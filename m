Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AF632ED4E
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 16:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009215; cv=none; b=e5HxBU4DmHzutIL2ocOrbEv5zib2V5no4OIOTrTcAv60mGv1l0E+J84uJ97CdAGcf3yBVALMFX51VtVBjcN9xAWZi6O3MxEEXRM48IncBN4iHWNH2Fe857iS6dfotjaRsd4u5F/Ob2RsUWgVoPGtmzsNkmq7QRwY+OQVrQ4fk5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009215; c=relaxed/simple;
	bh=uZdyal3TudfnXzXkBrQ6v2e5yAG18HQf5hN6L3CsHfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bOMDrDacvrtVoWPnBWudGXtE5OCoucouL6fMv6V8jhq41vJqli/PNgxuUmKnMdIN93ntZzTkr65JgmowlziC46Ny4LbZJg4jTwkaUVLojduXFbXtf1NBYHENbYOEHl6eg85tKwmi0thmZ49kjs5ujYNII85SHqcd8sW40q2inaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yxy/q4/c; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yxy/q4/c"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2c9d87b1f9eso20130575ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jul 2026 09:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783009214; x=1783614014; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rnMPSSlYPbFeKjZ6REZ70kPjg0z6TdA8YrdT5/DPlfA=;
        b=Yxy/q4/cg8O1qzxwt0+VHPudaf+CzUx8dTrx8m2cviij0IQN8nOs6FgtLLEHxSD9+G
         BuXx9HStXPGjax46W18Oolna9sTCa7SxPWqmBOddGTMiB8mFjgedGYyxKqIyn/fD++P6
         zwnXamJtece2oI4ttxCW2wpGgFwZIBRyOlbTfhmtuouOi5+j7qvMFJSA9V0iEPnxUccf
         KDfdm59ulHSJ57LUXbxl/sy0xDbq2rsn5dpF3qL9n/MP3r5LiUCt6McTXDKFsKRfbrNm
         OKjYt3TbY1AtGE6EEI0A60EMQX+nUDmvJ5pM3VHi2ISjuOC8iOmJzdZ+K4OR+daG1apF
         pLMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783009214; x=1783614014;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rnMPSSlYPbFeKjZ6REZ70kPjg0z6TdA8YrdT5/DPlfA=;
        b=QEUnYX9I7E0qe56zjtgj6zVil/uJyKgstrnFJvwvH+aoRaCPpbeu4LDkikc26snkmF
         Dh/EC5oxJ3u+LK/6369tf7iyPIQCx9H1rcxfMZyZm4bTuPeARJbfmZ+Jk7pXh3O5u2xv
         FQAzu9jQoEsVIHF4OKuTHebdfzI2hPhmKdIckjikxsOu8TAxFZ+gp4QMZFv+NLcLq/Sz
         +boIHFCPY5HBCnoZusybsscscCM8WNpcLRGWc0OaZEIjeo001XqEZHHbR33nONXjBQta
         edP7MxYJJznKyGPL9bkSWBHQ1z/YMDKK9sAmZxno0A8HJD0G290FSQdmdKWflY4gH6uR
         tDXQ==
X-Gm-Message-State: AOJu0Yy9ZcKt5vLnU29LkovNkBxRCypT1BUBVFUuzAQu4KUcpGvkis0a
	XqFvLOykAbicUiz/5NYRa+mEon3Q8wzgNuLu+EM4TRFmLjuVCQUb0GjAkdhwPs8u
X-Gm-Gg: AfdE7clOoDynTZi6Zn0IKgm0nA9pR0ujPC1/1uhPlMBY5y3/ZBICqOUMruKSaIUE/uz
	ycQoG4awRj/7AxMxJbFPkvZFZFWMEAIYCSXFv7G/BSbqk2Q/iB9zoZdrNW1Og3buDv2ThHl5rm1
	9rFc+C/Zxpg3oFq5jEaF1ztvp+JMQoTaW/tyr4dpexfPcX56iLnBV51VfN31igS5d3SKSIoEtfG
	3IczE46eIzo6OOH7xuP4aVHLoec8R+iX3JUZIB26BblAp5daG0wMnBRhYNpRNoJ3y41Hr/R5kKG
	NepZaPceoSykT+xV6MFesBWO+BbdubvirLrBt1mGJor8zux7QX5lYNOyz6A3JMuvaY2k1rj63DR
	jjqfeJQIIO2Z1zXp0TE3+5jGhblzFOU6Vdh082hlN1hF4jovLiP7ab+Kr/G3N7vIalumDmbeKQB
	1Ji8IhAkLDKmfUDObcv2ObwWWY0uG1pvPydgcrdqhk7AdPGNmRMyKhCnqLTw==
X-Received: by 2002:a17:903:3c05:b0:2c8:4c29:afeb with SMTP id d9443c01a7336-2ca7e6519c1mr75850665ad.8.1783009213852;
        Thu, 02 Jul 2026 09:20:13 -0700 (PDT)
Received: from fx.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b3c85b345sm16493826c88.10.2026.07.02.09.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 09:20:12 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v3] xfs: fail recovery on a committed log item with no regions
Date: Thu,  2 Jul 2026 09:20:00 -0700
Message-ID: <20260702162000.3548359-4-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260702162000.3548359-1-bestswngs@gmail.com>
References: <20260702162000.3548359-1-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the first op of a transaction is a bare transaction header
(len == sizeof(struct xfs_trans_header)), xlog_recover_add_to_trans()
adds an item but no region, leaving it on r_itemq with ri_cnt == 0 and
ri_buf == NULL.

The header can be split across op records, so later ops may still add
regions; the item is only invalid if the transaction commits with none.
The runtime commit path never emits such a transaction, so this only
happens on a crafted log.  It came from an AI-assisted code audit of the
recovery parser.

xlog_recover_reorder_trans() calls ITEM_TYPE() on the item, which reads
*(unsigned short *)item->ri_buf[0].iov_base and faults on the NULL
ri_buf.  Reject it there, before the commit handlers that also read
ri_buf[0].

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

Fixes: 89cebc847729 ("xfs: validate transaction header length on log recovery")
Cc: <stable@vger.kernel.org> # v4.3
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 fs/xfs/xfs_log_recover.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 103b2a79667b..fdb011e6ef60 100644
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

