Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCB37483;
	Tue, 16 Sep 2025 00:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757982964; cv=none; b=Hbd719ZI266qJZf96LwpZphM4XEBTLyeL4NnSFIsQVOOdxKtQZv70khuIdNKJb0Qq8Qs5wWGMXXTThQFr8fq+ipd71WPbQ2PNnB7SUG3/V3ZnjHIodpeVGHJFHO48vQXl7PEkvUFlhg2+IM61H8QDmWeGZp0cCQ+p5cNm94EAfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757982964; c=relaxed/simple;
	bh=e4FNVhT/z5qrAkfUHKFBm7yLQQuAzzB0jJWGfBz2e2M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KidKnhqI1YgTYMZi0diUeQgi98vkkcVYMnlquu5lgCXaKJoQ8FKY3O+AGpeCpcGuw2GnJQNSC1u/nCPFUdXk4NH3VLgGYRQbrn/MD5rMtJn2IRQfHz2fx7M2JE07VLtXUikFsTenva3evBLdyf2Viak393r/yBxcMf+VrLGgGZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gi1dFSJP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gi1dFSJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F7EC4CEF1;
	Tue, 16 Sep 2025 00:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757982963;
	bh=e4FNVhT/z5qrAkfUHKFBm7yLQQuAzzB0jJWGfBz2e2M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gi1dFSJPp0LqBz4TUss5L686kLsr67GJ5+HavQ/VP0JLPKmPSAfhD/GnaXfDPo7I3
	 CCEaHjPWvekvPqXWEpHOhYk0BZA3CC5lvEsgBaKsw1EexFTE/I3VyLaBma9eciPQtp
	 qdvYhs9Djw8pwPb9l0yN6FQfg3aVvOJcHJ3CG62iY1VPIj8aFZJqPYyI4eBs577JBK
	 7VfMWBWXaXeb4g6am7RETg9bRDFgbn+RL2B+4vukce81P7mu9YeGRGlITfY3u+SXEu
	 +5WPtrFTcMZkVKf0nvzfNWxUWHyZXL3bs8zF9TEuHg9RueVu6hWzPHOa35AfpQC8a6
	 IxmZILYTL1Bog==
Date: Mon, 15 Sep 2025 17:36:03 -0700
Subject: [PATCH 3/3] fuse: allow setting of root nodeid
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, miklos@szeredi.hu
Cc: bernd@bsbernd.com, linux-xfs@vger.kernel.org, John@groves.net,
 linux-fsdevel@vger.kernel.org, neal@gompa.dev, joannelkoong@gmail.com
Message-ID: <175798152161.383798.7046497131950486770.stgit@frogsfrogsfrogs>
In-Reply-To: <175798152081.383798.16940546036390782667.stgit@frogsfrogsfrogs>
References: <175798152081.383798.16940546036390782667.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Provide a new mount option so that fuse servers can actually set the
root nodeid.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/fuse/fuse_i.h |    2 ++
 fs/fuse/inode.c  |   11 +++++++++++
 2 files changed, 13 insertions(+)


diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 70942340e33855..fb60686fb9c61a 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -619,6 +619,7 @@ struct fuse_fs_context {
 	int fd;
 	struct file *file;
 	unsigned int rootmode;
+	u64 root_nodeid;
 	kuid_t user_id;
 	kgid_t group_id;
 	bool is_bdev:1;
@@ -633,6 +634,7 @@ struct fuse_fs_context {
 	bool no_force_umount:1;
 	bool legacy_opts_show:1;
 	bool local_fs:1;
+	bool root_nodeid_present:1;
 	enum fuse_dax_mode dax_mode;
 	unsigned int max_read;
 	unsigned int blksize;
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 350805fa61690c..e74d39ac05a570 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -781,6 +781,7 @@ enum {
 	OPT_ALLOW_OTHER,
 	OPT_MAX_READ,
 	OPT_BLKSIZE,
+	OPT_ROOT_NODEID,
 	OPT_ERR
 };
 
@@ -795,6 +796,7 @@ static const struct fs_parameter_spec fuse_fs_parameters[] = {
 	fsparam_u32	("max_read",		OPT_MAX_READ),
 	fsparam_u32	("blksize",		OPT_BLKSIZE),
 	fsparam_string	("subtype",		OPT_SUBTYPE),
+	fsparam_u64	("root_nodeid",		OPT_ROOT_NODEID),
 	{}
 };
 
@@ -890,6 +892,11 @@ static int fuse_parse_param(struct fs_context *fsc, struct fs_parameter *param)
 		ctx->blksize = result.uint_32;
 		break;
 
+	case OPT_ROOT_NODEID:
+		ctx->root_nodeid = result.uint_64;
+		ctx->root_nodeid_present = true;
+		break;
+
 	default:
 		return -EINVAL;
 	}
@@ -925,6 +932,8 @@ static int fuse_show_options(struct seq_file *m, struct dentry *root)
 			seq_printf(m, ",max_read=%u", fc->max_read);
 		if (sb->s_bdev && sb->s_blocksize != FUSE_DEFAULT_BLKSIZE)
 			seq_printf(m, ",blksize=%lu", sb->s_blocksize);
+		if (fc->root_nodeid && fc->root_nodeid != FUSE_ROOT_ID)
+			seq_printf(m, ",root_nodeid=%llu", fc->root_nodeid);
 	}
 #ifdef CONFIG_FUSE_DAX
 	if (fc->dax_mode == FUSE_DAX_ALWAYS)
@@ -1910,6 +1919,8 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
 	sb->s_flags |= SB_POSIXACL;
 
 	fc->default_permissions = ctx->default_permissions;
+	if (ctx->root_nodeid_present)
+		fc->root_nodeid = ctx->root_nodeid;
 	fc->allow_other = ctx->allow_other;
 	fc->user_id = ctx->user_id;
 	fc->group_id = ctx->group_id;

