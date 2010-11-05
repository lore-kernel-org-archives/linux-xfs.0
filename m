Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA537FXe176352 for <xfs@oss.sgi.com>; Thu, 4 Nov 2010 22:07:15 -0500
Received: from mail.perches.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D33C4138CE8C
	for <xfs@oss.sgi.com>; Thu,  4 Nov 2010 20:08:36 -0700 (PDT)
Received: from mail.perches.com (mail.perches.com [173.55.12.10]) by
	cuda.sgi.com with ESMTP id fq0MQTp5hkgIcPoo for
	<xfs@oss.sgi.com>; Thu, 04 Nov 2010 20:08:36 -0700 (PDT)
From: Joe Perches <joe@perches.com>
Subject: [PATCH 00/49] Use vzalloc not vmalloc/kmemset
Date: Thu,  4 Nov 2010 20:07:24 -0700
Message-Id: <cover.1288925424.git.joe@perches.com>
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-mips@linux-mips.org, alsa-devel@alsa-project.org, linux-ia64@vger.kernel.org, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, dm-devel@redhat.com, linux-mtd@lists.infradead.org, devel@driverdev.osuosl.org, linux-s390@vger.kernel.org, rds-devel@oss.oracle.com, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, linux-atm-general@lists.sourceforge.net, virtualization@lists.osdl.org, coreteam@netfilter.org, linux-input@vger.kernel.org, osst-users@lists.sourceforge.net, linux-ext4@vger.kernel.org, linux-media@vger.kernel.org, cbe-oss-dev@lists.ozlabs.org, amd64-microcode@amd64.org, reiserfs-devel@vger.kernel.org, kvm-ppc@vger.kernel.org, xfs@oss.sgi.com, linux-raid@vger.kernel.org, netfilter@vger.kernel.org, codalist@TELEMANN.coda.cs.cmu.edu, netdev@vger.kernel.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, xen-devel@lists.xen.org, e1000-devel@lists.sourceforge.net, netfilter-devel@vger.kernel.org, linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, drbd-user@lists.linbit.com

Converted vmalloc/memset and vmalloc_node/memset to
vzalloc or vzalloc_node using a cocci script and some editing

Reduces text a little bit.

Compiled x86 only.

There are still vmalloc_32 with memset calls still around.

Broken out to multiple patches to cc appropriate maintainers.

