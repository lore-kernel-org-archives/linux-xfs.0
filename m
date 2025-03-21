Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FFD4431
	for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 16:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742574723; cv=none; b=kMqAxjHUKz4KWTsKmCuI+CcaVmeRnmZe8q10KOkjO7mG3XV0Ia2YNhi4L8cYZq8V5DzVxRgFiGZQfvj+R9Z1ECceYB71yISZHF27aauFC3g2IRgXsRmoJoBD9ResaudiFuoOxI3WaRgUedl0QL+nJeP/6n35BVaydG8kbaTSweQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742574723; c=relaxed/simple;
	bh=JgUE65fFY1LvY7SAawaildBfpUI02MelWAbERicKops=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J85wdoAyR+VOSDsVllvl1Jfx++QL65NAGsuhtESBrnDYmiSPQzfRflhEeBBRjS/sp4TZnwW/NLWshFGchAzOnDs93/4mi+8OM7/TyRgM89eAK4ZdEwAp1tjufGD60SU97RpjlPB2e2eNAtFpaX93TJdwItuWruJkD/xvK6bNKfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ukNilgrs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ukNilgrs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB17EC4CEE3;
	Fri, 21 Mar 2025 16:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742574722;
	bh=JgUE65fFY1LvY7SAawaildBfpUI02MelWAbERicKops=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ukNilgrsU8lul0WYIpmBc8R4HEFXmeYEgtW48smZQX2yOFbkM5KEALAn282GljOP2
	 KQmkB5RBDCVq1M3W1ErSWv7bNWP7bVrYFMKRgPWqB6W937+rUK25H2hSlss2ByDNuf
	 Zfixh5BEEix0j07/RPWAFDiSg1/9ycnR5I+292dDvtFRrSOIFLLaV4Puidf3Qn9gNu
	 RVNsW4xQOWE3/4Pr5ZKzR1cT2/37BDe649MSRAQYgTM/fdp+TJxccEVv9paYshWjbz
	 TAt07KvYkcwf1dWJeQ2ew3DVNFthoQZ6b+vNgC9CfSrS+LLmVR+cCXTFD/FlrNhbIP
	 WSa8mZGP9p7Ew==
Date: Fri, 21 Mar 2025 09:32:02 -0700
Subject: [PATCH 3/4] xfs_repair: fix infinite loop in
 longform_dir2_entry_check*
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <174257453651.474645.12262367407953457434.stgit@frogsfrogsfrogs>
In-Reply-To: <174257453579.474645.8898419892158892144.stgit@frogsfrogsfrogs>
References: <174257453579.474645.8898419892158892144.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If someone corrupts the data fork of a directory to have a bmap record
whose br_startoff only has bits set in the upper 32 bits, the code will
suffer an integer overflow when assigning the 64-bit next_da_bno to the
32-bit da_bno.  This leads to an infinite loop.

Found by fuzzing xfs/812 with u3.bmx[0].startoff = firstbit.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/phase6.c          |   22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 14a67c8c24dd7e..dcb5dec0a7abd2 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -399,6 +399,7 @@
 #define xfs_verify_agbext		libxfs_verify_agbext
 #define xfs_verify_agino		libxfs_verify_agino
 #define xfs_verify_cksum		libxfs_verify_cksum
+#define xfs_verify_dablk		libxfs_verify_dablk
 #define xfs_verify_dir_ino		libxfs_verify_dir_ino
 #define xfs_verify_fsbext		libxfs_verify_fsbext
 #define xfs_verify_fsbno		libxfs_verify_fsbno
diff --git a/repair/phase6.c b/repair/phase6.c
index c16164c171d07d..44b9bfc3b7e69f 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2169,6 +2169,13 @@ longform_dir2_check_node(
 		if (bmap_next_offset(ip, &next_da_bno))
 			break;
 
+		if (next_da_bno != NULLFILEOFF &&
+		    !libxfs_verify_dablk(mp, next_da_bno)) {
+			do_warn(_("invalid dir leaf block 0x%llx\n"),
+					(unsigned long long)next_da_bno);
+			return 1;
+		}
+
 		/*
 		 * we need to use the da3 node verifier here as it handles the
 		 * fact that reading the leaf hash tree blocks can return either
@@ -2244,6 +2251,13 @@ longform_dir2_check_node(
 		if (bmap_next_offset(ip, &next_da_bno))
 			break;
 
+		if (next_da_bno != NULLFILEOFF &&
+		    !libxfs_verify_dablk(mp, next_da_bno)) {
+			do_warn(_("invalid dir free block 0x%llx\n"),
+					(unsigned long long)next_da_bno);
+			return 1;
+		}
+
 		error = dir_read_buf(ip, da_bno, &bp, &xfs_dir3_free_buf_ops,
 				&fixit);
 		if (error) {
@@ -2379,6 +2393,14 @@ longform_dir2_entry_check(
 			break;
 		}
 
+		if (next_da_bno != NULLFILEOFF &&
+		    !libxfs_verify_dablk(mp, next_da_bno)) {
+			do_warn(_("invalid dir data block 0x%llx\n"),
+					(unsigned long long)next_da_bno);
+			fixit++;
+			goto out_fix;
+		}
+
 		if (fmt == XFS_DIR2_FMT_BLOCK)
 			ops = &xfs_dir3_block_buf_ops;
 		else

