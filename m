Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7333B27FB
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 23:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788218873; cv=none; b=RHhGLEZKMFqLYW64bZaaihg0IPPckdkK8Wb7QSAqXafSujiJAjDRUTdgrSsg3yWbKSRkeAAV+kSmYg7jbt5woNaUa4V/oMT+8perVUjOZKqFpu/3+6nHbQXCdFVx4SiEEk8a1BnVdkgZ3rb+LXXfOXmdc28WJ3DOscvgtYfMzII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788218873; c=relaxed/simple;
	bh=MvWh5ICZ64xIMZK5rCoFo+3mp3zk+uuprNZ/o5keAUA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uN4WmJrfuWV9Kng1ec+kJI2LVF8+saMoc/v1sER1N2mY151L7pxzD8D+nAICMlYXFMC8OjeINcTkjsExASojOxql0uZxyCiBB4Ti4CL7nJ5CFy6N6HE+4NuE9AKxUUorzSolYnZmkwaZ47fSWsGf8QkGnrE+fpLzQ9P41VF95vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jjqn5vvk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jjqn5vvk"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 357901F000E9;
	Mon, 31 Aug 2026 23:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788218872;
	bh=ue8QXRk8NNf61GbjIATFX3u4sDPF8wLwAaB6GmjS62M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Jjqn5vvkjw1BKKtI9603kfWqZcAiEkY/qmqK5n1u9WvI9a5SgL/giU9W2sYavwnr9
	 WUQ7r17K8cCUnPZ3D/ijCYzh8KT8oR0icVqKkwX3HZT6sxEGPMCRI5/S0EwRNhTc/p
	 ZJIbF+77Iislgumb+lAIcym3VopPBP5Rgbf5gW1Ums1OV4dLJjxOaGKsRbbZGWq66N
	 HDIPOGtPKdUf2dEd/zlzk3M+dTFKgEpUCakcQ1UuKQx8bKVwDAOihfp0X/bu1iKSzS
	 H5zoPSDppQl+Fv4IdF8DJGYf4w09QxCLrQJ9Wjnvwo0eUU3f4yT3f5V0VLMM8hILgY
	 mBHS8XAwswYUg==
Date: Mon, 31 Aug 2026 16:27:51 -0700
Subject: [PATCH 5/5] xfs_admin: print configuration file for mounted
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178821870683.2381199.15369045052932427521.stgit@frogsfrogsfrogs>
In-Reply-To: <178821870568.2381199.9038448943413709082.stgit@frogsfrogsfrogs>
References: <178821870568.2381199.9038448943413709082.stgit@frogsfrogsfrogs>
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

