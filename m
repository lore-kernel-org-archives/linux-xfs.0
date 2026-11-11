Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794409947;
	b=js6Fpma2NdtfqeloFetQHI+RSB1yC30GW3Xadi1ItrxIyM5bzIcL6TCZgeyef7VhORst
	 9kgfOyz7lUsZMaJPueQ/R2vpb8jv2pHTIV1gUoQ4r1pV/TU2nRF6GUgG5XEdrXc9/IB4n
	 6bOq8DU5+V6VPSsL06A06c9IPQtPcoSjSoWP4SwvDSstxpRi9y/1x7y0BcKVA4D/MIWTy
	 uTe0gsgV9bVstxf99aJkhH2L9XKecLZZ00L8vc9b1TZ14w+V1mbSz8CX5RFqw7JQIuOZB
	 XDJYDILmfPyRJVuHqLzktN+P0O5xUhOU3E8E91FuTKrBTRMI1I8fy3Xr8Lg64LEy84g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409947;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V15jt6PAzV2jN9y4Ocvu3+l+b6lfeicW5tfihB2M95Y=;
	b=jGejEx90b/BRm2exfEiRXDUexGCuZUfqpOU32WwOdQdD12rgbDuI13jQIVffwtohzDYG
	 9mIwLh4PJ21crmlV3/li9kEpsBxw5GOMBkamj4PN+JuTrPgN1dl7TLTuy7O2M43S1pERs
	 4UYskmoXZ17T2sMRacp8j4OZf4hDEe6SCk4zpXnh60Tqg4DJi2Khaas1akGl8hfJV5aka
	 7TaL4Gy51teEftstpbLaa6lnWaP8Y+BtLxHch0pnKv2b3Jj/VRdlDXknFWIIDt623Kvwb
	 x6jmARu8KP7vr1Rzv+MPCw7WLnEjsVE42ksXNYMv8P8dP5L+zYUVog+/4tCMt9oVssg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NbXrKAAd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776F7606A8A1
	for <linux-xfs@vger.kernel.org>; Wed, 11 Nov 2026 15:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NbXrKAAd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC701F00A0A;
	Wed, 11 Nov 2026 15:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794409947;
	bh=V15jt6PAzV2jN9y4Ocvu3+l+b6lfeicW5tfihB2M95Y=;
	h=From:To:Cc:Subject:Date;
	b=NbXrKAAdFcmIsibfMQR1lGA8QS1JtOtUCsNUvZQ5GbQGcGzEbyHmF6Fo3KjduGWiH
	 CN1Lq76yRGlekazTdyWG0d/z/5c9PalA2UuY3PZVvECBWc3anOwNpyHDbex3taQhUw
	 tk1C9B+eD5CGEfqvIUyKERJcRy0ROH0pJohCSnxrIY9gIvmgwghCLm2gC7LAVvUyEi
	 Ch1RMLpXFtoQ/A678nh5284mkRevACr/AixVg0eK7+HvksuCh5ZSachhLPjzz1bPy2
	 SO62rpEJFBQkz88JlF9iOai+SVIxSL892dx/uq+PLGZ80crcQrqvgWFarIhyaX5Z3H
	 cg2Lelw0nClPw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hazley Samsudin <muhammad_hazley_samsudin_from.tp@tech.gov.sg>
Subject: [PATCH] xfs_admin: remove eval use
Date: Wed, 11 Nov 2026 16:11:08 +0100
Message-ID: <20261111151107.3884786-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The eval is known to cause issues due to the fact that it parses and
executes strings as code. Let's get rid of it.

Remove use of eval and instead set a bunch of boolean and value flags.
These are latter appended to the empty set of positional parameters $@.
These parameters are not parsed.

Reported-by: Hazley Samsudin <muhammad_hazley_samsudin_from.tp@tech.gov.sg>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 db/xfs_admin.sh | 142 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 99 insertions(+), 43 deletions(-)

diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index 13a876ad8d13..6b2102815cd7 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh
@@ -7,53 +7,74 @@
 status=0
 require_offline=""
 require_online=""
