Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:55885 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbfHNUpn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Aug 2019 16:45:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v5 00/18] compat_ioctl.c removal, part 2/3 
Date: Wed, 14 Aug 2019 22:42:27 +0200
Message-Id: <20190814204259.120942-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, davem@davemloft.net, axboe@kernel.dk, linux-block@vger.kernel.org, minyard@acm.org, gregkh@linuxfoundation.org, linux@roeck-us.net, alexandre.belloni@bootlin.com, jejb@linux.ibm.com, martin.petersen@oracle.com, dgilbert@interlog.com, jslaby@suse.com, wim@linux-watchdog.org, tytso@mit.edu, adilger.kernel@dilger.ca, jaegeuk@kernel.org, rpeterso@redhat.com, agruenba@redhat.com, mikulas@artax.karlin.mff.cuni.cz, konishi.ryusuke@gmail.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, netdev@vger.kernel.org, openipmi-developer@lists.sourceforge.net, linux-hwmon@vger.kernel.org, linux-ppp@vger.kernel.org, linux-rtc@vger.kernel.org, linux-scsi@vger.kernel.org, linux-watchdog@vger.kernel.org, ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com

This is a follow-up to part 1/3 that I posted after -rc2.
I hope these are still largely uncontroversial changes, and
I would like to get them into linux-5.4.

Part 1 was in

https://lore.kernel.org/lkml/CAPcyv4i_nHzV155RcgnAQ189aq2Lfd2g8pA1D5NbZqo9E_u+Dw@mail.gmail.com/

Part 3 will be one kernel release after part 2 is merged,
as that still needs a little extra work.

The entire series is available at

git://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git compat_ioctl

      Arnd

Al Viro (2):
  compat_ioctl: unify copy-in of ppp filters
  compat_ioctl: move PPPIOCSCOMPRESS to ppp_generic

