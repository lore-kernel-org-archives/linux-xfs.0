Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5784574267;
	Thu, 20 Jun 2024 20:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718917063; cv=none; b=O//1A34RB+dy0Z8q+Saom+8KtsD7w1E5LOPgt+insQB56d8hJoGf+nQTm+H9SQVeP3wEbwW/3Zrp5IIGQGE8Sdcg+Zn+VV9ECzqR4ssFc9KYs6ULbjbDU0Scv2H1tW3AO4a2N1vEkpReglZneRUPSqioEVvppZkro8ZsfWZybTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718917063; c=relaxed/simple;
	bh=j+SfqE42SlE5sWpHa837QH0rLm7g1fAqjIYdSjPwFWc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JC34xYhaEPd8zcnE9YWxgD4PSVsL+9tlB4Q1cU6vcpzwDROIVvBEOzS+/7IXwCWdyXhu2jSPe0SXrXlgQNuc/nryyYjgNyW4Ye8coodg3IYnj+8znUqYq6ONj8C03+3GbNtHJzvBllsVCCfhWZI4cYakpvKblOU1cHZz7dN0s04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ozUvZ/Il; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ozUvZ/Il"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F202C4AF09;
	Thu, 20 Jun 2024 20:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718917063;
	bh=j+SfqE42SlE5sWpHa837QH0rLm7g1fAqjIYdSjPwFWc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ozUvZ/IlbKUBIQZOL4X+InSdJPL9poB/SBrk3Km5n5QNflyrtVXmDweitqE/+PywY
	 z1ld7cj0JBCn6qZfaqkFr12TtdRP8yI97WNqOEciRIBEZA0sxKuQyB99P8Fqj+1YtT
	 Oyhg1cWWS5EYTHsWWkKiMBUshYVYmQGE18cJchvr+o8ts7hXQOvZwbw4U2s9EN5aPH
	 xyDZYMDi3FLeVpJ7yUAfBISlGiS+BSoQouVUmucEkACNJRmAsJraB11WrY18h7clno
	 OynUmfwdxeVYFPvlK8/UVoa2i3PBOc+le72yf9qCiYSbft3BwIRHypAuaZa5VWPUUI
	 HH1kOmp3BGfUg==
Date: Thu, 20 Jun 2024 13:57:42 -0700
Subject: [PATCH 03/11] xfs/122: update for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
 allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171891669686.3035255.7620855515754222234.stgit@frogsfrogsfrogs>
In-Reply-To: <171891669626.3035255.15795876594098866722.stgit@frogsfrogsfrogs>
References: <171891669626.3035255.15795876594098866722.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Update test for parent pointers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/122.out |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 86c806d4b5..7be14ed993 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -100,6 +100,9 @@ sizeof(struct xfs_fsop_ag_resblks) = 64
 sizeof(struct xfs_fsop_geom) = 256
 sizeof(struct xfs_fsop_geom_v1) = 112
 sizeof(struct xfs_fsop_geom_v4) = 112
+sizeof(struct xfs_getparents) = 40
+sizeof(struct xfs_getparents_by_handle) = 64
+sizeof(struct xfs_getparents_rec) = 32
 sizeof(struct xfs_icreate_log) = 28
 sizeof(struct xfs_inode_log_format) = 56
 sizeof(struct xfs_inode_log_format_32) = 52
@@ -109,6 +112,7 @@ sizeof(struct xfs_legacy_timestamp) = 8
 sizeof(struct xfs_log_dinode) = 176
 sizeof(struct xfs_log_legacy_timestamp) = 8
 sizeof(struct xfs_map_extent) = 32
+sizeof(struct xfs_parent_rec) = 12
 sizeof(struct xfs_phys_extent) = 16
 sizeof(struct xfs_refcount_key) = 4
 sizeof(struct xfs_refcount_rec) = 12

