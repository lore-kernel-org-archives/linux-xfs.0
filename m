Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38471 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933342AbdEOPoI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 May 2017 11:44:08 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/17] s390/sysinfo: use uuid_is_null instead of opencoding it
Date: Mon, 15 May 2017 17:43:00 +0200
Message-Id: <20170515154308.26739-10-hch@lst.de>
In-Reply-To: <20170515154308.26739-1-hch@lst.de>
References: <20170515154308.26739-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/s390/kernel/sysinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

