Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 14:04:23 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0KM4IvC006036
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 14:04:20 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C8EFF53DC75
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 14:04:33 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 75RPSSNwbmjKlQLm for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 14:04:33 -0800 (PST)
Message-ID: <4793C54D.7060003@sandeen.net>
Date: Sun, 20 Jan 2008 16:03:57 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Volume too big
References: <Pine.LNX.4.64.0801191650260.4780@fbirervta.pbzchgretzou.qr> <4792223E.7080805@sandeen.net> <Pine.LNX.4.64.0801191808100.4780@fbirervta.pbzchgretzou.qr> <47926087.3020600@sandeen.net>
In-Reply-To: <47926087.3020600@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:
> Jan Engelhardt wrote:
>> On Jan 19 2008 10:15, Eric Sandeen wrote:
>>>> 16:51 localhost:~ # strace -e mount mount /dev/md0 /mnt
>>>> mount("/dev/md0", "/mnt", "xfs", MS_MGC_VAL, NULL) = -1 E2BIG (Argument 
>>>> list too long)
>>>> mount: Argument list too long
>>>>
>>>> 16:51 localhost:~ # uname -a
>>>> Linux localhost 2.6.23.14-ccj63-regular #1 SMP 2007/10/26 14:17:15 UTC 
>>>> i686 athlon i386 GNU/Linux
>>>>
>>>> CONFIG_LBD=y. Do I need an extra flag for mkfs?
>>> Nope; this is probably that you can't do > 16T on a 32 bit box (core
>>> linux restriction, pretty much)
>>> get an x86_64, I think :)
>> Hm, JFS fails too.
>> But btrfs 0.11 can mount it.
> 
> It's possible that btrfs can cope with this somehow - but also quite
> possible that it's just missing the right checks :)

re: btrfs...

[15:50]  <mason> sandeen_: mkfs will work on >16TB, but the limiting
factor is the 32 bit radix tree ops on the page cache
[15:50]  <mason> so yes, it is missing a check ;)

:)

-Eric
