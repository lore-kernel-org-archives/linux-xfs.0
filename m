Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B98D67F83
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 20:00:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 985AE8F8052
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 18:00:59 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id dP8TOj1y2NspKSvB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Aug 2014 18:00:57 -0700 (PDT)
Date: Thu, 28 Aug 2014 18:00:56 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] xfs: combine xfs_dir_canenter into xfs_dir_createname
Message-ID: <20140829010056.GB26340@infradead.org>
References: <53F6942B.80808@redhat.com>
 <53F695C3.1020607@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53F695C3.1020607@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Aug 21, 2014 at 07:58:43PM -0500, Eric Sandeen wrote:
> xfs_dir_canenter and xfs_dir_createname are
> almost identical.
> 
> Fold the former into the latter, with a helpful
> wrapper for the former.  If createname is called without
> an inode number, it now only checks for space, and does
> not actually add the entry.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

The code changes looks good to me, but..

>  /*
> -  Enter a name in a directory.
> + * Enter a name in a directory.
> + * If inum is 0, only test for available space.
>   */
>  int
>  xfs_dir_createname(

Given how confusing the xfs_dir_createname function name is now this
probably needs a more detailed description mentioning the checking as
first class behavior.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
