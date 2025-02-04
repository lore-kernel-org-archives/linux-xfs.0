Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE03D25A62C;
	Tue,  4 Feb 2025 21:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704546; cv=none; b=QOBtT1Yj1eZNeP+J9DZKeyZGdCN4WmrfO5VQj1PxS+qTmbQRv53KKp15Wi6LdZvov3/VEwiELFQBVY/fcfp8KnTK70MaAysepkl+q6IIcPkIIlC44OFtNnMHQ/M3BaZFy5kkgMuBlnDVOqZnbacnyUij7HzBQSIC/0sJ5j6bzYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704546; c=relaxed/simple;
	bh=YPb7IdJ9sJYcrbCDpgURe//04eh3l9CLabN+pbmyaCU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ni3HMjglQ707BWZKelLZPGQjB75wkfPfXn8Z5YTL8py/RegfReAd5916TJ2zc6RuMPVuc0rMu0kto47hyk4MMyXluPUBxic5DTa8awaQCnI7lfCllb9eeXJFoPLvhoNWZHYeRU8vLFPOOd8JU3AZxSHe7GaCpttmjkvQEzQ5n/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bIRdalfH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bIRdalfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25CAC4CEDF;
	Tue,  4 Feb 2025 21:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704545;
	bh=YPb7IdJ9sJYcrbCDpgURe//04eh3l9CLabN+pbmyaCU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bIRdalfHVm7m/gRdKC+HLSrROPACca7BpCk0FBW5sVnAntXfh9QnA+YeTz96jAUXw
	 Nqmklq7ULUcOggjY/cUO1ZRFNkG4tSlog1wWCMsxdcqjbz64oGM16dTw5UzB8rw1BE
	 QOMeoxGVljBJ/GlgbLNeAefdVf0wgpWI0LUdriypxpNMEmnQ0Nt/fB6jc8oKtiF7jn
	 Vb/lrY6AMw8DDHRezi7vOHqQ806peFSAM5qGsNOCPcB8yc8UaA9l7BzuWb5b5sq2vs
	 2Hy2FVHuIbmRZqiHeL36NDEbCKDHYEobXcn8qn2dA1Iy78GBeMYL89GN2iGVh8EAh6
	 aGnjHO78VDm8Q==
Date: Tue, 04 Feb 2025 13:29:05 -0800
Subject: [PATCH 26/34] fuzzy: always stop the scrub fsstress loop on error
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406503.546134.2486707064611332584.stgit@frogsfrogsfrogs>
In-Reply-To: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Always abort the non-remount scrub fsstress loop in
__stress_scrub_fsstress_loop if fsstress returns a nonzero exit code.

Cc: <fstests@vger.kernel.org> # v2023.01.15
Fixes: 20df87599f66d0 ("fuzzy: make scrub stress loop control more robust")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/fuzzy |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/common/fuzzy b/common/fuzzy
index 41547add83121a..8afa4d35759f62 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -1012,6 +1012,7 @@ __stress_scrub_fsstress_loop() {
 	local remount_period="$3"
 	local stress_tgt="$4"
 	local focus=()
+	local res
 
 	case "$stress_tgt" in
 	"parent")
@@ -1143,7 +1144,9 @@ __stress_scrub_fsstress_loop() {
 		# Need to recheck running conditions if we cleared anything
 		__stress_scrub_clean_scratch && continue
 		_run_fsstress $args >> $seqres.full
-		echo "fsstress exits with $? at $(date)" >> $seqres.full
+		res=$?
+		echo "$mode fsstress exits with $res at $(date)" >> $seqres.full
+		[ "$res" -ne 0 ] && break;
 	done
 	rm -f "$runningfile"
 }

