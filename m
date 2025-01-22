Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667F3ECF
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 15:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737558117; cv=none; b=JNxiTxkEMMnSAQc3SH6uiz4H3vmh2ICnDv6xW8sEtddQf+/AtFAmb7fULQzSBZrxBK7eX6qHOmqD145dGF07jHlbUMgwfK7DBBjMCrOV1x+epXwPg+wn7p33rj4CBx+LKBZ6Vt4zr0ixx0hydXBBP2GPo6lp8z/yscxgaUnOPKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737558117; c=relaxed/simple;
	bh=DhoIS4LpAXTaU+j4RaTP0n4Osdzajaf1vg8VP1HOQj4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lLtiJNFd+6F8jDGwi9nTQkUxJbWoF9gTrWIpx9VmZgNCYEQ/a2aWA4VfSWr1kLX2F2t5kRccLu2VCrrRGjseEjScXq7iFfB2QQ6LAfmMyJd0xDWLypeypBzBcG+/K5V5eS/FYm1pH7GuVic37TXC3e8TUHRyW/tTqHRLEPlAEys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cVTcWP7G; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cVTcWP7G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737558115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gqPDDFe4X8MUDyudp/mtiktDnpxqiHC7K/6IWumjNhM=;
	b=cVTcWP7GOca9heTg+ND5fgSjgsvDeBcc3c+gGORsYT/LEj1GwOLQjnJqT10ANvWF6MR/6A
	ImLgz0fPNWilyY1aNKSbLlcmCuVdsNpAhxGUlkldaoxQ9D7hwRn87JUT0egAw8Wf3HO/Eq
	s7c8EyubBMGadznSQZFX20b5yCxBUWY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-GTe_QbGRPz29idbnR-n1yw-1; Wed, 22 Jan 2025 10:01:52 -0500
X-MC-Unique: GTe_QbGRPz29idbnR-n1yw-1
X-Mimecast-MFC-AGG-ID: GTe_QbGRPz29idbnR-n1yw
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-aa689b88293so730411966b.3
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 07:01:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737558111; x=1738162911;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gqPDDFe4X8MUDyudp/mtiktDnpxqiHC7K/6IWumjNhM=;
        b=iRRFFni0Ko84/kYvwjaPbIymiD0b/yrJjVmhlS/gTPMsr/IFdAj+fxBwoqvXFbWmqH
         qSXhsBvfhNze9jLk14mh8EqQVz3SU6HTP5KuVaDKDlxBHVRKfKcu6fzwLq2h1FscsMrb
         +TM0v5TA5AC7lVx+P0r4xKYsJB6EjWGtfQ+j1vQbvbf2NKFkTXHNoL/MB8Zc5VecHOMY
         EE9rD88nn6h0VafprAYJK+oGFXghrv3SLgGMuxzSNF9zHdsibrDWDbHlUhlLXdKN/COp
         rC0byxebXXJKe6u4NjbSYHupwHHxW6dORI6l2dEdJF2wRwwZx9s4PzGyEXeQliXkIj5y
         9nhA==
X-Gm-Message-State: AOJu0YzghjHh5Kqekgj3UFdOKtUlFSvISEMpAG7lB0+uMNKZMVlu2tw4
	MammBu2gDHyJIrV+GcbcWRrhPHKqStUgL5B/GGCZE2Gp3ZCXotfu3g2KZ8ErQfwMr5VYOlWUfVm
	h2V/Clp2RdL4ZPdgidXK5n0mPh3tmjHrxzki9yzK3H7y6pgpxmdZFsIAm
X-Gm-Gg: ASbGnctlJmaWBZ9R5zaob3gcOaA7nLjS5VGYVGbs8yjdlNHiOa5Vwfdaq2hjmX8FMCy
	d6aF+lW69hBk6cGQZOiFAZTe2q0S4C6NNnxDZ8e3zygxxSwvZb58HZf2fp4wMZWuDnBwWhSeJ2s
	tYcwHg0gp7xaF6lOjRy6MPMyJH7vJBOBb/SxZy/DAy/tCyGz2VCA9jej9yfxfq5XdzSaiHopG6N
	iyxfnmPMxYXVI34oFymM7Sf3qUEEnWt1kJIjWR8B9GCXZHG+APdlNhgDhEVgrP52ainTvi0TR6B
	C7/PPLuZYImZiW+DhePP
X-Received: by 2002:a17:907:3e12:b0:aaf:208:fd3f with SMTP id a640c23a62f3a-ab38b10f4aemr1830207566b.13.1737558111277;
        Wed, 22 Jan 2025 07:01:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE8dBh1bvv4mCOXYv6oYBFePe2BNFtL02dPi3Xb0443F6m+JCO3NPeil6tpw6FWke5qBSJUUg==
X-Received: by 2002:a17:907:3e12:b0:aaf:208:fd3f with SMTP id a640c23a62f3a-ab38b10f4aemr1830100366b.13.1737558100240;
        Wed, 22 Jan 2025 07:01:40 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f2303csm925653966b.100.2025.01.22.07.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 07:01:39 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 22 Jan 2025 16:01:27 +0100
Subject: [PATCH v2 1/7] release.sh: add signing and fix outdated commands
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250122-update-release-v2-1-d01529db3aa5@kernel.org>
References: <20250122-update-release-v2-0-d01529db3aa5@kernel.org>
In-Reply-To: <20250122-update-release-v2-0-d01529db3aa5@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1953; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=DhoIS4LpAXTaU+j4RaTP0n4Osdzajaf1vg8VP1HOQj4=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0idyBKru/W4guMjTS/tSsckmfgG77ytfnrrMseSeR
 4j0mYA0BdeOUhYGMS4GWTFFlnXSWlOTiqTyjxjUyMPMYWUCGcLAxSkAE9nCyvDfx8NMXcxV49f+
 poy5Iiw5y/WvsWW1e1ip3lz7No9FVlGa4a/AU3+Jx7WFL5ZeNPpd7xXz5eb/NSfDjaQvit95O9F
 tVxojAIVsRCM=
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
2.47.0

