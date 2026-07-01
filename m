Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0613D411670
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 15:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782920348; cv=none; b=fiUeDxNDlM1nyQe8i459ElAuX3jg0VIY71WV1VBqOW/6ilHoLGBFQeCY17qbPioC/0NnJPCwCnImGiDcn/+yeQF1+yBDjUDKCRISUZqTL7BRFqbSsumoGBgMOZ3EMBBwr+M+ffJJ1qhE37tnRvkomx7ap9wRD/rr+xhNJJIrfFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782920348; c=relaxed/simple;
	bh=LkEerIAbD4m5xLpvNpkhsL5pHqL6KHptjThZZ2P76UM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljRjyTm3KZONgBn+G0sSUOSe1IyaGCIv+0wYu2frQBwkhRYrgLaAXnZPNjeZ2nIPpcnifr+Z6lX1KM5HlcExxp8Hweh9YKR9NaE4Ru39/IWruW3MuwBk+B9xC1W1xcAN0ELpIhmLM0NKqHhZlm7lFkS8EFASkhNHTyy3B14WDIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S/ZEQj0G; arc=none smtp.client-ip=74.125.82.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S/ZEQj0G"
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-139b914bab6so881973c88.1
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jul 2026 08:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782920346; x=1783525146; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/EBXxurKZrqB96Omv7vJv+o/HR2l3cwiArcbTgFg8dg=;
        b=S/ZEQj0GT/S7166qwfHoW8/xM35fF1SwR2jRTusPwLbo5ph42wAVyUhEvp3aXWtjHn
         f4bb9FJ4/JZrsBjUIMnh/Sv6+QyhJ+fueJxOrpb88jO5Rg6htZeh5JHC+cEa2MU/EpdZ
         bcuAF2i5mnRWSt7YVg/9VT0lHCT0BMwb5Wml+l0n4EPLGXRKWqm6k+tqcQMMmOq2Bg+5
         YNQpnJ630uXzrd06X8XtHlX+s5Jma6sNsruUth2+6cpVJtLF4y0xGB3AHYGNQVZYspG7
         dfSaHUHHaxXa/MVTxWNZV9+ywfN4lnjXIsUwtLRaa93Lq3vq+QaW0MP6VJWqBMmtsjpN
         GWew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782920346; x=1783525146;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/EBXxurKZrqB96Omv7vJv+o/HR2l3cwiArcbTgFg8dg=;
        b=cHVHoxdPH7NJ0B1LyvgGXVFlC+yPu4zduIIfQ43HP/HpQ/Y/BBOodRIWL7J9nXwOs9
         k/KOW+veQ/58fmQCzg3HYisqqYE3H5fYaCVFkpwBFt1LZKMyN1WyrJuKBX8ET0S9RKxH
         bLah2JWugBeEBN4tHGq4WKt1kr0xbOXGvlB9TkW1TVdryaKPmWtJ3G9iX/PSybYCCmhW
         lDPagPAXnQIZTiwo65DWM604XpzYZXqKoqlkpBoFt3wABw6+XT9naXKI/kO8UnMjSdDl
         wlHjFvrwloJingDvd+lomnP3CFag+s+AAwq6hk2yvnDlB+vAujapNCaGRs+a3sdK+GIK
         iXxg==
X-Gm-Message-State: AOJu0Yyw3bB38zZpw/VfjUDdiiR8Iq2uGzsraUwSTq2GDDv1Naa9h0ty
	RJhYgoBhwefuSx5G4QfR9s+6q9AL+sVHoDtMZhOHmZql+WzmQWsQFFbbYcttLxJSVy8=
