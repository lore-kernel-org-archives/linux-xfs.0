Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5D4202F8E
	for <linux-xfs@vger.kernel.org>; Fri, 10 Jan 2025 11:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736507122; cv=none; b=qHBP1Kxs62r19zrgPK5LuZ7cnCKwhX54n7UZYigob69V0aQQNcqDsoOLFCZ8cFSbpau8DA7xnJnXTGWSQtiWoucwB29KJuNH2XUzKVdobCnSsXIclkwfLuWc9ujW3CAH5cHXaotKYu4YI+jjVqa38tIpzAPWrYqaH7RGB2MagWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736507122; c=relaxed/simple;
	bh=OUvwKYh6VEZ01uR8wkG1nXSQhgfNKwaFGOPvq9wVTts=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iLygWN4r8Cwn1uuvZHHsxjatXz3BGoBuBNyd/3oW40s25gnbnykeZlxlCvvrYBycvqFgi0HhTsenHSgkHZ2ZgEEy95qVCnydhUvAOHZfnhxnfUdWp1wCy7+as/2gQlaQ0CYwRpwZXgPGq4CzgNoLDWM3AQ8hswjSwcFqWMw5+cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a8bKPL7J; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a8bKPL7J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736507119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JSPu0e5TGhfMtbkmXCsXwBRiCajFy8txLF3yrDbRlDI=;
	b=a8bKPL7J7uZZUGe83Ff5OiNznZ2vnPSEOyMraTVCjbwhD1nu12aK8JAPWkDb0gMRkktzI/
	B9kSc5csYNGp/zdRJy6hEijVi6C23a2CE/YCreCIQ0PUp5fzvw+MTb4sBgMWeX1dhyPkPE
	Eqync+wijhklwF/u85b1Cq66hDm0F7M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-14-eNJEBeOMNSS9TiEMVvTTMA-1; Fri, 10 Jan 2025 06:05:18 -0500
X-MC-Unique: eNJEBeOMNSS9TiEMVvTTMA-1
X-Mimecast-MFC-AGG-ID: eNJEBeOMNSS9TiEMVvTTMA
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4362552ce62so9990375e9.0
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jan 2025 03:05:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736507117; x=1737111917;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JSPu0e5TGhfMtbkmXCsXwBRiCajFy8txLF3yrDbRlDI=;
        b=QAgA92McZ3liG4KUyXrnYeGaBBPRvFgE4gquv47T2TFd902S81OIRS15+GybjOz12+
         x7KZ5z/nKa0LZVuG84X7BoRTFDsGSSZFT6+12Q2s8bMx8/pSi9+PMv0qLIrbxGt4TtaH
         ap7NNC8P65WPdLmfz36UL457tMOsWdhzHGF/iYFQN9xBNSPuowu11myyx3P7nWJ9odP2
         pG6pSPMuBIkWiAtDrFZ6zA70GzuFR2EmkYjxJehrKMy8RiRIsIxozXKhY7PEjsiv7+mV
         jXdE7SbCaPkr3LisMwPMC9sH+mn5ZR3CCO98q4ISAkUOxh4ucKJ62JdwXkgFolQivIQY
         kFoQ==
X-Gm-Message-State: AOJu0Yzp7ztlT6cKDEwU4vHGmbCStCrQNu/E/HWX1KyD6zk3Jo8vWFjP
	7heoYerbXBNNVQkNaCDm0wquTImKlCvijfqmV0ekUyZfeotkU4ie97DCiE4xxKCrDH8kQd9EzrD
	8BIlFayYOet/2Ob44aqNMN9lKdg3N6o4Bes0z32UR3VScc5iTCdzzixuZvl/kGVfeDSkApw8nDK
	mQTFQKkNAVIL+HKY+1ZXgH2XvkJENQGfJjXRvULbGr
X-Gm-Gg: ASbGncti6/eUPFOtwwsB59eo7ijLwnXK/n3MrElU230xY2Epq6bdGVfhv/F3hssPIHE
	2lWGQpPMzqkfdtv1lP5EHwww0ktwerZUbeXwUNDF7aI/qqRtn0J6ks+yNCjIve63x72tvZZ05+0
	Ou7EAg33PFiRi0kymqdMyezbkMjC38g3xqQgmgqMMWZCfTFKZfql+Hs4NkNRe/Vsc4W9aiaBfjL
	hL3HnjOfs5pdRAxQVjtM0GteTvv7B3ZKiKZQVXbG1DPZuk2jNso9dK+xOTpjNOoue+tAJ4XMi+S
	+gYxX3U=
