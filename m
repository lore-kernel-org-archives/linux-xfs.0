Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6DB374A1E
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 01:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788485481; cv=none; b=YruwUW7Xjm5klelm3x+m43N+ScShKgnbF8aAYPxPR+p0SMYa6qlBrdE+vEP754ALu9D+SivDIvTpJ16AuyiHOcfE9lK8rvXOLEte7cMnU8WBwf3PekwZHFO0pp9zOBh4liGUmcyZwyx7/P8n8UhIhQ4ss9amwUyTsJUwAC7/qN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788485481; c=relaxed/simple;
	bh=zR0IaOl0aJAjEtBk7QTvduZm3mtkJbRxCmvyO02lMHk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=juwwc38HSyzPreHrO0ldvi4UIFZipZA05Dz/4o58T26/8GUlmShMvmS2hi+HAUYWZ1r8fb3HL5vZTifMk2/vBmPSOalWC4qST9mtgfuCLL3KLWvP/Yx0w3nrivQ1mNyhatw4LGoQkqJHjGCXkjwOhusiOHKKzX9NWiRgkXv2g7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bWrKFbZU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bWrKFbZU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 09EFE1F000E9;
	Fri,  4 Sep 2026 01:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788485480;
	bh=Dwp+xSWrfF9ru9xy/oueG4X2mWUHZOGEDpIfnNBocho=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=bWrKFbZU2Wg/kQFCy3tHjNWuSmoxnnRSAjLKehK8P3RZOPB0c2cJ2YWBa0IQ5XHwV
	 Y54qK4/RdHFYlXZnuioNQD9hoctVagE7t8ZifC2DdiD05SgmP+YQdWtSmSkpLV1GVa
	 MS2LUYUei8ryqYaLwEsylFyd+9haT1PvN3gkoyeyszUPvgtvp9PhJmCn9EOCt9RAFF
	 QAQ38dbhXKGNbUmfQMUr127d/lsRpQ2msorQhI+YXAOXM83fyWHwT2h14pU3BdlkQt
	 WA5soeUNBauR1pI1oEjW2FssiGbUlfi4D9avQtjxLnJh7ws0swSin26RAUIVKpoDP6
	 J2pe9aH8llI4g==
Date: Thu, 03 Sep 2026 18:31:19 -0700
Subject: [PATCH 6/8] makecfg: handle old V4 options that are almost always on
 by default
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178848534968.1052910.10475992759746401803.stgit@frogsfrogsfrogs>
In-Reply-To: <178848534822.1052910.754281019922260552.stgit@frogsfrogsfrogs>
References: <178848534822.1052910.754281019922260552.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The same alternate LOLLM also observed that there are a couple of V4
options that are always enabled on a V5 filesystem.  Since we support V4
for another 4 years, add these two options but only for the weird case
where someone wants to turn them off.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libfrog/fsgeom.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)


diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index f1ca7e73df638a..24effad2678765 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -284,6 +284,7 @@ enum {
 	I_SPINODES = 0,
 	I_NREXT64,
 	I_EXCHANGE,
+	I_PROJID32BIT,
 	I_MAX_OPTS,
 };
 
@@ -299,6 +300,11 @@ enum {
 	R_MAX_OPTS,
 };
 
+enum {
+	L_LAZYSBCNTR,
+	L_MAX_OPTS,
+};
+
 struct mkfs_config_opt;
 
 struct mkfs_config_data {
@@ -342,6 +348,24 @@ print_fsgeom(
 	return 0;
 }
 
+static int
+print_fsgeom_only_if_missing(
+	const struct mkfs_config_opt	*opt,
+	const struct mkfs_config_data	*data,
+	FILE				*fp)
+{
+	const struct xfs_fsop_geom	*fsgeo = data->fsgeo;
+	int				ret;
+
+	if (fsgeo->flags & opt->fsgeom_flag)
+		return 0;
+
+	ret = fprintf(fp, "%s=0\n", opt->name);
+	if (ret <= 0)
+		return ret;
+	return 0;
+}
+
 static int
 print_xflag(
 	const struct mkfs_config_opt	*opt,
@@ -606,9 +630,24 @@ static const struct mkfs_config_section config_sections[] = {
 				.name		= "exchange",
 				.fsgeom_flag	= XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE,
 			},
+			[I_PROJID32BIT] = {
+				.name		= "projid32bit",
+				.fsgeom_flag	= XFS_FSOP_GEOM_FLAGS_PROJID32,
+				.print_fn	= print_fsgeom_only_if_missing,
+			},
 			[I_MAX_OPTS] = { },
 		},
 	},
+	{
+		.ini_section = "log",
+		.subopts = {
+			[L_LAZYSBCNTR] = {
+				.name		= "lazy-count",
+				.fsgeom_flag	= XFS_FSOP_GEOM_FLAGS_LAZYSB,
+				.print_fn	= print_fsgeom_only_if_missing,
+			},
+		},
+	},
 	{
 		.ini_section = "naming",
 		.subopts = {

