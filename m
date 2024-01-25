Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806E76A005;
	Thu, 25 Jan 2024 19:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706209580; cv=none; b=jVygJ1GqYDbRSmViL0gvdPWhdwanVlb/M+3p6PYnMWuwdaQ5QHUn1l6pCZCKfTKFKfaAe5HF+S0HlsHbpDLfeKJXsm4haESw64lSYuc3emwXDuE62KTFMb9A2jMHt6cXHX+fwtTiWPOUcXnub9YEUS6fmV589I++AuHAHM4/NOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706209580; c=relaxed/simple;
	bh=lujOX5jDxrf+xAdwjPmZfVAFc2qNESt/SPyuOqHDCI0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TBkvoIDl9CryclD5LxvDihmSKuf6JqWgtX/3D+32gByN0LfXM2bYxKeeIya817L5Xq+32C79LoEFWbg1UP4q6wTn8wxX+2RSsKPrNR9r1aIIvWLYA0UhJTqPcIji6csvNEdQpqk/iKT1nvyMkucfXWYQyANFmDkQENkdY9Joycg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d8gL+SvJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d8gL+SvJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D42C433F1;
	Thu, 25 Jan 2024 19:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706209580;
	bh=lujOX5jDxrf+xAdwjPmZfVAFc2qNESt/SPyuOqHDCI0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=d8gL+SvJUU+dLSlL8n8mX7X4vQisI5o9F34qkugVBU5STM+F39/9pRbQXM/rw8w7N
	 aTdRTEgLsM8JvlkgeSjMN/0HQ7ZiFhztLoCeopskvrVad3uuSoKvcK2ZHXumIYeRJx
	 uUHKUwGdtJarDbpwQq+1S8asPWOyMMUulzz9n4PdqrcpzVdjGGj5g1BB9CnDpnHmx2
	 Dc1GxS2wP/STxJwijBWosS7O7Ml0EfZ+G4xmzmvJIGwZ7awfwZWrk8hof+eKTDKRIH
	 u0CcJp8k3k14AemaZ6Enb2tXdiBDApWORVHaFjjPA90RhQ+JnqDHf44CUm8R6uJfSb
	 af8+oIWv72Njg==
Date: Thu, 25 Jan 2024 11:06:19 -0800
Subject: [PATCH 09/10] common/xfs: only pass -l in _xfs_mdrestore for v2
 metadumps
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170620924493.3283496.11650772421388432291.stgit@frogsfrogsfrogs>
In-Reply-To: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
References: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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
 

