Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BA2257F60
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 05:11:18 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4A748AC00E
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 03:11:18 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id 37XBPchR8TrW201d (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2015 03:11:15 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/20] nfsd: add fh_fsid_match helper
Date: Thu, 22 Jan 2015 12:09:52 +0100
Message-Id: <1421925006-24231-7-git-send-email-hch@lst.de>
In-Reply-To: <1421925006-24231-1-git-send-email-hch@lst.de>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
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
