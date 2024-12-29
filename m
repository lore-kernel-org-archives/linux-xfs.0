Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96AFD172767
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479615; cv=none; b=cd8is87T8rWBSuBzOcDwCajhB6QOVAC8cSBswfdTf3IzJJuZmVtiQHmWLWG+ZfkzhP6hZl+FQ66U32jHne+guKExGr17mZm4JEq2ZNxAnfyAjLQ90lNd/8/Yp4Bu3jj961JQnmB2cKT5m+1LRqbHbKeJzgK9UH1bCyW2P/JLNtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479615; c=relaxed/simple;
	bh=UOO5WIkoVcMwr9Osx1Ts3c6uyPlk/bHm2gr6jDN+9M4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnaBZ4csahWZm3m5tBIWrJI70hZz5hld1iD8kk1PN0KRMBNDLqXJWdmtylLC9P2xO2GcLEoTtps+YBRIEzDiqGC7GFpsZ6m4UETBxZHYZAonBzsBp9jzWBmFlAriOBceLF2zki3y7JlXq19ckL0m65wqEunbat9e5v76wKjDX+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GFAOOEyI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GFAOOEyI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9VBDYY8YsqmepvnZrhH2SrGNKASbUKPW898jWxTGVMo=;
	b=GFAOOEyIZSCcOatCUOit9td3R2CS+4MQlaQJKCCUaIL9enaVq+mTbJeiMf0jU84VRxQzyU
	LL01vlfG2ShUY+IQdedAFGcb9On9/z6z7TZ9LZ6y2vxxmixkT8IZEJp/r+abevGsTFTUa2
	1oW549ILaQSljjPRJJU7dgdDL8yGTxM=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-186-VQx614OhPe-vp61MK1cOxw-1; Sun, 29 Dec 2024 08:40:11 -0500
X-MC-Unique: VQx614OhPe-vp61MK1cOxw-1
X-Mimecast-MFC-AGG-ID: VQx614OhPe-vp61MK1cOxw
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-aa67f18cb95so155439666b.1
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:40:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479610; x=1736084410;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9VBDYY8YsqmepvnZrhH2SrGNKASbUKPW898jWxTGVMo=;
        b=o3eusl5+ECu61J9H/3jwBFwdh4M0RKth+yb6Szf3j6g+P37VrJ/CBPcEMkQR1wCbwY
         RnpNSmR9hEpFfruh+owavLQdzmlxeFPDlkpTahYy2TbAf3JavGqUEZBIfulmBIKiNBr0
         EQEzqvbIQkK+cKC/SmNlDcL0V+s6YsZkANj4K3Ml7uTTpD7BEYNqYh3jLIWDH5FRNTak
         +Sw/gmX+qiSQHoOOnb+6eVgHy1tY1SOeg+YoNdpsvvFoAuOuFiVehmdwRK8OOSc+5KFx
         7ior5ULo261/C0kEdgg92lhq+33N3n6aSuRTovLTHdteGONZMuakydxLZdXBPwKoCifl
         6t9Q==
X-Gm-Message-State: AOJu0YyrP0011Dn6Qsxvtj5wWzpYO6fBmvAMxlRoSX1pwP+3b9PTPxA7
	3UuChrN7n3eCMb9ohff6evzYDdpixhbRUH/1Uf9CwpY3kJ+iz18aQ7FKC+pHD/ced/0ptag3OLJ
	jTTNHdBm81uhIDv/Pg6+VZF3vILyR/BN0Jsipc4hpKiQBg0kZyc/77iCntN9ZJavUcUduoeXz5v
	tDG2bm5hTO1AmIaB29c25HFhxXgmSZOJSGV0Dj1Fa2
X-Gm-Gg: ASbGncv+7wj1XyEfSfX1t09CD8VMfsjmwOdevgRsstPc3Vf5VJySGXBYsQ3TKhUNmNg
	n2N4EsXeUnfQ/lW0CrDWv3srrrq3PYDRl5KDRghrrkXJ8znwHF9xvl2ZKDw0O44jT8Wx9TrB++/
	nJpIGMTk/0f3N+3FdUZAvX6+A/DcLXf2B31p9KlJpW2kUC/X4OrggUkKcTzwFzGsOpHFXHTi67y
	ztyr9Z0zP/iRhXsSA/PHmxTCTyhiUWosClL3FG2Kuep4bgAdC+j5f5dJ0KD0yWMjZ0GHLM66hV1
	on8aFmnJ/Zq1g0o=
X-Received: by 2002:a17:907:9715:b0:aa6:8ce6:1928 with SMTP id a640c23a62f3a-aac334f7a7amr3166807666b.48.1735479610021;
        Sun, 29 Dec 2024 05:40:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFCtwjBAkE2JQ2dVcwGNLsmstRAGCwUsWbTAIPGg8XHjMlSGeXl8YRQTHrAwL5nNHYMVYRkMQ==
X-Received: by 2002:a17:907:9715:b0:aa6:8ce6:1928 with SMTP id a640c23a62f3a-aac334f7a7amr3166805066b.48.1735479609554;
        Sun, 29 Dec 2024 05:40:09 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f070a7bsm1355017766b.201.2024.12.29.05.40.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:40:08 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 19/24] xfs: use merkle tree offset as attr hash
