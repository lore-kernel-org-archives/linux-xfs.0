Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294F42236FF
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 14:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740581461; cv=none; b=iwuG0HyVDlguSs/s58B+nFBORfNUchDud1/hzhd1zJ3TUPjD5Pb0u18aN36xbhz9Y2ud7oQwloU2GjHlTEeI7O8Xqs7bRYfXNk6tlvyvdjmpTHxIOjCfwAZWXEzdms5pFccRvEHQEgZd/yR1xinGXz8uq08lXheUdU3DZHooNaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740581461; c=relaxed/simple;
	bh=q9tJlYi77GrKLPykRovUUwGWEwJBZVRr1Q8LS8Gdh9g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=svAMP5nBpDGuPa4iZKkce7UhcXE1rSRqY7ueYbtxtMCDJEAYvpPaLVMNSzAimOy6zAT5/76pVB97iiCzmLc8kDUEBEyzZ/KNzB8lC1lakTr0nqVzodf2qnogC0y9vAkCngVBVkWPBmunrjkjByEEHnOwM1PcPmauGrnfFVlAZCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HxXK4Ndl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HxXK4Ndl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740581459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XKRAVc6MlEKZqA0vjtnDJqkLrXz8aO/sEmAAN+dRDIY=;
	b=HxXK4Ndlu9hHSv7AyKRTwklQ2O8FndQYsZNna4pyXaw7oMtdDW3InBZkH2DMmLwUhEn1Sq
	mwsq9rENxwqp+tuLfCeaOwk347WIIwuXrA6F2df40jxcO33IrXY6n7nn034i+QWYAU5AOD
	Yf05SWd7d4xXY/I9j1bTzNqS2FhzTXw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-100-GDm4jSTHPfiIheRgaSEDwQ-1; Wed, 26 Feb 2025 09:50:57 -0500
X-MC-Unique: GDm4jSTHPfiIheRgaSEDwQ-1
X-Mimecast-MFC-AGG-ID: GDm4jSTHPfiIheRgaSEDwQ_1740581456
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-abafbdf4399so115669166b.0
        for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 06:50:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740581456; x=1741186256;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XKRAVc6MlEKZqA0vjtnDJqkLrXz8aO/sEmAAN+dRDIY=;
        b=JOYQib6gbiuJRi4HKg5qjFqSnt4sWVEu/IcSA1jty2Pw9fHICgkqkEpqqYxnhXSKSk
         k6ViYK2DUWpvznfFpPk5ych6hKxdSd+DU07XuTyWRDIfQoTnkXT8DdU1aquViSpOtS/q
         QCy2+Wlo4Un0OKi+1go1oGjGpfKm+v48Rc+wGGXaQkzGxGtRFt5kxgdnW0QLWepqSeWO
         Eca2UARA9n0mrX9xQiBuh4ckCrZPfI8ntW7EhY66xK3LrwGoYD7FhHVkxte8wEIXJ50w
         RG4sLgSkty4P9MIB5UMyhdxIBLJkTMkY2mqJSxSGzK1T1oKJFPK7gWaWl67HhkVYtM9w
         XRnw==
X-Gm-Message-State: AOJu0YxHLgmf4qYVuyLzsB5ZMVj8KhsfAtY2WU9P7V8ptHGPip2SSFcl
	NTU5DqTb/03buXp78lAMncUhlIth9Qt5ioKylgAKJosE25laXL/e6/d8Gr7lUWSa+PU045BzZ+B
	5EaffAc72gYAuci/8+2ruy3Di6Nq/P34N5mhGipWANUBA/txjlw9/acf9ZgHcDjNi
X-Gm-Gg: ASbGncsxifRoGfD3G0cs4v+juOhZkYEZMTr7rPw6VGHDFb01KPUX4XD+vhdS+nXRunx
	wIPQS8e6CP2FZZ0TkvhNKuLBprZNTYVp+2y9D7KxD8ZDJmfW8Fg+KB8Sei4uMmeLC7kfvszlOac
	wONhM+VanVgKyPb6yCNoS7mg+dutaD0u9M1qta5Vynihqi8g1HbOA/INXT7n116tYQQawcRCp/V
	s7XGFROshx8lZrmFyD3akUkDcR6LxHkVZN3PqvjRuRWMFHI/tUa4Ucb/qFAWsmQLS8y1biAU5FD
	qepuVwk+tNdOSK6WhGpPlSWH2pk5eMxRYZP06kka4Q==
X-Received: by 2002:a17:907:1c0e:b0:abb:e048:4f5e with SMTP id a640c23a62f3a-abc0b14d715mr2266040166b.29.1740581456214;
        Wed, 26 Feb 2025 06:50:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFeN/dKRVrf1EQ99zVDB5yHlA+mrjXjCzSeqsMG+q+BNoIjA/duaXD39LhxvOPswQNYskiSRw==
X-Received: by 2002:a17:907:1c0e:b0:abb:e048:4f5e with SMTP id a640c23a62f3a-abc0b14d715mr2266036866b.29.1740581455809;
        Wed, 26 Feb 2025 06:50:55 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed1cd564esm337731666b.21.2025.02.26.06.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 06:50:55 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 26 Feb 2025 15:50:35 +0100
Subject: [PATCH v5 10/10] gitignore: ignore a few newly generated files
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250226-update-release-v5-10-481914e40c36@kernel.org>
References: <20250226-update-release-v5-0-481914e40c36@kernel.org>
In-Reply-To: <20250226-update-release-v5-0-481914e40c36@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=740; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=q9tJlYi77GrKLPykRovUUwGWEwJBZVRr1Q8LS8Gdh9g=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0vdruXRpzm9svNQSHXRx56+7jrYpLvEfv8V5ONmmp
 bI1NnP8+9lRysIgxsUgK6bIsk5aa2pSkVT+EYMaeZg5rEwgQxi4OAVgImvfM/wzqUnfUZx50G9S
 9vvNoU37r+/4XWm05W7I5tqJHr4TW9l2MzK0Gz7+Ib+//uUH05Kw60ekugTV+ixcP724GzHR+3D
 Y0e9cAOe4S3o=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

These files are generated from corresponding *.in templates.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 .gitignore | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/.gitignore b/.gitignore
index 756867124a021b195a10fc2a8a598f16aa6514c4..5d971200d5bfb285e680427de193f81d8ab77c06 100644
--- a/.gitignore
+++ b/.gitignore
@@ -65,12 +65,14 @@ cscope.*
 /mdrestore/xfs_mdrestore
 /mkfs/fstyp
 /mkfs/mkfs.xfs
+/mkfs/xfs_protofile
 /quota/xfs_quota
 /repair/xfs_repair
 /rtcp/xfs_rtcp
 /spaceman/xfs_spaceman
 /scrub/xfs_scrub
 /scrub/xfs_scrub_all
+/scrub/xfs_scrub_all.timer
 /scrub/xfs_scrub_fail
 /scrub/*.cron
 /scrub/*.service

-- 
2.47.2

