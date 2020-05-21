Return-Path: <SRS0=XxdV=7D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC8FC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 08:22:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E0A02070A
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 08:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgEUIWH convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 04:22:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728374AbgEUIWG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 May 2020 04:22:06 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 207817] New: kworker using a lot of cpu
Date:   Thu, 21 May 2020 08:22:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: askjuise@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-207817-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207817

            Bug ID: 207817
           Summary: kworker using a lot of cpu
           Product: File System
           Version: 2.5
    Kernel Version: 4.19.69-1.el7.x86_64
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: askjuise@gmail.com
        Regression: No

Created attachment 289193
  --> https://bugzilla.kernel.org/attachment.cgi?id=289193&action=edit
files from description

Hello!

I'm using CentOS Linux release 7.7.1908 (Core) with kernel 4.19.69 under VMWare
hypervisor.

During my application stress tests, this problem occurred twice over the last
half-year. The last occurrence affected all three VM under the load at once.


# top -sH | head
top - 16:16:14 up  4:49,  1 user,  load average: 1.01, 1.02, 1.00
Threads: 290 total,   2 running, 186 sleeping,   0 stopped,   0 zombie
%Cpu(s):  1.5 us, 26.9 sy,  0.0 ni, 71.6 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem :  8168128 total,  5761540 free,  1267184 used,  1139404 buff/cache
KiB Swap:        0 total,        0 free,        0 used.  6620652 avail Mem

  PID USER      PR  NI    VIRT    RES    SHR S %CPU %MEM     TIME+ COMMAND
  360 root      20   0       0      0      0 R 99.9  0.0 283:13.38
kworker/u8:2+fl
    1 root      20   0   43784   5592   3936 S  0.0  0.1   0:08.64 systemd
    2 root      20   0       0      0      0 S  0.0  0.0   0:00.01 kthreadd

# cat /proc/360/comm
kworker/u8:2+flush-253:2

# uname -a
Linux hbr01 4.19.69-1.el7.x86_64 #1 SMP Thu Aug 29 11:11:09 UTC 2019 x86_64
x86_64 x86_64 GNU/Linux

# xfs_repair -V
xfs_repair version 4.5.0

> number of CPUs
attached as 'cpuinfo' file

> contents of /proc/meminfo
attached as 'meminfo' file

> contents of /proc/mounts
attached as 'mounts' file
please, not that /var/log is mounted from network storage to hypervisor

> contents of /proc/partitions
attached as 'partitions' file

> RAID layout (hardware and/or software)
not used

> write cache status of drives
# hdparm -W /dev/sd[a-d] | grep "write-caching"
...
 write-caching = not supported
 write-caching = not supported
 write-caching = not supported
 write-caching = not supported

> xfs_info output on the filesystem in question
attached as 'xfs_info' file

# echo w > /proc/sysrq-trigger
# dmesg
attached as 'w_sysrq-trigger' file

# echo l > /proc/sysrq-trigger
# dmesg
attached as 'l_sysrq-trigger' file

# perf record -g -a sleep 10
attached as 'perf.data' file

# trace-cmd record -e xfs\*
the trace.dat has the size about 1.4Gb over +-10 second
and
the trace_report.txt has the size more 3+Gb over +-10 second
I guess it's better to share it from some file storage?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
