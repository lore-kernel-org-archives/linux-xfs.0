Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5098367F3A
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 01:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788485497; cv=none; b=KGYtRSaNGrSMTJwnd8lh5xJV4DBjyQAqMXzBwanNNNGT+AlePjnKAAm/RqIkoMZialOUWFQl3hJk1ErEEvYJAzNkzJITKP/4/0vz9CPINmQ9nsMlqfncxe9IEVFjYNjkOd/cP8llyzlAHpWXPpQS/wgBcvluTtd11MHqgxaoagg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788485497; c=relaxed/simple;
	bh=ch76ZyBG3SMGSM3BCg0K+AZPCrIPEAQ7GutS/m7qBY4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vva7NgOJgVCUDL8HYllcxJ/i7o3oyac3hPgUW+LwGsbe4kmLl+mZzQI1kAiJalGIL6kz4rSQVrNfLAG95cjNybaoxz3nCavvjampAICZYBmv+mnF3lk9U8baqYfxBuazsZwop3SPpaNPYzMbW708xzk+1sMV1VVV+nPFXbuOC/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y2Pmo2bA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y2Pmo2bA"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 86C8D1F000E9;
	Fri,  4 Sep 2026 01:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788485495;
	bh=37ZGMM+WN9i6FbE/yvZUHuMaZm0Apor/YXL84RIP4JE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Y2Pmo2bAPtcBOo3OBVB/2Gte6QvUhYzWI99zp/X8uiwjZrpdman/DAl7Me3OwdxYN
	 WWoYEOpXM1TIFDc8rn0aaSP4EFrHxaIOqwwJsXy+oJRjhKcxC0RAa9yF6JxeCK6KNY
	 7/BGhpvzb4FwtDetVPb8rdEjgundrHl3pfuuuA8+CUfWuyIWJw/hXuehWRHmtMrGcI
	 zu9Txtxrfuv03Cp89lQOTteSmNh1ngiWp1uDm+aV/LDjY0mxiyWgX2i1xMqpC0Rv2i
	 HPMlWRsuGgqZFrpRjVQk/eAF/YDFduGH458QxN8ADfkhFuKL/d5ArYbdxyPhUKUGCd
	 dZFjgZ834KehA==
Date: Thu, 03 Sep 2026 18:31:35 -0700
Subject: [PATCH 7/8] xfs_admin: print configuration file for mounted
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178848534987.1052910.13294619123998525889.stgit@frogsfrogsfrogs>
In-Reply-To: <178848534822.1052910.754281019922260552.stgit@frogsfrogsfrogs>
References: <178848534822.1052910.754281019922260552.stgit@frogsfrogsfrogs>
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
-
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 db/xfs_admin.sh      |   15 +++++++++++++--
 man/man8/xfs_admin.8 |    7 +++++++
 2 files changed, 20 insertions(+), 2 deletions(-)


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
index 63f8ee90307b30..d2652c0598f551 100644
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
@@ -85,6 +87,11 @@ .SH OPTIONS
 .B \-u
 Print the current filesystem UUID (Universally Unique IDentifier).
 .TP
+.BI "\-C " path
+Write a configuration file to the given path that can be re-read by mkfs.xfs
+for a future filesystem format attempt.
+This file will contain only user-visible features.
+.TP
 .BR "\-c 0" | 1
 Enable (1) or disable (0) lazy-counters in the filesystem.
 .IP

