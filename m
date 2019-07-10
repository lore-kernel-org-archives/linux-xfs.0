Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from egyptian.birch.relay.mailchannels.net ([23.83.209.56]:61261
        "EHLO egyptian.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725994AbfGJJwd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 05:52:33 -0400
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id AFD255E1FE0
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 09:47:19 +0000 (UTC)
Received: from pdx1-sub0-mail-a65.g.dreamhost.com (100-96-92-226.trex.outbound.svc.cluster.local [100.96.92.226])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 433D55E1CEA
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 09:47:19 +0000 (UTC)
Received: from pdx1-sub0-mail-a65.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a65.g.dreamhost.com (Postfix) with ESMTP id 7F68C7F14C
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 02:47:18 -0700 (PDT)
Received: from [172.23.0.131] (broadband-178-140-10-107.ip.moscow.rt.ru [178.140.10.107])
        (using TLSv1.1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: a-j@a-j.ru)
        by pdx1-sub0-mail-a65.g.dreamhost.com (Postfix) with ESMTPSA id 8CF027F13A
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 02:47:17 -0700 (PDT)
Date: Wed, 10 Jul 2019 12:47:10 +0300
From: Andrey Zhunev <a-j@a-j.ru>
Message-ID: <958316946.20190710124710@a-j.ru>
Subject: Need help to recover root filesystem after a power supply issue
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello All,

I am struggling to recover my system after a PSU failure.

One of the hard drives throws some read errors, and that happen to be
my root drive...
My system is CentOS 7, and the root partition is a part of LVM.

[root@mgmt ~]# lvscan
  ACTIVE            '/dev/centos/root' [<98.83 GiB] inherit
  ACTIVE            '/dev/centos/home' [<638.31 GiB] inherit
  ACTIVE            '/dev/centos/swap' [<7.52 GiB] inherit
[root@mgmt ~]#

[root@tftp ~]# file -s /dev/centos/root
/dev/centos/root: symbolic link to `../dm-3'
[root@tftp ~]# file -s /dev/centos/home
/dev/centos/home: symbolic link to `../dm-4'
[root@tftp ~]# file -s /dev/dm-3
/dev/dm-3: SGI XFS filesystem data (blksz 4096, inosz 256, v2 dirs)
[root@tftp ~]# file -s /dev/dm-4
/dev/dm-4: SGI XFS filesystem data (blksz 4096, inosz 256, v2 dirs)


[root@tftp ~]# xfs_repair /dev/centos/root
Phase 1 - find and verify superblock...
superblock read failed, offset 53057945600, size 131072, ag 2, rval -1

fatal error -- Input/output error
[root@tftp ~]#


smartctl shows some pending sectors on /dev/sda, and no reallocated
sectors (yet?).

Can someone please give me a hand to bring root partition back to life
(ideally)? Or, at least, recover a couple of critical configuration
files...


---
Best regards,
 Andrey                    
