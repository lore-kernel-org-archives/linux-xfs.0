Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5674B78C75;
	Tue,  6 Aug 2024 18:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722968532; cv=none; b=kbDX0SZH7OgrsDILfkNBY/atMV2RxH+w7ZI9CTxyRAF2JuMDKG0MatOA19d79cP0H18SoBmDLQ4newjoeN5WEHyDZJaCWIhcXHYa9NPh7R+zAswuAChirs792Ku2yIWq9+MQzEtkCWRNKoRbKxavwBAqSPWaDiwHz1vKmbYk6vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722968532; c=relaxed/simple;
	bh=6B/qLVa2G54qOmaxfiw9R7OdyMcWTqu/IegZeLq/7Ns=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EUAt9ysEkurMiko9VWOskjWTExQUulnOG7tW8q07VehDneXD0YloDpIQ9dw89cVaHubjR9uWuA5Dbg0WcaEl+DXjh0ESQQpxezOCLP5h6MlntCiE6LlATt6DBZJ/EiivYTq0UbMdj+7f+1Jd1TIjU6jj508wInYsy/wAD9ltiJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zthfy+mO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zthfy+mO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA35C32786;
	Tue,  6 Aug 2024 18:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722968531;
	bh=6B/qLVa2G54qOmaxfiw9R7OdyMcWTqu/IegZeLq/7Ns=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Zthfy+mOz8VgV4surXCW7VeCPh9M+F20sVjSOwUy7WhYRqbBKjwD2n0i5haWIZq5y
	 bzXsmH5Hy6WHkfybJLC51rijf4kOEcYqrJjELwK0kwmHuKWJaJJ55nIdsQ6ow4e/Uk
	 qM9kC4BdgC1PgouiE3oWwigdzDN9iHDAzaAW8OzaHjMR+mffGVmXGdpK4AOx+U1Ff6
	 qnu24DqR2hI/OloBhTBWhvI9feM05kVCc6RteGaW1AGYgKHxRoOx954Q/B9BgaPPWz
	 5lCDFnnVwc7bSYnvJ27rLAoOl0hlQUBNf1p12PA3OFStliPFVNTQlr3GTuHPT8905Q
	 fkx6wY9LjTNAQ==
Date: Tue, 06 Aug 2024 11:22:11 -0700
Subject: [PATCH 4/4] mkfs: set autofsck filesystem property
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, dchinner@redhat.com, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <172296825658.3193344.3348247369210100441.stgit@frogsfrogsfrogs>
In-Reply-To: <172296825594.3193344.4163676649578585462.stgit@frogsfrogsfrogs>
References: <172296825594.3193344.4163676649578585462.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a new mkfs option -m autofsck so that sysadmins can control the
background scrubbing behavior of filesystems from the start.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/mkfs.xfs.8.in |    6 ++
 mkfs/lts_4.19.conf     |    1 
 mkfs/lts_5.10.conf     |    1 
 mkfs/lts_5.15.conf     |    1 
 mkfs/lts_5.4.conf      |    1 
 mkfs/lts_6.1.conf      |    1 
 mkfs/lts_6.6.conf      |    1 
 mkfs/xfs_mkfs.c        |  122 ++++++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 133 insertions(+), 1 deletion(-)


diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index d5a0783ac..a854b0e87 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -323,6 +323,12 @@ option set. When the option
 .B \-m crc=0
 is used, the reference count btree feature is not supported and reflink is
 disabled.
+.TP
+.BI autofsck= value
+Set the autofsck filesystem property to this value.
+See the
+.BI xfs_scrub (8)
+manual page for more information on this property.
 .RE
 .PP
 .PD 0
diff --git a/mkfs/lts_4.19.conf b/mkfs/lts_4.19.conf
index 9fa1f9378..4f190bacf 100644
--- a/mkfs/lts_4.19.conf
+++ b/mkfs/lts_4.19.conf
@@ -8,6 +8,7 @@ finobt=1
 inobtcount=0
 reflink=0
 rmapbt=0
+autofsck=0
 
 [inode]
 sparse=1
diff --git a/mkfs/lts_5.10.conf b/mkfs/lts_5.10.conf
index d64bcdf8c..a55fc68e4 100644
--- a/mkfs/lts_5.10.conf
+++ b/mkfs/lts_5.10.conf
@@ -8,6 +8,7 @@ finobt=1
 inobtcount=0
 reflink=1
 rmapbt=0