X-Received: by 2002:a05:600c:1384:b0:434:f2bf:1708 with SMTP id 5b1f17b1804b1-436e267822amr93806965e9.7.1736507116788;
        Fri, 10 Jan 2025 03:05:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGsoAILKAZw7wVZTkhONLko7Rcb1HTgISeaAzZuLGLzI/RdL9WSqyjNRlrCVoUrDvcVR7JoLw==
X-Received: by 2002:a05:600c:1384:b0:434:f2bf:1708 with SMTP id 5b1f17b1804b1-436e267822amr93806625e9.7.1736507116357;
        Fri, 10 Jan 2025 03:05:16 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e2ddcb5bsm84774835e9.23.2025.01.10.03.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 03:05:16 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 10 Jan 2025 12:05:06 +0100
Subject: [PATCH 1/4] release.sh: add signing and fix outdated commands
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250110-update-release-v1-1-61e40b8ffbac@kernel.org>
References: <20250110-update-release-v1-0-61e40b8ffbac@kernel.org>
In-Reply-To: <20250110-update-release-v1-0-61e40b8ffbac@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1903; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=OUvwKYh6VEZ01uR8wkG1nXSQhgfNKwaFGOPvq9wVTts=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0hv+vVYta/6VZn9k7eTtXtMXGYZPemuy27VI71/b5
 K15WR7tSdIdpSwMYlwMsmKKLOuktaYmFUnlHzGokYeZw8oEMoSBi1MAJhLpzvDPwHCXncVFR4n7
 PnuO152a8SF3BcvagpBrjTv3TX3n2/rkJCPD03bHptY3s/xsLpuejZ5z1SuFp2OqiPY+w8ajd34
 ob3nOCQCCQUw0
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 release.sh | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/release.sh b/release.sh
index 577257a354d442e1cc0a2b9381b11ffbe2f64a71..b15ed610082f34928827ab0547db944cf559cef4 100755
--- a/release.sh
+++ b/release.sh
@@ -9,6 +9,8 @@
 # configure.ac (with new version string)
 # debian/changelog (with new release entry, only for release version)
 
+set -e
+
 . ./VERSION
 
 version=${PKG_MAJOR}.${PKG_MINOR}.${PKG_REVISION}
@@ -16,21 +18,38 @@ date=`date +"%-d %B %Y"`
 
 echo "Cleaning up"
 make realclean
+rm -rf "xfsprogs-${version}.tar" \
+	"xfsprogs-${version}.tar.gz" \
+	"xfsprogs-${version}.tar.asc" \
+	"xfsprogs-${version}.tar.sign"
 
 echo "Updating CHANGES"
 sed -e "s/${version}.*/${version} (${date})/" doc/CHANGES > doc/CHANGES.tmp && \
 	mv doc/CHANGES.tmp doc/CHANGES
 
 echo "Commiting CHANGES update to git"
-git commit -a -m "${version} release"
+git commit --all --signoff --message="xfsprogs: Release v${version}
+
+Update all the necessary files for a v${version} release."
 
 echo "Tagging git repository"
-git tag -a -m "${version} release" v${version}
+git tag --annotate --sign --message="Release v${version}" v${version}
 
 echo "Making source tarball"
 make dist
+gunzip -k "xfsprogs-${version}.tar.gz"
 
-#echo "Sign the source tarball"
-#gpg --detach-sign xfsprogs-${version}.tar.gz
+echo "Sign the source tarball"
+gpg \
+	--detach-sign \
+	--armor \
+	"xfsprogs-${version}.tar"
 
-echo "Done.  Please remember to push out tags using \"git push --tags\""
+echo "Verify signature"
+gpg \
+	--verify \
+	"xfsprogs-${version}.tar.asc"
+
+mv "xfsprogs-${version}.tar.asc" "xfsprogs-${version}.tar.sign"
+
+echo "Done. Please remember to push out tags using \"git push origin v${version}\""

-- 
2.47.0

