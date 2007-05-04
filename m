Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 May 2007 08:58:29 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l44FwOfB005594
	for <linux-xfs@oss.sgi.com>; Fri, 4 May 2007 08:58:25 -0700
Received: from localhost (dslb-084-057-112-255.pools.arcor-ip.net [84.57.112.255])
	by mail.lichtvoll.de (Postfix) with ESMTP id AF67E5AD3F
	for <linux-xfs@oss.sgi.com>; Fri,  4 May 2007 17:58:22 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: XFS crash on linux raid
Date: Fri, 4 May 2007 17:58:21 +0200
References: <20070503164521.16efe075@harpe.intellique.com> <20070504073344.GL32602149@melbourne.sgi.com> <20070504152546.614374ac@harpe.intellique.com> (sfid-20070504_161005_263297_AD8C4AAD)
In-Reply-To: <20070504152546.614374ac@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705041758.21320.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Freitag 04 Mai 2007 schrieb Emmanuel Florac:

> I've ran the same test on the same machine but WITHOUT software raid-0
> (so write barriers are in use), and all went well, more than 3TB
> written without a glitch. I still think there's something related to
> the write barriers here. I'll try with another RAID controller, Adaptec
> for instance, to get sure the 3ware driver isn't involved. I'll also
> try again with an amd64 kernel.

Hello Emmanuel!

When you can't use write barriers as XFS tell you in the logs, you better 
switch of write caching for the harddisks / raid controller, unless you 
happen to have NVRAM or safe power supply.

But then using write cache without barrier should not make any difference 
unless you actually have a crash or power failure during write operation.

Did you test with ext3 as well? You wrote it crashes with ReiserFS 
(version 3) even faster. When it crashes with several filesystems its 
unlikely to be a filesystem issue.

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
