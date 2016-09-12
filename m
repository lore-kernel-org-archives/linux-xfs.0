Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:37846 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754396AbcILGxC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2016 02:53:02 -0400
MIME-Version: 1.0
In-Reply-To: <20160911221128.GK30056@dastard>
References: <1473348594-31425-1-git-send-email-amir73il@gmail.com>
 <20160908202511.GV30056@dastard> <CAOQ4uxigN71Evm_mhFzijtDaXAvKQqstryvNoBEL7=Uwgt5xFg@mail.gmail.com>
 <20160909075439.GE30056@dastard> <CAOQ4uxguEpSeq5A==gGCcVocY=5xSO+cEcUNr2GDYAbjvx4+Dw@mail.gmail.com>
 <20160909235221.GH30056@dastard> <CAOQ4uxhzigks7Jyx_SdBTFq8S3CpoTcXbgAFS79OiHXj42EjYg@mail.gmail.com>
 <20160911221128.GK30056@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 12 Sep 2016 09:52:59 +0300
Message-ID: <CAOQ4uxj6bF2AXiiVGiRc6VfXhF42CW805iQNZTb+e_-KOsBdzQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: use copy_file_range for copy up if possible
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On Mon, Sep 12, 2016 at 1:11 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Sat, Sep 10, 2016 at 09:54:59PM +0300, Amir Goldstein wrote:
>> On Sat, Sep 10, 2016 at 2:52 AM, Dave Chinner <david@fromorbit.com> wrote:
>>
>> > You can test whether this is supported at mount time, so you do a
>> > simply flag test at copyup to determine if a clone should be
>> > attempted or not.
>> >
>>
>> I am not sure that would not be over optimization.
>> I am already checking for the obvious reason for clone to fail in copyup -
>> different i_sb.
>
> Again, please don't do that.  Call vfs_clone_file_range() as it
> checks a whole lot more stuff that can cause a clone to fail. And it
> makes sure that the write references to the mnt are taken so that
> things like freeze and remount-ro behave correctly while a clone is
> in progress.
>

OK

>> After all, if I just call clone_file_range() once and it fails, then we are back
>> to copying and that is going to make the cost of calling clone insignificant.
>
> Apart from the fact that the ->clone_file_range() calls assume that
> all the validity checks have already been done by the caller, which
> you are not doing.
>
>> > If cloning fails or is not supported, then try vfs_copy_file_range()
>> > to do an optimised iterative partial range file copy.  Finally, try
>> > a slow, iterative partial range file copies using
>> > do_splice_direct(). This part can be wholly handled by
>> > vfs_copy_file_range() - this 'not supported' fallback doesn't need
>> > to be implemented every time someone wants to copy data between two
>> > files...
>>
>> You do realize that vfs_copy_file_range() itself does the 'not
>> supported' fallback
>> and if I do call it iteratively, then there will be a lot more 'not
>> supported' attempts
>> then there are in my current patch.
>
> No shit, Sherlock. But you're concentrating on the wrong thing -
> the overhead of checking if .clone_file_range/.copy_file_range is
> implemented and can be executed is effectively zero compared to
> copying any amount of data.
>
> IOWs, Amir, you're trying to *optimise the wrong thing*. It's the
> data copy that is costly and needs to be optimised, not the
> iteration or the checks done to determine what type of clone/copy
> can be executed. Shortcuts around generic helpers like you are
> proposing are more costly in the long run because code like this is
> much more likely to contain/mask bugs that only appear months or
> years later when something else is changed. Case in point: the mnt
> write references that need to be taken before calling
> clone/copy_file_range()....
>
> Please, just use vfs_clone_file_range() and vfs_copy_file_range()
> and only fall back to a slower method if the error returned is
> -EOPNOTSUPP. For any other error, the copy should fail, not be
> ignored.
>

Obviously, you meant to check for -EOPNOTSUPP or -EXDEV

>> But regardless, as I wrote to Christoph, changing the
>> vfs_copy_file_range() helper
>> and changing users of do_splice to use it like you suggested sounds
>> like it may be the right thing to do, but without consensus, I am a bit hesitant
>> to make those changes. I am definitely willing to draft the patch and test it
>> if I get more ACKs on the idea.
>
> Send a patch - that's the only way you'll get anyone to comment
> on it.
>

Will do.

Thanks,
Amir.
