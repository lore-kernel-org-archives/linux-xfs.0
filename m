Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 21 Jul 2007 12:41:11 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6LJf7bm005808
	for <linux-xfs@oss.sgi.com>; Sat, 21 Jul 2007 12:41:09 -0700
Received: from localhost (dslb-084-056-076-236.pools.arcor-ip.net [84.56.76.236])
	by mail.lichtvoll.de (Postfix) with ESMTP id C4FB15ADFF
	for <linux-xfs@oss.sgi.com>; Sat, 21 Jul 2007 21:47:48 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: xfs-cmds doesn't build... (cvs & 2.9.2...)
Date: Sat, 21 Jul 2007 21:41:09 +0200
References: <46A2209F.2030108@sandeen.net> (sfid-20070721_185105_539562_E01EA719)
In-Reply-To: <46A2209F.2030108@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707212141.10101.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Samstag 21 Juli 2007 schrieb Eric Sandeen:
> cvs:
>
> [sandeen@sandeen xfs-cmds]$ make
> ....
> == Building xfsprogs
> == clean, log is Logs/clean
> make: *** [cmds] Error 1
> [sandeen@sandeen xfs-cmds]$ cat xfsprogs/Logs/clean
> make[1]: Entering directory `/src/cvs/xfs-cmds/xfsprogs'
> === include ===
> gmake[2]: *** No rule to make target `mdrestore'.  Stop.
> make[1]: *** [mdrestore] Error 2
> make[1]: Leaving directory `/src/cvs/xfs-cmds/xfsprogs'
> [sandeen@sandeen xfs-cmds]$ grep -B1 mdrestore xfsprogs/Makefile
> SUBDIRS = include libxfs libxlog libxcmd libhandle libdisk \
>         copy db fsck growfs io logprint mkfs quota mdrestore repair
> rtcp \ [sandeen@sandeen xfs-cmds]$ ls xfsprogs/mdrestore
> ls: xfsprogs/mdrestore: No such file or directory

Hi Eric,

did work here a bit before Sa 21. Jul 21:40:50 CEST 2007.

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
