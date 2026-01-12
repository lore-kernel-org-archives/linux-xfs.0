Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641702701CB
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 14:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229454; cv=none; b=ImHt3YSIK49XvTiI+pGhx+bj4E3zdNyUxZNw2EI5taL8EOB4+Cfokujqgqf5/rOLekWmXcohjWjvSfkASOfAjXpEH2bTWBlAxKp1icdW0DkxRYjzXIbqjolRzTkiAWDZVYBeE8sOS7m5lZWjTVDvOYKPZrhVMe9oN8lZwmC/azk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229454; c=relaxed/simple;
	bh=zUe+u05Ji70egxnDu2vRJL+W32xXvgDxlQ06l0qTwQ0=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g0pd1vBGpiLY/DXdxxX8t38PqHqVvJT5kqt1gfr0PimSqYhjZ/poeTZteMJVPOrsiOkzK2d6mTpAk0oahYi6vD4s7ojg6j+fcS5XNlB6zZ5SBE5VKzX9bp22latb9gZOkcYhlSqGAHfr4ccDYhLILq/XFl8uVdNORqdiGakik7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ip1baVrB; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BVqzt6qd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ip1baVrB";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BVqzt6qd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768229452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZFITs97XcCADGQCmQX9tBpBI7bVy5Dx+q3IqNAqa92M=;
	b=ip1baVrB71ZEa8AekAXmarMC1JAWN88/fi7FbmnUlpt8e2udG3jBUFFFN4JpNRAPxu30tU
	RHTn9Vbg/ASnXR3YVf3MTlA+bCl8efctSs9FL/qSdThT6maB8I1JPN9+T8CFFmaIYXFt5J
	EML1lOL26nof1s9xeTF7zLsdCGx+pZI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-376-WHVvD-SyNuaxobanZJadjA-1; Mon, 12 Jan 2026 09:50:50 -0500
X-MC-Unique: WHVvD-SyNuaxobanZJadjA-1
X-Mimecast-MFC-AGG-ID: WHVvD-SyNuaxobanZJadjA_1768229449
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-64ba13b492aso8032818a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 06:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768229449; x=1768834249; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZFITs97XcCADGQCmQX9tBpBI7bVy5Dx+q3IqNAqa92M=;
        b=BVqzt6qdq1VQwNMv0UHYa++JLtR+bLFVpFpL4s6p5jHjCLqT9kunGqRyRaXpKKrXQl
         /pPSH6KfnWjeF0q4K41NrvxUSw9r9KC8xxH1D5fqBfYMlTJFegWxCvGkC5drQK+C4aav
         y+97nNf5uT7HlrA6yZpEo45t2oV0DF5NtOBeAnB1jVVdK2h8qnlLcgn0U6ft+DNcE33H
         Em92isrRKc+83/KQ4dj8F7QE/FKdpkwyqwQxZBEP76FNO8VqTOAk9KS+/eb7aHZoM3sf
         7/cVSLNfXKOEGbebyKSlqhKEDc0WIwX2kPyCYcT0Vxg/TQ3vG+9hs14XtGl7LwuQkRSv
         HA5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768229449; x=1768834249;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZFITs97XcCADGQCmQX9tBpBI7bVy5Dx+q3IqNAqa92M=;
        b=GW1HCwwctjPnaOXsKezW6LOVYAuJiv76jf5DG7rnLFMeYzJYzXqBSimVlt7DwTijRu
         0SOelOUG5UD6WBQblpq7OP26GDr5eFhaY0wdhPdNB2SiX0aX6iwzLL3hsL1g5zp/eYhn
         2bSPPH/xkCI4kZ/c4F+r2f8egQxoJdpBmr0VMU/c+9jGh8Q88HL+9VAAAgOqhn31p2yY
         pG2XoEJtWE3tGG3r6pMnyTb3qNo+j0bMHANh2Da8jPq0qA0VUes6Irahj/UYXfAJxJY2
         jVWVedCeXk+bzk91ctrz8hun82BlpgA7dHtnjP8xp9972jrU6/Q/y56fJe4GDZLlrb6p
         gh2A==
