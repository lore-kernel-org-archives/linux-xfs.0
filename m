Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B25557F37
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 11:33:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 958A3304051
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 09:33:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KWLgBZYKKLFYgfD4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 07 Oct 2015 09:33:45 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 26313C0BD898
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 16:33:45 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t97GXhPP029355
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 7 Oct 2015 12:33:44 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: avoid null *src in memcpy call in xlog_write
Message-ID: <56154967.70100@redhat.com>
Date: Wed, 7 Oct 2015 11:33:43 -0500
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

The gcc undefined behavior sanitizer caught this; surely
any sane memcpy implementation will no-op if size == 0,
but behavior with a *src of NULL is technically undefined
(declared nonnull), so avoid it here.

We are actually in this situation frequently via
xlog_commit_record(), because:

        struct xfs_log_iovec reg = {
                .i_addr = NULL,
                .i_len = 0,
                .i_type = XLOG_REG_TYPE_COMMIT,
        };

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 4012523..8897fd1 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2424,7 +2424,10 @@ xlog_write(
 
 			/* copy region */
 			ASSERT(copy_len >= 0);
-			memcpy(ptr, reg->i_addr + copy_off, copy_len);
+			ASSERT(reg->i_addr + copy_off > 0 || copy_len == 0);
+			/* size == 0 is ok, but *src == NULL is undefined */
+			if (reg->i_addr + copy_off)
+				memcpy(ptr, reg->i_addr + copy_off, copy_len);
 			xlog_write_adv_cnt(&ptr, &len, &log_offset, copy_len);
 
 			copy_len += start_rec_copy + sizeof(xlog_op_header_t);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
