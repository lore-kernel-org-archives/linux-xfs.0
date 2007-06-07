Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Jun 2007 12:32:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l57JWmWt028000
	for <xfs@oss.sgi.com>; Thu, 7 Jun 2007 12:32:49 -0700
Message-ID: <46685C5F.5090804@sandeen.net>
Date: Thu, 07 Jun 2007 14:28:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: ways to restore data from crashed disk
References: <465EA882.3030403@deserver.nl> <465ECF9B.2000500@sandeen.net> <46684A9B.90908@deserver.nl>
In-Reply-To: <46684A9B.90908@deserver.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jaap Struyk <japie@deserver.nl>
Cc: xfs@oss.sgi.com

Jaap Struyk wrote:
> Eric Sandeen schreef:
> 
>> For starters, is the file really that big?  (9397895168 bytes?)
> 
> dd_rhelp /dev/hdd4 hdd4.img
> xfs_repair hdd4.img
> Phase 1 - find and verify superblock...
> superblock read failed, offset 103376846848, size 2048, ag 11, rval 0
> fatal error -- Gelukt (gelukt is dutch for sucses or done)
> 
> The image is 92G. big but my original filesystem was about 120G. but the
> 92G is about the size of the data that was on the disc.

when you are talking about sizes, do you mean space used (du) or max
offset (ls -l?)  max offset should be the same for your image file as
for your original device... 120G.

-Eric

> dd_rhelp /dev/hdd4 hdd4.img info:
> - Jump pos : 96365061.0 - max file size : 156019623.0
> - Biggest hole size :  119309126 k - total holes : 0k
> - xferd(succ/err) : 36710498.0k(36710496.0k/2.0k)
> - EOF is not found, but between 36710498.0k and 156019623.0k.
> ALL your data has been dd_rescued !!
