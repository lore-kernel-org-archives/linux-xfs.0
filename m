Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A045C24BBED
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 20:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739477763; cv=none; b=Q/x2hfXeCGvXaweA3f9G0JS91laPsohf5mutAOqkyNfyJn/9AmN6YepMoKYjD9+D3pTdSbHC1F74cQ3QBzdOLtlGqi8f9+cmzwNVMaEqSz6YOMXgMezHd/dbJjiAApVUi8c3ZsqQdhaVKDR/uynBnKyRI4NLjvHd1btQpLZ2NsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739477763; c=relaxed/simple;
	bh=SUcYMnveHRrds1g1KDSVRn3iSgbRiOFQxeOxDUpSmiU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=trT+64xAB8+hFrc2bh3GU9Ij9VwvzvYzySJT+03buGmocI1Z5FIZEo+rkaxBly2JE7E5OT0XgTbE+clr/pQrWjf5QaC6XtKyJ/3nAec4O3IEh9UClcxNsz/xJTI3m/gfXLWGEIk4V7tUEC4tJ4WQgXRbmykEKrI2RdGQsV/TpV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gzZtvYDu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gzZtvYDu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739477760;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wHfUTzjVehqyfrB6QGAwoWMJBUqulYw/6Mwu24qZfy8=;
	b=gzZtvYDuGm/A7GFUqI5Vb+Bl02oL31S5WsC+d/N6BCVcVZPm19hmQgHRe8Gn751sObCARc
	3RZ4qVO5CA8gFRbvVRRstoJ63ss4t3qyvsDwu+QTdhnSEEHObijpvjHnXv6wXdJaUO4GX7
	LOQPkexCdrYT90Kjd1pYtFTBp8piqeI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-dlzAV_gHP3qsACcPO4rTEw-1; Thu, 13 Feb 2025 15:15:59 -0500
X-MC-Unique: dlzAV_gHP3qsACcPO4rTEw-1
X-Mimecast-MFC-AGG-ID: dlzAV_gHP3qsACcPO4rTEw
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-38dcd8ddc5eso1267491f8f.3
        for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 12:15:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739477758; x=1740082558;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wHfUTzjVehqyfrB6QGAwoWMJBUqulYw/6Mwu24qZfy8=;
        b=H/HF2EkEnbSFjOtK4JURAAAXBBXTF+Ms9JGh3aipRmevgMPRDqOqg5A3bSrkwRST4T
         rPit4/6fZzpi8tcjjb4Awdmo0V10VrIpXChVx3rO5GRJYNjrP52vODYDIgoK8f9vD4+6
         WC8NEH7xxgyhJU9GaolqCbZZ7Ceyclds9yeA9P2qQVf73ekgpdIbVc4E9RsSREc8cH8A
         L8spsh6/LW53vfGoFWhQEVsDUD2u2iYHw5RZ4Q+F6iFma+1fWqk6xKebho1dk77UFRP8
         UkItzDfB64fXdF0/q8MsTyEYfLHf1kXKW/3GXgqp7WWIE8Eyda6YXS6ZRmDd+2IFVAp5
         mmwQ==
X-Gm-Message-State: AOJu0YxmaPAMnamixpVXauzeUl5cJpd9mPwzYjiMBcyxDoAQxnF2ipqo
	uLm2rDjWq8RX8+zPzeQeWn5WyLJdOJeszsMOWnt6jwPr6iseGnKxFwH/mtDR/JuG9wE/KcC9Dt2
	KmMY79cyc3WtUTNqojpJszDKqkLHbJbh+oUdvq3RqqL/dUYtInyI0zwTk
X-Gm-Gg: ASbGncsWO61I6J1nbJDEhG2M2br/tyXBj+eHvNW/hsjJKiaRvNaiOyeDanZzYfC44/i
	Eg5c47AvKDBmgYkWnwxxrfoSXXJcOCKcS9h3sb/TMiTOc2MJIqbgoINcI1v8YJvdcGhztMLX+BY
	RZh2HPIr9pNyhl31DQF8r5SypgXUx/jnlifFMmEELIWBKp4pfdz7qT0+I8DaEFEh24428EXkUn4
	2cU8ApjDrsVRGNvt8h6lxWeBLEcaQGURqRUx0ad5VfX5R78ED1yKWgZ8CbsRgyeusysxZ/UAVxt
	K3D/jYY0M5moYnoAEdDSq8F2IlFYPcA=
X-Received: by 2002:a5d:6c6a:0:b0:38d:c627:f634 with SMTP id ffacd0b85a97d-38dea2ea06emr8736224f8f.50.1739477757787;
        Thu, 13 Feb 2025 12:15:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEJLbdxfXmhWH4fhf8qAcO0TpghMdAgeWhXyxaxMLiqe+Jg+/KBlRznfiCAtHUEmvmU/cKs1g==
X-Received: by 2002:a5d:6c6a:0:b0:38d:c627:f634 with SMTP id ffacd0b85a97d-38dea2ea06emr8736198f8f.50.1739477757396;
        Thu, 13 Feb 2025 12:15:57 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a06d237sm57520895e9.21.2025.02.13.12.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 12:15:56 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Thu, 13 Feb 2025 21:14:23 +0100
Subject: [PATCH v4 01/10] release.sh: add signing and fix outdated commands
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250213-update-release-v4-1-c06883a8bbd6@kernel.org>
References: <20250213-update-release-v4-0-c06883a8bbd6@kernel.org>
In-Reply-To: <20250213-update-release-v4-0-c06883a8bbd6@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1953; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=SUcYMnveHRrds1g1KDSVRn3iSgbRiOFQxeOxDUpSmiU=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0tcF/Tq2MLu5+mNHQM6GQ28ahL/Hbjn0U89ze+mFe
 oMT+nNOPAzqKGVhEONikBVTZFknrTU1qUgq/4hBjTzMHFYmkCEMXJwCMJHUswx/pV8tfCbHEV16
 8bFrlHrVrf0VL2R7j1l3XY58X3TyaSRrOcP/Ap/F57L3vzp7/t7CzEmJB+NMb6RK2n6Kj1dWv8z
 2lU+HCwDHiE4J
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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
2.47.2

