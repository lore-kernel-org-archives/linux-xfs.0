Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53781 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdE1KVr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 May 2017 06:21:47 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 20/22] scsi_debug: switch to uuid_t
Date: Sun, 28 May 2017 13:20:06 +0300
Message-Id: <20170528102008.30276-21-hch@lst.de>
In-Reply-To: <20170528102008.30276-1-hch@lst.de>
References: <20170528102008.30276-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/scsi/scsi_debug.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 17249c3650fe..35ee09644cfb 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -245,7 +245,7 @@ struct sdebug_dev_info {
 	unsigned int channel;
 	unsigned int target;
 	u64 lun;
-	uuid_be lu_name;
+	uuid_t lu_name;
 	struct sdebug_host_info *sdbg_host;
 	unsigned long uas_bm[1];
 	atomic_t num_in_q;
@@ -965,7 +965,7 @@ static const u64 naa3_comp_c = 0x3111111000000000ULL;
 static int inquiry_vpd_83(unsigned char *arr, int port_group_id,
 			  int target_dev_id, int dev_id_num,
 			  const char *dev_id_str, int dev_id_str_len,
-			  const uuid_be *lu_name)
+			  const uuid_t *lu_name)
 {
 	int num, port_a;
 	char b[32];
@@ -3568,7 +3568,7 @@ static void sdebug_q_cmd_wq_complete(struct work_struct *work)
 }
 
 static bool got_shared_uuid;
-static uuid_be shared_uuid;
+static uuid_t shared_uuid;
 
 static struct sdebug_dev_info *sdebug_device_create(
 			struct sdebug_host_info *sdbg_host, gfp_t flags)
@@ -3578,12 +3578,12 @@ static struct sdebug_dev_info *sdebug_device_create(
 	devip = kzalloc(sizeof(*devip), flags);
 	if (devip) {
 		if (sdebug_uuid_ctl == 1)
-			uuid_be_gen(&devip->lu_name);
+			uuid_gen(&devip->lu_name);
 		else if (sdebug_uuid_ctl == 2) {
 			if (got_shared_uuid)
 				devip->lu_name = shared_uuid;
 			else {
-				uuid_be_gen(&shared_uuid);
+				uuid_gen(&shared_uuid);
 				got_shared_uuid = true;
 				devip->lu_name = shared_uuid;
 			}
-- 
2.11.0