X-Forwarded-Encrypted: i=1; AJvYcCUBWblUQOHCm+G7R+FEXYQxJ3h+aYI4XPZL3jQZAutSRRwRmSmDMMWbr79Elufso0UVI3ajcT1DVqs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZ8TlPWAN9o7lA9tg9sR6ECb+pS0wwh9knL3rHt/qgHxE/0HZE
	ELzQyg1A0I1MFNhUIBgc0LbaUG/bQvkVQoY3wrh4SsXOmPoEqxx9NKzCkDq46cMB8O3oQlMh6ez
	lVvBbdFpbYBBek8EghKPgCMBC5KLGX+amiODAJ9BUQuaC2Rp2/AViTOyP6fRA
X-Gm-Gg: AY/fxX49EGnMC5xNw1RRzq1AZgI0Sw4D3v4/60QL3gyB0JQzFY45PAeCXKcPzmsXo03
	aeL9k4TKSJdnAWgYRMN5iV+Ss+b3IqpTJeEVeQ5aXhKDjijkiKrXXNd20wPTbOz8HItprYwAGMK
	lGEMzD8RSCXNW67yDPkqpDWdtMeIKePhWR2c94A64ybPHPKQ7RXZGBqJxRQx33FTOANdHVtN2MQ
	yavwXddv6dWuDD+O9jgvmECDC+PRsYHfrk2X9gle2bKLZkht0cJLCiy/jZ2Uj69wUTOZis2wePZ
	zVGSkHl21Ysopqk+1N/um1ZhPWlZeKzOKFEdgLjm3jP1TPDT8Yq7bNBXvhBINEp7sMxcCGzU4Cs
	=
X-Received: by 2002:a05:6402:4492:b0:650:8563:fdbe with SMTP id 4fb4d7f45d1cf-65097e5af32mr15189041a12.23.1768229448751;
        Mon, 12 Jan 2026 06:50:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGFm1BBLk3K8B25WecjEZzInMYPlViDE/uDnc7pMiIiyegJFjXo23wj95dH4bSVilJP1fmQnQ==
X-Received: by 2002:a05:6402:4492:b0:650:8563:fdbe with SMTP id 4fb4d7f45d1cf-65097e5af32mr15189021a12.23.1768229448364;
        Mon, 12 Jan 2026 06:50:48 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507b9d4ed5sm17536558a12.11.2026.01.12.06.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 06:50:47 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 12 Jan 2026 15:50:47 +0100
To: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	aalbersh@redhat.com, djwong@kernel.org
Cc: djwong@kernel.org, david@fromorbit.com, hch@lst.de
Subject: [PATCH v2 8/22] xfs: initialize fs-verity on file open and cleanup
 on inode destruction
Message-ID: <5rckitbnj3eqpeeiaw7u2jfvyk72lfkylg2r7mdtxmlu3qp7dx@t3pn5oelmkxe>
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

fs-verity will read and attach metadata (not the tree itself) from
a disk for those inodes which already have fs-verity enabled.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c  | 8 ++++++++
 fs/xfs/xfs_super.c | 2 ++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 7874cf745a..0c234ab449 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -36,6 +36,7 @@
 #include <linux/mman.h>
 #include <linux/fadvise.h>
 #include <linux/mount.h>
+#include <linux/fsverity.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -1604,11 +1605,18 @@
 	struct inode	*inode,
 	struct file	*file)
 {
+	int		error;
+
 	if (xfs_is_shutdown(XFS_M(inode->i_sb)))
 		return -EIO;
 	file->f_mode |= FMODE_NOWAIT | FMODE_CAN_ODIRECT;
 	if (xfs_get_atomic_write_min(XFS_I(inode)) > 0)
 		file->f_mode |= FMODE_CAN_ATOMIC_WRITE;
+
+	error = fsverity_file_open(inode, file);
+	if (error)
+		return error;
+
 	return generic_file_open(inode, file);
 }
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index bc71aa9dce..10c6fc8d20 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -53,6 +53,7 @@
 #include <linux/magic.h>
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
+#include <linux/fsverity.h>
 
 static const struct super_operations xfs_super_operations;
 
@@ -709,6 +710,7 @@
 	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
 	XFS_STATS_INC(ip->i_mount, vn_rele);
 	XFS_STATS_INC(ip->i_mount, vn_remove);
+	fsverity_cleanup_inode(inode);
 	xfs_inode_mark_reclaimable(ip);
 }
 

-- 
- Andrey

