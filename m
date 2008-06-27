Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Jun 2008 04:33:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5RBX6we027071
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 04:33:06 -0700
Received: from tyo202.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B8F6412CD7CD
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 04:34:06 -0700 (PDT)
Received: from tyo202.gate.nec.co.jp (TYO202.gate.nec.co.jp [202.32.8.206]) by cuda.sgi.com with ESMTP id w7Dd79eVRCPvxj1o for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 04:34:06 -0700 (PDT)
Message-Id: <7B349EFCD35842D4ADAEB402D2BDCA4E@nsl.ad.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
References: <20080624160056t-sato@mail.jp.nec.com> <20080624150925.765155f0.akpm@linux-foundation.org>
In-Reply-To: <20080624150925.765155f0.akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Fri, 27 Jun 2008 20:33:58 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, mtk.manpages@googlemail.com

Hi,

>> o Reset the timeout period
>>   int ioctl(int fd, int FIFREEZE_RESET_TIMEOUT, long *timeval)
>>     fd:file descriptor of mountpoint
>>     FIFREEZE_RESET_TIMEOUT: request code for reset of timeout period
>>     timeval: new timeout period in seconds
>>     Return value: 0 if the operation succeeds. Otherwise, -1
>>     Error number: If the filesystem has already been unfrozen,
>>                   errno is set to EINVAL.
>
> Please avoid the use of the term `timeval' here.  That term is closely
> associated with `struct timeval', and these are not being used here.  A
> better identifier would be timeout_secs - it tells the reader what it
> does, and it tells the reader what units it is in.  And when it comes
> to "time", it is very useful to tell people which units are being used,
> because there are many different ones.

OK.
I will use "timeout_secs" in the next version to match the source code.

>> -static int ioctl_freeze(struct file *filp)
>> +static int ioctl_freeze(struct file *filp, unsigned long arg)
>>  {
>> +    long timeout_sec;
>> +    long timeout_msec;
>>      struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
>> +    int error;
>>
>>      if (!capable(CAP_SYS_ADMIN))
>>          return -EPERM;
>> @@ -159,8 +163,27 @@ static int ioctl_freeze(struct file *fil
>>      if (sb->s_op->write_super_lockfs == NULL)
>>          return -EOPNOTSUPP;
>>
>> +    /* arg(sec) to tick value. */
>> +    error = get_user(timeout_sec, (long __user *) arg);>
> uh-oh, compat problems.
>
> A 32-bit application running under a 32-bit kernel will need to provide
> a 32-bit quantity.
>
> A 32-bit application running under a 64-bit kernel will need to provide
> a 64-bit quantity.
>
> I suggest that you go through the entire patch and redo this part of
> the kernel ABI in terms of __u32, and avoid any mention of "long" in
> the kernel<->userspace interface.

I agree.
I will replace long with a 32bit integer type.

>> +    /* arg(sec) to tick value. */
>> +    error = get_user(timeout_sec, (long __user *) arg);
>> +    if (timeout_sec < 0)
>> +        return -EINVAL;
>> +    else if (timeout_sec < 2)
>> +        timeout_sec = 0;> The `else' is unneeded.
>
> It would be clearer to code this all as:
>
> if (timeout_sec < 0)
>     return -EINVAL;
>
> if (timeout_sec == 1) {
>     /*
>      * If 1 is specified as the timeout period it is changed into 0
>      * to retain compatibility with XFS's xfs_freeze.
>      */
>     timeout_sec = 0;
> }

OK.

>> +    if (error)
>> +        return error;
>> +    timeout_msec = timeout_sec * 1000;
>> +    if (timeout_msec < 0)
>> +        return -EINVAL;
>
> um, OK, but timeout_msec could have overflowed during the
> multiplication and could be complete garbage.  I guess it doesn't
> matter much, but a cleaner approach might be:
>
> if (timeout_sec > LONG_MAX/1000)
>     return -EINVAL;
>
> or something like that.

OK.

> But otoh, why do the multiplication at all?  If we're able to handle
> the timeout down to the millisecond level, why not offer that
> resolution to userspace?  Offer the increased time granularity to the
> application?

I think there is no case the user specifies it in millisecond,
so the second granularity is more comfortable.

>> +    if (sb) {
>
> Can this happen?

I have found that sb == NULL never happen
but sb->s_bdev == NULL can happen when we call this ioctl
for a device file (not a directory or a regular file).
So I will add the following check.
if (sb->s_bdev == NULL)
    return -EINVAL;

>> +    if (test_and_set_bit(BD_FREEZE_OP, &sb->s_bdev->bd_state))
>> +        return -EBUSY;
>> +    if (sb->s_frozen == SB_UNFROZEN) {
>> +        clear_bit(BD_FREEZE_OP, &sb->s_bdev->bd_state);
>> +        return -EINVAL;
>> +    }
>> +    /* setup unfreeze timer */
>> +    if (timeout_msec > 0)
>
> What does this test do?  afacit it's special-casing the timeout_secs==0
> case.  Was this feature documented?  What does it do?

There is no special case of timeout_secs==0.
I will remove this check.

>> +void add_freeze_timeout(struct block_device *bdev, long timeout_msec)
>> +{
>> +    s64 timeout_jiffies = msecs_to_jiffies(timeout_msec);
>> +
>> +    /* Set delayed work queue */
>> +    cancel_delayed_work(&bdev->bd_freeze_timeout);
>
> Should this have used cancel_delayed_work_sync()?

Exactly.
I will replace cancel_delayed_work with cancel_delayed_work_sync.

>> +void del_freeze_timeout(struct block_device *bdev)
>> +{
>> + if (delayed_work_pending(&bdev->bd_freeze_timeout))
>
> Is this test needed?

It's not necessary because cancel_delayed_work_sync checks it itself.
I will remove it.

>> --- linux-2.6.26-rc7-xfs/fs/xfs/xfs_fsops.c 2008-06-23 11:55:15.000000000 +0900
>> +++ linux-2.6.26-rc7-timeout/fs/xfs/xfs_fsops.c 2008-06-23 11:56:47.000000000 +0900
>> @@ -619,7 +619,7 @@ xfs_fs_goingdown(
>>  {
>>  switch (inflags) {
>>  case XFS_FSOP_GOING_FLAGS_DEFAULT: {
>> - struct super_block *sb = freeze_bdev(mp->m_super->s_bdev);
>> + struct super_block *sb = freeze_bdev(mp->m_super->s_bdev, 0);
>
> Using NULL here is clearer and will, I expect, avoid a sparse warning.

I checked it but I couldn't find a sparse warning in xfs_fsops.c.
Can you tell me how to use NULL?

Cheers, Takashi
