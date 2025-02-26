Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EA0221739
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 14:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740581454; cv=none; b=IbFxHabNCeW58g7OQrPNvLCpFppX+Nf721PkRhlO8/y1r7snU4W0VVyy87EKAnq5i830g66ZwzuK8caAjBzgKOiZ8g6cijA5Q+ePnt7jhCvUqxkfDDvzJZzvR+PaUBezMhRtGWDXFlaW0JYga6tN5/VxACQnvV30ERlmySyd4tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740581454; c=relaxed/simple;
	bh=r8NE2PVa/ZrAaOBQWgPWkabf8eqQcrLO6lplelO8GLk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KwNZerBKAD1ja2v5myukn4C6cqx9KeflWkJvXRMsxTtwGrKAUpcOjJfOzU5AAPZ9JsxHX5DXP3sUa1a8zi+nSBJHE4dCE+CPNXwqtDpZMVW1zD5bwIz4Ei0hkpR1LJcAB9MPLIAIegEc3GWwT5J3hvHzgXbhMPStHIdERBqiGDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i+KQQhAX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i+KQQhAX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740581452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6p3yZF2ojbKPOjvfClYCWTgw5eOy5VAaFnC3+essAGY=;
	b=i+KQQhAXNFJs1In9NQmqLxYoh5Lgd7jr2eBGXW/a4MjUeqznyY8T5PeLZS07z/RDzAIy8f
	+hs6RLRkcvNC6PZpFUb5SCwExtowaZSM9M9Q6bZZSLa3n2dxOHanqqQefGH/xD/1hvfHlA
	nZr+T5RsuvpjKzBBkdkQ+eIBSD526MI=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-l5T_VMSSN6yDpo3pof7jng-1; Wed, 26 Feb 2025 09:50:48 -0500
X-MC-Unique: l5T_VMSSN6yDpo3pof7jng-1
X-Mimecast-MFC-AGG-ID: l5T_VMSSN6yDpo3pof7jng_1740581447
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-abbaac605c3so688992566b.0
        for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 06:50:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740581447; x=1741186247;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6p3yZF2ojbKPOjvfClYCWTgw5eOy5VAaFnC3+essAGY=;
        b=wk0P+99T8gv468HpO5aVecPQKoR9tc3EBbOCj/kSykqiri9M+c7qRvO6CLX88KUlQU
         Uqh95uddIlRyl0GAM6MHkhUGIC3TI0G7x39lq6n+xaCDC/uXAbtkcOLm4uJhqoNcS04H
         4vjebcu5Ku+zmo6XKWyZEMkPyExCiMVsSoRs/omAvuKqtxxCYbkr/QLR8+JRdjh0l93W
         GEThKB8Zq8rgCVPOATG1BziMkcUus//yYRBeMzl9TK7uf7f8xTYponbSlVF1JhEfou20
         /ood8K9fSVvg77javboZzw3ukXrdVr8Q4mxjkATUeVIjO7RFFS+xzPflHNY1bji8FeMf
         hc2Q==
X-Gm-Message-State: AOJu0Yxv2VNJyRgHxbogvQ1x+ofM5M/7RjDzhQkeqO33G8pHQFzt5wGu
	bwhD6EKypk+NDAwooHUd1weN3qKfsPApYNSnOfDv5eX0YTS2nxpRVspm88I3W3lm7j9BAqdKjCr
	5nr/aykiraUyGRrivg16EPWV9kUPUMQ63IUtiAXO1MWoBkdz/IoY4NVCW
X-Gm-Gg: ASbGnctSejpTGT83Qk6QNOTN0lCUlQtsobssw9B8wSdFd47RSEqtA5Ep8OYtqT8QV5D
	wnpcGb7zNpVtcA9Vy1WoE3UaizQbSpTnioseBnDFJ+rjAkyMy1DeDGfnwzyNCcqM4cLuhgt+P9p
	TAueXru1R4q7sQY2WFpPpHyiLvXPHx38ymSYPTsPv+BNAAUGYrugSRvggx0P3yDDSoBl4hwgGGo
	qQb+VrtffrUEaogCF5+7c7Z8qWsPe9g9/LO5mJPbkD9iuWA1yhyraaWgQTLIOCfAWX8K7YLqWCG
	XDnQrrQiIXfQKzqfy2NfR6BC+pFcE3Y/PNwxpiS8Fw==
X-Received: by 2002:a17:906:c148:b0:aae:85a9:e2d with SMTP id a640c23a62f3a-abc0de13a1emr2471887666b.45.1740581446022;
        Wed, 26 Feb 2025 06:50:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEAC9hG7oEXuq9BTFXg/wurwmCZ+o1EQgn4SBBoWHeX0Ql0tr3Zf8OXDOKSYpkPCC+iQ2c6Ug==
X-Received: by 2002:a17:906:c148:b0:aae:85a9:e2d with SMTP id a640c23a62f3a-abc0de13a1emr2471884566b.45.1740581445661;
        Wed, 26 Feb 2025 06:50:45 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed1cd564esm337731666b.21.2025.02.26.06.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 06:50:45 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 26 Feb 2025 15:50:26 +0100
Subject: [PATCH v5 01/10] release.sh: add signing and fix outdated commands
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250226-update-release-v5-1-481914e40c36@kernel.org>
References: <20250226-update-release-v5-0-481914e40c36@kernel.org>
In-Reply-To: <20250226-update-release-v5-0-481914e40c36@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2042; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=r8NE2PVa/ZrAaOBQWgPWkabf8eqQcrLO6lplelO8GLk=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0vdrOavWvutMWTPjws9p36W98p9fey3lM1fzzAbZY
 7naOokOjmwdpSwMYlwMsmKKLOuktaYmFUnlHzGokYeZw8oEMoSBi1MAJuK7nuEXE5PkDg+Rq9w3
 v79tUOf92Xfsg1PgljJLrs8B5Rn2duLLGBk2bw33iFu2RGpDZPljbcG5l1Ufz/Q42/zrZn3uKqV
 c7RoOAPStRgs=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 release.sh | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/release.sh b/release.sh
index 577257a354d442e1cc0a2b9381b11ffbe2f64a71..ea08ab334954e5b8aa40278a40cf7aceec2488cc 100755
--- a/release.sh
+++ b/release.sh
@@ -9,6 +9,8 @@
 # configure.ac (with new version string)
 # debian/changelog (with new release entry, only for release version)
 
+set -e
+
 . ./VERSION
 
 version=${PKG_MAJOR}.${PKG_MINOR}.${PKG_REVISION}
@@ -16,21 +18,42 @@ date=`date +"%-d %B %Y"`
 
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
+if [ $? -ne 0 ]; then
+	echo "Can not verify signature of tarball"
+	exit 1
+fi
+
+mv "xfsprogs-${version}.tar.asc" "xfsprogs-${version}.tar.sign"
+
+echo "Done. Please remember to push out tags using \"git push origin v${version}\""

-- 
2.47.2

