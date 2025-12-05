Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B355D33C501
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764947032; cv=none; b=npQgpFKzm/4wjMplEPktURN3SeNhOIE6/47xr/5Rt63hJvdidZcLkJMbA5n95R4eu7z+rdJSRveCDuRZS3+7CdPMM0937T1cbEqii1F4mwl8dwBp0k5vr5nBjpVNPfOQlFZaTkHGkhmTbIm80XaOZm+as7+azAZjokorYQ/nq+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764947032; c=relaxed/simple;
	bh=XNvteBMgcE6xrUVzGm5dqXZ/wFTGDrTsUfF+Wu6Muvo=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C83CrDFEK5omMSyJ7I7D8qUmgUjQKqU4E0hGjHpTE79USQRQw1soyIw3JP0YFNzETpjATdkdU0mdaObz60cN0qzYCOhmYFHM58VRRKv6TiNsLMFQJeRei6Mj8kXZ1tzCCF2fg4CLFpqt5WvlMMNOl5opdIPOza73ieOS2YL4lbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LwP4beBO; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=IOEeiVyf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LwP4beBO";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="IOEeiVyf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764947027;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JJTEz5PCvjJ2xbRrWFvtltZR21DJ2tAKhsGrD0F8HT8=;
	b=LwP4beBO1tmrYNt7guP7jYkjzgl77/oTr1rpO+uZY5CVZyE5xi3twES4VSfoLskoAO8Ipi
	4Fq9oaJ4KjiPSK2x8Qa9yZhD7v6UNE8iw9xKG4PePbplYggKvb2ik/q5JRG7eZFbKZjrMS
	oQqPkK4EoalG0So6suhiTR5g9vFVd2c=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-_kCi2qMCM9-QrQCGmz_yvw-1; Fri, 05 Dec 2025 10:03:46 -0500
X-MC-Unique: _kCi2qMCM9-QrQCGmz_yvw-1
X-Mimecast-MFC-AGG-ID: _kCi2qMCM9-QrQCGmz_yvw_1764947024
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47910af0c8bso21672945e9.2
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:03:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764947024; x=1765551824; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JJTEz5PCvjJ2xbRrWFvtltZR21DJ2tAKhsGrD0F8HT8=;
        b=IOEeiVyfuvrVPdEpZYL05aPotAu3VfkXl2kGu5fu89Za7XM4osB18nXBRRbUHLZMWr
         lgaaq1f1Kvb1rGbUDApgiaOtuYTRqznNMdTEb6VxHTfvGTwjqu+b0ST1UdIDymmkxGfF
         W5gmaoNTC1YWOhV0bam5APXdF2VpEwkk9qTlP5HFTdY3I70Pwt1x02YA6M0pBlbLEbsC
         FB4xwu90M7tGJtbrnuVrAe3MlsfoGOO7twF7wwt3QoT1vOoaMMZNYdfiin38uXLa6pKV
         hukNfeoT3dEPbrVZR9ToUat3wOuoFDweOW8ityhH94bKdNEnQz1sJ/WM2n1BnL1bSR5e
         9A2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764947024; x=1765551824;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JJTEz5PCvjJ2xbRrWFvtltZR21DJ2tAKhsGrD0F8HT8=;
        b=Pifzd+uc70mSbaKXShIqOsv6XBhjI3y8lRbnO3wvWbLio1s/0/soeMrNMDC5JVadlO
         hd5t0wmvvJQ6PN0qXmdi4WYuu3w2FiBrcBFJoi87iPnvW11WwUuMjbK2wYxVAnJJfZ0F
         3RYNICPbP67nfj3rOpSxiP/CQzrfITEqXJXm57U5gXN7VzKuESwluOCC2d6lx79olAYW
         IZEV/mJAUQZ+/OT49k3RjDktA2qpEtLUxaOoBDJR2nk26NwvcmVf5z7xKwBq3Q2ZvIuo
         GMdYAklkPuOZ8hRJTvfsIUL0WaE41AMzju4qnRPjJJ5XrgzkAxo9bOSW0G6/McPRvJt5
         t3ag==
X-Gm-Message-State: AOJu0Yz3e3SvpQIA1G9U87Mc3caHJ/rShqT8rWRAlx8gifjHEOGzF80W
	VHtglha92dtwYz4Dj32nZ1kyyNWldo1ru+y+YKe+jrGz8m+BauIW9/NgGSxbvKAL1oQ460ds4DE
	MUfQzbLSHjddq49LcXryjt7P0L4E3aQC/KAaR+20Gn4lW6pwhPFRIYqgO6SrP7d2W1IC3drSyUm
	lh1anhovlWycEX17cBuVLkM8CWKdqSzfc9uRXhjFgFZeVt
X-Gm-Gg: ASbGncucyspf1YPHTP9PZMZmOZUfy0yaD5+NJpwbVJJ/VgCtW/KIhcYFdbcelHo6vag
	VODmz4SvF3cGYXg0X94BMeeV5+hpfJNIFx8PRIaFhkx8GTlClZRYerV07z7zCE4YapRGcomBHSX
	8ylfxep+P6EbEyux0dKU8bAtuQBdb3d3mjQc4yjK+Z1D/IEPe1IoeePxycjONYF963CdH5/RSHU
	7Yrvskh0fS4gDWi6u68H/YDBTp5lRtUoVYvcTtE9XfytHKt0Anl/b8TQhJKAcbFsNQqbHHhXWEz
	iq/gXRRE1BW+Ws2KOfwFMyaRPNHn1ctZ6FocsZvZbxEosOiDynL8xpq/0iGoU4xIKGSspXCQmFM
	=
X-Received: by 2002:a05:600c:4f81:b0:46e:3d41:6001 with SMTP id 5b1f17b1804b1-4792f3987c6mr75046335e9.34.1764947023993;
        Fri, 05 Dec 2025 07:03:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEgEE7XBsV8CsgVLDl4m3mGrO2jgOnFcle2SlU5hTFznsWLYFo/Gf9xwJFOi0b4hSN+fm+w+A==
X-Received: by 2002:a05:600c:4f81:b0:46e:3d41:6001 with SMTP id 5b1f17b1804b1-4792f3987c6mr75045585e9.34.1764947023371;
        Fri, 05 Dec 2025 07:03:43 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792b02e842sm60970445e9.1.2025.12.05.07.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:03:43 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:03:42 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 27/33] xfs: remove the unused xfs_qoff_logformat_t typedef
Message-ID: <qu5uviem4hvl57syu3tq5usqsdvcwm76ewdmd6hkjqfiufwi34@jzul5pcwqwpk>
References: <cover.1764946339.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1764946339.patch-series@thinky>

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: bf0013f59ccdb283083f0451f6edc50ff98e68c0

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_log_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index fff3a2aaee..49c4a33166 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -974,12 +974,12 @@
  * to the first and ensures that the first logitem is taken out of the AIL
  * only when the last one is securely committed.
  */
-typedef struct xfs_qoff_logformat {
+struct xfs_qoff_logformat {
 	unsigned short		qf_type;	/* quotaoff log item type */
 	unsigned short		qf_size;	/* size of this item */
 	unsigned int		qf_flags;	/* USR and/or GRP */
 	char			qf_pad[12];	/* padding for future */
-} xfs_qoff_logformat_t;
+};
 
 /*
  * Disk quotas status in m_qflags, and also sb_qflags. 16 bits.

-- 
- Andrey

