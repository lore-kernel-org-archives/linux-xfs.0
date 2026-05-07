Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AC03BE16E
	for <linux-xfs@vger.kernel.org>; Thu,  7 May 2026 15:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778166373; cv=none; b=Hf1CITHfSjZCtDN8/RK48I5YlHMC0S1RNRca08+LILCQVccAVZnOa73O190GItY1BL2LeWIv85Rtkz+JDNL1HPcBJbxexJqbmJEq+dempw9bmkecoun3Lp15FiDtt+Gb5Ml8Dh5fdSN64gEQ2HQGvbaRKEMKDOyJsVOxjUpWI+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778166373; c=relaxed/simple;
	bh=DOttKTzPZwe0EWVod0OSGBKJMyefxnaxLbpK10PqnBc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tXWvce+BnF2A6Wh1/PgsrcwZaSnF5Tj/cpUODuF3u4ZZuP/o6/v1e66oMQtycfcqxR+vQlSzALYIPNtKzWMq7LonqoWxpceOjNiq5qX8WW6xE7Xse6kOMWqnFgOiUvFFlKF5+dNjkBWIOgM/5F1AOCF3gToj5NY65RIoMAdbj6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TslwbZW5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TslwbZW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFE9C2BCB2;
	Thu,  7 May 2026 15:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778166372;
	bh=DOttKTzPZwe0EWVod0OSGBKJMyefxnaxLbpK10PqnBc=;
	h=From:To:Cc:Subject:Date:From;
	b=TslwbZW5sZt1eyodkhRqJa0otpLP1LAdDSiQCyQlF7yKtT6r4OlSMuNc+vILK00ri
	 gqeahlFqTgOsCtAQuwfsiag7sPNG/XZHOSBU6BhkvRPROO5BrvUZPGy2/LSHVZDNzf
	 lRxcuVBP1ziCKnAXst4NjkK3UfFO477LAzV1EfWUIuhk8R5NWuMEciN4G6oPWj8cWw
	 CJHCvXTAfQYsJ9M1uMJzv5C6BXJagjhPvbq/Z/AWENfuoH8NK6PMTUnpr+Cn1q57AD
	 QEINGWguGcS1dVI6q01wxJXA1ZJuIFLoGNSUb+9TFJiyqjtYISZ//cRbVhl2BLKKb9
	 EYPgWCAs7Cuow==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH] xfsprogs: update release.sh with fixes from xfsdump
Date: Thu,  7 May 2026 17:06:00 +0200
Message-ID: <20260507150602.1453418-1-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While updating release.sh in xfsdump repository (copy-pasting this
release.sh into xfsdump repo), I added a few minor fixes to the
release.sh. These are those fixes (basically diff -u without
s/xfsprogs/xfsdump).

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 release.sh | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/release.sh b/release.sh
index 32084fb9fd90..c9b3c1b97fac 100755
--- a/release.sh
+++ b/release.sh
@@ -1,13 +1,6 @@
-#!/bin/sh
+#!/usr/bin/env bash
 #
 # Automate generation of a new release
-#
-# Need to first update these files:
-#
-# VERSION (with new version number)
-# docs/CHANGES (with changelog and version/date string)
-# configure.ac (with new version string)
-# debian/changelog (with new release entry, only for release version)
 
 set -e
 
@@ -50,8 +43,10 @@ prepare_mail() {
 	if [ -n "$LAST_HEAD" ]; then
 		if [ $branch == "master" ]; then
 			reason="$(git describe --abbrev=0 $branch) released"
+			for_next_update="\n\nThe for-next branch has also been updated to match the state of master."
 		else
 			reason="for-next updated to $(git log --oneline --format="%h" -1 $branch)"
+			for_next_update=""
 		fi;
 		cat << EOF > $mail_file
 To: linux-xfs@vger.kernel.org
@@ -67,9 +62,7 @@ The xfsprogs $branch branch in repository at:
 has just been updated.
 
 Patches often get missed, so if your outstanding patches are properly reviewed
-on the list and not included in this update, please let me know.
-
-The for-next branch has also been updated to match the state of master.
+on the list and not included in this update, please let me know.$(printf "%b" "$for_next_update")
 
 The new head of the $branch branch is commit:
 
@@ -199,3 +192,8 @@ if [ -n "$LAST_HEAD" ]; then
 	echo "Command to send ANNOUNCE email"
 	printf "\tneomutt -H $mail_file\n"
 fi
+if [ $KUP -ne 1 ]; then
+	echo "Don't forget to upload tarball:"
+	echo -e "\tkup put xfsprogs-${version}.tar.gz" \
+		"xfsprogs-${version}.tar.sign pub/linux/utils/fs/xfs/xfsprogs/"
+fi
-- 
2.51.2

