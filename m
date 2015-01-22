Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 161D27F56
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 05:11:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 996A4AC00F
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 03:11:19 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id dlMTic6vOhEa9P2m (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2015 03:11:18 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/20] nfsd: make find_any_file available outside nfs4state.c
Date: Thu, 22 Jan 2015 12:09:55 +0100
Message-Id: <1421925006-24231-10-git-send-email-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/nfsd/nfs4state.c | 2 +-
 fs/nfsd/state.h     | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index c31b8f8..444d43c 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -352,7 +352,7 @@ find_readable_file(struct nfs4_file *f)
 	return ret;
 }
 
-static struct file *
+struct file *
 find_any_file(struct nfs4_file *f)
 {
 	struct file *ret;
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index cd61e7d..18b5ab8 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -579,6 +579,7 @@ static inline void get_nfs4_file(struct nfs4_file *fi)
 {
 	atomic_inc(&fi->fi_ref);
 }
+struct file *find_any_file(struct nfs4_file *f);
 
 /* grace period management */
 void nfsd4_end_grace(struct nfsd_net *nn);
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
