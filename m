Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 04 Nov 2007 10:35:43 -0800 (PST)
Received: from rayleigh.systella.fr (rayleigh.systella.fr [213.41.184.253])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA4IZT0g020746
	for <xfs@oss.sgi.com>; Sun, 4 Nov 2007 10:35:32 -0800
Message-ID: <472E0CD2.7050702@systella.fr>
Date: Sun, 04 Nov 2007 19:17:54 +0100
From: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
MIME-Version: 1.0
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan> <472DBF8C.2060508@msgid.tls.msk.ru> <Pine.LNX.4.64.0711040750020.3956@p34.internal.lan> <472DDD78.7040002@msgid.tls.msk.ru>
In-Reply-To: <472DDD78.7040002@msgid.tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com

Michael Tokarev wrote:
> Justin Piszcz wrote:
>> On Sun, 4 Nov 2007, Michael Tokarev wrote:
> []
>>> The next time you come across something like that, do a SysRq-T dump and
>>> post that.  It shows a stack trace of all processes - and in particular,
>>> where exactly each task is stuck.
> 
>> Yes I got it before I rebooted, ran that and then dmesg > file.
>>
>> Here it is:
>>
>> [1172609.665902]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
>> [1172609.668768]  ffffffff80747dc0 ffff81015c3aa918 ffff810091c899b4 ffff810091c899a8
> 
> That's only partial list.  All the kernel threads - which are most important
> in this context - aren't shown.  You ran out of dmesg buffer, and the most
> interesting entries was at the beginning.  If your /var/log partition is
> working, the stuff should be in /var/log/kern.log or equivalent.  If it's
> not working, there is a way to capture the info still, by stopping syslogd,
> cat'ing /proc/kmsg to some tmpfs file and scp'ing it elsewhere.

	I have reported some days ago the same bug . I can reproduced it 
