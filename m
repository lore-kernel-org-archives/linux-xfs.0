Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3F826216B
	for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 17:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739294843; cv=none; b=j8QnGoNMnD+bRyiXurvkVxj+eWtNgGNs/bHNPR2WJgEx2C2Q4kmFyKEVdVO03eN8KvMrS1+TufXXLHMIeNr1YnC4reQrVe5pfOT+3Jo6g+NJWXpkDFjEvNOm57gHntZ25/v2XCkbIYEFLX5JruILEXIwrYQXg11b3aDSq4jOGsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739294843; c=relaxed/simple;
	bh=em41zXomO0jL9kZk0F8GUYFuiu2onzUI7wqVleP04iE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bs/bzesfSAALO8jPsLr/gztNO1TvE5JHrDWk1vnSNfvwrV8CCN7bSA9+v0vGnlL/b4TZN53hQGC4+PpHKgJgM42zKNgS7PSE0GT9PK27jcV9/LMYdXKm0KyZa2QRmjkUw8TjHfHUf65jyiH462M6Rgm4b8dtOB+c6HzDIgNrAcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TREJmhcX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TREJmhcX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739294841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EVF6Djswvdycv30ceiXMOHnHpXzJo3+aaqOC0QnjsTc=;
	b=TREJmhcXBGqghbnx5XFwxrBh89U4ERfe060A19q6RoR1NGvsq/LyustyhIvB9nqBdkUvgp
	gFty7vx2eGEARLbo/OM+AHzdfi7fVc62o2RmnH2mv5Ynpu9pXwDoxW6tsucnjH1YsDDjna
	1xe8UKEbA7muqwFNthJ3q5ujYLTXTmg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-nMGG4q2ZP0yJSaFEcLHAxQ-1; Tue, 11 Feb 2025 12:27:17 -0500
X-MC-Unique: nMGG4q2ZP0yJSaFEcLHAxQ-1
X-Mimecast-MFC-AGG-ID: nMGG4q2ZP0yJSaFEcLHAxQ
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5de4ae51b71so4159973a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 09:27:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739294836; x=1739899636;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EVF6Djswvdycv30ceiXMOHnHpXzJo3+aaqOC0QnjsTc=;
        b=gFB32gqAWBPqeyXx1SLgQGGfSjNKIeagshvOInC6AzZ5q1jVcVhQ+jGNXjqCr25szN
         aFCC5sfV6gX4hDmza3a7w8Kbv50fK0/Mjt+W0q19S9bjmzvSUrTz4BAbdxxrQ7dVN9k7
         vAPGIdmh5PBUB1+uVIZozV24lSPYUTXhjw9iQS8DwJIny/suWIn5SrH1TX88xSWxxznt
         kt+X2Ck0ZQ58lp21g/v0dHtCBjRQ6LeqkP40ybG6IGMHpnTZbTg21C35YWKd0HMvGsZb
         vVTwktIcH5sZWNH+eGcJpy+uycpPFnrjINDyaZQ/FgGCfPpsjiXkxa8XnecCE8k/TMwj
         OYRg==
X-Gm-Message-State: AOJu0Yz7NVA8r3xye6VH6ices3DUpP1m64MrCHyVIxjDz1e7YzlXiYpg
	8R/J7HZT37JM9yejT/L2rHX+fMAVvJF25lX26P2eGG9KlVPBPyNjDCXaJ/TkhCY0e/XDYcL/rcg
	kcTGmLMieXb9cdqWBxUc7LKYwzKDSttOtQVsOhxzfvGuPbVh3daGjGtmMyxakMlVrKnY=
X-Gm-Gg: ASbGncu8ltnvp7mLUaLsyARs4ffhmJgK53ozgPRj2FFweDaz+vO6KzXTCez4j/4kqni
	581qD7VNt3+S/D1Aj5K+e8mQX+ZwTkGfYFndspm94md1zV9+yRBNaVdfSAWc50AHvS2wgYTq2Jh
	mFUy+AjmivnplcMbzFRklZgWFPVv4OXUvWgGA3Q03tEwsJX4duZnG5c1tEGzITZv4e1O/7xu04e
	s0uBx1nGDXQ4oNw0JUxtCQCZDLcvExasspF+IUtTLkPjvmCdMoKcMxQPRkaSWwx5ASExmZSfI4a
	IbUVi1yrhsI2rjGtjYsFIDGiGR6jkZM=
X-Received: by 2002:a05:6402:3511:b0:5dc:8851:fc36 with SMTP id 4fb4d7f45d1cf-5deadd8c41fmr33522a12.11.1739294836273;
        Tue, 11 Feb 2025 09:27:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHxB1Iew8RDqzqNVZUaz4hGT1LW5NgkfoB3pAjjMiKBfJr0vvnk4jDZ8/vxvnvU5ZBu1IlhBw==
X-Received: by 2002:a05:6402:3511:b0:5dc:8851:fc36 with SMTP id 4fb4d7f45d1cf-5deadd8c41fmr33494a12.11.1739294835886;
        Tue, 11 Feb 2025 09:27:15 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5de5ced9758sm6914335a12.76.2025.02.11.09.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 09:27:15 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Tue, 11 Feb 2025 18:26:55 +0100
Subject: [PATCH v3 3/8] release.sh: update version files make commit
 optional
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250211-update-release-v3-3-7b80ae52c61f@kernel.org>
References: <20250211-update-release-v3-0-7b80ae52c61f@kernel.org>
In-Reply-To: <20250211-update-release-v3-0-7b80ae52c61f@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3840; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=em41zXomO0jL9kZk0F8GUYFuiu2onzUI7wqVleP04iE=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0ld3FASYBjYzvuURyY1K4ft5WPek+6mdU3Iy9K4mf
 c5v4/K886qjlIVBjItBVkyRZZ201tSkIqn8IwY18jBzWJlAhjBwcQrARKrSGRk+ztnm4Dmj8WZC
 YJBQ2Nbs7omPTz1J/fT0mFsVR7ZG5ptehn+6myoYU299WLrAVlSo2femHZfzmTWfj7boli806gp
 3+soGABC4SBE=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Based on ./VERSION script updates all other files. For
./doc/changelog script asks maintainer to fill it manually as not
all changes goes into changelog.

--no-commit|-n flag is handy when something got into the version commit
and need to be changed manually. Then ./release.sh -c will use fixed
history

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 release.sh | 75 ++++++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 58 insertions(+), 17 deletions(-)

diff --git a/release.sh b/release.sh
index b036c3241b3f67bfb2435398e6a17ea4c6a6eebe..c3f74bc8dc587a40d867dd22e1e4c6e4aabb8997 100755
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
+printf "\tgit push origin v${version} master:master master:for-next\n"

-- 
2.47.2

