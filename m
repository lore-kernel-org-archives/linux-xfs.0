Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32492148827
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529067; cv=none; b=d61OPXyePPgK/j/6sRDg88ogPvTdSILnLmKAlLhGbWMB9peWbhBvYOa42DygBiXM6g5j/dye/m6zPHZnIIJn1CBZLK0tEx5zhoDjjarTgSHdNyrux5DJKxwy4Y0rtay9CFYPXsMyCu25HvBu04xWPGK+UyktwXZu6xJluQ2lTp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529067; c=relaxed/simple;
	bh=Lh0rLripXC3GytttZ2Nl2jIQBS1n42EbaGGWpm3cpK4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XvsqRp3byl7nWj7ji1/uWjpPCvKgEBKeJu56kqVMJH4ZxGmUnaQwC6aZnMRcjKZZzM56YYoBcsFceLfxu52F+kQ2O/QNEDLBUyqmLmWdMG5sxKZcsm3k2Ra3TN0XIVrPRl3s8Dr/QaIJPYACjz9dl7eLuvv3MNrmuDVNlvj1vZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CS3E7fwv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CS3E7fwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C51BC4CED1;
	Fri,  6 Dec 2024 23:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529067;
	bh=Lh0rLripXC3GytttZ2Nl2jIQBS1n42EbaGGWpm3cpK4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CS3E7fwv/sx1CDcbvwZNUFfMZ0gPCmZW32mpPc7IC2UZZSoJBJoY46LGOU0/AdppF
	 2bWAXyzOofTY7BKOSmeOgTjacpom4zAZAR44VJTeQ+BJZK07qZLQnE7DGsBV/1Ibfl
	 5UHvrg5mgsbjI8LljyjXnN4joKmv1GmgnbdexzPdJhB9DB25+jy9yCpaX1/47SQTG0
	 7SzvUcaABW+fxqTXKD56QaDs/ubLeSRR2/5xlMP4pjZpplu/kU9LpX4nsrLBFgaDSe
	 pDYApdmikGohkdrS5uzxaYPBYe4FV7xxmY7MxGtIrhT+deIpqDjoFb+CvfRvfYNZJk
	 18coYWiSs7RZg==
Date: Fri, 06 Dec 2024 15:51:06 -0800
Subject: [PATCH 3/4] mkfs: support copying in xattrs
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352749362.124368.16120119760449034051.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749310.124368.15119896789476594437.stgit@frogsfrogsfrogs>
References: <173352749310.124368.15119896789476594437.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Update the protofile code to import extended attributes from the source
files.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/proto.c |   94 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index 6946c22ff14d2a..7a0493ec71cfd9 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -6,6 +6,8 @@
 
 #include "libxfs.h"
 #include <sys/stat.h>
+#include <sys/xattr.h>
+#include <linux/xattr.h>
 #include "libfrog/convert.h"
 #include "proto.h"
 
@@ -359,6 +361,97 @@ writefile(
 		fail(_("error committing isize transaction"), error);
 }
 
+static void
+writeattr(
+	struct xfs_inode	*ip,
+	const char		*fname,
+	int			fd,
+	const char		*attrname,
+	char			*valuebuf,
+	size_t			valuelen)
+{
+	struct xfs_da_args	args = {
+		.dp		= ip,
+		.geo		= ip->i_mount->m_attr_geo,
+		.owner		= ip->i_ino,
+		.whichfork	= XFS_ATTR_FORK,
+		.op_flags	= XFS_DA_OP_OKNOENT,
+		.value		= valuebuf,
+	};
+	ssize_t			ret;
+	int			error;
+
+	ret = fgetxattr(fd, attrname, valuebuf, valuelen);
+	if (ret < 0) {
+		if (errno == EOPNOTSUPP)
+			return;
+		fail(_("error collecting xattr value"), errno);
+	}
+	if (ret == 0)
+		return;
+
+	if (!strncmp(attrname, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN)) {
+		args.name = (unsigned char *)attrname + XATTR_TRUSTED_PREFIX_LEN;
+		args.attr_filter = LIBXFS_ATTR_ROOT;
+	} else if (!strncmp(attrname, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN)) {
+		args.name = (unsigned char *)attrname + XATTR_SECURITY_PREFIX_LEN;
+		args.attr_filter = LIBXFS_ATTR_SECURE;
+	} else if (!strncmp(attrname, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)) {
+		args.name = (unsigned char *)attrname + XATTR_USER_PREFIX_LEN;
+		args.attr_filter = 0;
+	} else {
+		args.name = (unsigned char *)attrname;
+		args.attr_filter = 0;
+	}
+	args.namelen = strlen((char *)args.name);
+
+	args.valuelen = ret;
+	libxfs_attr_sethash(&args);
+
+	error = -libxfs_attr_set(&args, XFS_ATTRUPDATE_UPSERT, false);
+	if (error)
+		fail(_("setting xattr value"), error);
+}
+
+static void
+writeattrs(
+	struct xfs_inode	*ip,
+	const char		*fname,
+	int			fd)
+{
+	char			*namebuf, *p, *end;
+	char			*valuebuf = NULL;
+	ssize_t			ret;
+
+	namebuf = malloc(XATTR_LIST_MAX);
+	if (!namebuf)
+		fail(_("error allocating xattr name buffer"), errno);
+
+	ret = flistxattr(fd, namebuf, XATTR_LIST_MAX);
+	if (ret < 0) {
+		if (errno == EOPNOTSUPP)
+			goto out_namebuf;
+		fail(_("error collecting xattr names"), errno);
+	}
+
+	p = namebuf;
+	end = namebuf + ret;
+	for (p = namebuf; p < end; p += strlen(p) + 1) {
+		if (!valuebuf) {
+			valuebuf = malloc(ATTR_MAX_VALUELEN);
+			if (!valuebuf)
+				fail(_("error allocating xattr value buffer"),
+						errno);
+		}
+
+		writeattr(ip, fname, fd, p, valuebuf, ATTR_MAX_VALUELEN);
+	}
+
+	free(valuebuf);
+out_namebuf:
+	free(namebuf);
+}
+
 static int
 newregfile(
 	char		**pp,
@@ -833,6 +926,7 @@ parseproto(
 	libxfs_parent_finish(mp, ppargs);
 	if (fmt == IF_REGULAR) {
 		writefile(ip, fname, fd);
+		writeattrs(ip, fname, fd);
 		close(fd);
 	}
 	libxfs_irele(ip);

