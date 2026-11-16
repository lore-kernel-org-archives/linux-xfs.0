Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871087;
	b=uV+TA0gNX3UGEUy/Frdu74tJ9M39Rwz5xvbaTrwoI6X4qnatd7N8HD46xRfN79ejuMT0
	 lNpQggob80iQmqpjI5wc2txu46aUJEcpvGOMHr9bUQ//ziDwq9I7Q4+84Knt8ZtZr31sz
	 61fiHNiPO6HmXwj0W0KSnuOo4mukNe6cEzot0bKCln9S79WzA0VFlpyMNUk0/lgInIie+
	 aMEk1pywNWcDeF/id1zP6lEbaAyE0ZLFWsIFUR2SJaYe0MvG3K+STU4X8N6GvHjH39taf
	 dEDzOZtb+eNzMjvKDhi2qy8oKbsRiIajhaxsTLdkafqLlyA3wCLLZQI6N4g7a7Wpe1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871087;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=CbCpt3QDhyK5J2oj/T3N6PznE9xwJwgs8/6uXAghNr0=;
	b=hvddARcCgiM8hCoiyDWCydTTgET0azY3eYIlHNyTuqpa1uo4ApW287khyYhw3NDXJx1B
	 g6UGZ/C8vsCoUU0L7TXq+8PuMeWiVm5elcrrSET0rVJx/sdsMn6+kHaZECtl0t/0U2Mwa
	 NY6vHGA8nECiRY80dORPJlXqtdpP2iI047Jg4oKNPXIhdVuD+1ur3Ve7LZQiAiuvq8AP5
	 JOzzLgd1py46P9Ot8ylyJpk4xESp+2ipBa+3kyJNUPuBZwH7zIo4pFFWa0DcwZOUjiM2h
	 jXdtnvHh3HZOjOS2dr/VmH8r7cRrBPLLSA0UBUWfqQtr1/KPs/h086Ovn9jitHh3NOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G3QbePLE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F2C606A31C
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G3QbePLE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027D21F000CC;
	Mon, 16 Nov 2026 23:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871086;
	bh=CbCpt3QDhyK5J2oj/T3N6PznE9xwJwgs8/6uXAghNr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G3QbePLEA0Vya7GDHk4g0ly4I4rg5sB44tIlU9xr0/ZlBN8EC8RzN6CuIqgpqyXS0
	 IpthaoxzQRtnehZciwGX4b5mUbc4/v1GlKs3N/EJ1YUJVCfBTveiBlxh19pwT4sc88
	 DNSQW2TCe9af0TaMjOHHvfQMIlvoEe7Gn7bTmn/i7pkL0yoCxWWtY/cFGG9yMgka/o
	 4uNRLTxJQfmlhTrrdevyA4uoKVRF9yBy3vTt8S/uM9zzXzXjSG7EiN6ixyH98cINwP
	 ZXl1ZFlhIFhor4CxJLIspnGfRzWy7p/IoIEZ6DwrnYjdiHBEV4YP6B94IlVIDnrscM
	 qxdVvFoO8XDzg==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 41/59] xfs: validate attr done items during recovery
Date: Tue, 17 Nov 2026 10:14:58 +1100
Message-ID: <20261116231707.3625263-42-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261116231707.3625263-1-dgc@kernel.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
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

An attr done item is a single fixed size region, but recovery only checked its
length in the commit handler and never checked its padding.

Validate the region length and require the padding to be zero as the item is
decoded. The commit handler can then trust the item, so the length check is
removed from it.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_attr_item.c | 34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index a53ee2b0c54a..a6e36b2aa7b3 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -1167,14 +1167,35 @@ xlog_recover_attrd_commit_pass2(
 	struct xfs_attrd_log_format	*attrd_formatp;
 
 	attrd_formatp = item->ri_buf[0].iov_base;
-	if (item->ri_buf[0].iov_len != sizeof(struct xfs_attrd_log_format)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
-				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+	xlog_recover_release_intent(log, XFS_LI_ATTRI,
+				    attrd_formatp->alfd_alf_id);
+	return 0;
+}
+
+/* The attrd is a single fixed size region. */
+static int
+xlog_recover_attrd_validate_region(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	int				region_index)
+{
+	struct xfs_attrd_log_format	*attrd_formatp =
+		item->ri_buf[region_index].iov_base;
+
+	if (item->ri_buf[region_index].iov_len !=
+			sizeof(struct xfs_attrd_log_format)) {
+		xfs_warn(log->l_mp, "ATTRD: bad item region length %zu recovered.",
+				item->ri_buf[region_index].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	/* The padding is always written as zero. */
+	if (attrd_formatp->__pad != 0) {
+		xfs_warn(log->l_mp, "ATTRD: bad padding 0x%x recovered.",
+				attrd_formatp->__pad);
 		return -EFSCORRUPTED;
 	}
 
-	xlog_recover_release_intent(log, XFS_LI_ATTRI,
-				    attrd_formatp->alfd_alf_id);
 	return 0;
 }
 
@@ -1203,5 +1224,8 @@ static const struct xfs_item_ops xfs_attrd_item_ops = {
 
 const struct xlog_recover_item_ops xlog_attrd_item_ops = {
 	.item_type	= XFS_LI_ATTRD,
+	.min_hdr_len	= sizeof(struct xfs_attrd_log_format),
+	.validate_nregions = xlog_recover_single_region,
+	.validate_region = xlog_recover_attrd_validate_region,
 	.commit_pass2	= xlog_recover_attrd_commit_pass2,
 };
-- 
2.55.0

