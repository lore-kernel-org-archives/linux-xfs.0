Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E7D1F1515
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 15:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737558125; cv=none; b=cWAMAYATnVrDs0sNo/W4DJiRdQot+qRU3GpEQODu8H9KEDkGJsr9/yD8CrDXg+9+i3QylHGNI5P/84egoDiHAOnsT27g+Sx44svzrkomdog4ALylcyz8xpV48T4RVNIUhWga64ur+FmgoP1xMssZuuaF2ZWpO7L35kho7HVoM3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737558125; c=relaxed/simple;
	bh=OgOo1ZSsR2kUCht7Gr/VNXT01rTJK79gPbW+LCwOf+o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ruBuwa1JFZd1n6gtxNEWqRIqS0oZuJEzoSaGm2WjaTTLNiu9hxrsMgrI+i88R5czu4OXVmkdUtpA/U6pNuJMpfKRYgwcr4OxHpd3DB6gN+1d11lpE1/4Fh97pOhbOaRwy/QB0o8OEvDVKyCvu9GKj/kZmaGpdw93uTpOfWA8gTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U1/6U7rJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U1/6U7rJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737558122;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l4wKUqzKOPPRbQaxM+8yaf7gzzQ1hiuDIqF6InyhzCY=;
	b=U1/6U7rJ57P0CR9ocrYkPEeUEwe2SV19aAp0wQSoPJ5J/MKvAA2miMMMr9RuEaNi1/Q/gv
	rFonueYWzrj/yG0hA3+bD3oM+dGiOMNmmYTGvQ66HX7xHUbNloKHjMuN16izzvzJI+8Ogi
	1Ed7VrUySVpwz8//8GzR0xottIk2IG8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-414-PtrfiNNJMTuva4C1wFpXdw-1; Wed, 22 Jan 2025 10:02:01 -0500
X-MC-Unique: PtrfiNNJMTuva4C1wFpXdw-1
X-Mimecast-MFC-AGG-ID: PtrfiNNJMTuva4C1wFpXdw
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-aa68b4b957fso802791866b.3
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 07:02:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737558119; x=1738162919;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l4wKUqzKOPPRbQaxM+8yaf7gzzQ1hiuDIqF6InyhzCY=;
        b=dc/60RGq5ROzDRdKQGAP2WOPriGCW8UEh6TgcvT9D98YGP991IfOosBzK/YN/6ZLRl
         wD10S/vnnsNG0vbRg58xNyrisOoKKGWpjulJhe5qIk/Abvxj2YuEaS4bIV68QgOjLBpo
         txsGt5x8d4Cm1k/OH5fPEyUU5VVYXYDAyxDBZ5N+BIzZxU/1t/J61+i72gThxT/FiVAH
         6m97NhI1LNATRQ+6lLR7MLSxUtJi+WYm8wMIxumeKYCfKlIu1nRMbapMnZd9j9q2rWX5
         KOFULvBXFPOFVjqo/0zMOj+ov54pa4sCMMmiV3hwcJhyYSL6JfaOKSNThion5dh2ru5X
         8SmA==
X-Gm-Message-State: AOJu0YyXekijN4qoTz/ZpKKRjE15Ye+LE3CIdwKfGtuapyWZQvNiQcoR
	gHV+79N6YK6nfzXjIbqx4WQLRnWr43WmkxMcRhLNpSELgAMAcWJ4cDofg0WkR7q0oWro4uZ1siy
	EBKPiW8nCLqVdRTbaepiTgOO1VszBUCAShwdJSwB5C2DUnHEEabfno2aJb9Qd6c8n
X-Gm-Gg: ASbGncuwMlSHXnCYlCT06gpjt6AvHo/qahnJq18lh4Juypm1DlFAkUIY6308eYB9sM5
	jKW4BUGwDSFwq2axRtKRz/wwnQ7cw+AWHN+C/tcLPXt23QM9TQ0wFvHA/bWCfTt+CAPjVLRmxjv
	rOO/e+O/ybbTiTfobHtNd04O5YJLHunEwnYw9fgkXULvJ0kfjcExhmF6dmMkyAFDQA9sr8CRshz
	BN34uzTIk+xr9hqjT7uzYZGkAy4yYcTLHW9ScPKnSwxaIWo8WybHLoG2B2nEa16j4+dF5OJMFF3
	JmT6ImjbK/apEHTpPrZe
X-Received: by 2002:a17:907:7b8b:b0:aa6:995d:9ef1 with SMTP id a640c23a62f3a-ab38b0b9960mr1925563266b.12.1737558117973;
        Wed, 22 Jan 2025 07:01:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFUsFPA+cnt2yImwXP7W+JI7lCAqfaO8JbyBkQ25jw/zt2ZBzmv6jqNJFkhdmm94cj3Jwgn7g==
X-Received: by 2002:a17:907:7b8b:b0:aa6:995d:9ef1 with SMTP id a640c23a62f3a-ab38b0b9960mr1925539266b.12.1737558116115;
        Wed, 22 Jan 2025 07:01:56 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f2303csm925653966b.100.2025.01.22.07.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 07:01:55 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 22 Jan 2025 16:01:30 +0100
Subject: [PATCH v2 4/7] release.sh: generate ANNOUNCE email
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250122-update-release-v2-4-d01529db3aa5@kernel.org>
References: <20250122-update-release-v2-0-d01529db3aa5@kernel.org>
In-Reply-To: <20250122-update-release-v2-0-d01529db3aa5@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1991; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=OgOo1ZSsR2kUCht7Gr/VNXT01rTJK79gPbW+LCwOf+o=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0idyBG7dd0Dnc61xgbbPSVfnj30p6vNkudntbPcdE
 FR4LW7OytFRysIgxsUgK6bIsk5aa2pSkVT+EYMaeZg5rEwgQxi4OAXgJgcxMnxecLn7d+vZ5HVt
 fb8+SiTyzSyxmJqQ1+u3/ciOm5dkhB8y/PeV4Wbm5uONFVFuc1/595WU5U+TANOqX8tmcN+0S2Q
 y4AUALT9BFA==
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 release.sh | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/release.sh b/release.sh
index 57ff217b9b6bf62873a149029957fdd9f01b8c38..723806beb05761da06d971460ee15c97d2d0d5b1 100755
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
@@ -122,6 +128,43 @@ if [ $KUP -eq 1 ]; then
 		pub/linux/utils/fs/xfs/xfsprogs/
 fi;
 
+mail_file=$(mktemp)
+if [ -n "$LAST_HEAD" ]; then
+	cat << EOF > $mail_file
+To: linux-xfs@vger.kernel.org
+Subject: [ANNOUNCE] xfsprogs $(git describe --abbrev=0) released
+
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
 echo "Done. Please remember to push out tags and the branch."
 printf "\tgit push origin v${version} master\n"
+if [ -n "$LAST_HEAD" ]; then
+	echo "Command to send ANNOUNCE email"
+	printf "\tneomutt -H $mail_file\n"
+fi

-- 
2.47.0

