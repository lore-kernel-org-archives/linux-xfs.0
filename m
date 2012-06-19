Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5JHBtlg127936 for <xfs@oss.sgi.com>; Tue, 19 Jun 2012 12:11:55 -0500
Date: Tue, 19 Jun 2012 12:11:53 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/9] xfs: convert internal buffer functions to pass maps
Message-ID: <20120619171153.GD2676@sgi.com>
References: <1339133914-11148-1-git-send-email-david@fromorbit.com>
	<1339133914-11148-3-git-send-email-david@fromorbit.com>
	<20120618204325.GX4721@sgi.com> <20120618210713.GY4721@sgi.com>
	<20120619071552.GA23093@infradead.org>
	<20120619155946.GA2676@sgi.com>
	<20120619170304.GC7554@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120619170304.GC7554@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Hey Christoph,

On Tue, Jun 19, 2012 at 01:03:05PM -0400, Christoph Hellwig wrote:
> On Tue, Jun 19, 2012 at 10:59:46AM -0500, Ben Myers wrote:
> > How long before the inode allocator redo?  Maybe it would be best if Dave's
> > buffer cache changes are rebased not to depend upon the inode allocator
> > changes?
> 
> I'll need some time to get back to it.  I'd rather like to get the
> buffer changes in ASAP as a lot of work depends on them.

In that case I think we'll be able to get the buffer changes in more quickly if
they are rebased not to require the inode allocator patchset.  I think that Jan
is also going to repost his 'Fix overallocation in xfs_buf_allocate_memory()'
based upon Dave's suggestions.  It's best not to depend upon that either.  What
do you say, Dave?

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
