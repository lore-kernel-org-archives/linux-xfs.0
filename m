Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Apr 2007 01:41:07 -0700 (PDT)
Received: from ex-osl-dc03.exense.int (exense-pdc.exense.com [195.204.47.129])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3J8f2fB024171
	for <xfs@oss.sgi.com>; Thu, 19 Apr 2007 01:41:03 -0700
Message-ID: <4627283E.7060000@start.no>
Date: Thu, 19 Apr 2007 10:28:46 +0200
From: "Stein M. Hugubakken" <dulci@start.no>
MIME-Version: 1.0
Subject: Inode usage
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi!

I have a lot of free inodes on my xfs-partitions and was wondering about 
what impact this has on performance or memory?

Here is output from 'df':
df -ih
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/hda2               5,1M    129K    5,0M    3% /
/dev/hda3                31M     54K     31M    1% /home

df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/hda2             5,1G  2,8G  2,4G  55% /
/dev/hda3              31G   18G   13G  59% /home

With xfs_growfs -m I can adjust the amount of free inodes, but it seems 
I can't change it for the root-partition, why is that a problem?

Kind regards
Stein
