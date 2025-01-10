Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799FC209F4C
	for <linux-xfs@vger.kernel.org>; Fri, 10 Jan 2025 11:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736507125; cv=none; b=CxVYldvknTiWkMpMwylV/rM0iyfCrDzzxfrl91Y3oEKk13U2P7pUK2gAl5iXU+HI88cD7YOciEP3tr0KjbAX0kAhW2+Nm7OMGy52HPhag6Bix9M5OZFg5ouhLOfiLWqS0EqZ45Kv93h80kOHUGhxSxVPMgeoJ3o7ZPqfieflZy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736507125; c=relaxed/simple;
	bh=Z/9yNkTOOqXxPx3g30q+XxHGBo3mwl3H4a6V3lKiubg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=U2DjR5IpBiGmd6RL3kUPFy7REAL5BGuEVKunGkYjv2qQcJWHefbvmvC2eJbzByvHZIM6+4gwWIsvl5QE/+4yJbLbtzILb7dC60ZTAQ4qRMXiCeL+jgL9Z4Oiu2yBlKfUaBmbwTTGSba+OldK3TJBlAu6gqYEIDN4WPsbIHV1pbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PWkucXQ3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PWkucXQ3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736507122;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hhS4I8YCLNBEYd3uUtYD046Fsw6yKxXpQpanSh5tnzo=;
	b=PWkucXQ3UC8YJCXJ2Jo7VKDNfQbK6KV1l2WHiuRPajsAU+iUu9QMqOHUr1SSc4CgpxTk9o
	+Yk/pcs5/+t/ktG5TvmxedpiDjHEK5iuZFbD3BcCComJ54wq1S6Q024gMRiMFCxawDienW
	VmxWzD/v3GuHTTwqOJNdzn8pyxdHO6w=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-324-k6IlX1gzM_iCkY70VlQbcQ-1; Fri, 10 Jan 2025 06:05:21 -0500
X-MC-Unique: k6IlX1gzM_iCkY70VlQbcQ-1
X-Mimecast-MFC-AGG-ID: k6IlX1gzM_iCkY70VlQbcQ
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43625ceae52so10499355e9.0
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jan 2025 03:05:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736507120; x=1737111920;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hhS4I8YCLNBEYd3uUtYD046Fsw6yKxXpQpanSh5tnzo=;
        b=ebRPDNIaPmRLkeakpZuMPDoAr0a2D9TD+k1tn32EUp6PmcBS0FKebXZzgrZvQsJduY
         fE69QWCDloqz6LTFQI7hfX8rump9J4BtGroErXujBf5wUZilHKqreIyfSE6mslYXjed6
         jExlD6r0i8iPWYQ0LWJMYblOdc5Vlo6Al6J870Yu88+ovO4489j0Cc0sm6QQrV/kd0/F
         Sdnz9cRC8Ilttj1xihRcMIHGp4E8rVjOom4+ILtk5UL+jdC5NpSUo8ZDF2b5W8OlcnmS
         WVWqEHQRNZh4NdfjmJ/QAe5SQbFln7nR6vU5CfrKqkaB1TwVSghVucEYRcf8AMWzsgCT
         kAPg==
X-Gm-Message-State: AOJu0YwZzdYG0ATCD3ByU8nYWWMGfM8r5dkYCnRFW2+xEnUKtBR8lPIt
	fyPZEQQKecdHuE1xpfsIMSoWVdpweKk+XdBSUJPGkZaj7aTbrmk8w9jpVq03PQ8ceDYwXuxPoCI
	EYDkvLC9Ep+qkNVVSYvImbYlsN0HGb2DeLvP8lN5kUy5zArCiCHHe20u9YHbWFxsJy9WBiIyI3u
	7s0l7iVMB1jDqohai+VJAC8nBARUbbTrKHSxlgaZnR
X-Gm-Gg: ASbGncvMWE5J/Qu2nO7nHKfKe6qX3AZssJr1YnX+SamZ+cvL+A4kvhyGD9C7wQnH43Z
	JPsQNwifBUM9ZqmF7q1GEVWFtxuYChMU92yuSj7EEE1ktCyTd2hF74ra7cn+W/XJGxZDHAqnrMA
	MTUxbkvmmGCSoWmbDteAtZnE+Lo0FdAPG8r9Fv+MomfNbhxx4mbqtJBYCYARndaoBMTM0TxIP8V
	I1xI1y4dAoPAw8X5/U5dYbZaaBf+GbRcMpjK1moJWR+GfhI7G8vbsoma+0mTnhey2/AmjiWGsOV
	KSjXPrQ=
