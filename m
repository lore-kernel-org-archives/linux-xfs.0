Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275824;
	b=Ozsnl5B54mMS40jGwtxOa3dKQ67N3AezJS+v46vTJQBWgUDAIWKMuX1la6eIKq8wN/Vy
	 X+TCUR4F4RVn7mYp8TitdqbyeZ6TzKb7v8dTiaRBcHgHbPygNEVhB8wTjXE1+DHL2/lsZ
	 185CEXbhdoxvfkpKpWy0Yk4L+/08wFf2unq9kAGAARU2YEBk75se3oe6Jq3JCaiaD50mk
	 xpSUdtyI7CGEU8qIfVWE+nzUxnimQI52WNvrRn6OUEFYCrKb2cstdGuxnWlgKgQBI3jwA
	 AJRW4WQVJojWe46Lb/LHb825PoKpN3Qei4cSNIq+mg7ZzgaCKA9Q0xXgYHFCVxIgaXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=MRh3BiAuWNIxur4C0q2eKnBi0sby8SjJGNLf4vVX+Uk=;
	b=Y9WKhRxEiFwTP6hD3+mUadTq8cf+/BY9vDcVfA2khjcaQKoP0bNc4osao+8KoS5LLwyM
	 WGufUFkvGfkugctULh8QtVO+kW5Vc8ZPrapYp8rW6ypvReypGSI6Q1KhHcm/OHAbHjxlE
	 +iVLW5Kd5riFRNmcrO70zpDr0e+tfpgFydUQcyxd/mTw+mcQvRK2HfHZF5zklX7TBMr/3
	 QC6PhiBHSmhB3rmCZ9Erd2pUVfyGFvz4j6IntlkqzFqsKaB1e4l4G3G20Qi4UHnaSbHrB
	 l7y19+wnch0+XxRucEuUQQOFDqNFGJS74UIUj4e2/MG98aCHD1bfKphTowBg5n+567w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cate9XYP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45ECD606A31A
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cate9XYP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7781F01825;
	Thu, 29 Oct 2026 12:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275824;
	bh=MRh3BiAuWNIxur4C0q2eKnBi0sby8SjJGNLf4vVX+Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cate9XYPzn12xEXf10wa6lfZJeuGfIajNB3DdzstfAGeDtSMEDBGK/KoJXOzDCuXZ
	 qDBAWRHliBJB7OhD4TIYLqSwP2g+QyTfH62DIqMxaR+h333Acjix3EuYhsjFJOUzNM
	 ypuMFQQ9AKxTd6czSFGzLx4NcY6Oa30iUMsxiNsRSeZEVteBPU/dh7/o9H5yK4FJfs
	 iEgFUTLBPv0KqNMnATUCeg68alLGvS0kxwu+ly90SwcXojRFcs5wBfTXSQvv9gw1F4
	 uGYLVVMJjD50FA7FXuPdqf4rdzyDuMm4i0ijayNGO4s+cI8yXPBrobA79TVAnURYQm
	 aBBIFkRBZDnVg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	cihan.cihan@gmail.com,
	cmaiolino@redhat.com,
	dchinner@redhat.com,
	dgc@kernel.org,
	djwong@kernel.org,
	floss@jetm.me,
	hch@lst.de,
	hemanth.selam@gmail.com,
	jiapenglin@tencent.com,
	johannes.thumshirn@wdc.com,
	kees+treewide@kernel.org,
	norbert@doyensec.com,
	syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com,
	yijiangshan@kylinos.cn,
	yun.zhou@windriver.com,
	zenghongling@kylinos.cn,
	Javier Tia <javier@peridio.com>
Subject: [PATCH 14/28] xfs: report the error that made deferred work shut down the fs
Date: Thu, 29 Oct 2026 13:06:11 +0100
Message-ID: <20261029120631.803074-15-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261029120631.803074-1-aalbersh@kernel.org>
References: <20261029120631.803074-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Javier Tia <javier@peridio.com>

Source kernel commit: d058f24b163a8d63866ac6bbe5f06b41aabe97d7

When a deferred operation fails and shuts the filesystem down,
xfs_defer_finish_noroll() reports neither the errno nor which operation
originated it, so the log cannot tell a transient -ENOSPC from real
corruption.  Report the operation type, errno and remaining reservation.

trace_xfs_defer_finish_error() runs after xfs_force_shutdown(), which
BUGs under fs.xfs.panic_mask and so never fires for the first failure;
move it ahead of the shutdown and mirror it to xfs_alert() for systems
without tracing armed.  Capture the op name while the item is live (dfp
is freed once its work list drains) and suppress the alert once the fs is
already down.

Signed-off-by: Javier Tia <floss@jetm.me>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_defer.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 6c247d73cf1d..aaf643a2d842 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -653,6 +653,7 @@ xfs_defer_finish_noroll(
 	struct xfs_trans		**tp)
 {
 	struct xfs_defer_pending	*dfp = NULL;
+	const char			*what = "chain";
 	int				error = 0;
 	LIST_HEAD(dop_pending);
 	LIST_HEAD(dop_paused);
@@ -702,9 +703,17 @@ xfs_defer_finish_noroll(
 				struct xfs_defer_pending, dfp_list);
 		if (!dfp)
 			break;
+		what = dfp->dfp_ops->name;
 		error = xfs_defer_finish_one(*tp, dfp);
 		if (error && error != -EAGAIN)
 			goto out_shutdown;
+		/*
+		 * A finished item is no longer a candidate for a later
+		 * failure.  An -EAGAIN one is not finished, so it keeps the
+		 * attribution across the roll that completes it.
+		 */
+		if (!error)
+			what = "chain";
 	}
 
 	/* Requeue the paused items in the outgoing transaction. */
@@ -716,8 +725,12 @@ xfs_defer_finish_noroll(
 out_shutdown:
 	list_splice_tail_init(&dop_paused, &dop_pending);
 	xfs_defer_trans_abort(*tp, &dop_pending);
-	xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
 	trace_xfs_defer_finish_error(*tp, error);
+	if (!xfs_is_shutdown((*tp)->t_mountp))
+		xfs_alert((*tp)->t_mountp,
+			  "deferred %s work failed, error %d, %u blocks reserved",
+			  what, error, (*tp)->t_blk_res);
+	xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
 	xfs_defer_cancel_list((*tp)->t_mountp, &dop_pending);
 	xfs_defer_cancel(*tp);
 	return error;
-- 
2.54.0

