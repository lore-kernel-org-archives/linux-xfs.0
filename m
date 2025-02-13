Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E2124BBF5
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 20:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739477771; cv=none; b=C7sbymP9E1tcoNiYxigXuUuD5Q1/bvjT5DHSsAzER4YCbPfLDcaoEdagafgi0LAPfpBYrRH6Ib2SnZFpx6b/loQ5L3gaM37I9ISnFIpA0orTp9FpaKweeDmzx7HIwJgGZo3nDbBfIaAMf/BjgByKPqfBTLsgwGlfX/ok1KBkRPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739477771; c=relaxed/simple;
	bh=/3wTB0dZWiuzHweqc57qc93adFoOrjqnjoE6PEajIGc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oCvQGM4MF9AEGIlLqcCF4fIdbeJO8mydC5TFaWLsETwCvkSyaZN3Diw3phN27U5EQeKK4oO0KurJbh3xz8qhefj1I1+vyWIWS008SzWPpWwnxH7BKoC0r6uWSiBUZzOCJZ8pCBUQ+OnKab+mUPOQmkAFtHnHRV5K7iESx/yiF68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g2Q/a22K; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g2Q/a22K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739477768;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nXeDJn2Hln3ymF19/vkeHhF/7YwfAfkD+D52rqv6Y1k=;
	b=g2Q/a22K2epW/8P6+ckAh4FIcLTdDT9LRCkgPOX1EgmfdhG9zOSWvAeZWeOINr+hikLQJs
	KTAgZxXJeyhzluVWWntwi/WorWNl5aSDTrEsgv7WuLf+OMvekiZeRODdTXwADXocmPzNic
	Di+5H5pkz6ezAYX3PuJI9rmj2uXYetM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-127-Q28v6uaRN0KMKg6QmP9lUQ-1; Thu, 13 Feb 2025 15:16:07 -0500
X-MC-Unique: Q28v6uaRN0KMKg6QmP9lUQ-1
X-Mimecast-MFC-AGG-ID: Q28v6uaRN0KMKg6QmP9lUQ_1739477766
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43945f32e2dso10650815e9.2
        for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 12:16:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739477766; x=1740082566;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nXeDJn2Hln3ymF19/vkeHhF/7YwfAfkD+D52rqv6Y1k=;
        b=QUgwVTH+f8rVwB8lXoxL/G83yUkAMvlsKEm5eC7TJWG0FoZh1UGsQ1kK5JYgndSwEY
         7xTdPxOmxYl7Q8iKSKZP/9bGqZ5bICH4SJSeG4G1uqr92YpRFIbsuxcdYmnlzGmsyj8e
         1TbEhQ9rQ9G2I6W+Gp0vqA0RR1fItl3pkbqwrgMRWZZ9aQVbkxf2HdPMm43MTram96hi
         5QQuGIVOsckdtoAkNC9WWB1HaheSrMSY6j1vds/rddHQ0pn/9FBf8if09x49VO/H3yKC
         friat04zEzxkJVIQJwdKE5xjm/C8/yHNs1FU8KbmkJUO7pl5vIsqMbpnTIMDMh/+YheJ
         ws3Q==
X-Gm-Message-State: AOJu0YwjeR1aK6bGSdaAR55A458XKQ0c8t7whFAaIzvwLuiEBgR/0azh
	rNKtj7Dc5snGt3IJ/MUf9ddMDC5K3Za1yDb7+vO2BVBDae1VgyTY/+Q3eVqei+FkDp77LwOoHgj
	Dv/kE2X5IXwhMYNV7LNP1OuxHfJEAts/3UQ0n6uPBYqOWiZjOvGfk19rmfsvGk7U7
