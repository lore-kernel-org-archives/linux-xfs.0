Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705B7223329
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 14:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740581460; cv=none; b=eO/MQ78aOSWJC4ZoJAKlvvQP7q4zenj8LZoZkAswVeMWMoWMkPeBFM0Mw0N8UfBzgaQHGr96qDUM8Xh/13dc76gxX7gVMqbJrr9/lJryjjoxy6utsXK/9f8AR5ty4VZK7ohZibDqoCcoGI33+rl83VUKd4coUGci3oQMHMm6fEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740581460; c=relaxed/simple;
	bh=nWvjm6cpb14hU+FqgOnmVG258uMgBHPs+yDKlXhkLeg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KRfN6EuHOJQdmJMcxnUazcRWo/4fE1GfVfFWdLql1ZgIgtVB/oQhwJiqXrnHG9/v8Hxcq7EdRqekgEy59ZaFB8zOOX/7zR8cHTIgFfvqC9sWoJwgjQsMIA35IQqGyYM9xP0KCzX67u10lVYl1E27cTOnQofyyJRnpCJ+XQzwhZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gw4cItNK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gw4cItNK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740581458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NwiAJGUBqoHtqbtyksEnkOa3/uNAyh+3E+UmCkjj06Q=;
	b=gw4cItNKbvHvpviTES0g9IxTJVOOLWaT8qumQxogTxxFqulcISZ5zYJ+pT75CsYsEMjwYE
	dWT8uu3/g5X95OXYIIBHLB/DELZXGDh68i5DFw/ibXaPowrHChQMAQ+x9cEpgsOn4xF2YE
	w3S+4kSYuoE1LOSFUwd1xlVhBZTILVg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-389-Vyhtyl7RPpqryIdkEF8eow-1; Wed, 26 Feb 2025 09:50:56 -0500
X-MC-Unique: Vyhtyl7RPpqryIdkEF8eow-1
X-Mimecast-MFC-AGG-ID: Vyhtyl7RPpqryIdkEF8eow_1740581456
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-38f27bddeeeso7211084f8f.3
        for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 06:50:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740581456; x=1741186256;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NwiAJGUBqoHtqbtyksEnkOa3/uNAyh+3E+UmCkjj06Q=;
        b=OvkzcQ+4yRZzyK3Z5Qki+anORHm3yS8B/g5/jpLfQmFuDRMf4CaBy8ntmkMOF8s59s
         REF9ZK6nj2l2+ScXzYnwodP31psVkxwvhjGwGois8XXLywQiO8gLcVRa3Al14iVrt8vT
         zE/kjzXKJqfdS3rtncAB5mwnXCjVnjxBqOUDWfUMasVSrQEW16x6bzlemmJkaq4UJbfk
         2Fo5aoxg9hd9eehJCe2VEBKIrwEpCghZqwKBq09SFpCOjze9JIo+svFXqbvThf+ngLtn
         g0j9tTLMjOhFgyIRPM0+ipuhXpSehRa/r8CeXEdj64bePkHPmeAJfBzRrrXqpbraUcwp
         xCog==
X-Gm-Message-State: AOJu0YwRTpH6sI3xHVfBmcRR+kdtWvrw+IZJrU8p1rlrraCOhD9Iwp00
	P1/EBK2jt62Lx+yzKzgSxwR1RULMawiwsJmVpqkkZax6vi3fl3WHQMlyif5f44NYUreagy4iRYu
	1GZtH1AKTW25te3J0IujTftNinONGMLZpzlwCVfLjsscVciE183ypnHTa
X-Gm-Gg: ASbGncsVL/b2GwCpbtCJV6Ct2LpGutu75ojZsM1Gy+jCopoCcZWdaWxhemDTfkzatXo
	Zt20e6QrVHd6n4xWtjuYu5tbFVPg2x+/REHqZEC/Ixsj2ayRVzx9KEuG28P6Le+aYsIdom6nz/d
	vNSZhHfwJklUI6sGvch1hc3BPi+SeOlHouyfKDoVfyPzbJA1zgqVT/BigBA2u3m5+cKYT5EpA8K
	XA2OzeopVLRZNLU6QDM4iUaBDPgqNp0NuSN0n6AAfhsSoN13xroP5YvBJK3lLduMe2hkJJhlWPR
	uCphoKHMq69DjXZnVTfyzmUoSRN/KuI9nq1e4Nvm7Q==
X-Received: by 2002:a5d:64eb:0:b0:390:d73a:4848 with SMTP id ffacd0b85a97d-390d73a48d9mr2992285f8f.47.1740581455615;
        Wed, 26 Feb 2025 06:50:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFG84N7nM9pIVoN9vkgGJon/ykyeoRCNCvu6O3Af2Lx2OMMBXtFbhAJyk4Hje75zIEFiWe+TQ==
X-Received: by 2002:a5d:64eb:0:b0:390:d73a:4848 with SMTP id ffacd0b85a97d-390d73a48d9mr2992256f8f.47.1740581455290;
        Wed, 26 Feb 2025 06:50:55 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed1cd564esm337731666b.21.2025.02.26.06.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 06:50:54 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 26 Feb 2025 15:50:34 +0100
Subject: [PATCH v5 09/10] libxfs-apply: drop Cc: to stable release list
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250226-update-release-v5-9-481914e40c36@kernel.org>
References: <20250226-update-release-v5-0-481914e40c36@kernel.org>
In-Reply-To: <20250226-update-release-v5-0-481914e40c36@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=755; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=nWvjm6cpb14hU+FqgOnmVG258uMgBHPs+yDKlXhkLeg=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0vdrOasE3i24b99h+uVLDrvxtLV2PLyPg9ZcKD+6S
 C7Ze59W/peOUhYGMS4GWTFFlnXSWlOTiqTyjxjUyMPMYWUCGcLAxSkAE9EMYWRY6z7/e5+BaUzN
 xK493vuf5ng+WNZ740ZqfW+y2rZjhiYOjAz/o/Trzh9dL/PecH93+7bdTxKzeIoF1txonfPzbmv
 RXT0WAOeHSJU=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

These Cc: tags are intended for kernel commits which need to be
backported to stable kernels. Maintainers of stable kernel aren't
interested in xfsprogs syncs.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 tools/libxfs-apply | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/libxfs-apply b/tools/libxfs-apply
index 097a695f942bb832c2fb1456a0fd8c28c025d1a6..e9672e572d23af296dccfe6499eda9b909f44afd 100755
--- a/tools/libxfs-apply
+++ b/tools/libxfs-apply
@@ -254,6 +254,7 @@ fixup_header_format()
 		}
 		/^Date:/ { date_seen=1; next }
 		/^difflib/ { next }
+		/[Cc]{2}: <?stable@vger.kernel.org>?.*/ { next }
 
 		// {
 			if (date_seen == 0)

-- 
2.47.2

