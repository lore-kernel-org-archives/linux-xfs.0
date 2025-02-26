Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AC52222A5
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 14:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740581454; cv=none; b=L+kTGQNnod0Dc2GGEDHkD0JgCzB2Bj+I5gyp0trQU9AhvlG6FHbKU/J+K1nbEwsRoZT0NZ0EjGm3kE3IU8x1+6E+U5N6uNfjVZgdy++GyShd30Qd4C3Xt0WxFPvylEFG7t55zS5NVa+HJOOvcnXDIKlo+7RSH3w13EgsR0zQAF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740581454; c=relaxed/simple;
	bh=b6VpuGhmjnJeY+MT0xwbMPhoDdQyVcCuT5ElFhmbhFw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Pvh4V1rPd+/8/5BRcelzs1F5FsQCh16iGvKZHfifL98dqgvhVKBbj57XGgIHyN6lxoG1seAjUlMQ6DIXAptKdnrcH+5muDf5l0SwBO3ucolpMfTAgrJ5AD6ImlZVNuHTxagQOjOT317Lq9lA3g8Mi8cSUEY/Jw0am3lpzKfee6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JJpk20UC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JJpk20UC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740581451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N4vx4VBQ6GbCq2IqZ3u6bl+vK4FweiYa9dSee+sAslA=;
	b=JJpk20UCiAjjR++EUB1WwhO1YryyZ7Bw6Iypmm5VfXM9AahcfG6vntXzXj73g8H5kRFs5J
	LTxL7Za4dAlonaSEJ4QMU8g2AL7k8P18/RPFCxYNwwYVJ9JVOkxp06xuK58GFHZD2KUqeG
	v+B6wvUyO98NN525c9sWSvKwJthMqz8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-Fb3DE9CZPXSb_2lRX7bcQw-1; Wed, 26 Feb 2025 09:50:49 -0500
X-MC-Unique: Fb3DE9CZPXSb_2lRX7bcQw-1
X-Mimecast-MFC-AGG-ID: Fb3DE9CZPXSb_2lRX7bcQw_1740581448
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-abba4c6d9ddso780128466b.1
        for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 06:50:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740581448; x=1741186248;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N4vx4VBQ6GbCq2IqZ3u6bl+vK4FweiYa9dSee+sAslA=;
        b=m2MQGT7q/juwbAMw4kjxio5E3dWkybF4QvBFaom3hoBde6/NyGHfHEgWxi/4BTU7Zj
         UneYGB1Vaorzha2Mqmgr1JHZznY1QyhRJIdDxw7/4T1cfxTxutjygGTdKergC/ZSEQxT
         DZ9wvvRZsK558snVSLS9Lo6Foa/hs06gyZyDNjjuVDZ2bcHR5q1sYmajEL+xVm4ZGUva
         jaEtEwuOmbvqWcyd53vi8Pxkozn6To61k5VJipdx7q6kV7IATUcU0bNq+KngQ7JhHJH7
         9pA+x2Vys9mXdFG63mjGuh7Z1WjIGN3mReaUP2m8Yp3P+HmufhCWFP4dWEpi2q/LORNN
         p0bw==
X-Gm-Message-State: AOJu0Yyykgv1JWKgs/jFfcc/Hdw6Suni/tXGNWhX2tj1ivFiX9AybyGE
	ZuTUSFSj4ni+fFCV0yUyN4JkIE69JRnM/fQeNTWccxQkf2U9yMq4Ra7JdBPRl+waclGfuUTsvQ8
	KgpC1X43Qc9Zq6IO1eKjlwvvat3wJA3tWUPcU5bQnWISv4JAMWmlY8xrF
X-Gm-Gg: ASbGncud67p7q6oS6IWeiQavUmAkiTXmaUVyx14DheJKpchc3l1/puIQg4a3eDM9AzW
	JHriRsxhcaETQKeYAzfOrkZN1YicgWfiJYjI4rv3MCFGNzYe5Ctaf744JdfNzeoGpiz8pHqPJws
	UYG76XqoOcmVBiNhQxVBO/kH5AQO64yhvsvSITK91Oxi6UdE5Pb4vFMqqdGBJhZVsWLez1YS53V
	8AJPU+Xvy8NS3KTyWr/urtlvGHlgJKGA0EX8ApG+TPiUd7EtwzCBnrxb5NIHPa6IY8lMTC2fSG+
	s/cA+VLMCNTOUM+5kyks5dFuLTZnnc1r1aIDoPmSSg==
X-Received: by 2002:a17:906:6a22:b0:aba:6204:1c03 with SMTP id a640c23a62f3a-abc0df5d89fmr2521170066b.57.1740581447941;
        Wed, 26 Feb 2025 06:50:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG5KQZWIST/nMrryAAjeVIMaR9mEBJFmjzaEn7XACtdinURzx/Yw9Sm6Cv0oDuTDaUeDiAt1Q==
X-Received: by 2002:a17:906:6a22:b0:aba:6204:1c03 with SMTP id a640c23a62f3a-abc0df5d89fmr2521166466b.57.1740581447545;
        Wed, 26 Feb 2025 06:50:47 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed1cd564esm337731666b.21.2025.02.26.06.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 06:50:47 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 26 Feb 2025 15:50:28 +0100
Subject: [PATCH v5 03/10] release.sh: update version files make commit
 optional
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250226-update-release-v5-3-481914e40c36@kernel.org>
References: <20250226-update-release-v5-0-481914e40c36@kernel.org>
In-Reply-To: <20250226-update-release-v5-0-481914e40c36@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3871; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=b6VpuGhmjnJeY+MT0xwbMPhoDdQyVcCuT5ElFhmbhFw=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0vdrOU84aMCe1Ls0OJal8/aB2qCgBXp5JtP5onZsa
 jEUvfXp/MaOUhYGMS4GWTFFlnXSWlOTiqTyjxjUyMPMYWUCGcLAxSkAExHVZ/gfd9zV/Lf/vo4w
 Xs76iumKm6x8VwusmWq8bNHuQwuOPeDMZGS4uVMz/rNa4c8THus41nLWfv7amLzeIGtLWtqFwji
 xGVO5AWcBRgg=
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
index 42bee75bb6fde7056c1770157f253eb5f492036d..385607f636d965ad98f0f3115e6f34d9e4042592 100755
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
 	echo "$(basename $0) - prepare xfsprogs release tarball or for-next update"
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
@@ -87,4 +126,6 @@ if [ $KUP -eq 1 ]; then
 		pub/linux/utils/fs/xfs/xfsprogs/
 fi;
 
-echo "Done. Please remember to push out tags using \"git push origin v${version}\""
+echo ""
+echo "Done. Please remember to push out tags and the branch."
+printf "\tgit push origin v${version} master:master master:for-next\n"

-- 
2.47.2

