Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F5C24BD1A
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311524; cv=none; b=IviQSFPBfVxXrPO8My2281j3iYCvJTWveEqjsV4FX3117XQCIXlGmFZ4xugngL+iSCDJ4m2FnbIEmKg5iVQL05ThAF4kTrw+vGKorYhZXAfRvXEXlrds/05Jbynw5tCPwAeENC1MP4LyoyxEqiGXeDf5SjPWKZPQRMRZB6hbva8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311524; c=relaxed/simple;
	bh=A0AeC/1tFRF1USYEfkPD6K7S16UGQofzdExyhCqoju0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5d0kgxRRya1mvk7IWuZjxA/3YOyBLlEWUGsbV/S315bT6t//FlLXgOyNptADsdH9f6aPwjmFe+RxcvdrqRIGkB7WLUhBjvfb0p7DU0d5ZnWN1XYOd1xzYO3oG90WUkngKsTIvUsLa4UJ3zoB2hyTRJZ3K5m/mEMz+iVye1nAX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oRruHWrI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oRruHWrI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hth0vlwne3gJg5+d+7IkI0x9usrVmz4ABXw3GopXlzM=; b=oRruHWrIym4LpCwFzcMXFK4CKQ
	r1rhbepbzzD8BlHXlVhi3Kgy6lZIwhYDQWki/O7OIoUUz9h19snjVOy2xVqoiluXUqAI+kyjH6KeN
	w8SEedEN2cSexJhNRRpLLu/nFfUhcMF+WFfVgdgwfiRdfAE+wV8DoxXZayV52oItGAm5VfDQBKCNz
	XutcGGCN83R2+I3BE8x6PBMIoAU0HkO9RdWyyg3AFiT3lW3M4TK6MzT46WOCl5XGxW2COQOvbRxuO
	KpyxTU8mG3AIWw014kGiJdmhGnOlOKDByQkN8JH1SSbb5Kad0am4qc9BZOipD3KaOU8zAx5Acvhcv
	2dMbFqKg==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOs1S-000000002gE-0gQD;
	Fri, 28 Nov 2025 06:32:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 15/25] logprint: factor out a xlog_print_process_region helper
Date: Fri, 28 Nov 2025 07:29:52 +0100
Message-ID: <20251128063007.1495036-16-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128063007.1495036-1-hch@lst.de>
References: <20251128063007.1495036-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Start splitting up xlog_print_record by moving the switch on the item
types inside the inner loop into a self-contained helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 logprint/log_misc.c | 187 +++++++++++++++++---------------------------
 1 file changed, 70 insertions(+), 117 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index c4486e5f6a14..f10dc57a1edb 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -902,6 +902,69 @@ print_lsn(
 		BLOCK_LSN(be64_to_cpu(*lsn)));
 }
 
