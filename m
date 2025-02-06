Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C892417C7
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882716; cv=none; b=AEXeRdaF2w0UJP/DhuieJG/+GfMtfSJRJ12D3kRdw9YpGhThOlQckzes2KUqr2ddWxPianrvwTeIuA6SqMnfQ9Acspw6OFOp4F+UZUn8CTOH1CrsQDgzvtmrZpJguync8Bm2RDbCmK4jkBqbNr0zQ5yVpvrSCaBDzZI0qMLrJfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882716; c=relaxed/simple;
	bh=nOV+cSI4wsstJSOX4eqyWbozoKJgzsu+h1bg9yd8qqE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A+BbWTHYXyrJaKcg77okhQAn0ncUxRwgReKYi2u+hPzhiNonIp/3tD+n872QFPD4YKQYO6c+osUNlUsymtCsLcVMoX8UXn/EaG0wFWGFZVDg+JvTd0X+schwk2Nr7MqAxzES3hqpaw5NN4ce77kcKGQLVDGbOnvFdvTWuOjkYXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K5uHiaPC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K5uHiaPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0931CC4CEDD;
	Thu,  6 Feb 2025 22:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882716;
	bh=nOV+cSI4wsstJSOX4eqyWbozoKJgzsu+h1bg9yd8qqE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=K5uHiaPCMoK7nvSdLR2raGeFiyh8iXf4eq8tX+sf5Po26zsK/nl8M2h2QpRsOG8iv
	 93TBVljexob3harSiEdEdJF7c5VF/o+XCq2kdnB2SMm8/Kp6XOEBpVxp0GQNvovMMO
	 9wMzbFBANgZCViqIltRtj7wsIszZiahkKRBW4GdSvp2MF1UVhJjX6LR8xifLZXWA6k
	 sOEVFyxvQB1rvpofO9L1ibmO+NfaOSCk8eNTCpoAdkoejxXhSzC3USXAz5ZLiwQPQv
	 4FGMSQBe5FY8ajjafih8bRPVp80TqfNllx9DZf2aMcEm2MYZcCj4+H43XWPhqBb1DO
	 bgOtE4vRbLc+g==
Date: Thu, 06 Feb 2025 14:58:35 -0800
Subject: [PATCH 07/22] xfs_db: support the realtime refcountbt
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888089041.2741962.5577654086707722081.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Wire up various parts of xfs_db for realtime refcount support so that we
can dump the rt refcount btree contents.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/btblock.c             |    3 +++
 db/btdump.c              |    8 ++++++++
 db/btheight.c            |    5 +++++
 libxfs/libxfs_api_defs.h |    1 +
 man/man8/xfs_db.8        |    1 +
 5 files changed, 18 insertions(+)


diff --git a/db/btblock.c b/db/btblock.c
index 40913a094375aa..e9e5d2f86b9f01 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -159,6 +159,9 @@ block_to_bt(
 	case TYP_REFCBT:
 		magic = crc ? XFS_REFC_CRC_MAGIC : 0;
 		break;
+	case TYP_RTREFCBT:
+		magic = crc ? XFS_RTREFC_CRC_MAGIC : 0;
+		break;
 	default:
 		ASSERT(0);
 	}
diff --git a/db/btdump.c b/db/btdump.c
index 55301d25de10cd..29ff28f1639977 100644
--- a/db/btdump.c
+++ b/db/btdump.c
@@ -456,6 +456,7 @@ dump_btree_inode(
 	char			*prefix;
 	struct xfs_dinode	*dip = iocur_top->data;
 	struct xfs_rtrmap_root	*rtrmap;
+	struct xfs_rtrefcount_root *rtrefc;
 	int			level;
 	int			numrecs;
 	int			ret;
@@ -467,6 +468,12 @@ dump_btree_inode(
 		level = be16_to_cpu(rtrmap->bb_level);
 		numrecs = be16_to_cpu(rtrmap->bb_numrecs);
 		break;
+	case XFS_METAFILE_RTREFCOUNT:
+		prefix = "u3.rtrefcbt";
+		rtrefc = (struct xfs_rtrefcount_root *)XFS_DFORK_DPTR(dip);
+		level = be16_to_cpu(rtrefc->bb_level);
+		numrecs = be16_to_cpu(rtrefc->bb_numrecs);
+		break;
 	default:
 		dbprintf("Unknown metadata inode btree type %u\n",
 				be16_to_cpu(dip->di_metatype));
@@ -549,6 +556,7 @@ btdump_f(
 	case TYP_BMAPBTA:
 	case TYP_BMAPBTD:
 	case TYP_RTRMAPBT:
+	case TYP_RTREFCBT:
 		return dump_btree_long(iflag);
 	case TYP_INODE:
 		if (is_btree_inode())
diff --git a/db/btheight.c b/db/btheight.c
index 31dff1c924a2e0..14081c969a922c 100644
--- a/db/btheight.c
+++ b/db/btheight.c
@@ -58,6 +58,11 @@ struct btmap {
 		.maxlevels	= libxfs_rtrmapbt_maxlevels_ondisk,
 		.maxrecs	= libxfs_rtrmapbt_maxrecs,
 	},
+	{
+		.tag		= "rtrefcountbt",
+		.maxlevels	= libxfs_rtrefcountbt_maxlevels_ondisk,
+		.maxrecs	= libxfs_rtrefcountbt_maxrecs,
+	},
 };
 
 static void
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 167df04df8fb1b..87a598f346f86a 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -321,6 +321,7 @@
 #define xfs_rtgroup_put			libxfs_rtgroup_put
 
 #define xfs_rtrefcountbt_droot_maxrecs	libxfs_rtrefcountbt_droot_maxrecs
+#define xfs_rtrefcountbt_maxlevels_ondisk	libxfs_rtrefcountbt_maxlevels_ondisk
 #define xfs_rtrefcountbt_maxrecs	libxfs_rtrefcountbt_maxrecs
 
 #define xfs_rtrmapbt_calc_reserves	libxfs_rtrmapbt_calc_reserves
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 8326bddcef8378..08f38f37ca01cc 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -536,6 +536,7 @@ .SH COMMANDS
 .IR bmapbt ,
 .IR refcountbt ,
 .IR rmapbt ,
+.IR rtrefcountbt ,
 and
 .IR rtrmapbt .
 The magic value

