Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9A0326927
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764788932; cv=none; b=Oj+FP/F/TH+yMGmQoSEdsZbW3nc73XwEDbfxa2ibHnCiybGR921r5XfjKTjRZwRS7grAMh0HZepKAg9QX6WhfuiC89FsgZ801R7PibsfsGBTkVwicI7edwOZBvnlKkhCcdMw1UwDWCNIKgQ50BAZCF/THaA92dqf0QvVqgiWzMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764788932; c=relaxed/simple;
	bh=GPDgXKkJpi9rXNEWM7i9Vv+v1poCd4BYTROtMkE7CVs=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=djeG2dfx1eONTNP+SXoPiD7sfTnXg2gzB2nm6OGI5HBe4BngKuWfXqHb6jwM6TdGYW5+ftF8Sg8WaGpQXTzCqN8taSQmxT/8UFaZUrDo7W2Ipzfgf9Dh18p32Dy4sKqX2w3Yhpwk3JH5hainfSEu3NoDdYg5GU9jAWP/DRyCqsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WcbrL7l5; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=CfXWquyv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WcbrL7l5";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="CfXWquyv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764788929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=queUjvHSXB3jMj1qYR2PSxNWe6TDDCpr5jIvFlenfTE=;
	b=WcbrL7l5EU/qDOsUdpWnbSAwP/1anckvWKo7pOPD+jktcxluQw0HCAWBVbPeADy6GmsuNS
	cVnJFA/FzQkspOLVNgsGZrHGBqIUvfGKa4dOXR1X2RDJFTJ1dUJ+V9Iwqb9ZPbx5ELrGqP
	ZBzOnmfRjV9lMjxi01eiDntFrjyOUfQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-193-PyjRqZDKNAWtIXjpT2GW0w-1; Wed, 03 Dec 2025 14:08:48 -0500
X-MC-Unique: PyjRqZDKNAWtIXjpT2GW0w-1
X-Mimecast-MFC-AGG-ID: PyjRqZDKNAWtIXjpT2GW0w_1764788926
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47775585257so642095e9.1
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764788925; x=1765393725; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=queUjvHSXB3jMj1qYR2PSxNWe6TDDCpr5jIvFlenfTE=;
        b=CfXWquyv59t5PXmcYYf9pxcgarUkyO5oBqBGCsrJ+FXt+1XmJB3svsmAYquo0nblqC
         4HuLjFzr3l8kg/FR7mjP0in/A51Mnzlsom50+fe8xswwutBJtqlHCg4Jh7umNGW2Uz9M
         L9GcyjaMw+GUBXtR9MP235cXnzEBFhPS3GvdX1nmOFIMOiLsAXL82qQbH/tDXWOGEIUq
         Ur0Zw2PSts5LtPHvoyRmPTshjf+lyghbHS1e+wZIlscJFDy1Y+VKoFT/eWkSIKmT655m
         /B/bNTumpd5q68FJZM1uJQ8ZsmPUXk5luDxUYKc2poXDiaE4hk/vwvfqXmrd1JKvB1Vi
         BrTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764788925; x=1765393725;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=queUjvHSXB3jMj1qYR2PSxNWe6TDDCpr5jIvFlenfTE=;
        b=K+Z5Eq6fFyhWsEf4ixIPtMLF65oTBXxJLgL5JK3Hg6V4m/kSJkfqSdA59MSgDNNS/b
         1TOq0jMVaScTEiV3GbNYRGBEhhGlrvr86/Oz73pzLXZvXDFAGblmrY4B3UZ1/4QksBdK
         RhQDMnLrlQyv6qalJqN3j6nNQP5Aw8+RKBqrWb13SFkMNG/a5cElXFTbZlTEQbzK4x4P
         MKyGIhJyh2d++0ZkwlMxu5hXmlt7ag9dJ7CyMg/Y5upRfcVj/00KFZo5kg3hAZRvD1//
         HvjILOgH0U0sGf3VdP2k4IdVRLnRpScw7wXb0mj/AQzMpmgaM5REJb74FAXecqD7lrSQ
         emHA==
X-Gm-Message-State: AOJu0Yx1E/FKtiSVZcs0m+toPFCZN/uLi9Zu/CBXqrWOWmZXn4V4JTzx
	QUKZSvqwyB1xq8ntpBLfWGM9YtbMNJaiIIv6T4wrVlNvLAyRxy/cd+dLnTn0nuzJWoHnaaEnJXA
	cZxOsYhOIvZNZYLl46n0usGUpt487QyficeQsC43Gx137PLCHvuLf/KC6K5hPYwk99QpIj+3PIz
	AiDp50IzpcjNTitGP4tvqgxRHdIDkq7IUfXpQj45/A11ee
X-Gm-Gg: ASbGncs9PWudkgieU1c4N14iRj2ot0S5R7JccN64w9LQPHjIYDaAtSyC55gTj3MSLel
	YNxGyOXBXfPk/KU0kte/ox695LtaAK1S29ZQi+grNr6f9b3vze2Io5O3hdoNdvhJfnjhpxNcijw
	ssWdAULy4hYfg1cJpAt/Y0DbQipA2HV+xghCPQbUmtqjLZqZfcgamI/20YK8yIJjcAG2j6UBHW2
	kfUA3NYeJYNrvg0mpDMKx4q2DVG4YuXyFsMsyXO4lzXI6WmPV1ZD6rfvP5ziadYs5Bz4wL3L9h7
	jnRmfitzAEXVSk4+kJ0U0KfRNw3/DJhJUD4LFAsa2TuHFpsFkghlPbgVc5CTahmZ/qXn3TO9zM4
	=
X-Received: by 2002:a05:600c:3b13:b0:477:952d:fc11 with SMTP id 5b1f17b1804b1-4792af1b157mr45387405e9.16.1764788924912;
        Wed, 03 Dec 2025 11:08:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFhwqzxw/mfFtmHREZm2DszRhZt16xQRgTEYDBxS/NNAYEDNEXoY9U3qUJWwNInm8IwUkwV+A==
X-Received: by 2002:a05:600c:3b13:b0:477:952d:fc11 with SMTP id 5b1f17b1804b1-4792af1b157mr45386925e9.16.1764788924375;
        Wed, 03 Dec 2025 11:08:44 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792a79761bsm64993575e9.2.2025.12.03.11.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:08:44 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:08:43 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 17/33] xfs: remove the unused xfs_log_iovec_t typedef
Message-ID: <runxblzxntiobnpvneare2uywu722d3ey6yvorwxjzb2rs7yvb@qf5ff5hama4f>
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

Source kernel commit: 3e5bdfe48e1f159de7ca3b23a6afa6c10f2a9ad2

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_log_format.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 49c4a33166..a42a832117 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -194,12 +194,11 @@
 } xlog_in_core_2_t;
 
 /* not an on-disk structure, but needed by log recovery in userspace */
-typedef struct xfs_log_iovec {
+struct xfs_log_iovec {
 	void		*i_addr;	/* beginning address of region */
 	int		i_len;		/* length in bytes of region */
 	uint		i_type;		/* type of region */
-} xfs_log_iovec_t;
-
+};
 
 /*
  * Transaction Header definitions.

-- 
- Andrey

