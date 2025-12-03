Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFEA32D7DB
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764788982; cv=none; b=gydVtwvUduw97dOOuNOGpRO3q00ExbonZweoIDpvvFXX13Un4PNJO9IrhVPi++J9Tp7nPQwdPf7LPi4cfk5UQQHWz9/utxeaAW0wl3EVs1MsvP8wq6jFuNf+B5lnqeY2wA8yL8UFowUfaJ9NmQinDXT1OKmi6S8qbrWhywoq+xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764788982; c=relaxed/simple;
	bh=Y3/Ez2xF2X7RvpEKSW825Mp3reyM+ed2oszdU9U7vOo=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QGTJVZnj83kYlNPNJX6Sm7/JF9efdI/NqIP6mw+z1TYMOqFOsdHrNqFk6I96ieR35xEa609mRyYySkVOQUa4P9CJ8VlECAPZb5VQd6nwq47QYgAFnhjCmDaMsGOsfqc4dlVBiJ/djEI2OMNiTQx3yr47HOh10uZRgL3RyyIEMdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZvPMaJgF; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=inba9v0o; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZvPMaJgF";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="inba9v0o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764788979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cob4u7mtS8QUgMEpOn/0Juck29I7WqGCT0WHW0VRKsA=;
	b=ZvPMaJgF84ruCnvlwJSfsxys/DTBpAR/73Rs2n2/x6e4FwrQkIf1+dfkAQJwdhpVouFO3D
	vcF9N9DoP0EXPVaIJhCTBCvGPHkpEo7xlthgleNWYeWcMOqyuMr8iWhOzdVz/bBXb5lABy
	rXag/rii+B5m/J1lr5lvINZ6reBFbaM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-qN9vswWUPom09cfkmCNKQw-1; Wed, 03 Dec 2025 14:09:37 -0500
X-MC-Unique: qN9vswWUPom09cfkmCNKQw-1
X-Mimecast-MFC-AGG-ID: qN9vswWUPom09cfkmCNKQw_1764788976
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-477a0ddd1d4so555745e9.0
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764788976; x=1765393776; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cob4u7mtS8QUgMEpOn/0Juck29I7WqGCT0WHW0VRKsA=;
        b=inba9v0ovigvEPMyGXZ5Isk6/8FDF3ubiSWJ6Oeh/9sLjaTRXo/mmXJXB+hPsmFhCB
         0ZF2nxmBzYRu1lwxX+iqPx/104T8ZEuPqHYFMhQs2KHrDkzmAwOEzEUIKnhZmgs7TAAt
         vmP41GzRfLrEMxi8aUk1/ZAaAihqhxKdBQrAP1hsrxXU9dY0DghBNfzXdH2zMADGMOss
         OK0rqZmlm4P48+UGTMj9gGFqJKsm2W20g1MXXq/GcCopW1hpN8+MAc6fw9IhSvFeS0Tq
         qAC+okBGI1awea2oxcS5Fy8RNnHRWFmguTyp1TFmsU73GVbmIBOCOf6Qf6RTzYhc4yrQ
         afHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764788976; x=1765393776;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cob4u7mtS8QUgMEpOn/0Juck29I7WqGCT0WHW0VRKsA=;
        b=dJlydXZnYhXlLE5Eglxxc2VUOl4dtLM82kWJI/VzRSjkcCIG+gzzBMv24eGdtUjmeJ
         8oMaY6VO1uAdOZLQwZJhUEFECCdelW2yEbo/wbE5HS04FdtAJaS2+nZBX9NxcaEh0KLI
         0HJvAF6ucyNAuw8X1VzBk13a7fVnQ7pswyfW+J6Y5LpmNbxHARdxlKVsVu9yIJEuX9yl
         9cGfU5qKANTtka584Q2SwtKGAKDuBND8nahwwePVonWgY7/jxvNvc4nPgs36ndBIVUoC
         1tFNvIzNxy3PLkEPRm7okvMTX+eN+MaHGHCtV37R/R3ptunhARFly3qARRKMiELq6WI9
         AZWw==
