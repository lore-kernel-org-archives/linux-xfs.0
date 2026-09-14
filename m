Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CB323BD03
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 20:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789419152; cv=none; b=tFqv3nx9Xtf+SyEOiUNCCGifP+1K/PSfnuNbYom78OJ3cVN65budu23OH0551PPFvWpZpEmS0vKNKkR1B2oEEG22MHpD4H4+Q/0+i2OVVnY1J4ZJgIKUCdy9suVB/Lln65CMNdqZsgwWk3EpRbA/vJVEBKImvx+izvHCYz413Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789419152; c=relaxed/simple;
	bh=8wGX1VxtaqcL9waL3lxRvuTy5dMXPBqwWnkHVdtKhtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ba9Bm0C6ZadjFne/VxZ4s/flOu7czUhY8Om0MSpLk9wq4/i0WBkf1J53urYzdzakv9NEXhQi88cA0/a0C9Hyf4VFni4WoK8xhebTtDXE/ZHeo2rQHmb0MOs1oG50VENdaoGe9o1AdEijxMH4FJ9OVMyLxZXjKTvJa6KByt/6yxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S6AVPeq3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Js3w4QxB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S6AVPeq3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Js3w4QxB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789419149;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LOzGpcgfdgfcx7Tj4EtUo0XGZvUecb6TCwvnxE8j6rU=;
	b=S6AVPeq3iJ27sHIfGChK7DnEO4Kqj6hAj9XP04A7XA1j0Q3FbOHk3cc2XYy1Vzsy8yXbFI
	s998Rj/KG45QwImbJVMojgqslz6b2P3/OhM6c1IRpHILVO1ziosn0TQTZKdP9zvaL+3nfT
	XMM9EmA7VvwC/ptVNJ1I4at+mTXByc0=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-nuoyxQdJMJCW1S2pLw-C0g-1; Mon, 14 Sep 2026 16:52:28 -0400
X-MC-Unique: nuoyxQdJMJCW1S2pLw-C0g-1
X-Mimecast-MFC-AGG-ID: nuoyxQdJMJCW1S2pLw-C0g_1789419148
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-92e82060977so49754685a.1
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 13:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789419148; x=1790023948; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LOzGpcgfdgfcx7Tj4EtUo0XGZvUecb6TCwvnxE8j6rU=;
        b=Js3w4QxBgT6fixhaH+fAJqkkPVBKpk/RTXLvMf6Lvn4UaSc0H/dWli8v4jTTxD5uVi
         Ie7btXFVMNRJ/e6EyvVzanqYg9PzwX2yaa2+AT0w2R9ItRsxpRwGIWvAROtUGY2CrP90
         m4+4U8OOwMhtIVjUJPe77pwRSWnCiJg20yiI5VFk5LuO6Yg3Iela+Kwoh2S5vk+DZFyi
         3OIYyA5MeqV4/lOHsJxYVaCouyjB+gMqxgW1JnUZucD1O7Qtb2FgEsZeXnZAqok4fi/B
         DcumcuZmU8XGt1L/yAFuLFyG7vFk+PP6M9V0lURgf5t56JRQcFoHtOyJFLR0Mg69bh+B
         /FDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789419148; x=1790023948;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LOzGpcgfdgfcx7Tj4EtUo0XGZvUecb6TCwvnxE8j6rU=;
        b=SKjzJLBvQqkS4fydifX8Wu8xHGTfys+d54rNlvINYra/8oCnsoCMFWPjNmr/wPHOLx
         XHrapzLVMOWLDfbYGI41a7eK0KOIe+CJCJAuJ8k67TDTm1LwlhdV8J5aNUFa/OaAv470
         r/cF7O/+mzIzb1a6kM8KuO6G/l6WXqC7zUQERtrX1SioHJSJ9/Ctqyokbel/o/IG+jK6
         S9IGMVsUGc1yKz+S/eJqF8zVjKC6Dq/ARJ7Tt3HmUktLTP8dzsk2wymXVpGP97wDJxG+
         KrHPjbULNFhVyvvgrcc6fjuGbfwdlrFhGTDHd3bbsiqenffhuLaVrGW+yeqHvBU4/lvi
         Kd9Q==
