Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005DD1854
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 03:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722309741; cv=none; b=hviRzO0o/xmylvV7wle86+j6/mb2+oyMJhmE5DpFcYOmgy1UrQ9gaX784aF6cuJRuXVOgz1uJMaJ+Cvv3wUCkxVwlaNsZjyBl6Ox81BLaBFfaHNaadNtTpte3/Mz64NEQVKuBW+Qwis1dZyBgc0M/MSObSJy6l3q2LEhD8VAJJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722309741; c=relaxed/simple;
	bh=FGopIb3FnsVaJqg3ofu4rJLSAbVhOI+o1q/1dzouwoI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UGy5CdogKeB6wDzlm4thEeM5cOQXkxPczkdkitIFOsjeVddqT+rAVtQfgvrsFB2m/CTyowbljtxf8iLaJgIGsOpqYWtBhOKALlyJ+bDNmspe6Yywt9HrV7CHoYFA3o/FaUgfdgBEcF0381RGtDPeujNiCmcN96rFd7Ai23kplmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cH9V1sQm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cH9V1sQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8DBC32786;
	Tue, 30 Jul 2024 03:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722309740;
	bh=FGopIb3FnsVaJqg3ofu4rJLSAbVhOI+o1q/1dzouwoI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cH9V1sQm8jfoxp85QcPOYGTSTl931Q8Gkr4uxO5EAo7bzNP3b3xL88xP7HX/AHafO
	 H1cx+toN7iDdARTKXQP3/sl2mU8eaXKgBgcKBGoYCpRVI6pD0MNAU8NLIumHckuXDZ
	 Vh4AtNtj6WiMh/PlTyB+uwQgtTpxnfbgGUi63FPNGM/l1ntZxD6XCFcKA056tV6o/0
	 zLqcOuuA8jtWYTaOAMyxg+9lQmVab7NW1g+6WB/tECZ+pYWCB9wWoNalWDpHn9y9+A
	 YsdYsdQmL1L9AXlhk19F7GIs8STPWqJPVEX9ew8GfrfOGYEprIcn0qP0juj6D+IwEZ
	 UiCmLTon+tH4w==
Date: Mon, 29 Jul 2024 20:22:19 -0700
Subject: [PATCH 3/3] mkfs: set self_healing property
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172230941034.1544039.10827364192939791397.stgit@frogsfrogsfrogs>
In-Reply-To: <172230940983.1544039.13001736803793260744.stgit@frogsfrogsfrogs>
References: <172230940983.1544039.13001736803793260744.stgit@frogsfrogsfrogs>
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

Add a new mkfs options so that sysadmins can control the background
scrubbing behavior of filesystems from the start.

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
index d5a0783ac5d6..a66fd2a606ed 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -323,6 +323,12 @@ option set. When the option
 .B \-m crc=0
 is used, the reference count btree feature is not supported and reflink is
 disabled.
+.TP
+.BI self_healing= value
+Set the self_healing filesystem property to this value.
+See the
+.BI xfs_scrub (8)
+manual page for more information on this property.
 .RE
 .PP
 .PD 0
diff --git a/mkfs/lts_4.19.conf b/mkfs/lts_4.19.conf
index 9fa1f9378f32..291200a1ff23 100644
--- a/mkfs/lts_4.19.conf
+++ b/mkfs/lts_4.19.conf
@@ -8,6 +8,7 @@ finobt=1
 inobtcount=0
 reflink=0
 rmapbt=0
+self_healing=0
 
 [inode]
 sparse=1
diff --git a/mkfs/lts_5.10.conf b/mkfs/lts_5.10.conf
index d64bcdf8c46b..7c95dcf4c1ce 100644
--- a/mkfs/lts_5.10.conf
+++ b/mkfs/lts_5.10.conf
@@ -8,6 +8,7 @@ finobt=1
 inobtcount=0
 reflink=1
 rmapbt=0
+self_healing=0
 
 [inode]
 sparse=1
diff --git a/mkfs/lts_5.15.conf b/mkfs/lts_5.15.conf
index 775fd9ab91b8..8797078e406a 100644
--- a/mkfs/lts_5.15.conf
+++ b/mkfs/lts_5.15.conf
@@ -8,6 +8,7 @@ finobt=1
 inobtcount=1
 reflink=1
 rmapbt=0
+self_healing=0
 
 [inode]
 sparse=1
diff --git a/mkfs/lts_5.4.conf b/mkfs/lts_5.4.conf
index 6f43a6c6d469..c741b8260d90 100644
--- a/mkfs/lts_5.4.conf
+++ b/mkfs/lts_5.4.conf
@@ -8,6 +8,7 @@ finobt=1
 inobtcount=0
 reflink=1
 rmapbt=0
+self_healing=0
 
 [inode]
 sparse=1
diff --git a/mkfs/lts_6.1.conf b/mkfs/lts_6.1.conf
index a78a4f9e35dc..834facc1d5fb 100644
--- a/mkfs/lts_6.1.conf
+++ b/mkfs/lts_6.1.conf
@@ -8,6 +8,7 @@ finobt=1
 inobtcount=1
 reflink=1
 rmapbt=0
