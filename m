Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 11:15:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m99IFuPE007627
	for <linux-xfs@oss.sgi.com>; Thu, 9 Oct 2008 11:15:56 -0700
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 102E513D5C1A
	for <linux-xfs@oss.sgi.com>; Thu,  9 Oct 2008 11:17:35 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by cuda.sgi.com with ESMTP id Z7iPe3TDfBCFmJkf for <linux-xfs@oss.sgi.com>; Thu, 09 Oct 2008 11:17:35 -0700 (PDT)
Received: from shambhala.lichtvoll.local (DSL01.83.171.172.241.ip-pool.NEFkom.net [83.171.172.241])
	by mail.lichtvoll.de (Postfix) with ESMTP id 2F0095AE1E
	for <linux-xfs@oss.sgi.com>; Thu,  9 Oct 2008 20:17:34 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: [RFC, PATCH 0/7] XFS: dynamic busy extent tracking
Date: Thu, 9 Oct 2008 20:17:32 +0200
References: <1223417377-8679-1-git-send-email-david@fromorbit.com> (sfid-20081008_111209_917116_76A20764)
In-Reply-To: <1223417377-8679-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810092017.33042.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


Hi Dave,

Am Mittwoch 08 Oktober 2008 schrieb Dave Chinner:
> The busy extent tracking in XFS is currently very static and has
> some performance issues. We can only track 128 busy extents per AG,
> and when we overflow this we fall back to synchronous transactions.
> Also, every time we re-use a busy extent we cause a synchronous log
> force, which stops all allocation and freeing in that AG while the
> log force is in progress.

Could this accelerate

tar -xf linux-2.6.26.tar.gz
rm -r linux-2.6.26

?

A student in the Linux Performance Tuning course I hold this week compared 
this with ext3, even with the improved mkfs.xfs options (but without 
lazy-count=1, cause mkfs.xfs from Debian Etch is too old) and even with 
noop as IO scheduler. AFAIR XFS took roughly 3-4 times as long as Ext3, I 
did not note the exact numbers. This was with 2.6.25. I can repeat the 
test locally with 2.6.26.5 if wanted.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