X-Gm-Message-State: AFuF++kyzGW6ue8epAi8r0Y2XORswKao1XYzs6rcpGnvhkbJ6+cgfLdn
	KJ64Aa7mxOzyqoKjIQcAWamT1CJg+R1UaMb5NBT8IXn8joMO61KB6VnXtr9uw1SCNS+unKoDo8x
	qCzWt3ptLeIZAD6zO7fgR14UIOPRpOfsLjsCIglQoxl7YhH5BtSIaawKFpecjRf/0gXgS8Yx73H
	7itZiGORIKnYts6mj9JM0kwZ/c5JjmNtjYLHwpmefAdjEni2g=
X-Gm-Gg: AYBFou2nGojCejlmDwQGN3zdIuKF8hDWhNAnM+ep0GuRT+KwtAvwfMsyWtyPYSa2BF7
	Du+22NYcKj3Nw0xfjHmM5hDsrTegcY/UTMu9xlAbG9MJ4a8whOczBchoDdEZShpe/zy4zqqtemL
	Ht0dQ94IT89M6PSu65DpGP2CMcfLY8PjR7oPufu42xJBZil7/zDfWoLJ5MYJlpgleOwv84mUFvM
	dXAcxbmxLVPHihgMtywh6c67CraU/fbojMmBZbauqViwWzinNCmKzgHVm4cPJ8+sxJqdhGJTauc
	jSTn7YU7HAH+FefDQmRw3oVLrUQRBWVuI3QRRnPy3DQtAPmDrjlywLZGQxKv047GiCbUx0vdc1g
	b0KBSRT+vWvN4lSeYN+8i4Y1CtLehnSwYZyzmhQ==
X-Received: by 2002:a05:620a:4053:b0:939:72cb:bae5 with SMTP id af79cd13be357-93a346fa603mr154337685a.28.1789419147972;
        Mon, 14 Sep 2026 13:52:27 -0700 (PDT)
X-Received: by 2002:a05:620a:4053:b0:939:72cb:bae5 with SMTP id af79cd13be357-93a346fa603mr154333185a.28.1789419147434;
        Mon, 14 Sep 2026 13:52:27 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e7f1da12sm1099236785a.9.2026.09.14.13.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:52:27 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 04/14] xfs: remove unused mp argument from xfs_exchmaps_check_forks()
Date: Mon, 14 Sep 2026 15:46:09 -0500
Message-ID: <20260914205221.1516254-5-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914205221.1516254-1-sandeen@redhat.com>
References: <20260914205221.1516254-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_exchmaps.c | 1 -
 fs/xfs/libxfs/xfs_exchmaps.h | 3 +--
 fs/xfs/xfs_exchrange.c       | 2 +-
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index 3efed37cb98a..78f09e9da744 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -135,7 +135,6 @@ xmi_has_postop_work(const struct xfs_exchmaps_intent *xmi)
 /* Check all mappings to make sure we can actually exchange them. */
 int
 xfs_exchmaps_check_forks(
-	struct xfs_mount		*mp,
 	const struct xfs_exchmaps_req	*req)
 {
 	struct xfs_ifork		*ifp1, *ifp2;
diff --git a/fs/xfs/libxfs/xfs_exchmaps.h b/fs/xfs/libxfs/xfs_exchmaps.h
index fa822dff202a..055b8dbabd5b 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.h
+++ b/fs/xfs/libxfs/xfs_exchmaps.h
@@ -115,8 +115,7 @@ void xfs_exchmaps_upgrade_extent_counts(struct xfs_trans *tp,
 int xfs_exchmaps_finish_one(struct xfs_trans *tp,
 		struct xfs_exchmaps_intent *xmi);
 
-int xfs_exchmaps_check_forks(struct xfs_mount *mp,
-		const struct xfs_exchmaps_req *req);
+int xfs_exchmaps_check_forks(const struct xfs_exchmaps_req *req);
 
 void xfs_exchange_mappings(struct xfs_trans *tp,
 		const struct xfs_exchmaps_req *req);
diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
index 94965a6c2187..a3891e17fa87 100644
--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -238,7 +238,7 @@ xfs_exchrange_mappings(
 	trace_xfs_exchrange_before(ip2, 2);
 	trace_xfs_exchrange_before(ip1, 1);
 
-	error = xfs_exchmaps_check_forks(mp, &req);
+	error = xfs_exchmaps_check_forks(&req);
 	if (error)
 		goto out_trans_cancel;
 
-- 
2.55.0

