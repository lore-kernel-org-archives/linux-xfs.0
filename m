Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5353D79E1
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302770; cv=none; b=GuZR4mRXQAjYIQJ/5SGKLonean8kRElPEaIBxbW+rMRH0yHTHQCqb6Mf9HcrlORUEWVfxENzkIysuZfpwKJhLnvY6FWFSgX+r64cMSGaZ0HFkd4HFco54z37bh11Fz4GAWyGqpqNnIA2DLCfEtyyxle+wUSkJuJt3ea8ueO0XdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302770; c=relaxed/simple;
	bh=Ubvl4vhVTdBbVONyxhpSPe1x77zhfZznbF9Jx1uusxE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s3Mj2YvVSUv5mZX4QAs9kYQoDxcX9yd0oxFV0VgpwAURPloUxg3y+yi7lolMHuxTE+HA3VzakfmC8/okro/aepmkRglV2UFsTN+bjmfCZ7voHrVCD3iO1iSQgfgQo9caZ0rFXHHeN1IdCKJwZYj4SFoL6xJLAuytui3hVZnxa9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g0AQg/3F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g0AQg/3F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC3EC4AF07;
	Tue, 30 Jul 2024 01:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302769;
	bh=Ubvl4vhVTdBbVONyxhpSPe1x77zhfZznbF9Jx1uusxE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g0AQg/3F5BgzaY/E3XPnRV58mxZefvYsBEo/9sikHt9ldEtcDc9oBV40VHOzHQF79
	 lCI/yyFS8ovNvEw3QC8LkW6CH62wCIMDqjc4Ci8CuY1r3pIVo/9TeLEo5dHBHeR5Yp
	 B398Nq4OcIDOi8r7vZRRQQmZfYo0xLwiGNE3zinei7vrmiCC4a3Fk7bXbKkUettH/f
	 CibbykCfZMavKGsFJDfKJOEEg7iL0q8Nj3PYQbYi/R/B8CtZvsXf+93Dy428lbtC3V
	 ck9sKljQYmldhgQzKDLIhBgTNf8MGe8Ft34P509DaJjH7yKL3zTIYaPf09sVS1yDaC
	 PEco6cLzSLtfw==
Date: Mon, 29 Jul 2024 18:26:09 -0700
Subject: [PATCH 02/12] xfs_db: actually report errors from libxfs_attr_set
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229851515.1352527.17325767071539808212.stgit@frogsfrogsfrogs>
In-Reply-To: <172229851481.1352527.11812121319440135994.stgit@frogsfrogsfrogs>
References: <172229851481.1352527.11812121319440135994.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/attrset.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)


diff --git a/db/attrset.c b/db/attrset.c
index 008662571..81d530055 100644
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
 

