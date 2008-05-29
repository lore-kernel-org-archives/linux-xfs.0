Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 01:03:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4T83tQO013554
	for <linux-xfs@oss.sgi.com>; Thu, 29 May 2008 01:03:55 -0700
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B21331C99D8
	for <linux-xfs@oss.sgi.com>; Thu, 29 May 2008 01:04:46 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by cuda.sgi.com with ESMTP id 9F2lE9AQMHmsKcbl for <linux-xfs@oss.sgi.com>; Thu, 29 May 2008 01:04:46 -0700 (PDT)
Received: from [10.0.0.21] (e179054170.adsl.alicedsl.de [85.179.54.170])
	by mail.lichtvoll.de (Postfix) with ESMTP id 36FCB5ADEF
	for <linux-xfs@oss.sgi.com>; Thu, 29 May 2008 10:05:04 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Question for XFS (mounting and clean bit)
Date: Thu, 29 May 2008 10:04:44 +0200
References: <20080527181336.22qjfcgcfdlwsg40@webmail.versatel.de> <200805291002.14665.Martin@lichtvoll.de> (sfid-20080529_100337_093273_54B3C19A)
In-Reply-To: <200805291002.14665.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805291004.45116.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Donnerstag 29 Mai 2008 schrieb Martin Steigerwald:
> Am Dienstag 27 Mai 2008 schrieb Andre Nitschke:
> > Hello,
> > i am a Linux User from Germany and chanched to xfs. I use Debian 4
> > and the installer creates lilo. Because of a wrong configuration i
> > destroyed the lilo.conf and rebootet with a systemrescuecd. from here
> > i mount the xfs partition and try to run lilo, but it fails.
> > then i had a realy bad idea. i unmount the xfs partition and then
> > mount it as root, but there exit a root file system.
>
> Hi Andre!
>
> Some additional hint on this:
>
> I think what you actually wanted to do was:
>
> mount /dev/sda1 /mnt

mount /dev/sda2 /mnt

but you get the picture. ;)

> chroot /mnt
> lilo
> Ctrl-D

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
