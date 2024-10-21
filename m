Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531E11E8824;
	Mon, 21 Oct 2024 10:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506929; cv=none; b=k85SWnkKiF1IHd1Zy6u8jzy/USV/i8nwf6Y2JzKK5HBeJ19PGqIwofRuwITjQOei8TSrV9FJJG+4XDXDmmIn5op+Exslgf8bv8OIRyVqRLMlY0sgylXrF9K/XHn116dYCbNAhQHlV/c6lrTFYxLM6c+NemF5C2kl0fOGK3dEzlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506929; c=relaxed/simple;
	bh=ebN6+nkbGxqn8u8RwGJQqxAYIKoNZC1Vb4w2z5qHQdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YA5khT/gIgPh1O7WTV61eQdQwVesDhHJ+3P13pnSjqn9h0R3zDU6XTyrPDS43ePCMJzN+V9Fs06HLgXoUohv7GdwPTagE9aLZ3G22Phai2K9bekCN04pNzP9wEHzLUvA7tgK1QHMeGkaIQtfo9cKMh18WuFNlVyT1XMSZ6EZdk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lcKeKsTd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lcKeKsTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3D8C4CEC3;
	Mon, 21 Oct 2024 10:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506929;
	bh=ebN6+nkbGxqn8u8RwGJQqxAYIKoNZC1Vb4w2z5qHQdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lcKeKsTdba0rglP5zQNPVInqyjB2UbO185Bt8ng+Eql7eZoIFmK2WJa29J1g6QnW1
	 z1yKcs1+CK704Qnpm3PlfxKG+cV4ef9qZmHEFSx78OpjUt+NbLQTIC79rd/Zb6X0Vu
	 K3wFInI5bvqQn4ufxko3c98Ddn6j+W4YROVlusgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 033/124] xfs: revert commit 44af6c7e59b12
Date: Mon, 21 Oct 2024 12:23:57 +0200
Message-ID: <20241021102258.008523072@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

commit 2a009397eb5ae178670cbd7101e9635cf6412b35 upstream.

[backport: resolve conflicts due to new xattr walk helper]

In my haste to fix what I thought was a performance problem in the attr
scrub code, I neglected to notice that the xfs_attr_get_ilocked also had
the effect of checking that attributes can actually be looked up through
the attr dabtree.  Fix this.

Fixes: 44af6c7e59b12 ("xfs: don't load local xattr values during scrub")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/attr.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -200,14 +200,6 @@ xchk_xattr_listent(
 	}
 
 	/*
-	 * Local xattr values are stored in the attr leaf block, so we don't
-	 * need to retrieve the value from a remote block to detect corruption
-	 * problems.
-	 */
-	if (flags & XFS_ATTR_LOCAL)
-		goto fail_xref;
-
-	/*
 	 * Try to allocate enough memory to extrat the attr value.  If that
 	 * doesn't work, we overload the seen_enough variable to convey
 	 * the error message back to the main scrub function.
@@ -222,6 +214,11 @@ xchk_xattr_listent(
 
 	args.value = ab->value;
 
+	/*
+	 * Get the attr value to ensure that lookup can find this attribute
+	 * through the dabtree indexing and that remote value retrieval also
+	 * works correctly.
+	 */
 	error = xfs_attr_get_ilocked(&args);
 	/* ENODATA means the hash lookup failed and the attr is bad */
 	if (error == -ENODATA)


