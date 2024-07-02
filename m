Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315189441
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719883080; cv=none; b=UawTA/WboS2QuibLkYFgjKah+vxXD8fAsRNV0gIhYnA5XR7ieq8r73dLcz72bK34RVkpvUi9Ol9WnqKT/hkVGRNuHaC5AoD2Yruamz/FDHavEmyoPF7oIaSDlinnPSRne7KFjjkYWum1IP/Ec1AY6OCPAkE7IuGgYcea2R8n7Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719883080; c=relaxed/simple;
	bh=ev+lTVOZMqEJ2xN8sWE5NkTqrqiD+SeFS1bgl8g6TGY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=euJocdsKZoowLX/psSMqAMR6j0FPbYQBcHMB/B15qphcFxrzirZgT9Wt98RdIo7Ajp+m8vC/2xjIu+5OoWgLz6zdCzyN4ZsSyDfEMb43mQQFuSo7eol5qCLTDlWdbryN+kBWGgr1M5WgqoHOZMKtg2D9eFaola+b357NxsgAeCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lF+miUSJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lF+miUSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09486C116B1;
	Tue,  2 Jul 2024 01:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719883080;
	bh=ev+lTVOZMqEJ2xN8sWE5NkTqrqiD+SeFS1bgl8g6TGY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lF+miUSJk7MF/1uU7qluczb6TOeFtD0qfynHU0e1U+lKXQY1jJjXkbdAF0hlPbt7G
	 /T/V8v5N2Zz8IUx2qyyvz2Z+3xHzut3Tzz5Cz4ws3hokuWyv43tvOL/pnkJkXcr77t
	 dB6dltReatzpjCV1hujKH+YKMFlqCNk+RLtFrFahlOk4ouh0PRSzEI6qa+G9WqYcm7
	 s2d7dgEv3evjQhTZZMB3Jfyb0X4llyZh5wObO8G2UeydYCYBlsHMp0xx0Cf9r9J4es
	 IodZpc08Hs4zYIeloH4rIPq/JSw4ahmV0wJyefEX51cmxnXK3bYhchxdH8TDCh5juJ
	 La2HQoOpMtwJA==
Date: Mon, 01 Jul 2024 18:17:59 -0700
Subject: [PATCH 02/12] xfs_db: actually report errors from libxfs_attr_set
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988122196.2010218.8191843801782872283.stgit@frogsfrogsfrogs>
In-Reply-To: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs>
References: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs>
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

Actually tell the user what went wrong when setting or removing xattrs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/attrset.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)


diff --git a/db/attrset.c b/db/attrset.c
index 008662571323..81d530055193 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -121,6 +121,7 @@ attr_set_f(
 	char			*value_from_file = NULL;
 	enum xfs_attr_update	op = XFS_ATTRUPDATE_UPSERT;
 	int			c;
+	int			error;
 
 	if (cur_typ == NULL) {
 		dbprintf(_("no current type\n"));
@@ -260,9 +261,11 @@ attr_set_f(
 	args.owner = iocur_top->ino;
 	libxfs_attr_sethash(&args);
 
-	if (libxfs_attr_set(&args, op, false)) {
-		dbprintf(_("failed to set attr %s on inode %llu\n"),
-			args.name, (unsigned long long)iocur_top->ino);
+	error = -libxfs_attr_set(&args, op, false);
+	if (error) {
+		dbprintf(_("failed to set attr %s on inode %llu: %s\n"),
+			args.name, (unsigned long long)iocur_top->ino,
+			strerror(error));
 		goto out;
 	}
 
@@ -291,6 +294,7 @@ attr_remove_f(
 	};
 	char			*name_from_file = NULL;
 	int			c;
+	int			error;
 
 	if (cur_typ == NULL) {
 		dbprintf(_("no current type\n"));
@@ -379,10 +383,12 @@ attr_remove_f(
 	args.owner = iocur_top->ino;
 	libxfs_attr_sethash(&args);
 
-	if (libxfs_attr_set(&args, XFS_ATTRUPDATE_REMOVE, false)) {
-		dbprintf(_("failed to remove attr %s from inode %llu\n"),
+	error = -libxfs_attr_set(&args, XFS_ATTRUPDATE_REMOVE, false);
+	if (error) {
+		dbprintf(_("failed to remove attr %s from inode %llu: %s\n"),
 			(unsigned char *)args.name,
-			(unsigned long long)iocur_top->ino);
+			(unsigned long long)iocur_top->ino,
+			strerror(error));
 		goto out;
 	}
 

