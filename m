Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9F724BBFF
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 20:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739477770; cv=none; b=sNxX7PeNmJi6CzdqjhvSPqXhGSPNI7FbHi4oaNr23sqefZGULs3bCF4/nTyAAeR3kVN1bwHuMT0FvkcH2tHeiik3un7DIbH9DdZogB00wEl9EH08b0wcA/zEU6OgdIjn0/11wccv1LVU0Cm6/l94cKIC1n4aAD4aODIUlLlMczQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739477770; c=relaxed/simple;
	bh=rEflmP3SN1QNELLhRia+oSljkcISs2LV+HBYG8gRPwI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oxmNC8Y2JwBCDObBGK8ygQ78RrgK7U7sId0BO/UhDU/ZvnY56YSataEI1ZNRv+GGpsnnCHRpeYfcNV6t8gyUiFo5IZOVa2Ek4RQKmRYpToPWQxN6Ue9MM5FQn2zJvDGdVC4VgvHC0JTsAwBJDhEvYMZzwR+fXOY85Hu/K0846f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IkblpVtx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IkblpVtx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739477768;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0x/LYnT+O7ha0wrAYFG+Ebf3sRK/ZTjDo3WLO3Wl+wY=;
	b=IkblpVtxiqQL2LurzZTCd2fvWKPIHjiT65UnVk2goaXCQ3aWae+ZZ+1Hm4lmvKYF8B3Z3E
	4pOSvk0MHbfd3lcB+rfU10AMuR5iUBLGDx/kcBOzXUyh3YaY4Tl8Sjea2aqA3xOZwKlAGo
	QxjTa+D5ISmPbuVMK1n5geFcLPXw+qg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-O6cmrUrlMnqumwGsTp5H5g-1; Thu, 13 Feb 2025 15:16:06 -0500
X-MC-Unique: O6cmrUrlMnqumwGsTp5H5g-1
X-Mimecast-MFC-AGG-ID: O6cmrUrlMnqumwGsTp5H5g
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4394c747c72so7548255e9.1
        for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 12:16:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739477765; x=1740082565;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0x/LYnT+O7ha0wrAYFG+Ebf3sRK/ZTjDo3WLO3Wl+wY=;
        b=Sh44jK5R/c6RR6jSXKlx+m1q6UROHEiXrkyt2aaj4MzEV8svzzy+isphv57V+PevHM
         MytP/PCG5pEwliMQ3D70k+ycqHZ1zclujKku8dK+X+NrnjAXj0zAwxuYTcKM7Ws/dznD
         orF9ImkcDVRw0OoneeU7ApAI8wltznrsakyI8Ce+zBTXBu3fpcbzlxf281Mn7i+FmNeD
         sYdDVbnpGzFFdvsT3bCEsRSg6aeCBdj031Gq5sA7b296CNV+n1rsmqlcKW8q92t7ZA7D
         gqrMF46Xul4uwPl/v3lPkwRfRpAPANg4M2pSdGkop2H2F8LYIUjP68PyV+4EbmTuqORc
         R7tw==
X-Gm-Message-State: AOJu0YzdzBUFvjk9+2K7/rJeDpvPvFzwfYamSgEWyhZ/mqFBVmMjDp9S
	74/00L5dF9kRo4ll1+Fwk9/sGT8+wzPDbvtQ76+SuRWmOYFT9bpFHjvs1Px0rmOLP7VpGplnmxM
	tZbj0Ls7+BZUU8I/VJCTc61OwqAyE68wnjDAmeBiDWlrxi7bhjF1k69Oub/EFfVwO
X-Gm-Gg: ASbGncvZSPPBHVVHaXTKzirS4Nb663jr4uge4VVdWIb9LtLLB13qFXzU+BU8jkym8eQ
	mgrpN4o9t+fIP1yPcSpGda3DwH8KqGWOfS5BCBBNO4VT5KD7Ul1EXJmZNbU4oZuqUTWYJmko5eL
	ZBfx6Mpmoko5Go/YqfIW73DhUAsO8MPTytUOk+7myulIegpWOUhbeWU7/BP9YF42viYAlsBY/Qs
	IzSnOPoH97Ow3b7I0nlekqXiyx1Y1OW5FfQa/QT8XFteCFrALxuoawm2znQjzcqSRf7dZJcIl0Y
	WQZmnLDam49S2znuLA7Nrk5BPDYWUHI=
X-Received: by 2002:a05:600c:8709:b0:439:4b9a:a9fb with SMTP id 5b1f17b1804b1-43959a997e9mr103927645e9.30.1739477764991;
        Thu, 13 Feb 2025 12:16:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFssC39RAkEFAv1yf4TSgr9XVc1v2gbf3RS+nS6QZGylhhnrZyLlNGM5Q0gnl1eZ44/uoFh5g==
X-Received: by 2002:a05:600c:8709:b0:439:4b9a:a9fb with SMTP id 5b1f17b1804b1-43959a997e9mr103927365e9.30.1739477764599;
        Thu, 13 Feb 2025 12:16:04 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a06d237sm57520895e9.21.2025.02.13.12.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 12:16:03 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Thu, 13 Feb 2025 21:14:29 +0100
Subject: [PATCH v4 07/10] release.sh: generate ANNOUNCE email
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250213-update-release-v4-7-c06883a8bbd6@kernel.org>
References: <20250213-update-release-v4-0-c06883a8bbd6@kernel.org>
In-Reply-To: <20250213-update-release-v4-0-c06883a8bbd6@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2602; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=rEflmP3SN1QNELLhRia+oSljkcISs2LV+HBYG8gRPwI=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0tcF/drh4qF+euvptLBdUinvtVzmN8SIzPQ4pH3px
 Mr5dRvTbyh2lLIwiHExyIopsqyT1pqaVCSVf8SgRh5mDisTyBAGLk4BmMimR4wMG55UlrI0m0/9
 s3hDtJLTku7NO8tWv1P+ylol/M69aoXReUaGJ6yBK1eGvpeymWk1I9troxOn4WKVUANzj8qw+es
 XXJRjAQDOUEb7
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 release.sh | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/release.sh b/release.sh
index c3f74bc8dc587a40d867dd22e1e4c6e4aabb8997..696d3ec107ca0cc11ed565734ca7423acfd6d858 100755
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
+	printf "\t[--last-head|-l] commit of the last release\n"
 }
 
 update_version() {
@@ -40,6 +42,48 @@ update_version() {
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
+Cc: $(./tools/git-contributors.py $LAST_HEAD..$branch --delimiter ', ')
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
@@ -48,6 +92,10 @@ while [ $# -gt 0 ]; do
 		--no-commit|-n)
 			COMMIT=0
 			;;
+		--last-head|-l)
+			LAST_HEAD=$2
+			shift
+			;;
 		--help|-h)
 			help
 			exit 0
@@ -122,6 +170,12 @@ if [ $KUP -eq 1 ]; then
 		pub/linux/utils/fs/xfs/xfsprogs/
 fi;
 
+prepare_mail "master"
+
 echo ""
 echo "Done. Please remember to push out tags and the branch."
 printf "\tgit push origin v${version} master:master master:for-next\n"
+if [ -n "$LAST_HEAD" ]; then
+	echo "Command to send ANNOUNCE email"
+	printf "\tneomutt -H $mail_file\n"
+fi

-- 
2.47.2