Arnd Bergmann (16):
  xfs: compat_ioctl: use compat_ptr()
  xfs: compat_ioctl: add missing conversions
  gfs2: add compat_ioctl support
  fs: compat_ioctl: move FITRIM emulation into file systems
  watchdog: cpwd: use generic compat_ptr_ioctl
  compat_ioctl: move WDIOC handling into wdt drivers
  compat_ioctl: reimplement SG_IO handling
  af_unix: add compat_ioctl support
  compat_ioctl: handle SIOCOUTQNSD
  compat_ioctl: move SIOCOUTQ out of compat_ioctl.c
  tty: handle compat PPP ioctls
  compat_ioctl: handle PPPIOCGIDLE for 64-bit time_t
  compat_ioctl: ppp: move simple commands into ppp_generic.c
  compat_ioctl: move SG_GET_REQUEST_TABLE handling
  pktcdvd: add compat_ioctl handler
  scsi: sd: enable compat ioctls for sed-opal

 Documentation/networking/ppp_generic.txt  |   2 +
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c |   1 +
 arch/um/drivers/harddog_kern.c            |   1 +
 block/scsi_ioctl.c                        | 132 ++++++++-
 drivers/block/pktcdvd.c                   |  25 ++
 drivers/char/ipmi/ipmi_watchdog.c         |   1 +
 drivers/hwmon/fschmd.c                    |   1 +
 drivers/net/ppp/ppp_generic.c             | 245 ++++++++++-----
 drivers/rtc/rtc-ds1374.c                  |   1 +
 drivers/scsi/sd.c                         |  14 +-
 drivers/scsi/sg.c                         |  59 +++-
 drivers/tty/tty_io.c                      |   5 +
 drivers/watchdog/acquirewdt.c             |   1 +
 drivers/watchdog/advantechwdt.c           |   1 +
 drivers/watchdog/alim1535_wdt.c           |   1 +
 drivers/watchdog/alim7101_wdt.c           |   1 +
 drivers/watchdog/ar7_wdt.c                |   1 +
 drivers/watchdog/at91rm9200_wdt.c         |   1 +
 drivers/watchdog/ath79_wdt.c              |   1 +
 drivers/watchdog/bcm63xx_wdt.c            |   1 +
 drivers/watchdog/cpu5wdt.c                |   1 +
 drivers/watchdog/cpwd.c                   |  25 +-
 drivers/watchdog/eurotechwdt.c            |   1 +
 drivers/watchdog/f71808e_wdt.c            |   1 +
 drivers/watchdog/gef_wdt.c                |   1 +
 drivers/watchdog/geodewdt.c               |   1 +
 drivers/watchdog/ib700wdt.c               |   1 +
 drivers/watchdog/ibmasr.c                 |   1 +
 drivers/watchdog/indydog.c                |   1 +
 drivers/watchdog/intel_scu_watchdog.c     |   1 +
 drivers/watchdog/iop_wdt.c                |   1 +
 drivers/watchdog/it8712f_wdt.c            |   1 +
 drivers/watchdog/ixp4xx_wdt.c             |   1 +
 drivers/watchdog/ks8695_wdt.c             |   1 +
 drivers/watchdog/m54xx_wdt.c              |   1 +
 drivers/watchdog/machzwd.c                |   1 +
 drivers/watchdog/mixcomwd.c               |   1 +
 drivers/watchdog/mtx-1_wdt.c              |   1 +
 drivers/watchdog/mv64x60_wdt.c            |   1 +
 drivers/watchdog/nuc900_wdt.c             |   1 +
 drivers/watchdog/nv_tco.c                 |   1 +
 drivers/watchdog/pc87413_wdt.c            |   1 +
 drivers/watchdog/pcwd.c                   |   1 +
 drivers/watchdog/pcwd_pci.c               |   1 +
 drivers/watchdog/pcwd_usb.c               |   1 +
 drivers/watchdog/pika_wdt.c               |   1 +
 drivers/watchdog/pnx833x_wdt.c            |   1 +
 drivers/watchdog/rc32434_wdt.c            |   1 +
 drivers/watchdog/rdc321x_wdt.c            |   1 +
 drivers/watchdog/riowd.c                  |   1 +
 drivers/watchdog/sa1100_wdt.c             |   1 +
 drivers/watchdog/sb_wdog.c                |   1 +
 drivers/watchdog/sbc60xxwdt.c             |   1 +
 drivers/watchdog/sbc7240_wdt.c            |   1 +
 drivers/watchdog/sbc_epx_c3.c             |   1 +
 drivers/watchdog/sbc_fitpc2_wdt.c         |   1 +
 drivers/watchdog/sc1200wdt.c              |   1 +
 drivers/watchdog/sc520_wdt.c              |   1 +
 drivers/watchdog/sch311x_wdt.c            |   1 +
 drivers/watchdog/scx200_wdt.c             |   1 +
 drivers/watchdog/smsc37b787_wdt.c         |   1 +
 drivers/watchdog/w83877f_wdt.c            |   1 +
 drivers/watchdog/w83977f_wdt.c            |   1 +
 drivers/watchdog/wafer5823wdt.c           |   1 +
 drivers/watchdog/watchdog_dev.c           |   1 +
 drivers/watchdog/wdrtas.c                 |   1 +
 drivers/watchdog/wdt.c                    |   1 +
 drivers/watchdog/wdt285.c                 |   1 +
 drivers/watchdog/wdt977.c                 |   1 +
 drivers/watchdog/wdt_pci.c                |   1 +
 fs/compat_ioctl.c                         | 346 +---------------------
 fs/ecryptfs/file.c                        |   1 +
 fs/ext4/ioctl.c                           |   1 +
 fs/f2fs/file.c                            |   1 +
 fs/gfs2/file.c                            |  24 ++
 fs/hpfs/dir.c                             |   1 +
 fs/hpfs/file.c                            |   1 +
 fs/nilfs2/ioctl.c                         |   1 +
 fs/ocfs2/ioctl.c                          |   1 +
 fs/xfs/xfs_ioctl32.c                      |  11 +-
 include/linux/blkdev.h                    |   2 +
 include/uapi/linux/ppp-ioctl.h            |   2 +
 include/uapi/linux/ppp_defs.h             |  14 +
 lib/iov_iter.c                            |   1 +
 net/socket.c                              |   3 +
 net/unix/af_unix.c                        |  19 ++
 86 files changed, 526 insertions(+), 472 deletions(-)

-- 
2.20.0

Cc: davem@davemloft.net
Cc: axboe@kernel.dk
Cc: linux-block@vger.kernel.org
Cc: minyard@acm.org
Cc: gregkh@linuxfoundation.org
Cc: linux@roeck-us.net
Cc: alexandre.belloni@bootlin.com
Cc: jejb@linux.ibm.com
Cc: martin.petersen@oracle.com
Cc: dgilbert@interlog.com
Cc: jslaby@suse.com
Cc: wim@linux-watchdog.org
Cc: viro@zeniv.linux.org.uk
Cc: tytso@mit.edu
Cc: adilger.kernel@dilger.ca
Cc: jaegeuk@kernel.org
Cc: rpeterso@redhat.com
Cc: agruenba@redhat.com
Cc: mikulas@artax.karlin.mff.cuni.cz
Cc: konishi.ryusuke@gmail.com
Cc: jlbec@evilplan.org
Cc: joseph.qi@linux.alibaba.com
Cc: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: openipmi-developer@lists.sourceforge.net
Cc: linux-hwmon@vger.kernel.org
Cc: linux-ppp@vger.kernel.org
Cc: linux-rtc@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Cc: linux-watchdog@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: ecryptfs@vger.kernel.org
Cc: linux-ext4@vger.kernel.org
Cc: linux-f2fs-devel@lists.sourceforge.net
Cc: cluster-devel@redhat.com
Cc: linux-nilfs@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com
