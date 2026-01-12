Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A142D3ECF
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 14:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229497; cv=none; b=VLn+qsDoREf/inoNoxDqf2L4iz43p7pPSqBSoEVAydWY+BFV3BDq5TIuSNHH704E336HGqqtUA1Z2HPfMnC9+effGEwLScGwcZuJ1yyGaSBTkEmfEx/S8slZd3+9I3HpncM7RGVEwaONQ02YKtT4ce+auM3n1ic+FytGQr/laQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229497; c=relaxed/simple;
	bh=JPjcCt7QWTf38nAptPhawsXuiMG7Azz0b4ENiSKcovw=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AZnQyfNkgzF2nYA0YfiMETTnzzy40FoKn50hJk3KpSAZMal60nox8KRSQBfftAmMACIFN0yHjWtDAEiA4o7VKjmdVw5uIDgRaFnVJe6tT3VhwLkro0wRbOgDuA1fYM4XrkAScjLTBUzmkePNvJX/hA3u9I71sWFN4BUXpIF/IkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ez/mkTvR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Udqzx1ld; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ez/mkTvR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Udqzx1ld"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768229495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MQFyKAmxkxq8BXZgaDmWovpGdqDXxz9LIVm+AcEZ+2Q=;
	b=ez/mkTvR11qr9RMN7hh6gmj/MmEwhEgZDo81zR9/Fy/OyxDFMCtZw62dqvRvVj3HaXQMiv
	bFXqMK0FwzNpO5dluLDx8L5trFcrFFYOKYpC8wwjaZNqHCQgy5IvMA/zdt1C3IJQAJ4Y71
	2d1aRMAXJb3JH/coWS+0jyeXyaZ65Ww=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-110-y3hL8-y4N4y9zXuoTgx81Q-1; Mon, 12 Jan 2026 09:51:34 -0500
X-MC-Unique: y3hL8-y4N4y9zXuoTgx81Q-1
X-Mimecast-MFC-AGG-ID: y3hL8-y4N4y9zXuoTgx81Q_1768229493
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b870870f1aeso123631266b.0
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 06:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768229492; x=1768834292; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MQFyKAmxkxq8BXZgaDmWovpGdqDXxz9LIVm+AcEZ+2Q=;
        b=Udqzx1ldzvoyffyHrlSukFwn2qt4e/J6xJhGLZtH7UnToyZ7YsZ+H8kwCpT4pbO/b3
         3XE1GbInKcDAb4cjXmO7Rp746fcdbAsIyxeRUqDhe494Syi0jnhg21sqq7HASl0ixkhR
         AGkTKmtLh9jVVtwlZJf09F/yCxX0e6St0CNHWxZjc9Eu+2w5qpljLw1FMZyt9/xbdUGx
         UT5K/+T8kX60IdF9EfbMghvA+SU2QnNJZJS8qnUab6BhDs4Ogzu0XN+alqbgs3m+T92O
         KlxfMoCLiEaHlwG1Raylp1MlKQ6LncyD9rsccTCWA4y99h98j6GO2iavF3EOEGsI3Z++
         MdiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768229492; x=1768834292;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MQFyKAmxkxq8BXZgaDmWovpGdqDXxz9LIVm+AcEZ+2Q=;
        b=pBt8Z2ZY4qVWBwrtbJ0gZ7QESsQGnAde6COzSMXEdFsuOVpwbfE86gK3mz6Mw5gi6U
         jwvNFRZyIfXBFXj5oP6nXlJx5icLZQfdh24Za5r/PVzAxvKkSfhGnvGDi2LGv8cheEDZ
         CWFPyS1AwDs2YYWxtPN90vysrUdgX+HOVTqyPfCywZB082nYOb/MvMouzfCCEs2HfFnu
         kW01fSpwvx01/nV1jZCAh9Qsk0XPz/v5HrGAb8/KADfIB7OR5HErkpA5ozL0KTHjkPvw
         PgX77rAweviQ0z3EQkX9may2ahHz819NKm6m2Z3xkHxRsY0CH7eYZXOXDagw5W+HZz/O
         Xlrg==
X-Forwarded-Encrypted: i=1; AJvYcCWgUa+A7615RcglmHuxFHrQgv3jSpRu/4YPNT7O4xJVGbt0lXceIGBegmjU4lZwRwIzMhOStJPY+DE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyo7pYJieBRjurO9rYEpO6wpW5luwGhIrWxegdC+zX+O1FREeI+
	G8AufgOBc0gQC8hOr6ptMPUYKTimyI8TmtG2YAQWqD2GDAJspMd4MM9BV24Cwrp736tmaZOcdtL
	OSEZX2pDsQRXF4IjYr1phhV5XGtS62/Ho4NIFyAWSjm5e7d3YqPBBrYNY8n1rrEqzFCds
