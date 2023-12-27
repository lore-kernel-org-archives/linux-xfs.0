Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCE23C35;
	Mon,  1 Jan 2024 00:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TXH1WI0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998EFC433C8;
	Mon,  1 Jan 2024 00:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070507;
	bh=fqyySn2E9nD3lk/IWViGdvk6D97X8kWv5pt+qkoHP78=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TXH1WI0clpllBBzuy0WQ2JxR7MaQ+O+xSjG/vP4iYaYo0jksLkAR6SEJdHCOnG1DS
	 V2v2tNBP6lFEF8vhIVKfUDd2lWc/itKoEWjjHSHKLo4FFaUotfZ9cStb02Wn+vFBOK
	 Xisz5ViFYjX4+Xa6Q/FENVkC/aUVtQSpIMycNGTSBwL5tsVVW3bg2KRj5vIFeQ38hN
	 cIbHbJzjOfTJ8nHGEbFSq+dpoY3uYBlD7ibCKbf+0/62biektmw9mwptX0fP7OGZ/X
	 AQZa+SLOKv2vC4hjzky5nxlOzfQtrJ77WVp48JsoBkfW5f1VDGim7HQPwPF5GuAL4e
	 +7IggkgMRkhUg==
Date: Sun, 31 Dec 2023 16:55:07 +9900
Subject: [PATCH 09/17] common: pass the realtime device to xfs_db when
 possible
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405030455.1826350.17236733624947817610.stgit@frogsfrogsfrogs>
In-Reply-To: <170405030327.1826350.709349465573559319.stgit@frogsfrogsfrogs>
References: <170405030327.1826350.709349465573559319.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Teach xfstests to pass the realtime device to xfs_db when it supports
that option.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)


diff --git a/common/xfs b/common/xfs
index 175de69c63..aa1c23dd54 100644
--- a/common/xfs
+++ b/common/xfs
@@ -282,10 +282,10 @@ _xfs_check()
 {
 	OPTS=" "
 	DBOPTS=" "
-	USAGE="Usage: xfs_check [-fsvV] [-l logdev] [-i ino]... [-b bno]... special"
+	USAGE="Usage: xfs_check [-fsvV] [-l logdev] [-r rtdev] [-i ino]... [-b bno]... special"
 
 	OPTIND=1
-	while getopts "b:fi:l:stvV" c; do
+	while getopts "b:fi:l:stvVR:" c; do
 		case $c in
 			s) OPTS=$OPTS"-s ";;
 			t) OPTS=$OPTS"-t ";;
@@ -297,6 +297,7 @@ _xfs_check()
 			V) $XFS_DB_PROG -p xfs_check -V
 			   return $?
 			   ;;
+			r) DBOPTS="$DBOPTS -R $OPTARG";;
 		esac
 	done
 	set -- extra $@
@@ -340,6 +341,10 @@ _scratch_xfs_db_options()
 	SCRATCH_OPTIONS=""
 	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
 		SCRATCH_OPTIONS="-l$SCRATCH_LOGDEV"
+	if [ "$USE_EXTERNAL" = yes ] && [ ! -z "$SCRATCH_RTDEV" ]; then
+		$XFS_DB_PROG --help 2>&1 | grep -q -- '-R rtdev' && \
+			SCRATCH_OPTIONS="$SCRATCH_OPTIONS -R$SCRATCH_RTDEV"
+	fi
 	echo $SCRATCH_OPTIONS $* $SCRATCH_DEV
 }
 
@@ -404,6 +409,11 @@ _scratch_xfs_check()
 		SCRATCH_OPTIONS="-l $SCRATCH_LOGDEV"
 	[ "$LARGE_SCRATCH_DEV" = yes ] && \
 		SCRATCH_OPTIONS=$SCRATCH_OPTIONS" -t"
+	if [ "$USE_EXTERNAL" = yes ] && [ ! -z "$SCRATCH_RTDEV" ]; then
+		$XFS_DB_PROG --help 2>&1 | grep -q -- '-R rtdev' || \
+			_notrun 'xfs_db does not support rt devices'
+		SCRATCH_OPTIONS="$SCRATCH_OPTIONS -R$SCRATCH_RTDEV"
+	fi
 	_xfs_check $SCRATCH_OPTIONS $* $SCRATCH_DEV
 }
 

