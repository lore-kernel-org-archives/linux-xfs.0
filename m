Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457C017B50A
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479542; cv=none; b=DKqWvUyZ9IuhadNruk/lqkpDsW1VUyFoSUNPwM9ESvLBg92f+iLSYb4s16d3lO9rED8ETGVW7r3zltdEgLzllX7fzEQOBNlnwAHnLRAftkeFlhlNx9BkVCvsZp2P+HFjDoqxAq1IdoJ+mym/UerwPI6upuk/UFWm69ugnk7ecOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479542; c=relaxed/simple;
	bh=C+Wv6tdJioRtfTE3kEjHgLGIfn0vVJJ9/ADqf0uxJZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTwphuz3A/E2iwUedRzJNhYooECxbbshrk5IOBy8DLYMmllecdgPO+O2uFPicV/aut+/p5GaO8ncQIMsur/V6tT+JZATqwsggBCduaHBO06RLNdUTbWsPsavFAVtZotk/yusl48E33CgLCC6Cv6EQHOV7CuFZqxzWVKo1keXTuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C/cuE3r1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C/cuE3r1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nWsspl0D0zo/uny5TfF8vLjKyVWpS+/wqpOlGGYSR9o=;
	b=C/cuE3r1jmmXasdxAiPBJ8KBD5594rrIslfPldc4djvCBM+Sb2lkwl1ra8M/qrPJzJS2Jw
	yZqWw4VqDK0M4q+/sCjqopaLx1vk7RRUnRpCGoHEwcxeoC1DJJD3wk02DMktpmDP4kVhUg
	oe7Xgvcc9SVQ1cjDiiggNj3Svjm6bXA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-206-czrnvJt2MiS-4-pGWCgHUA-1; Sun, 29 Dec 2024 08:38:51 -0500
X-MC-Unique: czrnvJt2MiS-4-pGWCgHUA-1
X-Mimecast-MFC-AGG-ID: czrnvJt2MiS-4-pGWCgHUA
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-385dcadffebso4267173f8f.0
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:38:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479529; x=1736084329;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nWsspl0D0zo/uny5TfF8vLjKyVWpS+/wqpOlGGYSR9o=;
        b=aIRDzqFBtKQJkfSdnSnKYc7MRWGjU0oV3VwpBAqcXkG5NUNfCVRjX1nq9Rt0cwCE/4
         OK/qCC2bSdJDf/G0eZBZLpfeV4g8cTKbCKpF+midbvvR4m84oErpM7f6j/z9ztY6e0eQ
         zPdy/UnmKlmgEqlH494EEZ9U5sw/VRiw6dWBkKTYMPxHK2HogImy9v/LMyKqxCAcf2No
         6mheRSbIvO7WztJWwZMonr9okc+lr0SZHj/Kt0yd8WmXON33+5YEIFiPBjAVfZAUkoFF
         IamQ2TRr4VsnveNPDXbbiZlNDzb329hqlmb7WVooHYh0AYxvjP2svslzOmQtu5wd2D5P
         VuDA==
X-Gm-Message-State: AOJu0YyzeZ/jVV01S7YUANNewrTJUW692KFVg8F/fDNCzuqYwbzhPELo
	L7rFTfWbHWwsaXSsd9+F15dX+QUHdyO86NHwTJGK6G2yRd6E6jGAStHAL6pTAbnh4pSTUpXQ8V2
	8gMZoceT3Foi4cP8U36tV54DufBNEwoG9krAXilMivxM7gn/GEoe/AU3VN0G33LBN+KArcawIMc
	ZMpOUFooLlS/S5T0YNeQM9ZKDMCLrDSZ9PmwTG9oAP
X-Gm-Gg: ASbGncucjtL9knfgX6fOvgtFJ2s2Yh3VI0MNwokDOU7s2RW4aOHAT6cpsl9SOl6mBa/
	JNyZjk4UwCSN+IhfUiaVb2zW9lG9Iq66EIBMSzi7wqChZUqD2SmbqAwpUBsslV9uM9wbsvXRLbv
	QAE1ItQpZa+hd74VWD0FQTrtjpKTbkTA6w1Q5xViNDxeTvVNMSVDBjKMq3ho8KV8g5tNv/mfRRv
	/DS73/ZBWkiHrZriZI6cNmCnqLvz16OWRTt7RJHrlqiV6xBijgNoxWXIEbttWmINjebkOq8CUsV
	Whe+bpvL6WM2X+k=
