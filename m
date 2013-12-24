Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E24737F92
	for <xfs@oss.sgi.com>; Tue, 24 Dec 2013 06:48:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B5BAE8F8040
	for <xfs@oss.sgi.com>; Tue, 24 Dec 2013 04:48:53 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id SZWel2eChryLk91E (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Dec 2013 04:48:52 -0800 (PST)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rBOCmpMD021613
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 24 Dec 2013 12:48:51 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBOCmojA029572
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 24 Dec 2013 12:48:50 GMT
Received: from ubhmt108.oracle.com (ubhmt108.oracle.com [156.151.24.13])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBOCmoVL029564 for <xfs@oss.sgi.com>; Tue, 24 Dec 2013 12:48:50 GMT
Message-ID: <52B982AF.2060607@oracle.com>
Date: Tue, 24 Dec 2013 20:48:47 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 4/4] xfs: rename mem_to_page to xfs_bufmem_to_page
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

Rename mem_to_page() to xfs_bufmem_to_page() for XFS convention.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_buf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 544315e..286ddbe 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -732,8 +732,8 @@ xfs_buf_set_empty(
 }
 
 static inline struct page *
-mem_to_page(
-	void			*addr)
+xfs_bufmem_to_page(
+	void		*addr)
 {
 	if ((!is_vmalloc_addr(addr))) {
 		return virt_to_page(addr);
@@ -774,7 +774,7 @@ xfs_buf_associate_memory(
 	bp->b_offset = offset;
 
 	for (i = 0; i < bp->b_page_count; i++) {
-		bp->b_pages[i] = mem_to_page((void *)pageaddr);
+		bp->b_pages[i] = xfs_bufmem_to_page((void *)pageaddr);
 		pageaddr += PAGE_SIZE;
 	}
 
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
