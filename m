Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D2E617F6A
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 10:29:39 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BD7C1304051
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 08:29:39 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id xUFoPvMWFJ1wMhpr (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 08:29:38 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/18] nfsd: add fh_fsid_match helper
Date: Tue,  6 Jan 2015 17:28:28 +0100
Message-Id: <1420561721-9150-6-git-send-email-hch@lst.de>
In-Reply-To: <1420561721-9150-1-git-send-email-hch@lst.de>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

Add a helper to check that the fsid parts of two file handles match.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/nfsd/nfsfh.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/nfsd/nfsfh.h b/fs/nfsd/nfsfh.h
index e24d954..84cae20 100644
--- a/fs/nfsd/nfsfh.h
+++ b/fs/nfsd/nfsfh.h
@@ -196,6 +196,15 @@ static inline bool fh_match(struct knfsd_fh *fh1, struct knfsd_fh *fh2)
 	return true;
 }
 
+static inline bool fh_fsid_match(struct knfsd_fh *fh1, struct knfsd_fh *fh2)
+{
+	if (fh1->fh_fsid_type != fh2->fh_fsid_type)
+		return false;
+	if (memcmp(fh1->fh_fsid, fh2->fh_fsid, key_len(fh1->fh_fsid_type) != 0))
+		return false;
+	return true;
+}
+
 #ifdef CONFIG_NFSD_V3
 /*
  * The wcc data stored in current_fh should be cleared
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
