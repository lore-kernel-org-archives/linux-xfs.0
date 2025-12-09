Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0502F9C23
	for <linux-xfs@vger.kernel.org>; Tue,  9 Dec 2025 22:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765321142; cv=none; b=MsLsxl+hNFfdSeSQ5HjXe+Oz361NjDXrGXW9ghcgH1K4o0y5rry20mk1VOJ6i8niiugsKArO2BUnv6oXJME6+EdZRXjcN4KGd2o2wPixXoCLm+DMLlOeBPC0LqBUaeRoEGpXDRKJPhpfYtFFqgcaAo3R+xlh/hs2rKe0Ro9tLiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765321142; c=relaxed/simple;
	bh=NA8v0gjJtmqM3C6fFWPhDshd92iqi899ai6XRjno/D4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bCu3a6v8N7j71RoJoRxKJy+PhQWQ1YriE13HluO/UYeBiNO4MJ7Z7yzucXvmDTn/Vgsb69w7xH7IjPaAn3JroajwwnOK15dH5p+4yUZm4af63nLNHkXtN3XajABP5vg3Lqz8v7PJ2aFLYsojT0tSkGTTDa0n+8KR2kUjESj46pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SI7c8lQw; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=LPfD77oR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SI7c8lQw";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="LPfD77oR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765321140;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TPxX+/zwrplRIf4WX3YEboNmzFrtUMX6/d5iPHGGOo4=;
	b=SI7c8lQwP34NQydyjOfEmpEj1BA4UlhtpfJpKcV3xtcKcczL3/dYuV7xhb3tYoAkwOJnEa
	K1yA4YiYD3FStTqQkJIa4Qx9pXMkIS8NhLQ5vUZ+MJsL2nJadBlPcQCvEoYxPwLPXOWxt7
	6cxVeNz93DVleIkBRB+hHye/vVxS4ak=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-103-ddVOenf-N9KIZsNrd3SsUw-1; Tue, 09 Dec 2025 17:58:58 -0500
X-MC-Unique: ddVOenf-N9KIZsNrd3SsUw-1
X-Mimecast-MFC-AGG-ID: ddVOenf-N9KIZsNrd3SsUw_1765321138
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47918084ac1so54441155e9.2
        for <linux-xfs@vger.kernel.org>; Tue, 09 Dec 2025 14:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765321136; x=1765925936; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TPxX+/zwrplRIf4WX3YEboNmzFrtUMX6/d5iPHGGOo4=;
        b=LPfD77oRpQV5JvUtxNRft0Xymz2EuitJ4wWmSHE4LuBNui6oAPN8t4oPJORkAefKWs
         EqG9ZtJ4KwzxAPyDqpWvGeehUNYUJ+n2SrqH86whnDk0GlGB3qbqxQ96uAffBj/mCEDd
         +lsq4AtIJXaMuDBf8/NDi/0l6zykt4RsHYIZXIaF7wgaMFYk58+CPIxBoeBPPeGQ74Ov
         BH5i8D0c1ZQOIlJrU5tVu9ntR5u6ck2icGDwF+WsE0MR/hw9DBLdiEWbAgwCbckf/Mgh
         nCUnk3VrD3D7WuwyZkAAk9kGxncLKjjAyJB786IcmjvgYgtWLpKJSuMyZ1ycOwIGRJ4b
         Sd8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765321136; x=1765925936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TPxX+/zwrplRIf4WX3YEboNmzFrtUMX6/d5iPHGGOo4=;
        b=J7d3WeIiNLliIaIz+JgFUs8o4G7CyAfY5SLm9SXxDBSWiB2cuJdLNEeMpyBsGw47C9
         o6A58Bmx6X7T+bb6OPhuev/2/yKS/OtfwVzgcS5YS85/vZUZuU4PtcZQ9LjNnaAcDmTR
         HJ5+1tA/DmRIxOPmWnBa6pUWH1986FRupPzMss4gLjQ3WqDStVnkZ62ovRJsTwZ1SUzC
         wI848uhYgyKJKg8+MYkS5wpfk1fFH7madYkt7nZIzASpANpx+rwY42wI/0SJtaBDwTWn
         SYnuWycA9+aV+JOJDv8L+SMmpEohfhHSmviZBj7imiz3ryJ2uaJZ+uL200kUVLREEojC
         pYpA==
