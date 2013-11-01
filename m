Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1166F7F55
	for <xfs@oss.sgi.com>; Fri,  1 Nov 2013 08:03:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E3E9630406A
	for <xfs@oss.sgi.com>; Fri,  1 Nov 2013 06:03:17 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id blZ9Ft7zWCF8EfgK (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 01 Nov 2013 06:03:17 -0700 (PDT)
Date: Fri, 1 Nov 2013 06:03:16 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 25/30 V2] libxfs: fix root inode handling inconsistencies
Message-ID: <20131101130316.GB14898@infradead.org>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
	<1383107481-28937-26-git-send-email-david@fromorbit.com>
	<20131030102318.GA31519@infradead.org>
	<20131030215940.GH6188@dastard> <20131031041343.GK6188@dastard>
	<20131031150024.GP22359@infradead.org>
	<20131031220438.GP4446@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131031220438.GP4446@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Nov 01, 2013 at 09:04:38AM +1100, Dave Chinner wrote:
> > > -	if ((flags & LIBXFS_MOUNT_ROOTINOS) && sbp->sb_rootino != NULLFSINO &&
> > > +	if (sbp->sb_rootino != NULLFSINO &&
> > >  	    xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> > 
> > Oh, I hadn't noticed that LIBXFS_MOUNT_ROOTINOS does more than reading
> > the root inode.  Seems like mkfs might need the rt inodes if a file with
> > the rt flag is specified in the proto file.
> 
> mkfs always allocates the rt inodes directly after the root
> directory is created.

True, we obviosuly create them in mkfs.  In fact looking over the code
the only call into the rtalloc code in userspace ever is mkfs
initializing those using libxfs_rtfree_extent.

So removing the call to rtmount_inodes is fine, and we should remove
the declaration of it as well as it's now unused.  In the future I
suspect we should simplify the mkfs code to not even require
xfs_rtalloc.c for just marking the inodes as entirely free, but that's
not something for this series.

> > I can't see how xfs_copy could need either the rt inodes nor the perag
> > data.
> 
> Right, it doesn't need them, but it doesn't hurt at all to
> initialise them because all the ag headers are about to be read to
> find all the used space, anyway.

xfs_initialize_perag_data does the following:

 - read in AGI/AGF.  This is something we lazily do whenever we need it
   anyway, so no one should rely on it.
 - update the in-core superblock global counters.  Seems like the old
   xfs_check relies on this and still needs an equivalent if we care
   enough.  No one else seems to care.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
