Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464EC222577
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 14:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740581454; cv=none; b=Ebk8JRaM1+rXrVrjX2q6+5HD3H5UkdFX05jORMVumXcurNgGQcY/VYZoQ9Fc+6Iu067qFOzMn8SUfr1yoCGBvTAPayeR2mYj2deAU9AWcAP4VmCueaM0dg4NBv9/vk05+7sE7U0xKLPG3vASxh5GLWSycMyo7yo9GOJVFarKODk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740581454; c=relaxed/simple;
	bh=MJ2Tul8N2/Gt2ODedDqE5IKqlFtdcKI9WnGeZyve120=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aJiITP6NLGY2/+y0furPZENBtByuK3WM47qGt/UgbID2fqz6/Yam1xjjdQFdizm8yr3eQtIGAJFKdMqw3R12WWEvIXM9AqOwLhYpJgC+nynH9wNiK/Qackp6Sr5o6hFt6yD2Il45bCa7c1OEZqpAG3VwWxFZQyZCKVX+lxJO23o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XmkpD/X5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XmkpD/X5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740581452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rya/hX8b8xYRoVXX2cpJVN5QpYydeDi0E+n4A3XI0zA=;
	b=XmkpD/X5GpF3Nx1dTyWPNPekJQIUuJG8m6r3JACogOgqpnBCHdmM37eSodiG1FW1P1AWu+
	X1HpDrUI9xwg/NMekgqc8zEkZvNiqhjMRKGRqErSWlPYB6CCbrhzZSnkSuy94az6BFC4Iw
	LmHsx9DqanWw8gxVPRNVucDtM9zpckM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-jdemVXSRM0O95slC9kFTog-1; Wed, 26 Feb 2025 09:50:51 -0500
X-MC-Unique: jdemVXSRM0O95slC9kFTog-1
X-Mimecast-MFC-AGG-ID: jdemVXSRM0O95slC9kFTog_1740581450
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-abef9384a3bso48328166b.3
        for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 06:50:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740581449; x=1741186249;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rya/hX8b8xYRoVXX2cpJVN5QpYydeDi0E+n4A3XI0zA=;
        b=uisAlEqsOfOjh2wcYfLPg9+am9mBB3+I89cjTIAld2s9OH78N5dzShDLDu/WJ9bb/C
         AVohTdSKlTLajm8utPlF88nIFFWijiyYS2D9lfh65sTvSE0IUHmlXJcm6asIftSYzOEd
         20r5vImTzOAWtNwEYey6+0RQ7x5uxgWNdlucraNSGjOvXQehas/GRDNZFz3me5zQ0p+6
         4Q+74YL/yGjYrtAsjQeie+GTFg7W/YQrD65zKC8P2DmCMSpwRmQzE4O1WtYYyt3UerIC
         IuS6yFBk4289WWHVpbOoFeQTljwLedM919QVNWLzbyhhVyEE1RD1KjpAA2OS87jnR5Ad
         qt2A==
X-Gm-Message-State: AOJu0Yz1x6gkIEY7Y0YZ1odnKI22nfMda1iljyV7qvkH2UBcimP5A5uM
	kwRmp38XYGN3RL+HkZmxGGvZkGHoRqDByEHG5pjqEMPJTauJsuwFsSqFA01xBzaxB58IhiY4KvQ
	HvW23YuKynVPtwqCVXhWr6P4XoFHoQEHRk4S322BFA1tgOkTXn+q6KTZJShctLrdt
X-Gm-Gg: ASbGnctRSVHevkx1lHw8S8RWISDdPHv0gqQyQ9+iu1nF8rQeSFTThhY54qB+Ob5XjGR
	foQ05/wKaXiO4HacOKdRa3NhXF7m1YHjaZiWNYPpGeNsnbywqu6Dq/xlAI3x4sEcJIYubqsq79T
	rlCRcISjLSerdYHxX54E2vRI4ocpoGWehlYU/fY6Mp/K72e/+eR/51PyENOf+4dIDs8mzW+Mt2m
	W3XypD3f+oeeGecBN0ha/1bg4RcZ8/4rDxcPjzUINteBBmQzJZEEKz//NR5GC2bquOVXXGF0tpS
	GEUs2nMsIbvIm0nzrdhUcxYoCFG/K7mDJRQY7csX8A==
X-Received: by 2002:a17:906:31d7:b0:ab7:a274:d3df with SMTP id a640c23a62f3a-abeeed5e9b4mr404002666b.20.1740581448657;
        Wed, 26 Feb 2025 06:50:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF3xJj7Q4Gbnz+/VjWlH1syRtj83iH2HrOLTDUuJ1cL0FnolQyqflphJcy1qDndXJmrjHX85A==
X-Received: by 2002:a17:906:31d7:b0:ab7:a274:d3df with SMTP id a640c23a62f3a-abeeed5e9b4mr403984966b.20.1740581446705;
        Wed, 26 Feb 2025 06:50:46 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed1cd564esm337731666b.21.2025.02.26.06.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 06:50:45 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 26 Feb 2025 15:50:27 +0100
Subject: [PATCH v5 02/10] release.sh: add --kup to upload release tarball
 to kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250226-update-release-v5-2-481914e40c36@kernel.org>
References: <20250226-update-release-v5-0-481914e40c36@kernel.org>
In-Reply-To: <20250226-update-release-v5-0-481914e40c36@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1387; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=MJ2Tul8N2/Gt2ODedDqE5IKqlFtdcKI9WnGeZyve120=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0vdrOZ/qflcwr2Lm5PK923enXHGcopbof+9FU9YTk
 cJ1jS6rkn52lLIwiHExyIopsqyT1pqaVCSVf8SgRh5mDisTyBAGLk4BmIjiUoa/Qkv/L6mYIeK/
 N8h61uWHB03cgk7c+zpf9vZal2nP5jrtfM/w3/XTtuPMvXULFrHZs3a1crbd8TqyZ5vuOpn74rM
 TD9gf5QQA0YJMYA==
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Add kup support so that the maintainer can push the newly formed
release tarballs to kernel.org.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 release.sh | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/release.sh b/release.sh
index ea08ab334954e5b8aa40278a40cf7aceec2488cc..42bee75bb6fde7056c1770157f253eb5f492036d 100755
--- a/release.sh
+++ b/release.sh
@@ -16,6 +16,30 @@ set -e
 version=${PKG_MAJOR}.${PKG_MINOR}.${PKG_REVISION}
 date=`date +"%-d %B %Y"`
 
+KUP=0
+
+help() {
+	echo "$(basename $0) - prepare xfsprogs release tarball or for-next update"
+	printf "\t[--kup|-k] upload final tarball with KUP\n"
+}
+
+while [ $# -gt 0 ]; do
+	case "$1" in
+		--kup|-k)
+			KUP=1
+			;;
+		--help|-h)
+			help
+			exit 0
+			;;
+		*)
+			>&2 printf "Error: Invalid argument\n"
+			exit 1
+			;;
+		esac
+	shift
+done
+
 echo "Cleaning up"
 make realclean
 rm -rf "xfsprogs-${version}.tar" \
@@ -56,4 +80,11 @@ fi
 
 mv "xfsprogs-${version}.tar.asc" "xfsprogs-${version}.tar.sign"
 
+if [ $KUP -eq 1 ]; then
+	kup put \
+		xfsprogs-${version}.tar.gz \
+		xfsprogs-${version}.tar.sign \
+		pub/linux/utils/fs/xfs/xfsprogs/
+fi;
+
 echo "Done. Please remember to push out tags using \"git push origin v${version}\""

-- 
2.47.2