X-Gm-Gg: ASbGnctZdWAr96/yDblzoGkqnwZ3QlW5GQm0Xz25l2KMi2mZvei7P1y5EXDUlZIwryW
	lt0VPSZM2HZSZZzeRm+HM1liU2GBL9Pc4uFvxhYrTZBKITRKKWYHiXDKLSTFJRv3NvLDYYGoukc
	mNHHo0unSOQ4DnVg7idrBvc8bcwvoPRSWgpTuvAuQOLQt1U3/iBvGj6E7XfruQZenLdfBYoYPF5
	afukSemuK8zWL93ThuUwzE1UNOe93D2Fq8qcwSzg7YzeSWq2vofeH7t/7FiSAmVC89PJWcSzeiw
	hP/bmwHr+O3euJkel4R32cUfa9XohX4=
X-Received: by 2002:a05:600c:4f4d:b0:439:3d5c:8c19 with SMTP id 5b1f17b1804b1-439601b7ef9mr63346685e9.24.1739477765836;
        Thu, 13 Feb 2025 12:16:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFiPB51e3ugUUKN8mtB0v6peaXkHODaveZJLRN27IX8lNnpE77dK6vxFY8+mTu8QCPU3RDefg==
X-Received: by 2002:a05:600c:4f4d:b0:439:3d5c:8c19 with SMTP id 5b1f17b1804b1-439601b7ef9mr63346465e9.24.1739477765503;
        Thu, 13 Feb 2025 12:16:05 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a06d237sm57520895e9.21.2025.02.13.12.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 12:16:05 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Thu, 13 Feb 2025 21:14:30 +0100
Subject: [PATCH v4 08/10] release.sh: add -f to generate for-next update
 email
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250213-update-release-v4-8-c06883a8bbd6@kernel.org>
References: <20250213-update-release-v4-0-c06883a8bbd6@kernel.org>
In-Reply-To: <20250213-update-release-v4-0-c06883a8bbd6@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1489; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=/3wTB0dZWiuzHweqc57qc93adFoOrjqnjoE6PEajIGc=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0tcF/YrZcVtY8vMZJuXFPtPyDhhnnp0TvHq308ulv
 CYX9B6t3ZHfUcrCIMbFICumyLJOWmtqUpFU/hGDGnmYOaxMIEMYuDgFYCJ7IxgZftW+b4t2vGX0
 4/fDR1FCe+WetTvfFK3xUFn9tldNdN9LC0aGJ8qxARZ5SdsPvV+79MFD9/VBzodi4s5FB35slk+
 fbnKYBQBPaEr5
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Add --for-next/-f to generate ANNOUNCE email for for-next branch
update. This doesn't require new commit/tarball/tags, so skip it.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 release.sh | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/release.sh b/release.sh
index 696d3ec107ca0cc11ed565734ca7423acfd6d858..b7461e958e6f55f7b8ccf31b53e2d304db11789e 100755
--- a/release.sh
+++ b/release.sh
@@ -14,12 +14,14 @@ set -e
 KUP=0
 COMMIT=1
 LAST_HEAD=""
+FOR_NEXT=0
 
 help() {
 	echo "$(basename) - create xfsprogs release"
 	printf "\t[--kup|-k] upload final tarball with KUP\n"
 	printf "\t[--no-commit|-n] don't create release commit\n"
 	printf "\t[--last-head|-l] commit of the last release\n"
+	printf "\t[--for-next|-f] generate announce email for for-next update\n"
 }
 
 update_version() {
@@ -96,6 +98,9 @@ while [ $# -gt 0 ]; do
 			LAST_HEAD=$2
 			shift
 			;;
+		--for-next|-f)
+			FOR_NEXT=1
+			;;
 		--help|-h)
 			help
 			exit 0
@@ -108,6 +113,17 @@ while [ $# -gt 0 ]; do
 	shift
 done
 
+if [ $FOR_NEXT -eq 1 ]; then
+	echo "Push your for-next branch:"
+	printf "\tgit push origin for-next:for-next\n"
+	prepare_mail "for-next"
+	if [ -n "$LAST_HEAD" ]; then
+		echo "Command to send ANNOUNCE email"
+		printf "\tneomutt -H $mail_file\n"
+	fi
+	exit 0
+fi
+
 if [ -z "$EDITOR" ]; then
 	EDITOR=$(command -v vi)
 fi

-- 
2.47.2

