Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BDB22616E
	for <linux-xfs@vger.kernel.org>; Mon, 17 Feb 2025 15:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739807451; cv=none; b=nzcz3W5aYR0lwVlc0ZJsX068hk1AGW3EcAhX8eBBeD+M8azUK3rZ+mCbHyXXOifNYMPExVonSQioykdlKYzjosFuhht/W6KywHeMdcWN9B9GXoUw+bsJGUFdLbDyfqS/jdqOYLF3HuKyMvFeWCTb42XX5/mgAoyMZt6drE+QfMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739807451; c=relaxed/simple;
	bh=O14YQwm4nSZumD4HVM9f32WGoZyv1UIIEYAPz/IzZIo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BoaPpLXMqHNLkoZww77rVHdXLqQLv73aeouSN+eLfXneL0CuZF1zLoKZLnrNHKASARHojXp3qm/8WiV3v7+yRmYMl/w4/DFky1A8bRMevOhOdMiNpA/VdCHKce9vNqGrRasx7RWp1VyJbn8nn536a0P+0UKM62PAuM9IeZfx3M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NfqHgU/6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NfqHgU/6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739807448;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=l0lSogpyFbhkcubnF6qWP2DnFZt+hCkqTYXeDzSG7M4=;
	b=NfqHgU/6UDoU1COdu1DzTHB4qriRdGoIOKkFMz9gdkTJB4+tnKvmXog+4UfD32XTPPpIA/
	2mzZBbWdY/WeESj69S5y+SSZQ89Q4cUvhyOgKwmnfa+KJwJiYS/1XLM3fvWn1f+0jd4JvU
	d33hgkVMXSOfotcZWxbPttYv1bS9/s4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-0FwMQ6c8MdaIinJu025fPw-1; Mon, 17 Feb 2025 10:50:46 -0500
X-MC-Unique: 0FwMQ6c8MdaIinJu025fPw-1
X-Mimecast-MFC-AGG-ID: 0FwMQ6c8MdaIinJu025fPw_1739807446
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-438da39bb69so41108795e9.0
        for <linux-xfs@vger.kernel.org>; Mon, 17 Feb 2025 07:50:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739807445; x=1740412245;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l0lSogpyFbhkcubnF6qWP2DnFZt+hCkqTYXeDzSG7M4=;
        b=DJEeOrIq4tfaC0VBR2dvWPlshimcrio1Efkwr5q7Iy2v6OsWfq8tC14DZVoLIf4pKT
         NuFOiN4Bw51mwBuWOd7bFIc4feYonaNMnJOBgOJteDFfsfHtZTOVDnspbaPTmr/Rvnr3
         NqPcXlU3KjTKdKikT+a35A+rOHzljm3V47bBl6AW+ENhmW9AedARQCnpXy11eVoaiOFd
         QuAYOciDhdCp37igykjW2nS0+4ooWihjUT3uCA7L4CEKXzVubwAVGHrvStdhx4PKVonP
         0Oc6uSmUMRZhBQ4Ho7HAiq4a+AL0EwTVakWgARmknJLW2pYRkG6/9CkVyY4gxEqFVyPI
         ZqXQ==
X-Gm-Message-State: AOJu0YwbUOIOvCJYJjTm5yUBaZjK/t2BHR5DoowTFCo7mwb4gsb7YFS4
	Lo7kpFMkJKAxN7QiHjaxhMx1gJG/2R7W3qqyewMDP/Ky52y7HBgVyVXwXYDwOsVX5jKWltvmzxc
	ZXrVt0+DpksLHsKpk2j4KomMvg0OvbE9TEKm8/rY03wsynIKtK56/8Ga7D16W9Bm+Ig==
X-Gm-Gg: ASbGncuATpPcPgk6yRxq72Nf6iLZ3KL3m1QT14TPdtGfYqHNNw8GqcXMOGEV7wWSX1Y
	4/lxKnsWEqy7A1lq0y8kLhvTVmH7pIFmabM2D9Qmni7Zl7yQdobTEqxRPjrYXscopbpz5Qrc+78
	/7QXaCyXEfE+lKUWjRQaATd+OcNWfWsWflGlMfpBnz292/Atr0K7PKYEVEPYwD0p+U38geuirjv
	dk1eAthMrBuomMvjVKof/whC1pnM+6qfZCsE4ZH53DzC5ElRrvUYA1BXCgim90+vzUihQANPczp
	qkw7I3fPJHeY5rd2UQCvWZngOu5EFwrfvCLREf9LDQ==
X-Received: by 2002:a05:600c:1c26:b0:439:6332:2780 with SMTP id 5b1f17b1804b1-4396e71af3emr87199935e9.27.1739807445173;
        Mon, 17 Feb 2025 07:50:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEA0ejZFcE2Dc29Pvma88Ng5NfLTxOHPTKJvc3w2RwXuBZmyKkFotMXHtBE48bFAt9Lu2lEYA==
X-Received: by 2002:a05:600c:1c26:b0:439:6332:2780 with SMTP id 5b1f17b1804b1-4396e71af3emr87199735e9.27.1739807444811;
        Mon, 17 Feb 2025 07:50:44 -0800 (PST)
Received: from fedora.redhat.com (gw20-pha-stl-mmo-2.avonet.cz. [131.117.213.219])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4396b0aa4e9sm86419505e9.16.2025.02.17.07.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2025 07:50:44 -0800 (PST)
From: Pavel Reichl <preichl@redhat.com>
To: aalbersh@redhat.com
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfsprogs: Fix mismatched return type of filesize()
Date: Mon, 17 Feb 2025 16:50:43 +0100
Message-ID: <20250217155043.78452-1-preichl@redhat.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function filesize() was declared with a return type of 'long' but
defined with 'off_t'. This mismatch caused build issues due to type
incompatibility.

This commit updates the declaration to match the definition, ensuring
consistency and preventing potential compilation errors.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 mkfs/proto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/proto.c b/mkfs/proto.c
index 6dd3a200..981f5b11 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -20,7 +20,7 @@ static struct xfs_trans * getres(struct xfs_mount *mp, uint blocks);
 static void rsvfile(xfs_mount_t *mp, xfs_inode_t *ip, long long len);
 static int newregfile(char **pp, char **fname);
 static void rtinit(xfs_mount_t *mp);
-static long filesize(int fd);
+static off_t filesize(int fd);
 static int slashes_are_spaces;
 
 /*
-- 
2.48.1

