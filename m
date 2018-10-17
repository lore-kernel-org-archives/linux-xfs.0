Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f44.google.com ([209.85.128.44]:39578 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbeJQPrT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Oct 2018 11:47:19 -0400
Received: by mail-wm1-f44.google.com with SMTP id y144-v6so1056955wmd.4
        for <linux-xfs@vger.kernel.org>; Wed, 17 Oct 2018 00:52:52 -0700 (PDT)
From: Avi Kivity <avi@scylladb.com>
Subject: ENSOPC on a 10% used disk
Message-ID: <40c52a7b-2520-8ae4-11d5-ae4b33e1dc29@scylladb.com>
Date: Wed, 17 Oct 2018 10:52:48 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

I have a user running a 1.7TB filesystem with ~10% usage (as shown by 
df), getting sporadic ENOSPC errors. The disk is mounted with inode64 
and has a relatively small number of large files. The disk is a 
single-member RAID0 array, with 1MB chunk size. There are 32 AGs. 
Running Linux 4.9.17.


The write load consists of AIO/DIO writes, followed by unlinks of these 
files. The writes are non-size-changing (we truncate ahead) and we use 
XFS_IOC_FSSETXATTR/XFS_FLAG_EXTSIZE with a hint size of 32MB. The errors 
happen on commit logs, which have a target size of 32MB (but may exceed 
it a little).


The errors are sporadic and after restarting the workload they go away 
for a few hours to a few days, but then return. During one of the 
crashes I used xfs_db to look at fragmentation and saw that most AGs had 
free extents of size categories up to 128-255, but a few had more. I 
tried xfs_fsr but it did not help.


Is this a known issue? Would upgrading the kernel help?


I'll try to get a metadata dump next time this happens, and I'll be 
happy to supply more information.
