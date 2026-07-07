Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DA62F12A5
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jul 2026 19:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783450976; cv=none; b=e5yLRD8Lo5JxxmAJYSwrAGjzasJKb7ogkjeT3IbxYdtsB0rpUnsYgI6/TdHFKh3SvKW2Fi/QTRIEPwz65vta/oTZT1uUEqlDnfsZnd1oTtDxXypNEDh8eXtCdq29b2KiJ1LN0Gb98K4Zy1GP8ASBcFNYgPSyTlfYGl1XxDGjIdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783450976; c=relaxed/simple;
	bh=ifTmuhdYEfA8S+Ti9vBnBv8jVJkTFG9fKTW/c6hx1FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g98ffb2Jwdmi9jiwDb5nbSfTndactgIp9mgMNsXgmPXly/r+yWCCY+x/alFhpBAGGUpuxmq3yqbRNUa3xYXFbgJeLrl+PR5UkILGc7JdhMKj9dV2FVyxMxzEAJuBK2oS+q/Cwz3W6tQUVlFqlYZSR8vFyBpmeLSYQGYtyh42nAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AP7rpcqE; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AP7rpcqE"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c9e30214d8fso3296079a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 07 Jul 2026 12:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783450975; x=1784055775; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ibl0MHrnxFzM837MpKxLVego5yHxJdHEFJ+77R4ZX9E=;
        b=AP7rpcqEK5S9B7W2eR7+tA+od7iBgBaWyY5p1QvuTTpydqmQLNqZvd514leH3pOZX5
         o2q4TZga2HHb7foAe+BB9WFBrQemb7aaw3BMXD1FznHinztufSrO9aKzlkpCK2oDksT0
         4/7YHE9yuP9h9Kxs0vPT4FeUb3ISWvFduJ6R+LruaCJkn45T0RYoHCDB3ksXuJA9VLcl
         qWXm7GBvGBw6wgD6By1TXlsHk41g+KFhSBlHgyQQPevfG10RxM+ELxB3e3YghJdTtCTr
         r6xfrhi2JH8CRQjE9iyXbOWGfY70jSLAqjmkYkuFRlwXTAyvWQYgbfyT/241c15n5l9H
         bL2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783450975; x=1784055775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ibl0MHrnxFzM837MpKxLVego5yHxJdHEFJ+77R4ZX9E=;
        b=Fzsxr+XZpkwplY0504ypkrjUiOVwTR3pdbFN5MI7eWT3j/umxTS/YH1hI5h01m8pU6
         /ij5dIerN+iu9J1dCwJ5Cb433W9FkwpT+ifuFFBZr5oAfSMR+HdG6JDLHhhfwAglvwPq
         ZCOkcu3J0WhGbTpdak4CFKwSQo0S2eBSCqkYEbnfyt1OTZQW2Yi4aem1e5u90NQcRSWS
         X0G4GDM5llMYz9psNjptPpTXFPQxehqZJBaLZCVnYy2WQQbh2/sqlecLqgIxdrAcI5hG
         a4SBRiH0TsxPX5CRI9Ddnkv/Ck2dZYDQfUt0ExUCYEnhMSJoHMNzSJHVU6i1S/YeaGRH
         OQrA==
X-Gm-Message-State: AOJu0YxXBzG1GcokFNn51DlOP6tc991gc6FiCHU5xNtau5UKeJPUhqoP
	XbGFFVS2BsHBQeECXtV6cmWUx/quGwW029CoMIrV+aq6ETDeSQyoBkoDZtjLwDTelKw=
