Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 27 Jul 2006 23:45:50 -0700 (PDT)
Received: from mail.charite.de (mail.charite.de [160.45.207.131])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6S6jdDW025025
	for <xfs@oss.sgi.com>; Thu, 27 Jul 2006 23:45:40 -0700
Received: from localhost (localhost [127.0.0.1])
	by mail.charite.de (Postfix) with ESMTP id 14B7E2207FB
	for <xfs@oss.sgi.com>; Fri, 28 Jul 2006 08:45:10 +0200 (CEST)
Received: from mail.charite.de ([127.0.0.1])
	by localhost (mail.charite.de [127.0.0.1]) (amavisd-new, port 10025)
	with LMTP id 8bRIUKf0uHlD for <xfs@oss.sgi.com>;
	Fri, 28 Jul 2006 08:45:08 +0200 (CEST)
Received: from postamt.charite.de (postamt.charite.de [160.45.207.132])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mail.charite.de (Postfix) with ESMTP id ED5292207ED
	for <xfs@oss.sgi.com>; Fri, 28 Jul 2006 08:45:06 +0200 (CEST)
Date: Fri, 28 Jul 2006 08:45:05 +0200
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
Subject: Problem with xfs_repair
Message-ID: <20060728064505.GA14714@charite.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_repair gave me this when repairing my / fs using a knoppix boot cd:

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - clear lost+found (if it exists) ...
        - clearing existing "lost+found" inode
        - marking entry "lost+found" to be deleted
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - ensuring existence of lost+found directory
        - traversing filesystem starting at / ... 
rebuilding directory inode 128

fatal error -- can't read block 16777216 for directory inode 167785633

a) How can I find out which file/directory this inode belongs to?
b) Can I mark the block defektiv somehow?

-- 
Ralf Hildebrandt (i.A. des IT-Zentrums)         Ralf.Hildebrandt@charite.de
Charite - Universitätsmedizin Berlin            Tel.  +49 (0)30-450 570-155
Gemeinsame Einrichtung von FU- und HU-Berlin    Fax.  +49 (0)30-450 570-962
IT-Zentrum Standort CBF                 send no mail to spamtrap@charite.de
