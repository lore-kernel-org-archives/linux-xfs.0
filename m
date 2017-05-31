Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50337 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751011AbdEaQT1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 May 2017 12:19:27 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/24] nfsd: namespace-prefix uuid_parse
Date: Wed, 31 May 2017 18:18:09 +0200
Message-Id: <20170531161826.23243-8-hch@lst.de>
In-Reply-To: <20170531161826.23243-1-hch@lst.de>
References: <20170531161826.23243-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/nfsd/export.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index e71f11b1a180..3bc08c394a3f 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -486,7 +486,7 @@ secinfo_parse(char **mesg, char *buf, struct svc_export *exp) { return 0; }
 #endif
 
 static inline int
-uuid_parse(char **mesg, char *buf, unsigned char **puuid)
+nfsd_uuid_parse(char **mesg, char *buf, unsigned char **puuid)
 {
 	int len;
 
@@ -586,7 +586,7 @@ static int svc_export_parse(struct cache_detail *cd, char *mesg, int mlen)
 			if (strcmp(buf, "fsloc") == 0)
 				err = fsloc_parse(&mesg, buf, &exp.ex_fslocs);
 			else if (strcmp(buf, "uuid") == 0)
-				err = uuid_parse(&mesg, buf, &exp.ex_uuid);
+				err = nfsd_uuid_parse(&mesg, buf, &exp.ex_uuid);
 			else if (strcmp(buf, "secinfo") == 0)
 				err = secinfo_parse(&mesg, buf, &exp);
 			else
-- 
2.11.0

