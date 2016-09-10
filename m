Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:35893 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751219AbcIJSzC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Sep 2016 14:55:02 -0400
MIME-Version: 1.0
In-Reply-To: <20160909235221.GH30056@dastard>
References: <1473348594-31425-1-git-send-email-amir73il@gmail.com>
 <20160908202511.GV30056@dastard> <CAOQ4uxigN71Evm_mhFzijtDaXAvKQqstryvNoBEL7=Uwgt5xFg@mail.gmail.com>
 <20160909075439.GE30056@dastard> <CAOQ4uxguEpSeq5A==gGCcVocY=5xSO+cEcUNr2GDYAbjvx4+Dw@mail.gmail.com>
 <20160909235221.GH30056@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 10 Sep 2016 21:54:59 +0300
Message-ID: <CAOQ4uxhzigks7Jyx_SdBTFq8S3CpoTcXbgAFS79OiHXj42EjYg@mail.gmail.com>
Subject: Re: [PATCH] ovl: use copy_file_range for copy up if possible
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On Sat, Sep 10, 2016 at 2:52 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Sep 09, 2016 at 11:27:34AM +0300, Amir Goldstein wrote:
>> On Fri, Sep 9, 2016 at 10:54 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Fri, Sep 09, 2016 at 10:31:02AM +0300, Amir Goldstein wrote:
>> >> On Thu, Sep 8, 2016 at 11:25 PM, Dave Chinner <david@fromorbit.com> wrote:
>> >> > On Thu, Sep 08, 2016 at 06:29:54PM +0300, Amir Goldstein wrote:
>> >> Yes, I considered that. With this V0 patch, copy_file_range() is
>> >> called inside the copy data 'killable loop'
>> >> but, unlike the slower splice, it tries to copy the entire remaining
>> >> len on every cycle and will most likely get all or nothing without
>> >> causing any major stalls.
>> >> So my options for V1 are:
>> >> 1. use the existing loop only fallback to splice on any
>> >> copy_file_range() failure.
>> >> 2. add another (non killable?) loop before the splice killable loop to
>> >> try and copy up as much data with copy_file_range()
>> >> 3. implement ovl_copy_up_file_range() and do the fallback near the
>> >> call site of ovl_copy_up_data()
>> >
>> > vfs_copy_file_range() already has a fallback to call
>> > do_splice_direct() itself if ->copy_file_range() is not supported.
>> > i.e. it will behave identically to the existing code if
>> > copy_file_range is not supported by the underlying fs.
>> >
>>
>> I though so initially, but existing code is not identical to the
>> vfs_copy_file_range() implementation because ovl_copy_up_data()
>> splices in small chunks allowing the user to kill the copying process.
>> This makes sense because the poor process only called open(),
>> so the app writer may not have been expecting a stall of copying
>> a large file...
>
> So call vfs_copy_file_range() iteratively, just like is being done
> right now for do_splice_direct() to limit latency on kill.
>
>> > If copy_file_range() fails, then it's for a reason that will cause
>> > do_splice_direct() to fail as well.
>> >
>> > vfs_copy_file_range() should really be a direct replacement for any
>> > code that calls do_splice_direct(). If it's not, we should make it
>> > so (e.g call do_splice direct for cross-fs copies automatically
>> > rather than returning EXDEV)
>>
>> But man page states that EXDEV will be returned if
>>      "The files referred to by file_in and file_out are not on the
>>       same mounted filesystem"
>
> That's the /syscall/ man page, not how we must implement the
> internal helper. Did you even /look/ at vfs_copy_file_range()?
> hint:
>
>         /* this could be relaxed once a method supports cross-fs copies */
>         if (inode_in->i_sb != inode_out->i_sb)
>                 return -EXDEV;
>
>
>>
>> I guess that when API is updated to allow for non zero flags,
>> then vfs_copy_file_range() should do_splice() instead or returning
>> EXDEV, only if (flags == COPY_FR_COPY).
>
> Not necessary - just hoist the EXDEV check to the syscall layer.
> Then, as I've already said, make vfs_copy_file_range "call do_splice
> direct for cross-fs copies automatically".
>
> i.e. vfs_copy_file_range() should just copy the data in the most
> efficient way possible for the given src/dst inode pair.  In future,
> if we add capability for offload of cross-fs copies, we can add the
> infrastructure to do that within vfs_copy_file_range() and not have
> to change a single caller to take advantage of it....
>
>> > and then replace all the calls in the
>> > kernel to do_splice_direct() with vfs_copy_file_range()....
>>
>> So in this case, I could not have replaced do_splice_direct() with
>> vfs_copy_file_range(), because I would either break the killable loop
>> behavior, or call copy_file_range() in small chunks which is not
>> desirable - is it?
>
> Of course you can call vfs_copy_file_range() in small chunks. It's
> just not going to be as efficient as a single large copy offload.
> Worst case, it ends up being identical to what ovl is doing now.
>
> But the question here is this: why are you even trying to /copy/ the
> data?  That's not guaranteed to do a fast, atomic,
> zero-data-movement operation. i.e. what we really want here first is
> an attempt to /clone/ the data:
>
>         1. try a fast, atomic, metadata clone operation like reflink
>         2. try a fast, optimised data copy
>         3. if all else fails, use do_splice_direct() to copy data.
>
> i.e first try vfs_clone_file_range() because:
>
> http://oss.sgi.com/archives/xfs/2015-12/msg00356.html
>
>         [...] Note that clones are different from
>         file copies in several ways:
>
>          - they are atomic vs other writers
>          - they support whole file clones
>          - they support 64-bit legth clones
>          - they do not allow partial success (aka short writes)
>          - clones are expected to be a fast metadata operation
>

