Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 31 May 2007 04:02:56 -0700 (PDT)
Received: from hpsmtp-eml20.kpnxchange.com (hpsmtp-eml20.kpnxchange.com [213.75.38.85])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4VB2qWt002281
	for <xfs@oss.sgi.com>; Thu, 31 May 2007 04:02:53 -0700
Received: from localhost (localhost [127.0.0.1])
	by mail.deserver.nl (Postfix) with ESMTP id 60760236CB
	for <xfs@oss.sgi.com>; Thu, 31 May 2007 12:50:47 +0200 (CEST)
Received: from [192.168.0.14] (unknown [192.168.0.14])
	by mail.deserver.nl (Postfix) with ESMTP id 01E03236BC
	for <xfs@oss.sgi.com>; Thu, 31 May 2007 12:50:42 +0200 (CEST)
Message-ID: <465EA882.3030403@deserver.nl>
Date: Thu, 31 May 2007 12:50:42 +0200
From: Jaap Struyk <japie@deserver.nl>
MIME-Version: 1.0
Subject: ways to restore data from crashed disk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello,

Recently my server drive has crashed and I'am trying to get some data of it.
The only problematic part is my xfs partition, the drive has some
"holes" in it, unfortunatly on the place where the superblock would be.
I did:
dd_rhelp /dev/hdb4 hdb4.img
xfs_repair -f hdb4.img
Phase 1 - find and verify superblock...
superblock read failed, offset 9397895168, size 2048, ag 1, rval 0
Is there an alternative available on xfs or a way to recreate it?
-- 
Groetjes Japie
