Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2592E1E1E1A
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 17:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740591224; cv=none; b=iJV4kfH/HbSHQ/wpOaRgehzrbnXlPVj5MVV8R+tW5x79kkjD0H/M0o7+ReJGLd+eHTsq5At7qPmPA/u9iof173o8Z/nNUsqfPl/uWXRbnCbBo0UlIDFRR9lwRNg2LJNriVsJigbLQb6hX5su7H87ePrEIBaZzIUHjfQ/EIdkw/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740591224; c=relaxed/simple;
	bh=C7uyY5Pz0Lz9PwmsfVNIVgjqn8SRb4PUJ9FRC/UIvoE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=CmPW44Jpt8oTWIMHyqAaYHaDMFsgealFIZaFESIv4V1Gj7uIISMXo/LkTWlFQ/BWwxjZmcxVxY1mxEn63KvWyirJrKQyuc97vRdOxTSAcyyMwpMzoU+ssVB2V2Ra4g+tyQRr+DY8mudrC3xKiLN/QP6ipAWcoiSiTxpWhVPBAtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FiJ6pfs+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FiJ6pfs+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740591222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LAMKY17M1S8TSLM2ApfQPBKV8Lm25eVHHysXLb156Ds=;
	b=FiJ6pfs+BGSZUD3KOsDxGl1W2DLjCl9yb4GuzLQUiY2Ghi1fJXToFoZNTKhVqoj0rf9Cme
	K63WX2YatEVqSb9fyGleQkHyK0NIhxWvMy30RKGTP1tu7mvd7zFsZYSYpRrEeceQjb984X
	alsbFygI2av55WobwOu5CRFpJnWjyMU=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-59-cPdarrCXMCaFAkTPW5b-xA-1; Wed, 26 Feb 2025 12:33:40 -0500
X-MC-Unique: cPdarrCXMCaFAkTPW5b-xA-1
X-Mimecast-MFC-AGG-ID: cPdarrCXMCaFAkTPW5b-xA_1740591220
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6e6a94b6bdfso1859856d6.1
        for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 09:33:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740591220; x=1741196020;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LAMKY17M1S8TSLM2ApfQPBKV8Lm25eVHHysXLb156Ds=;
        b=GG55yKH1Q4eGNSpUEPEkCi/pARF/VGd8wLZeJnCUXaNYSCamfFGZ/RxQRHj/Wm0aAE
         KVl9Pq+wa7pEgRzQBKgLll1oQRYfEs1WYkHaI6BUYAFSe4pzkTZHlcazuoZ5by/uVEfT
         F9rJnBAU60spcipsv77TeK2d+WlxCwyFAm50N4c9W/IIDa0GCWwZc9kRd1YavLS1lpVH
         al9WLVEJMbGeVGF27LgDyczqJpJ5A6IhIvkQ98rftGprNjAkLH8jFZEuhiqKTEPQDLgr
         T/OhafoQ0+iPjpAdbJTiNlaaIHKhHYtuXZvtElaexfeCQ5jAa3U7mGQV7i6F/r+vyody
         Pqyw==
X-Gm-Message-State: AOJu0YwTTgST082MpzXo9zpfUmdhQx815t1naBiu8zM2cpXvjeMUaxtc
	ioB6HHNtCjQUqxkydgAfznWR0iGUvRvYttJ4wYr0dWurfpCH2GwG1w5d1Aa/vzqgM+xJlDGdW2/
	kmuPRZfBrRU7mpstTNYaJsOatIZ+Rd/ZakGmi9XyVhcQcPX0I9CgVk/kIvhZV6bjVjM9JL9Z18Y
	yO6fqPJIp8ySNASjNDxszvRLbymo97tFZk8ObHMfdpWw==
X-Gm-Gg: ASbGncva37HIta+PheEC361VqzzzEJfeA3zW4xdFLxn44dUQKi67rDxl9VdDmCTcwBo
	Vm0SvIJVI8VQUkRs7hmhnQGuWQXJzNMkFTunH4m75SqmF/nN91U4KgSb4IYS+mtiOhWIpn6gvED
	88Tw61Y7w4fPPzC6MYjtz1IPE4qmVVwLOenXMBf1NNK9vhQE4+2oMFtR5Y4q0JDpGxsplnT81Dl
	gRvDxULEo2njJlzSsBzRYhw9DtgE6OsaG4pBJAQbHCIGm/hjd2h5zhqBc7iOUX/GUIIgUrnSrX0
	MSfyL7/erjTv8zI8U/krFr35nJ5jhFmKdT6RE3uWkjacQACNXdM1Kc5W6A==
X-Received: by 2002:a05:6214:4007:b0:6e4:f090:3634 with SMTP id 6a1803df08f44-6e6b01ab9c3mr264224436d6.33.1740591220018;
        Wed, 26 Feb 2025 09:33:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH1P6edDbMH1ynV2gKOffEid6Yha1I6DoiFkxMqT/yT11CTeuYWGQDFL7/5XpBCyk7li/dfdQ==
X-Received: by 2002:a05:6214:4007:b0:6e4:f090:3634 with SMTP id 6a1803df08f44-6e6b01ab9c3mr264224106d6.33.1740591219567;
        Wed, 26 Feb 2025 09:33:39 -0800 (PST)
Received: from fedora.redhat.com (72-50-215-160.fttp.usinternet.com. [72.50.215.160])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e87b17103bsm25190246d6.94.2025.02.26.09.33.38
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 09:33:39 -0800 (PST)
From: bodonnel@redhat.com
To: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs_repair: -EFSBADCRC needs action when read verifier detects it.
Date: Wed, 26 Feb 2025 11:32:22 -0600
Message-ID: <20250226173335.558221-1-bodonnel@redhat.com>
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