X-Gm-Gg: AY/fxX44sJIkWex9kcsKdU9zbum/bc+JDsT6Nzjrhmd4NERions8XQ+bMXSBVg2IXtb
	6ULxjBz70HEDQaIXgxAvaJ2NWFfkiQz9JpfbhDx0/C45dvyQ1vZThjf3PJLF+BOV47RMcn01SGG
	GKqrdjcp1n2zwOtOsmKuYCA8XglhQlQnXnfEcBauMf+ZG5H5qP4OodckUQt4t0WlCfSIiL92f1d
	Wvxzh63DuNHI2R+jyrwXA7s0d4xegUBSIZrizF+yy78fmb0pTWoMQFNMCNNQGu1N/mCRIuKccvV
	jNW8QcF5ug/hMp1m5+TYJ8rGTlNgjk5kAfV9TCkaqsYZGMO0R0EcBhHDsSDQevBUTZL2yIcpKNw
	=
X-Received: by 2002:a17:906:8a65:b0:b87:8c1:1ea5 with SMTP id a640c23a62f3a-b8708c120femr408104566b.5.1768229492473;
        Mon, 12 Jan 2026 06:51:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFT+lJr2mupsGTVPSmnIPthPNsIkn3bEkceKZ9KStsHmzA6ycghaOXhi8PQ2VxPhst05XGo9w==
X-Received: by 2002:a17:906:8a65:b0:b87:8c1:1ea5 with SMTP id a640c23a62f3a-b8708c120femr408102466b.5.1768229491989;
        Mon, 12 Jan 2026 06:51:31 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b871b5e610csm306104766b.65.2026.01.12.06.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 06:51:31 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 12 Jan 2026 15:51:30 +0100
To: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	aalbersh@redhat.com, djwong@kernel.org
Cc: djwong@kernel.org, david@fromorbit.com, hch@lst.de
Subject: [PATCH v2 14/22] xfs: disable preallocations for fsverity Merkle
 tree writes
Message-ID: <h5rtbef7rnkc7kooimncgxjefge7bybzujkxy3yrwbfkaiqiya@4n64b7spvy46>
References: <cover.1768229271.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1768229271.patch-series@thinky>

While writing Merkle tree, file is read-only and there's no further
writes except Merkle tree building. The file is truncated beforehand to
remove any preallocated extents.

The Merkle tree is the only data XFS will write. As we don't want XFS to
truncate file after we done writing, let's also skip truncation on
fsverity files. Therefore, we also need to disable preallocations while
writing merkle tree as we don't want any unused extents past the tree.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_iomap.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 04f39ea158..61aab5617f 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1938,7 +1938,9 @@
 		 * Determine the initial size of the preallocation.
 		 * We clean up any extra preallocation when the file is closed.
 		 */
-		if (xfs_has_allocsize(mp))
+		if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
+			prealloc_blocks = 0;
+		else if (xfs_has_allocsize(mp))
 			prealloc_blocks = mp->m_allocsize_blocks;
 		else if (allocfork == XFS_DATA_FORK)
 			prealloc_blocks = xfs_iomap_prealloc_size(ip, allocfork,
@@ -2065,6 +2067,13 @@
 	if (flags & IOMAP_FAULT)
 		return 0;
 
+	/*
+	 * While writing Merkle tree to disk we would not have any other
+	 * delayed allocations
+	 */
+	if (xfs_iflags_test(XFS_I(inode), XFS_VERITY_CONSTRUCTION))
+		return 0;
+
 	/* Nothing to do if we've written the entire delalloc extent */
 	start_byte = iomap_last_written_block(inode, offset, written);
 	end_byte = round_up(offset + length, i_blocksize(inode));
@@ -2109,6 +2118,7 @@
 	bool			shared = false;
 	unsigned int		lockmode = XFS_ILOCK_SHARED;
 	u64			seq;
+	int			iomap_flags;
 
 	ASSERT(!(flags & (IOMAP_WRITE | IOMAP_ZERO)));
 
@@ -2128,8 +2138,20 @@
 	if (error)
 		return error;
 	trace_xfs_iomap_found(ip, offset, length, XFS_DATA_FORK, &imap);
-	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags,
-				 shared ? IOMAP_F_SHARED : 0, seq);
+	iomap_flags = shared ? IOMAP_F_SHARED : 0;
+
+	/*
+	 * We can not use fsverity_active() here. fsverity_active() checks for
+	 * verity info attached to inode. This info is based on data from a
+	 * verity descriptor. But to read verity descriptor we need to go
+	 * through read iomap path (this function). So, when descriptor is read
+	 * we will not set IOMAP_F_BEYOND_EOF and descriptor page will be empty
+	 * (post EOF hole).
+	 */
+	if ((offset >= XFS_FSVERITY_REGION_START) && IS_VERITY(inode))
+		iomap_flags |= IOMAP_F_BEYOND_EOF;
+
+	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, iomap_flags, seq);
 }
 
 const struct iomap_ops xfs_read_iomap_ops = {

-- 
- Andrey

