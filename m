Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36729 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932271AbdERG15 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 May 2017 02:27:57 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/23] S390/sysinfo: use uuid_is_null instead of opencoding it
Date: Thu, 18 May 2017 08:26:51 +0200
Message-Id: <20170518062705.25902-10-hch@lst.de>
In-Reply-To: <20170518062705.25902-1-hch@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

.. and switch to use uuid_t instead of the old uuid_be type while we're
at it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/s390/include/asm/sysinfo.h | 4 ++--
 arch/s390/kernel/sysinfo.c      | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/sysinfo.h b/arch/s390/include/asm/sysinfo.h
index 73bff45ced55..e7f8e1b77d92 100644
--- a/arch/s390/include/asm/sysinfo.h
+++ b/arch/s390/include/asm/sysinfo.h
@@ -109,7 +109,7 @@ struct sysinfo_2_2_2 {
 	unsigned short cpus_shared;
 	char reserved_4[3];
 	unsigned char vsne;
-	uuid_be uuid;
+	uuid_t uuid;
 	char reserved_5[160];
 	char ext_name[256];
 };
@@ -134,7 +134,7 @@ struct sysinfo_3_2_2 {
 		char reserved_1[3];
 		unsigned char evmne;
 		unsigned int reserved_2;
-		uuid_be uuid;
+		uuid_t uuid;
 	} vm[8];
 	char reserved_3[1504];
 	char ext_names[8][256];
diff --git a/arch/s390/kernel/sysinfo.c b/arch/s390/kernel/sysinfo.c
index eefcb54872a5..fb869b103825 100644
--- a/arch/s390/kernel/sysinfo.c
+++ b/arch/s390/kernel/sysinfo.c
@@ -242,7 +242,7 @@ static void print_ext_name(struct seq_file *m, int lvl,
 
 static void print_uuid(struct seq_file *m, int i, struct sysinfo_3_2_2 *info)
 {
-	if (!memcmp(&info->vm[i].uuid, &NULL_UUID_BE, sizeof(uuid_be)))
+	if (uuid_is_null(&info->vm[i].uuid))
 		return;
 	seq_printf(m, "VM%02d UUID:            %pUb\n", i, &info->vm[i].uuid);
 }
-- 
2.11.0

