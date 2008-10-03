Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 03 Oct 2008 08:03:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m93F3Apg024546
	for <xfs@oss.sgi.com>; Fri, 3 Oct 2008 08:03:10 -0700
Received: from smtp2-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3DCB813782DD
	for <xfs@oss.sgi.com>; Fri,  3 Oct 2008 08:04:47 -0700 (PDT)
Received: from smtp2-g19.free.fr (smtp2-g19.free.fr [212.27.42.28]) by cuda.sgi.com with ESMTP id SSgzIVx1bZR8xiAV for <xfs@oss.sgi.com>; Fri, 03 Oct 2008 08:04:47 -0700 (PDT)
Received: from smtp2-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp2-g19.free.fr (Postfix) with ESMTP id E45A212B782
	for <xfs@oss.sgi.com>; Fri,  3 Oct 2008 17:04:46 +0200 (CEST)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
	by smtp2-g19.free.fr (Postfix) with ESMTP id 972A912B75F
	for <xfs@oss.sgi.com>; Fri,  3 Oct 2008 17:04:46 +0200 (CEST)
Date: Fri, 3 Oct 2008 17:04:52 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: what is the FS size limit for xfs_repair ?
Message-ID: <20081003170452.50a7ec78@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


After a system crash on a system with a 40TB XFS filesystem, xfs_repair
(32 bits binary, with a 64 bits 2.6.24 kernel) refused to work ("cannot
allocate block map, size xxx").
The 64 bits xfs_repair did the trick fine. 

I tried to reproduce the problem today by corrupting a 22TB filesystem.
However, 32 bits xfs_repair repaired the 22 TB FS just fine in the very
same configuration (64 bits kernel, etc).

I thought the limit would be at 16TB (32 bits limit for a filesystem)
but obviously this isn't the case. Is the limitation higher (like 32
TB) or is it a bug of etch 4.0r4 xfs_repair?

-- 
----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------
