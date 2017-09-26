Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:45192 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964997AbdIZIfs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2017 04:35:48 -0400
MIME-Version: 1.0
In-Reply-To: <20170926042421.GP10955@dastard>
References: <CAOQ4uxixLMRU2YT-3csTr_684vNUZ=2CazKKD-ojO68fC4f6tA@mail.gmail.com>
 <20170926042421.GP10955@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 26 Sep 2017 11:35:46 +0300
Message-ID: <CAOQ4uxhybgUmfk_voNxgx+NVT2JabKdcgtmKxSSGRF5LS+_C+g@mail.gmail.com>
Subject: Re: false positive lockdep splat with loop device
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Byungchul Park <byungchul.park@lge.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>

On Tue, Sep 26, 2017 at 7:24 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Sep 21, 2017 at 09:43:41AM +0300, Amir Goldstein wrote:
>> On Thu, Sep 21, 2017 at 1:22 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > [cc lkml, PeterZ and Byungchul]
>> ...
>> > The thing is, this IO completion has nothing to do with the lower
>> > filesystem - it's the IO completion for the filesystem on the loop
>> > device (the upper filesystem) and is not in any way related to the
>> > IO completion from the dax device the lower filesystem is waiting
>> > on.
>> >
>> > IOWs, this is a false positive.
>> >
>> > Peter, this is the sort of false positive I mentioned were likely to
>> > occur without some serious work to annotate the IO stack to prevent
>> > them.  We can nest multiple layers of IO completions and locking in
>> > the IO stack via things like loop and RAID devices.  They can be
>> > nested to arbitrary depths, too (e.g. loop on fs on loop on fs on
>> > dm-raid on n * (loop on fs) on bdev) so this new completion lockdep
>> > checking is going to be a source of false positives until there is
>> > an effective (and simple!) way of providing context based completion
>> > annotations to avoid them...
>> >
>>
>> IMO, the way to handle this is to add 'nesting_depth' information
>> on blockdev (or bdi?). 'nesting' in the sense of blockdev->fs->blockdev->fs.
>> AFAIK, the only blockdev drivers that need to bump nesting_depth
>> are loop and nbd??
>
> You're assumming that this sort of "completion inversion" can only
> happen with bdev->fs->bdev, and that submit_bio_wait() is the only
> place where completions are used in stackable block devices.
>
> AFAICT, this could happen on with any block device that can be
> stacked multiple times that uses completions. e.g. MD has a function
> sync_page_io() that calls submit_bio_wait(), and that is called from
> places in the raid 5, raid 10, raid 1 and bitmap layers (plus others
> in DM). These can get stacked anywhere - even on top of loop devices
> - and so I think the issue has a much wider scope than just loop and
> nbd devices.

True. We can probably duplicate the struct file_system_type pattern,
something like:

struct block_device_type = loop_blkdev_type = {
        .owner          = THIS_MODULE,
        .name           = "loop",
        .devt             = MKDEV(LOOP_MAJOR, 0),
        .probe           = loop_probe,
        .lock              = NULL,
};

...
blk_register_region(&loop_blkdev_type, range, NULL);

And then we have a static place holder for lock_class_key address
to be used when annotating bio completions.
I realize same block device types can be nested via raid/dm/loop,
but as we can see in the splat so do same file system types via loop/nbd,
so we can think of similar solution to both cases.

>
>> Not sure if the kernel should limit loop blockdev nesting depth??
>
> There's no way we should do that just because new lockdep
> functionality is unable to express such constructs.
>

Of course not. I was just wondering if there should be a limit to
blockdev nesting regardless (e.g. too much queuing in the io stack).

But even if there is no limit to blockdev nesting, we can define
CONFIG_LOCKDEP_MAX_NESTING and:

struct lock_class_nested_key {
        struct lock_class_key     keys[CONFIG_LOCKDEP_MAX_NESTING];
};

Then struct file_system_type and struct block_device_type keys
could be of type struct lock_class_nested_key.

nested_depth should be carried in struct gendisk and the it is the
responsibility of  the blockdev driver to bump nested_depth if it
is a nested blockdev.

Callers of lockdep_set_class() ,like lockdep_annotate_inode_mutex_key()
should use a variant lockdep_set_class_nested(lock, ket, nested_depth)
if appropriate.

For any depth greater than CONFIG_LOCKDEP_MAX_NESTING,
lockdep_set_class_nested() will overload the last key in the
array, so we don't solve false positives for infinite nesting depth,
but we solve them for a defined max nesting depth.

Alas, even if this is workable, it will not be anytime soon that I can
backup this scribble with tested patches.

Amir.