X-Gm-Message-State: AOJu0YzOnGymmKl5bXnmnP9bwrmel/v1ZzHfeEn5SMvA9JqxqQ7OPoYl
	neeQ3dRM79sFkImHI+0MygFCnbqsRUFBwCWvAj/GNQew7GPu9Bw0UIDV46g4IVRt32vAFbWZbL/
	QeBQnYxrGrCQ4vhLGrbfYwZcjvARMLbKMwUy6jRP3MC6BLBq2LevevuPuTbR3slPs84KDGE0swa
	Os5jfmJpRNMGL2s0HMf5C9XxHyyOPQASNKP866160YI3gS
X-Gm-Gg: ASbGncsy8BBJmcZe3D9NHJUTSp2amTKnLsjBpae+YKqBHXZTkNw7OBbfBrfbQC4Siz7
	kVSrU6rNFuEwMq1ABMCIdcEccuZpK8RiuUHgNw/0wgoIjVMUtPQH1v5Vm6VOQZdYFru4A5VqPeL
	JHu/2RFSKKkqLQiBUqgB6Gv5IluzA6Qqp0BOtwEK09kCPKQz9kJXVMpKXbLwlRAQEOYn16HDC4A
	glr1blIbh4OdEFHbiPZ7dFXIJzbh7E9b+KaPMCzibo3hE00np5wNiC5fUYsrqgiRZEGdPEoovrb
	JWW/eKVGdnU54C0HWf/U4XY/OE2lEr339AuIYb1INFrYTcFNKCvOKnJrprNhIVbvgZCJFpNXHL8
	=
X-Received: by 2002:a05:600c:c87:b0:477:9b4a:a82 with SMTP id 5b1f17b1804b1-4792af48eb2mr38168055e9.35.1764788976218;
        Wed, 03 Dec 2025 11:09:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGzl/CgbquP3W0yBkxqkDjaq45cRddWEz7whT+3C5wgy86nOYWwAvscFzV0BgvRD7sEsjCY8g==
X-Received: by 2002:a05:600c:c87:b0:477:9b4a:a82 with SMTP id 5b1f17b1804b1-4792af48eb2mr38167665e9.35.1764788975741;
        Wed, 03 Dec 2025 11:09:35 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792a7a31ecsm60509495e9.7.2025.12.03.11.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:09:35 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:09:34 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 22/33] xfs: prevent gc from picking the same zone twice
Message-ID: <vjyqg7u2gbarprz6usysans6apdoqmlqtafb2vfurib4uhfqp4@tvey7tdzlxr3>
References: <cover.1764788517.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1764788517.patch-series@thinky>

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 83bac569c762651ac6dff9a86f54ecc13d911f7d

When we are picking a zone for gc it might already be in the pipeline
which can lead to us moving the same data twice resulting in in write
amplification and a very unfortunate case where we keep on garbage
collecting the zone we just filled with migrated data stopping all
forward progress.

Fix this by introducing a count of on-going GC operations on a zone, and
skip any zone with ongoing GC when picking a new victim.

Fixes: 080d01c41 ("xfs: implement zoned garbage collection")
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Co-developed-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Tested-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_rtgroup.h | 6 ++++++
 1 file changed, 6 insertions(+), 0 deletions(-)

diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index d36a6ae0ab..d4fcf591e6 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -50,6 +50,12 @@
 		uint8_t			*rtg_rsum_cache;
 		struct xfs_open_zone	*rtg_open_zone;
 	};
+
+	/*
+	 * Count of outstanding GC operations for zoned XFS.  Any RTG with a
+	 * non-zero rtg_gccount will not be picked as new GC victim.
+	 */
+	atomic_t		rtg_gccount;
 };
 
 /*

-- 
- Andrey

