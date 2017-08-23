Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57998 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752880AbdHWCUy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 Aug 2017 22:20:54 -0400
Subject: Re: XFS Bug Report
References: <CAFzqJcahyU7F5CJcYKTPabWBVCnufwSMS4QcJijHVVux-Ndv+Q@mail.gmail.com>
 <ad807068-5de9-3200-68ef-de9e42401a5a@sandeen.net>
 <20170822232831.GY21024@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b83a062c-f129-e6a5-6056-5f76f9006169@sandeen.net>
Date: Tue, 22 Aug 2017 21:20:53 -0500
MIME-Version: 1.0
In-Reply-To: <20170822232831.GY21024@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Ruoxin Jiang <rj2394@columbia.edu>, linux-xfs@vger.kernel.org, Suman Jana <sumanj@gmail.com>

On 8/22/17 6:28 PM, Dave Chinner wrote:
> On Tue, Aug 22, 2017 at 05:33:24PM -0500, Eric Sandeen wrote:

...

>> Case 3 seems to show xfs violating this rule, I guess?
>>
>>        When  the  owner or group of an executable file are changed by a
>>        non-superuser, the S_ISUID and S_ISGID mode  bits  are  cleared.
>>        POSIX does not specify whether this also should happen when root
>>        does the chown(); the Linux behavior depends on the kernel  ver-
>>        sion.   In  case  of  a non-group-executable file (i.e., one for
>>        which the S_IXGRP bit is not  set)  the  S_ISGID  bit  indicates
>>        mandatory locking, and is not cleared by a chown().
>>
>> I thought this was all handled at the vfs, though, odd.
> 
> xfs_setattr_nonsize() does:
> 
>                 /*
>                  * CAP_FSETID overrides the following restrictions:
>                  *
>                  * The set-user-ID and set-group-ID bits of a file will be
>                  * cleared upon successful return from chown()
>                  */
>                 if ((inode->i_mode & (S_ISUID|S_ISGID)) &&
>                     !capable(CAP_FSETID))
>                         inode->i_mode &= ~(S_ISUID|S_ISGID);
> 
> Whereas the VFS has this check in should_remove_suid():
> 
>         /*
>          * sgid without any exec bits is just a mandatory locking mark; leave
>          * it alone.  If some exec bits are set, it's a real sgid; kill it.
>          */
>         if (unlikely((mode & S_ISGID) && (mode & S_IXGRP)))
>                 kill |= ATTR_KILL_SGID;
> 
> 	if (unlikely(kill && !capable(CAP_FSETID) && S_ISREG(mode)))
>                 return kill;

Thanks, not sure why I didn't find that.
 
> So the VFS is doing the right thing but the XFS code does it's own
> thing for reasons I don't remember. Given the VFS handles this, maybe
> we should finally remove it from the XFS code?

Yep, probably another remnant of irix code not having a vfs to rely on
as much?

And at least one version of POSIX says:

"If the specified file is a regular file, one or more of the S_IXUSR,
S_IXGRP, or S_IXOTH bits of the file mode are set, and the process has
appropriate privileges, it is implementation-defined whether the
set-user-ID and set-group-ID bits are altered."

Sooo I suppose that was just the Irix implementation ;)

I wonder if LTP tests this, I would have expected it to.

-Eric
