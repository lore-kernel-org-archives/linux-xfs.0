Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248041422AB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990594; cv=none; b=IVdrcMhuUrh9fjHaNYXaK/WmR/kHeTZiK9+Y4HuKu9xvAuFhkhygxQFgYxWY3VSvyEaUH+IzSGlAS4Ju/uYgwh5QL8Zc6H8XF6zRgt2fkDMOyY135hRsi7sIoWFsjMef7MSVePIzNGwbMau+NqF9P8ZsXw71AnsgA1yPpdJOB1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990594; c=relaxed/simple;
	bh=0EAHsWuDhDfz813bb6+vGEmq/XEbzVBHqo9x2nj7a1k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LOZ6yu+tutI/j4SRxZ7O7xNNjk1y1Ggyu58N6C2se4MjFyu8At3usymhJTIAbl7ZG2BnPVAnjYaNnZqqgly0DOjXLG/FpsogQ+N2ZYWKtM+mt8p7toJ0yVImJmn9ljsfJjnWJMSGHTnT7hsjSaewug8FnUUX3ccGu9uVVuCzRiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mgoqVvy0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mgoqVvy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C3CC4CED3;
	Mon, 23 Dec 2024 21:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990593;
	bh=0EAHsWuDhDfz813bb6+vGEmq/XEbzVBHqo9x2nj7a1k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mgoqVvy0EgWYM0eGOHOhOxeT28IdamVdqXgOpXTNUBYJieAboMg8+eOvPHGtuiNKp
	 egFqyeWVdgq7Pc62Jyh4+9kHSfpw6sk/o/3NF+5S/VDfJ+JBM68e0QlRzYvRLnU3uY
	 mKBG4FygZvDMRfq1/vQIGgBEPiT6PCBWO82jAjqK8gnW0J+rHdV2MALH2U1BpJlU39
	 NbVVbLGsILFoyY3WCLyCF29U41AjnS6EgchWIa35ty3usOdLgGF9OJP2LiIKukxo+F
	 FADu+C5b9RLzukhjkhpELMGuxg/0NKBG2uFm0qX1AQKjF+OZYR9vObAa2P/UDbhFLZ
	 J1Sa5eALrAB4w==
Date: Mon, 23 Dec 2024 13:49:53 -0800
Subject: [PATCH 13/41] xfs_db: show the metadata root directory when dumping
 superblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941167.2294268.16997793666566296649.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Show the metadirino field when appropriate.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/sb.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/db/sb.c b/db/sb.c
index 4f115650e1283f..fa15b429ecbefa 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -50,6 +50,18 @@ sb_init(void)
 	add_command(&version_cmd);
 }
 
+/*
+ * Counts superblock fields that only exist when the metadata directory feature
+ * is enabled.
+ */
+static int
+metadirfld_count(
+	void		*obj,
+	int		startoff)
+{
+	return xfs_has_metadir(mp) ? 1 : 0;
+}
+
 #define	OFF(f)	bitize(offsetof(struct xfs_dsb, sb_ ## f))
 #define	SZC(f)	szcount(struct xfs_dsb, sb_ ## f)
 const field_t	sb_flds[] = {
@@ -113,6 +125,8 @@ const field_t	sb_flds[] = {
 	{ "pquotino", FLDT_INO, OI(OFF(pquotino)), C1, 0, TYP_INODE },
 	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
 	{ "meta_uuid", FLDT_UUID, OI(OFF(meta_uuid)), C1, 0, TYP_NONE },
+	{ "metadirino", FLDT_INO, OI(OFF(metadirino)), metadirfld_count,
+		FLD_COUNT, TYP_INODE },
 	{ NULL }
 };
 

