Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Aug 2006 06:53:37 -0700 (PDT)
Received: from mondschein.lichtvoll.de (mondschein.lichtschiff.de [194.150.191.238] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7ODrRDW007238
	for <xfs@oss.sgi.com>; Thu, 24 Aug 2006 06:53:28 -0700
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: xfs bug in 2.6.17.9?
Date: Thu, 24 Aug 2006 14:29:13 +0200
References: <92b7ea0a0608240245v700f19dex6ecb688efcab657b@mail.gmail.com>
In-Reply-To: <92b7ea0a0608240245v700f19dex6ecb688efcab657b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200608241429.14277.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: liste@jordet.nu
Cc: xfs@oss.sgi.com

Am Donnerstag 24 August 2006 11:45 schrieb Stian Jordet:
> I got this on my server today, while it was not doing anything in
> particular...
>
> Aug 24 09:22:09 buick kernel: xfs_da_do_buf: bno 16777216

Hello Stian,

It looks to me that the directory corruption bug in kernel 2.6.17 upto 
2.6.17.6 hit you: Did you use a 2.6.17 kernel < 2.6.17.7 before? 

See 

http://oss.sgi.com/projects/xfs/faq.html#dir2
http://bugzilla.kernel.org/show_bug.cgi?id=6757

Try xfs_check and if it finds errors xfs_repair. 

If xfs_repair cannot fix it, you will have to look out a version that 
contains some fixes related to handling this kind of corruption:

http://oss.sgi.com/archives/xfs/2006-07/msg00374.html

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
