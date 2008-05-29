Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 01:08:48 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4T88kuh014091
	for <linux-xfs@oss.sgi.com>; Thu, 29 May 2008 01:08:46 -0700
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8AEE01B986AF
	for <linux-xfs@oss.sgi.com>; Thu, 29 May 2008 01:09:38 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by cuda.sgi.com with ESMTP id y1RNn1yzFqXyRwBU for <linux-xfs@oss.sgi.com>; Thu, 29 May 2008 01:09:38 -0700 (PDT)
Received: from [10.0.0.21] (e179054170.adsl.alicedsl.de [85.179.54.170])
	by mail.lichtvoll.de (Postfix) with ESMTP id D1B9B5ADEF
	for <linux-xfs@oss.sgi.com>; Thu, 29 May 2008 10:09:55 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Question for XFS (mounting and clean bit)
Date: Thu, 29 May 2008 10:09:35 +0200
References: <20080527181336.22qjfcgcfdlwsg40@webmail.versatel.de> <483E5462.1080604@sgi.com> (sfid-20080529_093513_291114_64DAE2F5)
In-Reply-To: <483E5462.1080604@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805291009.36229.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Donnerstag 29 Mai 2008 schrieb Timothy Shimmin:
> Hi Andre,

Hi Timothy,

> I didn't follow all of this, sorry.
> When you ask about the "clean bit", I assume that you are referring
> to "clean XFS mount for filesystem".
> We effectively mark it clean if we do a successful unmount.
> As part of unmount, we write an unmount record into the xfs log.
> On the next mount we look for the head of the log and then for the
> unmount record nearby. If we find the unmount record then we know
> we have had a clean unmount previously, otherwise we replay the log.
> So it's really a question of doing an unmount versus resetting the
> box beforehand or forcing a shutdown beforehand.

But when is it dirtied? If the clean log entry is the actual "clean bit" I 
guess: When the first new entry is written in the log.

Does XFS write a log entry on mounting it already or only on the first 
real write? Or in other words if I mount a XFS filesystem without writing 
to it and reset the machine, would it be marked clean or dirty then? 
Hmmm, I could test this ;-).

If its only mounted read only, it shouldn't be marked dirty anyways.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
