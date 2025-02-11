Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27C61F940A
	for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 17:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739294839; cv=none; b=rS7yp2VnSJRigXAOWkuDr3c7xEqGRdw2Dh87ctvG3I/teC0J5hXGizLsnALUPBfYDxfjlsnTzk8cs83l+ih/Dm5lBdYRzPbqUxsgU35WEVFQuP7BHh1WgybaW0wvIyfWB9xI5J1r3/iXcZUWLp3nqoC5m0avkSuqxiiSSZYPWl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739294839; c=relaxed/simple;
	bh=SUcYMnveHRrds1g1KDSVRn3iSgbRiOFQxeOxDUpSmiU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fhyv9BmTY4Ap7Jgsh/1va0auJXMJhgoSoTbpxxMrBT85YXkTGK6KNQe+28YVrKe1Ri7X3pqgiqF0Tcau3M5LRw0A8qeRVSZdx778/qsrSTugd3AqeE2eGit9chQOsSs7S8Ar372aRtmXtrTyqQw61wcaHo6HDuCPH/TIuve34ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FPzcqXJV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FPzcqXJV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739294836;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wHfUTzjVehqyfrB6QGAwoWMJBUqulYw/6Mwu24qZfy8=;
	b=FPzcqXJVpH9AHhCGYd98tkAg0V065QnKHMgIObg79u0lTgH69GhAVBsuvCnbMJWZTwTFyx
	Q+qeLJdH1Q677q9pGh0KyOdLXlaYnF8yynGf+zdLiW717iM9odgrLTslpjhwXnrWk1TjeF
	6DQnA43lVnbM8xDgJygG0I3N4WIAoy0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-t4oPQrMNMruDFTbeVkhQ7Q-1; Tue, 11 Feb 2025 12:27:15 -0500
X-MC-Unique: t4oPQrMNMruDFTbeVkhQ7Q-1
X-Mimecast-MFC-AGG-ID: t4oPQrMNMruDFTbeVkhQ7Q
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5da14484978so6424791a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 09:27:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739294834; x=1739899634;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wHfUTzjVehqyfrB6QGAwoWMJBUqulYw/6Mwu24qZfy8=;
        b=OH9ox4TqZjVU+dsmGnFuvvNl5y4NgF7hOu7FllqejMgA+UiZvMBL0ctsVvBjFcg5wF
         HtJSSzqtJb8A3mjZXbx+idqMC2EXjsOVwEHvhnPjAboK9sMjunl7vVcdY0dWPcGiICPY
         nVpW26O9YQqE6Rm4YFHeOkOjt4XDOkBQ2wtnqUSRcPWSp1Jg9ARvEhjHNVE2i59WENjW
         QTfpr9eHDFPbeAtD09T25QzFKBlLZMuUO+zZBa/xB5V8dNtG38APjbC4aY3JGKMliTng
         YDtgCCzIXNVNbTBfPvSD4b+uhaCQTdyQlNPKPBaVjNuINQik5uvOkrY4aFJBB33Lf1VK
         tNdA==
X-Gm-Message-State: AOJu0Yx8ku7yJSndLckZ7yrfjPmDIREnQ6td+pSNTjHPgy7BJlFuxUUM
	PSkd92AS7gvMnVSjGdLd6D93ec0XQCNRgEHjQKa0iJD+QmRVBDy09mnlt3P5GC08qOvswuJOjEP
	tcljdIhFOAAI06yU2kI2vqf2I5psezKMunzdOEfhefjSyMPd6OVwpHhhZ7UNoK0uXPas=
X-Gm-Gg: ASbGncsI4sptjibZ9xBUHVqRIzgWgbYqWcuxruP1/wRGXarAtg/FxRly/TWkXcOcsIc
	oHDEUaer7AWdCFaBZTCuoHuviPEOtv7mfAUNan0qX1nRHfksTPhursbRVBtXkuB5gGlmH52Mgw0
	WG+7MU58EUhECNbIk2AU+Mm3+w4n8gefvxNmaTpwm5TRhPzIuNKCbKLvxg2I56ul6qv/l39KX2a
	cz2r3RI82x5iuLDIxnZhUJkY+Us39frWR05D2F2ogd1gWezSC51xOuX2BTm2icw2EUBMercKc9R
	c5DbX7PKAnaBwOQJa2ayuhuI+yAZLnU=
X-Received: by 2002:a05:6402:1f11:b0:5d9:f21a:aa26 with SMTP id 4fb4d7f45d1cf-5deadde79ecmr7686a12.24.1739294833904;
        Tue, 11 Feb 2025 09:27:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH/kpQT+P6szjlMEp4Os1niREomDUiApXx6rxX/iC5wXLumjiCPGexag8mVmwQ8MVsSm7lZ2A==
X-Received: by 2002:a05:6402:1f11:b0:5d9:f21a:aa26 with SMTP id 4fb4d7f45d1cf-5deadde79ecmr7664a12.24.1739294833538;
        Tue, 11 Feb 2025 09:27:13 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5de5ced9758sm6914335a12.76.2025.02.11.09.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 09:27:13 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Tue, 11 Feb 2025 18:26:53 +0100
Subject: [PATCH v3 1/8] release.sh: add signing and fix outdated commands
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250211-update-release-v3-1-7b80ae52c61f@kernel.org>
References: <20250211-update-release-v3-0-7b80ae52c61f@kernel.org>
In-Reply-To: <20250211-update-release-v3-0-7b80ae52c61f@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1953; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=SUcYMnveHRrds1g1KDSVRn3iSgbRiOFQxeOxDUpSmiU=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0ld3FPzszkw0WSvEIHgmam55WLdSSLGR+I4eZ5epY
 Vn61/n56ztKWRjEuBhkxRRZ1klrTU0qkso/YlAjDzOHlQlkCAMXpwBMZIoawz/Lra4nrL2snBS3
 8KvP1D795mr1A8Wq+kUC7Qt3/lw8YaYjw/+E0DCHV2lat9b93bGPQX+ClJ1OkPaudy9SF94Nz/8
 2gZ8PAK6zRT8=
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

