Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 30 Nov 2007 10:07:23 -0800 (PST)
Received: from sovereign.computergmbh.de (sovereign.computergmbh.de [85.214.69.204])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAUI7I0V029883
	for <xfs@oss.sgi.com>; Fri, 30 Nov 2007 10:07:19 -0800
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id 752481C0596FB
	for <xfs@oss.sgi.com>; Fri, 30 Nov 2007 19:07:26 +0100 (CET)
Date: Fri, 30 Nov 2007 19:07:26 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: ACL limit
Message-ID: <Pine.LNX.4.64.0711301902360.18767@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,


is there any way to raise the number of ACLs that can be stored? The 
current limit of 25 is quite tight, where ext3 allows 124 and jfs 8192.
Would increasing XFS_ACL_MAX_ENTRIES work (yes, using potentially more 
memory), i.e. not interfering with the on-disk format?


thanks,
Jan
