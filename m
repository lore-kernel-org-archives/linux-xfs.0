Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5385774C14
	for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 06:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770703235; cv=none; b=mmdCKqEiyARWapfUQNt8wVHs8BcqYfOO08AFjvO40AZyqNRLBS7QGws0Any9ywdJn1XbQLcwNA7Ei23tIFXKG62gMx7xfiYLyPfexn5a1WlCtwcVPCvGPnagHry/30eu7vopobQW3c80QyBH4zrENCS+WTW9rlRW396FKJ8LVAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770703235; c=relaxed/simple;
	bh=MqSWhWO8yNsdnkPUq0kzrlXLpLq02XL9hPi978Q+6mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/9FzB/bokx/bHgdOUfgnIpqUFcVs9O4W/VqZDNw7ZDGRsIUobaK5U3iYlOkFzcT+Gp+mAbbGhosC2VI62amHrhN9u0shOXhl0jgseh1HNQa9NXT2bJhXupMfk1Y9SM1aa8lNtE8OF1XKEAGM+9kd7DvvNa6aY/QpQ6B10XrFL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EoSWdXsx; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EoSWdXsx"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-35640ad94d3so447892a91.1
        for <linux-xfs@vger.kernel.org>; Mon, 09 Feb 2026 22:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770703233; x=1771308033; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f3pi578tNsHpHm4XLR4sQaEFh2ch49VHP/2oPrNsjAA=;
        b=EoSWdXsxK3kcWvg/W0oACDP8qWqlqgPc4T+d88ugBss2sPpkLVmOuya6XJIYPkFzjE
         nCc1wQYgw8qkoscDP/PrXu9GGW1hox2AuQNnwuIU/84GqbsXhNdw6Wft/2QOAzYjQA1g
         QELKKxka1XdGE6Z64FZq+LfOteyIm/cn/kVch+IfCynatCZ4x/F/IQ8TnYT1AIPThODK
         pKjNoV5HmHvFoj246R5aTyfaolLp1q6cDb0LReFMnD2HQasDSqjumRN/m7YM90HzsclA
         M0q9F3RmwOMlNyzNE0AM9uAX7NJLnk9OWwnROWrMahnpSQT5DnKzt4Jbg5r0vJvDXgPm
         qbQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770703233; x=1771308033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f3pi578tNsHpHm4XLR4sQaEFh2ch49VHP/2oPrNsjAA=;
        b=CiXLEr0fWTbaHO9WcvNIS+pNZAM9mhpP+xZVrZJtC63JRIfAPr0Pr/Ra0cmtin+XRR
         efIqyTDoFIO+P2MhbeghrXiNQHZdC0/lQMOZfHWzFlxOqhOa50SX/eCf/ylWfXUXgdPy
         VwTKDNVPI3Ts+A9E4wdEhHQW6uQvqfv+9IVrHL7MqRX2/eS6AiFI2Pg0C3Ici1hV01kl
         7fJ/YDEq05cC1gFhIQZvU0wnLhkD+7ZNI6hPhEPmOloHarqFiDUquJ6HtjPOwoyX+/EH
         skxYBHGnhc5rIAzuirxXlUw2PJyIXa+McAgoIpzW4iMz+W/5oRqSHq4UhUxexPbkcH+y
         7Yyg==
X-Gm-Message-State: AOJu0YwsoQCHCvGJuiXvSIqQE9MJWWVFgzhfHo+CpElVqzQIjsz1FF7I
	BWh7zUPk8isMt8KvfY5nOcY/D+oM43Iy7tKsnCTMk7kKbalHDbsVxRmC
X-Gm-Gg: AZuq6aI/MraBmQYe3ABnjm6hf0ctd5mR5gquAKx54rtSG2MUAE0bcChfEB4pSDLv2P8
	f+GWW0hujCXEkAjERCIkmN3jFnDZagTZfzZbr0yNVCEKmLEAinf2yvqs56Qa3V8zvHCGrNQsHHx
	2lBctzPE6E/MYvbkh5S7KsRSQbKvFD32eoJrBonYt+2xZ85qTHr7RomwFlbXg/j4NASowTFB2cH
	mpTnyK7+5ADsGDQk8h3i9LrWrOcDgUvg2Tse2mWEa5+RatjaOO5UgTcKg4d185488Qwt6MR2+L4
	NUkwxQ12IwzdMbWKBtmI+LT4rylfnaihN4iQxTwjyAncqBFSgZNFus2T4SMkp2VEckTvnfumZ0d
	Mz65O/uixpcemi11mgUmH1Z74QP+vatqPUeA4d28KKIxmBC4ebV2FXjd2eyAonerXjrb0TaUm3W
	Ob8Z8wJQ54crI+0ikxcZurWbXEjMS8JRmstZYswGd9Qcepj1DReUCb5uBrzJym
