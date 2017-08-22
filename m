Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40652 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751643AbdHVWdZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 Aug 2017 18:33:25 -0400
Subject: Re: XFS Bug Report
References: <CAFzqJcahyU7F5CJcYKTPabWBVCnufwSMS4QcJijHVVux-Ndv+Q@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ad807068-5de9-3200-68ef-de9e42401a5a@sandeen.net>
Date: Tue, 22 Aug 2017 17:33:24 -0500
MIME-Version: 1.0
In-Reply-To: <CAFzqJcahyU7F5CJcYKTPabWBVCnufwSMS4QcJijHVVux-Ndv+Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ruoxin Jiang <rj2394@columbia.edu>, linux-xfs@vger.kernel.org
Cc: Suman Jana <sumanj@gmail.com>

On 8/22/17 4:10 PM, Ruoxin Jiang wrote:
> Hello,
> 
> We are researchers from Columbia University, New York. As part of our
> current research we have run into some issues using xfs filesystem.
> For example, we encountered a case where the setuid bit of a modified
> executable was not removed as desired.

Thanks for the reports.

For case 1:

> * In xfs, function `xfs_file_aio_write_checks` calls `file_remove_privs` which
> removes special file priviledges when the executable is written to or truncated.
> 
> * If an DIO write is not aligned to device logical sector size, the syscall
> fails with  EINVAL` before `xfs_file_aio_write_checks` is called. Thus the setuid
> bit will not be removed from the modified executable.

If the write did not happen, why should the setuid bit be removed?
The write failed and the file's contents were not modified.  It seems
like xfs's behavior makes sense; is there a posix specification that
indicates the behavior should be different?

Case 2 does look problematic (failed mmap write extending the file EOF)

Case 3 seems to show xfs violating this rule, I guess?

       When  the  owner or group of an executable file are changed by a
       non-superuser, the S_ISUID and S_ISGID mode  bits  are  cleared.
       POSIX does not specify whether this also should happen when root
       does the chown(); the Linux behavior depends on the kernel  ver-
       sion.   In  case  of  a non-group-executable file (i.e., one for
       which the S_IXGRP bit is not  set)  the  S_ISGID  bit  indicates
       mandatory locking, and is not cleared by a chown().

I thought this was all handled at the vfs, though, odd.

-Eric
