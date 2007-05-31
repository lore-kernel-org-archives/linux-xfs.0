Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 31 May 2007 06:37:38 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4VDbWWt032643
	for <xfs@oss.sgi.com>; Thu, 31 May 2007 06:37:33 -0700
Message-ID: <465ECF9B.2000500@sandeen.net>
Date: Thu, 31 May 2007 08:37:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: ways to restore data from crashed disk
References: <465EA882.3030403@deserver.nl>
In-Reply-To: <465EA882.3030403@deserver.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jaap Struyk <japie@deserver.nl>
Cc: xfs@oss.sgi.com

Jaap Struyk wrote:
> Hello,
> 
> Recently my server drive has crashed and I'am trying to get some data of it.
> The only problematic part is my xfs partition, the drive has some
> "holes" in it, unfortunatly on the place where the superblock would be.
> I did:
> dd_rhelp /dev/hdb4 hdb4.img
> xfs_repair -f hdb4.img
> Phase 1 - find and verify superblock...
> superblock read failed, offset 9397895168, size 2048, ag 1, rval 0

For starters, is the file really that big?  (9397895168 bytes?)

-eric

> Is there an alternative available on xfs or a way to recreate it?
