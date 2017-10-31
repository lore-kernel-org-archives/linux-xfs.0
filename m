Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42504 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750928AbdJaXMc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Oct 2017 19:12:32 -0400
Subject: Re: [PATCH] xfs_repair: clear extra file attributes on symlinks
References: <20171031215156.12544-1-mcgrof@kernel.org>
 <20171031221253.GV4911@magnolia>
 <CAB=NE6WusGvGYVBokMOup9snofncCm9gXopM7BaUukp9N3zbRQ@mail.gmail.com>
 <20171031224320.GB4911@magnolia> <20171031231022.GD22894@wotan.suse.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <659d0936-f2a0-5604-b72c-6b3ded3da4f7@sandeen.net>
Date: Tue, 31 Oct 2017 18:12:30 -0500
MIME-Version: 1.0
In-Reply-To: <20171031231022.GD22894@wotan.suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: David Howells <dhowells@redhat.com>, xfs <linux-xfs@vger.kernel.org>, Tso Ted <tytso@mit.edu>, Nikolay Borisov <nborisov@suse.com>, Flex Liu <fliu@suse.com>, Jake Norris <jake.norris@suse.com>, Jan Kara <jack@suse.cz>



On 10/31/17 6:10 PM, Luis R. Rodriguez wrote:
> On Tue, Oct 31, 2017 at 03:43:20PM -0700, Darrick J. Wong wrote:
>> On Tue, Oct 31, 2017 at 03:19:00PM -0700, Luis R. Rodriguez wrote:
>>> On Tue, Oct 31, 2017 at 3:12 PM, Darrick J. Wong
>>> <darrick.wong@oracle.com> wrote:
>>>> On Tue, Oct 31, 2017 at 02:51:56PM -0700, Luis R. Rodriguez wrote:
>>>>> diff --git a/repair/dinode.c b/repair/dinode.c
>>>>> index 15ba8cc22b39..6288e42de15e 100644
>>>>> --- a/repair/dinode.c
>>>>> +++ b/repair/dinode.c
>>>>> @@ -2482,6 +2482,27 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
>>>>>                                               FS_XFLAG_EXTSIZE);
>>>>>                       }
>>>>>               }
>>>>> +             if (flags & (XFS_DIFLAG_IMMUTABLE | XFS_DIFLAG_APPEND |
>>>>> +                          XFS_DIFLAG_NODUMP)) {
>>>>> +                     /*
>>>>> +                      * ioctl(fd, *) and so ioctl(fd, FS_IOC_SETFLAGS)
>>>>> +                      * yields EBADF on symlinks as they have O_PATH set.
>>>>> +                      * "Extra file attributes", stx_attributes, as per
>>>>> +                      * statx(2) cannot be set on symlinks on Linux.
>>>>> +                      */
>>>>> +                     if (di_mode && S_ISLNK(di_mode) &&
>>>>> +                         !S_ISREG(di_mode) && !S_ISDIR(di_mode)) {
>>>>
>>>> Does this DIFLAG clearing applies to bdev/cdev/fifo/socket files too?
>>>
>>> Not at the moment given the semantics I hunted down and tested for
>>> were for O_PATH only.  The validation I hunted down applies to any
>>> file descriptors which we open via O_PATH only.
>>
>> iirc when you open one of those special files you end up with a fd that
>> points to an inode on a special bdevfs/pipefs/etc., not an inode linked
>> to the underlying filesystem containing the special file.
> 
> That seems to fit the O_PATH intent, however its unclear if O_PATH was needed,
> as per my testing on /dev/loop0 I don't need O_PATH set for it.
> 
>> Therefore you shouldn't be able to set any DIFLAG/DIFLAG2 flags on special files.
> 
> That would be great if we can verify.
> 
>> # mknod block b 8 0 ; mknod char c 1 3 ; mknod fifo p
>> # lsattr block char fifo
>> lsattr: Operation not supported While reading flags on block
>> lsattr: Operation not supported While reading flags on char
>> lsattr: Operation not supported While reading flags on fifo
> 
> I'm afraid e2fsprogs has a special check for these, ie, userspace is barred
> from actually toying with special files purposely because of the Debian bug I
> named.
> 
> strace should reveal the respective ioctl() was not actually issued.

That's very easy to short-circuit in e2fsprogs if you'd like to test what
the kernel does today.

-Eric
