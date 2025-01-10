Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB141202F8E
	for <linux-xfs@vger.kernel.org>; Fri, 10 Jan 2025 11:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736507124; cv=none; b=jTdfYEaw1sqOaBP32HNZugIQ/Z1HM/OnpRqlTaofYX1lBoGimUMkpmhpxsyAfeAWTzQ2zbgDR+l3PXus3kIKQdMM6e8k/DZFDI0FmdawsOpiKBD4mKxf5oiHadbhUQdyQDpstKAN0u9cD9GA/bg6KBI9DuwQgOvWlFS7i+ZVQes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736507124; c=relaxed/simple;
	bh=2EUJESO8xyry4tieamUkyHtngI/WVawE7Imfc+Z+388=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dSXRXWB8puzwJnZQDwTkwT/o3JeThTjgJIV6AdqVySqccAIYC1Xu04QGiPzn8ArVVdetclvPqEnvSLwGNRBWO/rPl3WUh+JQgRziW+6FnjqW/b1/MXJTFyooNc+dTxqMgqikBW7va6Y7e7mGy9PcmUstY6zXSxW6vJBi6zf4MgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cxqT8LBA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cxqT8LBA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736507121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GDrHeHcxdMc+m86AV4aP2MIFDlrI5kqERuwT04m8aIQ=;
	b=cxqT8LBAH2O7LKd/PReyP2XmtlWAQhp2gzI0TdlY4LwCfm9RGI3GptHjFc01sMUk8DP5hv
	E4NvXc5Qqj3lKMuhbJ03cnURAz9E056KdL8yIBNKvy/tNoXLuM+1Nk6kttCaQ88aabyEys
	h93DdwoD1B0erP1mQjVRCoazmEojdh4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-S0uoEppcNEavx1O7W20C_A-1; Fri, 10 Jan 2025 06:05:20 -0500
X-MC-Unique: S0uoEppcNEavx1O7W20C_A-1
X-Mimecast-MFC-AGG-ID: S0uoEppcNEavx1O7W20C_A
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4361f371908so13610765e9.0
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jan 2025 03:05:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736507119; x=1737111919;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GDrHeHcxdMc+m86AV4aP2MIFDlrI5kqERuwT04m8aIQ=;
        b=lD6+nw23aaPyYCHvRtSxdSdsd/1tUbcOtHV5poql2qbKf12Mp8Qekr2ELwzasoeMqP
         kC6ts6LWegCbxCIfoZT/gWPV+eXDWJMJW6J3ac+o3P5TpnKwrEFZYKtIjd04XisihvTm
         Laoz9jESb3OJi4ymuLCUWvpNBzK1otiU8ipOEEuinhMRG6UssSUIZcvlfNslwWTuszqC
         xKJmddw7bAwYGB47gDGRH0r/RLzCBmqE5kaERsd4ocd7tX8KNie7POOI6BD/9s5LkhgF
         8eRODAfLvauSmZRD197AqWnyp2rmSPRvFRhSWekfk7vgmIPQNVDz47DHghTk1r+wjOYc
         qFbA==
X-Gm-Message-State: AOJu0YymViJFToYS8Otj3A7z2CqXDm6IXpB+3EPce889ZQXB2UChT5c1
	wnCWi+wmQb/8FJpjd4iIb7b4bJs0wqmeJS21yzBB9/HmhsE1sak7bfQmeMhXsPl7CmjBNtZGhER
	9smVmeQrGUYb51dYz5jg56/UvbeTX3QjncGplv942T1nuK/9617waP0VtuD7Y6wdh8QD7t3vcFQ
	832gUesEZyU7pZHh3Mv63wsnpiieP/pYWILSYNr8PC
X-Gm-Gg: ASbGnctOdl87TrtnKHe7eKUxRrEX2A8vsSmNFcfWsibLQsRHbSvHtJecmex7mp90Cbk
	XkV3902WHOEyEV2s0y1ITlnRzNG0YCRu2arslPIBpqj/XYrJigyPyVgcxcFgKdhk5betIOicfyN
	HDDZ3HFdeztN0/R0hnmjGOI/GZ1X3o+1Zags5tNdaJSXh6gsukZt/TsizQzBiE44GOkojb6tr+J
	HOMWk8lwtrShd0DFjJCHKHn1YgG2hFxvITiJ6zNhcwrKXhwNcIhyimW6fLaKzSWbKvcX9Kfp5M5
	zXvxmc4=
X-Received: by 2002:a05:600c:4ed4:b0:436:1b81:b65c with SMTP id 5b1f17b1804b1-436e26c0a33mr102150275e9.15.1736507119289;
        Fri, 10 Jan 2025 03:05:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGACLYmcU4v4uyk/ZSaSy4tn+l3xr+spR8WEQtowLinZxBrtKHUrTCnYclvS2di1Y9o2e5vYQ==
X-Received: by 2002:a05:600c:4ed4:b0:436:1b81:b65c with SMTP id 5b1f17b1804b1-436e26c0a33mr102149875e9.15.1736507118828;
        Fri, 10 Jan 2025 03:05:18 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e2ddcb5bsm84774835e9.23.2025.01.10.03.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 03:05:17 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 10 Jan 2025 12:05:08 +0100
Subject: [PATCH 3/4] release.sh: update version files make commit optional
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250110-update-release-v1-3-61e40b8ffbac@kernel.org>
References: <20250110-update-release-v1-0-61e40b8ffbac@kernel.org>
In-Reply-To: <20250110-update-release-v1-0-61e40b8ffbac@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3824; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=2EUJESO8xyry4tieamUkyHtngI/WVawE7Imfc+Z+388=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0hv+vf54i0+sY1Xv5p2ZU6a99XFre2+yKiJ0T49ef
 rjFlA1271s6SlkYxLgYZMUUWdZJa01NKpLKP2JQIw8zh5UJZAgDF6cATMRzI8M/QxMJ9y575rxY
 /s2pG5f/5JsU9epo5OIwIRNW1rsGW957M/z3t/Hdve049+3ooOINwu8Sujks6s+F5jpzX5kautQ
 qoIQHAC1wR1I=
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
 release.sh | 76 ++++++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 59 insertions(+), 17 deletions(-)

diff --git a/release.sh b/release.sh
index a23adc47efa5163b4e0082050c266481e4051bfb..c34efcbcdfcaf50a08853e65542e8f16214cfb4e 100755
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
@@ -83,4 +122,7 @@ if [ $KUP -eq 1 ]; then
 		pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-${version}.tar.gz
 fi;
 
-echo "Done. Please remember to push out tags using \"git push origin v${version}\""
+echo ""
+echo "Done. Please remember to push out tags and the branch."
+printf "\tgit push origin v${version}\n"
+printf "\tgit push origin master\n"

-- 
2.47.0

