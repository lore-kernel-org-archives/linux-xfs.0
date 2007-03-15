Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Mar 2007 06:07:42 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2FD7a6p019729
	for <linux-xfs@oss.sgi.com>; Thu, 15 Mar 2007 06:07:38 -0700
Received: from localhost (dslb-084-056-091-239.pools.arcor-ip.net [84.56.91.239])
	by mail.lichtvoll.de (Postfix) with ESMTP id CC7095ADEC
	for <linux-xfs@oss.sgi.com>; Thu, 15 Mar 2007 14:07:35 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: cache+barriers vs cache+nobarriers vs disabled cache+barriers vs disabled cache+nobarriers
Date: Thu, 15 Mar 2007 14:07:34 +0100
References: <20070315092220.1B09B193FE@mail.edu.haifa.ac.il> <200703151339.36259.Martin@lichtvoll.de>
In-Reply-To: <200703151339.36259.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Disposition: inline
Message-Id: <200703151407.34419.Martin@lichtvoll.de>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Donnerstag 15 März 2007 schrieb Martin Steigerwald:

> But why do you want to disable write cache in the first case? As long
> as you are using 2.6.17.7 or later you can safely enable barriers and
> and write cache. 

Hello again, Leon,

of couse using write barriers is only possible if the hardware 
requirements (cache flushes or similar mechanisms) are met. XFS complains 
if it can't use barriers. See dmesg or log for details.

It seems that the mailinglist software broke my GPG signature. It was 
correct as I sent out the mail.

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