X-Gm-Message-State: AOJu0YwuHp6n2x/WS4Z2idGOnmcL/x5w4cvZ2g23Omz1q5G0sjo1R5YB
	PMtFrIC+PJ00r9DYeDxxcyGh5QK5IXAOSWMyQgxgwJB4eKhbZKrVkzb+XJ31pyqen0zjuoEBnH1
	fVYi8WbPnnb7vp0rwtWeF83qYTcrzPu1Wj4BSk8Em6su7t7gJCorVAult/djC/fRzB22vvBnc1o
	+EG264zYEC4vxOiedwsG/fQkGxMEi31cm1/9U55QMNL9dZ
X-Gm-Gg: ASbGncs629rDNEwzGDSRAdKLQorUymPlrhqCGnXq48759udCADm2ZjROwRzeX7hNezz
	iuZh/5WtPt9swRjEU/L33q54mgtfH8HjMmGmHMT5gNTZmVVNKJApb2WWaVSUhbjuHI3mdM1n36U
	8FQTXktSyweI5lQBI75Y74t+EZ9Jyjiq7Xcb9GidXUwO5QQrs48xe/ZVB8J0cC8ZoV8LQBMaLq/
	pfe8RGOl1ch7iQnTnsDIY156rUxZa+2cLLcHBIxUg9ekVuHr+65D9/kXhL+clTzTjxXdGdP8rZb
	7RtO4c9oWeWja98Ey2vMrkrOdI+Le1CAWkb0NJScHusib8BwHmVqvOhfdTBhGm37WA7eK5brv7i
	nLzZHtjKatOM2Vbe29n8VsBdFJgFCQKOvd8I6sALLlFHPkzQ=
X-Received: by 2002:a05:600c:6c0d:b0:477:aed0:f403 with SMTP id 5b1f17b1804b1-47a83cc5512mr1363805e9.8.1765321135736;
        Tue, 09 Dec 2025 14:58:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHgkV4thk2V0ilx7T9KriixA01EJ3N5ZGuruKnMSi71b7EZwz9mOgjftEGtJyKBDlVJssGdZw==
X-Received: by 2002:a05:600c:6c0d:b0:477:aed0:f403 with SMTP id 5b1f17b1804b1-47a83cc5512mr1363705e9.8.1765321135305;
        Tue, 09 Dec 2025 14:58:55 -0800 (PST)
Received: from fedora.redhat.com (gw20-pha-stl-mmo-2.avonet.cz. [131.117.213.219])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d353f8bsm34575522f8f.43.2025.12.09.14.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 14:58:54 -0800 (PST)
From: Pavel Reichl <preichl@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	chandanbabu@kernel.org,
	aalbersh@redhat.com
Subject: [PATCH v2 1/1] mdrestore: fix restore_v2() superblock length check
Date: Tue,  9 Dec 2025 23:58:52 +0100
Message-ID: <20251209225852.1536714-2-preichl@redhat.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251209225852.1536714-1-preichl@redhat.com>
References: <20251209225852.1536714-1-preichl@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On big-endian architectures (e.g. s390x), restoring a filesystem from a
v2 metadump fails with "Invalid superblock disk address/length". This is
caused by restore_v2() treating a superblock extent length of 1 as an
error, even though a length of 1 is expected because the superblock fits
within a 512-byte sector.

On little-endian systems, the same raw extent length bytes that represent
a value of 1 on big-endian are misinterpreted as 16777216 due to byte
ordering, so the faulty check never triggers there and the bug is hidden.

Fix the issue by using an endian-correct comparison of xme_len so that
the superblock extent length is validated properly and consistently on
all architectures.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 mdrestore/xfs_mdrestore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index f10c4bef..b6e8a619 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -437,7 +437,7 @@ restore_v2(
 	if (fread(&xme, sizeof(xme), 1, md_fp) != 1)
 		fatal("error reading from metadump file\n");
 
-	if (xme.xme_addr != 0 || xme.xme_len == 1 ||
+	if (xme.xme_addr != 0 || be32_to_cpu(xme.xme_len) != 1 ||
 	    (be64_to_cpu(xme.xme_addr) & XME_ADDR_DEVICE_MASK) !=
 			XME_ADDR_DATA_DEVICE)
 		fatal("Invalid superblock disk address/length\n");
-- 
2.52.0

