Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C746926216A
	for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 17:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739294847; cv=none; b=LfOvFfaENd5zla6AEvhky6sOLdxLOzliRdCo331JF4pKkJna0DuoCoUV2IxJv6CAckiHruwe8u9d/hj8Hg5dSCohlM3ATcOZ0B9LnNE54OZ5HuvgE6MK9NVT6rWYnAMpRtwm6YHzXjZyPQgaVeijekWYH69qCFGi+cx6AGGCRA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739294847; c=relaxed/simple;
	bh=q2jjmOoI3Jc56QOxq0s3YbodR2pEPVnXjX/EH19gdnM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rSOHbhvydbRNHqilA1MVWso5bUwFxBr5frfLs7pvz+PhsFTWaj/hKjs1zEJAD7N7rZUjb6qZBBrbpvRlERSF0Wf+x0Em7S6pL4fLAQLNZY70aL/LaVUjqxQVic44Dn+AGwbycWkHtEObuXdC/DUCh4D1cZiVIAr3rH459EVrNoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HTyXs91l; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HTyXs91l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739294845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NWhtlxZ2nSf0EftYvO1VR2yRAhkH4Oa6sssf0L4LsKQ=;
	b=HTyXs91lmdZDRY9ZMdrGyMcBtdFV723yqoBMNT7G4GzXjN6TwsRa981+8KJ0cXNaKuEA5y
	hTdbSstz9ezRX8GEhzkY33FBzxQOGby8OrXEiaoz9dqnUeGfvgkFoP0iA4dx8mX7TWbcGo
	zagZwO2yHu3KkFAfvLUlw89UbbZ2hec=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-384-M0OZRTQNNICW6OaoNK0yWA-1; Tue, 11 Feb 2025 12:27:23 -0500
X-MC-Unique: M0OZRTQNNICW6OaoNK0yWA-1
X-Mimecast-MFC-AGG-ID: M0OZRTQNNICW6OaoNK0yWA
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5de4ae51b71so4160065a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 09:27:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739294842; x=1739899642;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NWhtlxZ2nSf0EftYvO1VR2yRAhkH4Oa6sssf0L4LsKQ=;
        b=YUftsHlA4dNfAvBvMyTMMUk89ub+gDl2Hld/mYheitSAdt8+ieOmFpFUOWvNZ0M1cj
         /F5FmBLGwGxECjfqrSIwAGxwILTC3jBvERSmSX8e5Yiv2N8GyYxGWbZB0r+T/R659MGl
         JK/x/2+z0FPWYTf/SWuKcXDQGsO8nzsOuetSu4pk8EncEk9m6lBBptCVxg4L/vNFFEBE
         0bFmmscRnOb6OdQ4QHWO0W4CWUwCabTn9+2JMPYN/R2jIrDMCZfHAEji7lH8Qh0Mue3+
         cm+zAdDQfd385SEMo2nzLLV5/jctZPyY33MzkafCeyFaA+2YwvcB7DKrMQp/+FahnZ9c
         VrGQ==
X-Gm-Message-State: AOJu0YzTvJGswh1+dy+4vZz6vuERH18ts4BX7fAmEdJDRTu7H1EComGI
	W5drRVNT7N9OitTx8e9IdGuHxR4pGfeFOWXD2O9yFvul+DljxHlvSSgX3SwpqnvuTkqyQE/kmyv
	Yns3tjXROTgtblA59lJ1npYt5ih0Y7s/RkgJTiOZ8ujHkbhuAXYY1TiTr7o3F54OleZs=
X-Gm-Gg: ASbGncuxFg41qNmsvvX4MMl3TPo9RSZcfOEx/9dmfy1xaScza9MMllpLqlZoVaeE5HZ
	83PRk0L0GlrDDiILSyxUhXVKZvM3o/eiXmpE6xFFOJ+dvtFyTnXf8bVb+viCT5yHiWnIaDAd5za
	OZ4YOKiQXr4+orRFTVAFaaJean6mgRtDSwvGi8xgPEF5OGwVU8/3h9mydYmMfROkhmqtLByxiiG
	f6O6ckgTpvHT0Wlwy0hf0f3Ux6GserxJ0g05pGRGNnwQNyn9TUYk5ypucCr2GqzmtOFgiSUieyj
	SVsdUTNTQ9C462sMffZ46v0F/RiJAXQ=
X-Received: by 2002:a05:6402:4316:b0:5cf:e9d6:cc8a with SMTP id 4fb4d7f45d1cf-5deade00a52mr6364a12.20.1739294841958;
        Tue, 11 Feb 2025 09:27:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHW56lIsf+2plTIdVn6fNs+yfEckFwouMyvCjFqNHDx1edgvWn32ycgGzBqaXAmf8OLxJBHXQ==