X-Received: by 2002:a05:600c:25a:b0:431:547e:81d0 with SMTP id 5b1f17b1804b1-436ee0a061emr40215395e9.11.1736507119858;
        Fri, 10 Jan 2025 03:05:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGS5dr39aad+GTH0gDcsJO9k7Kug2mFZ2OM9EJITrG8nANyrWbUiG4fpwjrPOk5jGOQ+6qtnQ==
X-Received: by 2002:a05:600c:25a:b0:431:547e:81d0 with SMTP id 5b1f17b1804b1-436ee0a061emr40215005e9.11.1736507119445;
        Fri, 10 Jan 2025 03:05:19 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e2ddcb5bsm84774835e9.23.2025.01.10.03.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 03:05:19 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 10 Jan 2025 12:05:09 +0100
Subject: [PATCH 4/4] release.sh: generate ANNOUNCE email
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250110-update-release-v1-4-61e40b8ffbac@kernel.org>
References: <20250110-update-release-v1-0-61e40b8ffbac@kernel.org>
In-Reply-To: <20250110-update-release-v1-0-61e40b8ffbac@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2164; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=Z/9yNkTOOqXxPx3g30q+XxHGBo3mwl3H4a6V3lKiubg=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0hv+vT4pcXT9Zp1VD1QntF99m2aevnLNickcWZwyC
 qcZdaskWfM7SlkYxLgYZMUUWdZJa01NKpLKP2JQIw8zh5UJZAgDF6cATOQ0AyPD58caW5d+1LkV
 dtc55Gxu6tUM4Sdcleb3tb8/Fo2u3bWwnuF/dsjbvAtun6oUiu8X8TF9OZJR47J9xzm+yxv2xIh
 tnqbACgDM1UoO
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 release.sh | 46 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/release.sh b/release.sh
index c34efcbcdfcaf50a08853e65542e8f16214cfb4e..40ecfaff66c3e9f8d794e7543750bd9579b7c6c9 100755
--- a/release.sh
+++ b/release.sh
@@ -13,11 +13,13 @@ set -e
 
 KUP=0
 COMMIT=1
+LAST_HEAD=""
 
 help() {
 	echo "$(basename) - create xfsprogs release"
 	printf "\t[--kup|-k] upload final tarball with KUP\n"
 	printf "\t[--no-commit|-n] don't create release commit\n"
+	printf "\t[--last-head|-h] commit of the last release\n"
 }
 
 update_version() {
@@ -48,6 +50,10 @@ while [ $# -gt 0 ]; do
 		--no-commit|-n)
 			COMMIT=0
 			;;
+		--last-head|-h)
+			LAST_HEAD=$2
+			shift
+			;;
 		--help|-h)
 			help
 			exit 0
@@ -122,7 +128,45 @@ if [ $KUP -eq 1 ]; then
 		pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-${version}.tar.gz
 fi;
 
+mail_file=$(mktemp)
+subject=""
+if [ -n "$LAST_HEAD" ]; then
+	subject="[ANNOUNCE] xfsprogs $(git describe --abbrev=0) released"
+
+	cat << EOF > $mail_file
+Hi folks,
+
+The xfsprogs repository at:
+
+	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
+
+has just been updated.
+
+Patches often get missed, so if your outstanding patches are properly reviewed
+on the list and not included in this update, please let me know.
+
+The for-next branch has also been updated to match the state of master.
+
+The new head of the master branch is commit:
+
+$(git log --oneline --format="%H" -1)
+
+New commits:
+
+$(git shortlog --format="[%h] %s" $LAST_HEAD..HEAD)
+
+Code Diffstat:
+
+$(git diff --stat --summary -C -M $LAST_HEAD..HEAD)
+EOF
+fi
+
 echo ""
-echo "Done. Please remember to push out tags and the branch."
+echo "Done."
+echo "Please remember to push out tags and the branch."
 printf "\tgit push origin v${version}\n"
 printf "\tgit push origin master\n"
+if [ -n "$LAST_HEAD" ]; then
+	echo "Command to send ANNOUNCE email"
+	printf "\tneomutt linux-xfs@vger.kernel.org -s \"$subject\" -i $mail_file\n"
+fi

-- 
2.47.0

