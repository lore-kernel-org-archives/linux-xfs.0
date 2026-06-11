Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9352737F8
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 21:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781213002; cv=none; b=HfbKPERKEW0VJzlHVridtQgTTVREfletvOsusspStUdhmtDs8vvU+OGY7kJzJ2pETyjpjGGa+3zV/Az1/4wHafQGw0Trw5rarEA2HIoxZ8Y8MGAtA8KxnLZuZ2VUMBYVSJwhqFXzUiIYiJEiZeD0LN0dWB8tg8rqFTfF8HHHITM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781213002; c=relaxed/simple;
	bh=f1OMtb8wg11GJGFN4AIwJ+A2dGp0tV/faIflT7gvA3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mKoJKzNDhktYhDVlcXa4KDSPdLXgz6IoJlak4Z+2aU8irPFQiz0f/xXsBbLZfjWAwc9KvHGlgkF47upATxojpVxsqDSgZNnONbgBBqukhZsDcmmzLKgW++r6Bt7AAByXeGebBJfOztTfas6TdrSqWq+DtXAZv6eHP7VF/TdVA0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=openai.com; spf=pass smtp.mailfrom=openai.com; dkim=pass (1024-bit key) header.d=openai.com header.i=@openai.com header.b=CYLUz78p; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=openai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openai.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=openai.com header.i=@openai.com header.b="CYLUz78p"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5176465a4a4so2675191cf.2
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 14:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openai.com; s=google; t=1781213000; x=1781817800; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iYtnnTDn2ELnOpysY9z4lN/auTKWMZCv8VSFk4uIcE8=;
        b=CYLUz78p8MUwMzs5DZwnyLoLBtQAJoDvfTBm3/MqKqYp3mSOHYotrsDFRatE98v+Kx
         KEpFdaUb6u2rX7cOSxHULIpyhgHCOerXJQzDD+ZFp6rcVrIQTvP4F+yNS0WB4OarHHMO
         GJkBnb4oybrt3GdVPYua296NAoHv4A9GT96kY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781213000; x=1781817800;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iYtnnTDn2ELnOpysY9z4lN/auTKWMZCv8VSFk4uIcE8=;
        b=NQ5qknuBkfwotriaLi2m4ySiUcczY7NVQrupEzI07Y+tPFnXKMhBRyqZSdK67UrOe3
         jM1z+Fn3J1rKGRhuNjE2hOsw4uaacCzrQfxYX+zfWSQMauGkWlS9ZHd6tisb8NttrR7D
         YfP5msHPP0zi45fkrJLzYQitGgNuISPX+AF51ojXPWKdOLmkSYBymzTqBcv67bm8vIM0
         Wi0gzXvugctzbmlGRzpUjXa4vO6UjVZrghI5+HkN3vurey87BYbrTkO86gEaijxe4KsS
         Rc2NukZwT94Nk8nwmwCWPBLqiA/2ZGHv8k++IT2zrNIOHka+1cOUvEwzrVaa91BvE/0I
         iEtw==
X-Gm-Message-State: AOJu0YxaQ9TkW9HIs5591RkCpzcebSCVJ/7iXcAkTMW2Jm6GeWnhnr9i
	Nc23DrCH/uotbc5ymKk78gpGBjachuG7aITOJsKq99dNr/vYvn8skbJPWe7NAqitL0xxd3M58aw
	ufBhpDp8=
X-Gm-Gg: Acq92OHof66DD7QZZYpNo/Y9cydU1kBxNpUHT0qRi56VkHFWjAg33/sBiW7cJYtOxqC
	xTNCex7OD48gGJBUBC82gBSwuVW4Zt64MUwhxyWN8H/34QcLkhMWu49WMV4yw+I9qtJxxJz9/2x
	AZfq1tKBADvjKvZa+/RjsQfI/e73sGq+TQssr1zD0/6dfYTAQc5Jf2E7VKI3dDUeePxAMjSbJT4
	oZPGYN5vs2vrmjJbknIFrjW2js8ROXmHvvXerYkwb6HE2BwlcTQpG+5Che4Cc6qNFWw21n0Ac4C
	iheRvzgk8NbWYlLCmbZkHvC1rbRM+utlhNZKC3QGpA5g060vZzVuUmI8m9y5d0LxRL1nK03wvpu
	LlFrisDgtrnnlW+r+PJ2kLZcMp/QNcyhHYvsaB9sImfvWLT8mk6YulbwBbKhJ8Jvg2mM7XBl9Cx
	R3JcuxKzUUiBz5zIJKKrFnbYesahZbfA1OxpT39cHN4pGb22Cy/d8W4kc2RuUhLhhxjEGcuJJL6
	kGsa010NG6Ka8+Dm43wIY49pidra4MKn1Y=
