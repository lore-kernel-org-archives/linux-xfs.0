Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A17327FD43
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 05:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789364961; cv=none; b=kP/KILGd5p7LLf46Vfm3/pgnGbIyTHp5WrNcJMdlbyCXcy7LmYruK1+ciotT8nEZIHw2tuLikk0isAnAo1RJlg3s/DcwFJCUzXXnpP+RMsJmnhXawm63kE2dpcjwB904ICuH2MZ0gD80WtIcJ0nzeKidCH2TMs4Zyd3D4NqAuaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789364961; c=relaxed/simple;
	bh=QYi917k6YvzkDzEfq0s1QcHfDEyIqstRkjsqnvuQuFE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UJjIUMHDPGl43Dfk3lMqfJqpWkmx6WLI6Afg6WNKfsGnCiaDLfIPPPjJo77rfPbkIUbdz9GTWWvHBoxd6RGxu8RAN0lkbhXX7ca8aG344OaRE641q3Qki+Iq/y7HrhxIEt8kVDB8QHJGFTOAfJNI5d7f+mx2cdx3X1oZzdJkGJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JB+xqFdB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JB+xqFdB"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E5A2F1F000FF;
	Mon, 14 Sep 2026 05:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789364960;
	bh=VBn8ql1BKGmBLziPFCdinQ5SCkJ28qpPlpAaUuU3WOI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=JB+xqFdB0M6VGZLe3z2ZsJYIzDdgVig83zKrWfibS0wLwnLLZP9LboYEsp0r3QO53
	 Z+B5UpiXYShfTfPDl7eRbEhoXm0JC8VQIaFtVNTd55VBWxoWDrQGXFwCsnNDRXPHcP
	 S9wmX7eSY2iRgsXJ9r937d5eHNZy2oxUCinN6/iasNCkM9SoZndxWzyQwypNaDWoBN
	 Rvzs37YvTjE1uGaEIcHjAdwxKZ2K5jgY0uM3oxxmrtYu0OZAimjb0InpBlAt+5TVBG
	 QVe2GNwnVVboot7fKj7eYKXAivO8Ynv75IlCZTrJWcu4NhE3SUQMBSPunxQeCcj84U
	 LZ5AITfLW1bHg==
Date: Sun, 13 Sep 2026 22:49:19 -0700
Subject: [PATCH 5/6] xfs_admin: print configuration file for mounted
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178936484550.2108437.14869952452109310408.stgit@frogsfrogsfrogs>
In-Reply-To: <178936484431.2108437.14645667775156303668.stgit@frogsfrogsfrogs>
References: <178936484431.2108437.14645667775156303668.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Teach xfs_admin to emit a mkfs.xfs config file for a mounted or
unmounted filesystem.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/xfs_admin.sh      |   15 +++++++++++++--
 man/man8/xfs_admin.8 |    8 ++++++++
 2 files changed, 21 insertions(+), 2 deletions(-)


diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index 52a658ba4a540f..13a876ad8d1377 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh
@@ -11,16 +11,20 @@ DB_OPTS=""
 DB_DEV_OPTS=""
 REPAIR_OPTS=""
 IO_OPTS=""
+SPACEMAN_OPTS=""
 REPAIR_DEV_OPTS=""
 LOG_OPTS=""
-USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-O v5_feature] [-r rtdev] [-U uuid] device [logdev]"
+USAGE="Usage: xfs_admin [-efjlpuV] [-C cfgfile] [-c 0|1] [-L label] [-O v5_feature] [-r rtdev] [-U uuid] device [logdev]"
 
-while getopts "c:efjlL:O:pr:uU:V" c
+while getopts "C:c:efjlL:O:pr:uU:V" c
 do
 	case $c in
 	c)	REPAIR_OPTS=$REPAIR_OPTS" -c lazycount="$OPTARG
 		require_offline=1
 		;;
+	C)	DB_OPTS=$DB_OPTS" -c 'makecfg "$OPTARG"'"
+		SPACEMAN_OPTS=$SPACEMAN_OPTS" -c 'makecfg "$OPTARG"'"
+		;;
 	e)	DB_OPTS=$DB_OPTS" -c 'version extflg'"
 		require_offline=1
 		;;
@@ -72,6 +76,13 @@ case $# in
 				exit 2
 			fi
 
+			if [ -n "$SPACEMAN_OPTS" ]; then
+				eval xfs_spaceman -p xfs_admin $SPACEMAN_OPTS "$mntpt"
+				res=$?
+				test $res -ne 0 && exit $res
+				test -n "$IO_OPTS" || exit $res
+			fi
+
 			if [ -n "$IO_OPTS" ]; then
 				eval xfs_io -p xfs_admin $IO_OPTS "$mntpt"
 				exit $?
diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 63f8ee90307b30..b118b338fb53aa 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -8,6 +8,8 @@ .SH SYNOPSIS
 ] [
 .BI \-O " featurelist"
 ] [
+.BR "\-C " cfgfile
+] [
 .BR "\-c 0" | 1
 ] [
 .B \-L
@@ -85,6 +87,12 @@ .SH OPTIONS
 .B \-u
 Print the current filesystem UUID (Universally Unique IDentifier).
 .TP
+.BI "\-C " path
+Write a configuration file to the given path that can be re-read by mkfs.xfs
+for a future filesystem format attempt.
+This file will contain only user-visible features.
+Filesystem geometry information is not written to the configuration file.
+.TP
 .BR "\-c 0" | 1
 Enable (1) or disable (0) lazy-counters in the filesystem.
 .IP

