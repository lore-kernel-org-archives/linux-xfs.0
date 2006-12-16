Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 16 Dec 2006 09:58:41 -0800 (PST)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBGHwSqw011834
	for <linux-xfs@oss.sgi.com>; Sat, 16 Dec 2006 09:58:32 -0800
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Gvdmr-0005MN-TV
	for linux-xfs@oss.sgi.com; Sat, 16 Dec 2006 18:57:29 +0100
Received: from finn.gmane.org ([80.91.229.4])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Sat, 16 Dec 2006 18:57:29 +0100
Received: from mszpak by finn.gmane.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Sat, 16 Dec 2006 18:57:29 +0100
From: =?ISO-8859-2?Q?Marcin_Zaj=B1czkowski?= <mszpak@wp.pl>
Subject: xfs_ncheck (actually xfs_db) eats a lot of memory and is killed
Date: Sat, 16 Dec 2006 18:58:00 +0100
Message-ID: <em1c1v$ig8$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Hi,


A few weeks ago I described problem with my file system (caused by a bug 
in kernel 2.6.17) - http://oss.sgi.com/archives/xfs/2006-11/msg00271.html

Recently I've got rescue CD with xfs_progs in version 2.8.11 and tried 
to repair it. xfs_repair gave me about 150 files with names like inode 
numbers in /lost+found and 1500 "normal" named files in its subdirectory.
I've tried to use "xfs_ncheck -i inode /dev/hdX" to got names 
corresponding with specified inode(s), but program had been runing 
several minutes, xfs_db had eaten all available memory (768MB) and was 
killed by system (whole system hung too). The second time I killed it 
(kill -15) when it ate whole available memory.
My file system has about 6GB and is filled with 95%.


Am I doing something wrong with xfs_db?
Is there any easier way to restore my files?


Btw, xfs_check shows two lines:
link count mismatch for inode 1572882 (name ?), nlink 16, counted 15
link count mismatch for inode 2102297 (name ?), nlink 2, counted 3
Can it be reason for strange xfs_db behavior?


Thanks for help
Marcin
