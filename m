Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7307A218823
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 16:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740588235; cv=none; b=jNXug8dDOCPCdlxxxmhx9T7uTIKV7xAWouIfloOcKxW0wezHZiTDSkPanpvOeJygA11CXq1edCBX5IYLUgwmAXxQIuw/xB9rBHAefIDCn2J8V9efuARo+oIEUrXG21DINHznxED+biG9yp6umkA1gzx7B0MklyfBWvpE/quzBAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740588235; c=relaxed/simple;
	bh=C7uyY5Pz0Lz9PwmsfVNIVgjqn8SRb4PUJ9FRC/UIvoE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HTY0iMmM62mtO47gyVGIQP7z7oBdymTO85bnzNLw3Qba2gFWNLfbVKZDfJTPzyu00QBpeXATqA/ztA0PWq1tFLZ44U3P/pkP6dmjhQmReOTQyi/e4r+30cjQ6ECXp3alEOCDcshvCato1s11yphleVY4C5janxHaDFXaT46ELs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VdayTspU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VdayTspU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740588229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LAMKY17M1S8TSLM2ApfQPBKV8Lm25eVHHysXLb156Ds=;
	b=VdayTspU94eyZ2Dl8IlFUMLYUv6KbQBGsUFW8kEgrwGxuX5RlRbREddosXg6tzWg/rbFiV
	JG5A6gkn7cxnsuyIiDHzMxflCfMiOtUwo/nD3kE3sqGZ1V9Be7p1E+97t0FrsViDurPTge
	z3TUKtsjDr7Q0OrclxQjHYBRy05TWWQ=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-GlJqVJxaM5GwhsxOK1eTVg-1; Wed, 26 Feb 2025 11:43:48 -0500
X-MC-Unique: GlJqVJxaM5GwhsxOK1eTVg-1
X-Mimecast-MFC-AGG-ID: GlJqVJxaM5GwhsxOK1eTVg_1740588227
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7c0ae84aaceso1202577685a.3
        for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 08:43:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740588227; x=1741193027;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LAMKY17M1S8TSLM2ApfQPBKV8Lm25eVHHysXLb156Ds=;
        b=xHg6E2J3/k6HWjMLnU3RuKBOW3uQ79I2vYjY1eEH6/kPEDnnoRol+17SJfwTd/3rg9
         PNBQx7sFnVb0z9BM2NyKJ0Wg9tJ9CwqM20QdENOlBp26mOGKjM/mtB93UMZ7p/CZ/D1J
         /goEgdgUF+9r/a/oXQWAHRyxgVo6kVPFShl+OC6wLa+LtET8yUGsHTNe+T9Z842R3/Ht
         gUDRN13HQz3/QUF4ThUBHOjYmFQniWXDYQwxYhMBXo3p0tdpCsXRxEiEoR/knd8UBRvB
         uhrC7x/x34mjVyuLZvnIXhfW0t6sZtrqfDYWNM1Ussqa9AODe+SCJ3WKK+6jWO7lq1qP
         3VuQ==
X-Gm-Message-State: AOJu0Yz1nmOeOoiuribxc+5P6KQ8rq6ZVZr3Tl1XwqlbkeuDfceCv0Hp
	G9g6Fobi4uXyTYJq+EqMFiOL0REwPpYmT1jw+LZqKVajOSU4G1uCe57TxQCUjWEpBx84Odjh79L
	T1VgRmLC5ExneIvYgFWdM6C1O1ja+3s7cKMRQ+dFoC6/XI90rt8SHKG8OihiS10lJy2FjIXdQ48
	ru6PiWEr722PFs6Fe0Nt9PTCs6bes/7fWmKGENDHSE8Q==
