Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA0D7EE;
	Mon,  1 Jan 2024 00:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="byPyrmVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1CFC433C7;
	Mon,  1 Jan 2024 00:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070445;
	bh=Co72ca/D7/pGEgAz19GcoPUNJACYs+E3KwqttNTgUmk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=byPyrmVUpujO/uPxyyxCeLKYxDs1rtSdEVpvc8iGrWrPbKmNVN2LpQOQfOKJvTC1U
	 Gr/Z/DXznEBdasAYp4Tn1ujxpjNhqiGvV4d53fhuf0cvqabSL2TTkqk8Hkp8kJNw5s
	 TE3Z4jZeRcg2SXldXJ1WpGtr4s8+r8KDpJ0TVs/tUrA9+BywgCyoGR4nX9IrbEiQrc
	 NKgrq5pIF4R1J02dNnVHE8bhNFbd7uQEDpD3CPSwrIThR1OLLRZpfTMB/5sOS5RbLy
	 HDDLbXC/Nh8dlw92BXFR6BQCX1aTDfT0AMpH4DirGD54TPj1d3pPdkvxa3P/dKobAx
	 EqTtZZvpaqu8Q==
Date: Sun, 31 Dec 2023 16:54:04 +9900
Subject: [PATCH 05/17] common/xfs: capture external logs during
 metadump/mdrestore
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405030403.1826350.4983042278295283651.stgit@frogsfrogsfrogs>
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

If xfs_mdrestore supports the -l switch and there's an external scratch
log, pass the option so that we can restore log contents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs |   40 +++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)


diff --git a/common/xfs b/common/xfs
index 4e8630b3ab..175de69c63 100644
--- a/common/xfs
+++ b/common/xfs
@@ -668,6 +668,7 @@ _xfs_metadump() {
 	shift; shift; shift; shift
 	local options="$@"
 	test -z "$options" && options="-a -o"
+	local metadump_has_dash_x
 
 	# Use metadump v2 format unless the user gave us a specific version
 	$XFS_METADUMP_PROG --help 2>&1 | grep -q -- '-v version' && \
@@ -694,6 +695,12 @@ _xfs_mdrestore() {
 	local logdev="$3"
 	shift; shift; shift
 	local options="$@"
+	local need_repair
+	local mdrestore_has_dash_l
+
+	# Does mdrestore support restoring to external devices?
+	$XFS_MDRESTORE_PROG --help 2>&1 | grep -q -- '-l logdev' &&
+			mdrestore_has_dash_l=1
 
 	# If we're configured for compressed dumps and there isn't already an
 	# uncompressed dump, see if we can use DUMP_COMPRESSOR to decompress
@@ -705,19 +712,38 @@ _xfs_mdrestore() {
 	fi
 	test -r "$metadump" || return 1
 
+	if [ "$logdev" != "none" ]; then
+		# We have an external log device.  If mdrestore supports
+		# restoring to it, configure ourselves to do that.
+		if [ -n "$mdrestore_has_dash_l" ]; then
+			options="$options -l $logdev"
+		fi
+
+		# Wipe the log device.  If mdrestore doesn't support restoring
+		# to external log devices or the metadump file doesn't capture
+		# the log contents, this is our only chance to signal that the
+		# log header needs to be rewritten.
+		$XFS_IO_PROG -d -c 'pwrite -S 0 -q 0 1m' "$logdev"
+	fi
+
 	$XFS_MDRESTORE_PROG $options "${metadump}" "${device}"
 	res=$?
 	test $res -ne 0 && return $res
 
-	# mdrestore does not know how to restore an external log.  If there is
-	# one, we need to erase the log header and run xfs_repair to format a
-	# new log header onto the log device.
+	# If there's an external log, check to see if the restore rewrote the
+	# log header.  If not, we need to run xfs_repair to format a new log
+	# header onto the log device.
 	if [ "$logdev" != "none" ]; then
-		$XFS_IO_PROG -d -c 'pwrite -S 0 -q 0 1m' "$logdev"
-		_scratch_xfs_repair >> $seqres.full 2>&1
-		res=$?
+		magic="$($XFS_IO_PROG -c 'pread -q -v 0 4' "$logdev")"
+		if [ "$magic" = "00000000:  00 00 00 00  ...." ]; then
+			need_repair=1
+		fi
 	fi
-	return $res
+
+	test -z "$need_repair" && return 0
+
+	echo "repairing fs to fix uncaptured parts of fs." >> $seqres.full
+	_scratch_xfs_repair >> $seqres.full 2>&1
 }
 
 # Snapshot the metadata on the scratch device

