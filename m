Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8993E327C0E
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764788850; cv=none; b=D7Z6Z+0wFz3abUd5674MA7Y5RAS5GwlOHocYiWdBjGgxr119//VehiftblQDBdf/+hpjxdsWbQ4C1dgD4KVcYcOULpUFFWSIFz4RgzfqPpIsfgijZn6ltsVRnKdvKSUohsW8TOL8PTCuL4+MaQCDLbhzXnjJDltXhaaTz6BNp6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764788850; c=relaxed/simple;
	bh=I1T0asy8kQiG60Hdwfx/yhyep1TWkfor7joWKgLHjzs=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mQ+6Cjvoulj2QjJv55kuQxMItWkNF8D6of/aK+m4YPKZv/Nvix6d6e6I+130vFkV7GdezLAREXr5EFCbz8CSFBbmqKXi+PvnhY2v12WJCqsdtF0CuSpdZTkEk6E/WL3EOxPfx362c5A8MwNfr6yXkw45rDYixdET+l/GKZEaTWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EIPgjgYS; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JGBrd0iB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EIPgjgYS";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JGBrd0iB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764788846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rMcvRF9TvDiPuStT1jY7vP1B0fRVjJ49mFqe50dOGRM=;
	b=EIPgjgYSY6D5DsWsAnkNE7z0TxGua8Dmv1mHTcuuHdLACfwwTqXDGKLhKHZ0ho6zP0EZrb
	pE4pCsiTCF3w67u0AVkm/0xyRzvLWc7r3oVZ+zYCgypTSSOqfM/zVCd6rTa6Rtlw0qLmRD
	0yTjBbXLrKDvD5iy1DDNRdyVoMoufuM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-p50RcoY_PSC7BWj9hquUBw-1; Wed, 03 Dec 2025 14:07:23 -0500
X-MC-Unique: p50RcoY_PSC7BWj9hquUBw-1
X-Mimecast-MFC-AGG-ID: p50RcoY_PSC7BWj9hquUBw_1764788843
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4775d8428e8so677175e9.0
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764788842; x=1765393642; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rMcvRF9TvDiPuStT1jY7vP1B0fRVjJ49mFqe50dOGRM=;
        b=JGBrd0iBstiZW5IPkcITmYLYgfPofdC7AE6U3RXzXaIFbQmniHVEVSSt2pNalQvuwP
         V4PI5eoEmGSw9WfGarXRicW3ohGqjkAThGHXKNFneTfwUobbar1/ZTyD7khs/9TMg7zk
         QUsjSmkP95dsTKB82SxtOSmlfqeKLSioRfJ3SKVqFdynqqICq/AUwykxAIwjv2XUYGNk
         CD+PDGLqqtgKEaQpzQE0nL0l9FGsYyIt8OZEqqHT+EbMr+VcVuAQ0XqJcG3foz1sdfNg
         ul0ETZYzP2H2Bbvxsz6mTHt0jZUDm4Psv+9zE+0CJsAHKN6W1TLbBdC5AoA+PApO5kX+
         N/tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764788842; x=1765393642;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rMcvRF9TvDiPuStT1jY7vP1B0fRVjJ49mFqe50dOGRM=;
        b=NSGfWzKOErkK7HOF3nYtSUmdh93vtGOr5zdg9Um3KDQO+2hN0nqxl49tjueWrtTHrp
         IBrvudnm7ub74LvJlHoLbpnlfWZB8tIsxblcLcejskVwK8/GaC/+3j7NQKACP3j6Qtgx
         kJUyS3Zog3Hexq7W6xcDxb4WX2ANfR9rSyZzVVRB7lvqQqHlom4FCQO23Yw/rl4BmOaq
         HxE1G1OgGYVRm5d7hDACV2+wb98M3DYFeubkagAGwh56sOoR0Ng9ekOD/VhIEG9naGtL
         hH2Z/gL52nL+MadFXenYSut2A/XkF/g4vSHI4z8dVxnzaf7Q86HEAn60rHXOswnPJIE+
         w0Ug==
X-Gm-Message-State: AOJu0YyPBSFOYMnEFYFdD+pDphZQmAvYNFjCJCo+JooFvcKyqi3rfvzZ
	aNR9wQEKVcVI12p4FsP5igVqU9YTk713YRcF3yLp0GscebAh1aKNiI5AfOmfsECeFycSdiBh9FX
	u1rulEtDrwfzuaVbbP8SXHL+vcfr1/ys0Pwhe0ETeRjhu9g0tA878Of7s0y++YoX9CEbJ91X4ct
	1z7mByRbKi4qzFnUEZ5SMbSJJ7kI5QilCXQzjFXPpDil5j
X-Gm-Gg: ASbGncuzfcWtP5WynqALZzXuPHwGjLqFIpcWRhImi3k7Xqg/in8SRY//1Hj56jOv2JP
	dXcIFOPnqZ5MLoA0vUJFh/2UEhzyWjn+fWeSgF70xIw+t/4yTNlbHpietWot4GdjzjQbSiLZX0G
	nRTrxR1ZSrg0V3Q3WNtzPzGeptO88xngzm+7PcVVfXpNTO8kS+ecfyLcIY+VmZT/4FjVvmBMRXY
	CvG97RJELZZZAfySpinQXS4IxzhChCw0oJ2OWO6ebXwntCiNwhs7nI7LmLz6YnoLGoLAgiizcFY
	tMzf+ZKj0esCRTv91JQxGGzjoK8rqd2ViKDshawRdT4WtmKwYCV1KEhVYJVmqrioyoinLWhyjL8
	=
X-Received: by 2002:a05:600c:4f54:b0:477:6d96:b3ca with SMTP id 5b1f17b1804b1-4792aedf781mr34713865e9.5.1764788842211;
        Wed, 03 Dec 2025 11:07:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEMSqu0t2W1YLoOlD62wnHWThW8kgDX7ALqhUrFqSHS3xgrBmmHDAP36zm9fKvnPGsfEEVbLw==
X-Received: by 2002:a05:600c:4f54:b0:477:6d96:b3ca with SMTP id 5b1f17b1804b1-4792aedf781mr34713485e9.5.1764788841689;
        Wed, 03 Dec 2025 11:07:21 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1caa5d02sm41601175f8f.36.2025.12.03.11.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:07:21 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:07:20 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 8/33] xfs: remove the xfs_efi_log_format_t typedef
Message-ID: <sjdpcpt3fd4a6e5z7pawx6hz5ifgeyf42ewsfg2ut6bupodbtw@kbpmof6g5jwn>
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

Source kernel commit: 655d9ec7bd9e38735ae36dbc635a9161a046f7b9

There are almost no users of the typedef left, kill it and switch the
remaining users to use the underlying struct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_log_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 2b270912e5..81c84c8a66 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -633,13 +633,13 @@
  * log.  The efi_extents field is a variable size array whose
  * size is given by efi_nextents.
  */
-typedef struct xfs_efi_log_format {
+struct xfs_efi_log_format {
 	uint16_t		efi_type;	/* efi log item type */
 	uint16_t		efi_size;	/* size of this item */
 	uint32_t		efi_nextents;	/* # extents to free */
 	uint64_t		efi_id;		/* efi identifier */
 	struct xfs_extent	efi_extents[];	/* array of extents to free */
-} xfs_efi_log_format_t;
+};
 
 static inline size_t
 xfs_efi_log_format_sizeof(

-- 
- Andrey

