Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2FGVneg064566 for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 11:31:49 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C61F24AA09
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 09:33:25 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id FEm0LVIWUuqlIG0n for
	<xfs@oss.sgi.com>; Mon, 15 Mar 2010 09:33:25 -0700 (PDT)
Date: Mon, 15 Mar 2010 12:33:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] Delayed logging
Message-ID: <20100315163324.GA26379@infradead.org>
References: <20100315043000.GK4732@dastard>
	<20100315160154.GA10406@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100315160154.GA10406@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Mar 15, 2010 at 12:01:54PM -0400, Christoph Hellwig wrote:
> Running the series on my KVM testbox trips out this assert in
> xfstests 013, which suggests we might be calling iput one too
> much somewhere (e.g. IOP_UNLOCK)):
> 
> [  132.174780] Assertion failed: atomic_read(&VFS_I(dp)->i_count) > 0, file: fs/xfs/xfs_vnodeops.c, line: 1430

Turns out this was due to the fsync clustering patch, which adds inodes
to a transaction without first grabbing a reference to them.
Unofrtunately grabbing the reference is not a easy as it sounds, as
inodes in the cluster might be on the unused list or even not have
valid VFS state anymore, so we can't simply call IHOLD here.  I've
reverted the patch in my local tree for now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
