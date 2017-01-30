Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mailrelay112.isp.belgacom.be ([195.238.20.139]:26270 "EHLO
        mailrelay112.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751047AbdA3Sk1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jan 2017 13:40:27 -0500
From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 00/14] use atomic_dec_not_zero()
Date: Mon, 30 Jan 2017 19:39:20 +0100
Message-Id: <20170130183920.12476-1-fabf@skynet.be>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-pm@vger.kernel.org, openipmi-developer@lists.sourceforge.net, dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net, Akinobu Mita <akinobu.mita@gmail.com>, Fabian Frederick <fabf@skynet.be>

complementary definition to atomic_inc_not_zero() featured in
lib/fault-inject.c. This small patchset moves it to
include/linux/atomic.h using it instead of
atomic_add_unless(value, -1, 0)

s390 patches were not compile-tested.

Fabian Frederick (14):
  locking/atomic: import atomic_dec_not_zero()
  drm/exynos: use atomic_dec_not_zero()
  drm/omap: use atomic_dec_not_zero()
  m5mols: use atomic_dec_not_zero()
  omap3isp: use atomic_dec_not_zero()
  s390/qeth: use atomic_dec_not_zero()
  PM / RUNTIME: use atomic_dec_not_zero()
  ipmi: use atomic_dec_not_zero()
  kdb: use atomic_dec_not_zero()
  PM / Hibernate: use atomic_dec_not_zero()
  PM: use atomic_dec_not_zero()
  s390/topology: use atomic_dec_not_zero()
  ext4: use atomic_dec_not_zero()
  xfs: use atomic_dec_not_zero()

 arch/s390/kernel/topology.c               | 2 +-
 drivers/base/power/runtime.c              | 4 ++--
 drivers/char/ipmi/ipmi_msghandler.c       | 2 +-
 drivers/gpu/drm/exynos/exynos_drm_fimd.c  | 2 +-
 drivers/gpu/drm/omapdrm/omap_dmm_tiler.c  | 2 +-
 drivers/media/i2c/m5mols/m5mols_core.c    | 2 +-
 drivers/media/platform/omap3isp/ispstat.c | 2 +-
 drivers/s390/net/qeth_core_main.c         | 2 +-
 fs/ext4/ext4.h                            | 2 +-
 fs/xfs/xfs_buf.c                          | 2 +-
 include/linux/atomic.h                    | 2 ++
 kernel/debug/kdb/kdb_main.c               | 2 +-
 kernel/power/hibernate.c                  | 4 ++--
 kernel/power/user.c                       | 2 +-
 lib/fault-inject.c                        | 2 --
 15 files changed, 17 insertions(+), 17 deletions(-)

-- 
2.9.3

