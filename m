Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:38492 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751445AbdIRT31 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 15:29:27 -0400
MIME-Version: 1.0
In-Reply-To: <20170918183549.GA32669@kroah.com>
References: <1504100302-3297-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxi4Zf8WJQ6zotVF_K6BxuQJ9EsfGL4uY1TaBLMiLP-JHw@mail.gmail.com>
 <20170918171144.GD6540@magnolia> <CAOQ4uxjiB9PHxzdz5rHv8h+b-pC0BjPKf+zvLeETU7BPKeoNww@mail.gmail.com>
 <20170918183549.GA32669@kroah.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 18 Sep 2017 22:29:25 +0300
Message-ID: <CAOQ4uxjf+-iaJwmnt8r7d=tPWJr1BdbjU4PSSwk+Nbb340oEgg@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix incorrect log_flushed on fsync
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Greg KH <greg@kroah.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <jbacik@fb.com>, "stable [v4.9]" <stable@vger.kernel.org>

On Mon, Sep 18, 2017 at 9:35 PM, Greg KH <greg@kroah.com> wrote:
> On Mon, Sep 18, 2017 at 09:00:30PM +0300, Amir Goldstein wrote:
>> On Mon, Sep 18, 2017 at 8:11 PM, Darrick J. Wong
>> <darrick.wong@oracle.com> wrote:
>> > On Fri, Sep 15, 2017 at 03:40:24PM +0300, Amir Goldstein wrote:
>> >> On Wed, Aug 30, 2017 at 4:38 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> >> > When calling into _xfs_log_force{,_lsn}() with a pointer
>> >> > to log_flushed variable, log_flushed will be set to 1 if:
>> >> > 1. xlog_sync() is called to flush the active log buffer
>> >> > AND/OR
>> >> > 2. xlog_wait() is called to wait on a syncing log buffers
>> >> >
>> >> > xfs_file_fsync() checks the value of log_flushed after
>> >> > _xfs_log_force_lsn() call to optimize away an explicit
>> >> > PREFLUSH request to the data block device after writing
>> >> > out all the file's pages to disk.
>> >> >
>> >> > This optimization is incorrect in the following sequence of events:
>> >> >
>> >> >  Task A                    Task B
>> >> >  -------------------------------------------------------
>> >> >  xfs_file_fsync()
>> >> >    _xfs_log_force_lsn()
>> >> >      xlog_sync()
>> >> >         [submit PREFLUSH]
>> >> >                            xfs_file_fsync()
>> >> >                              file_write_and_wait_range()
>> >> >                                [submit WRITE X]
>> >> >                                [endio  WRITE X]
>> >> >                              _xfs_log_force_lsn()
>> >> >                                xlog_wait()
>> >> >         [endio  PREFLUSH]
>> >> >
>> >> > The write X is not guarantied to be on persistent storage
>> >> > when PREFLUSH request in completed, because write A was submitted
>> >> > after the PREFLUSH request, but xfs_file_fsync() of task A will
>> >> > be notified of log_flushed=1 and will skip explicit flush.
>> >> >
>> >> > If the system crashes after fsync of task A, write X may not be
>> >> > present on disk after reboot.
>> >> >
>> >> > This bug was discovered and demonstrated using Josef Bacik's
>> >> > dm-log-writes target, which can be used to record block io operations
>> >> > and then replay a subset of these operations onto the target device.
>> >> > The test goes something like this:
>> >> > - Use fsx to execute ops of a file and record ops on log device
>> >> > - Every now and then fsync the file, store md5 of file and mark
>> >> >   the location in the log
>> >> > - Then replay log onto device for each mark, mount fs and compare
>> >> >   md5 of file to stored value
>> >> >
>> >> > Cc: Christoph Hellwig <hch@lst.de>
>> >> > Cc: Josef Bacik <jbacik@fb.com>
>> >> > Cc: <stable@vger.kernel.org>
>> >> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> >> > ---
>> >> >
>> >> > Christoph, Dave,
>> >> >
>> >> > It's hard to believe, but I think the reported bug has been around
>> >> > since 2005 f538d4da8d52 ("[XFS] write barrier support"), but I did
>> >> > not try to test old kernels.
>> >>
>> >> Forgot to tag commit message with:
>> >> Fixes: f538d4da8d52 ("[XFS] write barrier support")
>> >>
>> >> Maybe the tag could be added when applying to recent stables,
>> >> so distros and older downstream stables can see the tag.
>> >>
>> >> The disclosure of the security bug fix (commit b31ff3cdf5) made me wonder
>> >> if possible data loss bug should also be disclosed in some distros forum?
>> >> I bet some users would care more about the latter than the former.
>> >> Coincidentally, both data loss and security bugs fix the same commit..
>> >
>> > Yes the the patch ought to get sent on to stable w/ fixes tag.  One
>> > would hope that the distros will pick up the stable fixes from there.
>>
>>
>> Greg, for your consideration, please add
>>  Fixes: f538d4da8d52 ("[XFS] write barrier support")
>> If not pushed yet.
>
> Add it to what?

Sorry, add that tag when applying commit 47c7d0b1950258312
to stable trees, since I missed adding the tag before it was merged
to master.

Thanks,
Amir.
