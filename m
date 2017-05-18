Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51808 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932373AbdERG20 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 May 2017 02:28:26 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 20/23] sysctl: switch to use uuid_t
Date: Thu, 18 May 2017 08:27:02 +0200
Message-Id: <20170518062705.25902-21-hch@lst.de>
In-Reply-To: <20170518062705.25902-1-hch@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 kernel/sysctl_binary.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index ece4b177052b..1ae520eed53c 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -1119,7 +1119,7 @@ static ssize_t bin_uuid(struct file *file,
 	/* Only supports reads */
 	if (oldval && oldlen) {
 		char buf[UUID_STRING_LEN + 1];
-		uuid_be uuid;
+		uuid_t uuid;
 
 		result = kernel_read(file, 0, buf, sizeof(buf) - 1);
 		if (result < 0)
@@ -1128,7 +1128,7 @@ static ssize_t bin_uuid(struct file *file,
 		buf[result] = '\0';
 
 		result = -EIO;
-		if (uuid_be_to_bin(buf, &uuid))
+		if (uuid_to_bin(buf, &uuid))
 			goto out;
 
 		if (oldlen > 16)
-- 
2.11.0

