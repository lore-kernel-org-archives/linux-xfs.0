Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q16GXWk7148528 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 10:33:33 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fk4S9llaeWMzUmh7 for
	<xfs@oss.sgi.com>; Mon, 06 Feb 2012 08:33:31 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 3/3] filemap: don't call generic_write_sync for
	-EIOCBQUEUED
References: <1327698949-12616-1-git-send-email-jmoyer@redhat.com>
	<1327698949-12616-4-git-send-email-jmoyer@redhat.com>
	<20120202175219.GB6640@quack.suse.cz>
Date: Mon, 06 Feb 2012 11:33:29 -0500
In-Reply-To: <20120202175219.GB6640@quack.suse.cz> (Jan Kara's message of
	"Thu, 2 Feb 2012 18:52:19 +0100")
Message-ID: <x497gzzrkfa.fsf@segfault.boston.devel.redhat.com>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

Jan Kara <jack@suse.cz> writes:

>   Hello,
>
> On Fri 27-01-12 16:15:49, Jeff Moyer wrote:
>> As it stands, generic_file_aio_write will call into generic_write_sync
>> when -EIOCBQUEUED is returned from __generic_file_aio_write.  EIOCBQUEUED
>> indicates that an I/O was submitted but NOT completed.  Thus, we will
>> flush the disk cache, potentially before the write(s) even make it to
>> the disk!
>   Yeah. It seems to be a problem introduced by Tejun's rewrite of barrier
> code, right? Before that we'd drain the IO queue when cache flush is issued
> and thus effectively wait for IO completion...

Right, though hch seems to think even then the problem existed.

>>  Up until now, this has been the best we could do, as file
>> systems didn't bother to flush the disk cache after an O_SYNC AIO+DIO
>> write.  After applying the prior two patches to xfs and ext4, at least
>> the major two file systems do the right thing.  So, let's go ahead and
>> fix this backwards logic.
>   But doesn't this break filesystems which you didn't fix explicitely even
> more than they were? You are right they might have sent cache flush too
> early but they'd at least propely force all metadata modifications (e.g.
> from allocation) to disk. But after this patch O_SYNC will have simply no
> effect for these filesystems.

Yep.  Note that we're calling into generic_write_sync with a negative
value.  I followed that call chain all the way down and convinced myself
that it was "mostly harmless," but it sure as heck ain't right.  I'll
audit other file systems to see whether it's a problem.  btrfs, at
least, isn't affected by this.

> Also I was thinking whether we couldn't implement the fix in VFS. Basically
> it would be the same like the fix for ext4. Like having a per-sb workqueue
> and queue work calling generic_write_sync() from end_io handler when the
> file is O_SYNC? That would solve the issue for all filesystems...

Well, that would require buy-in from the other file system developers.
What do the XFS folks think?

Cheers,
Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
