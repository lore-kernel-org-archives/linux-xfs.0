Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410D5ECF
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 15:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737558124; cv=none; b=j0t2gREf/kTQgaCkz75uo4CzRHr5hZ3N6p8g7eweTwhqVWIiRzgiYtSGsTgw9daKcDf9QX4OSsLerEAU5kk/HMDDViPyCnevTarRTuYvO5nWBtscXMbjZaS79QCtOsmWHL7D0nR8PnJNVNLbBgroyWRBzmij3J91uGhKOavOmwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737558124; c=relaxed/simple;
	bh=uQa8vmMc73ToD17zbOVCwEY2cNBULfkbSXG2Ep49Mic=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=F/QnvyUrKmZPW8x5b4m06uXhftfaXitovfQ0ysWiKKO/vboic30ur67hpxH9pWMVsac/Xg0RP+P8uFOzE0b1QMtuJBo2SD7M4zNVay8HEkbcPOfG1aHAyHM+i/x2iwm3o14YyDiTzEM86K8gX+Ergasfn3FpAZqR1MyfBu4RFW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H6ZBz4j3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H6ZBz4j3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737558122;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GpANL5LoSGvHyocaC+nst+0GpBs6QazoVf7ruWuEcgs=;
	b=H6ZBz4j3xi43NVWBb82capZryCaPow9QmzdEHgXeRh2CKLtHcqMEnyo/+K/67qtxo4T3EX
	jUhrs/933hDDbcEMo2i/sKV7fEf9v8DeqnEYf6h1v+snjj+8i29YK7ag01bZJ/5OuIVT1Q
	5vL5uX6zckJAeXiNIQ3KrzGFae63Nhk=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-27-V2N7aMyCNgiNQirWGKAk-g-1; Wed, 22 Jan 2025 10:01:58 -0500
X-MC-Unique: V2N7aMyCNgiNQirWGKAk-g-1
X-Mimecast-MFC-AGG-ID: V2N7aMyCNgiNQirWGKAk-g
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-aa683e90dd3so619052766b.3
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 07:01:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737558117; x=1738162917;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GpANL5LoSGvHyocaC+nst+0GpBs6QazoVf7ruWuEcgs=;
        b=u7gnxCfdqYmY91N8KT3zFY2vSAfKWmeWbDbqH2n/H46D38VfPO76k6AM889sNJRDS7
         7kn78G4b2Z+aMnm7uQAH3X1gsvevN4DaKI+quUlYWO6Hmy0z3dbiS7cm8mecMnM7hds1
         zIyjRnqCJ3UWjPREAtwXoQYJV2sGqQHiaWcHYmwHYFre6P7IOGOBhM9TEICzX3grOVfe
         R4GlNLreLdZWBviLSTOGyklDvwI45hEk8ryrjKQFjJhdCZ5R32iwSCYzhIET6gOCBLbU
         07pMshyWwB3CEiXzl90+CadHnkk5DO+vEbVuXqRm7DV0tjUmDDJyVGfJcnRb/RGi/4W9
         n+Hw==
X-Gm-Message-State: AOJu0Yw0+dPGLzxYzUkWLgwyCdj2c69TdgIzTXDKKpAhfGSSTJ22sEPh
	hZKtI98hVo6rskDzL60FsOgsJsnKIIoO3SfVt4oAYKu/HjtB3n0tqvyDt0VLV7wTAon0qpMUEZZ
	WUmETxtCKPiJy5lMKl5I6cd6zPgb78K8e9yiLv3h9viuqkW14f6EcxN2+jDOvG5ct
X-Gm-Gg: ASbGncthL/eCK5J7J0SZTf6P+iMpcV0Rht+h6lvJK4WFz1QYMspSNPFEDF8foIAliQK
	4HaHpP2Y9h2dYgQDyAYjigOBGhX1E0QH9dY/b4Tb6NqDkEWteoy8vaZ5ZlC7h6VFYBz+ymH+jDX
	PfglbWkd9sdLVQgGhYEAXVKe+CHjzTP5Cx2+Jr6IAC4aI3L4OtqhRqZriJ4eCCVzCKZ3agwl/YG
	Ay4eFD7PORGB7Pld4O7Qr7kz/WYRtfxzPGlPpoFiT8DDuou3GkFEQklIsH1LgBbNxZCWoAlYO2N
	Fk0lwSVrorVq9v6drYy0
X-Received: by 2002:a17:907:2d20:b0:ab3:88a0:14be with SMTP id a640c23a62f3a-ab38b0b9971mr1742175366b.9.1737558116598;
        Wed, 22 Jan 2025 07:01:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEZ1dKsEPK6xW1T2s4Svr1olG1qput3xMd5ZsbDP4yZ9lZYYVzVXTD2K7+QNdmZV7XtJbLgJA==
X-Received: by 2002:a17:907:2d20:b0:ab3:88a0:14be with SMTP id a640c23a62f3a-ab38b0b9971mr1742148166b.9.1737558114564;
        Wed, 22 Jan 2025 07:01:54 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f2303csm925653966b.100.2025.01.22.07.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 07:01:53 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 22 Jan 2025 16:01:29 +0100
