Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Oct 2006 01:51:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9H8pTaG005367
	for <xfs@oss.sgi.com>; Tue, 17 Oct 2006 01:51:29 -0700
Received: from mondschein.lichtvoll.de (mondschein.lichtschiff.de [194.150.191.238])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E6894AF6C0
	for <xfs@oss.sgi.com>; Tue, 17 Oct 2006 00:37:53 -0700 (PDT)
Received: from deepdance.of.teamix.net (blackhole.teamix.net [194.150.191.251])
	by mondschein.lichtvoll.de (Postfix) with ESMTP id CF3D9FA0AD
	for <xfs@oss.sgi.com>; Tue, 17 Oct 2006 09:35:47 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: FS corruption and repair problem
Date: Tue, 17 Oct 2006 09:37:30 +0200
References: <20061016082532.GA5574@jdc> <45338FEA.3060709@sandeen.net> <20061017053514.GA5095@jdc>
In-Reply-To: <20061017053514.GA5095@jdc>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200610170937.31036.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Am Dienstag 17 Oktober 2006 07:35 schrieb Jason White:

> Unfortunately, yes. The first I knew about it came in the form of i/o
> errors and processes terminating with error 990.

Hello Jason,

this is the error code XFS returns when it detects corruption. AFAIK it 
has been changed to something more meaningful lately.

> After unmounting the backup fs I ran xfs_check, which reported no
> problems. Thus I suspect that in the case of the backup drive, the FS
> corruption was due to the 2.6.17 bug, since copying gigabytes of files
> to it failed to reproduce the problem, and all seems fine under 2.6.18.
>
> I am still pleased with XFS as I have been using it since 2001, and the
> only problems have been due to bugs that were quickly fixed by the
> developers, and most of these happened prior to the integration of XFS
> into the mainline.

Since 2.6.17.7 I had no fs corruption with XFS anymore. Neither on my 
laptop nor on my workstation. On my laptop I had quite some issues with 
2.6.16 which I omitted on my Workstation except 2.6.16rc1.

I am currently running 2.6.18 and am pretty pleased.

Make sure that write barriers are enabled (is default since 2.6.17, was 
not the default 2.6.16 which IMHO at least partly contributed to my 
problems with it). Umount an XFS partition, do tail -f /var/log/syslog or 
tail -f /var/log/messages and mount it again. If XFS can't do write 
barriers on your machine, it should put an error message into log. You 
can find more about this is in the approbiate log entry.

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
