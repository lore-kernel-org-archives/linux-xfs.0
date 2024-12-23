Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481141422AB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991078; cv=none; b=PrQGD07Qv9BU8o8PfYe+Z8jTzohtkYIwGk6E4krKLWxLTDoyU6TOgSeWpnFf6ceCzV96z3jE6N2C9sZerU7wdpHwXqYJpC9NnCG/f3JLZxxdYLzS1oNYHbREJDTQgyzFx+TAZ/5Hwm5dspNLSs+/nRrKUXHNsU0EqvrAOLPO4aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991078; c=relaxed/simple;
	bh=K8855pYoTCEOQJRj81NPifMfru2FuypGPABkLtneq0Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VBbirb+pebz+cGp/TK4TMqE4KlPBmT/MBUlk4/o4GOQs0DAEPWFJQLqlEcY9wFD2R0U7MJ3d6z+vYuQbJxbqL0S1OSHjZL/yLnUi33smE+gpfcKbO5Gt66cVJN6yIXvjuS59xAE8FKWQzjpfqjOYA9ZaZHtnKgGfHphdhJMxpJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rTNGXKow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rTNGXKow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F16AC4CED3;
	Mon, 23 Dec 2024 21:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991078;
	bh=K8855pYoTCEOQJRj81NPifMfru2FuypGPABkLtneq0Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rTNGXKow15J4nNHdLXxGTTegaw7oZoMGPfMtjxaCeHRY9Nj2vxcJZ8Lf3YRmHDk0D
	 kN6Djy+ODLEEusE2mIyfYAWZrt0ghJjCHg40TqadmsSMt32CRnSaqYutn2Fi2KSuc6
	 Xmzrjw7NUqhPNP7lMA5DSYXKYE168YGg9h1pW7gk4m5FNKzYKFMBd222miJ/dPstlD
	 Sragu5NVirjIQOPHmwaERU0lqFHSEoQgsbqoGPLc7DgYEw1mi8lwMjuh0K+gV8QvdG
	 CB9s0ORAjRKZzm0mL8mwp6HQNjNSkYjXhA8Wuc6isdveF8ILt0LkrA+r9Dyyj/VHlI
	 2CMtVlpd0ByyA==
Date: Mon, 23 Dec 2024 13:57:57 -0800
Subject: [PATCH 3/4] mkfs: support copying in xattrs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941974.2295644.15019113821847240813.stgit@frogsfrogsfrogs>
In-Reply-To: <173498941923.2295644.12590815257028938964.stgit@frogsfrogsfrogs>
References: <173498941923.2295644.12590815257028938964.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

