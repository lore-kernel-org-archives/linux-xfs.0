Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 19 Jan 2008 13:02:13 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0JL1uBD018260
	for <xfs@oss.sgi.com>; Sat, 19 Jan 2008 13:02:00 -0800
Received: from sovereign.computergmbh.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 21A6ACA0C27
	for <xfs@oss.sgi.com>; Sat, 19 Jan 2008 13:02:15 -0800 (PST)
Received: from sovereign.computergmbh.de (sovereign.computergmbh.de [85.214.69.204]) by cuda.sgi.com with ESMTP id KEme1V7f82i43Y1Z for <xfs@oss.sgi.com>; Sat, 19 Jan 2008 13:02:15 -0800 (PST)
Date: Sat, 19 Jan 2008 22:01:41 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Volume too big
In-Reply-To: <47926087.3020600@sandeen.net>
Message-ID: <Pine.LNX.4.64.0801192200390.4780@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801191650260.4780@fbirervta.pbzchgretzou.qr>
 <4792223E.7080805@sandeen.net> <Pine.LNX.4.64.0801191808100.4780@fbirervta.pbzchgretzou.qr>
 <47926087.3020600@sandeen.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com


On Jan 19 2008 14:41, Eric Sandeen wrote:
>Jan Engelhardt wrote:
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
>> 
>> Hm, JFS fails too.
>> But btrfs 0.11 can mount it.
>
>It's possible that btrfs can cope with this somehow - but also quite
>possible that it's just missing the right checks :)
>
I am not sure why Linux would be limited to 16 TB. If LBD is on,
things are 64 bit, so I would expect to have at least access to
2 exabyte.
