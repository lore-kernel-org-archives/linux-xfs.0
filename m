Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FDA2D0625
	for <linux-xfs@vger.kernel.org>; Thu,  9 Oct 2025 12:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760011778; cv=none; b=UqxmlfFV62dRs2Ve7ni3j9tlMd92of8STi+wqSJpwUTDcvzIwesTb2LfJs1uiqSwbScEGSlKmSUqHdatk5f6VGKnHfQAcdMKWAYvyDoLWDTU6Si8Bu0SZ9fSTW8EPIbwvKK4SGNqqMqwV3RPx8GJyZi6nwMP374n0pi11whHctk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760011778; c=relaxed/simple;
	bh=St3rOKjzoHsmbWAGq6MX4q5pR85DjP2gbXB3KAZmWRk=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XPcsrut0rwi8F5VZHcUuKdRw+v991vGpVtxr6JtwfVM9xLtjuRzs0CGlHo2RA/F2npaEihW9HPPUGrl1wljSKGL8kIlAhpQ0A7gptM9QGMYjPVqssYtVFht9UIF1fXltIMfPeENXMn1mc3ynK3hWrG04/HbGtvJA/KMpe+d9P5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FxSpCW1u; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FxSpCW1u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760011775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sIPnxZfn6gg6ieFRcbPSM49AUqVi584k0elJWDeQW1w=;
	b=FxSpCW1uIjDvpD/6Vwst9GyzBRyV9F6TKnu56EnwD6ZnBr9yescBZGaT6jNCzfMRebfb22
	wFi1Xih7VDKOroBBjvrMFQIdl/T3Q4f2IlVJZm+1YY0BA26A3YTA35gPaK8V4lHj8JO33p
	NScvhT+BC9n7qROzuy5Xpq312vuXCNQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-676-9uOLArFAPES3PdvN9UEeHQ-1; Thu, 09 Oct 2025 08:09:34 -0400
X-MC-Unique: 9uOLArFAPES3PdvN9UEeHQ-1
X-Mimecast-MFC-AGG-ID: 9uOLArFAPES3PdvN9UEeHQ_1760011773
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-42557bdbe50so1150438f8f.1
        for <linux-xfs@vger.kernel.org>; Thu, 09 Oct 2025 05:09:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760011771; x=1760616571;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sIPnxZfn6gg6ieFRcbPSM49AUqVi584k0elJWDeQW1w=;
        b=ar4oZr7TmbcYm5BRS4rHE74lZeQBP2tQg2DJ4O6iz0yKt41kUdODCJ3MRHjYtXYSWH
         yqPXBd1pdN5zBAxL/oMUAdVjNqGkLOexBT1SJ5kLE7lxd7kKZkIQJa0DQMcyOiNJOLpr
         RS8CsUbafAEPTKIQKQ6ep/bJoyn4sF6M/CpIBdMrKCTYNbdCalySx4qwM34UV+uttjF7
         15fBqC92pbNDzU6B6JwcSrtrGiYJp4IcdqGrG+6BrR3u+Mg6Pyr5aUGO3SfEShJv2GXN
         icYE5OeriSPOCyoARD2P7Y3OvnVLo3SXBKL4D79ZqCV0le6wbW2wkOtOGg1kTuWjqbUd
         N+xQ==
X-Gm-Message-State: AOJu0YyA4+BamFBRPm+YXqdMDS/8VxCQUDywJFT7O9aUqviKkBe9fLy3
	jwIppMliJS1NlZhsyZlT+B44/0yeL+5i2xSVeMU+VqYeJ9iwTAR36gSDOstbTER32l87TesyK/q
	qysMBnjJIcotr+VzNq9uDkT6xMZAPWeFyJi5pVOjtvK2cOCGxW5Q0QkTSCYhuaAaT54uRb/0om3
	9HLiq/cKilMoW0wy+4ebh+eSOPWV6pYKOlMzDpcSpZDZ4L
X-Gm-Gg: ASbGncvYxrI4e91EaU0wrmhoF8ybXtk4fY0RBuqM27TVT6LXXGob/37yaFmWE+z3FR/
	B9caa9/SqdHl9vJlXGCteFzaWzyatfQxXnWqMb4kn2K5CqvdWBlTLrxEduTC1DnSzvSGp2/t9c8
	xEM0dNBZtpPdkyfnsCOVhjA4AlXFPQqXNW5oruGb2zIxtOFZhcpLAj1rMGOelZ92oWS90A+b63Z
	nHDuv9ydL+t694gRr62BFoRqDZ0JywTO3bVp13F1CYqErHYO1hAvZtuaWSdyRPJswycuPLk4h+D
	bDHRiGIyf9uowHKGexMkePoYJd6zjCbPTUepvOpicp7Kq0WOvLBKTlfWYiqtA8iE