+autofsck=0
 
 [inode]
 sparse=1
diff --git a/mkfs/lts_5.15.conf b/mkfs/lts_5.15.conf
index 775fd9ab9..daea0b406 100644
--- a/mkfs/lts_5.15.conf
+++ b/mkfs/lts_5.15.conf
@@ -8,6 +8,7 @@ finobt=1
 inobtcount=1
 reflink=1
 rmapbt=0
+autofsck=0
 
 [inode]
 sparse=1
diff --git a/mkfs/lts_5.4.conf b/mkfs/lts_5.4.conf
index 6f43a6c6d..0f807fc35 100644
--- a/mkfs/lts_5.4.conf
+++ b/mkfs/lts_5.4.conf
@@ -8,6 +8,7 @@ finobt=1
 inobtcount=0
 reflink=1
 rmapbt=0
+autofsck=0
 
 [inode]
 sparse=1
diff --git a/mkfs/lts_6.1.conf b/mkfs/lts_6.1.conf
index a78a4f9e3..0ff5bbad5 100644
--- a/mkfs/lts_6.1.conf
+++ b/mkfs/lts_6.1.conf
@@ -8,6 +8,7 @@ finobt=1
 inobtcount=1
 reflink=1
 rmapbt=0
+autofsck=0
 
 [inode]
 sparse=1
diff --git a/mkfs/lts_6.6.conf b/mkfs/lts_6.6.conf
index 91a25bd81..2ef5957e0 100644
--- a/mkfs/lts_6.6.conf
+++ b/mkfs/lts_6.6.conf
@@ -8,6 +8,7 @@ finobt=1
 inobtcount=1
 reflink=1
 rmapbt=1
+autofsck=0
 
 [inode]
 sparse=1
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 394a35771..bbd0dbb6c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -12,6 +12,7 @@
 #include "libfrog/convert.h"
 #include "libfrog/crc32cselftest.h"
 #include "libfrog/dahashselftest.h"
+#include "libfrog/fsproperties.h"
 #include "proto.h"
 #include <ini.h>
 
@@ -148,6 +149,7 @@ enum {
 	M_REFLINK,
 	M_INOBTCNT,
 	M_BIGTIME,
+	M_AUTOFSCK,
 	M_MAX_OPTS,
 };
 
@@ -809,6 +811,7 @@ static struct opt_params mopts = {
 		[M_REFLINK] = "reflink",
 		[M_INOBTCNT] = "inobtcount",
 		[M_BIGTIME] = "bigtime",
+		[M_AUTOFSCK] = "autofsck",
 		[M_MAX_OPTS] = NULL,
 	},
 	.subopt_params = {
@@ -852,6 +855,12 @@ static struct opt_params mopts = {
 		  .maxval = 1,
 		  .defaultval = 1,
 		},
+		{ .index = M_AUTOFSCK,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		},
 	},
 };
 