X-Received: by 2002:a05:622a:c16:b0:517:92e4:4288 with SMTP id d75a77b69052e-517ede75c2emr78195951cf.15.1781213000431;
        Thu, 11 Jun 2026 14:23:20 -0700 (PDT)
Received: from com-75606.node.ndb.openai.org ([209.249.37.146])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-517fb79e2f2sm3747311cf.17.2026.06.11.14.23.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 11 Jun 2026 14:23:20 -0700 (PDT)
From: Kyle Zeng <kylebot@openai.com>
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>,
	outbounddisclosures@openai.com,
	Kyle Zeng <kylebot@openai.com>
Subject: [PATCH] xfs: validate recovered buffer item dirty bitmaps
Date: Thu, 11 Jun 2026 14:23:14 -0700
Message-ID: <20260611212314.4610-1-kylebot@openai.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

XFS buffer log recovery trusts the dirty bitmap in recovered buffer log
items when replaying logged regions into the buffer.  The replay path only
has debug assertions to check that each bitmap extent fits within the
buffer described by blf_len.

A corrupted log can therefore set a dirty bit beyond the end of the
recovered buffer.  In non-debug builds, xlog_recover_do_reg_buffer() will
copy the corresponding logged region to that out-of-range buffer offset.

Validate the recovered dirty bitmap and the associated logged data regions
before replay.  Reject buffer items whose dirty extents extend beyond
blf_len, whose region count does not match the bitmap, or whose data iovecs
are malformed.

Assisted-by: Codex:gpt-5.5
Signed-off-by: Kyle Zeng <kylebot@openai.com>
---
 fs/xfs/xfs_buf_item_recover.c | 63 +++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 02b95b89d1b5..576d6245e922 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -206,6 +206,63 @@ xlog_recover_buf_commit_pass1(
 	return 0;
 }
 
+/*
+ * Make sure the recovered dirty bitmap only describes ranges inside the
+ * recovered buffer and that each logged region is backed by one data iovec.
+ */
+STATIC int xlog_recover_validate_buf_data_map(struct xfs_mount *mp,
+					      struct xlog_recover_item *item,
+					      struct xfs_buf_log_format *buf_f)
+{
+	u64				buf_bytes = BBTOB(buf_f->blf_len);
+	int				i = 1;
+	int				bit = 0;
+
+	while (1) {
+		u64			reg_bytes;
+		u64			reg_end;
+		int			nbits;
+
+		bit = xfs_next_bit(buf_f->blf_data_map, buf_f->blf_map_size,
+				   bit);
+		if (bit == -1)
+			break;
+
+		nbits = xfs_contig_bits(buf_f->blf_data_map,
+					buf_f->blf_map_size, bit);
+		if (XFS_IS_CORRUPT(mp, nbits <= 0))
+			return -EFSCORRUPTED;
+
+		reg_bytes = (u64)nbits << XFS_BLF_SHIFT;
+		reg_end = ((u64)bit << XFS_BLF_SHIFT) + reg_bytes;
+		if (XFS_IS_CORRUPT(mp, reg_end > buf_bytes))
+			return -EFSCORRUPTED;
+
+		if (XFS_IS_CORRUPT(mp, i >= item->ri_total))
+			return -EFSCORRUPTED;
+		if (XFS_IS_CORRUPT(mp, !item->ri_buf[i].iov_base))
+			return -EFSCORRUPTED;
+		if (XFS_IS_CORRUPT(mp, item->ri_buf[i].iov_len == 0 ||
+				   item->ri_buf[i].iov_len % XFS_BLF_CHUNK))
+			return -EFSCORRUPTED;
+		if (XFS_IS_CORRUPT(mp, item->ri_buf[i].iov_len > reg_bytes))
+			return -EFSCORRUPTED;
+
+		/*
+		 * A single contiguous dirty range can be split into multiple
+		 * log vectors.  Advance by the amount covered by this iovec.
+		 */
+		nbits = item->ri_buf[i].iov_len >> XFS_BLF_SHIFT;
+		i++;
+		bit += nbits;
+	}
+
+	if (XFS_IS_CORRUPT(mp, i != item->ri_total))
+		return -EFSCORRUPTED;
+
+	return 0;
+}
+
 /*
  * Validate the recovered buffer is of the correct type and attach the
  * appropriate buffer operations to them for writeback. Magic numbers are in a
@@ -1033,6 +1090,12 @@ xlog_recover_buf_commit_pass2(
 			goto cancelled;
 	}
 
+	error = xlog_recover_validate_buf_data_map(mp, item, buf_f);
+	if (error) {
+		ASSERT(error == -EFSCORRUPTED);
+		return error;
+	}
+
 	trace_xfs_log_recover_buf_recover(log, buf_f);
 	error = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
 			  0, &bp, NULL);
-- 
2.43.0
