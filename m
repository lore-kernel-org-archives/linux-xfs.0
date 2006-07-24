Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Jul 2006 09:04:01 -0700 (PDT)
Received: from stargate.synerway.com (stargate.synerway.com [84.14.10.249])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6OG3nDW024688
	for <linux-xfs@oss.sgi.com>; Mon, 24 Jul 2006 09:03:50 -0700
Received: from stargate.synerway.com (stargate.synerway.com [127.0.0.1])
	by stargate.synerway.com (Postfix) with ESMTP id 13EB6454092
	for <linux-xfs@oss.sgi.com>; Mon, 24 Jul 2006 18:31:30 +0200 (CEST)
Received: from venus (unknown [172.16.10.150])
	by stargate.synerway.com (Postfix) with ESMTP id 0515C45408E
	for <linux-xfs@oss.sgi.com>; Mon, 24 Jul 2006 18:31:29 +0200 (CEST)
Date: Mon, 24 Jul 2006 18:03:17 +0200
From: Pascal GREGIS <pgs@synerway.com>
Subject: currupted files filling with zeros after power failure
Message-ID: <20060724160317.GA787@venus.synerway.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Hello everyone,

I'm  working on power failures on some test machines in my company.
I volunteerly switch off my machine by pressing the power button and restart my machine to see how it behaves.

The problem I'm facing is that about once for two crashes the last file (or at least the last file) i which I wrote becomes corrupted and filled with \0 characters.

I didn't think XFS could be subject to this type of problem, however here isn't really the reason of my mail.

What I would like to know is what can I do to resolve this problem? Is XFS able to recover my file with its right content, at least a consistent content, not only \0 characters?
I made some tries with xfs_repair and it didn't repair it, once it put me some inodes in lost+found but id didn't repair my corrupted file.
Maybe xfs_db could help, I don't know.

I'm running a 2.6.11.11 kernel iwth xfsprogs-2.7.3 and xfsdump-2.2.30.
Maybe is a bug in that kernel.

Do you guys know if this problem has often been encountered or not,a dn if there is a way to proceed?

Thank you

Pascal
