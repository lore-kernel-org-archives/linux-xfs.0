Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2AC23BD03
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 20:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789419149; cv=none; b=gvIFMcVScqOR38eDlyju/7UWSl/sboJsT1r+41y1UfzqoEUODCVY0U+GGJ8LkQL8ij5XBwM1YtxFLHk/BTqU9euZcExbgEV3IZQFziEC4aKrB765BAyxXy9CAfWjnL+9Cl1tO8tNrjXY51JHVeUxhWGgqbj3r66ONkP4BCIvxN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789419149; c=relaxed/simple;
	bh=siIDiLtehUViXnj0y1OdjIDPToMf//VbtWKbirCKtaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+XvAXW4C6ptoiZwtTaJbjeFlIdHn1zoDlXR3ijCK0FgnIIPXdhYCKI7kPzZfPrWv+aOOU+z4WqQI/UmyfLgb0F1nWP4jI/mNd7rcUDIY+1Sn3ZkXbKSFu2TjgIvx6yyx71pXZNLATIxP67kG9O6k1IbowvMEazicYCCZBjEIBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fbjAFMvq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=g/e8smng; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fbjAFMvq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="g/e8smng"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789419147;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ru5e1lRl9m4tTPmIdTlQ205KdS8MxoV2jZJ0mGACtj4=;
	b=fbjAFMvqGt58Duf3ChlkI8KSAumW9i97K37mdhhHQfAib7idiEWcgOCVoWsPFli7i91AXd
	/bKrJYCCprOcqnXQLQ53/7gIO0YBIFUpc9ZQht6bvpxeAgASN98RHAr3P66vOxi9yeG9Nt
	NsC5dSBBkOlZrZ+a61PwwJ6Q/nS0bvA=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-RS9ZHSqrP0GyJRqTuJdmow-1; Mon, 14 Sep 2026 16:52:26 -0400
X-MC-Unique: RS9ZHSqrP0GyJRqTuJdmow-1
X-Mimecast-MFC-AGG-ID: RS9ZHSqrP0GyJRqTuJdmow_1789419145
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-530256c61b4so78242361cf.3
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 13:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789419145; x=1790023945; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ru5e1lRl9m4tTPmIdTlQ205KdS8MxoV2jZJ0mGACtj4=;
        b=g/e8smngjdmNfpe1GBAVAdtaB7s3QINIHGcruTrC2+qYSJBEpTNlH4U6+24RrfoLDn
         qxkdnC8NBBUCMbH+IcnoUTKM4HWQtW79INH02j/npjBbovw+yyAOb2G2a9aXVx/LuWif
         gSZVztMq2QH5jKVyam3OIEdrsaSlfA483wlLrsiOQVivtLHV9EfUkBcjNgE62Tn2e4lJ
         XaZITlX0To188Mo0Muxg+M5xX2aogVvUOBL3PBNQebVIQdhM11rGQNxk23YaLGQD8xdK
         CZTdkIguoAbCg8S80ieCRF+qa1Xvqj2r4l6E2Z/9x7BlcLLxp9kY1+62prLMgDXP4hAp
         ijOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789419145; x=1790023945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ru5e1lRl9m4tTPmIdTlQ205KdS8MxoV2jZJ0mGACtj4=;
        b=hp2/k4oWQw3WCaRwRmRxSEEg14eIVcDRaTRQH8Pou9b/ftk5XHRqQfZ+6P0sF/G3D0
         nIIOg3xudlNIa2y4hRvE6clURElNBa4/K4TiORwZjsM1/daGq5nZCRwqa2P/pyjF5Eco
         z5tiq2U6t7AX27cSQwFFQQKJ6LZTS9WW2noilPD8ng97O7JITGaPKELVP5l9ldbxDn3m
         ygmSK6kRK5maO3jHkUfYotOVrKqy9azLUIZSj4jaJlYV5e1NMKkm4qLAZfsE7k8lTMN7
         OdoXp7H96/42GzZz2X/AGoo5dlvRlZ4pr9dT5tkm5DwQg5LhNPmUPV1UZIpu+ZYRgqTZ
         SxLQ==
X-Gm-Message-State: AFuF++msx7088xV4Htn1JGS5yDjmHPCEXX2CnivGnuzKZGHPu/PKd0Vk
	60XaYLA022Ff61WuEacQvC3vO25BencqQCvCRnpjnzDw6bgpCEWVCl4i8pokfRrva1Yo4mNwYfW
	8QcqWV9BIGMC+v5meWe86jfHDI/PecoUJGpb5YUxGFJdbEVYsauS9l1dkJwLqi3Q0+dSMQ6BVn3
	HbxFwsOYGOjUP3XI7xhsw77Zo0UfA/u0sbHebQBYqiUNxMLJA=