X-Gm-Gg: ASbGncvYPix1MefCJXSXArM3vg0DcS/V8sVNFpJpTf4xWVD6S6P5lqwxoGEi80PszMt
	ZMDDTbhvmPX0QV4hynCZNBBzEW7pvYZCZzV7nkWcDkNunhff2q5opKCNj+cJhjVAFNPQHopTaEo
	2M0FDwpPc0Xyx8q6W0hP5waIvqhps68dxumLTp3yACjNVqk0DmximoJugoOsmFo7p44JgRehFYg
	20x19JBy1k8QKH/3/df8dd9t9kkVif/01yNzSHgdEfwmvN0RSc7cqLJ6bL53Atu6PBV4yLVvZxg
	uTsr2+tn/SXrOOU3lqtujzt9Xi2OQcw7MxbsNTHcoSkvlOzcqPQ15ZQXvA==
X-Received: by 2002:a05:620a:4512:b0:7c0:61d2:4ec5 with SMTP id af79cd13be357-7c247fe48a3mr659122785a.53.1740588226895;
        Wed, 26 Feb 2025 08:43:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEL9gL0WEo11J/B3VWWA/FPx1fX3KYbvG3GXkRDB4Z2Ndmiub+IXpkmGVk32EgCLULGlvkbxg==
X-Received: by 2002:a05:620a:4512:b0:7c0:61d2:4ec5 with SMTP id af79cd13be357-7c247fe48a3mr659118185a.53.1740588226462;
        Wed, 26 Feb 2025 08:43:46 -0800 (PST)
Received: from fedora.redhat.com (72-50-215-160.fttp.usinternet.com. [72.50.215.160])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c23c29936esm265907285a.12.2025.02.26.08.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 08:43:46 -0800 (PST)
From: bodonnel@redhat.com
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	djwong@kernel.org
Subject: [PATCH] xfs_repair: -EFSBADCRC needs action when read verifier detects it.
Date: Wed, 26 Feb 2025 10:43:34 -0600
Message-ID: <20250226164334.556505-1-bodonnel@redhat.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bill O'Donnell <bodonnel@redhat.com>

For xfs_repair, there is a case when -EFSBADCRC is encountered but not
acted on. Modify da_read_buf to check for and repair. The current
implementation fails for the case:

$ xfs_repair xfs_metadump_hosting.dmp.image
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
Metadata CRC error detected at 0x46cde8, xfs_dir3_block block 0xd3c50/0x1000
bad directory block magic # 0x16011664 in block 0 for directory inode 867467
corrupt directory block 0 for inode 867467
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 3
        - agno = 2
bad directory block magic # 0x16011664 in block 0 for directory inode 867467
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
bad directory block magic # 0x16011664 for directory inode 867467 block 0: fixing magic # to 0x58444233
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
Metadata corruption detected at 0x46cc88, xfs_dir3_block block 0xd3c50/0x1000
libxfs_bwrite: write verifier failed on xfs_dir3_block bno 0xd3c50/0x8
xfs_repair: Releasing dirty buffer to free list!
xfs_repair: Refusing to write a corrupt buffer to the data device!
xfs_repair: Lost a write to the data device!

fatal error -- File system metadata writeout failed, err=117.  Re-run xfs_repair.


With the patch applied:
$ xfs_repair xfs_metadump_hosting.dmp.image
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
Metadata CRC error detected at 0x46ce28, xfs_dir3_block block 0xd3c50/0x1000
bad directory block magic # 0x16011664 in block 0 for directory inode 867467
cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
bad directory block magic # 0x16011664 in block 0 for directory inode 867467
cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
Metadata CRC error detected at 0x46ce28, xfs_dir3_block block 0xd3c50/0x1000
cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
bad directory block magic # 0x16011664 for directory inode 867467 block 0: fixing magic # to 0x58444233
cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
rebuilding directory inode 867467
cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done

Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
---
 repair/da_util.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/repair/da_util.c b/repair/da_util.c
index 7f94f4012062..0a4785e6f69b 100644
--- a/repair/da_util.c
+++ b/repair/da_util.c
@@ -66,6 +66,9 @@ da_read_buf(
 	}
 	libxfs_buf_read_map(mp->m_dev, map, nex, LIBXFS_READBUF_SALVAGE,
 			&bp, ops);
+	if (bp->b_error == -EFSBADCRC) {
+		libxfs_buf_relse(bp);
+	}
 	if (map != map_array)
 		free(map);
 	return bp;
-- 
2.48.1

