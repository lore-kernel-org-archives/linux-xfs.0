Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3JF4ZM2079704 for <xfs@oss.sgi.com>; Thu, 19 Apr 2012 10:04:35 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WPCggApLdZdSGYdg for
	<xfs@oss.sgi.com>; Thu, 19 Apr 2012 08:04:33 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 5/7] xfs: honor the O_SYNC flag for aysnchronous direct
	I/O requests
References: <1333058705-31512-1-git-send-email-jmoyer@redhat.com>
	<1333058705-31512-6-git-send-email-jmoyer@redhat.com>
	<20120329225743.GC18323@dastard>
	<x49y5qii1mx.fsf@segfault.boston.devel.redhat.com>
	<x49d37tj2ji.fsf@segfault.boston.devel.redhat.com>
Date: Thu, 19 Apr 2012 11:04:22 -0400
In-Reply-To: <x49d37tj2ji.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Fri, 30 Mar 2012 15:45:37 -0400")
Message-ID: <x49obqng3ux.fsf@segfault.boston.devel.redhat.com>
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

Jeff Moyer <jmoyer@redhat.com> writes:

> Jeff Moyer <jmoyer@redhat.com> writes:
>
>> Hi, Dave,
>>
>> Thanks for the review!
>>
>>> or better still, factor xfs_file_fsync() so that it calls a helper
>>> that doesn't wait for data IO completion, and call that helper here
>>> too. The semantics of fsync/fdatasync are too complex to have to
>>> implement and maintain in multiple locations....
>>
>> I definitely agree with consolidating things.  However, there are four
>> blocking calls in xfs_file_fsync (filemap_write_and_wait_range,
>> xfs_blkdev_issue_flush, _xfs_log_force_lsn, and another call to
>> xfs_blkdev_issue_flush).  How would you propose to make that
>> non-blocking given that those steps have to happen in sequence?
>
> OK, so re-reading your mail, I think you meant to just factor out
> everything except the filemap_write_and_wait_range.  Here are a couple
> of patches which do that.  Also, since we're not worried about blocking
> in the endio processing, just making things synchronous makes the code a
> lot simpler.  Let me know what you think of the attached two patches
> (which I've already run through xfstests).

Dave, ping?  Did you have a chance to take a look at these patches?

Cheers,
Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
