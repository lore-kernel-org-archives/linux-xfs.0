Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6A5FBE9;
	Wed,  7 Feb 2024 02:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707272365; cv=none; b=l7NYoWMaH5fuGiZ1GOaQF1ZGxl2D/RgqkT8OV+9/LxnNYs34s5XFQGCaqYqugC3Kxg/ku/QnDW4HJ2DDB5Wuzhkt4XW38Wt9+c77rcQD1+xvi/2B5LajOiD8IKXjuMfFMMtTEAxkRyvA5ErnjrQfiJjQ1Y/EcYLAT5YOebKoRnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707272365; c=relaxed/simple;
	bh=JY0an+aV7JvYhVNzONkthuKt4vhY7UOlu6g94nyVTr0=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hGaz11I0FoIrVLup1TFHUEYwa8NURmnZbIFkSzrNshQTYdPE9QTV9Fhd5TSdhY4STCyWUp2VVxr8GQp6oMJNnzTHEKx7CnNplo0aRnzGVyXZujkXk8IlV/H01ihaCuLc6e5A6l3xYJ+yUWxScPclp/asOxEd+8uZMDFlxqxOA2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ai1z8DXa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ai1z8DXa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78908C43390;
	Wed,  7 Feb 2024 02:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707272365;
	bh=JY0an+aV7JvYhVNzONkthuKt4vhY7UOlu6g94nyVTr0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=ai1z8DXaZINJqPpyww4geaCZrMhkEnzCp8WIVvweIVVLdlELvXN+6eUCovseQGrhY
	 78UG5kiJQFEnA2xL4sFMonoFdeyacISA45slmvpMaLAdHx9VmQxqWPwMqeDEW0E0Vs
	 CC9qO9E5aa3XsmRvxetaMOJmVOCfRmne8upDZ2prQHdeF4LfLxhjCIcyK0KwbTs8LG
	 7Xnh4JAzNoqQYI4N8GTPmaCE/FswFaQ75qiWZm0p4nkawyxKlNXdNlGhStoXkLKEJM
	 OQ3lwYKdsBr/RfYhtxFN2qLUjkMQnLUm++JakuLSp/EKquhR9HAllkwVnVV3CfmYNB
	 IPpJQsG2l7zKA==
Subject: [PATCH 09/10] common/xfs: only pass -l in _xfs_mdrestore for v2
 metadumps
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
 linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date: Tue, 06 Feb 2024 18:19:25 -0800
Message-ID: <170727236500.3726171.13197353676937666826.stgit@frogsfrogsfrogs>
In-Reply-To: <170727231361.3726171.14834727104549554832.stgit@frogsfrogsfrogs>
References: <170727231361.3726171.14834727104549554832.stgit@frogsfrogsfrogs>
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

fstests has a weird history with external log devices -- prior to the
introduction of metadump v2, a dump/restore cycle would leave an
external log unaltered, and most tests worked just fine.  Were those
tests ignorant?  Or did they pass intentionally?

Either way, we don't want to pass -l to xfs_mdrestore just because we
have an external log, because that switch is new and causes regressions
when testing with xfsprogs from before 6.5.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 common/xfs |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)


diff --git a/common/xfs b/common/xfs
index 6a48960a7f..65b509691b 100644
--- a/common/xfs
+++ b/common/xfs
@@ -689,12 +689,25 @@ _xfs_metadump() {
 	return $res
 }
 
+# What is the version of this metadump file?
+_xfs_metadumpfile_version() {
+	local file="$1"
+	local magic
+
+	magic="$($XFS_IO_PROG -c 'pread -q -v 0 4' "$file")"
+	case "$magic" in
+	"00000000:  58 4d 44 32  XMD2") echo 2;;
+	"00000000:  58 46 53 4d  XFSM") echo 1;;
+	esac
+}
+
 _xfs_mdrestore() {
 	local metadump="$1"
 	local device="$2"
 	local logdev="$3"
 	shift; shift; shift
 	local options="$@"
+	local dumpfile_ver
 
 	# If we're configured for compressed dumps and there isn't already an
 	# uncompressed dump, see if we can use DUMP_COMPRESSOR to decompress
@@ -705,8 +718,18 @@ _xfs_mdrestore() {
 		done
 	fi
 	test -r "$metadump" || return 1
+	dumpfile_ver="$(_xfs_metadumpfile_version "$metadump")"
 
-	if [ "$logdev" != "none" ]; then
+	if [ "$logdev" != "none" ] && [[ $dumpfile_ver > 1 ]]; then
+		# metadump and mdrestore began capturing and restoring the
+		# contents of external log devices with the addition of the
+		# metadump v2 format.  Hence it only makes sense to specify -l
+		# here if the dump file itself is in v2 format.
+		#
+		# With a v1 metadump, the log device is not changed by the dump
+		# and restore process.  Historically, fstests either didn't
+		# notice or _notrun themselves when external logs were in use.
+		# Don't break that for people testing with xfsprogs < 6.5.
 		options="$options -l $logdev"
 	fi
 