Date: Sun, 29 Dec 2024 14:39:22 +0100
Message-ID: <20241229133927.1194609-20-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133927.1194609-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133927.1194609-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

I was exploring the fsverity metadata with xfs_db after creating a 220MB
verity file, and I noticed the following in the debugger output:

entries[0-75] = [hashval,nameidx,incomplete,root,secure,local,parent,verity]
0:[0,4076,0,0,0,0,0,1]
1:[0,1472,0,0,0,1,0,1]
2:[0x800,4056,0,0,0,0,0,1]
3:[0x800,4036,0,0,0,0,0,1]
...
72:[0x12000,2716,0,0,0,0,0,1]
73:[0x12000,2696,0,0,0,0,0,1]
74:[0x12800,2676,0,0,0,0,0,1]
75:[0x12800,2656,0,0,0,0,0,1]
...
nvlist[0].merkle_off = 0x18000
nvlist[1].merkle_off = 0
nvlist[2].merkle_off = 0x19000
nvlist[3].merkle_off = 0x1000
...
nvlist[71].merkle_off = 0x5b000
nvlist[72].merkle_off = 0x44000
nvlist[73].merkle_off = 0x5c000
nvlist[74].merkle_off = 0x45000
nvlist[75].merkle_off = 0x5d000

Within just this attr leaf block, there are 76 attr entries, but only 38
distinct hash values.  There are 415 merkle tree blocks for this file,
but we already have hash collisions.  This isn't good performance from
the standard da hash function because we're mostly shifting and rolling
zeroes around.

However, we don't even have to do that much work -- the merkle tree
block keys are themslves u64 values.  Truncate that value to 32 bits
(the size of xfs_dahash_t) and use that for the hash.  We won't have any
collisions between merkle tree blocks until that tree grows to 2^32nd
blocks.  On a 4k block filesystem, we won't hit that unless the file
contains more than 2^49 bytes, assuming sha256.

As a side effect, the keys for merkle tree blocks get written out in
roughly sequential order, though I didn't observe any change in
performance.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c      |  2 ++
 fs/xfs/libxfs/xfs_da_format.h |  6 ++++++
 fs/xfs/libxfs/xfs_verity.c    | 16 ++++++++++++++++
 fs/xfs/libxfs/xfs_verity.h    |  1 +
 4 files changed, 25 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 9c416d2506a4..05021456578b 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -612,6 +612,8 @@ xfs_attr_hashval(
 
 	if (attr_flags & XFS_ATTR_PARENT)
 		return xfs_parent_hashattr(mp, name, namelen, value, valuelen);
+	if (attr_flags & XFS_ATTR_VERITY)
+		return xfs_verity_hashname(name, namelen);
 
 	return xfs_attr_hashname(name, namelen);
 }
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index cb49e2629bb5..99ca5594ad02 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -938,4 +938,10 @@ struct xfs_merkle_key {
 #define XFS_VERITY_DESCRIPTOR_NAME	"vdesc"
 #define XFS_VERITY_DESCRIPTOR_NAME_LEN	(sizeof(XFS_VERITY_DESCRIPTOR_NAME) - 1)
 
+/*
+ * Merkle tree blocks cannot be smaller than 1k in size, so the hash function
+ * can right-shift the merkle offset by this amount without losing anything.
+ */
+#define XFS_VERITY_HASH_SHIFT		(10)
+
 #endif /* __XFS_DA_FORMAT_H__ */
diff --git a/fs/xfs/libxfs/xfs_verity.c b/fs/xfs/libxfs/xfs_verity.c
index ff02c5c840b5..8c470014b915 100644
--- a/fs/xfs/libxfs/xfs_verity.c
+++ b/fs/xfs/libxfs/xfs_verity.c
@@ -56,3 +56,19 @@ xfs_verity_namecheck(
 
 	return true;
 }
+
+/*
+ * Compute name hash for a verity attribute.  For merkle tree blocks, we want
+ * to use the merkle tree block offset as the hash value to avoid collisions
+ * between blocks unless the merkle tree becomes larger than 2^32 blocks.
+ */
+xfs_dahash_t
+xfs_verity_hashname(
+	const uint8_t		*name,
+	unsigned int		namelen)
+{
+	if (namelen != sizeof(struct xfs_merkle_key))
+		return xfs_attr_hashname(name, namelen);
+
+	return xfs_merkle_key_from_disk(name, namelen) >> XFS_VERITY_HASH_SHIFT;
+}
diff --git a/fs/xfs/libxfs/xfs_verity.h b/fs/xfs/libxfs/xfs_verity.h
index 5813665c5a01..3d7485c511d5 100644
--- a/fs/xfs/libxfs/xfs_verity.h
+++ b/fs/xfs/libxfs/xfs_verity.h
@@ -9,5 +9,6 @@ void xfs_merkle_key_to_disk(struct xfs_merkle_key *key, uint64_t pos);
 uint64_t xfs_merkle_key_from_disk(const void *attr_name, int namelen);
 bool xfs_verity_namecheck(unsigned int attr_flags, const void *name,
 		int namelen);
+xfs_dahash_t xfs_verity_hashname(const uint8_t *name, unsigned int namelen);
 
 #endif	/* __XFS_VERITY_H__ */
-- 
2.47.0

