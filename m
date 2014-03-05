Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A182A7F3F
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 11:03:01 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8C582304043
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 09:02:58 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id hKku0Tw2KAJ9HCEl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 05 Mar 2014 09:02:57 -0800 (PST)
Date: Wed, 5 Mar 2014 09:02:56 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: fix use after free in inode_item_done()
Message-ID: <20140305170256.GB11667@infradead.org>
References: <5314E912.9080708@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5314E912.9080708@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Mar 03, 2014 at 02:41:54PM -0600, Eric Sandeen wrote:
> Commit "3a19fb7 libxfs: stop caching inode structures"
> introduced a use after free.

I see the use after free, but I don't see how I would have introduced it
in that commit.  Before that libxfs_iput already was freeing the inode
through the cache code, now we do it directly.

> @@ -739,12 +738,6 @@ ili_done:
>  	} else {
>  		libxfs_iput(ip, 0);
>  	}
> -
> -	if (ip->i_itemp)
> -		kmem_zone_free(xfs_ili_zone, ip->i_itemp);
> -	else
> -		ASSERT(0);
> -	ip->i_itemp = NULL;
>  }

Seems like inode_item_done should call into inode_item_unlock, which
factors the exact sequence we want into a nice helper.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