I admit I missed this Note. perhaps it would be good to keep it in comment next
to the copy/clone_range helpers.

> i.e. if you want to use reflink type methods to optimise copy-up
> latency, then you need to be /cloning/ the file, not copying it.

That's a good advise and I will definitely follow it.
I shall call clone_file_range once above the splice loop.

> You can test whether this is supported at mount time, so you do a
> simply flag test at copyup to determine if a clone should be
> attempted or not.
>

I am not sure that would not be over optimization.
I am already checking for the obvious reason for clone to fail in copyup -
different i_sb.
After all, if I just call clone_file_range() once and it fails, then we are back
to copying and that is going to make the cost of calling clone insignificant.

> If cloning fails or is not supported, then try vfs_copy_file_range()
> to do an optimised iterative partial range file copy.  Finally, try
> a slow, iterative partial range file copies using
> do_splice_direct(). This part can be wholly handled by
> vfs_copy_file_range() - this 'not supported' fallback doesn't need
> to be implemented every time someone wants to copy data between two
> files...

You do realize that vfs_copy_file_range() itself does the 'not
supported' fallback
and if I do call it iteratively, then there will be a lot more 'not
supported' attempts
then there are in my current patch.
But regardless, as I wrote to Christoph, changing the
vfs_copy_file_range() helper
and changing users of do_splice to use it like you suggested sounds
like it may be the right thing to do, but without consensus, I am a bit hesitant
to make those changes. I am definitely willing to draft the patch and test it
if I get more ACKs on the idea.

Beyond the question of whether or not to change vfs_copy_file_range(),
there is the pragmatic question of which workload is going to benefit from
this in the copyup case.

My patch sets out to improve a very clear and immediate problem for
overlayfs over xfs setup (lower and upper on the same fs).
It is not a hypothetical case, it is a very common case for docker.
Further more, when docker users realize they have this improvement,
it will provide a very good incentive for users (and container distros) to
test and deploy overlayfs over xfs with reflink support.
So it would be a great service to the docker community if xfs reflink support
would be out with v4.9 (hint hint).

The copy_file_range() before do_splice() step, OTOH, may be useful
for overlayfs over nfs (lower and upper on the same fs) and I don't know
that is an interesting use case. anyone?

Thanks for the good review comments
Will work on V1 tomorrow.

Cheers,
Amir.
