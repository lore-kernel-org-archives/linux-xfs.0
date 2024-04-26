Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35DD3AC01
	for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 21:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714168571; cv=none; b=cfFUqRY2GMF6ZS3oEipNt11Ty33jKSESxPDTffEGYFY2AOX3OfjWrKnJiGQTNK7nPgUq9YgWVtbL5FzD/X/NA7f8BPIjZcCqOreNs0p0xk5rhRz0J/GM89hSPQ/jZB9HFIrI7QEYBtNI4Qg2r3SwWHPa+h6ciKxynjsPFSHLYXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714168571; c=relaxed/simple;
	bh=XmzbHAvg2b6sJ0iPja5NIyp38GHTvg5TSU3divPaVoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnpbwXKpZFiNdAXAnRWhTxt1U/oe2pf9tpmQLfNIBMDQyUnIoZZmPVPoCmOwuJ0OtmoAXT+xUf+c8+jNle780MOKdXP9KbfRCheQNqzs0C7FqR/sliwGxGo3V/2aJRvCD+U2p77ScAYOyEIrtBwhC9HFI1hMBsPiNCmHX4FZWho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y5Cj4g3P; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y5Cj4g3P"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5d8b519e438so2072779a12.1
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 14:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714168570; x=1714773370; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pht/K/7CZKwiiqOQN9VzZ+/9t5Cm8B/yBFfj5eXlF9o=;
        b=Y5Cj4g3PKtBtAe3YbP5SqshNidcIFczTx+CK5dkB2g8NzCc6zSeo6rAnACB+7iN7Cx
         aOBGWUx++UoiiRLZxE+UihxFR5Dv5sXNCeugSx+mHstqwA6UfBxpvGaW9zm1CEGIGY3h
         RwJLzp8P0LhsPT9QroNovPIOojJ+J4i3bnwXNjhBI4U12c6r++7uthCDeIzL4mLENyeq
         FSpgK5rtGTeQSfLzXrkS392x63pjZ8eb8vQxNOA0FMwuLdlo7qDFISJmmq9OcDUflo1S
         OVhcptrQj4cyQSxOFgnj98hLz7fnNJaawIT0CTMYd1SCJDG59OF+b2fMNyFhBi8elZQl
         XPHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714168570; x=1714773370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pht/K/7CZKwiiqOQN9VzZ+/9t5Cm8B/yBFfj5eXlF9o=;
        b=YYdobYUzSO+gRxqsd5OM1gu1LaRYwyB75BwryOIsr+3Zga99HGXYPHDEW4S6XTrbwH
         FzeaKOhgUbffNxz9bL79P7nojVUZvuMOumOwFcSXMZZjcl1lIWjEKMM0Rf4PzroYBn+7
         /gk8WbWaleCtAjkdJ/mkvYWgzRAbYWC29tj4nIWC+HOb/XLJd1/a1aU340bSDIZf+nTr
         EdmVkzf38OEzJovczfOEBdH0xAgNZwR5lie1wjXYrjAj4XPTnpl2y9wL3WT9nbfqUnoo
         iFmFz+AngqnqaGlK3rUnTPn+GFxEkxRQA2ygY+HfhoJH4yoKhYD30joe6Tjcw1pNDTMX
         L4qg==
X-Gm-Message-State: AOJu0YyLX29TOiSb42NtHin4VqRm5wgmiDolBFdL5ZMIqMy/yJbVTtZP
	Iq7aXxlIiVhvN4Gz+WgPntDFGf+XQ/O2LHTXf6o69wqKUFCmEsLSTabO1TC+
X-Google-Smtp-Source: AGHT+IEVcl6FGXitanH6nqcz9w950sg3/erj0t12/pyTV2CrpCuG92rBDR/p/9VP090rJVScYloucA==
X-Received: by 2002:a17:902:f605:b0:1eb:ed2:f74c with SMTP id n5-20020a170902f60500b001eb0ed2f74cmr3511517plg.67.1714168569866;
        Fri, 26 Apr 2024 14:56:09 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2b3a:c37d:d273:a588])
        by smtp.gmail.com with ESMTPSA id b18-20020a170903229200b001eb2e6b14e0sm855772plh.126.2024.04.26.14.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 14:56:09 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	mngyadam@amazon.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 20/24] xfs: invalidate xfs_bufs when allocating cow extents
Date: Fri, 26 Apr 2024 14:55:07 -0700
Message-ID: <20240426215512.2673806-21-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
In-Reply-To: <20240426215512.2673806-1-leah.rumancik@gmail.com>
References: <20240426215512.2673806-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit ddfdd530e43fcb3f7a0a69966e5f6c33497b4ae3 ]

While investigating test failures in xfs/17[1-3] in alwayscow mode, I
noticed through code inspection that xfs_bmap_alloc_userdata isn't
setting XFS_ALLOC_USERDATA when allocating extents for a file's CoW
fork.  COW staging extents should be flagged as USERDATA, since user
data are persisted to these blocks before being remapped into a file.

This mis-classification has a few impacts on the behavior of the system.
First, the filestreams allocator is supposed to keep allocating from a
chosen AG until it runs out of space in that AG.  However, it only does
that for USERDATA allocations, which means that COW allocations aren't
tied to the filestreams AG.  Fortunately, few people use filestreams, so
nobody's noticed.

A more serious problem is that xfs_alloc_ag_vextent_small looks for a
buffer to invalidate *if* the USERDATA flag is set and the AG is so full
that the allocation had to come from the AGFL because the cntbt is
empty.  The consequences of not invalidating the buffer are severe --
if the AIL incorrectly checkpoints a buffer that is now being used to
store user data, that action will clobber the user's written data.

Fix filestreams and yet another data corruption vector by flagging COW
allocations as USERDATA.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 56b9b7db38bb..0d56a8d862e8 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4058,7 +4058,7 @@ xfs_bmap_alloc_userdata(
 	 * the busy list.
 	 */
 	bma->datatype = XFS_ALLOC_NOBUSY;
-	if (whichfork == XFS_DATA_FORK) {
+	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK) {
 		bma->datatype |= XFS_ALLOC_USERDATA;
 		if (bma->offset == 0)
 			bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
-- 
2.44.0.769.g3c40516874-goog

