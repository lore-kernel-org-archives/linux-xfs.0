Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Oct 2006 07:33:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9QEX8aG028421
	for <xfs@oss.sgi.com>; Thu, 26 Oct 2006 07:33:08 -0700
Received: from mx1.blinkenlights.nl (mx1.blinkenlights.nl [80.84.249.153])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 004014DAA78
	for <xfs@oss.sgi.com>; Thu, 26 Oct 2006 06:31:35 -0700 (PDT)
Received: from zaphod.blinkenlights.nl (zaphod.blinkenlights.nl [IPv6:2001:980:ffe:3:2e0:81ff:fe2f:bb6a])
	by mx1.blinkenlights.nl (Postfix) with ESMTP id 7F56E73009
	for <xfs@oss.sgi.com>; Thu, 26 Oct 2006 15:31:14 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zaphod.blinkenlights.nl (Postfix) with ESMTP id 4CD4B17F455
	for <xfs@oss.sgi.com>; Thu, 26 Oct 2006 15:31:14 +0200 (CEST)
Date: Thu, 26 Oct 2006 15:31:14 +0200 (CEST)
From: Sten Spans <sten@blinkenlights.nl>
Subject: xfs_quota project + symlinks
Message-ID: <Pine.LNX.4.64.0610261519250.30903@zaphod.blinkenlights.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


This is with

root@backup:/root/backup# xfs_quota -V
xfs_quota version 2.8.11
root@backup:/backup# ln -s foo bar
root@backup:/backup# xfs_quota -x -c 'project -c 0'
Checking project 7 (path /backup)...
xfs_quota: cannot open /backup/bar: No such file or directory
Processed 1 /etc/projects paths for project 0

Would it be possible to handle symlinks better ?
Perhaps a check for symlinks in project.c ?
