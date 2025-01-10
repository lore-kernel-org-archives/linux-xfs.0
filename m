Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA669205AA8
	for <linux-xfs@vger.kernel.org>; Fri, 10 Jan 2025 11:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736507123; cv=none; b=HcgPm3sFtU4o84eJ9jlZdRATrhcmCRPWoJAhmbz7NSrY9BWL5yaCczINNjvz9BJmWbum0tpCbYz/zJ0DOgIpswPD4JwBA86ZCyyEpuq8lpBUlT6frO7kW+Rqtt9XbogiIo1T/SOquYel+FWNmLZt8t7yH1e3N5qzFjenhqfKWBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736507123; c=relaxed/simple;
	bh=GvVxfRTpG9NHuQlcYhKEbz5tLJqKGeVwvpASR4E785w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iWzUWs6mmnKRjovtOYI69yL0TPHvp+8Z0mrTM9z9j+VruEb6vnAFibhmkH2JqNKpXaG1MsIqVUKZCoQ8xWJTbmK1oFSv1HQqTCJtE5gV/7VhFVJa3cD+jG2o4F7UUGyemigvV0E845VTDeBh46o+NY21cFioS/hkCky+JP9ekrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LUvPfIZr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LUvPfIZr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736507120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3/+9Tg1Pbx7KMuMaajlZwPzfDNRvl9QP8X4iGqp91Wg=;
	b=LUvPfIZrpm7bThaz6dAluvaJX5w5U5cO2RngHX9TKRRx4z3l0MUN6ksxX5KcBkRrU6y4pt
	o48YkgDNHNMiuXZpglH3+Qyy/GCoIRVs2x+yppXWirHlhEQ2TFCARk4KVFQiB4iegidiYJ
	HgvwlfroIKc1/OIkJ4DvoP6ynXtYAf0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-600-VlQH0IbVOw2nRd6jXgnmhA-1; Fri, 10 Jan 2025 06:05:19 -0500
X-MC-Unique: VlQH0IbVOw2nRd6jXgnmhA-1
X-Mimecast-MFC-AGG-ID: VlQH0IbVOw2nRd6jXgnmhA
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-385e27c5949so1145121f8f.3
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jan 2025 03:05:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736507118; x=1737111918;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3/+9Tg1Pbx7KMuMaajlZwPzfDNRvl9QP8X4iGqp91Wg=;
        b=LYj3Az+apvVkKoQL4qSf0KwgfThOrdZXPTrpUWmZSk6+9Mj0Va2nYNfTXUMgpDAGzC
         l0mjRHtbZmbgd1sAn21ZtjJ10jdVOh8e+5AqEoj11WuRWYLd/pjUARctn4hNeg6UdbRs
         2fClqecHHWDhBnq4IEoTiQSKFFEd+gde3Q0MtorIYxM662Fn+T321ilmsbnUFVH8Z1sD
         QiSqxW8fVkRMBuHXIPiA5sLUYoz+OuD8cnGcyrBmCiBfCmPpHnk08fRktuP6CC62q9Ff
         7+44M+4Jc2UaCPpEmzMncTL/ifuPALrw+iwSMNIiVWgW0kgZiNrnF4LvvV3KTHg6g7Ry
         3Vmg==
X-Gm-Message-State: AOJu0Yy4faeOEwWwaNXUsohCQ51cIcWn4rJLBtAdVrBnS3kFRDO886JL
	BXbXS3nBtSCoEzRbYbGUM+/OYSlC0Yxupzaux8Rm214eE1AN5LlyqPCRI8WPXFcP2qLKWmSAYGu
	TNQ2A5el3obs8Ub4IK6XA4s2x2bdua+GicnbWqqe1RPyh0GbtEBT9HXQD/VP0ArfWj0RLcQbT1q
	cYCicc6uYf3m0b3HBV26IoeyS4Fvdyxmb03Fmtbam3
X-Gm-Gg: ASbGnctRd7IUX+LfwLgLobXI65NTO8WCAED8DNjKhMTlL6HqVTb5EGV3bca1ZTk61UF
	Zq0qt/dwhbuBAMzV4w/2UxnEJ9uaM0Qq60fUB/aOkICseiE+4WXnPAjjvaAEekllVQU93nefocq
	CoOAYz2YIAy1N4nMyxbUGt5r7YmOIr4iSZVSj2UsMXDMgfbAYdHpnRWbO+Jva2detfzuCIWQjE7
	N6+uL1mpRNuEAr4193nRn/1pwAtW8sWl1jbPNWzIzhAekoaT709r4Ci9hLL2dTOg8EqNGiHRy6s
	5ARbuqA=
X-Received: by 2002:a05:6000:154a:b0:385:eeb9:a5bb with SMTP id ffacd0b85a97d-38a872de3femr9378704f8f.17.1736507117720;
        Fri, 10 Jan 2025 03:05:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGuvbejlVdVr7p4kKlExFJkcl9Wt/QK5sY9Qn7LGu+S/34NvHyblocEHBuzEuvT9apKkSVTyA==
X-Received: by 2002:a05:6000:154a:b0:385:eeb9:a5bb with SMTP id ffacd0b85a97d-38a872de3femr9378677f8f.17.1736507117251;
        Fri, 10 Jan 2025 03:05:17 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e2ddcb5bsm84774835e9.23.2025.01.10.03.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 03:05:16 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 10 Jan 2025 12:05:07 +0100
Subject: [PATCH 2/4] release.sh: add --kup to upload release tarball to
 kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250110-update-release-v1-2-61e40b8ffbac@kernel.org>
References: <20250110-update-release-v1-0-61e40b8ffbac@kernel.org>
In-Reply-To: <20250110-update-release-v1-0-61e40b8ffbac@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1234; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=GvVxfRTpG9NHuQlcYhKEbz5tLJqKGeVwvpASR4E785w=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0hv+vZ4875zW9b+PPsaxiLOfWeE/WcZr94utTH4H3
 UV2cc3cq/aoo5SFQYyLQVZMkWWdtNbUpCKp/CMGNfIwc1iZQIYwcHEKwERy7zH8D1jB4XtCv2dq
 dYbv3PmnrrEsZnMJa8tNyO6ZImmd67j3NyPDRrWTy+ekct36dXSeWesNhdffKiTP2s52e13GeFT
 jrO1adgBTskok
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 release.sh | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/release.sh b/release.sh
index b15ed610082f34928827ab0547db944cf559cef4..a23adc47efa5163b4e0082050c266481e4051bfb 100755
--- a/release.sh
+++ b/release.sh
@@ -16,6 +16,30 @@ set -e
 version=${PKG_MAJOR}.${PKG_MINOR}.${PKG_REVISION}
 date=`date +"%-d %B %Y"`
 
+KUP=0
+
+help() {
+	echo "$(basename) - create xfsprogs release"
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
@@ -52,4 +76,11 @@ gpg \
 
 mv "xfsprogs-${version}.tar.asc" "xfsprogs-${version}.tar.sign"
 
+if [ $KUP -eq 1 ]; then
+	kup put \
+		xfsprogs-${version}.tar.gz \
+		xfsprogs-${version}.tar.sign \
+		pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-${version}.tar.gz
+fi;
+
 echo "Done. Please remember to push out tags using \"git push origin v${version}\""

-- 
2.47.0

