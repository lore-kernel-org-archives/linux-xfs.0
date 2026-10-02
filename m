Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEAF4483AB
	for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2026 21:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790975448; cv=none; b=CsRDt4YutvDRcYNTntZqrpGTIiFHR5wHThbRE1t3b1PfqkbzgYtgrBrMW9k1AtjUDiBMFf1X56+XFuKK90Phi/ONEma5JqO0XagPTjgQWIR3MEZRC7nhITp8gzvcV4dsKwscsgnJ1Y6Sqj2+3Nvu2yV8KEdCW2+M/bNeHsrYNzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790975448; c=relaxed/simple;
	bh=xOdpx1E5jtkNCPM9/i4qCsmDEzM8JTm82v/iy6z+7K8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=euLVi8+d8LMli0UAUiwDERsfKyHdhAKSgN2T+OlUDA9mSrkP9tAfrGBdggkFswTcjFpPzA4CFfxnOxBN0FgvLoIVmaCZ+GY81knMf79TTeLLxeW3izRmMBw0rTMknDyGXXpUMV00rEFsY8Qz01elaL9iJ0ylj1V4Vt7IuI0j05w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dK6awXiJ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=f64q+rTI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dK6awXiJ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="f64q+rTI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790975445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4idDmWGjnDCuJsI5TOnx4mcoXHIsLdLzABRVXO/wIOs=;
	b=dK6awXiJC8+V9Mok4L29IxpD6PAQw/fhqLsD81jii72KoQm989MWOqiK9sThoivyTbSvr4
	tfjdtiio0aTpv7EDHZRrNSnVMY+KyktqL8cqZgO4dt9KWjqrQO7Ef+FEKPtpv3hXi0/2Bk
	iCWwULjcgEScfWkrpNSzDMXgQ0hpJbY=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-BiNMPCVON82jfNwh56r0Xg-1; Fri, 02 Oct 2026 17:10:43 -0400
X-MC-Unique: BiNMPCVON82jfNwh56r0Xg-1
X-Mimecast-MFC-AGG-ID: BiNMPCVON82jfNwh56r0Xg_1790975443
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-81dc8e2a180so646897a34.3
        for <linux-xfs@vger.kernel.org>; Fri, 02 Oct 2026 14:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790975443; x=1791580243; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4idDmWGjnDCuJsI5TOnx4mcoXHIsLdLzABRVXO/wIOs=;
        b=f64q+rTIje3c/BED834sxIi3SpvhulxXw4EifWb75yjj0RmrQiRbN85dB0e6SGMdgf
         YgPMZJPbRJO4excvr2DfzYJ/xwrm+GcgNGrPoha/LByrZ2JA6zR2HxbKOlw+hoMMuOaF
         j+9Xa1FNTheeokbWQw7NLm6XRJy5hGPde2h4QBbbTeKl5L4PDNyE+FHB+bs/TYFlkjVL
         5WfpWxwzvYMrnTlNu5r1TFEapTuM23FObI0qwXDRj6t0ZiwDvd/liLRyQoKiQumIHDWo
         Xoum7t2RgLjI5tJECRI2B6KT12+1EzakzRD9yxZRkhQa5aS+g2d+3D7uhqdeL505XWPL
         gHjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790975443; x=1791580243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4idDmWGjnDCuJsI5TOnx4mcoXHIsLdLzABRVXO/wIOs=;
        b=O6yzVrss6l6mxNuCLVROujbYagp4thYFlyDW7xixBWOGXakWM3mOq1kZobY7O9SYy+
         4MIUzDkKi//D+dHi3srQyR7GYXACE6f5J+s3ENYKtOCPLjLMU1OUmQYlrwi2e9grj3Aq
         zemoU/rCW7Y0HhzST6rNZWvTJXy4RH5Qt7M/7V7Ugvz7iU82ABcaAbPj8jWEgSxYIbGa
         TjywUn8Fr+57y1Ayaf16CEkIBdoLX3FCY9RszLbEkmdjasywRyhvPoK8TIfDicJxRS57
         cn676HAUurtVL/C1SJ9vApf1FHjfBMp0za1lHyNi99Mvwz71xBsnWb+apIk0ZHAk5r6d
         s8Wg==
