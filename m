Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ishtar.tlinx.org ([173.164.175.65]:49690 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbeKCNbW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Nov 2018 09:31:22 -0400
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id wA33xLcP042450
        for <linux-xfs@vger.kernel.org>; Fri, 2 Nov 2018 20:59:23 -0700
Message-ID: <5BDD1D19.7030208@tlinx.org>
Date: Fri, 02 Nov 2018 20:59:21 -0700
From: "L.A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: xfsprogs-4.16; scrubbing and files w/o /usr dependencies...
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linux-Xfs <linux-xfs@vger.kernel.org>

I was noticing in a newer version of xfsprogs that it puts some non-/usr-lib
dependent files in /sbin, specifically fsck.mfs(shell), mkfs.xfs, xfs_repair
xfs_scrub, and xfs_scrub_all.

What was the decider for putting these files in /sbin?  The reason I ask is
that the last one 'xfs_scrub_all' has a heavy dependency on /usr as it needs
#!/usr/bin/python3 to run.  So wouldn't it be happier in /usr/sbin? 

I also note that it has dependencies on systemd.  Will it work for
systems not running systemd or will systemd be required for newer-versioned
xfs maintenance?

Thnx...
