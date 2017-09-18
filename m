Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:50052 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755926AbdIRPcP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 11:32:15 -0400
Received: by mail-qk0-f173.google.com with SMTP id u67so890903qkg.6
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2017 08:32:14 -0700 (PDT)
Message-ID: <1505748732.29502.5.camel@gmail.com>
Subject: Re: Fw: [Bug 196895] New: SLUB debugging prevents booting encrypted
 XFS partition
From: s.panicho@gmail.com
Date: Mon, 18 Sep 2017 11:32:12 -0400
In-Reply-To: <20170915141250.e4e9f759fe0cd0469db75924@linux-foundation.org>
References: <20170915141250.e4e9f759fe0cd0469db75924@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, "Darrick J.Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Resending last message in plain text this time...

Would you like me to create a ticket on the XFS Bugzilla?

Thanks,
Stephen Panicho

On Fri, 2017-09-15 at 14:12 -0700, Andrew Morton wrote:
> (switched to email.  Please respond via emailed reply-to-all, not via
> the
> bugzilla web interface).
> 
> 
> This might indicate a bug in XFS?
> 
> 
> 
> Begin forwarded message:
> 
> Date: Mon, 11 Sep 2017 01:44:34 +0000
> From: bugzilla-daemon@bugzilla.kernel.org
> To: akpm@linux-foundation.org
> Subject: [Bug 196895] New: SLUB debugging prevents booting encrypted
> XFS partition
> 
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=196895
> 
>             Bug ID: 196895
>            Summary: SLUB debugging prevents booting encrypted XFS
>                     partition
>            Product: Memory Management
>            Version: 2.5
>     Kernel Version: 4.13
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Slab Allocator
>           Assignee: akpm@linux-foundation.org
>           Reporter: s.panicho@gmail.com
>         Regression: No
> 
> This has been identified as an upstream issue in
> https://bugs.archlinux.org/task/54700
> 
> Attempting to boot an encrypted XFS partition with slub_debug=FZPU or
> CONFIG_SLUB_DEBUG_ON=y results in memory corruption and failure to
> mount the
> disk.
> 
> The error messages are as follows:
> 
> [ 23.115192] XFS (dm—0): metadata I/O error: block 0x2
> ("xfs_trans_read_buf_map") error 5 numblks 1
> [ 23.115300] XFS (dm—0): metadata I/O error: block 0x324b002
> ("xfs_trans_read_buf_map") error 5 numblks 1
> [ 23.115380] XFS (dm-0): metadata I/O error: block 0x6496002
> ("xfs_trans_read_buf_map") error 5 numblks 1
> [ 23.115459] XFS (dm-0): metadata I/O error: block 0x96e1002
> ("xfs_trans_read_buf_map") error 5 numblks 1
> [ 23.115468] XFS (dm-0): Corruption of in—memory data detected.
> Shutting down
> filesystem
> [ 23.115471] XFS (dm-0): Please umount the filesystem and rectify the
> problem(s)
> 
> 
> A notable comment from user "loqs" in the Arch Linux bug tracker post
> linked at
> the beginning of this post:
> 
> Reran the test with only CONFIG_SLAB_CANARY=y and I was able to
> reproduce the
> issue.
> Edit:
> Rebuilt with CONFIG_XFS_WARN=y set as well first run did not
> reproduce the
> issue, second run did reproduce the issue.
> No additional xfs related output generated with
> /proc/sys/kernel/printk set to
> 7.
> Edit2:
> After 10 test runs 9 reproduced the issue.
> Edit3:
> Rebuilt without CONFIG_XFS_WARN=y with CONFIG_XFS_DEBUG=y first run
> did not
> reproduce the issue, second run did reproduce the issue.
> No additional xfs related output generated with
> /proc/sys/kernel/printk set to
> 7. (identical behavior to that noted in Edit)
> 