X-Received: by 2002:a17:90b:53c6:b0:336:9dcf:ed14 with SMTP id 98e67ed59e1d1-354b3e263bfmr11945366a91.23.1770703232556;
        Mon, 09 Feb 2026 22:00:32 -0800 (PST)
Received: from zenbook ([159.196.5.243])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-354c7fad6c6sm6028151a91.1.2026.02.09.22.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 22:00:32 -0800 (PST)
From: Wilfred Mallawa <wilfred.opensource@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: [PATCH v2 2/2] xfs: add static size checks for ioctl UABI
Date: Tue, 10 Feb 2026 15:59:44 +1000
Message-ID: <20260210055942.2844783-5-wilfred.opensource@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260210055942.2844783-2-wilfred.opensource@gmail.com>
References: <20260210055942.2844783-2-wilfred.opensource@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wilfred Mallawa <wilfred.mallawa@wdc.com>

The ioctl structures in libxfs/xfs_fs.h are missing static size checks.
It is useful to have static size checks for these structures as adding
new fields to them could cause issues (e.g. extra padding that may be
inserted by the compiler). So add these checks to xfs/xfs_ondisk.h.

Due to different padding/alignment requirements across different
architectures, to avoid build failures, some structures are ommited from
the size checks. For example, structures with "compat_" definitions in
xfs/xfs_ioctl32.h are ommited.

Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
---
V1 -> V2:
	- Added inline comment to describe why some ioctl structs
	  are not addded.

	- Keep the new size check coupled under "ioctl UABI".

	- Drop size checks for structures that are in xfs/xfs_ioctl32.h
	  (i.e compat__X) to avoid build failures across different
	  architectures.
---
 fs/xfs/libxfs/xfs_ondisk.h | 40 +++++++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 601a8367ced6..dced91d281fa 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -208,11 +208,6 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(struct xfs_dir3_free, hdr.hdr.magic,	0);
 	XFS_CHECK_OFFSET(struct xfs_attr3_leafblock, hdr.info.hdr, 0);
 
-	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat,		192);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers,		24);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat_req,		64);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers_req,		64);
-
 	/*
 	 * Make sure the incore inode timestamp range corresponds to hand
 	 * converted values based on the ondisk format specification.
@@ -292,6 +287,41 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_SB_OFFSET(sb_pad,			281);
 	XFS_CHECK_SB_OFFSET(sb_rtstart,			288);
 	XFS_CHECK_SB_OFFSET(sb_rtreserved,		296);
+
+	/*
+	 * ioctl UABI
+	 *
+	 * Due to different padding/alignment requirements across
+	 * different architectures, some structures are ommited from
+	 * the size checks. In addition, structures with architecture
+	 * dependent size fields are also ommited (e.g. __kernel_long_t).
+	 */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat,		192);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers,		24);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat_req,		64);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers_req,		64);
+	XFS_CHECK_STRUCT_SIZE(struct dioattr,			12);
+	XFS_CHECK_STRUCT_SIZE(struct getbmap,			32);
+	XFS_CHECK_STRUCT_SIZE(struct getbmapx,			48);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist_cursor,	16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist_ent,		4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_ag_geometry,		128);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_rtgroup_geometry,	128);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_error_injection,	8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom,		256);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom_v4,		112);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_counts,		32);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_resblks,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_growfs_log,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bulk_ireq,		64);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_fs_eofblocks,		128);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_fsid,			8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_scrub_metadata,	64);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_scrub_vec,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_scrub_vec_head,	40);
+
 }
 
 #endif /* __XFS_ONDISK_H */
-- 
2.53.0