+static int
+xlog_print_region(
+	struct xlog		*log,
+	char			**ptr,
+	struct xlog_op_header	*ophdr,
+	int			*i,
+	int			num_ops,
+	bool			continued)
+{
+	uint32_t		len = be32_to_cpu(ophdr->oh_len);
+
+	if (*(uint *)*ptr == XFS_TRANS_HEADER_MAGIC)
+		return xlog_print_trans_header(ptr, len);
+
+	switch (*(unsigned short *)*ptr) {
+	case XFS_LI_BUF:
+		return xlog_print_trans_buffer(ptr, len, i, num_ops);
+	case XFS_LI_ICREATE:
+		return xlog_print_trans_icreate(ptr, len, i, num_ops);
+	case XFS_LI_INODE:
+		return xlog_print_trans_inode(log, ptr, len, i, num_ops,
+				continued);
+	case XFS_LI_DQUOT:
+		return xlog_print_trans_dquot(ptr, len, i, num_ops);
+	case XFS_LI_EFI_RT:
+	case XFS_LI_EFI:
+		return xlog_print_trans_efi(ptr, len, continued);
+	case XFS_LI_EFD_RT:
+	case XFS_LI_EFD:
+		return xlog_print_trans_efd(ptr, len);
+	case XFS_LI_ATTRI:
+		return xlog_print_trans_attri(ptr, len, i);
+	case XFS_LI_ATTRD:
+		return xlog_print_trans_attrd(ptr, len);
+	case XFS_LI_RUI_RT:
+	case XFS_LI_RUI:
+		return xlog_print_trans_rui(ptr, len, continued);
+	case XFS_LI_RUD_RT:
+	case XFS_LI_RUD:
+		return xlog_print_trans_rud(ptr, len);
+	case XFS_LI_CUI_RT:
+	case XFS_LI_CUI:
+		return xlog_print_trans_cui(ptr, len, continued);
+	case XFS_LI_CUD_RT:
+	case XFS_LI_CUD:
+		return xlog_print_trans_cud(ptr, len);
+	case XFS_LI_BUI:
+		return xlog_print_trans_bui(ptr, len, continued);
+	case XFS_LI_BUD:
+		return xlog_print_trans_bud(ptr, len);
+	case XFS_LI_XMI:
+		return xlog_print_trans_xmi(ptr, len, continued);
+	case XFS_LI_XMD:
+		return xlog_print_trans_xmd(ptr, len);
+	case XFS_LI_QUOTAOFF:
+		return xlog_print_trans_qoff(ptr, len);
+	case XLOG_UNMOUNT_TYPE:
+		printf(_("Unmount filesystem\n"));
+		return 0;
+	default:
+		return -1;
+	}
+}
 
 static int
 xlog_print_record(
@@ -1046,118 +1109,9 @@ xlog_print_record(
 	}
 
 	if (be32_to_cpu(op_head->oh_len) != 0) {
-	    if (*(uint *)ptr == XFS_TRANS_HEADER_MAGIC) {
-		skip = xlog_print_trans_header(&ptr,
-					be32_to_cpu(op_head->oh_len));
-	    } else {
-		switch (*(unsigned short *)ptr) {
-		    case XFS_LI_BUF: {
-			skip = xlog_print_trans_buffer(&ptr,
-					be32_to_cpu(op_head->oh_len),
-					&i, num_ops);
-			break;
-		    }
-		    case XFS_LI_ICREATE: {
-			skip = xlog_print_trans_icreate(&ptr,
-					be32_to_cpu(op_head->oh_len),
-					&i, num_ops);
-			break;
-		    }
-		    case XFS_LI_INODE: {
-			skip = xlog_print_trans_inode(log, &ptr,
-					be32_to_cpu(op_head->oh_len),
-					&i, num_ops, continued);
-			break;
-		    }
-		    case XFS_LI_DQUOT: {
-			skip = xlog_print_trans_dquot(&ptr,
-					be32_to_cpu(op_head->oh_len),
-					&i, num_ops);
-			break;
-		    }
-		    case XFS_LI_EFI_RT:
-		    case XFS_LI_EFI: {
-			skip = xlog_print_trans_efi(&ptr,
-					be32_to_cpu(op_head->oh_len),
-					continued);
-			break;
-		    }
-		    case XFS_LI_EFD_RT:
-		    case XFS_LI_EFD: {
-			skip = xlog_print_trans_efd(&ptr,
-					be32_to_cpu(op_head->oh_len));
-			break;
-		    }
-		    case XFS_LI_ATTRI: {
-			skip = xlog_print_trans_attri(&ptr,
-					be32_to_cpu(op_head->oh_len),
-					&i);
-			break;
-		    }
-		    case XFS_LI_ATTRD: {
-			skip = xlog_print_trans_attrd(&ptr,
-					be32_to_cpu(op_head->oh_len));
-			break;
-		    }
-		    case XFS_LI_RUI_RT:
-		    case XFS_LI_RUI: {
-			skip = xlog_print_trans_rui(&ptr,
-					be32_to_cpu(op_head->oh_len),
-					continued);
-			break;
-		    }
-		    case XFS_LI_RUD_RT:
-		    case XFS_LI_RUD: {
-			skip = xlog_print_trans_rud(&ptr,
-					be32_to_cpu(op_head->oh_len));
-			break;
-		    }
-		    case XFS_LI_CUI_RT:
-		    case XFS_LI_CUI: {
-			skip = xlog_print_trans_cui(&ptr,
-					be32_to_cpu(op_head->oh_len),
-					continued);
-			break;
-		    }
-		    case XFS_LI_CUD_RT:
-		    case XFS_LI_CUD: {
-			skip = xlog_print_trans_cud(&ptr,
-					be32_to_cpu(op_head->oh_len));
-			break;
-		    }
-		    case XFS_LI_BUI: {
-			skip = xlog_print_trans_bui(&ptr,
-					be32_to_cpu(op_head->oh_len),
-					continued);
-			break;
-		    }
-		    case XFS_LI_BUD: {
-			skip = xlog_print_trans_bud(&ptr,
-					be32_to_cpu(op_head->oh_len));
-			break;
-		    }
-		    case XFS_LI_XMI: {
-			skip = xlog_print_trans_xmi(&ptr,
-					be32_to_cpu(op_head->oh_len),
-					continued);
-			break;
-		    }
-		    case XFS_LI_XMD: {
-			skip = xlog_print_trans_xmd(&ptr,
-					be32_to_cpu(op_head->oh_len));
-			break;
-		    }
-		    case XFS_LI_QUOTAOFF: {
-			skip = xlog_print_trans_qoff(&ptr,
-					be32_to_cpu(op_head->oh_len));
-			break;
-		    }
-		    case XLOG_UNMOUNT_TYPE: {
-			printf(_("Unmount filesystem\n"));
-			skip = 0;
-			break;
-		    }
-		    default: {
+		skip = xlog_print_region(log, &ptr, op_head, &i, num_ops,
+				continued);
+		if (skip == -1) {
 			if (bad_hdr_warn && !lost_context) {
 				fprintf(stderr,
 			_("%s: unknown log operation type (%x)\n"),
@@ -1173,11 +1127,10 @@ xlog_print_record(
 			skip = 0;
 			ptr += be32_to_cpu(op_head->oh_len);
 			lost_context = 0;
-		    }
-		} /* switch */
-	    } /* else */
-	    if (skip != 0)
-		xlog_print_add_to_trans(be32_to_cpu(op_head->oh_tid), skip);
+		}
+
+		if (skip)
+			xlog_print_add_to_trans(be32_to_cpu(op_head->oh_tid), skip);
 	}
     }
     printf("\n");
-- 
2.47.3

