Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:37847 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754515AbdDZQrS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Apr 2017 12:47:18 -0400
Received: by mail-wm0-f54.google.com with SMTP id m123so10406596wma.0
        for <linux-xfs@vger.kernel.org>; Wed, 26 Apr 2017 09:47:17 -0700 (PDT)
MIME-Version: 1.0
From: Gareth Clay <gclay@pivotal.io>
Date: Wed, 26 Apr 2017 17:47:15 +0100
Message-ID: <CAPeSaCC-Z+atujOq9+uj0tgdkWDNPadiQVDB+23tj=DBH-EKrw@mail.gmail.com>
Subject: Many D state processes on XFS, kernel 4.4
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

We're trying to diagnose a problem on an AWS virtual machine with two
XFS filesystems, each on loop devices. The loop files are sitting on
an EXT4 filesystem on Amazon EBS. The VM is running lots of Linux
containers - we're using Overlay FS on XFS to provide the root
filesystems for these containers.

The problem we're seeing is a lot of processes entering D state, stuck
in the xlog_grant_head_wait function. We're also seeing xfsaild/loop0
stuck in D state. We're not able to write to the filesystem at all on
this device, it seems, without the process hitting D state. Once the
processes enter D state they never recover, and the list of D state
processes seems to be growing slowly over time.

The filesystem on loop1 seems fine (we can run ls, touch etc)

Would anyone be able to help us to diagnose the underlying problem please?

Following the problem reporting FAQ we've collected the following
details from the VM:

uname -a:
Linux 8dd9526f-00ba-4f7b-aa59-a62ec661c060 4.4.0-72-generic
#93~14.04.1-Ubuntu SMP Fri Mar 31 15:05:15 UTC 2017 x86_64 x86_64
x86_64 GNU/Linux

xfs_repair version 3.1.9

AWS VM with 8 CPU cores and EBS storage

And we've also collected output from /proc, xfs_info, dmesg and the
XFS trace tool in the following files:

https://s3.amazonaws.com/grootfs-logs/dmesg
https://s3.amazonaws.com/grootfs-logs/meminfo
https://s3.amazonaws.com/grootfs-logs/mounts
https://s3.amazonaws.com/grootfs-logs/partitions
https://s3.amazonaws.com/grootfs-logs/trace_report.txt
https://s3.amazonaws.com/grootfs-logs/xfs_info

Thanks for any help or advice you can offer!

Claudia and Gareth
