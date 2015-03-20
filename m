Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BE4777F37
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 02:56:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4B04DAC002
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 00:56:56 -0700 (PDT)
Received: from mail-pd0-f172.google.com (mail-pd0-f172.google.com
	[209.85.192.172]) by cuda.sgi.com with ESMTP id
	USYH1DeCU2E1tNl5 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Mar 2015 00:56:54 -0700 (PDT)
Received: by pdbcz9 with SMTP id cz9so101473482pdb.3
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 00:56:54 -0700 (PDT)
Message-ID: <550BD2B8.6070900@gmail.com>
Date: Fri, 20 Mar 2015 15:56:40 +0800
From: Kinglong Mee <kinglongmee@gmail.com>
MIME-Version: 1.0
Subject: [PATCH] NFSD: Fix infinite loop in nfsd4_cb_layout_fail()
References: <20150304020826.GD19439@fieldses.org>
	<20150304155421.GE1627@fieldses.org>
	<20150304220900.GX18360@dastard>
	<20150304222709.GI1627@fieldses.org>
	<20150304224557.GY4251@dastard> <54F78BE5.1020608@sandeen.net>
	<20150304225623.GZ4251@dastard>
	<20150305040849.GJ1627@fieldses.org>
	<20150305131731.GA16235@lst.de>
	<CAB6yy341fvF8Bsg0_hViQm+zRLVdJ2WOE9duDwdU+S0CkOEpbg@mail.gmail.com>
	<20150320065010.GC626@lst.de>
In-Reply-To: <20150320065010.GC626@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>, "J. Bruce Fields" <bfields@fieldses.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, xfs@oss.sgi.com

Fix commit 31ef83dc05 (nfsd: add trace events)'s typo 
causing a infinite loop when callback layout fail.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kinglong Mee <kinglongmee@gmail.com>
---
 fs/nfsd/nfs4layouts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4layouts.c b/fs/nfsd/nfs4layouts.c
index 3c1bfa1..0a616b5 100644
--- a/fs/nfsd/nfs4layouts.c
+++ b/fs/nfsd/nfs4layouts.c
@@ -587,7 +587,7 @@ nfsd4_cb_layout_fail(struct nfs4_layout_stateid *ls)
 
 	rpc_ntop((struct sockaddr *)&clp->cl_addr, addr_str, sizeof(addr_str));
 
-	nfsd4_cb_layout_fail(ls);
+	trace_layout_recall_fail(&ls->ls_stid.sc_stateid);
 
 	printk(KERN_WARNING
 		"nfsd: client %s failed to respond to layout recall. "
-- 
2.3.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
