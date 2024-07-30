Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D85D10F9
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300107; cv=none; b=FgeApBwyVJJbbL0dNRsdB/1POC9IpoPmGrsoRIYEi3wLV2Og5kMVkJYIubaghsb7zBZpUZoKoafzXA+e2SK4j4BeYutFwUhv49Z98kQJ1yFNisnO27jmxk91PUOj9rdJ4okkti6NAE20c9UAcAqdZ6ADhUjFDwy8j7GTlIEaUeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300107; c=relaxed/simple;
	bh=jZrNabBXEj0GN2xW9iFutZASU9S8rWDv7rU8ggJGIOk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a3QSZtpr7JRQJuj8+ouiYQt69ngfpqO/FtlZDr5LOExmDwjJ0sxCb/Ge5eHZnHD05Td7mblYrzT4XMM97mt7ORZUVT1BM1jwgLXOK32Z79gsiDolYfeT5vfYathaxdT7yrQNjCY9BdcpdA0HpY/Moewu2ZloFlMm6fhRjOIpjME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LU1C3Vfu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LU1C3Vfu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A17DC32786;
	Tue, 30 Jul 2024 00:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300107;
	bh=jZrNabBXEj0GN2xW9iFutZASU9S8rWDv7rU8ggJGIOk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LU1C3Vfuvlfeuu+/6+cINBkFRaAFDpsrSPKxstEcltiR629FWN5LynZhAh6+dd4lm
	 vbBd2XFo9NNioEPa/HtfoRo3XHFWI1XFqmGd9ZwXMrpNlaTEne/YK2VNjYT4uHhHSf
	 oxSvVUI20MziSfV2My4P35vKpqQTiP8gEW9cdi6WkO9CVTCftPunpgi3aLqzYRICWz
	 VAwsxPuUkFjh5U9+8HHcx+j+9+2cGj8JPd9rsHQB99n1H6HH9EIgkc7ifxXnUSG9tR
	 BYRv5zTlzTV/daHo+v3eHofbVituTUyOnz8V7PD34+n/WV77ew9CRMzeErwklZ8hEP
	 9Pi5Q9ijo4mgw==
Date: Mon, 29 Jul 2024 17:41:46 -0700
Subject: [PATCH 069/115] xfs: pass the attr value to put_listent when possible
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843416.1338752.7158096912746328754.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: 8f4b980ee67fe53a77b70b1fdd8e15f2fe37180c

Pass the attr value to put_listent when we have local xattrs or
shortform xattrs.  This will enable the GETPARENTS ioctl to use
xfs_attr_list as its backend.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr.h    |    5 +++--
 libxfs/xfs_attr_sf.h |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index d0ed7ea58..d12583dd7 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -47,8 +47,9 @@ struct xfs_attrlist_cursor_kern {
 
 
 /* void; state communicated via *context */
-typedef void (*put_listent_func_t)(struct xfs_attr_list_context *, int,
-			      unsigned char *, int, int);
+typedef void (*put_listent_func_t)(struct xfs_attr_list_context *context,
+		int flags, unsigned char *name, int namelen, void *value,
+		int valuelen);
 
 struct xfs_attr_list_context {
 	struct xfs_trans	*tp;
diff --git a/libxfs/xfs_attr_sf.h b/libxfs/xfs_attr_sf.h
index bc4422223..73bdc0e55 100644
--- a/libxfs/xfs_attr_sf.h
+++ b/libxfs/xfs_attr_sf.h
@@ -16,6 +16,7 @@ typedef struct xfs_attr_sf_sort {
 	uint8_t		flags;		/* flags bits (see xfs_attr_leaf.h) */
 	xfs_dahash_t	hash;		/* this entry's hash value */
 	unsigned char	*name;		/* name value, pointer into buffer */
+	void		*value;
 } xfs_attr_sf_sort_t;
 
 #define XFS_ATTR_SF_ENTSIZE_MAX			/* max space for name&value */ \