-DB_OPTS=""
-DB_DEV_OPTS=""
-REPAIR_OPTS=""
-IO_OPTS=""
-SPACEMAN_OPTS=""
-REPAIR_DEV_OPTS=""
-LOG_OPTS=""
+have_db=""
+have_repair=""
+opt_extflg=""			# -e
+opt_force=""			# -f
+opt_log2=""			# -j
+opt_projid32bit=""		# -p
+opt_get_label=""		# -l
+opt_get_uuid=""			# -u
+opt_cfgfile=""			# -C
+cfgfile=""
+opt_set_label=""		# -L
+set_label=""
+opt_set_uuid=""			# -U
+set_uuid=""
+opt_rtdev=""			# -r
+rtdev=""
+repair_tokens=""
+
 USAGE="Usage: xfs_admin [-efjlpuV] [-C cfgfile] [-c 0|1] [-L label] [-O v5_feature] [-r rtdev] [-U uuid] device [logdev]"
 
 while getopts "C:c:efjlL:O:pr:uU:V" c
 do
 	case $c in
-	c)	REPAIR_OPTS=$REPAIR_OPTS" -c lazycount="$OPTARG
+	c)	repair_tokens="$repair_tokens lazycount=$OPTARG"
 		require_offline=1
+		have_repair=1
 		;;
-	C)	DB_OPTS=$DB_OPTS" -c 'makecfg "$OPTARG"'"
-		SPACEMAN_OPTS=$SPACEMAN_OPTS" -c 'makecfg "$OPTARG"'"
+	C)	opt_cfgfile=1
+		cfgfile=$OPTARG
+		have_db=1
 		;;
-	e)	DB_OPTS=$DB_OPTS" -c 'version extflg'"
+	e)	opt_extflg=1
+		have_db=1
 		require_offline=1
 		;;
-	f)	DB_OPTS=$DB_OPTS" -f"
+	f)	opt_force=1
+		have_db=1
 		require_offline=1
 		;;
-	j)	DB_OPTS=$DB_OPTS" -c 'version log2'"
+	j)	opt_log2=1
+		have_db=1
 		require_offline=1
 		;;
-	l)	DB_OPTS=$DB_OPTS" -r -c label"
-		IO_OPTS=$IO_OPTS" -r -c label"
+	l)	opt_get_label=1
+		have_db=1
 		;;
-	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'"
-		IO_OPTS=$IO_OPTS" -c 'label -s "$OPTARG"'"
+	L)	opt_set_label=1
+		set_label=$OPTARG
+		have_db=1
 		;;
-	O)	REPAIR_OPTS=$REPAIR_OPTS" -c $OPTARG"
+	O)	repair_tokens="$repair_tokens $OPTARG"
 		require_offline=1
+		have_repair=1
 		;;
-	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'"
+	p)	opt_projid32bit=1
+		have_db=1
 		require_offline=1
 		;;
-	r)	REPAIR_DEV_OPTS=" -r '$OPTARG'"
-		DB_DEV_OPTS=" -R '$OPTARG'"
+	r)	opt_rtdev=1
+		rtdev=$OPTARG
 		require_offline=1
 		;;
-	u)	DB_OPTS=$DB_OPTS" -r -c uuid"
-		IO_OPTS=$IO_OPTS" -r -c fsuuid"
+	u)	opt_get_uuid=1
+		have_db=1
 		;;
-	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'"
+	U)	opt_set_uuid=1
+		set_uuid=$OPTARG
+		have_db=1
 		require_offline=1
 		;;
 	V)	xfs_db -p xfs_admin -V
@@ -65,50 +86,85 @@ do
 		;;
 	esac
 done
-set -- extra $@
+set -- extra "$@"
 shift $OPTIND
+device=$1
+logdev=$2
+
+# We use a bunch of opt_* flags here instead of crafting argument strings
+# directly in the getopts loop above. This is because passing such strings
+# to eval could cause command injection.
+#
+# As we cannot use arrays in POSIX, instead we resort to using the positional
+# parameters ($@). Before calling any of the xfs_* utilities we reset $@ to an
+# empty set with "set --". Then, based on the flags parsed above, we append all
+# necessary arguments. This way each argument is passed verbatim, without being
+# re-parsed or word-split by the shell.
 case $# in
 	1|2)