X-Gm-Gg: AYBFou1QpP7sg3KOlUXDtqB/usaTv1b6tIsKPq8EEda6TKBec87wBk9IPVviJD2hhcL
	dJCJ07fkclkFerLPbPreFuk5q4/qEPvhSI7bdLLjBT8f8Zb4VYgMhGzSb36tYFRgW/9YKd/OYvz
	bQ6+3m52YEygrrvDZesh1/0QxPciQ2G1CEfOObFRDiY5Zr9WfJSX9Xv/6ZaEER175Ack17tYyDi
	iA8n64XG9kH+wyJZt6mB0leYvy0od1KTI0B3rtwxpy0Zh35Lugp5WL02X8QlbulA9QBa7MmcwoQ
	VoKH+1qJrxPYTFbJwnKdYzj4EG2XXqFVTv3TwFEtzLv3yed2wxOkEJ0JHpiQ1HvV1cgut59ix/o
	wmeEDiNo5MWFHjPbT5t5qXRPF1P5kBMBWDUTzqw==
X-Received: by 2002:a05:620a:6086:b0:939:365a:49a5 with SMTP id af79cd13be357-93a299facfbmr584910485a.27.1789419145459;
        Mon, 14 Sep 2026 13:52:25 -0700 (PDT)
X-Received: by 2002:a05:620a:6086:b0:939:365a:49a5 with SMTP id af79cd13be357-93a299facfbmr584906285a.27.1789419144914;
        Mon, 14 Sep 2026 13:52:24 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e7f1da12sm1099236785a.9.2026.09.14.13.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:52:24 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 01/14] xfs: remove unused args argument from xfs_attr_node_lookup()
Date: Mon, 14 Sep 2026 15:46:06 -0500
Message-ID: <20260914205221.1516254-2-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914205221.1516254-1-sandeen@redhat.com>
References: <20260914205221.1516254-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b3f7b2c34ad7..8fb3adc3dd2d 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -59,8 +59,7 @@ STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
 static int xfs_attr_node_try_addname(struct xfs_attr_intent *attr);
 STATIC int xfs_attr_node_addname_find_attr(struct xfs_attr_intent *attr);
 STATIC int xfs_attr_node_remove_attr(struct xfs_attr_intent *attr);
-STATIC int xfs_attr_node_lookup(struct xfs_da_args *args,
-		struct xfs_da_state *state);
+STATIC int xfs_attr_node_lookup(struct xfs_da_state *state);
 
 int
 xfs_inode_hasattr(
@@ -709,7 +708,7 @@ int xfs_attr_node_removename_setup(
 	int				error;
 
 	xfs_attr_item_init_da_state(attr);
-	error = xfs_attr_node_lookup(args, attr->xattri_da_state);
+	error = xfs_attr_node_lookup(attr->xattri_da_state);
 	if (error != -EEXIST)
 		goto out;
 	error = 0;
@@ -985,7 +984,7 @@ xfs_attr_lookup(
 	}
 
 	state = xfs_da_state_alloc(args);
-	error = xfs_attr_node_lookup(args, state);
+	error = xfs_attr_node_lookup(state);
 	xfs_da_state_free(state);
 	return error;
 }
@@ -1386,7 +1385,6 @@ xfs_attr_leaf_get(
 /* Return EEXIST if attr is found, or ENOATTR if not. */
 STATIC int
 xfs_attr_node_lookup(
-	struct xfs_da_args	*args,
 	struct xfs_da_state	*state)
 {
 	int			retval, error;
@@ -1417,7 +1415,7 @@ xfs_attr_node_addname_find_attr(
 	 * to where it should go.
 	 */
 	xfs_attr_item_init_da_state(attr);
-	error = xfs_attr_node_lookup(args, attr->xattri_da_state);
+	error = xfs_attr_node_lookup(attr->xattri_da_state);
 	switch (error) {
 	case -ENOATTR:
 		if (args->op_flags & XFS_DA_OP_REPLACE)
@@ -1588,7 +1586,7 @@ xfs_attr_node_get(
 	 * Search to see if name exists, and get back a pointer to it.
 	 */
 	state = xfs_da_state_alloc(args);
-	error = xfs_attr_node_lookup(args, state);
+	error = xfs_attr_node_lookup(state);
 	if (error != -EEXIST)
 		goto out_release;
 
-- 
2.55.0

