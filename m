Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 04 Nov 2007 07:21:07 -0800 (PST)
Received: from hobbit.corpit.ru (hobbit.corpit.ru [81.13.94.6])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA4FL0Fc021016
	for <xfs@oss.sgi.com>; Sun, 4 Nov 2007 07:21:03 -0800
Message-ID: <472DDD78.7040002@msgid.tls.msk.ru>
Date: Sun, 04 Nov 2007 17:55:52 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
MIME-Version: 1.0
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan> <472DBF8C.2060508@msgid.tls.msk.ru> <Pine.LNX.4.64.0711040750020.3956@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0711040750020.3956@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com

Justin Piszcz wrote:
> On Sun, 4 Nov 2007, Michael Tokarev wrote:
[]
>> The next time you come across something like that, do a SysRq-T dump and
>> post that.  It shows a stack trace of all processes - and in particular,
>> where exactly each task is stuck.

> Yes I got it before I rebooted, ran that and then dmesg > file.
> 
> Here it is:
> 
> [1172609.665902]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
> [1172609.668768]  ffffffff80747dc0 ffff81015c3aa918 ffff810091c899b4 ffff810091c899a8

That's only partial list.  All the kernel threads - which are most important
in this context - aren't shown.  You ran out of dmesg buffer, and the most
interesting entries was at the beginning.  If your /var/log partition is
working, the stuff should be in /var/log/kern.log or equivalent.  If it's
not working, there is a way to capture the info still, by stopping syslogd,
cat'ing /proc/kmsg to some tmpfs file and scp'ing it elsewhere.

/mjt
