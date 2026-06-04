Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AF93CB902;
	Thu,  4 Jun 2026 09:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.16.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780566696; cv=none; b=p21gOYdvsPwQuN16i1NM5P63ztPMF3svO7mpNJFfhNBSoCCU7K77oPNXG11geVaRlxTQoEQgP8zVhWds8+PrwyjJFwsv4U0P8CykRKl/6bWTUWEIBnEJ1FhPw7o2d8ELNoMY0HbWTi5NvnCljCATifRFk+SADi7+Vg9UzCwgLmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780566696; c=relaxed/simple;
	bh=Qv10JX0rlvP9+3DwEn+zohMMEi4qmvvfVvuBnsOUf8U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=K06l0B6IKfKv1YC1n3KM+gNCg9fF7gwvlmPLEs+AvuAM6FsS7obCs4Eg/tOfMm60vzJDwPDdu6Z4AmiZlYPVGCOQgcaPGyMr53ZFqJejT/RH2NzeA5W8fZqvvEBZu1bqzOmgDP+efxhkoblItYCz+kRvZ3GxZA96PVeQ/YyjbVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=N3BnwI7G; arc=none smtp.client-ip=54.206.16.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="N3BnwI7G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1780566544;
	bh=7Bn4lO0z4VKqa/pAC4ap4+OQDD5xcuBwz5wOA0IQE8U=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=N3BnwI7Gm23VjbIjBDI2O7FyAJvDbCcmFOsdqCyfLTlK/2/vYm/x5kPw+KeCW0d2S
	 ciKiKmJKNOcnP9tXVwsK5Je9ls3qWTvQ78QP+dO0jKY0KdkTjzbgqKlUo3fejuPQcg
	 K/7QelpWBGkUgRmIeQ6l+bNBUTrFIx9XdbX87y/w=
