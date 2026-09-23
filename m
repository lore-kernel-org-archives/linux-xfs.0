Received: from mail-vs2-f41.google.com (mail-vs2-f41.google.com [74.125.227.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE5E3B42DD
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 11:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790164710; cv=none; b=Qpk4KAb99AbetPONKU6ypJ+AudQkQwWr3yq7QLL3l5eNYUW3NX4IbAwGZXkvVnLlgAOK7QGkpbp2pSNx0mrtD0EseBZ85yqU6THhrJPtf1BRLNkK/JMPbwJbm8mPWqSt0AoSVdxj90txLz68MP2GimI1dP6VqOyFvBSauy3GdjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790164710; c=relaxed/simple;
	bh=ifTmuhdYEfA8S+Ti9vBnBv8jVJkTFG9fKTW/c6hx1FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DPaNIYQqDWmfvMHsqjZmj0jdxQEDV7dh44owvN3spm574Xp/n3915lA0mNrLetV9k9zxN48DO0TLj8AexKQ5wYOCWNmRCt/WWKk0C5nI22ds5A/O0KDzuH0TZZx6M9Cl2AFMeqyhld5A2+82N3ltdP1JGfLgvzdq9UHCrVeHSQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i/nsXj3H; arc=none smtp.client-ip=74.125.227.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i/nsXj3H"
Received: by mail-vs2-f41.google.com with SMTP id ada2fe7eead31-79028ca9371so317721137.0
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 04:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790164703; x=1790769503; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ibl0MHrnxFzM837MpKxLVego5yHxJdHEFJ+77R4ZX9E=;
        b=i/nsXj3HBjJwaFiK/WvcUoe4E0BCWdtNaiOYTgdmylvpOiqzO5zCoWqYW9DZOBvZzQ
         /TgnxS2Ii2BE9zExDNiwpW4bhRvMf7q+bP5kiZ7nEtX7xZWe3kTqlqFA1ZRcEPUp5I2u
         uX6J7M0+7HHmpe7+rJJnzqz41PoSVqeFdbmctI9Q2uUgwoQ7ZaCWcbgkf1hcktGz2Z0o
         lMKXA5E8u7xMW4SHvc87aORe4hSZVyZNTn2G8byfOqcY3uvcFaJtxNAiN+EHNvpBD09m
         eNzorVOgqBsSGo5JfTLE/NOs0HDpssXfelWQs3G4RGzv+7tx8nqDQLBLIIQOkxjRBMnT
         UbaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790164703; x=1790769503;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ibl0MHrnxFzM837MpKxLVego5yHxJdHEFJ+77R4ZX9E=;
        b=eu9eOI8qrRG3IwogafJZiTpLWWMJscCVvl/Je2yIg1m0bfegODNSz+FXxjd4hn2d0p
         TWZ6pafpqmBFO+/q3JvnrSzBcPZDrfyJJtIQb2Af0D23eFgRAhHC+cqPzLKVU7vBQVZQ
         Qd+3XczKo5m5zCYpv21J320i5x2R207jnDJHXaRYS6S/4zA8DurYHiWyHlzv7kexBlsD
         Uex7uJRBQL9sWpCfMhu90W2Qx+qvoDnjX1lElpvNbaLOgJa2+/3UQXCl6CVUf+zUb5s7
         JQkh2GF5NEHIyeO/0mWI0pCWrTwFhGGt1F3X9n2TmnlT3rHoOdtoi59BmsyOfdTr4zld
         YUjA==
X-Gm-Message-State: AFuF++mfQoTQrRgL4OtDQ4AuOqiTP5TbATVCPEttQo2+YUbMq71jdfUw
	892AMraoLksuDPvOasFWDPaJX18ryXOPVEnrGBEAGthJvfOiTXRApEikcLcOFw==
X-Gm-Gg: AYBFou0lZHRNnmdvA9ggKKwMSGYO0Sy8lvfSu/W/vmTyAcKNOyS6+5fmUN22Obp0bzc
	vbsADg80hga+XdXhBfnEVtjoPMesuAfegiSLvTE9xVlCWJ10LobkSxuyFWKOUBMxkQ0w5SJtmP6
	Z6EcMim9Xhi3IyYobWvvIYwxTsH+QF8par2Fv2RJ1pNNrfnvm6eoUcNdT7tGewFVggZpvxj1urW
	lf4DcRUr0+6VVLQbP20v612b9y3+V320R9Rs5c19z6s69hSvGOIpZHp0DNj+NiGCr5MSVbpwjhy
	2bBT999k/TbrLIf3EY4GHxPJ0aeGWvTqln2VpFtAOhdzD6SO92VPfP9Gv8+cV8c7J8tgjqDo52c
	ulSMz5z4SC9+ljHnEhgQYpkoLqNU+LwxFz5EDxEZT4enobNFsupgpM9e8Y7kU02/FNLZH8AC8F0
	pXYbtPLhRwjBCZ2rCgDjIeBe0ez3iZUzDQPLM8hg+V+OXy+gAfsVlTFBoDtkkECxA=
X-Received: by 2002:a05:6102:f12:b0:79f:45dc:118e with SMTP id ada2fe7eead31-7ac1acd5debmr2043519137.5.1790164702882;
        Wed, 23 Sep 2026 04:58:22 -0700 (PDT)
Received: from beelink.. ([187.13.30.172])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ca2876229dsm1091399e0c.3.2026.09.23.04.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 04:58:22 -0700 (PDT)
From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-kernel@vger.kernel.org,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 RESEND] xfs: bound da-node entry count against the correct geometry
Date: Wed, 23 Sep 2026 08:57:54 -0300
Message-ID: <20260923115754.3196232-1-qwe.aldo@gmail.com>
X-Mailer: git-send-email 2.43.0
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

