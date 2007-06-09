Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 09 Jun 2007 00:50:58 -0700 (PDT)
Received: from psmtp08.wxs.nl (psmtp08.wxs.nl [195.121.247.22])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l597osWt001879
	for <xfs@oss.sgi.com>; Sat, 9 Jun 2007 00:50:56 -0700
Received: from mail.deserver.nl (ip565e92ac.direct-adsl.nl [86.94.146.172])
 by psmtp08.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0JJC00LE9Z4U9Z@psmtp08.wxs.nl> for xfs@oss.sgi.com; Sat,
 09 Jun 2007 09:50:54 +0200 (MEST)
Received: from localhost (localhost [127.0.0.1])	by mail.deserver.nl (Postfix)
 with ESMTP id 1E8B6236CE	for <xfs@oss.sgi.com>; Sat,
 09 Jun 2007 09:50:54 +0200 (CEST)
Received: from [192.168.0.14] (unknown [192.168.0.14])
	by mail.deserver.nl (Postfix) with ESMTP id 484D2236C4	for <xfs@oss.sgi.com>;
 Sat, 09 Jun 2007 09:50:51 +0200 (CEST)
Date: Sat, 09 Jun 2007 09:50:49 +0200
From: Jaap Struyk <japie@deserver.nl>
Subject: Re: ways to restore data from crashed disk
In-reply-to: <46697C94.40401@sandeen.net>
Message-id: <466A5BD9.7010604@deserver.nl>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <465EA882.3030403@deserver.nl> <465ECF9B.2000500@sandeen.net>
 <46684A9B.90908@deserver.nl> <46685C5F.5090804@sandeen.net>
 <4668D51F.8010804@deserver.nl> <46697C94.40401@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Eric Sandeen schreef:

> it looks like the original filesystem was bigger than your image:
> 
> 4096*36710528
> 150366322688 <-- 140 MB
> 
> so it looks like your image file is not correct... I'm not familiar with
> the tool you're using, is it somehow compressing a sparse file or
> something like that?

You are completely right!

I used dd_rhelp instead of dd_rescue since everytime a bad block is hit
my disk isn't acceseble anymore and I have to reboot.
So I tryed another aproach and used a knoppix cd to boot and used
dd_rescue right away and with knoppix the disk keeps readable. (so it
seems the kernel knoppix is using isn't killed by bad blocks, mine is)
In concreto: I dumped my disk on another, used xfs_repair without
problems and got almost all my data back (except for the last 2G that
was written)
Thanks for pointing me the right track, or else I was still wrestling to
recover an incomplete image file!
-- 
Groetjes Japie