X-Gm-Message-State: AFuF++nDywPbbIqL6BbHK4puRy5SjVr5LlAW6TuITS0eyX3gZY6hNdg4
	J5whdM7W17pTJK9a8ffnmsli+M2N3tERieLrcUE0qLOcfQ/jQDQfKpRybGiZZ3vl1x0oBIMCLnb
	Gta/ZkMmYs86Kv9oAOXPBXLSzIT+XzIIbRW6u0xrYpC5+wKkl2eiw5LoMZJrz5dEeXRkUURpjsX
	PECHfbt7cpmhlhjA2Bs0IguGvKY8Zopg1DWa/5fTkWJuVg/oY=
X-Gm-Gg: AYBFou0D1sJfteuufARf7RkWKue4YRN9OmjdoPALlhkDfHpru3sCPL/4ZsOo2ROVBzj
	TqG6e7GniDBRwEJzwhlVEJehRaXw/16al8sjuqY7mvZ3/omPERDVZ+ti8mvvOfjx2oBcFtkMnNg
	8CRzQISZUrgXJFhZcYRar3arj2vM9Iww1Iu5Zb6dzUSHK/ThjY241l42sjHedcNsaxWvyQGFXIg
	MApgzoluE8Wr8EB/NdvFCkpW0Jn7Ip4IMJ8o6dqjWyxXgRRR96FwJExDRaTra9+vbyQvlXjyHcP
	YykWRnFgevmNX0wHG1eurhKQiNIwtaXiccoFU8w/NE2/Uww8Xn+P5bekkhTfNepqxgueZx45ycF
	/WuIWxigikwxe1OJzwNimzPQYx14bwddAykxQaQ==
X-Received: by 2002:a05:6830:6f83:b0:805:9b38:6f7c with SMTP id 46e09a7af769-823fe015c19mr687614a34.29.1790975442757;
        Fri, 02 Oct 2026 14:10:42 -0700 (PDT)
X-Received: by 2002:a05:6830:6f83:b0:805:9b38:6f7c with SMTP id 46e09a7af769-823fe015c19mr687563a34.29.1790975442122;
        Fri, 02 Oct 2026 14:10:42 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-8227aa72075sm4456044a34.27.2026.10.02.14.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 14:10:41 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/3] xfs: factor out xfs_dir2_sf_copy_entries helper
Date: Fri,  2 Oct 2026 16:08:09 -0500
Message-ID: <20261002211038.2139655-2-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261002211038.2139655-1-sandeen@redhat.com>
References: <20261002211038.2139655-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_dir2_sf_toino8 and xfs_dir2_sf_toino64 share a dozen or so lines
of copied code used to move short form directory entries; factor that
out to eliminate cut and paste.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_dir2_sf.c | 68 ++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 0567cf8b9c1b..a8675a0d574e 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -1124,6 +1124,34 @@ xfs_dir2_sf_replace(
 	return 0;
 }
 
+static inline void
+xfs_dir2_sf_copy_entries(
+	struct xfs_mount	*mp,
+	struct xfs_dir2_sf_hdr	*sfp,
+	struct xfs_dir2_sf_hdr	*oldsfp)
+{
+	int			i;
+	struct xfs_dir2_sf_entry *sfep;		/* new sf entry */
+	struct xfs_dir2_sf_entry *oldsfep;	/* old sf entry */
+
+	/*
+	 * Copy the entries field by field.
+	 */
+	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp),
+		    oldsfep = xfs_dir2_sf_firstentry(oldsfp);
+	     i < sfp->count;
+	     i++, sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep),
+		  oldsfep = xfs_dir2_sf_nextentry(mp, oldsfp, oldsfep)) {
+		sfep->namelen = oldsfep->namelen;
+		memcpy(sfep->offset, oldsfep->offset, sizeof(sfep->offset));
+		memcpy(sfep->name, oldsfep->name, sfep->namelen);
+		xfs_dir2_sf_put_ino(mp, sfp, sfep,
+				xfs_dir2_sf_get_ino(mp, oldsfp, oldsfep));
+		xfs_dir2_sf_put_ftype(mp, sfep,
+				xfs_dir2_sf_get_ftype(mp, oldsfep));
+	}
+}
+
 /*
  * Convert from 8-byte inode numbers to 4-byte inode numbers.
  * The last 8-byte inode number is gone, but the count is still 1.
@@ -1136,11 +1164,8 @@ xfs_dir2_sf_toino4(
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_dir2_sf_hdr	*oldsfp = dp->i_df.if_data;
 	char			*buf;		/* old dir's buffer */