Joe Perches (49):
  arch/ia64: Use vzalloc
  arch/mips: Use vzalloc
  arch/powerpc: Use vzalloc
  arch/s390: Use vzalloc
  arch/x86: Use vzalloc
  crypto: Use vzalloc
  drivers/atm: Use vzalloc
  drivers/block: Use vzalloc
  drivers/char: Use vzalloc
  drivers/gpu: Use vzalloc
  drivers/hid: Use vzalloc
  drivers/infiniband: Use vzalloc
  drivers/isdn: Use vzalloc
  drivers/md: Use vzalloc
  drivers/media: Use vzalloc
  drivers/mtd: Use vzalloc
  drivers/net/cxgb3: Use vzalloc
  drivers/net/cxgb4: Use vzalloc
  drivers/net/e1000: Use vzalloc
  drivers/net/e1000e: Use vzalloc
  drivers/net/ehea: Use vzalloc
  drivers/net/igb: Use vzalloc
  drivers/net/igbvf: Use vzalloc
  drivers/net/ixgb: Use vzalloc
  drivers/net/ixgbe: Use vzalloc
  drivers/net/ixgbevf: Use vzalloc
  drivers/net/netxen: Use vzalloc
  drivers/net/pch_gbe: Use vzalloc
  drivers/net/qlcnic: Use vzalloc
  drivers/net/sfc: Use vzalloc
  drivers/net/vxge: Use vzalloc
  drivers/net/bnx2.c: Use vzalloc
  drivers/s390: Use vzalloc
  drivers/scsi: Use vzalloc
  drivers/staging: Use vzalloc
  drivers/video: Use vzalloc
  fs/ext4: Use vzalloc
  fs/jffs2: Use vzalloc
  fs/reiserfs: Use vzalloc
  fs/udf: Use vzalloc
  fs/xfs: Use vzalloc
  include/linux/coda_linux.h: Use vzalloc
  kernel: Use vzalloc
  mm: Use vzalloc
  net/core/pktgen.c: Use vzalloc
  net/netfilter: Use vzalloc
  net/rds: Use vzalloc
  sound/oss/dev_table.c: Use vzalloc
  virt/kvm/kvm_main.c: Use vzalloc

 arch/ia64/kernel/perfmon.c                      |    3 +-
 arch/mips/sibyte/common/sb_tbprof.c             |    3 +-
 arch/powerpc/kvm/book3s.c                       |    6 +--
 arch/powerpc/platforms/cell/spufs/lscsa_alloc.c |    3 +-
 arch/s390/hypfs/hypfs_diag.c                    |    3 +-
 arch/x86/kernel/microcode_amd.c                 |    3 +-
 arch/x86/kvm/x86.c                              |    3 +-
 arch/x86/mm/pageattr-test.c                     |    3 +-
 crypto/deflate.c                                |    3 +-
 crypto/zlib.c                                   |    3 +-
 drivers/atm/idt77252.c                          |   11 ++++---
 drivers/atm/lanai.c                             |    3 +-
 drivers/block/drbd/drbd_bitmap.c                |    5 +--
 drivers/char/agp/backend.c                      |    3 +-
 drivers/char/mspec.c                            |    5 +--
 drivers/gpu/drm/via/via_dmablit.c               |    4 +-
 drivers/hid/hid-core.c                          |    3 +-
 drivers/infiniband/hw/amso1100/c2_rnic.c        |    5 +--
 drivers/infiniband/hw/ehca/ipz_pt_fn.c          |    5 +--
 drivers/infiniband/hw/ipath/ipath_driver.c      |    3 +-
 drivers/infiniband/hw/ipath/ipath_file_ops.c    |   11 ++-----
 drivers/infiniband/hw/ipath/ipath_init_chip.c   |    5 +--
 drivers/infiniband/hw/qib/qib_init.c            |    7 +---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c         |   10 ++----
 drivers/infiniband/ulp/ipoib/ipoib_main.c       |    3 +-
 drivers/isdn/i4l/isdn_common.c                  |    4 +-
 drivers/isdn/mISDN/dsp_core.c                   |    3 +-
 drivers/isdn/mISDN/l1oip_codec.c                |    6 +--
 drivers/md/dm-log.c                             |    3 +-
 drivers/md/dm-snap-persistent.c                 |    3 +-
 drivers/md/dm-table.c                           |    4 +--
 drivers/media/dvb/ngene/ngene-core.c            |    3 +-
 drivers/media/video/mx3_camera.c                |    3 +-
 drivers/media/video/pwc/pwc-if.c                |    3 +-
 drivers/media/video/videobuf-dma-sg.c           |    3 +-
 drivers/mtd/nand/nandsim.c                      |    3 +-
 drivers/mtd/ubi/vtbl.c                          |    6 +--
 drivers/net/bnx2.c                              |   10 +-----
 drivers/net/cxgb3/cxgb3_offload.c               |    7 ++--
 drivers/net/cxgb4/cxgb4_main.c                  |    7 ++--
 drivers/net/e1000/e1000_main.c                  |    6 +--
 drivers/net/e1000e/netdev.c                     |    6 +--
 drivers/net/ehea/ehea_main.c                    |    4 +--
 drivers/net/igb/igb_main.c                      |    6 +--
 drivers/net/igbvf/netdev.c                      |    6 +--
 drivers/net/ixgb/ixgb_main.c                    |    6 +--
 drivers/net/ixgbe/ixgbe_main.c                  |   10 ++----
 drivers/net/ixgbevf/ixgbevf_main.c              |    6 +--
 drivers/net/netxen/netxen_nic_init.c            |    7 +---
 drivers/net/pch_gbe/pch_gbe_main.c              |    6 +--
 drivers/net/qlcnic/qlcnic_init.c                |    7 +---
 drivers/net/sfc/filter.c                        |    3 +-
 drivers/net/vxge/vxge-config.c                  |   37 +++++-----------------
 drivers/s390/cio/blacklist.c                    |    3 +-
 drivers/scsi/bfa/bfad.c                         |    3 +-
 drivers/scsi/bfa/bfad_debugfs.c                 |    8 +----
 drivers/scsi/cxgbi/libcxgbi.h                   |    9 ++----
 drivers/scsi/osst.c                             |    3 +-
 drivers/scsi/qla2xxx/qla_attr.c                 |    3 +-
 drivers/scsi/qla2xxx/qla_bsg.c                  |    3 +-
 drivers/scsi/scsi_debug.c                       |    7 +---
 drivers/staging/comedi/drivers.c                |    4 +--
 drivers/staging/rtl8192e/r8192E_core.c          |    4 +--
 drivers/staging/udlfb/udlfb.c                   |    5 +--
 drivers/staging/xgifb/XGI_main_26.c             |    3 +-
 drivers/staging/zram/zram_drv.c                 |    3 +-
 drivers/video/arcfb.c                           |    5 +--
 drivers/video/broadsheetfb.c                    |    4 +--
 drivers/video/hecubafb.c                        |    5 +--
 drivers/video/metronomefb.c                     |    4 +--
 drivers/video/xen-fbfront.c                     |    3 +-
 fs/ext4/super.c                                 |    4 +--
 fs/jffs2/build.c                                |    5 +--
 fs/reiserfs/journal.c                           |    9 ++----
 fs/reiserfs/resize.c                            |    4 +--
 fs/udf/super.c                                  |    5 +--
 fs/xfs/linux-2.6/kmem.h                         |    7 +----
 include/linux/coda_linux.h                      |   26 ++++++++++------
 kernel/profile.c                                |    6 +--
 kernel/relay.c                                  |    4 +--
 mm/memcontrol.c                                 |    5 +--
 mm/page_cgroup.c                                |    3 +-
 mm/percpu.c                                     |    8 +----
 mm/swapfile.c                                   |    3 +-
 net/core/pktgen.c                               |    3 +-
 net/netfilter/x_tables.c                        |    5 +--
 net/rds/ib_cm.c                                 |    6 +--
 sound/oss/dev_table.c                           |    6 +--
 virt/kvm/kvm_main.c                             |   13 ++------
 89 files changed, 167 insertions(+), 328 deletions(-)

-- 
1.7.3.1.g432b3.dirty

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
