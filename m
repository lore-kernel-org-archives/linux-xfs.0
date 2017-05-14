Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:33868 "EHLO
        mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751934AbdENN4c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 May 2017 09:56:32 -0400
Received: by mail-ua0-f175.google.com with SMTP id g49so66612989uaa.1
        for <linux-xfs@vger.kernel.org>; Sun, 14 May 2017 06:56:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <38F56772-7836-4902-929C-80908BFBEA7B@dilger.ca>
References: <CAG48ez1AWewJRg8gySgihn0y15jRhC6C+5DNwGsDpAhtokB=Lw@mail.gmail.com>
 <20170508184112.GJ5973@birch.djwong.org> <CAG48ez3e+2VuvjtEfJuMujEo6PWBO3z8oM-otN2juq96jKdjCw@mail.gmail.com>
 <20170508204738.GL5973@birch.djwong.org> <CAG48ez0iLRazKvXty9CG8ENXvkG6b1xjO0Q75p+16HKNptFnow@mail.gmail.com>
 <20170509015324.GM5973@birch.djwong.org> <20170509211746.GA87747@gmail.com>
 <20170510163818.7bleiykxgnx3pkds@thunk.org> <87mvakpl5m.fsf@xmission.com>
 <20170510201437.GA9854@birch.djwong.org> <20170511051051.GA7533@zzz> <38F56772-7836-4902-929C-80908BFBEA7B@dilger.ca>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 14 May 2017 06:56:10 -0700
Message-ID: <CALCETrX0=w8tDQbAysZH3AHvvaGvPb54Jj7=Eiuk0uoB+fRfzQ@mail.gmail.com>
Subject: Re: [PATCH] ioctl_getfsmap.2: document the GETFSMAP ioctl
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Dilger <adilger@dilger.ca>
Cc: Eric Biggers <ebiggers3@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Theodore Ts'o <tytso@mit.edu>, Jann Horn <jannh@google.com>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, linux-xfs@vger.kernel.org, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

On Sat, May 13, 2017 at 6:41 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> On May 10, 2017, at 11:10 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
>>
>> On Wed, May 10, 2017 at 01:14:37PM -0700, Darrick J. Wong wrote:
>>> [cc btrfs, since afaict that's where most of the dedupe tool authors hang out]

>> Yes, PIDs have traditionally been global, but today we have PID namespaces, and
>> many other isolation features such as mount namespaces.  Nothing is perfect, of
>> course, and containers are a lot worse than VMs, but it seems weird to use that
>> as an excuse to knowingly make things worse...
>>

Indeed.  Not only PID namespaces -- we have hidepid and we can simply
unmount /proc.  "There are other info leaks" is a poor excuse.

>>>
>>>>> Fortunately, the days of timesharing seem to well behind us.  For
>>>>> those people who think that containers are as secure as VM's (hah,
>>>>> hah, hah), it might be that best way to handle this is to have a mount
>>>>> option that requires root access to this functionality.  For those
>>>>> people who really care about this, they can disable access.
>>>
>>> Or use separate filesystems for each container so that exploitable bugs
>>> that shut down the filesystem can't be used to kill the other
>>> containers.  You could use a torrent of metadata-heavy operations
>>> (fallocate a huge file, punch every block, truncate file, repeat) to DoS
>>> the other containers.
>>>
>>>> What would be the reason for not putting this behind
>>>> capable(CAP_SYS_ADMIN)?
>>>>
>>>> What possible legitimate function could this functionality serve to
>>>> users who don't own your filesystem?
>>>
>>> As I've said before, it's to enable dedupe tools to decide, given a set
>>> of files with shareable blocks, roughly how many other times each of
>>> those shareable blocks are shared so that they can make better decisions
>>> about which file keeps its shareable blocks, and which file gets
>>> remapped.  Dedupe is not a privileged operation, nor are any of the
>>> tools.
>>>
>>
>> So why does the ioctl need to return all extent mappings for the entire
>> filesystem, instead of just the share count of each block in the file that the
>> ioctl is called on?
>
> One possibility is that the ioctl() can return the mapping for all inodes
> owned by the calling PID (or others if CAP_SYS_ADMIN, CAP_DAC_OVERRIDE,
> or CAP_FOWNER is set), and return an "filesystem aggregate inode" (or more
> than one if there is a reason to do so) with all the other allocated blocks
> for inodes the user doesn't have permission to access?

Sounds like it could be reasonable.  But you don't want "owned by the
calling PID" precisely -- you also need to check
kgid_has_mapping(current_user_ns(), inode->i_gid), I think.
