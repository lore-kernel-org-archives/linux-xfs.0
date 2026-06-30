Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871E486334
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 01:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782781485; cv=none; b=qGppcvOprdWI4HRjmqPzSZfA5PoJhX1TaQrSuTjPGbZ5p7nYlH0SncT8PE9xQI2jiZHH7EZshobDdLNNxb89DlmK4v/0G+mvFCQ3zlgq9NZarlpn/nWEwNlFQrPkGJ30MiBqQGO5YwFzHyZwSC24tSkznFc/UH4oIz/DWQ/UWzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782781485; c=relaxed/simple;
	bh=mty4ZwNKP65DOkfS6FpdiPl+I3SlYRympGMlE1OU0yM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rS6R8YJD3LPWPQnFy2pYthfLvhl0D/T/1BX/BRmnybZ3u0Bvk+LKF7qMXx7CiGfyReGaZZW8tq0czle0+79OJH1Hunrw4HL9EOzthIGRi0LQKgfHS00qEaC5hBQIlZWov8EtElBIj/HWrSlRT6AJm9zoWDIyJAg5HDmFvkMXx7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UK8feoBP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UK8feoBP"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5FD0E1F000E9;
	Tue, 30 Jun 2026 01:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782781484;
	bh=2Ug5bVLaL6C7JyCputJjsRLQlD6M/3ofefnmETS/An0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=UK8feoBPK/D9D2J9jh5a4N4HGvKafLlAnF3+qWgxtVOt+bEupc3gC6Cm8PFa+cNTk
	 eskFmGyahifEvZnAELnhMXw6iWDIW6+ewUb7FC9f2huShmLCqhlshoAPRaMeoqRx/W
	 dRXxIhqayIEMSKbCLg4e+5XfO4B+4b5hz35I+IiQg/JY57UuDfURXmhZoFNHBxaO8w
	 fXVFtnd8cihmD/TbSDhTh+jlM3cvvMmrbcpcW3C9Zo+akqSgIGV4Hcw8gtEzAM67Uo
	 qt6nvUDfErQGfOAkyGesT2mMfdmtW7qH+EAIuld7DoKJjXjSav5Wg/wdeXydMvFsFC
	 WLSnByntb+Wsw==
Date: Mon, 29 Jun 2026 18:04:44 -0700
Subject: [PATCH 2/2] xfs_db: dump zoned filesystem superblock fields
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178278130156.858605.18364793006080520519.stgit@frogsfrogsfrogs>
In-Reply-To: <178278130113.858605.5206441223016436305.stgit@frogsfrogsfrogs>
References: <178278130113.858605.5206441223016436305.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Display the rtstart and rtreserved superblock fields if the filesystem
has zoned storage support.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/sb.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/db/sb.c b/db/sb.c
index 52ac48d45d5ae6..666207145a86cb 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -63,6 +63,14 @@ metadirfld_count(
 	return xfs_has_metadir(mp) ? 1 : 0;
 }
 
+static int
+zonedfld_count(
+	void		*obj,
+	int		startoff)
+{
+	return xfs_has_zoned(mp) ? 1 : 0;
+}
+
 #define	OFF(f)	bitize(offsetof(struct xfs_dsb, sb_ ## f))
 #define	SZC(f)	szcount(struct xfs_dsb, sb_ ## f)
 const field_t	sb_flds[] = {
@@ -136,6 +144,8 @@ const field_t	sb_flds[] = {
 		FLD_COUNT, TYP_NONE },
 	{ "pad", FLDT_UINT8X, OI(OFF(pad)), metadirfld_count,
 		FLD_COUNT, TYP_NONE },
+	{ "rtstart", FLDT_DRFSBNO, OI(OFF(rtstart)), zonedfld_count, FLD_COUNT, TYP_NONE },
+	{ "rtreserved", FLDT_UINT64D, OI(OFF(rtreserved)), zonedfld_count, FLD_COUNT, TYP_NONE },
 	{ NULL }
 };
 

