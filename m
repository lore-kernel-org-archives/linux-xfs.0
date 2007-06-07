Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Jun 2007 11:23:00 -0700 (PDT)
Received: from smtp14.wxs.nl (smtp14.wxs.nl [195.121.247.5])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l57IMuWt006080
	for <xfs@oss.sgi.com>; Thu, 7 Jun 2007 11:22:57 -0700
Received: from mail.deserver.nl (ip565e92ac.direct-adsl.nl [86.94.146.172])
 by smtp14.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006)) with ESMTP id
 <0JJA0085L2LHA6@smtp14.wxs.nl> for xfs@oss.sgi.com; Thu,
 07 Jun 2007 20:12:53 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])	by mail.deserver.nl (Postfix)
 with ESMTP id D9310236CD	for <xfs@oss.sgi.com>; Thu,
 07 Jun 2007 20:12:52 +0200 (CEST)
Received: from [192.168.0.14] (unknown [192.168.0.14])
	by mail.deserver.nl (Postfix) with ESMTP id 21E3A236C4	for <xfs@oss.sgi.com>;
 Thu, 07 Jun 2007 20:12:44 +0200 (CEST)
Date: Thu, 07 Jun 2007 20:12:43 +0200
From: Jaap Struyk <japie@deserver.nl>
Subject: Re: ways to restore data from crashed disk
In-reply-to: <465ECF9B.2000500@sandeen.net>
Message-id: <46684A9B.90908@deserver.nl>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <465EA882.3030403@deserver.nl> <465ECF9B.2000500@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Eric Sandeen schreef:

> For starters, is the file really that big?  (9397895168 bytes?)

dd_rhelp /dev/hdd4 hdd4.img
xfs_repair hdd4.img
Phase 1 - find and verify superblock...
superblock read failed, offset 103376846848, size 2048, ag 11, rval 0
fatal error -- Gelukt (gelukt is dutch for sucses or done)

The image is 92G. big but my original filesystem was about 120G. but the
92G is about the size of the data that was on the disc.

dd_rhelp /dev/hdd4 hdd4.img info:
- Jump pos : 96365061.0 - max file size : 156019623.0
- Biggest hole size :  119309126 k - total holes : 0k
- xferd(succ/err) : 36710498.0k(36710496.0k/2.0k)
- EOF is not found, but between 36710498.0k and 156019623.0k.
ALL your data has been dd_rescued !!
-- 
Groetjes Japie
