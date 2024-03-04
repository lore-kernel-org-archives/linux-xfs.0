Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFC778B68
	for <linux-xfs@vger.kernel.org>; Mon,  4 Mar 2024 19:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709579538; cv=none; b=VI4FHi+bhqXsIQrvpgJucSG82VHwTu8SOPHOyGSBdQfHCaB+RiiOdgwFOSnDyNnmNfi9h4wCqNlNyYTjm+XZynsA6m8gJPaXxFPyweW0u2Pf11Gml4wpYbZQhkYZ4Tchgn+ewqfjkZy8FXpq+lkYi38mCtFMRo937a6HFKhp76Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709579538; c=relaxed/simple;
	bh=Vy6aKow/W1afzQTgEIlDGAfiO3Pdvi5QJY/f+z2nhzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XMcGACLJzfz/g8qHtTOhyttN+9dXtEWo0Wk4Dh0gHAg3dXsJxZ7Lq5YRSyIBUxHhXnnzkeRQ9qZ+k88TYPeX6Jx9leWvepZ4K3bEjZ68AbQXfIE1t3kEVWVZk8rqafSWXt4MOhb6Wb9cdG2Evri1kdG60/oxn9pxOykwV4QCQs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f91mTuqr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f91mTuqr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709579535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nqqw4mVotq0OBveNn7Z3piHTecgeWnPUkNTctKlIj/8=;
	b=f91mTuqrLsN/4WQe0mHJ7/Yy0K0tOWEZctFBiKMIen0XnmuwFR8Z7RveBf6dLu03awt1up
	4ntTEcHy1xYP4gVZGYHOYj8N1vcZeYqpIAcWyqq0GS8lWWteT/ShB74rT3/b07zd5/rnJ7
	/lDg/6ChkbjS7JKRJris1lUE9Pb4jz8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-118-979I_NyePSKOcRPsX6JIng-1; Mon, 04 Mar 2024 14:12:13 -0500
X-MC-Unique: 979I_NyePSKOcRPsX6JIng-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a44143c8908so453701366b.1
        for <linux-xfs@vger.kernel.org>; Mon, 04 Mar 2024 11:12:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709579533; x=1710184333;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nqqw4mVotq0OBveNn7Z3piHTecgeWnPUkNTctKlIj/8=;
        b=nO+oWWW7OxSaoWkrVl84u882pYvvz8cqevbl+JHxqCrO85I/HiSkmBKqF7iFoGGDPQ
         EOT4M8Cd+/mEYQ6lrqeZz69iFO1iO1wS5ClZY6a93zHgnuy31zhb5xbE33Tn0d5ORkHo
         QmHSHGJl1ipkFmEB5na4aX69kku2hsMG+TnuihG6Ts5CbZWN0ENRcIYlPigrF2Bm649X
         pz6HQVL3lC6ewb2elZgFwDeIkImuXmfoLP4d3ZSvWgNoogDW48M8Wn19AajyZEPVCSCx
         4+hrPFc31V1JZpZ2oRdxlIiNVKItIECzxa/B2GHksJ0Nv9d2mh2TZWh9Q+MIa1mmnjcA
         vZEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMy5yhvJsaZfWKf9Apc/9l36fabh775ykqWnqZeXggxH9g2wEl7AvKTaFwAKqYulN3WVRhHTh3rm4RS310h7FmoKzsfynJpGom
X-Gm-Message-State: AOJu0YyzuARV9Ow7ongUweh5205It2ucLKc5SFDzWXemxx4FfmLi8thn
	Rmswr9kX2bvXtN+fSHdenkiS+uQlRKiRxdgRj36bjNv7ifp5BBgWC0u3VgaKTMDQ1Hwz40B/UXX
	frJ/nU1A2AAR+3ACX0iP6xeCXfXDewXRxMZPls7UcfmjgJqIudf9gRPgP
X-Received: by 2002:a17:906:7208:b0:a44:9483:33c1 with SMTP id m8-20020a170906720800b00a44948333c1mr454992ejk.20.1709579532834;
        Mon, 04 Mar 2024 11:12:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHriVFD5H05LTiKf6J8/M+ZPcD1k3KsigVNhXSp46qw4DNjzzgpyPjO7C93xuGAbGnaCVQYNQ==