X-QQ-mid: esmtpsz17t1780566516teea0a55a
X-QQ-Originating-IP: EJI3xTDl5emZxuoZN/oxkJCkKKMcJfyx3nqVtFJwiTA=
Received: from localhost.localdomain ( [1.85.7.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 04 Jun 2026 17:48:33 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 2714360259105689685
EX-QQ-RecipientCnt: 9
From: Gou Hao <gouhao@uniontech.com>
To: cem@kernel.org,
	djwong@kernel.org,
	dchinner@redhat.com
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	niecheng1@uniontech.com,
	zhanjun@uniontech.com,
	gouhaojake@163.com,
	gouhao@unionntech.com
Subject: [PATCH] xfs: fix use-after-free of buf_log_item in xlog_cil_build_lv_chain
Date: Thu,  4 Jun 2026 17:42:33 +0800
Message-Id: <20260604094233.8492-1-gouhao@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: NvIr6BtGSx+/g4pEm+DzRmnyOwi+3miuc4jg01uy9nIO0xk0KMrPULQM
	R72vaFsQeBXCCvwQR30Xop55XThMrkHyrwGUV3YUMeVewa1ygnwqNYbok03SM2Vy0bsXDzJ
	4RWzVLVcVqjAfdbjzXk0Bp6GMSNjxupnJcZvWHWmcTszS2gJgzhwystJRrceBNGVeKswhfv
	nHHZo47fwBxnO6YhNf5SOcys2J8F2pB6YrRFW8H7XABr5uAl6gb5BY1CXeoSMIoc8LJsa66
	sT9vXafoJljfBCIlxqFe2dIESxPRDU0IFLYPvMOebN6fualG7ZRyXYlsUGpCWwAxsv9Sgx5
	qOe+I7MFOkhujsiCjkmwf470cRZK/0o0yEM0EkRfL2HciLbgEu24hK6eZqaECf9XKOqmjTn
	/x1XRISLNvDV42MHShDcnEAzdMHq6ein3SX7VS677JhPfFLV/bvLZAgRNOaPJi6+YJE2z4p
	4AEvQfRkcF7BY05YSl7J5wKxYA106255eaRI5+csIJ2e7EdR1HcqO3r/Wtne4pxcisC6wqu
	CLrQHeymjVdYhuTTYlXvCH778UI6quaEtRIGhJ5JoG/TNXtn3AQGyqzK3W1LW5HQqNfD5ah
	EPDWxSJSd2syPy9tq8ukX59PW6yise4rUIGi1FAg+SQa8saevcxdsNuytcHX6He+5rloEQH
	SqLLzhPWdy3AZfUlgsgZybEIjHxjjyZkKssNvDpVAXIAalt5Fxu3N0Z9MZISBc8QPVIKVoF
	9n00lFBz13YZpXb22H8SgS3Wj96j0LqAkRY3872/hDSS+F+mUzM1c16A23c0CUIFDQfqggg
	XYWTmpaBTGHnculgHTIZ6JUsYCoBzLAjPRXhT+gg6+3AW4CxtUBKVD2NEOziu4+LR+FTbwi
	VXsyrmHXS05X0pWPl94y6TW8nr1+TgQzlbjW5XCtAogn0lDCFkkLnpQqUz4IZZuqNvxPxj/
	5a9LgzBUF9Tmgf5rEcNwqbl38EfLfR8ebcolyWbCAfKzqP30Rtmy8OPBc5ISnyeutS1+q8+
	cwtN5I5GBAyFHCA6bm3SA5fUbB4zHoeKfwIPyK9rAJKb9M+gLSBTXhPlNMNPQCm/sqbDaTm
	9pgij3J1qMfQ5AAhP4OBnyvl2m4+B2vn3Os+3TO0Y1JaBLpkH9BVvPVgcT2pbonmEfqmZ+Z
	JxkgIm4GEDQjnMk=
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

xfs_buf_item_done() frees the buf_item via xfs_buf_item_relse() but
does not remove the item from the CIL log_items list (li_cil). When the
item is freed through an error/shutdown/abort path before the CIL push
worker processes it, the freed memory remains linked in ctx->log_items.

The CIL push worker in xlog_cil_build_lv_chain() then dereferences
the freed object via item->li_lv, triggering a KASAN slab-use-after-free.
For details, see Link[1].

Add down_read() on xc_ctx_lock before list_del_init() in
xfs_buf_item_done() to safely remove the item from the CIL list.  This
uses the same lock that protects CIL list operations: insertions are
done under xc_ctx_lock read-side (xlog_cil_insert_items) and removals
under write-side (xlog_cil_build_lv_chain).  The read lock is safe here
because xfs_buf_item_done() is always called in process context (workqueue
or direct I/O wait) and cannot deadlock with the CIL push worker which
holds the write lock during xlog_cil_build_lv_chain - the worker does not
trigger metadata buffer I/O that would call xfs_buf_item_done().

Reported-by: syzbot+598a791b31c498b63c6b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a069a95.050a0220.2921a.0006.GAE@google.com/T/ [1]
Fixes: 816c330b605c ("xfs: factor out stale buffer item completion")
Cc: stable@vger.kernel.org
Suggested-by: Zhan Jun <zhanjun@uniontech.com>
Signed-off-by: Gou Hao <gouhao@uniontech.com>
---
 fs/xfs/xfs_buf_item.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 8487635579e5..75529dfd1170 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1067,6 +1067,11 @@ void
 xfs_buf_item_done(
 	struct xfs_buf		*bp)
 {
+	if (bp->b_log_item->bli_item.li_log->l_cilp) {
+		down_read(&bp->b_log_item->bli_item.li_log->l_cilp->xc_ctx_lock);
+		list_del_init(&bp->b_log_item->bli_item.li_cil);
+		up_read(&bp->b_log_item->bli_item.li_log->l_cilp->xc_ctx_lock);
+	}
 	/*
 	 * If we are forcibly shutting down, this may well be off the AIL
 	 * already. That's because we simulate the log-committed callbacks to
-- 
2.20.1

