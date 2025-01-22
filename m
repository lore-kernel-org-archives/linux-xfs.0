Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC78ECF
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 15:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737558122; cv=none; b=jJauJ3tCOH0AGq2mT2BF3u7PQNIT99C6MfBEnZJIilLE0o0UMVmQdKT0J+VZ4lutM8Izi6Rajg5DvMancmr2srpYzO8LYi3IpEIspOADfPfRYr7xpu+49XM2BaHOZythhIDVqDUML6V1AO4Bqdw3eD5PvUJkFFowNhJCjsxS8fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737558122; c=relaxed/simple;
	bh=zfY74ewYuNTKognc1+W1ZHXOd2aZc8BpDDePAj4HKgA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mHRfVWYZohQRNu5uRsg64zUPxz1acLOmjKs1rx5CsWXjHfzDp3nlqW5Fc/yYP8O/2tgckavI8UF7yhpW2ZgqRLWfL/7bYipnmKkGkGj1SbJmgSKYBQdikoeRChJYwUtxeZWV+m2uQrpEHDBibaeExRwa37rLJ1N4LR5KuaC8JxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HcoTT+iX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HcoTT+iX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737558119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W8hVNcD02eppmlHwBK5gPIPKCPfjbHT7R3HSpZM7aoA=;
	b=HcoTT+iXNli4EoEmUaUMdm5lqHUc6MDp8cV8HCHlLPuXsI7Y19qSvMMwDj/5sACInHaYzD
	a1gC+fXoZolx+gNVmeY2lohemwaf7YxLvKLrlRf46PrMErsplrIw+jd/LIifkY25jzoXhd
	i8tdaBDnyemWYFqtagtsQwglOKwW/PI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-298-ufQ51OFkML2z5PZScU0UGg-1; Wed, 22 Jan 2025 10:01:56 -0500
X-MC-Unique: ufQ51OFkML2z5PZScU0UGg-1
X-Mimecast-MFC-AGG-ID: ufQ51OFkML2z5PZScU0UGg
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-ab367e406b3so616876966b.0
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 07:01:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737558114; x=1738162914;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W8hVNcD02eppmlHwBK5gPIPKCPfjbHT7R3HSpZM7aoA=;
        b=IwizQMTHGPuFI3weOPwAyi6NG4140uYVr+E0mwgV3ISaXYd/DGDzyWde4y9iWdHfld
         3g03t3FyRr0UCzjfl+RTLopm+cGTnV3jRGKJWOpSgXkglecfRrjsiw8BGtv2fOjQ7S7B
         Mr6j5OTIs0bX7lRrqzMatXfvvviaKkDrDEU2dec5jdCf3O0I6XEpGLqfSBWLKSVUIwga
         8zZN/HA/BMGEZNYtpxDI60/Z7VUO2LVvLY485cB+6/8O1HqID3nhq/xV7/dpWxlVab+X
         h6WIfoI0oGkc1LoHDT93jIthSVZNwFPkswzr8gKxqf3cl78agT0QZjF9ysXXOtCk+iKj
         IgQA==
X-Gm-Message-State: AOJu0YyMhU4eZD77EXgLzWhEQYpPHnYXDbsaN8NICXT2wkaI9F8FwV8N
	fExO/I/mh151NSLWRX/A2wW7+sq0hqKwdF9eQs1iHXtP/cDBI9ntf82AVBAJnGlY1MMjBhgy9Q6
	mbppai6InQ4aPqbrj6k28NACEC9m2ZvqQyavmZjh4QoUieMsCsLSx1neKb1mo0eyN
X-Gm-Gg: ASbGncsKKglp4yisr5LJCnf5DeUUAxRg3PXxaPOXzxscbO3FiRvLqwdNQ8lI5sHpSum
	baNthqhr0P1cyyFNzzD0AmQLMgaIRGsoxWGYYJmB52DSl08aZIRqdEIBR82bxKnCIl+n/bL10zn
	Qn2LkfrZpsUFFFkIO/fkJdyD65apU032k99izpOPqQJJ+tqrfG/VM5OxB5kRNN7BPnD5hdh3QzS
	ntU822Uo20qcK1g24gnXfqKvu9kbriLy5Ra1U2Ejw+cXHinhc+Cr0CONn2Vl8YXG3/vo03nCtZO
	pFoLHbIjyU9c/rqn5QLD
X-Received: by 2002:a17:907:706:b0:aa6:5201:7ae3 with SMTP id a640c23a62f3a-ab38b3b23e1mr2309471666b.40.1737558114015;
        Wed, 22 Jan 2025 07:01:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFASXwdsRtoce3XQWQKVzqPrkiskLnGKpawX9BvMgtwCFwfL/yVyNl1J8S1q7i7K1MbshJ9xQ==
X-Received: by 2002:a17:907:706:b0:aa6:5201:7ae3 with SMTP id a640c23a62f3a-ab38b3b23e1mr2309459766b.40.1737558113146;
        Wed, 22 Jan 2025 07:01:53 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f2303csm925653966b.100.2025.01.22.07.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 07:01:49 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 22 Jan 2025 16:01:28 +0100
Subject: [PATCH v2 2/7] release.sh: add --kup to upload release tarball to
 kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250122-update-release-v2-2-d01529db3aa5@kernel.org>
References: <20250122-update-release-v2-0-d01529db3aa5@kernel.org>
In-Reply-To: <20250122-update-release-v2-0-d01529db3aa5@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1309; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=zfY74ewYuNTKognc1+W1ZHXOd2aZc8BpDDePAj4HKgA=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0idyBEolCd+7wPH/QSNjvmdn3nb/YKODc/pu+3Nah
 B+0VZDa1dxRysIgxsUgK6bIsk5aa2pSkVT+EYMaeZg5rEwgQxi4OAVgImz/GRl6Xzcynz304fXa
 s3dPFgQ8nJf5W+Otk12Y+7oKv6qDXn0HGBme5yT7/N5hffPsNsWQAjZjo8jZtyaUxL/wzQkInr/
 tvAIDAGrsRvM=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Add kup support so that the maintainer can push the newly formed
release tarballs to kernel.org.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 release.sh | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/release.sh b/release.sh
index b15ed610082f34928827ab0547db944cf559cef4..b036c3241b3f67bfb2435398e6a17ea4c6a6eebe 100755
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
+		pub/linux/utils/fs/xfs/xfsprogs/
+fi;
+
 echo "Done. Please remember to push out tags using \"git push origin v${version}\""

-- 
2.47.0