X-Received: by 2002:a5d:6d84:0:b0:385:d7f9:f169 with SMTP id ffacd0b85a97d-38a221e1461mr27306101f8f.12.1735479529317;
        Sun, 29 Dec 2024 05:38:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGkVU4PvUm0Dx09MnvQna+7KAIledFkyzpMhyzZV4w4BXRZ+zEc0DtjGfhU1gvgQWW/41+vJg==
X-Received: by 2002:a5d:6d84:0:b0:385:d7f9:f169 with SMTP id ffacd0b85a97d-38a221e1461mr27306088f8f.12.1735479528956;
        Sun, 29 Dec 2024 05:38:48 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8474c2sm27093127f8f.55.2024.12.29.05.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:38:48 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 00/14] Direct mapped extended attribute data
Date: Sun, 29 Dec 2024 14:38:22 +0100
Message-ID: <20241229133836.1194272-1-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133350.1192387-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset introduces new format for extended attribute leafs.
The main difference is that data block doesn't have any header and
that data has to be written through page cache.

The most useful part of the header, necessary for metadata
verification, is rm_crc. This field is moved into DA tree and
doubled in size as rm_crc[2].

rm_crc[2] stores both CRCs for data before IO completion (old data)
and after IO completion (new written data). This allow us to
transactionally update CRC in the DA block while updating attribute
data with writeback.

So far, the interface isn't useful by itself as it requires
additional iomap_begin callbacks. These are implemented by fsverity,
for example.

Andrey Albershteyn (13):
  iomap: add wrapper to pass readpage_ctx to read path
  iomap: add read path ioends for filesystem read verification
  iomap: introduce IOMAP_F_NO_MERGE for non-mergable ioends
  xfs: add incompat directly mapped xattr flag
  libxfs: add xfs_calc_chsum()
  libxfs: pass xfs_sb to xfs_attr3_leaf_name_remote()
  xfs: introduce XFS_DA_OP_EMPTY
  xfs: introduce workqueue for post read processing
  xfs: add interface to set CRC on leaf attributes
  xfs: introduce XFS_ATTRUPDATE_FLAGS operation
  xfs: add interface for page cache mapped remote xattrs
  xfs: parse both remote attr name on-disk formats
  xfs: enalbe XFS_SB_FEAT_INCOMPAT_DXATTR

Darrick J. Wong (1):
  xfs: do not use xfs_attr3_rmt_hdr for remote value blocks for dxattr

 fs/iomap/buffered-io.c          | 111 +++++++++++------
 fs/xfs/libxfs/xfs_attr.c        | 212 +++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_attr.h        |  11 ++
 fs/xfs/libxfs/xfs_attr_leaf.c   | 135 +++++++++++++++-----
 fs/xfs/libxfs/xfs_attr_leaf.h   |   1 +
 fs/xfs/libxfs/xfs_attr_remote.c |  83 ++++++++++---
 fs/xfs/libxfs/xfs_attr_remote.h |   8 +-
 fs/xfs/libxfs/xfs_cksum.h       |  12 ++
 fs/xfs/libxfs/xfs_da_btree.h    |   5 +-
 fs/xfs/libxfs/xfs_da_format.h   |  18 ++-
 fs/xfs/libxfs/xfs_format.h      |   4 +-
 fs/xfs/libxfs/xfs_log_format.h  |   1 +
 fs/xfs/libxfs/xfs_ondisk.h      |   9 +-
 fs/xfs/libxfs/xfs_sb.c          |   2 +
 fs/xfs/libxfs/xfs_shared.h      |   1 +
 fs/xfs/scrub/attr.c             |   2 +-
 fs/xfs/scrub/attr_repair.c      |   3 +-
 fs/xfs/scrub/listxattr.c        |   3 +-
 fs/xfs/xfs_attr_inactive.c      |   4 +-
 fs/xfs/xfs_attr_item.c          |   6 +
 fs/xfs/xfs_attr_item.h          |   1 +
 fs/xfs/xfs_attr_list.c          |   3 +-
 fs/xfs/xfs_mount.h              |   3 +
 fs/xfs/xfs_stats.h              |   1 +
 fs/xfs/xfs_super.c              |   9 ++
 fs/xfs/xfs_trace.h              |   1 +
 include/linux/iomap.h           |  34 +++++
 27 files changed, 580 insertions(+), 103 deletions(-)

-- 
2.47.0

