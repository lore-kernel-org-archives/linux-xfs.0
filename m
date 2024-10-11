Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B2C26AC1;
	Fri, 11 Oct 2024 01:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610922; cv=none; b=tPJzwy0kUm+2IVY4SNeZ5m4Ah9G0wFFstwau2fDe1GQlBrYZbvOSMvbs9nKLEuUkGzca8DEvB64dD0NDnLFdquyWBmpS4ISsuBgf8SjDEDRq9E2Wsv5l6rBLRcqYlZJG5zmBsLNsmS0Muo/uU9Vfnuo6pZfkduSYV9k+JconNig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610922; c=relaxed/simple;
	bh=JzmMVNxtm/t4f7tA6XWsqLASyLTQYHzAN2fRl6rcB68=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YdZdV4mq9eXm5/f7aH2Xw/4TB4SN0wq2uHjUSSDFskRHwEib2T3WuAsIafLzwBduXz/57EFRMTgOXHzTna8pniHu0k7HiXgesRYFe/WHMdM7RsRDSzoLPCzKNfKC8XqLqQewMItu+uiQaUQCfUkhSwkqFtvNrZ9+IMI00k1IlL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JW+UGamL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JW+UGamL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB868C4CEC5;
	Fri, 11 Oct 2024 01:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610921;
	bh=JzmMVNxtm/t4f7tA6XWsqLASyLTQYHzAN2fRl6rcB68=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JW+UGamLq3gubfAvY0Ftre+eLIis3hI+T/U8DPOdcSwqX9/bSaisLRsLcP7xtWo5B
	 Z7mQvzsRCplgUvqIxEKZ8rz9jcwEH5t/+yhsB62xxt0nwuE0cD18yNLrSOw+jErLPT
	 S4bDCc/OXZ3xlc1xf538LEfVkv5+1v+9qqkfn38e91FNS09pXdsffcewU6GDqVUxco
	 yXqEza3LhbK/ZUaNx3KIpsIPZLxPSa3xbFQl5yr4KRO56Ky9hX48MVLk9dtRX7oj26
	 Bpor5E7YB9MmqaP5QzPnDQgqSDh0fsIsOlSb3HZWyZOWytPGBGTEAbfyY6qyqPBWgT
	 Uh+Q9mCb5UWLA==
Date: Thu, 10 Oct 2024 18:42:01 -0700
Subject: [PATCH 04/16] common/ext4: reformat external logs during mdrestore
 operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860658582.4188964.312537719739222724.stgit@frogsfrogsfrogs>
In-Reply-To: <172860658506.4188964.2073353321745959286.stgit@frogsfrogsfrogs>
References: <172860658506.4188964.2073353321745959286.stgit@frogsfrogsfrogs>
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

The e2image file format doesn't support the capture of external log
devices, which means that mdrestore ought to reformat the external log
to get the restored filesystem to work again.  The common/populate code
could already do this, so push it to the common ext4 helper.

While we're at it, fix the uncareful usage of SCRATCH_LOGDEV in the
populate code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/ext4     |   17 ++++++++++++++++-
 common/populate |   18 +++++-------------
 2 files changed, 21 insertions(+), 14 deletions(-)


diff --git a/common/ext4 b/common/ext4
index 13921bb8165a4d..e1b336d3d20cba 100644
--- a/common/ext4
+++ b/common/ext4
@@ -134,7 +134,8 @@ _ext4_mdrestore()
 {
 	local metadump="$1"
 	local device="$2"
-	shift; shift
+	local logdev="$3"
+	shift; shift; shift
 	local options="$@"
 
 	# If we're configured for compressed dumps and there isn't already an
@@ -148,6 +149,20 @@ _ext4_mdrestore()
 	test -r "$metadump" || return 1
 
 	$E2IMAGE_PROG $options -r "${metadump}" "${SCRATCH_DEV}"
+	res=$?
+	test $res -ne 0 && return $res
+
+	# ext4 cannot e2image external logs, so we have to reformat the log
+	# device to match the restored fs
+	if [ "${logdev}" != "none" ]; then
+		local fsuuid="$($DUMPE2FS_PROG -h "${SCRATCH_DEV}" 2>/dev/null | \
+				grep 'Journal UUID:' | \
+				sed -e 's/Journal UUID:[[:space:]]*//g')"
+		$MKFS_EXT4_PROG -O journal_dev "${logdev}" \
+				-F -U "${fsuuid}"
+		res=$?
+	fi
+	return $res
 }
 
 # this test requires the ext4 kernel support crc feature on scratch device
diff --git a/common/populate b/common/populate
index 94ee7af9ba1c95..ed3ee85ee2b6db 100644
--- a/common/populate
+++ b/common/populate
@@ -1021,20 +1021,12 @@ _scratch_populate_restore_cached() {
 		return $?
 		;;
 	"ext2"|"ext3"|"ext4")
-		_ext4_mdrestore "${metadump}" "${SCRATCH_DEV}"
-		ret=$?
-		test $ret -ne 0 && return $ret
+		local logdev=none
+		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+			logdev=$SCRATCH_LOGDEV
 
-		# ext4 cannot e2image external logs, so we have to reformat
-		# the scratch device to match the restored fs
-		if [ -n "${SCRATCH_LOGDEV}" ]; then
-			local fsuuid="$($DUMPE2FS_PROG -h "${SCRATCH_DEV}" 2>/dev/null | \
-					grep 'Journal UUID:' | \
-					sed -e 's/Journal UUID:[[:space:]]*//g')"
-			$MKFS_EXT4_PROG -O journal_dev "${SCRATCH_LOGDEV}" \
-					-F -U "${fsuuid}"
-		fi
-		return 0
+		_ext4_mdrestore "${metadump}" "${SCRATCH_DEV}" "${logdev}"
+		return $?
 		;;
 	esac
 	return 1

