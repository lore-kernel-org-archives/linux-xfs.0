Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Jun 2007 21:03:50 -0700 (PDT)
Received: from psmtp09.wxs.nl (psmtp09.wxs.nl [195.121.247.23])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5843kWt027652
	for <xfs@oss.sgi.com>; Thu, 7 Jun 2007 21:03:47 -0700
Received: from mail.deserver.nl (ip565e92ac.direct-adsl.nl [86.94.146.172])
 by psmtp09.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0JJA00CCSTY9M4@psmtp09.wxs.nl> for xfs@oss.sgi.com; Fri,
 08 Jun 2007 06:03:46 +0200 (MEST)
Received: from localhost (localhost [127.0.0.1])	by mail.deserver.nl (Postfix)
 with ESMTP id 662A8236CD	for <xfs@oss.sgi.com>; Fri,
 08 Jun 2007 06:03:45 +0200 (CEST)
Received: from [192.168.0.14] (unknown [192.168.0.14])
	by mail.deserver.nl (Postfix) with ESMTP id 89C31236C4	for <xfs@oss.sgi.com>;
 Fri, 08 Jun 2007 06:03:43 +0200 (CEST)
Date: Fri, 08 Jun 2007 06:03:43 +0200
From: Jaap Struyk <japie@deserver.nl>
Subject: Re: ways to restore data from crashed disk
In-reply-to: <46685C5F.5090804@sandeen.net>
Message-id: <4668D51F.8010804@deserver.nl>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <465EA882.3030403@deserver.nl> <465ECF9B.2000500@sandeen.net>
 <46684A9B.90908@deserver.nl> <46685C5F.5090804@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Eric Sandeen schreef:

> when you are talking about sizes, do you mean space used (du) or max
> offset (ls -l?)  max offset should be the same for your image file as
> for your original device... 120G.

ls -l
But I don't know what tot trust anymore, if I look with gparted at my
partitions the old disk gaves me a partition of 140G with 106G used space.
My new disk has a partition of 200G with 166G used space.
If I create a new xfs partition it has about 10% used space (according
to gparted, I suspect thats the size of the logfiles?) so from the 166G
on the new disk 146G is the "real" used space so that should be the size
of the image file. (nomather what ls -l tells me)
Is this correct?
-- 
Groetjes Japie
