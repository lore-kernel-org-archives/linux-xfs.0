Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:15037 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750822AbdEMLYD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 13 May 2017 07:24:03 -0400
Subject: [pre-linux-4.12-rc1] undefined reference to `put_dax' `dax_get_by_host'
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201705132023.CEI64165.FtQJFOMFOHOSVL@I-love.SAKURA.ne.jp>
Date: Sat, 13 May 2017 20:23:58 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: dan.j.williams@intel.com
Cc: linux-xfs@vger.kernel.org

Hello.

I got build failures as of commit 0fcc3ab23d7395f5 ("Merge branch 'libnvdimm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm").

$ make
fs/built-in.o: In function `xfs_file_iomap_end':
xfs_iomap.c:(.text+0xe0ef9): undefined reference to `put_dax'
fs/built-in.o: In function `xfs_file_iomap_begin':
xfs_iomap.c:(.text+0xe1a7f): undefined reference to `dax_get_by_host'
make: *** [vmlinux] Error 1
$ grep DAX .config
CONFIG_DAX=m
# CONFIG_DEV_DAX is not set
# CONFIG_FS_DAX is not set