+self_healing=0
 
 [inode]
 sparse=1
diff --git a/mkfs/lts_6.6.conf b/mkfs/lts_6.6.conf
index 91a25bd8121f..10e965942e38 100644
--- a/mkfs/lts_6.6.conf
+++ b/mkfs/lts_6.6.conf
@@ -8,6 +8,7 @@ finobt=1
 inobtcount=1
 reflink=1
 rmapbt=1
+self_healing=0
 
 [inode]
 sparse=1
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 394a35771246..ea4e97725541 100644
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
+	M_SELFHEAL,
 	M_MAX_OPTS,
 };
 
@@ -809,6 +811,7 @@ static struct opt_params mopts = {
 		[M_REFLINK] = "reflink",
 		[M_INOBTCNT] = "inobtcount",
 		[M_BIGTIME] = "bigtime",
+		[M_SELFHEAL] = "self_healing",
 		[M_MAX_OPTS] = NULL,
 	},
 	.subopt_params = {
@@ -852,6 +855,12 @@ static struct opt_params mopts = {
 		  .maxval = 1,
 		  .defaultval = 1,
 		},
+		{ .index = M_SELFHEAL,
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
 
+	enum fsprop_self_healing self_healing;
+
 	/* parameters that depend on sector/block size being validated. */
 	char	*dsize;
 	char	*agsize;
@@ -1037,7 +1048,7 @@ usage( void )
 /* blocksize */		[-b size=num]\n\
 /* config file */	[-c options=xxx]\n\
 /* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,\n\
-			    inobtcount=0|1,bigtime=0|1]\n\
+			    inobtcount=0|1,bigtime=0|1,self_healing=xxx]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
 			    sectsize=num,concurrency=num]\n\
@@ -1858,6 +1869,20 @@ meta_opts_parser(
 	case M_BIGTIME:
 		cli->sb_feat.bigtime = getnum(value, opts, subopt);
 		break;
+	case M_SELFHEAL:
+		if (!value || value[0] == 0 || isdigit(value[0])) {
+			long long	ival = getnum(value, opts, subopt);
+
+			if (ival)
+				cli->self_healing = FSPROP_SELFHEAL_REPAIR;
+			else
+				cli->self_healing = FSPROP_SELFHEAL_NONE;
+		} else {
+			cli->self_healing = fsprop_read_self_healing(value);
+			if (cli->self_healing == FSPROP_SELFHEAL_UNSET)
+				illegal(value, "m self_heal");
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
+		if (cli->self_healing >= FSPROP_SELFHEAL_CHECK) {
+			if (!cli->sb_feat.rmapbt) {
+				if (cli_opt_set(&mopts, M_RMAPBT)) {
+					fprintf(stdout,
+_("self-healing=%s is less effective without reverse mapping\n"),
+						fsprop_write_self_healing(cli->self_healing));
+				} else {
+					cli->sb_feat.rmapbt = true;
+				}
+			}
+			if (!cli->sb_feat.parent_pointers) {
+				if (cli_opt_set(&nopts, N_PARENT)) {
+					fprintf(stdout,
+_("self-healing=%s is less effective without parent pointers\n"),
+						fsprop_write_self_healing(cli->self_healing));
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
+		if (cli->self_healing != FSPROP_SELFHEAL_UNSET &&
+		    cli_opt_set(&mopts, M_SELFHEAL)) {
+			fprintf(stderr,
+_("self-healing not supported without CRC support\n"));
+			usage();
+		}
+		cli->self_healing = FSPROP_SELFHEAL_UNSET;
 	}
 
 	if (!cli->sb_feat.finobt) {
@@ -4332,6 +4391,63 @@ cfgfile_parse(
 		cli->cfgfile);
 }
 
+static void
+set_self_healing(
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
+	error = fsprop_name_to_attr_name(FSPROP_SELF_HEALING_NAME, &p);
+	if (error < 0) {
+		fprintf(stderr,
+ _("%s: error %d while allocating fs property name\n"),
+				progname, error);
+		exit(1);
+	}
+	args.namelen = error;
+	args.name = p;
+
+	word = fsprop_write_self_healing(cli->self_healing);
+	if (!word) {
+		fprintf(stderr,
+ _("%s: not sure what to do with self_healing value %u\n"),
+				progname, cli->self_healing);
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
+ _("%s: error %d while setting self_healing property\n"),
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
+		.self_healing = FSPROP_SELFHEAL_UNSET,
 	};
 	struct mkfs_params	cfg = {};
 
@@ -4669,6 +4786,9 @@ main(
 	if (mp->m_sb.sb_agcount > 1)
 		rewrite_secondary_superblocks(mp);
 
+	if (cli.self_healing != FSPROP_SELFHEAL_UNSET)
+		set_self_healing(mp, &cli);
+
 	/*
 	 * Dump all inodes and buffers before marking us all done.
 	 * Need to drop references to inodes we still hold, first.