@@ -917,6 +926,8 @@ struct cli_params {
 	char	*cfgfile;
 	char	*protofile;
 
+	enum fsprop_autofsck autofsck;
+
 	/* parameters that depend on sector/block size being validated. */
 	char	*dsize;
 	char	*agsize;
@@ -1037,7 +1048,7 @@ usage( void )
 /* blocksize */		[-b size=num]\n\
 /* config file */	[-c options=xxx]\n\
 /* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,\n\
-			    inobtcount=0|1,bigtime=0|1]\n\
+			    inobtcount=0|1,bigtime=0|1,autofsck=xxx]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
 			    sectsize=num,concurrency=num]\n\
@@ -1858,6 +1869,20 @@ meta_opts_parser(
 	case M_BIGTIME:
 		cli->sb_feat.bigtime = getnum(value, opts, subopt);
 		break;
+	case M_AUTOFSCK:
+		if (!value || value[0] == 0 || isdigit(value[0])) {
+			long long	ival = getnum(value, opts, subopt);
+
+			if (ival)
+				cli->autofsck = FSPROP_AUTOFSCK_REPAIR;
+			else
+				cli->autofsck = FSPROP_AUTOFSCK_NONE;
+		} else {
+			cli->autofsck = fsprop_autofsck_read(value);
+			if (cli->autofsck == FSPROP_AUTOFSCK_UNSET)
+				illegal(value, "m autofsck");
+		}
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2323,6 +2348,32 @@ _("Directory ftype field always enabled on CRC enabled filesystems\n"));
 			usage();
 		}
 
+		/*
+		 * Self-healing through online fsck relies heavily on back
+		 * reference metadata, so we really want to try to enable rmap
+		 * and parent pointers.
+		 */
+		if (cli->autofsck >= FSPROP_AUTOFSCK_CHECK) {
+			if (!cli->sb_feat.rmapbt) {
+				if (cli_opt_set(&mopts, M_RMAPBT)) {
+					fprintf(stdout,
+_("-m autofsck=%s is less effective without reverse mapping\n"),
+						fsprop_autofsck_write(cli->autofsck));
+				} else {
+					cli->sb_feat.rmapbt = true;
+				}
+			}
+			if (!cli->sb_feat.parent_pointers) {
+				if (cli_opt_set(&nopts, N_PARENT)) {
+					fprintf(stdout,
+_("-m autofsck=%s is less effective without parent pointers\n"),
+						fsprop_autofsck_write(cli->autofsck));
+				} else {
+					cli->sb_feat.parent_pointers = true;
+				}
+			}
+		}
+
 	} else {	/* !crcs_enabled */
 		/*
 		 * The V4 filesystem format is deprecated in the upstream Linux
@@ -2406,6 +2457,14 @@ _("parent pointers not supported without CRC support\n"));
 			usage();
 		}
 		cli->sb_feat.parent_pointers = false;
+
+		if (cli->autofsck != FSPROP_AUTOFSCK_UNSET &&
+		    cli_opt_set(&mopts, M_AUTOFSCK)) {
+			fprintf(stderr,
+_("autofsck not supported without CRC support\n"));
+			usage();
+		}
+		cli->autofsck = FSPROP_AUTOFSCK_UNSET;
 	}
 
 	if (!cli->sb_feat.finobt) {
@@ -4332,6 +4391,63 @@ cfgfile_parse(
 		cli->cfgfile);
 }
 
+static void
+set_autofsck(
+	struct xfs_mount	*mp,
+	struct cli_params	*cli)
+{
+	struct xfs_da_args	args = {
+		.geo		= mp->m_attr_geo,
+		.whichfork	= XFS_ATTR_FORK,
+		.op_flags	= XFS_DA_OP_OKNOENT,
+		.attr_filter	= LIBXFS_ATTR_ROOT,
+		.owner		= mp->m_sb.sb_rootino,
+	};
+	const char		*word;
+	char			*p;
+	int			error;
+
+	error = fsprop_name_to_attr_name(FSPROP_AUTOFSCK_NAME, &p);
+	if (error < 0) {
+		fprintf(stderr,
+ _("%s: error %d while allocating fs property name\n"),
+				progname, error);
+		exit(1);
+	}
+	args.namelen = error;
+	args.name = (const uint8_t *)p;
+
+	word = fsprop_autofsck_write(cli->autofsck);
+	if (!word) {
+		fprintf(stderr,
+ _("%s: not sure what to do with autofsck value %u\n"),
+				progname, cli->autofsck);
+		exit(1);
+	}
+	args.value = (void *)word;
+	args.valuelen = strlen(word);
+
+	error = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &args.dp);
+	if (error) {
+		fprintf(stderr,
+ _("%s: error %d while opening root directory\n"),
+				progname, error);
+		exit(1);
+	}
+
+	libxfs_attr_sethash(&args);
+
+	error = -libxfs_attr_set(&args, XFS_ATTRUPDATE_UPSERT, false);
+	if (error) {
+		fprintf(stderr,
+ _("%s: error %d while setting autofsck property\n"),
+				progname, error);
+		exit(1);
+	}
+
+	libxfs_irele(args.dp);
+}
+
 int
 main(
 	int			argc,
@@ -4361,6 +4477,7 @@ main(
 		.is_supported	= 1,
 		.data_concurrency = -1, /* auto detect non-mechanical storage */
 		.log_concurrency = -1, /* auto detect non-mechanical ddev */
+		.autofsck = FSPROP_AUTOFSCK_UNSET,
 	};
 	struct mkfs_params	cfg = {};
 
@@ -4669,6 +4786,9 @@ main(
 	if (mp->m_sb.sb_agcount > 1)
 		rewrite_secondary_superblocks(mp);
 
+	if (cli.autofsck != FSPROP_AUTOFSCK_UNSET)
+		set_autofsck(mp, &cli);
+
 	/*
 	 * Dump all inodes and buffers before marking us all done.
 	 * Need to drop references to inodes we still hold, first.

