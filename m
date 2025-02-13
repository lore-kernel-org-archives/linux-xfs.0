Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C577F24BC1F
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 20:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739477766; cv=none; b=FViYE9mMQKxbPfF7pPsevvkTkWx/mdP57sTmmyzR6/QkGqYFmnNBt2Te1VfhDBn43rzbv7pU+NZ0w+3zl/V/tokUYWp/Gfgd4JHMmqxsUTecDa2gd9XvhkESK64zNHcnVuG8zGSRkGX1vkH5biqfrIEmc28Nxb27HEXwPj3B4kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739477766; c=relaxed/simple;
	bh=em41zXomO0jL9kZk0F8GUYFuiu2onzUI7wqVleP04iE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RYsfeh9e+Zo+hexRaNBNDoeNaUOMlaop3jaxA+Hq08DLNtM/M/qbHt7/FQOIjZGW9fBNzxUhY4wQFAkZTx59U5IvGEiWWk4qiKmQwOa6aAg5jNdFmdka5w99oUbzaPYDCH10CmHlBUDwHRQHNjXi97q85wy8zlHPidUyCe5EF7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Um/lgZEq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Um/lgZEq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739477763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EVF6Djswvdycv30ceiXMOHnHpXzJo3+aaqOC0QnjsTc=;
	b=Um/lgZEqYHFlMBGz2Sv5QVHiIoM6qMt6bwLIBpviFdTtLbsHRFmwgIv6eN5dGD5nlpd+JU
	4qsX6/p/kNT8tt3aMPzLAyLIdCBX9VxTsN9OITAT4CCPaFrkSkGJq4qzE79T4NFkuRrywz
	cMp4LPovWhsfzf048g0QqdgxVk3aIBc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-iu27gUF7On61JC85HfHKGg-1; Thu, 13 Feb 2025 15:16:02 -0500
X-MC-Unique: iu27gUF7On61JC85HfHKGg-1
X-Mimecast-MFC-AGG-ID: iu27gUF7On61JC85HfHKGg
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-38dc88ed7e6so993812f8f.1
        for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 12:16:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739477761; x=1740082561;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EVF6Djswvdycv30ceiXMOHnHpXzJo3+aaqOC0QnjsTc=;
        b=UFTJeBtmF/12DX4PQbebEWQxq6g6N81iggsaHTRP213hE9nGfgh9z4YdHnjlzmWtQG
         G1katQboGePeMMZytsS7aJBgcacGb5RCq/zRo4PzN8QlJYH3JodJOBc+DEQzuNKFyowQ
         UbJ3g596BP23D2nT7R2lDFrLpJXogjkIo8TRfPcKF2HfRnfoe7ZpfWh1BytarKtoHBkL
         znzY7UnXmXU/MOoC7Hut4YGdVyQC2neLUxh7WqrP1Fkp3rhVFab9BklOR6eBvp8LskEV
         s4TwpF8yvKFlRF1DBKyBaDwOD2xDqQTFpgfPboU1mKQfXXfljzllKGkJwrmrEvRzpJ04
         Epbw==
X-Gm-Message-State: AOJu0YxKyi3T1zDMU8C6WPbGlubD+OHYKKxX0grlUqpbi8UFBAQf43CJ
	XS3D6Z8CocSUaREZzldHT4IfnOk78nNmrdRUenP4msZ7RGEoXWCR87H+UbFyIHYyLYWkYc/nnJ3
	ZdJZWlKUNhuhmoKU2gXdgJBMkFH3IKGOfrmBI2nUO9gGhl246i2xdBJwJO4UtQVfC
X-Gm-Gg: ASbGnctQq2KBgI/cYkUrVIUcck+BxOhRRoumg89WkLvIzqppIIZdYWDgu21P+bda9wO
	cE8LZpNAtUr1oEVxlGxSpNZTopdZBac79ndDZfUKKYgtBVnsQo0t5wawc+5nGcSk8yeOQzDjSL5
	1hbUxYvWuOQvIlYFsrfNkpbWuGmKvzyQQ6QKlHYtz28kmcuQZaaFGFvuCphA+/WhYbWyWtmBy2x
	sQY+tU25/zXqYvb3PKt+dwwK+eUm/XkdWif/dkwKJwYyre9XsKU/YImuq+zNWOkqIHwqNV4S0ss
	QqxfpZluDTqphxAT5kf5SIAhbUgdrMo=
X-Received: by 2002:a05:6000:12c6:b0:38e:d026:820 with SMTP id ffacd0b85a97d-38f244e539dmr6025598f8f.16.1739477760687;
        Thu, 13 Feb 2025 12:16:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH48FHFs9EFXlbhNx/RhYE6UHH12tO14eGSYBkVE2YT1VxqYOeYrtcsExZDvcpHOk3w54IxWQ==
X-Received: by 2002:a05:6000:12c6:b0:38e:d026:820 with SMTP id ffacd0b85a97d-38f244e539dmr6025576f8f.16.1739477760212;
        Thu, 13 Feb 2025 12:16:00 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a06d237sm57520895e9.21.2025.02.13.12.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 12:15:59 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Thu, 13 Feb 2025 21:14:25 +0100
Subject: [PATCH v4 03/10] release.sh: update version files make commit
 optional
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250213-update-release-v4-3-c06883a8bbd6@kernel.org>
References: <20250213-update-release-v4-0-c06883a8bbd6@kernel.org>
In-Reply-To: <20250213-update-release-v4-0-c06883a8bbd6@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3840; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=em41zXomO0jL9kZk0F8GUYFuiu2onzUI7wqVleP04iE=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0tcF/UpkKw7dbLkr5mhp4eZnMlWvjql4TJZ+839qJ
 l9Q16yPVus6SlkYxLgYZMUUWdZJa01NKpLKP2JQIw8zh5UJZAgDF6cATMRpFiPDVlEDoRtb85cF
 PvshPHHGs/V6bxUPnpXtu7voeZSOS/HPjYwMO/iUJyfei7l0pbpVqXNGQU7mh1CuOdxNSVdTsoJ
 5e43ZAPUMSGQ=
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