Subject: [PATCH v2 3/7] release.sh: update version files make commit
 optional
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250122-update-release-v2-3-d01529db3aa5@kernel.org>
References: <20250122-update-release-v2-0-d01529db3aa5@kernel.org>
In-Reply-To: <20250122-update-release-v2-0-d01529db3aa5@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3767; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=uQa8vmMc73ToD17zbOVCwEY2cNBULfkbSXG2Ep49Mic=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0idyBD4Wf1yq3TP1kHX1bYn4slu3F95cIbA9y3n3I
 0aGDUdTW106SlkYxLgYZMUUWdZJa01NKpLKP2JQIw8zh5UJZAgDF6cATOTyQ4b/0YErTvMJVR5y
 9WL4Ne9La1WFZsjX3b8yO+eGv9yrNDfpAcNf8et6ahs4mnIrZln5fD8uan7r+w/5td3JCkeOMCy
 c4xjBCACfY0la
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Based on ./VERSION script updates all other files. For
./doc/changelog script asks maintainer to fill it manually as not
all changes goes into changelog.

--no-commit|-n flag is handy when something got into the version commit
and need to be changed manually. Then ./release.sh -c will use fixed
history

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 release.sh | 75 ++++++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 58 insertions(+), 17 deletions(-)

diff --git a/release.sh b/release.sh
index b036c3241b3f67bfb2435398e6a17ea4c6a6eebe..57ff217b9b6bf62873a149029957fdd9f01b8c38 100755
--- a/release.sh
+++ b/release.sh
@@ -11,16 +11,33 @@
 
 set -e
 
-. ./VERSION
-
-version=${PKG_MAJOR}.${PKG_MINOR}.${PKG_REVISION}
-date=`date +"%-d %B %Y"`
-
 KUP=0
+COMMIT=1
 
 help() {
 	echo "$(basename) - create xfsprogs release"
 	printf "\t[--kup|-k] upload final tarball with KUP\n"
+	printf "\t[--no-commit|-n] don't create release commit\n"
+}
+
+update_version() {
+	echo "Updating version files"
+	# doc/CHANGES
+	header="xfsprogs-${version} ($(date +'%d %b %Y'))"
+	sed -i "1s/^/$header\n\t<TODO list user affecting changes>\n\n/" doc/CHANGES
+	$EDITOR doc/CHANGES
+
+	# ./configure.ac
+	CONF_AC="AC_INIT([xfsprogs],[${version}],[linux-xfs@vger.kernel.org])"
+	sed -i "s/^AC_INIT.*/$CONF_AC/" ./configure.ac
+
+	# ./debian/changelog
+	sed -i "1s/^/\n/" ./debian/changelog
+	sed -i "1s/^/ -- Nathan Scott <nathans@debian.org>  `date -R`\n/" ./debian/changelog
+	sed -i "1s/^/\n/" ./debian/changelog
+	sed -i "1s/^/  * New upstream release\n/" ./debian/changelog
+	sed -i "1s/^/\n/" ./debian/changelog
+	sed -i "1s/^/xfsprogs (${version}-1) unstable; urgency=low\n/" ./debian/changelog
 }
 
 while [ $# -gt 0 ]; do
@@ -28,6 +45,9 @@ while [ $# -gt 0 ]; do
 		--kup|-k)
 			KUP=1
 			;;
+		--no-commit|-n)
+			COMMIT=0
+			;;
 		--help|-h)
 			help
 			exit 0
@@ -40,6 +60,36 @@ while [ $# -gt 0 ]; do
 	shift
 done
 
+if [ -z "$EDITOR" ]; then
+	EDITOR=$(command -v vi)
+fi
+
+if [ $COMMIT -eq 1 ]; then
+	if git diff --exit-code ./VERSION > /dev/null; then
+		$EDITOR ./VERSION
+	fi
+fi
+
+. ./VERSION
+
+version=${PKG_MAJOR}.${PKG_MINOR}.${PKG_REVISION}
+date=`date +"%-d %B %Y"`
+
+if [ $COMMIT -eq 1 ]; then
+	update_version
+
+	git diff --color=always | less -r
+	[[ "$(read -e -p 'All good? [Y/n]> '; echo $REPLY)" == [Nn]* ]] && exit 0
+
+	echo "Commiting new version update to git"
+	git commit --all --signoff --message="xfsprogs: Release v${version}
+
+Update all the necessary files for a v${version} release."
+
+	echo "Tagging git repository"
+	git tag --annotate --sign --message="Release v${version}" v${version}
+fi
+
 echo "Cleaning up"
 make realclean
 rm -rf "xfsprogs-${version}.tar" \
@@ -47,17 +97,6 @@ rm -rf "xfsprogs-${version}.tar" \
 	"xfsprogs-${version}.tar.asc" \
 	"xfsprogs-${version}.tar.sign"
 
-echo "Updating CHANGES"
-sed -e "s/${version}.*/${version} (${date})/" doc/CHANGES > doc/CHANGES.tmp && \
-	mv doc/CHANGES.tmp doc/CHANGES
-
-echo "Commiting CHANGES update to git"
-git commit --all --signoff --message="xfsprogs: Release v${version}
-
-Update all the necessary files for a v${version} release."
-
-echo "Tagging git repository"
-git tag --annotate --sign --message="Release v${version}" v${version}
 
 echo "Making source tarball"
 make dist
@@ -83,4 +122,6 @@ if [ $KUP -eq 1 ]; then
 		pub/linux/utils/fs/xfs/xfsprogs/
 fi;
 
-echo "Done. Please remember to push out tags using \"git push origin v${version}\""
+echo ""
+echo "Done. Please remember to push out tags and the branch."
+printf "\tgit push origin v${version} master\n"

-- 
2.47.0

