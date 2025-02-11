Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC04B253B61
	for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 17:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739294844; cv=none; b=mx3nfVPgSf8tsuFM/SEDFT9baBfI3YBdMYFn/+7ul0VxFl3BSrWeT2hnhSH3ym8TLGDKFMSdnd/+AU+FGMJxxkVeblGBKUQuM+/NVGa6XCRSLVKgU3zQTJ+uNFRDibyVKMK4J/YCKcfQ/57SdnxQear8/UXw2apEcLbU9ZqbXq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739294844; c=relaxed/simple;
	bh=yaWJVJuKGFhzmKVRHpmJy9ajG9Z4QjIUPMiBrDMw+rA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SmtP0UuYOoPZb1+Di67h7WdRk1FFDMBfJIRLP+UL+kN+iVlm46To4gYY0YJqW1j/zWjrIEhp+5WV7gdB2FCStYO9wOYZg7FgHyX26h+BDhuyj1CFf5v/+CI4dWH6l1Sv1c5QqVfmvk8MA7LgA6d13XsjVtaHuMCVx2NJUylwbHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JXCIgCIR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JXCIgCIR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739294842;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7Jyn8SRDfxRzXxNsdthBGUPPfefcNkXBuN43maj8ovE=;
	b=JXCIgCIR0D+lbR0XwV9SEvAYpN7HWVo0kFDWWME97rA1wUts0jJexjRYYTfoRRiEYjvl4Q
	wu5Eak4TKVcb4abI3H1DVr4onQVZPBIvr7I9Qgf6wCq+mL6X4T99nTaIOEtCSv0Sw/6wgi
	5fxnnWb17rgJEBy0RgIe9tK2vhGm9co=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-2G-5i-6lNnqublswa718ng-1; Tue, 11 Feb 2025 12:27:20 -0500
X-MC-Unique: 2G-5i-6lNnqublswa718ng-1
X-Mimecast-MFC-AGG-ID: 2G-5i-6lNnqublswa718ng_1739294838
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5dc5369fad7so6420225a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 09:27:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739294838; x=1739899638;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Jyn8SRDfxRzXxNsdthBGUPPfefcNkXBuN43maj8ovE=;
        b=kfG59XYePTT4CiR3IyeWoBcq6iHlnx/4/Cx5VgsecqCQSgX7HkGL7nGrT0sOBPe/DJ
         HzrGU/eJnLOJWKMZ72Y1NLPBZhsh1Z/vFJeRrusLQBLBON8zmbIBI+5LNvrWSupnsC+L
         LMFVpKCguK+0+tSr0GSRCapClnVzX33i3ibs8HPnalIybu+qd27AnPwxma2uzOiZxqU3
         FGCN6DR+Pbz/e1zxWkLtLmQmUHbFS9x5s4L/Fa+DoFgD60HCoXoYEIxvYQhIsqq0hF98
         q5yUK6xJXC+eMafe+/+ZuiTkRiGk/M/I0jXTUan/tiWBC5rfklebxkuCWSsI6Wx6dXQ6
         rxBg==
X-Gm-Message-State: AOJu0YwU6QBzjJJiHnEzT1JH4WN3JmbD0RE/Tl3/boQhK1brfhDWcTI0
	d4jrpv1sKBr4IOmEEEn9sYRqVCRjotD29+mfAvDX2Z1ukAkyhAqSU0Jbc537q4212TOMWPnt7UY
	BS+ZcM9SYQBTVJXMSMmBAV+HJid1TXw5u+bscxYkTxmspxP/KKXVI98/vDKYN6AOaK1U=
X-Gm-Gg: ASbGncsFfjBHEjWlgx856KzD2Wln8tIizMeicRqi0BkEil1ZqNSDx2+FIJwgQRh778b
	ySMGAVyhk78WU8ItfubpHVQ6HnxerWc9e7IqawocRPFCNKa6meGUgU3l0HS4FnYFozD3giIzB+G
	wBAH/QNp/tvgk5krsqNiNSbzVr/UpQ0bSILXZ3shkPLOQ8DUaaaOWdT0LRQ0729ODkT7inncpJk
	TRKoiXa0S0nU5cLfI7/A1T0Hng+m7mr2Jj7dUf2Ckt4VKn70DYye02PkVfas3c6iWPSlBk3RIVx
	W356KAvOLR9WkPL3y4h4LbWREoGns7s=
X-Received: by 2002:a05:6402:4409:b0:5d0:ed71:3ce4 with SMTP id 4fb4d7f45d1cf-5deadd78174mr31324a12.6.1739294837894;
        Tue, 11 Feb 2025 09:27:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEa/aJ/4pStKz8w8oLajT1N1xxXisFGzRQM73mmsmUOWmsBGVfUR6MScDSB662qitTrT9O5zQ==
X-Received: by 2002:a05:6402:4409:b0:5d0:ed71:3ce4 with SMTP id 4fb4d7f45d1cf-5deadd78174mr31291a12.6.1739294837407;
        Tue, 11 Feb 2025 09:27:17 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5de5ced9758sm6914335a12.76.2025.02.11.09.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 09:27:16 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Tue, 11 Feb 2025 18:26:56 +0100
Subject: [PATCH v3 4/8] release.sh: generate ANNOUNCE email
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250211-update-release-v3-4-7b80ae52c61f@kernel.org>
References: <20250211-update-release-v3-0-7b80ae52c61f@kernel.org>
In-Reply-To: <20250211-update-release-v3-0-7b80ae52c61f@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2064; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=yaWJVJuKGFhzmKVRHpmJy9ajG9Z4QjIUPMiBrDMw+rA=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0ld3FBx703jH0Tk3QOlh4vU1y2u2fbY4/PyUYsa62
 G417Y99NfwdpSwMYlwMsmKKLOuktaYmFUnlHzGokYeZw8oEMoSBi1MAJlJ7gpHhsszsc1z9bmeZ
 FjaIKMReFWWyt+DSYOA+rTwlIaDkwOr5DP9Mts8z+mgxQ7Ft6REPxt8N17zzeBRrP77NWjtvgm/
 gKnM+AI/4RhM=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 release.sh | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/release.sh b/release.sh
index c3f74bc8dc587a40d867dd22e1e4c6e4aabb8997..a2afb98c2391c418a1b1d8537ea9f7a2f5138c1e 100755
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
@@ -48,6 +50,10 @@ while [ $# -gt 0 ]; do
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
 printf "\tgit push origin v${version} master:master master:for-next\n"
+if [ -n "$LAST_HEAD" ]; then
+	echo "Command to send ANNOUNCE email"
+	printf "\tneomutt -H $mail_file\n"
+fi

-- 
2.47.2