without any trouble :-(.

	Configuration : 2.6.23 linux kernel with iscsi-target on sparc64/smp 
(sun4v). Following output was crated by echo t > /proc/sysrq-trigger and 
echo x > /proc/sysrq-trigger. I is a  and paste from /var/log/syslog and 
I hope I haven't done any mistake...

Nov  4 18:55:56 poulenc kernel: SysRq : Show State
Nov  4 18:55:56 poulenc kernel:   task                        PC stack 
  pid father
Nov  4 18:55:56 poulenc kernel: init          S 00000000004c7d68     0 
    1      0
Nov  4 18:55:56 poulenc kernel: Call Trace:
Nov  4 18:55:56 poulenc kernel:  [000000000067ec0c] 
schedule_timeout+0x54/0xc0
Nov  4 18:55:56 poulenc kernel:  [00000000004c7d68] do_select+0x3d0/0x420
Nov  4 18:55:56 poulenc kernel:  [00000000004eccb8] 
compat_core_sys_select+0x160/0x200
Nov  4 18:55:56 poulenc kernel:  [00000000004eef74] 
compat_sys_select+0xbc/0x1a0
Nov  4 18:55:56 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:55:56 poulenc kernel:  [00000000000150b8] 0x150c0
Nov  4 18:55:56 poulenc kernel: kthreadd      S 00000000004273d0     0 
    2      0
Nov  4 18:55:56 poulenc kernel: Call Trace:
Nov  4 18:55:56 poulenc kernel:  [0000000000478fe8] kthreadd+0x1b0/0x1c0
Nov  4 18:55:56 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:55:56 poulenc kernel:  [000000000067d404] rest_init+0x2c/0x60
Nov  4 18:55:56 poulenc kernel: migration/0   S 0000000000478ce0     0 
    3      2
Nov  4 18:55:56 poulenc kernel: Call Trace:
Nov  4 18:55:56 poulenc kernel:  [000000000045e60c] 
migration_thread+0x174/0x360
Nov  4 18:55:56 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:55:56 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:55:56 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:55:56 poulenc kernel: ksoftirqd/0   S 0000000000478ce0     0 
    4      2
Nov  4 18:55:56 poulenc kernel: Call Trace:
Nov  4 18:55:56 poulenc kernel:  [00000000004683c0] ksoftirqd+0xa8/0xc0
Nov  4 18:55:56 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:55:56 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:55:57 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:55:57 poulenc kernel: watchdog/0    S 0000000000478ce0     0 
    5      2
Nov  4 18:55:57 poulenc kernel: Call Trace:
Nov  4 18:55:57 poulenc kernel:  [000000000048f9e0] watchdog+0x48/0x80
Nov  4 18:55:57 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:55:57 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:55:57 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:55:57 poulenc kernel: migration/1   S 0000000000478ce0     0 
    6      2
Nov  4 18:55:57 poulenc kernel: Call Trace:
Nov  4 18:55:57 poulenc kernel:  [000000000045e60c] 
migration_thread+0x174/0x360
Nov  4 18:55:57 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:55:57 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:55:57 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:55:57 poulenc kernel: ksoftirqd/1   S 0000000000478ce0     0 
    7      2
Nov  4 18:55:57 poulenc kernel: Call Trace:
Nov  4 18:55:57 poulenc kernel:  [00000000004683c0] ksoftirqd+0xa8/0xc0
Nov  4 18:55:57 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:55:57 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:55:57 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:55:57 poulenc kernel: watchdog/1    S 0000000000478ce0     0 
    8      2
Nov  4 18:55:57 poulenc kernel: Call Trace:
Nov  4 18:55:57 poulenc kernel:  [000000000048f9e0] watchdog+0x48/0x80
Nov  4 18:55:57 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:55:57 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:55:57 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:55:57 poulenc kernel: migration/2   S 0000000000478ce0     0 
    9      2
Nov  4 18:55:57 poulenc kernel: Call Trace:
Nov  4 18:55:57 poulenc kernel:  [000000000045e60c] 
migration_thread+0x174/0x360
Nov  4 18:55:57 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:55:57 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:55:57 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:55:57 poulenc kernel: ksoftirqd/2   S 0000000000478ce0     0 
   10      2
Nov  4 18:55:57 poulenc kernel: Call Trace:
Nov  4 18:55:57 poulenc kernel:  [00000000004683c0] ksoftirqd+0xa8/0xc0
Nov  4 18:55:57 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:55:57 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:55:57 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:55:57 poulenc kernel: watchdog/2    S 0000000000478ce0     0 
   11      2
Nov  4 18:55:57 poulenc kernel: Call Trace:
Nov  4 18:55:57 poulenc kernel:  [000000000048f9e0] watchdog+0x48/0x80
Nov  4 18:55:57 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:55:57 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:55:57 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:55:57 poulenc kernel: migration/3   R  running task        0 
   12      2
Nov  4 18:55:57 poulenc kernel: ksoftirqd/3   S 0000000000478ce0     0 
   13      2
Nov  4 18:55:57 poulenc kernel: Call Trace:
Nov  4 18:55:57 poulenc kernel:  [00000000004683c0] ksoftirqd+0xa8/0xc0
Nov  4 18:55:57 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:55:57 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:55:58 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:55:58 poulenc kernel: watchdog/3    S 0000000000478ce0     0 
   14      2
Nov  4 18:55:58 poulenc kernel: Call Trace:
Nov  4 18:55:58 poulenc kernel:  [000000000048f9e0] watchdog+0x48/0x80
Nov  4 18:55:58 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:55:58 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:55:58 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:55:58 poulenc kernel: migration/4   S 0000000000478ce0     0 
   15      2
Nov  4 18:55:58 poulenc kernel: Call Trace:
Nov  4 18:55:58 poulenc kernel:  [000000000045e60c] 
migration_thread+0x174/0x360
Nov  4 18:55:58 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:55:58 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:55:58 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:55:58 poulenc kernel: ksoftirqd/4   S 0000000000478ce0     0 
   16      2
Nov  4 18:55:58 poulenc kernel: Call Trace:
Nov  4 18:55:58 poulenc kernel:  [00000000004683c0] ksoftirqd+0xa8/0xc0
Nov  4 18:55:58 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:55:58 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:55:58 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:55:58 poulenc kernel: watchdog/4    S 0000000000478ce0     0 
   17      2
Nov  4 18:55:58 poulenc kernel: Call Trace:
Nov  4 18:55:58 poulenc kernel:  [000000000048f9e0] watchdog+0x48/0x80
Nov  4 18:55:58 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:55:58 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:55:58 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:55:58 poulenc kernel: migration/5   S 0000000000478ce0     0 
   18      2
Nov  4 18:55:58 poulenc kernel: Call Trace:
Nov  4 18:55:58 poulenc kernel:  [000000000045e60c] 
migration_thread+0x174/0x360
Nov  4 18:55:58 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:55:58 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:55:58 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:55:58 poulenc kernel: ksoftirqd/5   S 0000000000478ce0     0 
   19      2
Nov  4 18:55:58 poulenc kernel: Call Trace:
Nov  4 18:55:58 poulenc kernel:  [00000000004683c0] ksoftirqd+0xa8/0xc0
Nov  4 18:55:58 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:55:58 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:55:58 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:55:58 poulenc kernel: watchdog/5    S 0000000000478ce0     0 
   20      2
Nov  4 18:55:58 poulenc kernel: Call Trace:
Nov  4 18:55:58 poulenc kernel:  [000000000048f9e0] watchdog+0x48/0x80
Nov  4 18:55:58 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:55:58 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:55:58 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:55:58 poulenc kernel: migration/6   S 0000000000478ce0     0 
   21      2
Nov  4 18:55:58 poulenc kernel: Call Trace:
Nov  4 18:55:58 poulenc kernel:  [000000000045e60c] 
migration_thread+0x174/0x360
Nov  4 18:55:58 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:55:58 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:55:59 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:55:59 poulenc kernel: ksoftirqd/6   S 0000000000478ce0     0 
   22      2
Nov  4 18:55:59 poulenc kernel: Call Trace:
Nov  4 18:55:59 poulenc kernel:  [00000000004683c0] ksoftirqd+0xa8/0xc0
Nov  4 18:55:59 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:55:59 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:55:59 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:55:59 poulenc kernel: watchdog/6    S 0000000000478ce0     0 
   23      2
Nov  4 18:55:59 poulenc kernel: Call Trace:
Nov  4 18:55:59 poulenc kernel:  [000000000048f9e0] watchdog+0x48/0x80
Nov  4 18:55:59 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:55:59 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:55:59 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:55:59 poulenc kernel: migration/7   S 0000000000478ce0     0 
   24      2
Nov  4 18:55:59 poulenc kernel: Call Trace:
Nov  4 18:55:59 poulenc kernel:  [000000000045e60c] 
migration_thread+0x174/0x360
Nov  4 18:55:59 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:55:59 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:55:59 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:55:59 poulenc kernel: ksoftirqd/7   S 0000000000478ce0     0 
   25      2
Nov  4 18:55:59 poulenc kernel: Call Trace:
Nov  4 18:55:59 poulenc kernel:  [00000000004683c0] ksoftirqd+0xa8/0xc0
Nov  4 18:55:59 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:55:59 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:55:59 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:55:59 poulenc kernel: watchdog/7    S 0000000000478ce0     0 
   26      2
Nov  4 18:55:59 poulenc kernel: Call Trace:
Nov  4 18:55:59 poulenc kernel:  [000000000048f9e0] watchdog+0x48/0x80
Nov  4 18:55:59 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:55:59 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:55:59 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:55:59 poulenc kernel: migration/8   S 0000000000478ce0     0 
   27      2
Nov  4 18:55:59 poulenc kernel: Call Trace:
Nov  4 18:55:59 poulenc kernel:  [000000000045e60c] 
migration_thread+0x174/0x360
Nov  4 18:55:59 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:55:59 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:55:59 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:55:59 poulenc kernel: ksoftirqd/8   S 0000000000478ce0     0 
   28      2
Nov  4 18:55:59 poulenc kernel: Call Trace:
Nov  4 18:55:59 poulenc kernel:  [00000000004683c0] ksoftirqd+0xa8/0xc0
Nov  4 18:55:59 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:55:59 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:55:59 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:55:59 poulenc kernel: watchdog/8    S 0000000000478ce0     0 
   29      2
Nov  4 18:55:59 poulenc kernel: Call Trace:
Nov  4 18:55:59 poulenc kernel:  [000000000048f9e0] watchdog+0x48/0x80
Nov  4 18:55:59 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:55:59 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:55:59 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:00 poulenc kernel: migration/9   S 0000000000478ce0     0 
   30      2
Nov  4 18:56:00 poulenc kernel: Call Trace:
Nov  4 18:56:00 poulenc kernel:  [000000000045e60c] 
migration_thread+0x174/0x360
Nov  4 18:56:00 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:00 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:00 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:00 poulenc kernel: ksoftirqd/9   S 0000000000478ce0     0 
   31      2
Nov  4 18:56:00 poulenc kernel: Call Trace:
Nov  4 18:56:00 poulenc kernel:  [00000000004683c0] ksoftirqd+0xa8/0xc0
Nov  4 18:56:00 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:00 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:00 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:00 poulenc kernel: watchdog/9    S 0000000000478ce0     0 
   32      2
Nov  4 18:56:00 poulenc kernel: Call Trace:
Nov  4 18:56:00 poulenc kernel:  [000000000048f9e0] watchdog+0x48/0x80
Nov  4 18:56:00 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:00 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:00 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:00 poulenc kernel: migration/10  S 0000000000478ce0     0 
   33      2
Nov  4 18:56:00 poulenc kernel: Call Trace:
Nov  4 18:56:00 poulenc kernel:  [000000000045e60c] 
migration_thread+0x174/0x360
Nov  4 18:56:00 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:00 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:00 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:00 poulenc kernel: ksoftirqd/10  S 0000000000478ce0     0 
   34      2
Nov  4 18:56:00 poulenc kernel: Call Trace:
Nov  4 18:56:00 poulenc kernel:  [00000000004683c0] ksoftirqd+0xa8/0xc0
Nov  4 18:56:00 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:00 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:00 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:00 poulenc kernel: watchdog/10   S 0000000000478ce0     0 
   35      2
Nov  4 18:56:00 poulenc kernel: Call Trace:
Nov  4 18:56:00 poulenc kernel:  [000000000048f9e0] watchdog+0x48/0x80
Nov  4 18:56:00 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:00 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:00 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:00 poulenc kernel: migration/11  S 0000000000478ce0     0 
   36      2
Nov  4 18:56:00 poulenc kernel: Call Trace:
Nov  4 18:56:00 poulenc kernel:  [000000000045e60c] 
migration_thread+0x174/0x360
Nov  4 18:56:00 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:00 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:00 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:00 poulenc kernel: ksoftirqd/11  S 0000000000478ce0     0 
   37      2
Nov  4 18:56:00 poulenc kernel: Call Trace:
Nov  4 18:56:00 poulenc kernel:  [00000000004683c0] ksoftirqd+0xa8/0xc0
Nov  4 18:56:00 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:01 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:01 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:01 poulenc kernel: watchdog/11   S 0000000000478ce0     0 
   38      2
Nov  4 18:56:01 poulenc kernel: Call Trace:
Nov  4 18:56:01 poulenc kernel:  [000000000048f9e0] watchdog+0x48/0x80
Nov  4 18:56:01 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:01 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:01 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:01 poulenc kernel: migration/12  S 0000000000478ce0     0 
   39      2
Nov  4 18:56:01 poulenc kernel: Call Trace:
Nov  4 18:56:01 poulenc kernel:  [000000000045e60c] 
migration_thread+0x174/0x360
Nov  4 18:56:01 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:01 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:01 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:01 poulenc kernel: ksoftirqd/12  S 0000000000478ce0     0 
   40      2
Nov  4 18:56:01 poulenc kernel: Call Trace:
Nov  4 18:56:01 poulenc kernel:  [00000000004683c0] ksoftirqd+0xa8/0xc0
Nov  4 18:56:01 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:01 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:01 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:01 poulenc kernel: watchdog/12   S 0000000000478ce0     0 
   41      2
Nov  4 18:56:01 poulenc kernel: Call Trace:
Nov  4 18:56:01 poulenc kernel:  [000000000048f9e0] watchdog+0x48/0x80
Nov  4 18:56:01 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:01 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:01 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:01 poulenc kernel: migration/13  S 0000000000478ce0     0 
   42      2
Nov  4 18:56:01 poulenc kernel: Call Trace:
Nov  4 18:56:01 poulenc kernel:  [000000000045e60c] 
migration_thread+0x174/0x360
Nov  4 18:56:01 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:01 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:01 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:01 poulenc kernel: ksoftirqd/13  S 0000000000478ce0     0 
   43      2
Nov  4 18:56:01 poulenc kernel: Call Trace:
Nov  4 18:56:01 poulenc kernel:  [00000000004683c0] ksoftirqd+0xa8/0xc0
Nov  4 18:56:01 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:01 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:01 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:01 poulenc kernel: watchdog/13   S 0000000000478ce0     0 
   44      2
Nov  4 18:56:01 poulenc kernel: Call Trace:
Nov  4 18:56:01 poulenc kernel:  [000000000048f9e0] watchdog+0x48/0x80
Nov  4 18:56:01 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:01 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:01 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:02 poulenc kernel: migration/14  S 0000000000478ce0     0 
   45      2
Nov  4 18:56:02 poulenc kernel: Call Trace:
Nov  4 18:56:02 poulenc kernel:  [000000000045e60c] 
migration_thread+0x174/0x360
Nov  4 18:56:02 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:02 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:02 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:02 poulenc kernel: ksoftirqd/14  S 0000000000478ce0     0 
   46      2
Nov  4 18:56:02 poulenc kernel: Call Trace:
Nov  4 18:56:02 poulenc kernel:  [00000000004683c0] ksoftirqd+0xa8/0xc0
Nov  4 18:56:02 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:02 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:02 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:02 poulenc kernel: watchdog/14   S 0000000000478ce0     0 
   47      2
Nov  4 18:56:02 poulenc kernel: Call Trace:
Nov  4 18:56:02 poulenc kernel:  [000000000048f9e0] watchdog+0x48/0x80
Nov  4 18:56:02 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:02 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:02 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:02 poulenc kernel: migration/15  S 0000000000478ce0     0 
   48      2
Nov  4 18:56:02 poulenc kernel: Call Trace:
Nov  4 18:56:02 poulenc kernel:  [000000000045e60c] 
migration_thread+0x174/0x360
Nov  4 18:56:02 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:02 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:02 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:02 poulenc kernel: ksoftirqd/15  S 0000000000478ce0     0 
   49      2
Nov  4 18:56:02 poulenc kernel: Call Trace:
Nov  4 18:56:02 poulenc kernel:  [00000000004683c0] ksoftirqd+0xa8/0xc0
Nov  4 18:56:02 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:02 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:02 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:02 poulenc kernel: watchdog/15   S 0000000000478ce0     0 
   50      2
Nov  4 18:56:02 poulenc kernel: Call Trace:
Nov  4 18:56:02 poulenc kernel:  [000000000048f9e0] watchdog+0x48/0x80
Nov  4 18:56:02 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:02 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:02 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:02 poulenc kernel: migration/16  S 0000000000478ce0     0 
   51      2
Nov  4 18:56:03 poulenc kernel: Call Trace:
Nov  4 18:56:03 poulenc kernel:  [000000000045e60c] 
migration_thread+0x174/0x360
Nov  4 18:56:03 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:03 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:03 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:03 poulenc kernel: ksoftirqd/16  S 0000000000478ce0     0 
   52      2
Nov  4 18:56:03 poulenc kernel: Call Trace:
Nov  4 18:56:03 poulenc kernel:  [00000000004683c0] ksoftirqd+0xa8/0xc0
Nov  4 18:56:03 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:03 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:03 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:03 poulenc kernel: watchdog/16   S 0000000000478ce0     0 
   53      2
Nov  4 18:56:03 poulenc kernel: Call Trace:
Nov  4 18:56:03 poulenc kernel:  [000000000048f9e0] watchdog+0x48/0x80
Nov  4 18:56:03 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:03 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:03 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:03 poulenc kernel: migration/17  R  running task        0 
   54      2
Nov  4 18:56:03 poulenc kernel: ksoftirqd/17  R  running task        0 
   55      2
Nov  4 18:56:03 poulenc kernel: watchdog/17   S 0000000000478ce0     0 
   56      2
Nov  4 18:56:03 poulenc kernel: Call Trace:
Nov  4 18:56:03 poulenc kernel:  [000000000048f9e0] watchdog+0x48/0x80
Nov  4 18:56:03 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:03 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:03 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:03 poulenc kernel: migration/18  S 0000000000478ce0     0 
   57      2
Nov  4 18:56:03 poulenc kernel: Call Trace:
Nov  4 18:56:03 poulenc kernel:  [000000000045e60c] 
migration_thread+0x174/0x360
Nov  4 18:56:03 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:03 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:03 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:03 poulenc kernel: ksoftirqd/18  S 0000000000478ce0     0 
   58      2
Nov  4 18:56:03 poulenc kernel: Call Trace:
Nov  4 18:56:03 poulenc kernel:  [00000000004683c0] ksoftirqd+0xa8/0xc0
Nov  4 18:56:03 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:04 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:04 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:04 poulenc kernel: watchdog/18   S 0000000000478ce0     0 
   59      2
Nov  4 18:56:04 poulenc kernel: Call Trace:
Nov  4 18:56:04 poulenc kernel:  [000000000048f9e0] watchdog+0x48/0x80
Nov  4 18:56:04 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:04 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:04 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:04 poulenc kernel: migration/19  S 0000000000478ce0     0 
   60      2
Nov  4 18:56:04 poulenc kernel: Call Trace:
Nov  4 18:56:04 poulenc kernel:  [000000000045e60c] 
migration_thread+0x174/0x360
Nov  4 18:56:04 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:04 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:04 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:04 poulenc kernel: ksoftirqd/19  S 0000000000478ce0     0 
   61      2
Nov  4 18:56:04 poulenc kernel: Call Trace:
Nov  4 18:56:04 poulenc kernel:  [00000000004683c0] ksoftirqd+0xa8/0xc0
Nov  4 18:56:04 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:04 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:04 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:04 poulenc kernel: watchdog/19   S 0000000000478ce0     0 
   62      2
Nov  4 18:56:04 poulenc kernel: Call Trace:
Nov  4 18:56:04 poulenc kernel:  [000000000048f9e0] watchdog+0x48/0x80
Nov  4 18:56:04 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:04 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:04 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:04 poulenc kernel: migration/20  S 0000000000478ce0     0 
   63      2
Nov  4 18:56:04 poulenc kernel: Call Trace:
Nov  4 18:56:04 poulenc kernel:  [000000000045e60c] 
migration_thread+0x174/0x360
Nov  4 18:56:04 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:04 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:04 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:04 poulenc kernel: ksoftirqd/20  S 0000000000478ce0     0 
   64      2
Nov  4 18:56:04 poulenc kernel: Call Trace:
Nov  4 18:56:04 poulenc kernel:  [00000000004683c0] ksoftirqd+0xa8/0xc0
Nov  4 18:56:04 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:04 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:04 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:04 poulenc kernel: watchdog/20   S 0000000000478ce0     0 
   65      2
Nov  4 18:56:04 poulenc kernel: Call Trace:
Nov  4 18:56:04 poulenc kernel:  [000000000048f9e0] watchdog+0x48/0x80
Nov  4 18:56:04 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:04 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:04 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:04 poulenc kernel: migration/21  S 0000000000478ce0     0 
   66      2
Nov  4 18:56:04 poulenc kernel: Call Trace:
Nov  4 18:56:04 poulenc kernel:  [000000000045e60c] 
migration_thread+0x174/0x360
Nov  4 18:56:04 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:04 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:05 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:05 poulenc kernel: ksoftirqd/21  S 0000000000478ce0     0 
   67      2
Nov  4 18:56:05 poulenc kernel: Call Trace:
Nov  4 18:56:05 poulenc kernel:  [00000000004683c0] ksoftirqd+0xa8/0xc0
Nov  4 18:56:05 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:05 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:05 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:05 poulenc kernel: watchdog/21   S 0000000000478ce0     0 
   68      2
Nov  4 18:56:05 poulenc kernel: Call Trace:
Nov  4 18:56:05 poulenc kernel:  [000000000048f9e0] watchdog+0x48/0x80
Nov  4 18:56:05 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:05 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:05 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:05 poulenc kernel: migration/22  S 0000000000478ce0     0 
   69      2
Nov  4 18:56:05 poulenc kernel: Call Trace:
Nov  4 18:56:05 poulenc kernel:  [000000000045e60c] 
migration_thread+0x174/0x360
Nov  4 18:56:05 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:05 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:05 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:05 poulenc kernel: ksoftirqd/22  S 0000000000478ce0     0 
   70      2
Nov  4 18:56:05 poulenc kernel: Call Trace:
Nov  4 18:56:05 poulenc kernel:  [00000000004683c0] ksoftirqd+0xa8/0xc0
Nov  4 18:56:05 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:05 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:05 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:05 poulenc kernel: watchdog/22   S 0000000000478ce0     0 
   71      2
Nov  4 18:56:05 poulenc kernel: Call Trace:
Nov  4 18:56:05 poulenc kernel:  [000000000048f9e0] watchdog+0x48/0x80
Nov  4 18:56:05 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:05 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:05 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:05 poulenc kernel: migration/23  S 0000000000478ce0     0 
   72      2
Nov  4 18:56:05 poulenc kernel: Call Trace:
Nov  4 18:56:05 poulenc kernel:  [000000000045e60c] 
migration_thread+0x174/0x360
Nov  4 18:56:05 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:05 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:05 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:05 poulenc kernel: ksoftirqd/23  S 0000000000478ce0     0 
   73      2
Nov  4 18:56:05 poulenc kernel: Call Trace:
Nov  4 18:56:05 poulenc kernel:  [00000000004683c0] ksoftirqd+0xa8/0xc0
Nov  4 18:56:05 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:05 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:06 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:06 poulenc kernel: watchdog/23   S 0000000000478ce0     0 
   74      2
Nov  4 18:56:06 poulenc kernel: Call Trace:
Nov  4 18:56:06 poulenc kernel:  [000000000048f9e0] watchdog+0x48/0x80
Nov  4 18:56:06 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:06 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:06 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:06 poulenc kernel: events/0      S 0000000000478ce0     0 
   75      2
Nov  4 18:56:06 poulenc kernel: Call Trace:
Nov  4 18:56:06 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:06 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:06 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:06 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:06 poulenc kernel: events/1      S 0000000000478ce0     0 
   76      2
Nov  4 18:56:06 poulenc kernel: Call Trace:
Nov  4 18:56:06 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:06 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:06 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:06 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:06 poulenc kernel: events/2      S 0000000000478ce0     0 
   77      2
Nov  4 18:56:06 poulenc kernel: Call Trace:
Nov  4 18:56:06 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:06 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:06 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:06 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:06 poulenc kernel: events/3      R  running task        0 
   78      2
Nov  4 18:56:06 poulenc kernel: events/4      S 0000000000478ce0     0 
   79      2
Nov  4 18:56:06 poulenc kernel: Call Trace:
Nov  4 18:56:06 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:06 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:06 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:06 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:06 poulenc kernel: events/5      S 0000000000478ce0     0 
   80      2
Nov  4 18:56:06 poulenc kernel: Call Trace:
Nov  4 18:56:06 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:06 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:06 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:06 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:06 poulenc kernel: events/6      S 0000000000478ce0     0 
   81      2
Nov  4 18:56:06 poulenc kernel: Call Trace:
Nov  4 18:56:06 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:06 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:06 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:06 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:06 poulenc kernel: events/7      S 0000000000478ce0     0 
   82      2
Nov  4 18:56:06 poulenc kernel: Call Trace:
Nov  4 18:56:06 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:06 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:06 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:06 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:07 poulenc kernel: events/8      S 0000000000478ce0     0 
   83      2
Nov  4 18:56:07 poulenc kernel: Call Trace:
Nov  4 18:56:07 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:07 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:07 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:07 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:07 poulenc kernel: events/9      S 0000000000478ce0     0 
   84      2
Nov  4 18:56:07 poulenc kernel: Call Trace:
Nov  4 18:56:07 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:07 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:07 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:07 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:07 poulenc kernel: events/10     S 0000000000478ce0     0 
   85      2
Nov  4 18:56:07 poulenc kernel: Call Trace:
Nov  4 18:56:07 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:07 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:07 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:07 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:07 poulenc kernel: events/11     S 0000000000478ce0     0 
   86      2
Nov  4 18:56:07 poulenc kernel: Call Trace:
Nov  4 18:56:07 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:07 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:07 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:07 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:07 poulenc kernel: events/12     S 0000000000478ce0     0 
   87      2
Nov  4 18:56:07 poulenc kernel: Call Trace:
Nov  4 18:56:07 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:07 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:07 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:07 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:07 poulenc kernel: events/13     S 0000000000478ce0     0 
   88      2
Nov  4 18:56:07 poulenc kernel: Call Trace:
Nov  4 18:56:07 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:07 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:07 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:07 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:07 poulenc kernel: events/14     S 0000000000478ce0     0 
   89      2
Nov  4 18:56:07 poulenc kernel: Call Trace:
Nov  4 18:56:07 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:07 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:07 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:07 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:07 poulenc kernel: events/15     S 0000000000478ce0     0 
   90      2
Nov  4 18:56:07 poulenc kernel: Call Trace:
Nov  4 18:56:07 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:07 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:07 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:07 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:07 poulenc kernel: events/16     S 0000000000478ce0     0 
   91      2
Nov  4 18:56:08 poulenc kernel: Call Trace:
Nov  4 18:56:08 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:08 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:08 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:08 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:08 poulenc kernel: events/17     S 0000000000478ce0     0 
   92      2
Nov  4 18:56:08 poulenc kernel: Call Trace:
Nov  4 18:56:08 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:08 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:08 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:08 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:08 poulenc kernel: events/18     S 0000000000478ce0     0 
   93      2
Nov  4 18:56:08 poulenc kernel: Call Trace:
Nov  4 18:56:08 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:08 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:08 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:08 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:08 poulenc kernel: events/19     S 0000000000478ce0     0 
   94      2
Nov  4 18:56:08 poulenc kernel: Call Trace:
Nov  4 18:56:08 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:08 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:08 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:08 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:08 poulenc kernel: events/20     S 0000000000478ce0     0 
   95      2
Nov  4 18:56:08 poulenc kernel: Call Trace:
Nov  4 18:56:08 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:08 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:08 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:08 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:08 poulenc kernel: events/21     S 0000000000478ce0     0 
   96      2
Nov  4 18:56:08 poulenc kernel: Call Trace:
Nov  4 18:56:08 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:08 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:08 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:08 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:08 poulenc kernel: events/22     S 0000000000478ce0     0 
   97      2
Nov  4 18:56:08 poulenc kernel: Call Trace:
Nov  4 18:56:08 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:08 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:08 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:08 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:08 poulenc kernel: events/23     S 0000000000478ce0     0 
   98      2
Nov  4 18:56:08 poulenc kernel: Call Trace:
Nov  4 18:56:08 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:08 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:08 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:08 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:08 poulenc kernel: khelper       S 0000000000478ce0     0 
   99      2
Nov  4 18:56:08 poulenc kernel: Call Trace:
Nov  4 18:56:08 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:08 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:08 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:08 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:09 poulenc kernel: kblockd/0     S 0000000000478ce0     0 
  247      2
Nov  4 18:56:09 poulenc kernel: Call Trace:
Nov  4 18:56:09 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:09 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:09 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:09 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:09 poulenc kernel: kblockd/1     S 0000000000478ce0     0 
  248      2
Nov  4 18:56:09 poulenc kernel: Call Trace:
Nov  4 18:56:09 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:09 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:09 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:09 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:09 poulenc kernel: kblockd/2     S 0000000000478ce0     0 
  249      2
Nov  4 18:56:09 poulenc kernel: Call Trace:
Nov  4 18:56:09 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:09 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:09 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:09 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:09 poulenc kernel: kblockd/3     R  running task        0 
  250      2
Nov  4 18:56:09 poulenc kernel: kblockd/4     S 0000000000478ce0     0 
  251      2
Nov  4 18:56:09 poulenc kernel: Call Trace:
Nov  4 18:56:09 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:09 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:09 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:09 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:09 poulenc kernel: kblockd/5     S 0000000000478ce0     0 
  252      2
Nov  4 18:56:09 poulenc kernel: Call Trace:
Nov  4 18:56:09 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:09 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:09 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:09 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:09 poulenc kernel: kblockd/6     S 0000000000478ce0     0 
  253      2
Nov  4 18:56:09 poulenc kernel: Call Trace:
Nov  4 18:56:09 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:09 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:09 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:10 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:10 poulenc kernel: kblockd/7     S 0000000000478ce0     0 
  254      2
Nov  4 18:56:10 poulenc kernel: Call Trace:
Nov  4 18:56:10 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:10 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:10 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:10 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:10 poulenc kernel: kblockd/8     S 0000000000478ce0     0 
  255      2
Nov  4 18:56:10 poulenc kernel: Call Trace:
Nov  4 18:56:10 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:10 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:10 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:10 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:10 poulenc kernel: kblockd/9     S 0000000000478ce0     0 
  256      2
Nov  4 18:56:10 poulenc kernel: Call Trace:
Nov  4 18:56:10 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:10 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:10 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:10 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:10 poulenc kernel: kblockd/10    S 0000000000478ce0     0 
  257      2
Nov  4 18:56:10 poulenc kernel: Call Trace:
Nov  4 18:56:10 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:10 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:10 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:10 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:10 poulenc kernel: kblockd/11    S 0000000000478ce0     0 
  258      2
Nov  4 18:56:10 poulenc kernel: Call Trace:
Nov  4 18:56:10 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:10 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:10 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:10 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:10 poulenc kernel: kblockd/12    S 0000000000478ce0     0 
  259      2
Nov  4 18:56:10 poulenc kernel: Call Trace:
Nov  4 18:56:10 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:10 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:10 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:10 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:10 poulenc kernel: kblockd/13    S 0000000000478ce0     0 
  260      2
Nov  4 18:56:10 poulenc kernel: Call Trace:
Nov  4 18:56:10 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:10 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:10 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:10 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:10 poulenc kernel: kblockd/14    S 0000000000478ce0     0 
  261      2
Nov  4 18:56:10 poulenc kernel: Call Trace:
Nov  4 18:56:10 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:10 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:10 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:11 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:11 poulenc kernel: kblockd/15    S 0000000000478ce0     0 
  262      2
Nov  4 18:56:11 poulenc kernel: Call Trace:
Nov  4 18:56:11 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:11 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:11 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:11 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:11 poulenc kernel: kblockd/16    S 0000000000478ce0     0 
  263      2
Nov  4 18:56:11 poulenc kernel: Call Trace:
Nov  4 18:56:11 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:11 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:11 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:11 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:11 poulenc kernel: kblockd/17    S 0000000000478ce0     0 
  264      2
Nov  4 18:56:11 poulenc kernel: Call Trace:
Nov  4 18:56:11 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:11 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:11 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:11 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:11 poulenc kernel: kblockd/18    S 0000000000478ce0     0 
  265      2
Nov  4 18:56:11 poulenc kernel: Call Trace:
Nov  4 18:56:11 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:11 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:11 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:11 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:11 poulenc kernel: kblockd/19    S 0000000000478ce0     0 
  266      2
Nov  4 18:56:11 poulenc kernel: Call Trace:
Nov  4 18:56:11 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:11 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:11 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:11 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:11 poulenc kernel: kblockd/20    S 0000000000478ce0     0 
  267      2
Nov  4 18:56:11 poulenc kernel: Call Trace:
Nov  4 18:56:11 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:11 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:11 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:11 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:11 poulenc kernel: kblockd/21    S 0000000000478ce0     0 
  268      2
Nov  4 18:56:11 poulenc kernel: Call Trace:
Nov  4 18:56:11 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:12 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:12 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:12 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:12 poulenc kernel: kblockd/22    S 0000000000478ce0     0 
  269      2
Nov  4 18:56:12 poulenc kernel: Call Trace:
Nov  4 18:56:12 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:12 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:12 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:12 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:12 poulenc kernel: kblockd/23    S 0000000000478ce0     0 
  270      2
Nov  4 18:56:12 poulenc kernel: Call Trace:
Nov  4 18:56:12 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:12 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:12 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:12 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:12 poulenc kernel: pdflush       S 0000000000478ce0     0 
  294      2
Nov  4 18:56:12 poulenc kernel: Call Trace:
Nov  4 18:56:12 poulenc kernel:  [000000000049a420] pdflush+0xc8/0x200
Nov  4 18:56:12 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:12 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:12 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:12 poulenc kernel: pdflush       S 0000000000478ce0     0 
  295      2
Nov  4 18:56:12 poulenc kernel: Call Trace:
Nov  4 18:56:12 poulenc kernel:  [000000000049a420] pdflush+0xc8/0x200
Nov  4 18:56:12 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:12 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:12 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:12 poulenc kernel: kswapd0       S 0000000000478ce0     0 
  296      2
Nov  4 18:56:12 poulenc kernel: Call Trace:
Nov  4 18:56:12 poulenc kernel:  [000000000049e778] kswapd+0x540/0x560
Nov  4 18:56:12 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:12 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:12 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:12 poulenc kernel: aio/0         S 0000000000478ce0     0 
  297      2
Nov  4 18:56:12 poulenc kernel: Call Trace:
Nov  4 18:56:12 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:12 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:12 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:12 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:12 poulenc kernel: aio/1         S 0000000000478ce0     0 
  298      2
Nov  4 18:56:12 poulenc kernel: Call Trace:
Nov  4 18:56:12 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:13 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:13 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:13 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:13 poulenc kernel: aio/2         S 0000000000478ce0     0 
  299      2
Nov  4 18:56:13 poulenc kernel: Call Trace:
Nov  4 18:56:13 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:13 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:13 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:13 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:13 poulenc kernel: aio/3         S 0000000000478ce0     0 
  300      2
Nov  4 18:56:13 poulenc kernel: Call Trace:
Nov  4 18:56:13 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:13 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:13 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:13 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:13 poulenc kernel: aio/4         S 0000000000478ce0     0 
  301      2
Nov  4 18:56:13 poulenc kernel: Call Trace:
Nov  4 18:56:13 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:13 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:13 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:13 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:13 poulenc kernel: aio/5         S 0000000000478ce0     0 
  302      2
Nov  4 18:56:13 poulenc kernel: Call Trace:
Nov  4 18:56:13 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:13 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:13 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:13 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:13 poulenc kernel: aio/6         S 0000000000478ce0     0 
  303      2
Nov  4 18:56:13 poulenc kernel: Call Trace:
Nov  4 18:56:13 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:13 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:13 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:13 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:13 poulenc kernel: aio/7         S 0000000000478ce0     0 
  304      2
Nov  4 18:56:13 poulenc kernel: Call Trace:
Nov  4 18:56:13 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:13 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:13 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:13 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:14 poulenc kernel: aio/8         S 0000000000478ce0     0 
  305      2
Nov  4 18:56:14 poulenc kernel: Call Trace:
Nov  4 18:56:14 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:14 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:14 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:14 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:14 poulenc kernel: aio/9         S 0000000000478ce0     0 
  306      2
Nov  4 18:56:14 poulenc kernel: Call Trace:
Nov  4 18:56:14 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:14 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:14 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:14 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:14 poulenc kernel: aio/10        S 0000000000478ce0     0 
  307      2
Nov  4 18:56:14 poulenc kernel: Call Trace:
Nov  4 18:56:14 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:14 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:14 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:14 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:14 poulenc kernel: aio/11        S 0000000000478ce0     0 
  308      2
Nov  4 18:56:14 poulenc kernel: Call Trace:
Nov  4 18:56:14 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:14 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:14 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:14 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:14 poulenc kernel: aio/12        S 0000000000478ce0     0 
  309      2
Nov  4 18:56:14 poulenc kernel: Call Trace:
Nov  4 18:56:15 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:15 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:15 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:15 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:15 poulenc kernel: aio/13        S 0000000000478ce0     0 
  310      2
Nov  4 18:56:15 poulenc kernel: Call Trace:
Nov  4 18:56:15 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:15 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:15 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:15 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:15 poulenc kernel: aio/14        S 0000000000478ce0     0 
  311      2
Nov  4 18:56:15 poulenc kernel: Call Trace:
Nov  4 18:56:15 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:15 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:15 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:15 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:15 poulenc kernel: aio/15        S 0000000000478ce0     0 
  312      2
Nov  4 18:56:15 poulenc kernel: Call Trace:
Nov  4 18:56:15 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:15 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:15 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:15 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:15 poulenc kernel: aio/16        S 0000000000478ce0     0 
  313      2
Nov  4 18:56:15 poulenc kernel: Call Trace:
Nov  4 18:56:15 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:15 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:15 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:15 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:15 poulenc kernel: aio/17        S 0000000000478ce0     0 
  314      2
Nov  4 18:56:15 poulenc kernel: Call Trace:
Nov  4 18:56:15 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:15 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:15 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:15 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:15 poulenc kernel: aio/18        S 0000000000478ce0     0 
  315      2
Nov  4 18:56:15 poulenc kernel: Call Trace:
Nov  4 18:56:15 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:15 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:15 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:16 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:16 poulenc kernel: aio/19        S 0000000000478ce0     0 
  316      2
Nov  4 18:56:16 poulenc kernel: Call Trace:
Nov  4 18:56:16 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:16 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:16 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:16 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:16 poulenc kernel: aio/20        S 0000000000478ce0     0 
  317      2
Nov  4 18:56:16 poulenc kernel: Call Trace:
Nov  4 18:56:16 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:16 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:16 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:16 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:16 poulenc kernel: aio/21        S 0000000000478ce0     0 
  318      2
Nov  4 18:56:16 poulenc kernel: Call Trace:
Nov  4 18:56:16 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:16 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:16 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:16 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:16 poulenc kernel: aio/22        S 0000000000478ce0     0 
  319      2
Nov  4 18:56:16 poulenc kernel: Call Trace:
Nov  4 18:56:16 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:16 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:16 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:16 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:16 poulenc kernel: aio/23        S 0000000000478ce0     0 
  320      2
Nov  4 18:56:16 poulenc kernel: Call Trace:
Nov  4 18:56:16 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:16 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:16 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:16 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:16 poulenc kernel: scsi_tgtd/0   S 0000000000478ce0     0 
  911      2
Nov  4 18:56:16 poulenc kernel: Call Trace:
Nov  4 18:56:16 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:16 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:16 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:17 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:17 poulenc kernel: scsi_tgtd/1   S 0000000000478ce0     0 
  912      2
Nov  4 18:56:17 poulenc kernel: Call Trace:
Nov  4 18:56:17 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:17 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:17 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:17 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:17 poulenc kernel: scsi_tgtd/2   S 0000000000478ce0     0 
  913      2
Nov  4 18:56:17 poulenc kernel: Call Trace:
Nov  4 18:56:17 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:17 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:17 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:17 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:17 poulenc kernel: scsi_tgtd/3   S 0000000000478ce0     0 
  914      2
Nov  4 18:56:17 poulenc kernel: Call Trace:
Nov  4 18:56:17 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:17 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:17 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:17 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:17 poulenc kernel: scsi_tgtd/4   S 0000000000478ce0     0 
  915      2
Nov  4 18:56:17 poulenc kernel: Call Trace:
Nov  4 18:56:17 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:17 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:17 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:17 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:17 poulenc kernel: scsi_tgtd/5   S 0000000000478ce0     0 
  916      2
Nov  4 18:56:17 poulenc kernel: Call Trace:
Nov  4 18:56:17 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:17 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:17 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:17 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:17 poulenc kernel: scsi_tgtd/6   S 0000000000478ce0     0 
  917      2
Nov  4 18:56:17 poulenc kernel: Call Trace:
Nov  4 18:56:17 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:17 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:17 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:17 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:17 poulenc kernel: scsi_tgtd/7   S 0000000000478ce0     0 
  918      2
Nov  4 18:56:17 poulenc kernel: Call Trace:
Nov  4 18:56:17 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:17 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:17 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:17 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:17 poulenc kernel: scsi_tgtd/8   S 0000000000478ce0     0 
  919      2
Nov  4 18:56:17 poulenc kernel: Call Trace:
Nov  4 18:56:17 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:17 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:17 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:17 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:18 poulenc kernel: scsi_tgtd/9   S 0000000000478ce0     0 
  920      2
Nov  4 18:56:18 poulenc kernel: Call Trace:
Nov  4 18:56:18 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:18 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:18 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:18 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:18 poulenc kernel: scsi_tgtd/10  S 0000000000478ce0     0 
  921      2
Nov  4 18:56:18 poulenc kernel: Call Trace:
Nov  4 18:56:18 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:18 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:18 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:18 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:18 poulenc kernel: scsi_tgtd/11  S 0000000000478ce0     0 
  922      2
Nov  4 18:56:18 poulenc kernel: Call Trace:
Nov  4 18:56:18 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:18 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:18 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:18 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:18 poulenc kernel: scsi_tgtd/12  S 0000000000478ce0     0 
  923      2
Nov  4 18:56:18 poulenc kernel: Call Trace:
Nov  4 18:56:18 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:18 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:18 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:18 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:18 poulenc kernel: scsi_tgtd/13  S 0000000000478ce0     0 
  924      2
Nov  4 18:56:18 poulenc kernel: Call Trace:
Nov  4 18:56:18 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:18 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:18 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:18 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:18 poulenc kernel: scsi_tgtd/14  S 0000000000478ce0     0 
  925      2
Nov  4 18:56:18 poulenc kernel: Call Trace:
Nov  4 18:56:18 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:18 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:18 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:18 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:18 poulenc kernel: scsi_tgtd/15  S 0000000000478ce0     0 
  926      2
Nov  4 18:56:18 poulenc kernel: Call Trace:
Nov  4 18:56:18 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:18 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:18 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:18 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:18 poulenc kernel: scsi_tgtd/16  S 0000000000478ce0     0 
  927      2
Nov  4 18:56:19 poulenc kernel: Call Trace:
Nov  4 18:56:19 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:19 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:19 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:19 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:19 poulenc kernel: scsi_tgtd/17  S 0000000000478ce0     0 
  928      2
Nov  4 18:56:19 poulenc kernel: Call Trace:
Nov  4 18:56:19 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:19 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:19 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:19 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:19 poulenc kernel: scsi_tgtd/18  S 0000000000478ce0     0 
  929      2
Nov  4 18:56:19 poulenc kernel: Call Trace:
Nov  4 18:56:19 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:19 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:19 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:19 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:19 poulenc kernel: scsi_tgtd/19  S 0000000000478ce0     0 
  930      2
Nov  4 18:56:19 poulenc kernel: Call Trace:
Nov  4 18:56:19 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:19 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:19 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:19 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:19 poulenc kernel: scsi_tgtd/20  S 0000000000478ce0     0 
  931      2
Nov  4 18:56:19 poulenc kernel: Call Trace:
Nov  4 18:56:19 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:19 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:19 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:19 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:19 poulenc kernel: scsi_tgtd/21  S 0000000000478ce0     0 
  932      2
Nov  4 18:56:19 poulenc kernel: Call Trace:
Nov  4 18:56:19 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:19 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:19 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:19 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:19 poulenc kernel: scsi_tgtd/22  S 0000000000478ce0     0 
  933      2
Nov  4 18:56:19 poulenc kernel: Call Trace:
Nov  4 18:56:20 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:20 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:20 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:20 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:20 poulenc kernel: scsi_tgtd/23  S 0000000000478ce0     0 
  934      2
Nov  4 18:56:20 poulenc kernel: Call Trace:
Nov  4 18:56:20 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:20 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:20 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:20 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:20 poulenc kernel: scsi_eh_0     S 0000000000478ce0     0 
  947      2
Nov  4 18:56:20 poulenc kernel: Call Trace:
Nov  4 18:56:20 poulenc kernel:  [00000000005ae0a0] 
scsi_error_handler+0x48/0x5a0
Nov  4 18:56:20 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:20 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:20 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:20 poulenc kernel: md0_raid1     S 00000000005f2ee8     0 
  991      2
Nov  4 18:56:20 poulenc kernel: Call Trace:
Nov  4 18:56:20 poulenc kernel:  [000000000067ec30] 
schedule_timeout+0x78/0xc0
Nov  4 18:56:20 poulenc kernel:  [00000000005f2ee8] md_thread+0xf0/0x140
Nov  4 18:56:20 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:20 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:20 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:20 poulenc kernel: kjournald     S 0000000000478ce0     0 
  993      2
Nov  4 18:56:20 poulenc kernel: Call Trace:
Nov  4 18:56:20 poulenc kernel:  [000000000052da18] kjournald+0x1c0/0x1e0
Nov  4 18:56:20 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:20 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:20 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:20 poulenc kernel: udevd         S 00000000004c7d68     0 
1091      1
Nov  4 18:56:20 poulenc kernel: Call Trace:
Nov  4 18:56:20 poulenc kernel:  [000000000067ec30] 
schedule_timeout+0x78/0xc0
Nov  4 18:56:20 poulenc kernel:  [00000000004c7d68] do_select+0x3d0/0x420
Nov  4 18:56:20 poulenc kernel:  [00000000004eccb8] 
compat_core_sys_select+0x160/0x200
Nov  4 18:56:20 poulenc kernel:  [00000000004eeee4] 
compat_sys_select+0x2c/0x1a0
Nov  4 18:56:20 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:20 poulenc kernel:  [0000000000013590] 0x13598
Nov  4 18:56:20 poulenc kernel: scsi_eh_1     S 0000000000478ce0     0 
1985      2
Nov  4 18:56:20 poulenc kernel: Call Trace:
Nov  4 18:56:20 poulenc kernel:  [00000000005ae0a0] 
scsi_error_handler+0x48/0x5a0
Nov  4 18:56:20 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:20 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:20 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:20 poulenc kernel: scsi_eh_2     S 0000000000478ce0     0 
2093      2
Nov  4 18:56:20 poulenc kernel: Call Trace:
Nov  4 18:56:21 poulenc kernel:  [00000000005ae0a0] 
scsi_error_handler+0x48/0x5a0
Nov  4 18:56:21 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:21 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:21 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:21 poulenc kernel: ksnapd        S 0000000000478ce0     0 
2718      2
Nov  4 18:56:21 poulenc kernel: Call Trace:
Nov  4 18:56:21 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:21 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:21 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:21 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:21 poulenc kernel: md6_raid1     S 00000000005f2ee8     0 
2731      2
Nov  4 18:56:21 poulenc kernel: Call Trace:
Nov  4 18:56:21 poulenc kernel:  [000000000067ec30] 
schedule_timeout+0x78/0xc0
Nov  4 18:56:21 poulenc kernel:  [00000000005f2ee8] md_thread+0xf0/0x140
Nov  4 18:56:21 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:21 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:21 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:21 poulenc kernel: md1_raid1     S 00000000005f2ee8     0 
2748      2
Nov  4 18:56:21 poulenc kernel: Call Trace:
Nov  4 18:56:21 poulenc kernel:  [000000000067ec30] 
schedule_timeout+0x78/0xc0
Nov  4 18:56:21 poulenc kernel:  [00000000005f2ee8] md_thread+0xf0/0x140
Nov  4 18:56:21 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:21 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:21 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:21 poulenc kernel: md2_raid1     S 00000000005f2ee8     0 
2753      2
Nov  4 18:56:21 poulenc kernel: Call Trace:
Nov  4 18:56:21 poulenc kernel:  [000000000067ec30] 
schedule_timeout+0x78/0xc0
Nov  4 18:56:21 poulenc kernel:  [00000000005f2ee8] md_thread+0xf0/0x140
Nov  4 18:56:21 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:21 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:21 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:21 poulenc kernel: md3_raid1     S 00000000005f2ee8     0 
2758      2
Nov  4 18:56:21 poulenc kernel: Call Trace:
Nov  4 18:56:21 poulenc kernel:  [000000000067ec30] 
schedule_timeout+0x78/0xc0
Nov  4 18:56:21 poulenc kernel:  [00000000005f2ee8] md_thread+0xf0/0x140
Nov  4 18:56:21 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:21 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:21 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:22 poulenc kernel: md4_raid1     S 00000000005f2ee8     0 
2763      2
Nov  4 18:56:22 poulenc kernel: Call Trace:
Nov  4 18:56:22 poulenc kernel:  [000000000067ec30] 
schedule_timeout+0x78/0xc0
Nov  4 18:56:22 poulenc kernel:  [00000000005f2ee8] md_thread+0xf0/0x140
Nov  4 18:56:22 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:22 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:22 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:22 poulenc kernel: md5_raid1     S 00000000005f2ee8     0 
2768      2
Nov  4 18:56:22 poulenc kernel: Call Trace:
Nov  4 18:56:22 poulenc kernel:  [000000000067ec30] 
schedule_timeout+0x78/0xc0
Nov  4 18:56:22 poulenc kernel:  [00000000005f2ee8] md_thread+0xf0/0x140
Nov  4 18:56:22 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:22 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:22 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:22 poulenc kernel: kjournald     S 0000000000478ce0     0 
2857      2
Nov  4 18:56:22 poulenc kernel: Call Trace:
Nov  4 18:56:22 poulenc kernel:  [000000000052da18] kjournald+0x1c0/0x1e0
Nov  4 18:56:22 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:22 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:22 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:22 poulenc kernel: kjournald     S 0000000000478ce0     0 
2870      2
Nov  4 18:56:22 poulenc kernel: Call Trace:
Nov  4 18:56:22 poulenc kernel:  [000000000052da18] kjournald+0x1c0/0x1e0
Nov  4 18:56:22 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:22 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:22 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:22 poulenc kernel: kjournald     S 0000000000478ce0     0 
2871      2
Nov  4 18:56:22 poulenc kernel: Call Trace:
Nov  4 18:56:22 poulenc kernel:  [000000000052da18] kjournald+0x1c0/0x1e0
Nov  4 18:56:22 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:22 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:22 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:22 poulenc kernel: kjournald     S 0000000000478ce0     0 
2872      2
Nov  4 18:56:22 poulenc kernel: Call Trace:
Nov  4 18:56:22 poulenc kernel:  [000000000052da18] kjournald+0x1c0/0x1e0
Nov  4 18:56:22 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:22 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:22 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:23 poulenc kernel: kjournald     S 0000000000478ce0     0 
2873      2
Nov  4 18:56:23 poulenc kernel: Call Trace:
Nov  4 18:56:23 poulenc kernel:  [000000000052da18] kjournald+0x1c0/0x1e0
Nov  4 18:56:23 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:23 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:23 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:23 poulenc kernel: portmap       S 00000000004c776c     0 
2994      1
Nov  4 18:56:23 poulenc kernel: Call Trace:
Nov  4 18:56:23 poulenc kernel:  [000000000067ec0c] 
schedule_timeout+0x54/0xc0
Nov  4 18:56:23 poulenc kernel:  [00000000004c776c] do_sys_poll+0x234/0x400
Nov  4 18:56:23 poulenc kernel:  [00000000004c7960] sys_poll+0x28/0x60
Nov  4 18:56:23 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:23 poulenc kernel:  [00000000700025b8] 0x700025c0
Nov  4 18:56:23 poulenc kernel: rpc.statd     S 00000000004c7d68     0 
3006      1
Nov  4 18:56:23 poulenc kernel: Call Trace:
Nov  4 18:56:23 poulenc kernel:  [000000000067ec30] 
schedule_timeout+0x78/0xc0
Nov  4 18:56:23 poulenc kernel:  [00000000004c7d68] do_select+0x3d0/0x420
Nov  4 18:56:23 poulenc kernel:  [00000000004eccb8] 
compat_core_sys_select+0x160/0x200
Nov  4 18:56:23 poulenc kernel:  [00000000004eeee4] 
compat_sys_select+0x2c/0x1a0
Nov  4 18:56:23 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:23 poulenc kernel:  [00000000000143f4] 0x143fc
Nov  4 18:56:23 poulenc kernel: rpciod/0      S 0000000000478ce0     0 
3035      2
Nov  4 18:56:23 poulenc kernel: Call Trace:
Nov  4 18:56:23 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:23 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:23 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:23 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:23 poulenc kernel: rpciod/1      S 0000000000478ce0     0 
3036      2
Nov  4 18:56:23 poulenc kernel: Call Trace:
Nov  4 18:56:23 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:23 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:23 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:23 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:23 poulenc kernel: rpciod/2      S 0000000000478ce0     0 
3037      2
Nov  4 18:56:23 poulenc kernel: Call Trace:
Nov  4 18:56:23 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:23 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:23 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:23 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:23 poulenc kernel: rpciod/3      S 0000000000478ce0     0 
3038      2
Nov  4 18:56:23 poulenc kernel: Call Trace:
Nov  4 18:56:23 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:23 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:23 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:23 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:24 poulenc kernel: rpciod/4      S 0000000000478ce0     0 
3039      2
Nov  4 18:56:24 poulenc kernel: Call Trace:
Nov  4 18:56:24 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:24 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:24 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:24 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:24 poulenc kernel: rpciod/5      S 0000000000478ce0     0 
3040      2
Nov  4 18:56:24 poulenc kernel: Call Trace:
Nov  4 18:56:24 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:24 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:24 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:24 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:24 poulenc kernel: rpciod/6      S 0000000000478ce0     0 
3041      2
Nov  4 18:56:24 poulenc kernel: Call Trace:
Nov  4 18:56:24 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:24 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:24 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:24 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:24 poulenc kernel: rpciod/7      S 0000000000478ce0     0 
3042      2
Nov  4 18:56:24 poulenc kernel: Call Trace:
Nov  4 18:56:24 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:24 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:24 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:24 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:24 poulenc kernel: rpciod/8      S 0000000000478ce0     0 
3043      2
Nov  4 18:56:24 poulenc kernel: Call Trace:
Nov  4 18:56:24 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:24 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:24 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:24 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:24 poulenc kernel: rpciod/9      S 0000000000478ce0     0 
3044      2
Nov  4 18:56:24 poulenc kernel: Call Trace:
Nov  4 18:56:24 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:24 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:24 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:24 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:24 poulenc kernel: rpciod/10     S 0000000000478ce0     0 
3045      2
Nov  4 18:56:24 poulenc kernel: Call Trace:
Nov  4 18:56:24 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:24 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:24 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:24 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:24 poulenc kernel: rpciod/11     S 0000000000478ce0     0 
3046      2
Nov  4 18:56:24 poulenc kernel: Call Trace:
Nov  4 18:56:24 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:24 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:24 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:24 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:24 poulenc kernel: rpciod/12     S 0000000000478ce0     0 
3047      2
Nov  4 18:56:24 poulenc kernel: Call Trace:
Nov  4 18:56:25 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:25 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:25 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:25 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:25 poulenc kernel: rpciod/13     S 0000000000478ce0     0 
3048      2
Nov  4 18:56:25 poulenc kernel: Call Trace:
Nov  4 18:56:25 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:25 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:25 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:25 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:25 poulenc kernel: rpciod/14     S 0000000000478ce0     0 
3049      2
Nov  4 18:56:25 poulenc kernel: Call Trace:
Nov  4 18:56:25 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:25 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:25 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:25 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:25 poulenc kernel: rpciod/15     S 0000000000478ce0     0 
3050      2
Nov  4 18:56:25 poulenc kernel: Call Trace:
Nov  4 18:56:25 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:25 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:25 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:25 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:25 poulenc kernel: rpciod/16     S 0000000000478ce0     0 
3051      2
Nov  4 18:56:25 poulenc kernel: Call Trace:
Nov  4 18:56:25 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:25 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:25 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:25 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:25 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:25 poulenc kernel: rpciod/17     S 0000000000478ce0     0 
3052      2
Nov  4 18:56:25 poulenc kernel: Call Trace:
Nov  4 18:56:25 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:25 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:25 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:25 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:25 poulenc kernel: rpciod/18     S 0000000000478ce0     0 
3053      2
Nov  4 18:56:25 poulenc kernel: Call Trace:
Nov  4 18:56:25 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:25 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:25 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:25 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:25 poulenc kernel: rpciod/19     S 0000000000478ce0     0 
3054      2
Nov  4 18:56:25 poulenc kernel: Call Trace:
Nov  4 18:56:25 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:25 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:25 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:25 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:26 poulenc kernel: rpciod/20     S 0000000000478ce0     0 
3055      2
Nov  4 18:56:26 poulenc kernel: Call Trace:
Nov  4 18:56:26 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:26 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:26 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:26 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:26 poulenc kernel: rpciod/21     S 0000000000478ce0     0 
3056      2
Nov  4 18:56:26 poulenc kernel: Call Trace:
Nov  4 18:56:26 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:26 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:26 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:26 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:26 poulenc kernel: rpciod/22     S 0000000000478ce0     0 
3057      2
Nov  4 18:56:26 poulenc kernel: Call Trace:
Nov  4 18:56:26 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:26 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:26 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:26 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:26 poulenc kernel: rpciod/23     S 0000000000478ce0     0 
3058      2
Nov  4 18:56:26 poulenc kernel: Call Trace:
Nov  4 18:56:26 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:26 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:26 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:26 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:26 poulenc kernel: rpc.idmapd    S 00000000004ea8fc     0 
3139      1
Nov  4 18:56:26 poulenc kernel: Call Trace:
Nov  4 18:56:26 poulenc kernel:  [000000000067ec30] 
schedule_timeout+0x78/0xc0
Nov  4 18:56:26 poulenc kernel:  [00000000004ea8fc] 
sys_epoll_wait+0x144/0x480
Nov  4 18:56:26 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:26 poulenc kernel:  [00000000f7f2515c] 0xf7f25164
Nov  4 18:56:26 poulenc kernel: syslogd       S 00000000004c7d68     0 
3244      1
Nov  4 18:56:26 poulenc kernel: Call Trace:
Nov  4 18:56:26 poulenc kernel:  [000000000067ec30] 
schedule_timeout+0x78/0xc0
Nov  4 18:56:26 poulenc kernel:  [00000000004c7d68] do_select+0x3d0/0x420
Nov  4 18:56:26 poulenc kernel:  [00000000004eccb8] 
compat_core_sys_select+0x160/0x200
Nov  4 18:56:26 poulenc kernel:  [00000000004eeee4] 
compat_sys_select+0x2c/0x1a0
Nov  4 18:56:26 poulenc kernel:  [000000000002a32c] 0x2a334
Nov  4 18:56:26 poulenc kernel:  [0000000000014910] 0x14918
Nov  4 18:56:26 poulenc kernel: klogd         R  running task        0 
3254      1
Nov  4 18:56:26 poulenc kernel: named         S 00000000004061d4     0 
3270      1
Nov  4 18:56:26 poulenc kernel: Call Trace:
Nov  4 18:56:26 poulenc kernel:  [000000000048b6d0] 
compat_sys_rt_sigsuspend+0x98/0xe0
Nov  4 18:56:26 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:26 poulenc kernel:  [00000000f79bb0b0] 0xf79bb0b8
Nov  4 18:56:26 poulenc kernel: named         S 00000000004833bc     0 
3271      1
Nov  4 18:56:26 poulenc kernel: Call Trace:
Nov  4 18:56:26 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:27 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:27 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:27 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:27 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:27 poulenc kernel: named         S 00000000004833bc     0 
3272      1
Nov  4 18:56:27 poulenc kernel: Call Trace:
Nov  4 18:56:27 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:27 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:27 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:27 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:27 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:27 poulenc kernel: named         S 00000000004833bc     0 
3273      1
Nov  4 18:56:27 poulenc kernel: Call Trace:
Nov  4 18:56:27 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:27 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:27 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:27 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:27 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:27 poulenc kernel: named         S 00000000004833bc     0 
3274      1
Nov  4 18:56:27 poulenc kernel: Call Trace:
Nov  4 18:56:27 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:27 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:27 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:27 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:27 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:27 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:27 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:27 poulenc kernel: named         S 00000000004833bc     0 
3275      1
Nov  4 18:56:27 poulenc kernel: Call Trace:
Nov  4 18:56:27 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:27 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:27 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:27 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:27 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:27 poulenc kernel: named         S 00000000004833bc     0 
3276      1
Nov  4 18:56:27 poulenc kernel: Call Trace:
Nov  4 18:56:27 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:27 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:27 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:27 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:27 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:27 poulenc kernel: named         S 00000000004833bc     0 
3277      1
Nov  4 18:56:27 poulenc kernel: Call Trace:
Nov  4 18:56:27 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:28 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:28 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:28 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:28 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:28 poulenc kernel: named         S 00000000004833bc     0 
3278      1
Nov  4 18:56:28 poulenc kernel: Call Trace:
Nov  4 18:56:28 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:28 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:28 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:28 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:28 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:28 poulenc kernel: named         S 00000000004833bc     0 
3279      1
Nov  4 18:56:28 poulenc kernel: Call Trace:
Nov  4 18:56:28 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:28 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:28 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:28 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:28 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:28 poulenc kernel: named         S 00000000004833bc     0 
3280      1
Nov  4 18:56:28 poulenc kernel: Call Trace:
Nov  4 18:56:28 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:28 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:28 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:28 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:28 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:28 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:28 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:28 poulenc kernel: named         S 00000000004833bc     0 
3281      1
Nov  4 18:56:28 poulenc kernel: Call Trace:
Nov  4 18:56:28 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:28 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:28 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:28 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:28 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:28 poulenc kernel: named         S 00000000004833bc     0 
3282      1
Nov  4 18:56:28 poulenc kernel: Call Trace:
Nov  4 18:56:28 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:28 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:28 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:29 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:29 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:29 poulenc kernel: named         S 00000000004833bc     0 
3283      1
Nov  4 18:56:29 poulenc kernel: Call Trace:
Nov  4 18:56:29 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:29 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:29 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:29 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:29 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:29 poulenc kernel: named         S 00000000004833bc     0 
3284      1
Nov  4 18:56:29 poulenc kernel: Call Trace:
Nov  4 18:56:29 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:29 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:29 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:29 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:29 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:29 poulenc kernel: named         S 00000000004833bc     0 
3285      1
Nov  4 18:56:29 poulenc kernel: Call Trace:
Nov  4 18:56:29 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:29 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:29 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:29 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:29 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:29 poulenc kernel: named         S 00000000004833bc     0 
3286      1
Nov  4 18:56:29 poulenc kernel: Call Trace:
Nov  4 18:56:29 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:29 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:29 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:29 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:29 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:29 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:29 poulenc kernel: named         S 00000000004833bc     0 
3287      1
Nov  4 18:56:29 poulenc kernel: Call Trace:
Nov  4 18:56:29 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:29 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:29 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:29 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:29 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:29 poulenc kernel: named         S 00000000004833bc     0 
3288      1
Nov  4 18:56:29 poulenc kernel: Call Trace:
Nov  4 18:56:29 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:29 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:29 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:29 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:30 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:30 poulenc kernel: named         S 00000000004833bc     0 
3289      1
Nov  4 18:56:30 poulenc kernel: Call Trace:
Nov  4 18:56:30 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:30 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:30 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:30 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:30 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:30 poulenc kernel: named         S 00000000004833bc     0 
3290      1
Nov  4 18:56:30 poulenc kernel: Call Trace:
Nov  4 18:56:30 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:30 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:30 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:30 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:30 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:30 poulenc kernel: named         S 00000000004833bc     0 
3291      1
Nov  4 18:56:30 poulenc kernel: Call Trace:
Nov  4 18:56:30 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:30 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:30 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:30 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:30 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:30 poulenc kernel: named         S 00000000004833bc     0 
3292      1
Nov  4 18:56:30 poulenc kernel: Call Trace:
Nov  4 18:56:30 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:30 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:30 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:30 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:30 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:30 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:30 poulenc kernel: named         S 00000000004833bc     0 
3293      1
Nov  4 18:56:30 poulenc kernel: Call Trace:
Nov  4 18:56:30 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:30 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:30 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:30 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:30 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:30 poulenc kernel: named         S 00000000004833bc     0 
3294      1
Nov  4 18:56:30 poulenc kernel: Call Trace:
Nov  4 18:56:30 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:30 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:31 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:31 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:31 poulenc kernel:  [00000000f7afb2e4] 0xf7afb2ec
Nov  4 18:56:31 poulenc kernel: named         S 00000000004833bc     0 
3295      1
Nov  4 18:56:31 poulenc kernel: Call Trace:
Nov  4 18:56:31 poulenc kernel:  [0000000000482e1c] futex_wait+0x1c4/0x2c0
Nov  4 18:56:31 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:31 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:31 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:31 poulenc kernel:  [00000000f7afb638] 0xf7afb640
Nov  4 18:56:31 poulenc kernel: named         S 00000000004c7d68     0 
3296      1
Nov  4 18:56:31 poulenc kernel: Call Trace:
Nov  4 18:56:31 poulenc kernel:  [000000000067ec30] 
schedule_timeout+0x78/0xc0
Nov  4 18:56:31 poulenc kernel:  [00000000004c7d68] do_select+0x3d0/0x420
Nov  4 18:56:31 poulenc kernel:  [00000000004eccb8] 
compat_core_sys_select+0x160/0x200
Nov  4 18:56:31 poulenc kernel:  [00000000004eeee4] 
compat_sys_select+0x2c/0x1a0
Nov  4 18:56:31 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:31 poulenc kernel:  [00000000f7a60070] 0xf7a60078
Nov  4 18:56:31 poulenc kernel: rpc.bootparam S 00000000004c776c     0 
3518      1
Nov  4 18:56:31 poulenc kernel: Call Trace:
Nov  4 18:56:31 poulenc kernel:  [000000000067ec0c] 
schedule_timeout+0x54/0xc0
Nov  4 18:56:31 poulenc kernel:  [00000000004c776c] do_sys_poll+0x234/0x400
Nov  4 18:56:31 poulenc kernel:  [00000000004c7960] sys_poll+0x28/0x60
Nov  4 18:56:31 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:31 poulenc kernel:  [0000000000011bbc] 0x11bc4
Nov  4 18:56:31 poulenc kernel: hddtemp       S 00000000004c7d68     0 
3576      1
Nov  4 18:56:31 poulenc kernel: Call Trace:
Nov  4 18:56:31 poulenc kernel:  [000000000067ec30] 
schedule_timeout+0x78/0xc0
Nov  4 18:56:31 poulenc kernel:  [00000000004c7d68] do_select+0x3d0/0x420
Nov  4 18:56:31 poulenc kernel:  [00000000004eccb8] 
compat_core_sys_select+0x160/0x200
Nov  4 18:56:31 poulenc kernel:  [00000000004eeee4] 
compat_sys_select+0x2c/0x1a0
Nov  4 18:56:31 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:31 poulenc kernel:  [000000000001223c] 0x12244
Nov  4 18:56:31 poulenc kernel: lockd         S 000000001008aff4     0 
3681      2
Nov  4 18:56:31 poulenc kernel: Call Trace:
Nov  4 18:56:31 poulenc kernel:  [000000000067ec30] 
schedule_timeout+0x78/0xc0
Nov  4 18:56:31 poulenc kernel:  [000000001008aff4] svc_recv+0x21c/0x4e0 
[sunrpc]
Nov  4 18:56:31 poulenc kernel:  [00000000100baef8] lockd+0x120/0x300 
[lockd]
Nov  4 18:56:31 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:32 poulenc kernel:  [0000000010087e10] 
__svc_create_thread+0x118/0x220 [sunrpc]
Nov  4 18:56:32 poulenc kernel: nfsd4         S 0000000000478ce0     0 
3682      2
Nov  4 18:56:32 poulenc kernel: Call Trace:
Nov  4 18:56:32 poulenc kernel:  [0000000000474c5c] worker_thread+0xa4/0xe0
Nov  4 18:56:32 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:32 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:32 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:32 poulenc kernel: nfsd          S 000000001008aff4     0 
3683      2
Nov  4 18:56:32 poulenc kernel: Call Trace:
Nov  4 18:56:32 poulenc kernel:  [000000000067ec0c] 
schedule_timeout+0x54/0xc0
Nov  4 18:56:32 poulenc kernel:  [000000001008aff4] svc_recv+0x21c/0x4e0 
[sunrpc]
Nov  4 18:56:32 poulenc kernel:  [0000000010150aac] nfsd+0xb4/0x300 [nfsd]
Nov  4 18:56:32 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:32 poulenc kernel:  [0000000010087e10] 
__svc_create_thread+0x118/0x220 [sunrpc]
Nov  4 18:56:32 poulenc kernel: rpc.mountd    S 00000000004c7d68     0 
3694      1
Nov  4 18:56:32 poulenc kernel: Call Trace:
Nov  4 18:56:32 poulenc kernel:  [000000000067ec30] 
schedule_timeout+0x78/0xc0
Nov  4 18:56:32 poulenc kernel:  [00000000004c7d68] do_select+0x3d0/0x420
Nov  4 18:56:32 poulenc kernel:  [00000000004eccb8] 
compat_core_sys_select+0x160/0x200
Nov  4 18:56:32 poulenc kernel:  [00000000004eeee4] 
compat_sys_select+0x2c/0x1a0
Nov  4 18:56:32 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:32 poulenc kernel:  [0000000000016708] 0x16710
Nov  4 18:56:32 poulenc kernel: iscsid        S 000000000048c0d4     0 
3785      1
Nov  4 18:56:32 poulenc kernel: Call Trace:
Nov  4 18:56:32 poulenc kernel:  [000000000067ec0c] 
schedule_timeout+0x54/0xc0
Nov  4 18:56:32 poulenc kernel:  [000000000048c0d4] 
compat_sys_nanosleep+0x7c/0xe0
Nov  4 18:56:32 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:32 poulenc kernel:  [00000000f7ec168c] 0xf7ec1694
Nov  4 18:56:32 poulenc kernel: iscsid        S 00000000004c776c     0 
3786      1
Nov  4 18:56:32 poulenc kernel: Call Trace:
Nov  4 18:56:32 poulenc kernel:  [000000000067ec0c] 
schedule_timeout+0x54/0xc0
Nov  4 18:56:32 poulenc kernel:  [00000000004c776c] do_sys_poll+0x234/0x400
Nov  4 18:56:32 poulenc kernel:  [00000000004c7960] sys_poll+0x28/0x60
Nov  4 18:56:32 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:32 poulenc kernel:  [0000000000045bf0] 0x45bf8
Nov  4 18:56:32 poulenc kernel: inetd         S 00000000004c7d68     0 
3802      1
Nov  4 18:56:32 poulenc kernel: Call Trace:
Nov  4 18:56:32 poulenc kernel:  [000000000067ec30] 
schedule_timeout+0x78/0xc0
Nov  4 18:56:32 poulenc kernel:  [00000000004c7d68] do_select+0x3d0/0x420
Nov  4 18:56:32 poulenc kernel:  [00000000004eccb8] 
compat_core_sys_select+0x160/0x200
Nov  4 18:56:32 poulenc kernel:  [00000000004eeee4] 
compat_sys_select+0x2c/0x1a0
Nov  4 18:56:32 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:32 poulenc kernel:  [00000000000155d8] 0x155e0
Nov  4 18:56:32 poulenc kernel: rarpd         S 00000000004c776c     0 
3809      1
Nov  4 18:56:32 poulenc kernel: Call Trace:
Nov  4 18:56:32 poulenc kernel:  [000000000067ec0c] 
schedule_timeout+0x54/0xc0
Nov  4 18:56:33 poulenc kernel:  [00000000004c776c] do_sys_poll+0x234/0x400
Nov  4 18:56:33 poulenc kernel:  [00000000004c7960] sys_poll+0x28/0x60
Nov  4 18:56:33 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:33 poulenc kernel:  [00000000f7da7234] 0xf7da723c
Nov  4 18:56:33 poulenc kernel: smartd        S 000000000048c0d4     0 
3814      1
Nov  4 18:56:33 poulenc kernel: Call Trace:
Nov  4 18:56:33 poulenc kernel:  [000000000067ec0c] 
schedule_timeout+0x54/0xc0
Nov  4 18:56:33 poulenc kernel:  [000000000048c0d4] 
compat_sys_nanosleep+0x7c/0xe0
Nov  4 18:56:33 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:33 poulenc kernel:  [00000000f7c5d68c] 0xf7c5d694
Nov  4 18:56:33 poulenc kernel: snmpd         S 00000000004c7d68     0 
3823      1
Nov  4 18:56:33 poulenc kernel: Call Trace:
Nov  4 18:56:33 poulenc kernel:  [000000000067ec0c] 
schedule_timeout+0x54/0xc0
Nov  4 18:56:33 poulenc kernel:  [00000000004c7d68] do_select+0x3d0/0x420
Nov  4 18:56:33 poulenc kernel:  [00000000004eccb8] 
compat_core_sys_select+0x160/0x200
Nov  4 18:56:33 poulenc kernel:  [00000000004eef74] 
compat_sys_select+0xbc/0x1a0
Nov  4 18:56:33 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:33 poulenc kernel:  [0000000000012e64] 0x12e6c
Nov  4 18:56:33 poulenc kernel: sendmail-mta  S 00000000004c7d68     0 
3880      1
Nov  4 18:56:33 poulenc kernel: Call Trace:
Nov  4 18:56:33 poulenc kernel:  [000000000067ec0c] 
schedule_timeout+0x54/0xc0
Nov  4 18:56:33 poulenc kernel:  [00000000004c7d68] do_select+0x3d0/0x420
Nov  4 18:56:33 poulenc kernel:  [00000000004eccb8] 
compat_core_sys_select+0x160/0x200
Nov  4 18:56:33 poulenc kernel:  [00000000004eef74] 
compat_sys_select+0xbc/0x1a0
Nov  4 18:56:33 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:33 poulenc kernel:  [000000007003b1d8] 0x7003b1e0
Nov  4 18:56:33 poulenc kernel: ntpd          S 00000000004c7d68     0 
3909      1
Nov  4 18:56:33 poulenc kernel: Call Trace:
Nov  4 18:56:33 poulenc kernel:  [000000000067ec30] 
schedule_timeout+0x78/0xc0
Nov  4 18:56:33 poulenc kernel:  [00000000004c7d68] do_select+0x3d0/0x420
Nov  4 18:56:33 poulenc kernel:  [00000000004eccb8] 
compat_core_sys_select+0x160/0x200
Nov  4 18:56:33 poulenc kernel:  [00000000004eeee4] 
compat_sys_select+0x2c/0x1a0
Nov  4 18:56:33 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:33 poulenc kernel:  [000000000001aea8] 0x1aeb0
Nov  4 18:56:33 poulenc kernel: mdadm         S 00000000004c7d68     0 
3922      1
Nov  4 18:56:33 poulenc kernel: Call Trace:
Nov  4 18:56:33 poulenc kernel:  [000000000067ec0c] 
schedule_timeout+0x54/0xc0
Nov  4 18:56:33 poulenc kernel:  [00000000004c7d68] do_select+0x3d0/0x420
Nov  4 18:56:33 poulenc kernel:  [00000000004eccb8] 
compat_core_sys_select+0x160/0x200
Nov  4 18:56:33 poulenc kernel:  [00000000004eef74] 
compat_sys_select+0xbc/0x1a0
Nov  4 18:56:33 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:33 poulenc kernel:  [0000000000016cc0] 0x16cc8
Nov  4 18:56:33 poulenc kernel: rsync         S 00000000004c7d68     0 
3943      1
Nov  4 18:56:34 poulenc kernel: Call Trace:
Nov  4 18:56:34 poulenc kernel:  [000000000067ec30] 
schedule_timeout+0x78/0xc0
Nov  4 18:56:34 poulenc kernel:  [00000000004c7d68] do_select+0x3d0/0x420
Nov  4 18:56:34 poulenc kernel:  [00000000004eccb8] 
compat_core_sys_select+0x160/0x200
Nov  4 18:56:34 poulenc kernel:  [00000000004eeee4] 
compat_sys_select+0x2c/0x1a0
Nov  4 18:56:34 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:34 poulenc kernel:  [0000000000035418] 0x35420
Nov  4 18:56:34 poulenc kernel: atd           S 000000000048c0d4     0 
3959      1
Nov  4 18:56:34 poulenc kernel: Call Trace:
Nov  4 18:56:34 poulenc kernel:  [000000000067ec0c] 
schedule_timeout+0x54/0xc0
Nov  4 18:56:34 poulenc kernel:  [000000000048c0d4] 
compat_sys_nanosleep+0x7c/0xe0
Nov  4 18:56:34 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:34 poulenc kernel:  [00000000f7e6d68c] 0xf7e6d694
Nov  4 18:56:34 poulenc kernel: cron          S 000000000048c0d4     0 
3966      1
Nov  4 18:56:34 poulenc kernel: Call Trace:
Nov  4 18:56:34 poulenc kernel:  [000000000067ec0c] 
schedule_timeout+0x54/0xc0
Nov  4 18:56:34 poulenc kernel:  [000000000048c0d4] 
compat_sys_nanosleep+0x7c/0xe0
Nov  4 18:56:34 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:34 poulenc kernel:  [00000000f7df968c] 0xf7df9694
Nov  4 18:56:34 poulenc kernel: watchdog      S 000000000048c0d4     0 
3976      1
Nov  4 18:56:34 poulenc kernel: Call Trace:
Nov  4 18:56:34 poulenc kernel:  [000000000067ec0c] 
schedule_timeout+0x54/0xc0
Nov  4 18:56:34 poulenc kernel:  [000000000048c0d4] 
compat_sys_nanosleep+0x7c/0xe0
Nov  4 18:56:34 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:34 poulenc kernel:  [00000000f7e4568c] 0xf7e45694
Nov  4 18:56:34 poulenc kernel: apache2       S 00000000004c7d68     0 
3994      1
Nov  4 18:56:34 poulenc kernel: Call Trace:
Nov  4 18:56:34 poulenc kernel:  [000000000067ec0c] 
schedule_timeout+0x54/0xc0
Nov  4 18:56:34 poulenc kernel:  [00000000004c7d68] do_select+0x3d0/0x420
Nov  4 18:56:34 poulenc kernel:  [00000000004eccb8] 
compat_core_sys_select+0x160/0x200
Nov  4 18:56:34 poulenc kernel:  [00000000004eef74] 
compat_sys_select+0xbc/0x1a0
Nov  4 18:56:34 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:34 poulenc kernel:  [00000000f7be6c74] 0xf7be6c7c
Nov  4 18:56:34 poulenc kernel: fail2ban-serv S 00000000004c7d68     0 
4011      1
Nov  4 18:56:34 poulenc kernel: Call Trace:
Nov  4 18:56:34 poulenc kernel:  [000000000067ec0c] 
schedule_timeout+0x54/0xc0
Nov  4 18:56:34 poulenc kernel:  [00000000004c7d68] do_select+0x3d0/0x420
Nov  4 18:56:34 poulenc kernel:  [00000000004eccb8] 
compat_core_sys_select+0x160/0x200
Nov  4 18:56:34 poulenc kernel:  [00000000004eef74] 
compat_sys_select+0xbc/0x1a0
Nov  4 18:56:34 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:34 poulenc kernel:  [00000000f7dc0070] 0xf7dc0078
Nov  4 18:56:34 poulenc kernel: fail2ban-serv S 00000000004c776c     0 
4012      1
Nov  4 18:56:34 poulenc kernel: Call Trace:
Nov  4 18:56:34 poulenc kernel:  [000000000067ec0c] 
schedule_timeout+0x54/0xc0
Nov  4 18:56:34 poulenc kernel:  [00000000004c776c] do_sys_poll+0x234/0x400
Nov  4 18:56:34 poulenc kernel:  [00000000004c7960] sys_poll+0x28/0x60
Nov  4 18:56:34 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:34 poulenc kernel:  [00000000f7dbd0d4] 0xf7dbd0dc
Nov  4 18:56:34 poulenc kernel: fail2ban-serv S 00000000004c7d68     0 
4038      1
Nov  4 18:56:34 poulenc kernel: Call Trace:
Nov  4 18:56:34 poulenc kernel:  [000000000067ec0c] 
schedule_timeout+0x54/0xc0
Nov  4 18:56:34 poulenc kernel:  [00000000004c7d68] do_select+0x3d0/0x420
Nov  4 18:56:35 poulenc kernel:  [00000000004eccb8] 
compat_core_sys_select+0x160/0x200
Nov  4 18:56:35 poulenc kernel:  [00000000004eef74] 
compat_sys_select+0xbc/0x1a0
Nov  4 18:56:35 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:35 poulenc kernel:  [00000000f7dc0070] 0xf7dc0078
Nov  4 18:56:35 poulenc kernel: fail2ban-serv S 00000000004c7d68     0 
4039      1
Nov  4 18:56:35 poulenc kernel: Call Trace:
Nov  4 18:56:35 poulenc kernel:  [000000000067ec0c] 
schedule_timeout+0x54/0xc0
Nov  4 18:56:35 poulenc kernel:  [00000000004c7d68] do_select+0x3d0/0x420
Nov  4 18:56:35 poulenc kernel:  [00000000004eccb8] 
compat_core_sys_select+0x160/0x200
Nov  4 18:56:35 poulenc kernel:  [00000000004eef74] 
compat_sys_select+0xbc/0x1a0
Nov  4 18:56:35 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:35 poulenc kernel:  [00000000f7dc0070] 0xf7dc0078
Nov  4 18:56:35 poulenc kernel: apache2       S 00000000004ea8fc     0 
4071   3994
Nov  4 18:56:35 poulenc kernel: Call Trace:
Nov  4 18:56:35 poulenc kernel:  [000000000067ec30] 
schedule_timeout+0x78/0xc0
Nov  4 18:56:35 poulenc kernel:  [00000000004ea8fc] 
sys_epoll_wait+0x144/0x480
Nov  4 18:56:35 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:35 poulenc kernel:  [00000000f7be2710] 0xf7be2718
Nov  4 18:56:35 poulenc kernel: apache2       S 00000000004061d4     0 
4072   3994
Nov  4 18:56:35 poulenc kernel: Call Trace:
Nov  4 18:56:35 poulenc kernel:  [00000000005333bc] 
sys_semtimedop+0x564/0x660
Nov  4 18:56:35 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:35 poulenc kernel:  [00000000f7bdaea8] 0xf7bdaeb0
Nov  4 18:56:35 poulenc kernel: apache2       S 00000000004061d4     0 
4073   3994
Nov  4 18:56:35 poulenc kernel: Call Trace:
Nov  4 18:56:35 poulenc kernel:  [00000000005333bc] 
sys_semtimedop+0x564/0x660
Nov  4 18:56:35 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:35 poulenc kernel:  [00000000f7bdaea8] 0xf7bdaeb0
Nov  4 18:56:35 poulenc kernel: apache2       S 00000000004061d4     0 
4074   3994
Nov  4 18:56:35 poulenc kernel: Call Trace:
Nov  4 18:56:35 poulenc kernel:  [00000000005333bc] 
sys_semtimedop+0x564/0x660
Nov  4 18:56:35 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:35 poulenc kernel:  [00000000f7bdaea8] 0xf7bdaeb0
Nov  4 18:56:35 poulenc kernel: apache2       S 00000000004061d4     0 
4075   3994
Nov  4 18:56:35 poulenc kernel: Call Trace:
Nov  4 18:56:35 poulenc kernel:  [00000000005333bc] 
sys_semtimedop+0x564/0x660
Nov  4 18:56:35 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:35 poulenc kernel:  [00000000f7bdaea8] 0xf7bdaeb0
Nov  4 18:56:35 poulenc kernel: login         S 000000000048bda8     0 
4146      1
Nov  4 18:56:35 poulenc kernel: Call Trace:
Nov  4 18:56:35 poulenc kernel:  [00000000004656dc] do_wait+0x264/0xda0
Nov  4 18:56:36 poulenc kernel:  [000000000048bda8] 
compat_sys_wait4+0xb0/0xc0
Nov  4 18:56:36 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:36 poulenc kernel:  [00000000f7df3234] 0xf7df323c
Nov  4 18:56:36 poulenc kernel: bash          R  running task        0 
4173   4146
Nov  4 18:56:36 poulenc kernel: sshd          S 00000000004c7d68     0 
4330      1
Nov  4 18:56:36 poulenc kernel: Call Trace:
Nov  4 18:56:36 poulenc kernel:  [000000000067ec30] 
schedule_timeout+0x78/0xc0
Nov  4 18:56:36 poulenc kernel:  [00000000004c7d68] do_select+0x3d0/0x420
Nov  4 18:56:36 poulenc kernel:  [00000000004eccb8] 
compat_core_sys_select+0x160/0x200
Nov  4 18:56:36 poulenc kernel:  [00000000004eeee4] 
compat_sys_select+0x2c/0x1a0
Nov  4 18:56:36 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:36 poulenc kernel:  [0000000070017e1c] 0x70017e24
Nov  4 18:56:36 poulenc kernel: md_d0_raid5   R  running task        0 
4462      2
Nov  4 18:56:36 poulenc kernel: ietd          S 000000000067dac4     0 
8227      1
Nov  4 18:56:36 poulenc kernel: Call Trace:
Nov  4 18:56:36 poulenc kernel:  [000000000067d9dc] 
__down_interruptible+0xa4/0x1c0
Nov  4 18:56:36 poulenc kernel:  [000000000067dac4] 
__down_interruptible+0x18c/0x1c0
Nov  4 18:56:36 poulenc kernel:  [00000000102204d0] ioctl+0x58/0x5e0 
[iscsi_trgt]
Nov  4 18:56:36 poulenc kernel:  [00000000004f0484] 
compat_sys_ioctl+0x14c/0x460
Nov  4 18:56:36 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:36 poulenc kernel:  [000000000001532c] 0x15334
Nov  4 18:56:36 poulenc kernel: istd1         R  running task        0 
8228      2
Nov  4 18:56:36 poulenc kernel: istiod1       D 00000000102262c8     0 
8229      2
Nov  4 18:56:36 poulenc kernel: Call Trace:
Nov  4 18:56:36 poulenc kernel:  [000000000067e4cc] 
wait_for_completion+0x74/0xe0
Nov  4 18:56:36 poulenc kernel:  [00000000102262c8] 
blockio_make_request+0x1d0/0x24c [iscsi_trgt]
Nov  4 18:56:36 poulenc kernel:  [000000001021a140] tio_write+0x28/0x80 
[iscsi_trgt]
Nov  4 18:56:36 poulenc kernel:  [0000000010223df8] 
build_write_response+0x40/0xe0 [iscsi_trgt]
Nov  4 18:56:36 poulenc kernel:  [000000001021e444] 
send_scsi_rsp+0xc/0x120 [iscsi_trgt]
Nov  4 18:56:36 poulenc kernel:  [0000000010223c30] 
disk_execute_cmnd+0x158/0x220 [iscsi_trgt]
Nov  4 18:56:36 poulenc kernel:  [0000000010220330] 
worker_thread+0x118/0x1a0 [iscsi_trgt]
Nov  4 18:56:36 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:36 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:36 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:36 poulenc kernel: istiod1       D 00000000102262c8     0 
8230      2
Nov  4 18:56:36 poulenc kernel: Call Trace:
Nov  4 18:56:36 poulenc kernel:  [000000000067e4cc] 
wait_for_completion+0x74/0xe0
Nov  4 18:56:36 poulenc kernel:  [00000000102262c8] 
blockio_make_request+0x1d0/0x24c [iscsi_trgt]
Nov  4 18:56:36 poulenc kernel:  [000000001021a140] tio_write+0x28/0x80 
[iscsi_trgt]
Nov  4 18:56:36 poulenc kernel:  [0000000010223df8] 
build_write_response+0x40/0xe0 [iscsi_trgt]
Nov  4 18:56:36 poulenc kernel:  [000000001021e444] 
send_scsi_rsp+0xc/0x120 [iscsi_trgt]
Nov  4 18:56:36 poulenc kernel:  [0000000010223c30] 
disk_execute_cmnd+0x158/0x220 [iscsi_trgt]
Nov  4 18:56:36 poulenc kernel:  [0000000010220330] 
worker_thread+0x118/0x1a0 [iscsi_trgt]
Nov  4 18:56:37 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:37 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:37 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:37 poulenc kernel: istiod1       D 00000000102262c8     0 
8231      2
Nov  4 18:56:37 poulenc kernel: Call Trace:
Nov  4 18:56:37 poulenc kernel:  [000000000067e4cc] 
wait_for_completion+0x74/0xe0
Nov  4 18:56:37 poulenc kernel:  [00000000102262c8] 
blockio_make_request+0x1d0/0x24c [iscsi_trgt]
Nov  4 18:56:37 poulenc kernel:  [000000001021a140] tio_write+0x28/0x80 
[iscsi_trgt]
Nov  4 18:56:37 poulenc kernel:  [0000000010223df8] 
build_write_response+0x40/0xe0 [iscsi_trgt]
Nov  4 18:56:37 poulenc kernel:  [000000001021e444] 
send_scsi_rsp+0xc/0x120 [iscsi_trgt]
Nov  4 18:56:37 poulenc kernel:  [0000000010223c30] 
disk_execute_cmnd+0x158/0x220 [iscsi_trgt]
Nov  4 18:56:37 poulenc kernel:  [0000000010220330] 
worker_thread+0x118/0x1a0 [iscsi_trgt]
Nov  4 18:56:37 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:37 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:37 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:37 poulenc kernel: istiod1       D 00000000102262c8     0 
8232      2
Nov  4 18:56:37 poulenc kernel: Call Trace:
Nov  4 18:56:37 poulenc kernel:  [000000000067e4cc] 
wait_for_completion+0x74/0xe0
Nov  4 18:56:37 poulenc kernel:  [00000000102262c8] 
blockio_make_request+0x1d0/0x24c [iscsi_trgt]
Nov  4 18:56:37 poulenc kernel:  [000000001021a140] tio_write+0x28/0x80 
[iscsi_trgt]
Nov  4 18:56:37 poulenc kernel:  [0000000010223df8] 
build_write_response+0x40/0xe0 [iscsi_trgt]
Nov  4 18:56:37 poulenc kernel:  [000000001021e444] 
send_scsi_rsp+0xc/0x120 [iscsi_trgt]
Nov  4 18:56:37 poulenc kernel:  [0000000010223c30] 
disk_execute_cmnd+0x158/0x220 [iscsi_trgt]
Nov  4 18:56:37 poulenc kernel:  [0000000010220330] 
worker_thread+0x118/0x1a0 [iscsi_trgt]
Nov  4 18:56:37 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:37 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:37 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:37 poulenc kernel: istiod1       D 00000000102262c8     0 
8233      2
Nov  4 18:56:37 poulenc kernel: Call Trace:
Nov  4 18:56:37 poulenc kernel:  [000000000067e4cc] 
wait_for_completion+0x74/0xe0
Nov  4 18:56:37 poulenc kernel:  [00000000102262c8] 
blockio_make_request+0x1d0/0x24c [iscsi_trgt]
Nov  4 18:56:37 poulenc kernel:  [000000001021a140] tio_write+0x28/0x80 
[iscsi_trgt]
Nov  4 18:56:37 poulenc kernel:  [0000000010223df8] 
build_write_response+0x40/0xe0 [iscsi_trgt]
Nov  4 18:56:37 poulenc kernel:  [000000001021e444] 
send_scsi_rsp+0xc/0x120 [iscsi_trgt]
Nov  4 18:56:37 poulenc kernel:  [0000000010223c30] 
disk_execute_cmnd+0x158/0x220 [iscsi_trgt]
Nov  4 18:56:37 poulenc kernel:  [0000000010220330] 
worker_thread+0x118/0x1a0 [iscsi_trgt]
Nov  4 18:56:37 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:37 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:37 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:37 poulenc kernel: istiod1       D 00000000102262c8     0 
8234      2
Nov  4 18:56:37 poulenc kernel: Call Trace:
Nov  4 18:56:37 poulenc kernel:  [000000000067e4cc] 
wait_for_completion+0x74/0xe0
Nov  4 18:56:37 poulenc kernel:  [00000000102262c8] 
blockio_make_request+0x1d0/0x24c [iscsi_trgt]
Nov  4 18:56:37 poulenc kernel:  [000000001021a140] tio_write+0x28/0x80 
[iscsi_trgt]
Nov  4 18:56:37 poulenc kernel:  [0000000010223df8] 
build_write_response+0x40/0xe0 [iscsi_trgt]
Nov  4 18:56:37 poulenc kernel:  [000000001021e444] 
send_scsi_rsp+0xc/0x120 [iscsi_trgt]
Nov  4 18:56:37 poulenc kernel:  [0000000010223c30] 
disk_execute_cmnd+0x158/0x220 [iscsi_trgt]
Nov  4 18:56:37 poulenc kernel:  [0000000010220330] 
worker_thread+0x118/0x1a0 [iscsi_trgt]
Nov  4 18:56:38 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:38 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:38 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:38 poulenc kernel: istiod1       D 00000000102262c8     0 
8235      2
Nov  4 18:56:38 poulenc kernel: Call Trace:
Nov  4 18:56:38 poulenc kernel:  [000000000067e4cc] 
wait_for_completion+0x74/0xe0
Nov  4 18:56:38 poulenc kernel:  [00000000102262c8] 
blockio_make_request+0x1d0/0x24c [iscsi_trgt]
Nov  4 18:56:38 poulenc kernel:  [000000001021a140] tio_write+0x28/0x80 
[iscsi_trgt]
Nov  4 18:56:38 poulenc kernel:  [0000000010223df8] 
build_write_response+0x40/0xe0 [iscsi_trgt]
Nov  4 18:56:38 poulenc kernel:  [000000001021e444] 
send_scsi_rsp+0xc/0x120 [iscsi_trgt]
Nov  4 18:56:38 poulenc kernel:  [0000000010223c30] 
disk_execute_cmnd+0x158/0x220 [iscsi_trgt]
Nov  4 18:56:38 poulenc kernel:  [0000000010220330] 
worker_thread+0x118/0x1a0 [iscsi_trgt]
Nov  4 18:56:38 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:38 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:38 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:38 poulenc kernel: istiod1       D 00000000102262c8     0 
8236      2
Nov  4 18:56:38 poulenc kernel: Call Trace:
Nov  4 18:56:38 poulenc kernel:  [000000000067e4cc] 
wait_for_completion+0x74/0xe0
Nov  4 18:56:38 poulenc kernel:  [00000000102262c8] 
blockio_make_request+0x1d0/0x24c [iscsi_trgt]
Nov  4 18:56:38 poulenc kernel:  [000000001021a140] tio_write+0x28/0x80 
[iscsi_trgt]
Nov  4 18:56:38 poulenc kernel:  [0000000010223df8] 
build_write_response+0x40/0xe0 [iscsi_trgt]
Nov  4 18:56:38 poulenc kernel:  [000000001021e444] 
send_scsi_rsp+0xc/0x120 [iscsi_trgt]
Nov  4 18:56:38 poulenc kernel:  [0000000010223c30] 
disk_execute_cmnd+0x158/0x220 [iscsi_trgt]
Nov  4 18:56:38 poulenc kernel:  [0000000010220330] 
worker_thread+0x118/0x1a0 [iscsi_trgt]
Nov  4 18:56:38 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:38 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:38 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:38 poulenc kernel: identd        S 00000000004c776c     0 
8394   3802
Nov  4 18:56:38 poulenc kernel: Call Trace:
Nov  4 18:56:38 poulenc kernel:  [000000000067ec0c] 
schedule_timeout+0x54/0xc0
Nov  4 18:56:38 poulenc kernel:  [00000000004c776c] do_sys_poll+0x234/0x400
Nov  4 18:56:38 poulenc kernel:  [00000000004c7960] sys_poll+0x28/0x60
Nov  4 18:56:38 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:38 poulenc kernel:  [00000000f7ce50d4] 0xf7ce50dc
Nov  4 18:56:38 poulenc kernel: identd        S 00000000004833bc     0 
8395   3802
Nov  4 18:56:38 poulenc kernel: Call Trace:
Nov  4 18:56:38 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:38 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:38 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:38 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:38 poulenc kernel:  [00000000f7ee72e4] 0xf7ee72ec
Nov  4 18:56:38 poulenc kernel: identd        S 00000000004833bc     0 
8396   3802
Nov  4 18:56:38 poulenc kernel: Call Trace:
Nov  4 18:56:38 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:38 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:38 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:38 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:38 poulenc kernel:  [00000000f7ee72e4] 0xf7ee72ec
Nov  4 18:56:38 poulenc kernel: identd        S 00000000004833bc     0 
8397   3802
Nov  4 18:56:38 poulenc kernel: Call Trace:
Nov  4 18:56:39 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:39 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:39 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:39 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:39 poulenc kernel:  [00000000f7ee72e4] 0xf7ee72ec
Nov  4 18:56:39 poulenc kernel: identd        S 00000000004833bc     0 
8398   3802
Nov  4 18:56:39 poulenc kernel: Call Trace:
Nov  4 18:56:39 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:39 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:39 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:39 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:39 poulenc kernel:  [00000000f7ee72e4] 0xf7ee72ec
Nov  4 18:56:39 poulenc kernel: identd        S 00000000004833bc     0 
8399   3802
Nov  4 18:56:39 poulenc kernel: Call Trace:
Nov  4 18:56:39 poulenc kernel:  [0000000000482ec0] futex_wait+0x268/0x2c0
Nov  4 18:56:39 poulenc kernel:  [00000000004833bc] do_futex+0x64/0xbc0
Nov  4 18:56:39 poulenc kernel:  [00000000004843fc] 
compat_sys_futex+0x64/0x120
Nov  4 18:56:39 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:39 poulenc kernel:  [00000000f7ee72e4] 0xf7ee72ec
Nov  4 18:56:39 poulenc kernel: watchdog      ? 0000000000466d4c     0 
8412   3976
Nov  4 18:56:39 poulenc kernel: Call Trace:
Nov  4 18:56:39 poulenc kernel:  [00000000004669f0] do_exit+0x6d8/0xa00
Nov  4 18:56:39 poulenc kernel:  [0000000000466d4c] do_group_exit+0x34/0xa0
Nov  4 18:56:39 poulenc kernel:  [00000000004061d4] 
linux_sparc_syscall32+0x3c/0x40
Nov  4 18:56:39 poulenc kernel:  [000000000001b264] 0x1b26c
Nov  4 18:56:46 poulenc kernel: SysRq : Show Blocked State
Nov  4 18:56:46 poulenc kernel:   task                        PC stack 
  pid father
Nov  4 18:56:46 poulenc kernel: istiod1       D 00000000102262c8     0 
8229      2
Nov  4 18:56:46 poulenc kernel: Call Trace:
Nov  4 18:56:46 poulenc kernel:  [000000000067e4cc] 
wait_for_completion+0x74/0xe0
Nov  4 18:56:46 poulenc kernel:  [00000000102262c8] 
blockio_make_request+0x1d0/0x24c [iscsi_trgt]
Nov  4 18:56:46 poulenc kernel:  [000000001021a140] tio_write+0x28/0x80 
[iscsi_trgt]
Nov  4 18:56:46 poulenc kernel:  [0000000010223df8] 
build_write_response+0x40/0xe0 [iscsi_trgt]
Nov  4 18:56:47 poulenc kernel:  [000000001021e444] 
send_scsi_rsp+0xc/0x120 [iscsi_trgt]
Nov  4 18:56:47 poulenc kernel:  [0000000010223c30] 
disk_execute_cmnd+0x158/0x220 [iscsi_trgt]
Nov  4 18:56:47 poulenc kernel:  [0000000010220330] 
worker_thread+0x118/0x1a0 [iscsi_trgt]
Nov  4 18:56:47 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:47 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:47 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:47 poulenc kernel: istiod1       D 00000000102262c8     0 
8230      2
Nov  4 18:56:47 poulenc kernel: Call Trace:
Nov  4 18:56:47 poulenc kernel:  [000000000067e4cc] 
wait_for_completion+0x74/0xe0
Nov  4 18:56:47 poulenc kernel:  [00000000102262c8] 
blockio_make_request+0x1d0/0x24c [iscsi_trgt]
Nov  4 18:56:47 poulenc kernel:  [000000001021a140] tio_write+0x28/0x80 
[iscsi_trgt]
Nov  4 18:56:47 poulenc kernel:  [0000000010223df8] 
build_write_response+0x40/0xe0 [iscsi_trgt]
Nov  4 18:56:47 poulenc kernel:  [000000001021e444] 
send_scsi_rsp+0xc/0x120 [iscsi_trgt]
Nov  4 18:56:47 poulenc kernel:  [0000000010223c30] 
disk_execute_cmnd+0x158/0x220 [iscsi_trgt]
Nov  4 18:56:47 poulenc kernel:  [0000000010220330] 
worker_thread+0x118/0x1a0 [iscsi_trgt]
Nov  4 18:56:47 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:47 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:47 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:47 poulenc kernel: istiod1       D 00000000102262c8     0 
8231      2
Nov  4 18:56:47 poulenc kernel: Call Trace:
Nov  4 18:56:47 poulenc kernel:  [000000000067e4cc] 
wait_for_completion+0x74/0xe0
Nov  4 18:56:47 poulenc kernel:  [00000000102262c8] 
blockio_make_request+0x1d0/0x24c [iscsi_trgt]
Nov  4 18:56:47 poulenc kernel:  [000000001021a140] tio_write+0x28/0x80 
[iscsi_trgt]
Nov  4 18:56:47 poulenc kernel:  [0000000010223df8] 
build_write_response+0x40/0xe0 [iscsi_trgt]
Nov  4 18:56:47 poulenc kernel:  [000000001021e444] 
send_scsi_rsp+0xc/0x120 [iscsi_trgt]
Nov  4 18:56:47 poulenc kernel:  [0000000010223c30] 
disk_execute_cmnd+0x158/0x220 [iscsi_trgt]
Nov  4 18:56:47 poulenc kernel:  [0000000010220330] 
worker_thread+0x118/0x1a0 [iscsi_trgt]
Nov  4 18:56:47 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:47 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:47 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:47 poulenc kernel: istiod1       D 00000000102262c8     0 
8232      2
Nov  4 18:56:47 poulenc kernel: Call Trace:
Nov  4 18:56:47 poulenc kernel:  [000000000067e4cc] 
wait_for_completion+0x74/0xe0
Nov  4 18:56:47 poulenc kernel:  [00000000102262c8] 
blockio_make_request+0x1d0/0x24c [iscsi_trgt]
Nov  4 18:56:47 poulenc kernel:  [000000001021a140] tio_write+0x28/0x80 
[iscsi_trgt]
Nov  4 18:56:47 poulenc kernel:  [0000000010223df8] 
build_write_response+0x40/0xe0 [iscsi_trgt]
Nov  4 18:56:47 poulenc kernel:  [000000001021e444] 
send_scsi_rsp+0xc/0x120 [iscsi_trgt]
Nov  4 18:56:48 poulenc kernel:  [0000000010223c30] 
disk_execute_cmnd+0x158/0x220 [iscsi_trgt]
Nov  4 18:56:48 poulenc kernel:  [0000000010220330] 
worker_thread+0x118/0x1a0 [iscsi_trgt]
Nov  4 18:56:48 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:48 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:48 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:48 poulenc kernel: istiod1       D 00000000102262c8     0 
8233      2
Nov  4 18:56:48 poulenc kernel: Call Trace:
Nov  4 18:56:48 poulenc kernel:  [000000000067e4cc] 
wait_for_completion+0x74/0xe0
Nov  4 18:56:48 poulenc kernel:  [00000000102262c8] 
blockio_make_request+0x1d0/0x24c [iscsi_trgt]
Nov  4 18:56:48 poulenc kernel:  [000000001021a140] tio_write+0x28/0x80 
[iscsi_trgt]
Nov  4 18:56:48 poulenc kernel:  [0000000010223df8] 
build_write_response+0x40/0xe0 [iscsi_trgt]
Nov  4 18:56:48 poulenc kernel:  [000000001021e444] 
send_scsi_rsp+0xc/0x120 [iscsi_trgt]
Nov  4 18:56:48 poulenc kernel:  [0000000010223c30] 
disk_execute_cmnd+0x158/0x220 [iscsi_trgt]
Nov  4 18:56:48 poulenc kernel:  [0000000010220330] 
worker_thread+0x118/0x1a0 [iscsi_trgt]
Nov  4 18:56:48 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:48 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:48 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:48 poulenc kernel: istiod1       D 00000000102262c8     0 
8234      2
Nov  4 18:56:48 poulenc kernel: Call Trace:
Nov  4 18:56:48 poulenc kernel:  [000000000067e4cc] 
wait_for_completion+0x74/0xe0
Nov  4 18:56:48 poulenc kernel:  [00000000102262c8] 
blockio_make_request+0x1d0/0x24c [iscsi_trgt]
Nov  4 18:56:48 poulenc kernel:  [000000001021a140] tio_write+0x28/0x80 
[iscsi_trgt]
Nov  4 18:56:48 poulenc kernel:  [0000000010223df8] 
build_write_response+0x40/0xe0 [iscsi_trgt]
Nov  4 18:56:48 poulenc kernel:  [000000001021e444] 
send_scsi_rsp+0xc/0x120 [iscsi_trgt]
Nov  4 18:56:48 poulenc kernel:  [0000000010223c30] 
disk_execute_cmnd+0x158/0x220 [iscsi_trgt]
Nov  4 18:56:48 poulenc kernel:  [0000000010220330] 
worker_thread+0x118/0x1a0 [iscsi_trgt]
Nov  4 18:56:48 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:48 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:48 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:48 poulenc kernel: istiod1       D 00000000102262c8     0 
8235      2
Nov  4 18:56:48 poulenc kernel: Call Trace:
Nov  4 18:56:48 poulenc kernel:  [000000000067e4cc] 
wait_for_completion+0x74/0xe0
Nov  4 18:56:48 poulenc kernel:  [00000000102262c8] 
blockio_make_request+0x1d0/0x24c [iscsi_trgt]
Nov  4 18:56:48 poulenc kernel:  [000000001021a140] tio_write+0x28/0x80 
[iscsi_trgt]
Nov  4 18:56:48 poulenc kernel:  [0000000010223df8] 
build_write_response+0x40/0xe0 [iscsi_trgt]
Nov  4 18:56:48 poulenc kernel:  [000000001021e444] 
send_scsi_rsp+0xc/0x120 [iscsi_trgt]
Nov  4 18:56:48 poulenc kernel:  [0000000010223c30] 
disk_execute_cmnd+0x158/0x220 [iscsi_trgt]
Nov  4 18:56:48 poulenc kernel:  [0000000010220330] 
worker_thread+0x118/0x1a0 [iscsi_trgt]
Nov  4 18:56:48 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:48 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:48 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
Nov  4 18:56:49 poulenc kernel: istiod1       D 00000000102262c8     0 
8236      2
Nov  4 18:56:49 poulenc kernel: Call Trace:
Nov  4 18:56:49 poulenc kernel:  [000000000067e4cc] 
wait_for_completion+0x74/0xe0
Nov  4 18:56:49 poulenc kernel:  [00000000102262c8] 
blockio_make_request+0x1d0/0x24c [iscsi_trgt]
Nov  4 18:56:49 poulenc kernel:  [000000001021a140] tio_write+0x28/0x80 
[iscsi_trgt]
Nov  4 18:56:49 poulenc kernel:  [0000000010223df8] 
build_write_response+0x40/0xe0 [iscsi_trgt]
Nov  4 18:56:49 poulenc kernel:  [000000001021e444] 
send_scsi_rsp+0xc/0x120 [iscsi_trgt]
Nov  4 18:56:49 poulenc kernel:  [0000000010223c30] 
disk_execute_cmnd+0x158/0x220 [iscsi_trgt]
Nov  4 18:56:49 poulenc kernel:  [0000000010220330] 
worker_thread+0x118/0x1a0 [iscsi_trgt]
Nov  4 18:56:49 poulenc kernel:  [0000000000478ce0] kthread+0x48/0x80
Nov  4 18:56:49 poulenc kernel:  [00000000004273d0] kernel_thread+0x38/0x60
Nov  4 18:56:49 poulenc kernel:  [0000000000478f80] kthreadd+0x148/0x1c0
