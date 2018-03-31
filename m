Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:31119 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752483AbeCaEMt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 31 Mar 2018 00:12:49 -0400
Subject: [PATCH v8 08/18] dax: introduce CONFIG_DAX_DRIVER
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 30 Mar 2018 21:02:52 -0700
Message-ID: <152246897244.36038.14718237765737542802.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152246892890.36038.18436540150980653229.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152246892890.36038.18436540150980653229.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-nvdimm@lists.01.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, Mike Snitzer <snitzer@redhat.com>, david@fromorbit.com, hch@lst.de, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, jack@suse.czsnitzer@redhat.com

In support of allowing device-mapper to compile out idle/dead code when
there are no dax providers in the system, introduce the DAX_DRIVER
symbol. This is selected by all leaf drivers that device-mapper might be
layered on top. This allows device-mapper to conditionally 'select DAX'
only when a provider is present.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Reported-by: Bart Van Assche <Bart.VanAssche@wdc.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/Kconfig        |    5 ++++-
 drivers/nvdimm/Kconfig     |    2 +-
 drivers/s390/block/Kconfig |    2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index b79aa8f7a497..e0700bf4893a 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -1,3 +1,7 @@
+config DAX_DRIVER
+	select DAX
+	bool
+
 menuconfig DAX
 	tristate "DAX: direct access to differentiated memory"
 	select SRCU
@@ -16,7 +20,6 @@ config DEV_DAX
 	  baseline memory pool.  Mappings of a /dev/daxX.Y device impose
 	  restrictions that make the mapping behavior deterministic.
 
-
 config DEV_DAX_PMEM
 	tristate "PMEM DAX: direct access to persistent memory"
 	depends on LIBNVDIMM && NVDIMM_DAX && DEV_DAX
diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index a65f2e1d9f53..40cbdb16e23e 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -20,7 +20,7 @@ if LIBNVDIMM
 config BLK_DEV_PMEM
 	tristate "PMEM: Persistent memory block device support"
 	default LIBNVDIMM
-	select DAX
+	select DAX_DRIVER
 	select ND_BTT if BTT
 	select ND_PFN if NVDIMM_PFN
 	help
diff --git a/drivers/s390/block/Kconfig b/drivers/s390/block/Kconfig
index 1444333210c7..9ac7574e3cfb 100644
--- a/drivers/s390/block/Kconfig
+++ b/drivers/s390/block/Kconfig
@@ -15,8 +15,8 @@ config BLK_DEV_XPRAM
 
 config DCSSBLK
 	def_tristate m
-	select DAX
 	select FS_DAX_LIMITED
+	select DAX_DRIVER
 	prompt "DCSSBLK support"
 	depends on S390 && BLOCK
 	help