-		if mntpt="$(findmnt -t xfs -f -n -o TARGET "$1" 2>/dev/null)"; then
+		if mntpt="$(findmnt -t xfs -f -n -o TARGET "$device" 2>/dev/null)"; then
 			# filesystem is mounted
 			if [ -n "$require_offline" ]; then
-				echo "$1: filesystem is mounted."
+				echo "$device: filesystem is mounted."
 				exit 2
 			fi
 
-			if [ -n "$SPACEMAN_OPTS" ]; then
-				eval xfs_spaceman -p xfs_admin $SPACEMAN_OPTS "$mntpt"
+			have_io=""
+			if [ -n "$opt_get_label" ] || [ -n "$opt_set_label" ] || \
+			   [ -n "$opt_get_uuid" ]; then
+				have_io=1
+			fi
+
+			if [ -n "$opt_cfgfile" ]; then
+				xfs_spaceman -p xfs_admin -c "makecfg $cfgfile" "$mntpt"
 				res=$?
 				test $res -ne 0 && exit $res
-				test -n "$IO_OPTS" || exit $res
+				test -n "$have_io" || exit $res
 			fi
 
-			if [ -n "$IO_OPTS" ]; then
-				eval xfs_io -p xfs_admin $IO_OPTS "$mntpt"
-				exit $?
+			if [ -n "$have_io" ]; then
+				set --
+				[ -n "$opt_get_label" ] && set -- "$@" -r -c label
+				[ -n "$opt_set_label" ] && set -- "$@" -c "label -s $set_label"
+				[ -n "$opt_get_uuid" ] && set -- "$@" -r -c fsuuid
+				exec xfs_io -p xfs_admin "$@" "$mntpt"
 			fi
 		fi
 
 		# filesystem is not mounted
 		if [ -n "$require_online" ]; then
-			echo "$1: filesystem is not mounted"
+			echo "$device: filesystem is not mounted"
 			exit 2
 		fi
 
-		# Pick up the log device, if present
-		if [ -n "$2" ]; then
-			LOG_OPTS=" -l '$2'"
-		fi
-
-		if [ -n "$DB_OPTS" ]
+		if [ -n "$have_db" ]
 		then
-			eval xfs_db -x -p xfs_admin $LOG_OPTS $DB_DEV_OPTS $DB_OPTS "$1"
+			set --
+			[ -n "$logdev" ] && set -- "$@" -l "$logdev"
+			[ -n "$opt_rtdev" ] && set -- "$@" -R "$rtdev"
+			[ -n "$opt_cfgfile" ] && set -- "$@" -c "makecfg $cfgfile"
+			[ -n "$opt_extflg" ] && set -- "$@" -c "version extflg"
+			[ -n "$opt_force" ] && set -- "$@" -f
+			[ -n "$opt_log2" ] && set -- "$@" -c "version log2"
+			[ -n "$opt_get_label" ] && set -- "$@" -r -c label
+			[ -n "$opt_set_label" ] && set -- "$@" -c "label $set_label"
+			[ -n "$opt_projid32bit" ] && set -- "$@" -c "version projid32bit"
+			[ -n "$opt_get_uuid" ] && set -- "$@" -r -c uuid
+			[ -n "$opt_set_uuid" ] && set -- "$@" -c "uuid $set_uuid"
+			xfs_db -x -p xfs_admin "$@" "$device"
 			status=$?
 		fi
-		if [ -n "$REPAIR_OPTS" ]
+		if [ -n "$have_repair" ]
 		then
 			echo "Running xfs_repair to upgrade filesystem."
-			eval xfs_repair $LOG_OPTS $REPAIR_DEV_OPTS $REPAIR_OPTS "$1"
+			set --
+			[ -n "$logdev" ] && set -- "$@" -l "$logdev"
+			[ -n "$opt_rtdev" ] && set -- "$@" -r "$rtdev"
+			for token in $repair_tokens
+			do
+				set -- "$@" -c "$token"
+			done
+			xfs_repair "$@" "$device"
 			status=`expr $? + $status`
 		fi
 		;;
-- 
2.54.0

