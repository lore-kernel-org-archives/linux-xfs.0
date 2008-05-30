Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 18:12:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4U1Brkf000796
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 18:11:54 -0700
Subject: Re: REVIEW: Enhance xfs_repair -P option to disable libxfs xfs_buf_t locking
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.ubxy8gk63jf8g2@pc-bnaujok.melbourne.sgi.com> <483F4FC7.3060801@sandeen.net>
Content-Transfer-Encoding: 7bit
Date: Fri, 30 May 2008 11:13:14 +1000
Message-ID: <op.ubx0ccd33jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <483F4FC7.3060801@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, 30 May 2008 10:52:23 +1000, Eric Sandeen <sandeen@sandeen.net>  
wrote:

> Barry Naujok wrote:
>> I hope the subject is explanation enough :)
>
> not really ;)
>
> Hum, if I normally lock why do I not want to lock?  Locking good?
> Locking bad?  Locking too slow?  locking for what?  Incoherency ok?  Man
> page updates? :)
>

Ok, man page update:

--- a/xfsprogs/man/man8/xfs_repair.8    2008-05-30 11:11:41.000000000 +1000
+++ b/xfsprogs/man/man8/xfs_repair.8    2008-05-30 11:10:24.075877526 +1000
@@ -91,6 +91,14 @@
  should not modify the filesystem but should only scan the
  filesystem and indicate what repairs would have been made.
  .TP
+.B \-P
+Disable prefetching of inode and directory blocks. Use this option if
+you find
+.B xfs_repair
+gets stuck and stops proceeding. Interrupting a stuck
+.B xfs_repair
+is safe.
+.TP
  .BI \-m " maxmem"
  Specifies the approximate maximum amount of memory, in megabytes, to use  
for
  .BR xfs_repair .
@@ -146,9 +154,6 @@
  outputs its progress every 15 minutes. Reporting is only activated when
  ag_stride is enabled.
  .TP
-.B \-P
-Disable prefetching of inode and directory blocks.
-.TP
  .B \-v
  Verbose output.
  .TP
