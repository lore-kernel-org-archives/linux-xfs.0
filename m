Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E353B48877F
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 13:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330214; cv=none; b=Rp2n9I7LdgS3cvQVLunwSFic0E/bfhX+u5bPT/0rpF1hbLZP3Bz3vO1kVOXKTVW3uc0ba6RZBb9VLOY3H6XNZKjLdmJkZhO5S6dZ2Wztn8r0auoerK5bcLjtEdfwL8l/kYtn/sa2iQsIof1BTHCxw4I6HYHgyovLoOSU1/TIcaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330214; c=relaxed/simple;
	bh=ugJQTkRaBcXdLBy+03+zfgSSkIS7jWk+KmYRr04dnvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ScL9hNYXSCXsRqa2G5fzuA9OgOMRjY+K5VziTUc8itNXD6q3jsZ+ibMqwBN1w4KqUZpQCPKo8H+1ELj+Cjt6K7wVrmNiRRU7JPLiEBeBXD78mg6G68FvtNj4tCJdhvNA9MyiX0GW3Z8mzbMAp8ipyzU5jH51ueUfrFvAZyG4zzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LZApGqh5; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LZApGqh5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=L4r6me3X+bFa8aS3T12wICnqa+AHWUuyZsRzu2UJ8Oc=; b=LZApGqh55OedacStg/9fxrRX+p
	uJ8Yk64yZCFIHPVf4tC1+AL28s9bhIKzeqIBv3KrIc4mrAz4lJbgGu1BP1b00t36MngH6ZhuATRBQ
	KI6JUYY6pH4MIDaW7SOAk27VqFNiB76NuKHxhgq+aA5VE6tIe+EOM6foTQC0NB++9jsWXtzNT6Jk4
	PObXi4VFGXn9NV3kUyEJNme9OuDt6bSwbtRFXy+Kj0GS3WiXHbDKu5hGeeAyEiBZraZ+J4cCZ7wIM
	X8gOkWN06oLhaWMzhj+sRZ9d9IlRvR6SS/LxRG+akPGc1WAa2a3ZOhXoDgzkp6Fno1QqDy0soFAm3
	h1+xh/wg==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp3wW-00000004WkM-1DUz;
	Wed, 29 Jul 2026 13:03:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 08/16] xfs: split out the handlers for XFS_IOC_FSGROWFS*
Date: Wed, 29 Jul 2026 15:03:07 +0200
Message-ID: <20260729130320.2282183-9-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260729130320.2282183-1-hch@lst.de>
References: <20260729130320.2282183-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Split out helpers for XFS_IOC_FSGROWFS* to keep the stack variables out
of xfs_file_ioctl and to clean up the main ioctl handler flow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 107 ++++++++++++++++++++++++++++-----------------
 1 file changed, 66 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index eeff0678d5bf..0b5ae79e4aaf 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1281,6 +1281,66 @@ xfs_ioc_swapext(
 	return error;
 }
 
+static int
+xfs_ioc_growfs_data(
+	struct file		*file,
+	struct xfs_mount	*mp,
+	void __user		*arg)
+{
+	struct xfs_growfs_data	in;
+	int			error;
+
+	if (copy_from_user(&in, arg, sizeof(in)))
+		return -EFAULT;
+
+	error = mnt_want_write_file(file);
+	if (error)
+		return error;
+	error = xfs_growfs_data(mp, &in);
+	mnt_drop_write_file(file);
+	return error;
+}
+
+static int
+xfs_ioc_growfs_log(
+	struct file		*file,
+	struct xfs_mount	*mp,
+	void  __user		*arg)
+{
+	struct xfs_growfs_log	in;
+	int			error;
+
+	if (copy_from_user(&in, arg, sizeof(in)))
+		return -EFAULT;
+
+	error = mnt_want_write_file(file);
+	if (error)
+		return error;
+	error = xfs_growfs_log(mp, &in);
+	mnt_drop_write_file(file);
+	return error;
+}
+
+static int
+xfs_ioc_growfs_rt(
+	struct file		*file,
+	struct xfs_mount	*mp,
+	void __user		*arg)
+{
+	struct xfs_growfs_rt	in;
+	int			error;
+
+	if (copy_from_user(&in, arg, sizeof(in)))
+		return -EFAULT;
+
+	error = mnt_want_write_file(file);
+	if (error)
+		return error;
+	error = xfs_growfs_rt(mp, &in);
+	mnt_drop_write_file(file);
+	return error;
+}
+
 /*
  * These long-unused ioctls were removed from the official ioctl API in 5.17,
  * but retain these definitions so that we can log warnings about them.
@@ -1390,47 +1450,12 @@ xfs_file_ioctl(
 	case XFS_IOC_GET_RESBLKS:
 		return xfs_ioc_getset_resblocks(filp, cmd, arg);
 
-	case XFS_IOC_FSGROWFSDATA: {
-		struct xfs_growfs_data in;
-
-		if (copy_from_user(&in, arg, sizeof(in)))
-			return -EFAULT;
-
-		error = mnt_want_write_file(filp);
-		if (error)
-			return error;
-		error = xfs_growfs_data(mp, &in);
-		mnt_drop_write_file(filp);
-		return error;
-	}
-
-	case XFS_IOC_FSGROWFSLOG: {
-		struct xfs_growfs_log in;
-
-		if (copy_from_user(&in, arg, sizeof(in)))
-			return -EFAULT;
-
-		error = mnt_want_write_file(filp);
-		if (error)
-			return error;
-		error = xfs_growfs_log(mp, &in);
-		mnt_drop_write_file(filp);
-		return error;
-	}
-
-	case XFS_IOC_FSGROWFSRT: {
-		xfs_growfs_rt_t in;
-
-		if (copy_from_user(&in, arg, sizeof(in)))
-			return -EFAULT;
-
-		error = mnt_want_write_file(filp);
-		if (error)
-			return error;
-		error = xfs_growfs_rt(mp, &in);
-		mnt_drop_write_file(filp);
-		return error;
-	}
+	case XFS_IOC_FSGROWFSDATA:
+		return xfs_ioc_growfs_data(filp, mp, arg);
+	case XFS_IOC_FSGROWFSLOG:
+		return xfs_ioc_growfs_log(filp, mp, arg);
+	case XFS_IOC_FSGROWFSRT:
+		return xfs_ioc_growfs_rt(filp, mp, arg);
 
 	case XFS_IOC_GOINGDOWN: {
 		uint32_t in;
-- 
2.53.0

