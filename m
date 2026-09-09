Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DBB7082D
	for <linux-xfs@vger.kernel.org>; Wed,  9 Sep 2026 06:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788933741; cv=none; b=I0CPRqpkr9PRiY6kjPnynxYkxUXYe5C6BYt1CzhbL4y6p4eTBFEKamIEWYtSyvFOP2CXNUVpdVpjudOpwECZOJ5off+lCbQZryB7eejW9DRRgy1Mnfn7iMy58HvXCzw1yumEvj7at72Uz/a5ecTqtDHS/U9FQIE3nTNUJQUOaNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788933741; c=relaxed/simple;
	bh=BaCkE7uymKwlUFlinMV5fMtpuE2vy1M8WCeNJT2a0OQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OP/PPO18CeMhUunCWPq8gc93xBbrZp3j3pVjSSnduZXRwD0AHN6+9JbO0A8lcwxXzOhxKj2BmVYIfQcU3qfC0UuX2mAIU7rTOxoIckoBsxfMXeJwcgevmpxAyEzWFDX9S50aYaXEPCOyNMRMLa2yOEEf/zlEwgkl8jG/eUVdq9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gY35pMQO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gY35pMQO"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 52E171F00A3D;
	Wed,  9 Sep 2026 06:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788933740;
	bh=kzaEDHw4uQYW8yFIY/LrVJ1lPVgntweHIoXnf3GFKvM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=gY35pMQOZS81fRbyuVsM6m0VW9fMBD2/cUF6NWyZa7218sA3fKaxh8LutxXbEDW3x
	 xiwy5e2V9BFXQOptTWmk32YHrq2NnJDW5kxbaCMYHWvSe0GklyCwIBnD8wCTAmrMoE
	 kNQtqfHV41nNg9C7L5jKVGvHYrq8FvDv5xqNdMzXwquKWu3tmX7ageYlJov/q73CjB
	 DSd3YjoEHss168JBrbY6OLdIVQet1I64nToVJ4KpXBKSLtYph8M0mPD0a7A4Lul2dQ
	 6BKeJb/HSyrXjf/ldwdIdxrljHRn0eypGNQbhy1KpNotW+kUWU8G2VZu7oTxhpnxZ+
	 4bsL4fe9Zxggg==
Date: Tue, 08 Sep 2026 23:02:20 -0700
Subject: [PATCH 8/9] xfs_admin: print configuration file for mounted
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178892910678.4047311.6897947264568294544.stgit@frogsfrogsfrogs>
In-Reply-To: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
References: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
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

