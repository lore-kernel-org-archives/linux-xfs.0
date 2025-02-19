Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D74828628D;
	Wed, 19 Feb 2025 01:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927192; cv=none; b=ETSBv3eXyvOYfC/RnKuYzXhzlPowSRvbFuENrlGDOXWiTaQd2p+CGglB2mjOgwKg0lDESXgOgeeD86IaSiR7hjW2GDIXuhgR2jpOpF7+UC0gKV0e+ZtQSP3W7m+ucNpFK1UsCT+DK63iJ3Hcu5TeWSNBMWoReoarwNMZDnrx8n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927192; c=relaxed/simple;
	bh=usVYIugv9KwA/y9EWfVX3GZhu8a1LZP2vPwY2Ww+Dvs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LHHZ62hS/iZJ6cDvz4XXiuzhsT80hgQaF4KEmDI6xLlmXhgSFxqWoJ9iL0podRta2No/DIz7MDmaPDpYQjBvGXxapF8jgd5sRtvqPzNYkiM29YIBG0tAaRuazi55aysSo5VAcg9BJUjBcQXlpUbxTNARLDU+nvIJGAe9gF+QNVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oNOwStNs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oNOwStNs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8281AC4CEE2;
	Wed, 19 Feb 2025 01:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739927191;
	bh=usVYIugv9KwA/y9EWfVX3GZhu8a1LZP2vPwY2Ww+Dvs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oNOwStNsQlaJ+3TYdKcHqJGBZbBVw95SKyEZBgeehJ/fzB7OZoB5LC1q3TzUlhZJc
	 96oPRADYE7u8L8uetAm5RKDSJbhz5Q1ejCvmVM/mhL8ye5/JcSWxhobCvB8gAFfAL7
	 1FBVce9Rv2BO8/UIGUerSr4AUuhEVIoDJGF6fVu4cdpnuXMsnkjaGRJ6jGZX5evsmT
	 jkNBswp6Fxbmb2/gw3UdlBeFXvPkkW4ALLbhYW9MChSTF46N4iipHodFp/WxPTAo5q
	 VeLIcllMBNhXqQ0v3X9OCwdUYk8IrS0ZC/V1/zI6ZQ3KwYNdbnOuakQ16vWEXuMgXL
	 LyLp8MxSEFLFw==
Date: Tue, 18 Feb 2025 17:06:31 -0800
Subject: [PATCH 11/13] populate: adjust rtrmap calculations for rtgroups
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992591313.4080556.12323562393894296677.stgit@frogsfrogsfrogs>
In-Reply-To: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
References: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we've sharded the realtime volume and created per-group rmap
btrees, we need to adjust downward the size of rtrmapbt records since
the block counts are now 32-bit instead of 64-bit.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/populate |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/common/populate b/common/populate
index ade3ace886f4d4..1741403fafd9aa 100644
--- a/common/populate
+++ b/common/populate
@@ -463,7 +463,7 @@ _scratch_xfs_populate() {
 	is_rt="$(_xfs_get_rtextents "$SCRATCH_MNT")"
 	if [ $is_rmapbt -gt 0 ] && [ $is_rt -gt 0 ]; then
 		echo "+ rtrmapbt btree"
-		nr="$((blksz * 2 / 32))"
+		nr="$((blksz * 2 / 24))"
 		$XFS_IO_PROG -R -f -c 'truncate 0' "${SCRATCH_MNT}/RTRMAPBT"
 		__populate_create_file $((blksz * nr)) "${SCRATCH_MNT}/RTRMAPBT"
 	fi