X-Received: by 2002:a17:906:7208:b0:a44:9483:33c1 with SMTP id m8-20020a170906720800b00a44948333c1mr454957ejk.20.1709579532348;
        Mon, 04 Mar 2024 11:12:12 -0800 (PST)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a11-20020a1709064a4b00b00a44a04aa3cfsm3783319ejv.225.2024.03.04.11.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 11:12:11 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
	Mark Tinguely <tinguely@sgi.com>,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v5 02/24] xfs: add parent pointer support to attribute code
Date: Mon,  4 Mar 2024 20:10:25 +0100
Message-ID: <20240304191046.157464-4-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240304191046.157464-2-aalbersh@redhat.com>
References: <20240304191046.157464-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Allison Henderson <allison.henderson@oracle.com>

Add the new parent attribute type. XFS_ATTR_PARENT is used only for parent pointer
entries; it uses reserved blocks like XFS_ATTR_ROOT.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       | 3 ++-
 fs/xfs/libxfs/xfs_da_format.h  | 5 ++++-
 fs/xfs/libxfs/xfs_log_format.h | 1 +
 fs/xfs/scrub/attr.c            | 2 +-
 fs/xfs/xfs_trace.h             | 3 ++-
 5 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 673a4b6d2e8d..ff67a684a452 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -925,7 +925,8 @@ xfs_attr_set(
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans_res	tres;
-	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
+	bool			rsvd = (args->attr_filter & (XFS_ATTR_ROOT |
+							     XFS_ATTR_PARENT));
 	int			error, local;
 	int			rmt_blks = 0;
 	unsigned int		total;
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 060e5c96b70f..5434d4d5b551 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -714,12 +714,15 @@ struct xfs_attr3_leafblock {
 #define	XFS_ATTR_LOCAL_BIT	0	/* attr is stored locally */
 #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
 #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure attrs */
+#define	XFS_ATTR_PARENT_BIT	3	/* parent pointer attrs */
 #define	XFS_ATTR_INCOMPLETE_BIT	7	/* attr in middle of create/delete */
 #define XFS_ATTR_LOCAL		(1u << XFS_ATTR_LOCAL_BIT)
 #define XFS_ATTR_ROOT		(1u << XFS_ATTR_ROOT_BIT)
 #define XFS_ATTR_SECURE		(1u << XFS_ATTR_SECURE_BIT)
+#define XFS_ATTR_PARENT		(1u << XFS_ATTR_PARENT_BIT)
 #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
-#define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
+#define XFS_ATTR_NSP_ONDISK_MASK \
+			(XFS_ATTR_ROOT | XFS_ATTR_SECURE | XFS_ATTR_PARENT)
 
 /*
  * Alignment for namelist and valuelist entries (since they are mixed
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 16872972e1e9..9cbcba4bd363 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -974,6 +974,7 @@ struct xfs_icreate_log {
  */
 #define XFS_ATTRI_FILTER_MASK		(XFS_ATTR_ROOT | \
 					 XFS_ATTR_SECURE | \
+					 XFS_ATTR_PARENT | \
 					 XFS_ATTR_INCOMPLETE)
 
 /*
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 83c7feb38714..49f91cc85a65 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -494,7 +494,7 @@ xchk_xattr_rec(
 	/* Retrieve the entry and check it. */
 	hash = be32_to_cpu(ent->hashval);
 	badflags = ~(XFS_ATTR_LOCAL | XFS_ATTR_ROOT | XFS_ATTR_SECURE |
-			XFS_ATTR_INCOMPLETE);
+			XFS_ATTR_INCOMPLETE | XFS_ATTR_PARENT);
 	if ((ent->flags & badflags) != 0)
 		xchk_da_set_corrupt(ds, level);
 	if (ent->flags & XFS_ATTR_LOCAL) {
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 56b07d8ed431..d4f1b2da21e7 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -86,7 +86,8 @@ struct xfs_bmap_intent;
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
 	{ XFS_ATTR_SECURE,	"SECURE" }, \
-	{ XFS_ATTR_INCOMPLETE,	"INCOMPLETE" }
+	{ XFS_ATTR_INCOMPLETE,	"INCOMPLETE" }, \
+	{ XFS_ATTR_PARENT,	"PARENT" }
 
 DECLARE_EVENT_CLASS(xfs_attr_list_class,
 	TP_PROTO(struct xfs_attr_list_context *ctx),
-- 
2.42.0

