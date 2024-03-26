Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54231292FD
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425318; cv=none; b=D3SzE+D1aXkzFkM2K80x+DZMYxDVACzJHS72OcKYgO8+k5lTHm3b5+AC1bAdVBkNbBewTKxGFF5aL3GORKzDNPXpbuyK/fHnhMx+ZaLKEhQy5pbF9b+7CKjrHStcIh6OetAYXOD1pXcVogl2+X1ohm3qI2u+E9ERFP8zd//q41A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425318; c=relaxed/simple;
	bh=28Ea2W/BHOsd5t/IeySyi7nl0cqnxLas8Z5XdHOY4/A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s6Q/8YbFK9WGV/J4YqGwAIWIeQJ2KWdM6cuxHlfGw8JepsHJyT07Av8RSEppGPWt95b2eqjlE0f9/gw7OEkpDSib1e+FQTW+eJ1qir+3wJoJ3zHWviForkCH5EATXq0HjGMRKi1yE8M8XPqXFj15xqoeoKnIG/s2CKSg+0BajUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tiCNVYSX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tiCNVYSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD720C433F1;
	Tue, 26 Mar 2024 03:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425318;
	bh=28Ea2W/BHOsd5t/IeySyi7nl0cqnxLas8Z5XdHOY4/A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tiCNVYSXbCZqj6FBebk7Qc/Ehmt/IF9nyLuY8Oh6Z8gkV1rJ39mk4o9CbVh08GLi7
	 C/mJ8GptR0ew4xRMFCC0XFMQI8LCSqE1RZcM1G4lWfrVmw4WGmSXBOplD4YWyEDuCk
	 0hgaae0sSPzTQ0wirSgWilfmYGY1j7AM6u8HoqUCI7yDnJPbsvtlbbmeO4zjYUTUy9
	 AASjvLlTbLJKx5jrZI9RtyTNidEcnD5vSKl00V4m7D6jsm5BKpLiXOmYgehymfkfw/
	 LVF6KOvKfRjWMXvkjBvGmUhuoWTBG/t3kUymP7kJxmkGT/+jq/QDuzEH03ks0nlH2h
	 4hnOtG9/Hnrlg==
Date: Mon, 25 Mar 2024 20:55:18 -0700
Subject: [PATCH 103/110] xfs: add a realtime flag to the bmap update log redo
 items
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132863.2215168.6186467309953298926.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: 7302cda7f8b08062b11d2ba9ae0b4f3871fe3d46

Extend the bmap update (BUI) log items with a new realtime flag that
indicates that the updates apply against a realtime file's data fork.
We'll wire up the actual code later.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_log_format.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 269573c82808..16872972e1e9 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -838,10 +838,12 @@ struct xfs_cud_log_format {
 
 #define XFS_BMAP_EXTENT_ATTR_FORK	(1U << 31)
 #define XFS_BMAP_EXTENT_UNWRITTEN	(1U << 30)
+#define XFS_BMAP_EXTENT_REALTIME	(1U << 29)
 
 #define XFS_BMAP_EXTENT_FLAGS		(XFS_BMAP_EXTENT_TYPE_MASK | \
 					 XFS_BMAP_EXTENT_ATTR_FORK | \
-					 XFS_BMAP_EXTENT_UNWRITTEN)
+					 XFS_BMAP_EXTENT_UNWRITTEN | \
+					 XFS_BMAP_EXTENT_REALTIME)
 
 /*
  * This is the structure used to lay out an bui log item in the

