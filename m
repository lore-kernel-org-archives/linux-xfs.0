Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9528155C87;
	Wed, 18 Dec 2024 19:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734551421; cv=none; b=hsEFQhuOrCvIOWi9KKvaw6MQLBK4ao/QW7Yr2vcS85SZsOOxOFsIILKy5StTzqeDLbM8iMx7I+Ce1WKF/g0xgWgn1LL82SaujHlOcqeeOsY2mSl2eb2lMtZM7pROaPWJVLTuXURyq0hvSW+cKcd6SwDAzwsfy7dD0wvBKUMA6FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734551421; c=relaxed/simple;
	bh=vqYZmsvcG6U/5Mh5MfuNRBOvNlC1AWXKUBNrgvbx+mY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P/DY8rF6ueDySQye6FhBfLV16rVi5m5IjSiNX/O+0aQ36AACgN/SH2gFSgpETVfnHefNo/FAgGqHynRxIZbSBHFjHwH+IrKRpte6m1LQ6QiD02sAnccBYeO5gPuT6PvzOdkm7v/65KpgjiPftuVCKE3kaQ65xHoPgapzHJN4zpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Aw5e0iU/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Aw5e0iU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C76C4CECD;
	Wed, 18 Dec 2024 19:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734551421;
	bh=vqYZmsvcG6U/5Mh5MfuNRBOvNlC1AWXKUBNrgvbx+mY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Aw5e0iU/u/OSvZEsxrOI6XIbpvxlMGAXBK0LlYOq/v2XICGfYVRS4BGXO6zvE8W8k
	 6ppNaXmgIetHKbaLJfKoP4XeLlKrO95n0TaoL+NUCoykXS0IpCi9uWaPjcMVqL90tu
	 fdPGf137FuFiJROlnZnr7mGabvz5HGE/w4Js2v5DV2BtdkaxWWTBmema7Nghk2umZn
	 FhizRCOjkAQ/iHt4o5KjGfJXYUxlSmtBmcQhmPmmNYLi3l4vWWFuBwLkGIEJ78R2/z
	 Y/1YKZvCKPpd1dmAonEmufUeRRsUB0NUBoN/9dBrKzgiPbqHKEk1ShRMS/d991JE8p
	 l3nCsLEaAhu+g==
Date: Wed, 18 Dec 2024 11:50:20 -0800
Subject: [PATCH 1/5] xfs: sb_spino_align is not verified
From: "Darrick J. Wong" <djwong@kernel.org>
To: stable@vger.kernel.org, djwong@kernel.org
Cc: dchinner@redhat.com, cem@kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173455093514.305755.18242328636177192354.stgit@frogsfrogsfrogs>
In-Reply-To: <173455093488.305755.7686977865497104809.stgit@frogsfrogsfrogs>
References: <173455093488.305755.7686977865497104809.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Dave Chinner <dchinner@redhat.com>

commit 59e43f5479cce106d71c0b91a297c7ad1913176c upstream.

It's just read in from the superblock and used without doing any
validity checks at all on the value.

Fixes: fb4f2b4e5a82 ("xfs: add sparse inode chunk alignment superblock field")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[djwong: actually tag for 6.12 because upstream maintainer ignored cc-stable tag]
Link: https://lore.kernel.org/linux-xfs/20241024165544.GI21853@frogsfrogsfrogs/
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 02ebcbc4882f5b..9e0ae312bc8035 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -391,6 +391,20 @@ xfs_validate_sb_common(
 					 sbp->sb_inoalignmt, align);
 				return -EINVAL;
 			}
+
+			if (!sbp->sb_spino_align ||
+			    sbp->sb_spino_align > sbp->sb_inoalignmt ||
+			    (sbp->sb_inoalignmt % sbp->sb_spino_align) != 0) {
+				xfs_warn(mp,
+				"Sparse inode alignment (%u) is invalid.",
+					sbp->sb_spino_align);
+				return -EINVAL;
+			}
+		} else if (sbp->sb_spino_align) {
+			xfs_warn(mp,
+				"Sparse inode alignment (%u) should be zero.",
+				sbp->sb_spino_align);
+			return -EINVAL;
 		}
 	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
 				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {

