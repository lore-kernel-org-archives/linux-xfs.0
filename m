Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D9E24BBF5
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 20:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739477764; cv=none; b=eY3CdOvujC5hAnGH6rhdtB+iBfqiYk9Rl+8B3gFl/GgPuPApYvm+jlWxrtvm5yPFmxaj5gyAPUrIhywM8oHtOnZWDcNX7dVe2H2A52YqwRExol6eFrkACDRF9etUKE95uSaGzhqqESBsmeZ3SWXDpU9ahdEioSKC5mQJsp2hOPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739477764; c=relaxed/simple;
	bh=k4JjaWjDKXkA2Ktr0ek0djzOAggrEZFk2s4xZ5LUkZ0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=itt3GPKO8SqS54Co3DTrVZVYwlgcRiIwebxSUchqXXHWOXChoqL6uAbWy5fG9d4cS3RTyh43D95QwCUtz4G+m2Ych43ZS/38yR3okjoNpX29srerBGa9hUG742QCQ+ycqoMKqKigeOmcr+vEzbLvPLXtAxIm/L4tIDX8OWqHkb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H95TDcbT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H95TDcbT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739477761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pbAFELYrrgqB0w7UVgfPzmVZdE/umW5JbrBDfQjoIg0=;
	b=H95TDcbT2Ndisltgf4CEk1CqPrilcjBUIUAbPTaK9HxYugitPgct4m8C/w6vq4pLP2oURG
	z9GByypRWCR/Gor8vVXCCLUYJPtuNROCtxGvcQ5uKO+3m0mqGMCfr7Q/QaG5EPlimPKGdZ
	oODsIn5zfnGdNiV9Uc5rfFnFHJEmBAQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-119-1xQHjMaVMh2Rdwt1s64oRA-1; Thu, 13 Feb 2025 15:16:00 -0500
X-MC-Unique: 1xQHjMaVMh2Rdwt1s64oRA-1
X-Mimecast-MFC-AGG-ID: 1xQHjMaVMh2Rdwt1s64oRA_1739477759
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-38de11a0002so1346371f8f.3
        for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 12:16:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739477759; x=1740082559;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pbAFELYrrgqB0w7UVgfPzmVZdE/umW5JbrBDfQjoIg0=;
        b=SKxXwjm1uU6mTsTpzQ71GESrCNrw/5APCW2Mt+yA87OdumhaG3ppvmB13UkkgFzdvc
         fXxisGKjWS1pfd1oxs3+PWSGXz8pJZoK1vWyh1MC4Wcg7uOi2YsqtAEYKBeIip01gVoC
         LVrjjDGUUcA7LnZFr28qP4MK2fjr3X5rYrc7y+U2O+gC3l9lR7HWUSRgn868PVzoyrTJ
         1NXftJsFWq4tqkNdGw9EUOQq489I56rPq5B/HmEEGmix+5TAISuZkcKMUdLR/Sc2u/BW
         Un5ynXGWUqzdBHaDY/gEQrQM8bGBB9233eArfScBlFA3SJ5KgOQYgqnNAl5bXvYrGk0E
         WxgQ==
X-Gm-Message-State: AOJu0YzMvas+lVbIqEOGnfcxxqQj1MV0lTLiWliO1+0DWFW4d0Rfkdsg
	F+0VeqCbChpjeddRJP2D4+YJ6bVytS/eqwkXsq+kCCS7M0hmTXHbgCymsLLDDf+NnLaM9DjjErn
	zYSG/CzTaYclKaHM+hsC5Rb/LtoIASTu3m5zoKAOelpLrlqttlBscrVMZ
X-Gm-Gg: ASbGncvwUH+r9IaNH3ltHa9W4EPEsferVqSEEok0WkjhHV0rrWWlJuEHefPMfzvTF8O
	29MnmXdeEigVmMdbZ+U+StdV1jiVrfB5LShhGBpUo9AuoyORa8SbTwRyhQqjDEk22ezaJ+qb8YC
	cT+TzKTueQTxGNwzc0acCJn01pX/v+3OZA1728RIOq7j24HXnagxqHN7I9Evgz9OFtq5FbNZPqe
	SFtRKdfsHzvH4hqc/5cDyPuo/DsPQJXUQYnNS+4Jti9toHgK232M2uT/EBW6HO4EDCshGo2hDer
	k6E/xPB7sMcXjQzKa+zrdngYIYs7r98=
X-Received: by 2002:a5d:5188:0:b0:385:fd07:85f4 with SMTP id ffacd0b85a97d-38dea290941mr7424190f8f.31.1739477759109;
        Thu, 13 Feb 2025 12:15:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFwnnhMiMFGDRCJ6LRhaQLilLPS+FzUwf8s4XHK+I3i6f2p4k0zydiOybtOaGGIh9gSzzIH6Q==
X-Received: by 2002:a5d:5188:0:b0:385:fd07:85f4 with SMTP id ffacd0b85a97d-38dea290941mr7424173f8f.31.1739477758763;
        Thu, 13 Feb 2025 12:15:58 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a06d237sm57520895e9.21.2025.02.13.12.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 12:15:57 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Thu, 13 Feb 2025 21:14:24 +0100
Subject: [PATCH v4 02/10] release.sh: add --kup to upload release tarball
 to kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250213-update-release-v4-2-c06883a8bbd6@kernel.org>
References: <20250213-update-release-v4-0-c06883a8bbd6@kernel.org>
In-Reply-To: <20250213-update-release-v4-0-c06883a8bbd6@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1359; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=k4JjaWjDKXkA2Ktr0ek0djzOAggrEZFk2s4xZ5LUkZ0=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0tcF/epSrUzK+L/+uNRjo5ZJPNY8rP5pBqZ/dJg5k
 ksqJAP8pnWUsjCIcTHIiimyrJPWmppUJJV/xKBGHmYOKxPIEAYuTgGYSLIJw2+WK5sl76be2MH/
 i0dz+5ztP6bvXZzKqr9bY1pl3qlbD42jGP7KHV9gGLRI+6gSw8Ibi1LnzO+v/di/WLAku+JJZGm
 h8QluABPpRn4=
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
2.47.2

