Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34443 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751786AbcIIHb4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Sep 2016 03:31:56 -0400
MIME-Version: 1.0
In-Reply-To: <20160908202511.GV30056@dastard>
References: <1473348594-31425-1-git-send-email-amir73il@gmail.com> <20160908202511.GV30056@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 9 Sep 2016 10:31:02 +0300
Message-ID: <CAOQ4uxigN71Evm_mhFzijtDaXAvKQqstryvNoBEL7=Uwgt5xFg@mail.gmail.com>
Subject: Re: [PATCH] ovl: use copy_file_range for copy up if possible
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Sep 8, 2016 at 11:25 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Sep 08, 2016 at 06:29:54PM +0300, Amir Goldstein wrote:
>> When copying up within the same fs, try to use f_op->copy_file_range().
>> This becomes very efficient when lower and upper are on the same fs
>> with file reflink support.
>>
>> Tested correct behavior when lower and upper are on:
>> 1. same ext4 (copy)
>> 2. same xfs + reflink patches + mkfs.xfs (copy)
>> 3. same xfs + reflink patches + mkfs.xfs -m reflink=1 (clone)
>> 4. different xfs + reflink patches + mkfs.xfs -m reflink=1 (copy)
>>
>> Verified that all the overlay xfstests pass in the 'same xfs+reflink'
>> setup.
>>
>> For comparison, on my laptop, xfstest overlay/001 (copy up of large
>> sparse files) takes less than 1 second in the xfs reflink setup vs.
>> 25 seconds on the rest of the setups.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  fs/overlayfs/copy_up.c | 28 +++++++++++++++++++++++++---
>>  1 file changed, 25 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
>> index 43fdc27..400567b 100644
>> --- a/fs/overlayfs/copy_up.c
>> +++ b/fs/overlayfs/copy_up.c
>> @@ -121,6 +121,7 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
>>       struct file *new_file;
>>       loff_t old_pos = 0;
>>       loff_t new_pos = 0;
>> +     int try_copy_file = 0;
>>       int error = 0;
>>
>>       if (len == 0)
>> @@ -136,6 +137,13 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
>>               goto out_fput;
>>       }
>>
>> +     /*
>> +      * When copying up within the same fs, try to use fs's copy_file_range
>> +      */
>> +     if (file_inode(old_file)->i_sb == file_inode(new_file)->i_sb) {
>> +             try_copy_file = (new_file->f_op->copy_file_range != NULL);
>> +     }
>
> You don't need this. .copy_file_range() should return -EXDEV when
> you try to use it to copy files across different mount points or
> superblocks.
>

Right.

> i.e. you should probably be calling vfs_copy_file_range() here to do
> the copy up, and if that fails (for whatever reason) then fall back
> to the existing data copying code.
>

Yes, I considered that. With this V0 patch, copy_file_range() is
called inside the copy data 'killable loop'
but, unlike the slower splice, it tries to copy the entire remaining
len on every cycle and will most likely get all or nothing without
causing any major stalls.
So my options for V1 are:
1. use the existing loop only fallback to splice on any
copy_file_range() failure.
2. add another (non killable?) loop before the splice killable loop to
try and copy up as much data with copy_file_range()
3. implement ovl_copy_up_file_range() and do the fallback near the
call site of ovl_copy_up_data()

Miklos, so you have any preference?

Cheers,
Amir.
