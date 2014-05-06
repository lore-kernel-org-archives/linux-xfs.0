Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4F40A7FD5
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 03:15:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D9432AC006
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 01:15:19 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id VKDKkfuemq15zpL0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 01:15:19 -0700 (PDT)
Date: Tue, 6 May 2014 01:15:18 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] xfs: turn NLINK feature on by default
Message-ID: <20140506081518.GB24143@infradead.org>
References: <1399348559-19889-1-git-send-email-david@fromorbit.com>
	<1399348559-19889-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1399348559-19889-4-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

>  
> @@ -1112,7 +1085,7 @@ xfs_bumplink(
>  		 * system to do this, then we need to bump the superblock
>  		 * version number as well.
>  		 */
> -		xfs_bump_ino_vers2(tp, ip);
> +		xfs_bump_ino_vers2(ip);

The comment here is certainly out of date now.

But I think keeping these xfs_bump_ino_vers2 calls around everywhere is
wrong to start with.  xfs_iread should make sure all inodes are version
1, that allows to kill xfs_bump_ino_vers2 entirely, and probably also
simplify xfs_ialloc a little more.  At the point we won't have to deal
with v1 inodes anywhere but in xfs_iread, and we can have a big fat
comment in that place why we even bother with the v1 inodes, because
the fact that we have the hasnlink bit but inodes might still be old
format is something we'll all have forgotten about in a few years,
and new developers will never figure out by themselves.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