-	int			i;		/* entry index */
 	int			newsize;	/* new inode size */
-	xfs_dir2_sf_entry_t	*oldsfep;	/* old sf entry */
 	int			oldsize;	/* old inode size */
-	xfs_dir2_sf_entry_t	*sfep;		/* new sf entry */
 	xfs_dir2_sf_hdr_t	*sfp;		/* new sf directory */
 
 	trace_xfs_dir2_sf_toino4(args);
@@ -1171,22 +1196,7 @@ xfs_dir2_sf_toino4(
 	sfp->count = oldsfp->count;
 	sfp->i8count = 0;
 	xfs_dir2_sf_put_parent_ino(sfp, xfs_dir2_sf_get_parent_ino(oldsfp));
-	/*
-	 * Copy the entries field by field.
-	 */
-	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp),
-		    oldsfep = xfs_dir2_sf_firstentry(oldsfp);
-	     i < sfp->count;
-	     i++, sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep),
-		  oldsfep = xfs_dir2_sf_nextentry(mp, oldsfp, oldsfep)) {
-		sfep->namelen = oldsfep->namelen;
-		memcpy(sfep->offset, oldsfep->offset, sizeof(sfep->offset));
-		memcpy(sfep->name, oldsfep->name, sfep->namelen);
-		xfs_dir2_sf_put_ino(mp, sfp, sfep,
-				xfs_dir2_sf_get_ino(mp, oldsfp, oldsfep));
-		xfs_dir2_sf_put_ftype(mp, sfep,
-				xfs_dir2_sf_get_ftype(mp, oldsfep));
-	}
+	xfs_dir2_sf_copy_entries(mp, sfp, oldsfp);
 	/*
 	 * Clean up the inode.
 	 */
@@ -1208,11 +1218,8 @@ xfs_dir2_sf_toino8(
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_dir2_sf_hdr	*oldsfp = dp->i_df.if_data;
 	char			*buf;		/* old dir's buffer */
-	int			i;		/* entry index */
 	int			newsize;	/* new inode size */
-	xfs_dir2_sf_entry_t	*oldsfep;	/* old sf entry */
 	int			oldsize;	/* old inode size */
-	xfs_dir2_sf_entry_t	*sfep;		/* new sf entry */
 	xfs_dir2_sf_hdr_t	*sfp;		/* new sf directory */
 
 	trace_xfs_dir2_sf_toino8(args);
@@ -1243,22 +1250,7 @@ xfs_dir2_sf_toino8(
 	sfp->count = oldsfp->count;
 	sfp->i8count = 1;
 	xfs_dir2_sf_put_parent_ino(sfp, xfs_dir2_sf_get_parent_ino(oldsfp));
-	/*
-	 * Copy the entries field by field.
-	 */
-	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp),
-		    oldsfep = xfs_dir2_sf_firstentry(oldsfp);
-	     i < sfp->count;
-	     i++, sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep),
-		  oldsfep = xfs_dir2_sf_nextentry(mp, oldsfp, oldsfep)) {
-		sfep->namelen = oldsfep->namelen;
-		memcpy(sfep->offset, oldsfep->offset, sizeof(sfep->offset));
-		memcpy(sfep->name, oldsfep->name, sfep->namelen);
-		xfs_dir2_sf_put_ino(mp, sfp, sfep,
-				xfs_dir2_sf_get_ino(mp, oldsfp, oldsfep));
-		xfs_dir2_sf_put_ftype(mp, sfep,
-				xfs_dir2_sf_get_ftype(mp, oldsfep));
-	}
+	xfs_dir2_sf_copy_entries(mp, sfp, oldsfp);
 	/*
 	 * Clean up the inode.
 	 */
-- 
2.55.0

