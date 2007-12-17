Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Dec 2007 05:28:55 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBHDSjrx007357
	for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 05:28:47 -0800
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E089C116EDAD
	for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 05:28:55 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by cuda.sgi.com with ESMTP id MpGGme7IF4CtuVP0 for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 05:28:55 -0800 (PST)
Received: from nb27steigerwald.qs.de (unknown [212.204.70.254])
	by mail.lichtvoll.de (Postfix) with ESMTP id 1C3E95AE80
	for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 14:29:00 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Installing grub onto a system with XFS root fs
Date: Mon, 17 Dec 2007 14:28:51 +0100
References: <20071217004945.GA13335@jdc.jasonjgw.net> (sfid-20071217_102458_420553_1ADB1FF4)
In-Reply-To: <20071217004945.GA13335@jdc.jasonjgw.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712171428.51831.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Hello Jason,

Am Montag 17 Dezember 2007 schrieb Jason White:
> I am trying to install Grub onto a system with a single XFS partition
> serving as both / and /boot.
>
> Distribution: Debian Unstable (Sid).
> Architecture: x86_64
>
> When I run grub-install I get:
> Searching for GRUB installation directory ... found: /boot/grub
> Due to a bug in xfs_freeze, the following command might produce a
> segmentation fault when /boot/grub is not in an XFS filesystem. This
> error is harmless and can be ignored.
>
> At this point the install script hangs and the only way to recover is
> to reboot the machine (with a hard reset). Needless to say, Grub isn't
> installed.
>
> Any suggestions?

Using grub shell manually always worked for me:

- grub
- find /boot/grub/menu.lst
- root <result from above command>
- setup <place to install too> for example (hd0,0) for first harddisks MBR

Remember to copy over the contents of /usr/lib/grub/i386-pc to /boot 
before you do a manual installation.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
