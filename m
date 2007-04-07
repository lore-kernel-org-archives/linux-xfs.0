Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 07 Apr 2007 13:47:45 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l37KlefB023317
	for <linux-xfs@oss.sgi.com>; Sat, 7 Apr 2007 13:47:42 -0700
Received: from localhost (dslb-084-056-094-087.pools.arcor-ip.net [84.56.94.87])
	by mail.lichtvoll.de (Postfix) with ESMTP id 58DE55ADBB
	for <linux-xfs@oss.sgi.com>; Sat,  7 Apr 2007 22:47:39 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: XFS Resiliency to the disk errors.
Date: Sat, 7 Apr 2007 22:47:37 +0200
References: <A63C579E7F04E74588517328EF5A385E02076A9A@ILEX5.IL.NDS.COM> (sfid-20070405_112347_743716_6E82B98E) (sfid-20070405_112347_743716_6E82B98E) (sfid-20070405_112347_743716_6E82B98E)
In-Reply-To: <A63C579E7F04E74588517328EF5A385E02076A9A@ILEX5.IL.NDS.COM>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704072247.38143.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Donnerstag 05 April 2007 schrieb Zak, Semion:
> Hi,
>
> We are studying possibility to use XFS with cheap (not too reliable)
> discs, so we have some questions:

Hi Semion!

I recommend at least monitoring the health status of the drives using 
smartmontools - with regular short and long selft test - or a similar 
mechanism. So you *may* at least be warned *before* a disk fails.

Otherwise I would go for a redundant RAID array at least so that at least 
one drive in a bunch of drives can fail without data loss.

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