X-Gm-Gg: AfdE7cmSqqiuXMw+EXdnXuXaD1vaULwpvJrDvQl1C1Ix2sn3IUjO/1J/XAe4oi9bpKp
	tCERydtYBP+10HbKHCGiVdhdQU//iUNHnaSttyIoQOt0ukYmAvg6FF6uIBRkYqHr2IwYhQEa86a
	Vn00RNRjo6hTvCrmlqkyQqxtTbik+1giMUARE1OqIpCT/IU8h4imnvf2BD4Q9mUkuylkXFbpXlw
	zuR5Y+iyjU8nvaADYmxv5qvkA7deVVLfwhFP8rnpWfviRRv/aSiF6kCHwn4XIzVll0ttebqO+6Q
	ft3hwMwIk+yn/BB5VD3aS2Jnq5MnnQnwyQ2vf/sPRvooySRfr8WjUOo51nNQvwBJTwG494dOa02
	mER2cD+qu57Xax+PJ987wGW34ZviHnIbiwMf3L59/tMbYOEsVoF+VkDygv4j8avfgK4r/PE99Jg
	Lw1abwSMbWHLTGTm244c+c2PnCElVSuPUrFZCj2VkrrrjSnalJLfV8QXBQrg==
X-Received: by 2002:a05:7022:385:b0:139:fc0a:f48f with SMTP id a92af1059eb24-13b36df9c00mr1708626c88.38.1782920345898;
        Wed, 01 Jul 2026 08:39:05 -0700 (PDT)
Received: from fx.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b2cd1be7bsm15761678c88.1.2026.07.01.08.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 08:39:04 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH v2 3/3] xfs: fail recovery on a committed log item with no regions
Date: Wed,  1 Jul 2026 08:38:33 -0700
Message-ID: <20260701153833.3155514-5-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260701153833.3155514-2-bestswngs@gmail.com>
References: <20260701153833.3155514-2-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the first op of a transaction is a bare transaction header
(len == sizeof(struct xfs_trans_header)), xlog_recover_add_to_trans()
adds a recovery item but no region, leaving it on r_itemq with
ri_cnt == 0 and ri_buf == NULL.

If a commit op follows, xlog_recover_reorder_trans() calls ITEM_TYPE()
on the item, which reads *(unsigned short *)item->ri_buf[0].iov_base and
faults on the NULL ri_buf.

The log is CRC-checked, so this op sequence comes from a crafted image,
not media corruption.  It faults the kernel when such an image is
mounted:

 KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
 RIP: 0010:xlog_recover_reorder_trans (fs/xfs/xfs_log_recover.c:1836)
  xlog_recover_commit_trans (fs/xfs/xfs_log_recover.c:2043)
  xlog_recover_process_data (fs/xfs/xfs_log_recover.c:2501)
  xlog_do_recovery_pass (fs/xfs/xfs_log_recover.c:3244)
  xlog_recover (fs/xfs/xfs_log_recover.c:3493)
  xfs_log_mount (fs/xfs/xfs_log.c:618)
  xfs_mountfs (fs/xfs/xfs_mount.c:1034)
  xfs_fs_fill_super (fs/xfs/xfs_super.c:1938)
  vfs_get_tree (fs/super.c:1695)
  path_mount (fs/namespace.c:4161)
  __x64_sys_mount (fs/namespace.c:4367)

A committed item always carries its format descriptor in ri_buf[0], so
one with no regions is invalid.  Reject it with -EFSCORRUPTED, like the
unrecognized item type below.

Fixes: 89cebc847729 ("xfs: validate transaction header length on log recovery")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 fs/xfs/xfs_log_recover.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 5347f6a5ec42..461e847c32a2 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1907,6 +1907,15 @@ xlog_recover_reorder_trans(
 	list_for_each_entry_safe(item, n, &sort_list, ri_list) {
 		enum xlog_recover_reorder	fate = XLOG_REORDER_ITEM_LIST;
 
+		/* a committed item with no regions has a NULL ri_buf[0] */
+		if (!item->ri_cnt || !item->ri_buf) {
+			xfs_warn(log->l_mp,
+				"%s: committed log item has no regions",
+				__func__);
+			error = -EFSCORRUPTED;
+			break;
+		}
+
 		item->ri_ops = xlog_find_item_ops(item);
 		if (!item->ri_ops) {
 			xfs_warn(log->l_mp,
-- 
2.43.0

