Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 187037F93
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 05:57:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0C3BD304070
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 03:57:36 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id IC3XVKy3BRaXcpbB (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Jun 2015 03:57:35 -0700 (PDT)
Received: from [88.128.80.44] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z5B2E-0003Ye-Jp
	for xfs@oss.sgi.com; Wed, 17 Jun 2015 10:57:35 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/5] xfs: use void pointers in log validation helpers
Date: Wed, 17 Jun 2015 12:55:31 +0200
Message-Id: <1434538532-6566-5-git-send-email-hch@lst.de>
In-Reply-To: <1434538532-6566-1-git-send-email-hch@lst.de>
References: <1434538532-6566-1-git-send-email-hch@lst.de>
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
To: xfs@oss.sgi.com

Compared to char pointers this saves us a lot of casting effort.  Also
add another local variable to make the code easier to read.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      | 30 ++++++++++++++----------------
 fs/xfs/xfs_log_priv.h |  2 +-
 2 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 68e22b6..7b940c6 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -109,7 +109,7 @@ xlog_ungrant_log_space(
 STATIC void
 xlog_verify_dest_ptr(
 	struct xlog		*log,
-	char			*ptr);
+	void			*ptr);
 STATIC void
 xlog_verify_grant_tail(
 	struct xlog *log);
@@ -1444,7 +1444,7 @@ xlog_alloc_log(
 		iclog->ic_bp = bp;
 		iclog->ic_data = bp->b_addr;
 #ifdef DEBUG
-		log->l_iclog_bak[i] = (xfs_caddr_t)&(iclog->ic_header);
+		log->l_iclog_bak[i] = &iclog->ic_header;
 #endif
 		head = &iclog->ic_header;
 		memset(head, 0, sizeof(xlog_rec_header_t));
@@ -3661,7 +3661,7 @@ xlog_ticket_alloc(
 void
 xlog_verify_dest_ptr(
 	struct xlog	*log,
-	char		*ptr)
+	void		*ptr)
 {
 	int i;
 	int good_ptr = 0;
@@ -3764,8 +3764,7 @@ xlog_verify_iclog(
 	xlog_op_header_t	*ophead;
 	xlog_in_core_t		*icptr;
 	xlog_in_core_2_t	*xhdr;
-	xfs_caddr_t		ptr;
-	xfs_caddr_t		base_ptr;
+	void			*base_ptr, *ptr, *p;
 	ptrdiff_t		field_offset;
 	__uint8_t		clientid;
 	int			len, i, j, k, op_len;
@@ -3785,9 +3784,9 @@ xlog_verify_iclog(
 	if (iclog->ic_header.h_magicno != cpu_to_be32(XLOG_HEADER_MAGIC_NUM))
 		xfs_emerg(log->l_mp, "%s: invalid magic num", __func__);
 
-	ptr = (xfs_caddr_t) &iclog->ic_header;
-	for (ptr += BBSIZE; ptr < ((xfs_caddr_t)&iclog->ic_header) + count;
-	     ptr += BBSIZE) {
+	base_ptr = ptr = &iclog->ic_header;
+	p = &iclog->ic_header;
+	for (ptr += BBSIZE; ptr < base_ptr + count; ptr += BBSIZE) {
 		if (*(__be32 *)ptr == cpu_to_be32(XLOG_HEADER_MAGIC_NUM))
 			xfs_emerg(log->l_mp, "%s: unexpected magic num",
 				__func__);
@@ -3795,16 +3794,15 @@ xlog_verify_iclog(
 
 	/* check fields */
 	len = be32_to_cpu(iclog->ic_header.h_num_logops);
-	ptr = iclog->ic_datap;
-	base_ptr = ptr;
-	ophead = (xlog_op_header_t *)ptr;
+	base_ptr = ptr = iclog->ic_datap;
+	ophead = ptr;
 	xhdr = iclog->ic_data;
 	for (i = 0; i < len; i++) {
-		ophead = (xlog_op_header_t *)ptr;
+		ophead = ptr;
 
 		/* clientid is only 1 byte */
-		field_offset = (ptrdiff_t)
-			       ((xfs_caddr_t)&(ophead->oh_clientid) - base_ptr);
+		p = &ophead->oh_clientid;
+		field_offset = p - base_ptr;
 		if (!syncing || (field_offset & 0x1ff)) {
 			clientid = ophead->oh_clientid;
 		} else {
@@ -3826,8 +3824,8 @@ xlog_verify_iclog(
 				(unsigned long)field_offset);
 
 		/* check length */
-		field_offset = (ptrdiff_t)
-			       ((xfs_caddr_t)&(ophead->oh_len) - base_ptr);
+		p = &ophead->oh_len;
+		field_offset = p - base_ptr;
 		if (!syncing || (field_offset & 0x1ff)) {
 			op_len = be32_to_cpu(ophead->oh_len);
 		} else {
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index db7cbde..1c87c8a 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -409,7 +409,7 @@ struct xlog {
 
 	/* The following field are used for debugging; need to hold icloglock */
 #ifdef DEBUG
-	char			*l_iclog_bak[XLOG_MAX_ICLOGS];
+	void			*l_iclog_bak[XLOG_MAX_ICLOGS];
 #endif
 
 };
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