X-Received: by 2002:a05:6402:4316:b0:5cf:e9d6:cc8a with SMTP id 4fb4d7f45d1cf-5deade00a52mr6347a12.20.1739294841530;
        Tue, 11 Feb 2025 09:27:21 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5de5ced9758sm6914335a12.76.2025.02.11.09.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 09:27:20 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Tue, 11 Feb 2025 18:27:00 +0100
Subject: [PATCH v3 8/8] release.sh: add -f to generate for-next update
 email
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250211-update-release-v3-8-7b80ae52c61f@kernel.org>
References: <20250211-update-release-v3-0-7b80ae52c61f@kernel.org>
In-Reply-To: <20250211-update-release-v3-0-7b80ae52c61f@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3858; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=q2jjmOoI3Jc56QOxq0s3YbodR2pEPVnXjX/EH19gdnM=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0ld3FPRHnLm7MyTc6PHmjbN2L45cMznrpw9bFevbF
 SYH+v/VtyV3lLIwiHExyIopsqyT1pqaVCSVf8SgRh5mDisTyBAGLk4BmMhWc4a/4rJPOL/rywe7
 qr1c+W/SjwaOF6JmhmdVlj74ky/O84bpFMMvpujLBvUeLsU9T78G6SwU5P2VFr7TNVZW9amLmC7
 v6ywWAFXwR4Q=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Add --for-next/-f to generate ANNOUNCE email for for-next branch
update. This doesn't require new commit/tarball/tags, so skip it.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 release.sh | 92 ++++++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 59 insertions(+), 33 deletions(-)

diff --git a/release.sh b/release.sh
index 3d272aebdb1fe7a3b47689b9dc129a26d6a9eb20..863c2c5e061b73e232c0bb01e879a115b6dd55bb 100755
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
@@ -42,6 +44,48 @@ update_version() {
 	sed -i "1s/^/xfsprogs (${version}-1) unstable; urgency=low\n/" ./debian/changelog
 }
 
+prepare_mail() {
+	branch="$1"
+	mail_file=$(mktemp)
+	if [ -n "$LAST_HEAD" ]; then
+		if [ $branch == "master" ]; then
+			reason="$(git describe --abbrev=0 $branch) released"
+		else
+			reason="for-next updated to $(git log --oneline --format="%h" -1 $branch)"
+		fi;
+		cat << EOF > $mail_file
+To: linux-xfs@vger.kernel.org
+Cc: $(./tools/git-contributors.py $LAST_HEAD..$branch --delimiter ' ')
+Subject: [ANNOUNCE] xfsprogs: $reason
+
+Hi folks,
+
+The xfsprogs $branch branch in repository at:
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
+The new head of the $branch branch is commit:
+
+$(git log --oneline --format="%H" -1 $branch)
+
+New commits:
+
+$(git shortlog --format="[%h] %s" $LAST_HEAD..$branch)
+
+Code Diffstat:
+
+$(git diff --stat --summary -C -M $LAST_HEAD..$branch)
+EOF
+	fi
+}
+
 while [ $# -gt 0 ]; do
 	case "$1" in
 		--kup|-k)
@@ -54,6 +98,9 @@ while [ $# -gt 0 ]; do
 			LAST_HEAD=$2
 			shift
 			;;
+		--for-next|-f)
+			FOR_NEXT=1
+			;;
 		--help|-h)
 			help
 			exit 0
@@ -66,6 +113,17 @@ while [ $# -gt 0 ]; do
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
@@ -128,39 +186,7 @@ if [ $KUP -eq 1 ]; then
 		pub/linux/utils/fs/xfs/xfsprogs/
 fi;
 
-mail_file=$(mktemp)
-if [ -n "$LAST_HEAD" ]; then
-	cat << EOF > $mail_file
-To: linux-xfs@vger.kernel.org
-Cc: $(./tools/git-contributors.py $LAST_HEAD.. --delimiter ' ')
-Subject: [ANNOUNCE] xfsprogs $(git describe --abbrev=0) released
-
-Hi folks,
-
-The xfsprogs repository at:
-
-	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
-
-has just been updated.
-
-Patches often get missed, so if your outstanding patches are properly reviewed
-on the list and not included in this update, please let me know.
-
-The for-next branch has also been updated to match the state of master.
-
-The new head of the master branch is commit:
-
-$(git log --oneline --format="%H" -1)
-
-New commits:
-
-$(git shortlog --format="[%h] %s" $LAST_HEAD..HEAD)
-
-Code Diffstat:
-
-$(git diff --stat --summary -C -M $LAST_HEAD..HEAD)
-EOF
-fi
+prepare_mail "master"
 
 echo ""
 echo "Done. Please remember to push out tags and the branch."

-- 
2.47.2

