Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7087334A3AF;
	Tue, 21 Oct 2025 18:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761071397; cv=none; b=cKXhMEZkK87BbHasj03C6yR/o2ronaV6TseJPR/08xrIJCzhLpg9Vza5j0LUVhERB0Ihg3nrY3QJ6x8OJiVXORKkRV5FJpfuDbUvZ48gPiv8KLbzrDO/5RL66A2CPKVYxh3Gp2bc6qeVv48+1RUqAm0AxIr5Oy9h7qpDP3w3uf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761071397; c=relaxed/simple;
	bh=c7HFCnMDi6dVOOnwECkUTn7tB5L3czGdK4OVPl0YbaU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d0ivvO9yXcMqlidBI65T2uUrZgPJjqBBLap+ikFTSGjicJuR8fohU0L+wbxOfZlMZMZOrM7oCIDU3VKmXK2YWlavhC24vJnaX3FQXSmcyXSZ6r/fWzDQRMD0yxQwMomdO5nHeL3cTAqVWS2xzfMbOwNoTmk719zxJ9G4/5jrDUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mhU25ise; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mhU25ise"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F317CC4CEF7;
	Tue, 21 Oct 2025 18:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761071397;
	bh=c7HFCnMDi6dVOOnwECkUTn7tB5L3czGdK4OVPl0YbaU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mhU25ise531AsNEIUR/NjFlAUazYWVRmXGN9igWYEu0pB9vms7UkzsNNjCsql1X3g
	 8VohgCp7NIOMmizZVcQQxoqp+2rRvL3e2oXIja0IXroTJZUCKluGzgJ0mGwJLEh2c4
	 pcdHT6mJ6uAsuiFhduTVlpEHqvNxGcC8JhyxHnaOZ+gqBMko/7kr/I+GMLfx1yRo2s
	 24p58gqL3FzQ3zPTNKFrPnSTmp4OWwS6pGx0V5zQA/0LVVNt+oNQHc118c+SaQjSCW
	 ty5RY1pk04XhrHIoaAxchuvFm6b6MVe4PWLSz5+6y28kE+p3Vh0EOnaeJBBJdZabKn
	 bu35NbF1URuiQ==
Date: Tue, 21 Oct 2025 11:29:56 -0700
Subject: [PATCH 1/4] xfs: don't set bt_nr_sectors to a negative number
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <176107134001.4152072.8614924012436403838.stgit@frogsfrogsfrogs>
In-Reply-To: <176107133959.4152072.11526530466991879614.stgit@frogsfrogsfrogs>
References: <176107133959.4152072.11526530466991879614.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

xfs_daddr_t is a signed type, which means that xfs_buf_map_verify is
using a signed comparison.  This causes problems if bt_nr_sectors is
never overridden (e.g. in the case of an xfbtree for rmap btree repairs)
because even daddr 0 can't pass the verifier test in that case.

Define an explicit max constant and set the initial bt_nr_sectors to a
positive value.

Found by xfs/422.

Cc: <stable@vger.kernel.org> # v6.18-rc1
Fixes: 42852fe57c6d2a ("xfs: track the number of blocks in each buftarg")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.h |    1 +
 fs/xfs/xfs_buf.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 8fa7bdf59c9110..e25cd2a160f31c 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -22,6 +22,7 @@ extern struct kmem_cache *xfs_buf_cache;
  */
 struct xfs_buf;
 
+#define XFS_BUF_DADDR_MAX	((xfs_daddr_t) S64_MAX)
 #define XFS_BUF_DADDR_NULL	((xfs_daddr_t) (-1LL))
 
 #define XBF_READ	 (1u << 0) /* buffer intended for reading from device */
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 773d959965dc29..47edf3041631bb 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1751,7 +1751,7 @@ xfs_init_buftarg(
 	const char			*descr)
 {
 	/* The maximum size of the buftarg is only known once the sb is read. */
-	btp->bt_nr_sectors = (xfs_daddr_t)-1;
+	btp->bt_nr_sectors = XFS_BUF_DADDR_MAX;
 
 	/* Set up device logical sector size mask */
 	btp->bt_logical_sectorsize = logical_sectorsize;

