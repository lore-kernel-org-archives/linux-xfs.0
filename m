Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2AFCB7F3F
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 11:19:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1144830406B
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 09:19:20 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id nBdp5c70ypYnayhE for <xfs@oss.sgi.com>;
	Wed, 05 Mar 2014 09:19:19 -0800 (PST)
Message-ID: <53175C97.2050408@sandeen.net>
Date: Wed, 05 Mar 2014 11:19:19 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: fix use after free in inode_item_done()
References: <5314E912.9080708@redhat.com>
	<20140305170256.GB11667@infradead.org>
In-Reply-To: <20140305170256.GB11667@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 3/5/14, 11:02 AM, Christoph Hellwig wrote:
> On Mon, Mar 03, 2014 at 02:41:54PM -0600, Eric Sandeen wrote:
>> Commit "3a19fb7 libxfs: stop caching inode structures"
>> introduced a use after free.
> 
> I see the use after free, but I don't see how I would have introduced it
> in that commit.  Before that libxfs_iput already was freeing the inode
> through the cache code, now we do it directly.

Ok, sorry if I wrongly implicated that commit.

>> @@ -739,12 +738,6 @@ ili_done:
>>  	} else {
>>  		libxfs_iput(ip, 0);
>>  	}
>> -
>> -	if (ip->i_itemp)
>> -		kmem_zone_free(xfs_ili_zone, ip->i_itemp);
>> -	else
>> -		ASSERT(0);
>> -	ip->i_itemp = NULL;
>>  }
> 
> Seems like inode_item_done should call into inode_item_unlock, which
> factors the exact sequence we want into a nice helper.

Yeah, that does seem better!   Thanks for spotting that.

The difference when calling inode_item_unlock is a bit more zeroing-out:

        ip->i_transp = NULL;

        iip->ili_flags = 0;

I'm not sure of the implications of that offhand, TBH.

Dave, hold off on my commit I guess ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