X-Received: by 2002:a05:6000:2483:b0:425:70cb:9ba8 with SMTP id ffacd0b85a97d-42666a9f3aemr4828837f8f.1.1760011771408;
        Thu, 09 Oct 2025 05:09:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFRLesDzBCxBuENQMNve/ItXfsRy5t/WURLgzlEICExhOX4VrUpHYkVd4V0AWMJPtNnRAESwg==
X-Received: by 2002:a05:6000:2483:b0:425:70cb:9ba8 with SMTP id ffacd0b85a97d-42666a9f3aemr4828797f8f.1.1760011770762;
        Thu, 09 Oct 2025 05:09:30 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d869d50sm35509423f8f.0.2025.10.09.05.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 05:09:30 -0700 (PDT)
From: Fedor Pchelkin <aalbersh@redhat.com>
X-Google-Original-From: Fedor Pchelkin <pchelkin@ispras.ru>
Date: Thu, 9 Oct 2025 14:09:29 +0200
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, hch@lst.de, pchelkin@ispras.ru, 
	pranav.tyagi03@gmail.com, sandeen@redhat.com
Subject: [PATCH v2 5/11] xfs: use a proper variable name and type for storing
 a comparison result
Message-ID: <fyqljkspdbi6jujezjddnez4p7vfrzh2k6jpksnglaod632gq7@tgvullnxvlpd>
References: <cover.1760011614.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1760011614.patch-series@thinky>

Source kernel commit: 2717eb35185581988799bb0d5179409978f36a90

Perhaps that's just my silly imagination but 'diff' doesn't look good for
the name of a variable to hold a result of a three-way-comparison
(-1, 0, 1) which is what ->cmp_key_with_cur() does. It implies to contain
an actual difference between the two integer variables but that's not true
anymore after recent refactoring.

Declaring it as int64_t is also misleading now. Plain integer type is
more than enough.

Found by Linux Verification Center (linuxtesting.org).

Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/xfs_btree.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 15846f0ff6..facc35401f 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1982,7 +1982,7 @@
 	int			*stat)	/* success/failure */
 {
 	struct xfs_btree_block	*block;	/* current btree block */
-	int64_t			diff;	/* difference for the current key */
+	int			cmp_r;	/* current key comparison result */
 	int			error;	/* error return value */
 	int			keyno;	/* current key number */
 	int			level;	/* level in the btree */
@@ -2010,13 +2010,13 @@
 	 * on the lookup record, then follow the corresponding block
 	 * pointer down to the next level.
 	 */
-	for (level = cur->bc_nlevels - 1, diff = 1; level >= 0; level--) {
+	for (level = cur->bc_nlevels - 1, cmp_r = 1; level >= 0; level--) {
 		/* Get the block we need to do the lookup on. */
 		error = xfs_btree_lookup_get_block(cur, level, pp, &block);
 		if (error)
 			goto error0;
 
-		if (diff == 0) {
+		if (cmp_r == 0) {
 			/*
 			 * If we already had a key match at a higher level, we
 			 * know we need to use the first entry in this block.
@@ -2062,15 +2062,16 @@
 						keyno, block, &key);
 
 				/*
-				 * Compute difference to get next direction:
+				 * Compute comparison result to get next
+				 * direction:
 				 *  - less than, move right
 				 *  - greater than, move left
 				 *  - equal, we're done
 				 */
-				diff = cur->bc_ops->cmp_key_with_cur(cur, kp);
-				if (diff < 0)
+				cmp_r = cur->bc_ops->cmp_key_with_cur(cur, kp);
+				if (cmp_r < 0)
 					low = keyno + 1;
-				else if (diff > 0)
+				else if (cmp_r > 0)
 					high = keyno - 1;
 				else
 					break;
@@ -2086,7 +2087,7 @@
 			 * If we moved left, need the previous key number,
 			 * unless there isn't one.
 			 */
-			if (diff > 0 && --keyno < 1)
+			if (cmp_r > 0 && --keyno < 1)
 				keyno = 1;
 			pp = xfs_btree_ptr_addr(cur, keyno, block);
 
@@ -2099,7 +2100,7 @@
 	}
 
 	/* Done with the search. See if we need to adjust the results. */
-	if (dir != XFS_LOOKUP_LE && diff < 0) {
+	if (dir != XFS_LOOKUP_LE && cmp_r < 0) {
 		keyno++;
 		/*
 		 * If ge search and we went off the end of the block, but it's
@@ -2122,14 +2123,14 @@
 			*stat = 1;
 			return 0;
 		}
-	} else if (dir == XFS_LOOKUP_LE && diff > 0)
+	} else if (dir == XFS_LOOKUP_LE && cmp_r > 0)
 		keyno--;
 	cur->bc_levels[0].ptr = keyno;
 
 	/* Return if we succeeded or not. */
 	if (keyno == 0 || keyno > xfs_btree_get_numrecs(block))
 		*stat = 0;
-	else if (dir != XFS_LOOKUP_EQ || diff == 0)
+	else if (dir != XFS_LOOKUP_EQ || cmp_r == 0)
 		*stat = 1;
 	else
 		*stat = 0;

-- 
- Andrey

