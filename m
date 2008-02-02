Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 02 Feb 2008 02:12:39 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m12ACWCG000537
	for <xfs@oss.sgi.com>; Sat, 2 Feb 2008 02:12:37 -0800
Received: from hs-out-2122.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 70B7C59201E
	for <xfs@oss.sgi.com>; Sat,  2 Feb 2008 02:12:40 -0800 (PST)
Received: from hs-out-2122.google.com (hs-out-0708.google.com [64.233.178.244]) by cuda.sgi.com with ESMTP id PqEzeTdQhIjVCFRQ for <xfs@oss.sgi.com>; Sat, 02 Feb 2008 02:12:40 -0800 (PST)
Received: by hs-out-2122.google.com with SMTP id 4so1258964hsl.4
        for <xfs@oss.sgi.com>; Sat, 02 Feb 2008 02:12:39 -0800 (PST)
Message-ID: <8f1895b90802020212h278968efy7a644c55c480134e@mail.gmail.com>
Date: Sat, 2 Feb 2008 11:12:38 +0100
From: "Per Lundberg" <perlun@gmail.com>
Subject: XFS: failed to read RT inodes
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello,

After a hard drive failure (and no backup...) I am trying with all my
strength do recover the file systems... With no real success. I have
dumped over the two file systems in question to another, healthy disk
drive. After dumping back the data to a third hard disk, one of the
file system can be successfully mounted but with a huge number of
files in the lost+found directory (after recovery using xfs_repair).
Strange since the dump indicated only 11 bad sectors on that file
system.

However, the big (55 gig) file system cannot even be mounted and this
is troublesome since it contains the most valuable data. This is what
I get after doing xfs_repair on the volume:

Jan 10 10:30:59 amos kernel: SGI XFS with ACLs, security attributes,
realtime, large block numbers, no debug enabled
Jan 10 10:30:59 amos kernel: SGI XFS Quota Management subsystem
Jan 10 10:31:00 amos kernel: XFS mounting filesystem sda10
Jan 10 10:31:00 amos kernel: XFS: failed to read RT inodes

The repair was done using Debian-compiled Linux kernel (2.6.17-2-k7)
using xfsprogs 2.8.11-1. Afterwards, I've upgraded the kernel to
2.6.22 and xfsprogs 2.9.4-2 but it doesn't really make much of a
difference.

I've tried to disable the realtime stuff afterwards, by mounting the
filesystem using rtdev=/dev/null but I only got the following message
out of that:

Jan 10 10:36:40 amos kernel: XFS: Invalid device [/dev/null], error=-15

*Any* ideas on how to proceed with this is greatly appreciated...
Thanks in advance.
-- 
Best regards,
Per Lundberg
