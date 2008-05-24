Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 24 May 2008 09:18:15 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4OGIDCq009090
	for <linux-xfs@oss.sgi.com>; Sat, 24 May 2008 09:18:13 -0700
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E3261172AD06
	for <linux-xfs@oss.sgi.com>; Sat, 24 May 2008 09:19:03 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by cuda.sgi.com with ESMTP id crBknegJrtWANVqB for <linux-xfs@oss.sgi.com>; Sat, 24 May 2008 09:19:03 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: XFS for lots of small files
Date: Sat, 24 May 2008 18:16:55 +0200
References: <4820832B.3070903@dubielvitrum.pl> <200805062055.36755.Martin@lichtvoll.de> <4836135D.9050409@tlinx.org> (sfid-20080523_104048_864520_772E3EC8)
In-Reply-To: <4836135D.9050409@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200805241816.56080.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com
Cc: Linda Walsh <xfs@tlinx.org>


Hi Linda,

Am Freitag 23 Mai 2008 schrieb Linda Walsh:
> Martin Steigerwald wrote:
> > And there is quite some fragmentation on it:
> >
> > xfs_db> frag
> > actual 653519, ideal 587066, fragmentation factor 10.17%
>
> ----
> 	Not to disturb you, but are  you running xfs_fsr on a
> regular basis?

No, not yet. I had those bad experiences with xfs_fsr on a ck patchset 
patched kernel and after this I didn't try again. Its pretty sure that my 
file content corruption issues was related to the ck patchset as I was 
not able to reproduce it with a CFS or mainline kernel. But still I have 
been reluctant. I think, I give it a try after I made my backups.

> I have a shell script that runs in my 'cron.daily' that has two
> lines:
> ----
> #!/bin/bash
> ionice -c 3 /usr/sbin/xfs_fsr &
> -------
>
> I've never noticed fragmentation above 1% on my disks...but your
> mileage may vary ....

Lets see ;-)

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
