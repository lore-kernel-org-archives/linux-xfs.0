Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f181.google.com ([209.85.208.181]:33026 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbeJTUyL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Oct 2018 16:54:11 -0400
Received: by mail-lj1-f181.google.com with SMTP id z21-v6so33122644ljz.0
        for <linux-xfs@vger.kernel.org>; Sat, 20 Oct 2018 05:43:48 -0700 (PDT)
MIME-Version: 1.0
From: Oleg Davydov <burunduk3@gmail.com>
Date: Sat, 20 Oct 2018 15:43:36 +0300
Message-ID: <CA+MkmrPWg=pD5t-bt8ye36bi8prep+FjM_n-L4XnG-PRJc--7w@mail.gmail.com>
Subject: Segmentation fault in xfs_repair
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

I try to repair file system from corrupter drive and this leads to
Segmentaion Fault in xfs_repair. You can see some logs here (incl.
stack trace from coredump): https://pastebin.com/farKCDRi

I tried xfsprogs-4.14.0 (currently installed on my system), custom
build from git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git, from
master (3caeb69c) and from libxfs-4.19-sync (b5c71bcd), all ended in
the same result.

Please suggest me how to fix it, how to get some more information
about the problem or how can I workaround it. Additional problem is
that I can't even mount filesystem now (mount fails with Corruption
warning: Metadata has LSN (1674570203:54480) ahead of current LSN
(1:8). Please unmount and run xfs_repair (>= v4.3) to resolve.)

-------------------------------------
All the best,
   Oleg [burunduk3] Davydov
