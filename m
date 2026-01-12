Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13382BDC34
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 14:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229497; cv=none; b=kZH4hf3Xjeb5F3pq44pJQdtMizHfLe7G+aK5Yv3dKH6c4dfAvoA5zBlSFuDjOkwKi3gZmm3K/417eAkMXm8Hbcb0IrOv4r8ltk8XTF40wvITJxcZazuMNLCsCe82ta6uzR3s4uPLeQCs3BFbAwLJxzLlMpEoVHhCgn6xcFZkCGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229497; c=relaxed/simple;
	bh=MxgptwcHFi+z4ifrlUMeCFEAHWtj2SNcmezFtEHqDpM=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ANn98wYy3okrZjE3aKAhaFmcpen0wqumqoxo/sK1rD2EMrRCwlvrVBnToIEf5URENHuOY46+j+k1ZGLWgKp7s8TGNoOH3c5i+I/4iYqKFAiMqrVKcnStR66/ZvWcp8duqJ1Lxg3ar4QmMsu+5F7Ypzpufv+ZyZvEbwrqtATXVFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e/MpJ+Lo; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ijykuOZE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e/MpJ+Lo";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ijykuOZE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768229495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wL9J1kXYNGpo3omk75dIbnVKK7rJ+xh/+WBR5nbHReI=;
	b=e/MpJ+LoVOlS+XORsJ+B06gpX6467c5Fr3AESpySf5a6A1OlJWFgcxLcRdxkR7/5bE4yFe
	iIZgZWi3RDj8gaBRGBMx1SPhSQP9medSQBaquH7u2dDq3SNQncSMiM/Xwu4V42dOB1axxd
	5DcCoi604fnWoR1wB/tcCycq3XJDTh4=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-374-ytAekTDJNe2ICtfNkuHHKw-1; Mon, 12 Jan 2026 09:51:23 -0500
X-MC-Unique: ytAekTDJNe2ICtfNkuHHKw-1
X-Mimecast-MFC-AGG-ID: ytAekTDJNe2ICtfNkuHHKw_1768229481
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b871e14de77so147497766b.2
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 06:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768229481; x=1768834281; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wL9J1kXYNGpo3omk75dIbnVKK7rJ+xh/+WBR5nbHReI=;
        b=ijykuOZEHrc4IJ9SxNOKtnblMmzn+NRbtnxf5B+HVJiVhgAP9JefXe3Dgm3TPRLn57
         1hPdUgVvFhHbCnxwyNjrQ70M9Lb6ZqEzN+eYHbp8Er/f4e8RteInKM0s06Bj0VcRwz3s
         xlaETzvX1bJVIXWD9Ym4MbCdlAjyq+gbBLWT2E81rr01u7SJP9ZSgCRaPB7JaOWvT5ho
         HVuvO9+WVReFiBghApWiaGwgDPkS4KTsXFn9rsnqED3/+IMj8120LoqEAGHOMewdt8O2
         2MR++MnYPK2xpiGCWM8Tkm/J9pwRT8965tHx3dJhZF/otGGfJdEHfW81/aeK30YEI0JM
         hpwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768229481; x=1768834281;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wL9J1kXYNGpo3omk75dIbnVKK7rJ+xh/+WBR5nbHReI=;
        b=fnE0RRCrS2IX8vL6r6ZZCEqzSvpu40/zbY6Bu5fnBa5tCia5X5WsrLAfzPXa/QITdC
         zBdESxoW2esRtKEs12Up2atsyMrzSTBZ9wt5BzxS9JsDsWOnfWbBGwlxrCSwyx/TXGE3
         k96B2/r1MhvEjJ0Tt5aT75ZcDePXwNZZG+WOOoSsXcmIGvpagRP2wCxJbGt7cDut8oFF
         30ene3XUYDrYeMBJ6DOkVppiDbSZh+mCtynMrYy1T50r/wb9HQo+o3vxqCN+fv9yDN29
         i/xP3ggu7hkaSlYWEh9BqkyPTZJoXoL0n1J5F9xrY/9bjsQwKnOvByh6vmnz9us31MEC
         v/7w==
X-Forwarded-Encrypted: i=1; AJvYcCUmJsZuwtj+js/A65XAcDueD2VeoYU5dj1lvjY0UG019qs+yp0G8fccB3GT9cbyeOTOSXV7LY+z+xg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwM655jqf/LsgiqK0JV3QsNs0UGAdMH+S+ppLq42b6gDv6SqlG9
	zJ83rKflNFnWk362HN/2CxPKIbQJDhevXLpQ3UAsB0QEOTqYE+R5hooQE+Jrj3hsHIxSoV9RaJ3
	wDCUxsLnQGFi7sX/OGiW5D1NpcUBGVPlWSzmesd7P720mAaD1/tscKdyX5s9KxVbMNS03
X-Gm-Gg: AY/fxX4Ku4ULB9/16gHrzr3KU1gYhoEDt7UJrZZflYJ8zdlqAbLvflThgRNKtMaUAVi
	MxyIVkem4Uksfgb48eikqzmaRGxWpb/UuszHJEPIwmTkPjxcaBOE74SHLVQrf1jE9yELarx19v/
	yAUkMQz/uVj6fEitncKTTFYNJs9P0EJk5QNCFF0z9f/nO91scPGYpsidUdAR9SMEI2dPbyuR40t
	7NaGiDxzSxMVo7KAXXB2IyUqUKxq4/+h6+cyInVOjcJKdSgVg8d17KjGT8BkEyz6cgvFM0IxukL
	zduMhawfZN8m3tkBfUP+UianOzNNlGmmMuHAYJPPcuws18sdo30nkdaKK1XQaEmhLuw7tCb2UjY
	=
X-Received: by 2002:a17:907:7f90:b0:b87:33f3:605b with SMTP id a640c23a62f3a-b8733f37289mr5217266b.27.1768229481033;
        Mon, 12 Jan 2026 06:51:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFMB0JxHgMWzT9jlMyCtL8Tarhm33xjovmcnmuqowqS/Fr0c7wyM0JTrOTtbi8ZoddZMgmNgg==
X-Received: by 2002:a17:907:7f90:b0:b87:33f3:605b with SMTP id a640c23a62f3a-b8733f37289mr5215566b.27.1768229480682;
        Mon, 12 Jan 2026 06:51:20 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a2338cbsm1914558166b.14.2026.01.12.06.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 06:51:20 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 12 Jan 2026 15:51:16 +0100
To: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	aalbersh@redhat.com, djwong@kernel.org
Cc: djwong@kernel.org, david@fromorbit.com, hch@lst.de
Subject: [PATCH v2 12/22] xfs: introduce XFS_FSVERITY_CONSTRUCTION inode flag
Message-ID: <bfcg5hug75qtvc2psw5yymfoudnz2uda3gg5dfzgnze46hwt6n@u67n3rdzzuo4>
References: <cover.1768229271.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1768229271.patch-series@thinky>

Add new flag meaning that merkle tree is being build on the inode.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_inode.h | 6 ++++++
 1 file changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index f149cb1eb5..9373bf146a 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -420,6 +420,12 @@
  */
 #define XFS_IREMAPPING		(1U << 15)
 
+/*
+ * fs-verity's Merkle tree is under construction. The file is read-only, the
+ * only writes happening is the ones with Merkle tree blocks.
+ */
+#define XFS_VERITY_CONSTRUCTION	(1U << 16)
+
 /* All inode state flags related to inode reclaim. */
 #define XFS_ALL_IRECLAIM_FLAGS	(XFS_IRECLAIMABLE | \
 				 XFS_IRECLAIM | \

-- 
- Andrey

