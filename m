Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815C32DC321
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 14:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229461; cv=none; b=J9PBcrTt1Of7WqoQZUj8pYwTPsmUyFCgRRPh27Geos4Vvr/bkviNr6qpGWRjNMhemcCkgkA9HgLf39I9LUchlN/fuJFOKRnvxBVuef+TjM/YNckfRTw4UAA1XnrWdziVBC7FqS/aDCCHj8K6rL7u7qjB06hAOOgJpvHpFJ0mV50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229461; c=relaxed/simple;
	bh=yWqqnqyEHVCP+GfyyAPeDyvO4XQXeMSaifR3DHZygFE=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mYropoQ6jZzxQ4t/0OaySziPPTM94hjGTEzWAU5MgPViO4mcXrc/Utgk34DRzmxPNdB4/AKBvx1nZwmC+cGtZmGUd4kox7cjZPBgLIl6aXdmIv1qpwEUIvmfgUjvbOR6B4qpmENhpDN3BLAZBfygP20vl0vz88QrA214zeNqnMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UuFizG2l; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gjJz467o; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UuFizG2l";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gjJz467o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768229459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/8i7Y45C1rUzQ3Pho8pbs3bPeHebh5bCEthructqQBM=;
	b=UuFizG2liKAwtcoRKFJcQmf9YljXtGliMPwzgFH1XDJQmq7AmnA0MOHRavd8u0+BL13EvW
	3ABfRqDl4MDVsuupYG6yTZRBuYouGrIVxHjX4OOCjPH8ceWcZMacgJ7y8MFXH8dQpwH1GV
	x6pSudu6Xu1q7CZo1ZE0k0mnqgQRKco=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-63-rEGoJz50P5OqUkjAGwhFIA-1; Mon, 12 Jan 2026 09:50:58 -0500
X-MC-Unique: rEGoJz50P5OqUkjAGwhFIA-1
X-Mimecast-MFC-AGG-ID: rEGoJz50P5OqUkjAGwhFIA_1768229457
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b7ff8a27466so777011866b.3
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 06:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768229457; x=1768834257; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/8i7Y45C1rUzQ3Pho8pbs3bPeHebh5bCEthructqQBM=;
        b=gjJz467o2d8UVIDzTO8S5XPRDsfVma3/btziW/pPyfeyg0nhLC9iHp72zl+qhfteUB
         s45oqKDAyLRCusH5EmufM/XT1OACypMgt9ID4OhmIdV7b+Fk2zokVPKmAJvBMzRnokK+
         dG+GlayberxQdKP6lAhmPaMSEyCslr3huVgCQXKxc05Y/PAG0M1PLvBs16oKQmbICwrM
         e1esg9d+YGRtnm22osmVTHPA82HEV2CuZKcaNYwwualhm5At0+2BrrqnC2TgicDRB0tP
         5uKrnYOqkmptqTd+b/0OO7MZTQ5RGMTjsi1BbhutrriJVMAiRaynxhuflp2CC7hPhTEn
         NXKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768229457; x=1768834257;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/8i7Y45C1rUzQ3Pho8pbs3bPeHebh5bCEthructqQBM=;
        b=GTjDkDFpJPYvGKCOrDvKdJtd3YF1BaVSfhUDC4OiShLdVT7vCPndPtmkPoMQXc62OB
         Qebx72bVsgSbeQl/PizAMd1EoYLhuUL666rwC+Q4EMdN05DdmfLjk2lTg9kz+Op2J6Yk
         ZLegmnlKIZxYqsphXgwUc3NHsW/PO1X0CytiZx0gMWwtEnppGsHzifNF24PVPfKUclYx
         C3KLPeb6UTKwg8dKslSYWXJ/YTQnc6i4NBML81bbQXOs7vh/kvBNkqI7e/gvH9HsxeMI
         9liikP56oEyoUbiSEIgwcPT+ZnXbV7jciSvOZAmW1UHgiv8arW7uwEQ4cK9RAUCerdHw
         y2Lg==
X-Forwarded-Encrypted: i=1; AJvYcCXK1jWMzIe/smzb3aZSl4lVlUd7A88Z64o4YQ07vQ/anLSYg52Ch/HKcefTBvHSw98IsE04H1d/I4M=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcYXT6dBT5YFHimRsyJIRvABizhpo8OHNYKffsyO9hSsp8oAXr
	8TN9cwgI8rqyVFNNCUQVAjNaCgcxBoCmpYD/38ICULdxvlhgRQGvUM42Fa2r44eUgRbZayy0fll
	bDyn4UR5J0P3sdM1/tP+/MLYu/0muv/9sXZXIzD/Vkh9FNFWrtpGuAZS2jpxZ
X-Gm-Gg: AY/fxX7a+lpe2k9FLD4tBSEKE+GkOCwSZu/ZU5yPyNEdYRChrZYzhozKWkWyZpYKzsj
	ylw/tB5GuUFTTdoxer6jrwsOIjokv+lq34plW1DFJeZ4r6B6RpXlNbIr94DBXFGf+Ek6sATzIkH
	jv0IG1F2g2M/wIRPsEVp70+fa6cKBwx8UYjvt7yQDnSePL6r8JyfD/YKqlZ4rEFxkdogAmIkgRK
	3QzjjxnrNjpMeVrC5yKF9sh/71PS1tAdvpk9F3IJKp46WwXZvHhHGv7OCLUgW4WY/uF3AVzVdjo
	Qkn4uqH35TlDiaB7WLxr2MUzfFTipVse0tSOVHk4FYoAFLqv8YgIblLSrHCMFyVvl3qXgRgBVRM
	=
X-Received: by 2002:a17:907:d11:b0:b87:19ac:98ce with SMTP id a640c23a62f3a-b8719ac9ba6mr340669966b.4.1768229457178;
        Mon, 12 Jan 2026 06:50:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGodEgWaGnO/BinsgSPFbBzgONiFVWuueEar/8j4zEvL7xMhaUYrOMxjKwwTSCT4wC7a0hARQ==
X-Received: by 2002:a17:907:d11:b0:b87:19ac:98ce with SMTP id a640c23a62f3a-b8719ac9ba6mr340667066b.4.1768229456659;
        Mon, 12 Jan 2026 06:50:56 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8715d0e99asm388258666b.51.2026.01.12.06.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 06:50:56 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 12 Jan 2026 15:50:55 +0100
To: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	aalbersh@redhat.com, djwong@kernel.org
Cc: djwong@kernel.org, david@fromorbit.com, hch@lst.de
Subject: [PATCH v2 9/22] xfs: don't allow to enable DAX on fs-verity sealed
 inode
Message-ID: <osfyixw77gnssemtxreoziyumsdstic4xgm6k6c5hp7v2nj4x6@ypfnx6seiaps>
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

fs-verity doesn't support DAX. Forbid filesystem to enable DAX on
inodes which already have fs-verity enabled. The opposite is checked
when fs-verity is enabled, it won't be enabled if DAX is.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: fix typo in subject]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iops.c | 2 ++
 1 file changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 6b8e4e87ab..44c6161137 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1366,6 +1366,8 @@
 		return false;
 	if (!xfs_inode_supports_dax(ip))
 		return false;
+	if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
+		return false;
 	if (xfs_has_dax_always(ip->i_mount))
 		return true;
 	if (ip->i_diflags2 & XFS_DIFLAG2_DAX)

-- 
- Andrey

