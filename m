Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2UEoekt115842 for <xfs@oss.sgi.com>; Fri, 30 Mar 2012 09:50:40 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DOADllPGwykc8nyT for
	<xfs@oss.sgi.com>; Fri, 30 Mar 2012 07:50:39 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 5/7] xfs: honor the O_SYNC flag for aysnchronous direct
	I/O requests
References: <1333058705-31512-1-git-send-email-jmoyer@redhat.com>
	<1333058705-31512-6-git-send-email-jmoyer@redhat.com>
	<20120329225743.GC18323@dastard>
Date: Fri, 30 Mar 2012 10:50:30 -0400
In-Reply-To: <20120329225743.GC18323@dastard> (Dave Chinner's message of "Fri,
	30 Mar 2012 09:57:43 +1100")
Message-ID: <x49y5qii1mx.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, linux-ext4@vger.kernel.org, jack@suse.cz, xfs@oss.sgi.com

Hi, Dave,

Thanks for the review!

> or better still, factor xfs_file_fsync() so that it calls a helper
> that doesn't wait for data IO completion, and call that helper here
> too. The semantics of fsync/fdatasync are too complex to have to
> implement and maintain in multiple locations....

I definitely agree with consolidating things.  However, there are four
blocking calls in xfs_file_fsync (filemap_write_and_wait_range,
xfs_blkdev_issue_flush, _xfs_log_force_lsn, and another call to
xfs_blkdev_issue_flush).  How would you propose to make that
non-blocking given that those steps have to happen in sequence?

Cheers,
Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
