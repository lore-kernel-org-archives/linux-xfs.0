Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q17KdGiu000331 for <xfs@oss.sgi.com>; Tue, 7 Feb 2012 14:39:16 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tWA4slaUjbGvbEF5 for
	<xfs@oss.sgi.com>; Tue, 07 Feb 2012 12:39:14 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 3/3] filemap: don't call generic_write_sync for
	-EIOCBQUEUED
References: <1327698949-12616-1-git-send-email-jmoyer@redhat.com>
	<1327698949-12616-4-git-send-email-jmoyer@redhat.com>
	<20120202175219.GB6640@quack.suse.cz>
	<x497gzzrkfa.fsf@segfault.boston.devel.redhat.com>
	<20120206195546.GA22640@infradead.org>
Date: Tue, 07 Feb 2012 15:39:06 -0500
In-Reply-To: <20120206195546.GA22640@infradead.org> (Christoph Hellwig's
	message of "Mon, 6 Feb 2012 14:55:47 -0500")
Message-ID: <x49pqdqml91.fsf@segfault.boston.devel.redhat.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

Christoph Hellwig <hch@infradead.org> writes:

> On Mon, Feb 06, 2012 at 11:33:29AM -0500, Jeff Moyer wrote:
>> > code, right? Before that we'd drain the IO queue when cache flush is issued
>> > and thus effectively wait for IO completion...
>> 
>> Right, though hch seems to think even then the problem existed.
>
> I was wrong, using -o barrier it didn't.  That was however not something
> people using O_SYNC heavy production loads would do, they'd use disabled
> caches and nobarrier.
>
>> > Also I was thinking whether we couldn't implement the fix in VFS. Basically
>> > it would be the same like the fix for ext4. Like having a per-sb workqueue
>> > and queue work calling generic_write_sync() from end_io handler when the
>> > file is O_SYNC? That would solve the issue for all filesystems...
>> 
>> Well, that would require buy-in from the other file system developers.
>> What do the XFS folks think?
>
> I don't think using that code for XFS makes sene.  But just like
> generic_write_sync there's no reason it can't be added to generic code,
> just make sure only generic_file_aio_write/__generic_file_aio_write use
> it, but generic_file_buffered_write and generic_file_direct_write stay
> clear of it.

ext4_file_write (ext4's .aio_write routine) calls into
generic_file_aio_write.  So, I don't think we can generalize that this
routine means that the file system doesn't install its own endio
handler.  What's more, we'd have to pass an endio routine down the call
stack quite a ways.  In all, I think that would be an uglier solution to
the problem.  Did I miss something?

Cheers,
Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
