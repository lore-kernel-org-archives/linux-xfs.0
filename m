Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847C026216A
	for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 17:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739294841; cv=none; b=jOv3ZAEwyPPEPU0SvnTIcu1lIpLtiTGEZ56xUOoZKLgRIcQyjc2t77wsGuBKEnhuT3oxUaH+cbQh8iR9WXATh0oHTTwluAlKi5GmasbpXweY0azv306GJJAC5aGyjjTwFR9MDuxfJtWM4TuqckiK4sjApyjLpth9o3BEfj3wi7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739294841; c=relaxed/simple;
	bh=k4JjaWjDKXkA2Ktr0ek0djzOAggrEZFk2s4xZ5LUkZ0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HPMhlRzLPuyEbvCIesET2uTDWupyk7cLXAFh1gDELPZQwTeGwxYe9qwiVKGbTHCHgMA3IMIc1uN2QP9Hk/vDx1eVEqq7Gf2t/5x0g7Cmmbfash1R0xrVlhgx8pMWDzQ6yWPRrwkILlE2gt8JT7KI9rL9Ch7chz+65W1qs8imJ10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hn4nqXI5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hn4nqXI5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739294838;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pbAFELYrrgqB0w7UVgfPzmVZdE/umW5JbrBDfQjoIg0=;
	b=hn4nqXI53VahxgAlbl0R/om1p5jq992VwmP8l+apLdhtwsqYxg1yBpMcPx0xnrp7X3EmqH
	hXsXvXIrGxaDwjHCMN6U5kIlFxafp356rcNhAXkdyzXWsaTCinxhQhE9AcKjDTfA8cEClx
	XgO6JtNd9/NNjQ4As+V/CckWjz2Ns+4=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-s4rTzq7_ME2WlEbQz1QEVA-1; Tue, 11 Feb 2025 12:27:17 -0500
X-MC-Unique: s4rTzq7_ME2WlEbQz1QEVA-1
X-Mimecast-MFC-AGG-ID: s4rTzq7_ME2WlEbQz1QEVA
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-ab7bb1b91fdso200141866b.1
        for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 09:27:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739294835; x=1739899635;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pbAFELYrrgqB0w7UVgfPzmVZdE/umW5JbrBDfQjoIg0=;
        b=XWjM06L7tfWCHhc4VxDFHWRom2wIZlrKUh7fSJh+/OxV/ZWYcJgY9X/PKLCqLmYR+O
         q+jbpP165iwXMH1XPrIZGXtuJc4dwpmyg8Kx4C+9uMxmdzQ3HC/ap3S1jMbFS+QtwBgB
         fC0zKi5w0NXnD5eGN862VkcDqP/orCI35XXQS9n7QKr6STuzzbQDA5t1nyOkpZ3jTC4O
         P6XlMJbW7vuUQSdoT3nXZWvp+ZUM2IrrtVNNjPI5YWL54goL+Bmh1xiOhVfxyvTxUaoP
         dTmxuZlw/RLDnwfqi6BUQjcMsCpRfUzgX3gLP9pGL+GI+LbEkvVYOQnKmNreFFZCUp5A
         GRHw==
X-Gm-Message-State: AOJu0YxF6ZFtQ7OjQoYgKA34qYEdJCuP4kXmwI10GDiSKQZqKGB0tIAI
	zlwuvSRCP12nT/une508ULC1sIcs6eWL6k3g5ZLVxTMGH1sp52OCT1RVomfAyCUbhn8Kp+ZE9ir
	qRQYyGtWNb6x2L+uMe5jWOiBt0p68GTe6h91GKH3c9hc2X2H0daLQsjamPDlxvMLRT1A=
X-Gm-Gg: ASbGnctpBU+x+gIH1soPp51rnUrYx/16rfpyay1vjgeLakQxD88zckl5oPkktX0R+NH
	RUporc4f3Sh+DpfnEBTIH8ffVgxBTbWQZRPcoedoR3AhnJBxfL6XCYwL/G3GvahqDuV+jnafQEf
	4xEvvGBZrHuvaD2UDiosxIYcgmSmb79i7iqhkGnN4q9uZW6zpMaHG1W70NFMpcZG19xuspaljM1
	MHKR7ahFpfRM/AL2+2z1us63ubE/ZwEyoj2NcVIGMwfU0FCQTYyHlHjEWtmdj7kl/kaZa0tyTVw
	eb1LXgBQuX7oN5INqhW3dIKGgLkSql8=
X-Received: by 2002:a17:907:3ea0:b0:aa6:7165:5044 with SMTP id a640c23a62f3a-ab789c3aed3mr1610088966b.44.1739294835542;
        Tue, 11 Feb 2025 09:27:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEFsqNa89lw3eFnmb2ieMnHHDl6O5O2c14ar0mOQkzwUUI8G2MMhVZWzuXDlaS2WNcKObpZwQ==
X-Received: by 2002:a17:907:3ea0:b0:aa6:7165:5044 with SMTP id a640c23a62f3a-ab789c3aed3mr1610086766b.44.1739294835130;
        Tue, 11 Feb 2025 09:27:15 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5de5ced9758sm6914335a12.76.2025.02.11.09.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 09:27:13 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Tue, 11 Feb 2025 18:26:54 +0100
Subject: [PATCH v3 2/8] release.sh: add --kup to upload release tarball to
 kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250211-update-release-v3-2-7b80ae52c61f@kernel.org>
References: <20250211-update-release-v3-0-7b80ae52c61f@kernel.org>
In-Reply-To: <20250211-update-release-v3-0-7b80ae52c61f@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1359; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=k4JjaWjDKXkA2Ktr0ek0djzOAggrEZFk2s4xZ5LUkZ0=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0ld3FLxY3LB3yb8JL58+q1SclDfJ+hPXrwlSPSwFU
 8Pn2/eYSE3oKGVhEONikBVTZFknrTU1qUgq/4hBjTzMHFYmkCEMXJwCMBHtu4wMC03qG9vnGJuJ
 prYoZs1KfuGheWfS7GvVpdcf7a+N4Uo4wsiwjys05tWKoG39q3akP6nPNNwbvHEK60vjG9vPxKy
 vfynLAgANekmz
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

