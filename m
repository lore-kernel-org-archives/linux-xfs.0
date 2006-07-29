Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 29 Jul 2006 05:58:07 -0700 (PDT)
Received: from mondschein.lichtvoll.de (ms1.lichtvoll.de [194.150.191.234])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6TCvqDW029184
	for <linux-xfs@oss.sgi.com>; Sat, 29 Jul 2006 05:57:53 -0700
Received: from localhost (dslb-084-056-097-058.pools.arcor-ip.net [84.56.97.58])
	by mondschein.lichtvoll.de (Postfix) with ESMTP id C4ACBFA50A
	for <linux-xfs@oss.sgi.com>; Sat, 29 Jul 2006 14:57:08 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Problem with xfs_repair
Date: Sat, 29 Jul 2006 14:57:19 +0200
References: <20060728064505.GA14714@charite.de> <Pine.LNX.4.64.0607281019400.30325@p34.internal.lan> <Pine.LNX.4.64.0607281023370.30325@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0607281023370.30325@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200607291457.20760.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Freitag 28 Juli 2006 16:23 schrieb Justin Piszcz:

> > Is your knoppix boot cd 5.0.1 == 2.6.17 == bugged kernel? ;P
>
> When repairing, do not use knoppix 5.0.1 or any version that uses
> 2.6.17 either..

Hello Justin,

since xfs_repair works independently of the in-kernel XFS implementation 
it is possible to repair a directory-corruption broken XFS filesystem 
with Knoppix 5.0.1.

It did so already. I used 5.0.1 to rsync a workstation image and sure it 
had this slight corruption afterwards. Thus I xfs_repair'ed it and 
xfs_check'ed it afterwards and all was well again.

No this is not a recommendation to use Knoppix 5.0.1 to rsync an 
workstation image ;), but an xfs_repair should be possible (unless one 
hits the unfixable bug). 

Important: When XFS needs to be mounted first before repair in order to 
clean the log it might not be wise to use Knoppix 5.0.1 tough.

BTW when using Knoppix 5 or even an older version instead I recommend 
switching off the write cache to be on the safe side (hdparm -W0).

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