X-Gm-Gg: AfdE7cmF+RnVwxRpXtz/dJz6jufpjIPre//fB/SveMgDmoSmPDiTMDVgJ2oCh+L+36F
	79ypDVGvGgejdk80GQ6qEL6xFDbXzPgkjbN7iSN/VNrEF/yXL+rv1u3TjfYfwNiZb603EMEbAgE
	Ag459FZTbTzCNzkvJXV4Fp+xospJwJK5Xkdkka7avk3mqa6T6Z17URF1/yb0DRbG7d5q1BJVSoR
	Xx7bVMY3CGjF7fGcXDJxuM9ZPyVvF93Gv5hEEm5wrx/lGXoa98pdLuoMe42EPfcnJRLCbZIbCSs
	mkACSQhnE+sI9jOBNLXtyNvmCsmPJKswep875jG2xmwPeaVcrmlEujokAvRFuWW6jbaPahx6RPY
	+Kas/BTlwYkK23Uio3fiinkfpUAOt0mEKSCTEfsrxHlimDzfE6h/Ib/u6NG2VFI0zWqTrk2v+gc
	6E8Ayx
X-Received: by 2002:a05:6300:2203:b0:3bf:6237:4d3f with SMTP id adf61e73a8af0-3c08ed081d3mr7453396637.18.1783450974527;
        Tue, 07 Jul 2026 12:02:54 -0700 (PDT)
Received: from beelink.. ([186.22.57.86])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b6593c76dsm10704585c88.3.2026.07.07.12.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 12:02:54 -0700 (PDT)
From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-kernel@vger.kernel.org,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] xfs: bound da-node entry count against the correct geometry
Date: Tue,  7 Jul 2026 16:02:45 -0300
Message-ID: <20260707190245.3813498-1-qwe.aldo@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260707135930.3214701-1-qwe.aldo@gmail.com>
References: <20260707135930.3214701-1-qwe.aldo@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_da3_node_verify() bounds the node entry count against the larger of
the directory and attribute geometries because, as a buffer verifier, it
cannot tell whether the block belongs to the directory or the attribute
tree. When the directory block size exceeds the fs block size (e.g.
mkfs.xfs -n size=64k -b size=4k), an attribute node buffer is a single fs
block that holds only m_attr_geo->node_ents entries, yet a crafted attr
node may claim a count up to m_dir_geo->node_ents and still pass the
verifier.

xfs_da3_node_lookup_int() then indexes btree[] up to that count during
its binary search -- an out-of-bounds read via getxattr/listxattr on a
mounted crafted image.

The buffer verifier is the wrong place to tighten this: it has no fork
context, and the transaction-less read path used by getxattr does not run
xfs_da3_node_set_type() either. xfs_da3_node_lookup_int(), on the other
hand, always runs on that path and holds args->geo, the geometry of the
fork actually being searched. Bound the entry count against
args->geo->node_ents there, before walking the entries.

Fixes: 7ab610f9e0f1 ("xfs: move node entry counts to xfs_da_geometry")
Cc: <stable@vger.kernel.org>
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
---
v2: reworked per Darrick's review.  Do not infer dir-vs-attr from the
    buffer size in the verifier; instead bound the entry count in
    xfs_da3_node_lookup_int() against args->geo->node_ents, the
    geometry of the fork being searched.  cc stable.

 fs/xfs/libxfs/xfs_da_btree.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 9debb95d86fa..95ea3737eb33 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -1787,6 +1787,20 @@ xfs_da3_node_lookup_int(
 		} else
 			expected_level--;
 
+		/*
+		 * The node verifier cannot tell whether this block belongs to
+		 * the directory or the attribute tree, so it only bounds the
+		 * entry count against the larger of the two geometries.  Here
+		 * args->geo is the geometry of the fork we are actually
+		 * searching, so reject a count that would walk btree[] off the
+		 * end of this node buffer.
+		 */
+		if (nodehdr.count > args->geo->node_ents) {
+			xfs_buf_mark_corrupt(blk->bp);
+			xfs_da_mark_sick(args);
+			return -EFSCORRUPTED;
+		}
+
 		max = nodehdr.count;
 		blk->hashval = be32_to_cpu(btree[max - 1].hashval);
 
-- 
2.53.0

