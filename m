Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 04 Nov 2007 14:01:58 -0800 (PST)
Received: from mail.ukfsn.org (s2.ukfsn.org [217.158.120.143])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA4M1nsb022151
	for <xfs@oss.sgi.com>; Sun, 4 Nov 2007 14:01:50 -0800
Message-ID: <472E3C4B.5010904@dgreaves.com>
Date: Sun, 04 Nov 2007 21:40:27 +0000
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan> <472DBF8C.2060508@msgid.tls.msk.ru> <Pine.LNX.4.64.0711040750020.3956@p34.internal.lan> <472DDD78.7040002@msgid.tls.msk.ru>
In-Reply-To: <472DDD78.7040002@msgid.tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1
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

or netconsole is actually pretty easy and incredibly useful in this kind of
situation even if there's no disk at all :)

David
