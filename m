Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:42152 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750722AbeELEPg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 12 May 2018 00:15:36 -0400
MIME-Version: 1.0
In-Reply-To: <20180512000634.GG9510@magnolia>
References: <20180511192651.21324-1-mfasheh@suse.de> <20180511192651.21324-3-mfasheh@suse.de>
 <20180512000634.GG9510@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 12 May 2018 07:15:35 +0300
Message-ID: <CAOQ4uxiR+_Vzy-XWm6tfgF16h_ksxMR4hBBqnCvQUwHy0xn+7Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] vfs: dedupe should return EPERM if permission is not granted
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Sat, May 12, 2018 at 3:06 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Fri, May 11, 2018 at 12:26:51PM -0700, Mark Fasheh wrote:
>> Right now we return EINVAL if a process does not have permission to dedupe a
>> file. This was an oversight on my part. EPERM gives a true description of
>> the nature of our error, and EINVAL is already used for the case that the
>> filesystem does not support dedupe.
>>
>> Signed-off-by: Mark Fasheh <mfasheh@suse.de>
>> ---
>>  fs/read_write.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/read_write.c b/fs/read_write.c
>> index 77986a2e2a3b..8edef43a182c 100644
>> --- a/fs/read_write.c
>> +++ b/fs/read_write.c
>> @@ -2038,7 +2038,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
>>                       info->status = -EINVAL;
>>               } else if (!(is_admin || (dst_file->f_mode & FMODE_WRITE) ||
>>                            uid_eq(current_fsuid(), dst->i_uid))) {
>> -                     info->status = -EINVAL;
>> +                     info->status = -EPERM;
>
> Hmm, are we allowed to change this aspect of the kabi after the fact?
>
> Granted, we're only trading one error code for another, but will the
> existing users of this care?  xfs_io won't and I assume duperemove won't
> either, but what about bees? :)
>

Relaxing -EINVAL is the common case with kabi.
Every new flag we add support for does that and is it also common
that a new flag we support is restricted for certain capabilities so
EINVAL is replaced with EPERM.
BTW, man page doesn't say anything about the is_admin case.

IMO EPERM makes perfect sense here and btw, we also return
EPERM from overlayfs if dst is on lower layer.

Mark,

Please be aware that these changes conflict with Miklos' dedupe-cleanup
patches, so I suggest you collaborate on that
https://marc.info/?l=linux-fsdevel&m=152568128031031&w=2

Thanks,
Amir.
