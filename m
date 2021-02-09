Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 589BEC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:16:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1880464EB4
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:16:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhBIEQC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 23:16:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:48554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230326AbhBIENr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Feb 2021 23:13:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E494E64EC5;
        Tue,  9 Feb 2021 04:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612843850;
        bh=p3U1n34LGkCg7mepWUQRZ+MZXo7Vw+SF37k0522MAso=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AoVSAjCsRPg5U8eINz4LUuyrtqBkXnlccj8UHJvzO63vK9Ppexesc7Z1G1WaQ6PJe
         tmdGiTpPqjZh2mTnACek9CrXbxc9/CMe2ZEyUbyllX5Ko9l/o7nZhNKCJanOCFWv1f
         4rzGlcoo/Ydyr8PrlSNyNmdkcqnfD8wSoahNzYJ1GifuUnrTR4l4OmAA/B8FSMwKZF
         39Ou0MXAHt5oWrAnywDGU6IZLbVN2PPrmzE5eYrCLlLDLDz/vFc2sY/kQt3KMUjbN+
         trbR3RD24mILJ1Dm6+pfHv1CxVGf0+12U44kUFFanHV42tX/X9lxfDwUpVNgQTrhhD
         paKPBwkO3rtIQ==
Subject: [PATCH 08/10] xfs_repair: allow setting the needsrepair flag
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Mon, 08 Feb 2021 20:10:49 -0800
Message-ID: <161284384955.3057868.8076509276356847362.stgit@magnolia>
In-Reply-To: <161284380403.3057868.11153586180065627226.stgit@magnolia>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Quietly set up the ability to tell xfs_repair to set NEEDSREPAIR at
program start and (presumably) clear it by the end of the run.  This
code isn't terribly useful to users; it's mainly here so that fstests
can exercise the functionality.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/globals.c    |    2 ++
 repair/globals.h    |    2 ++
 repair/phase1.c     |   23 +++++++++++++++++++++++
 repair/xfs_repair.c |    9 +++++++++
 4 files changed, 36 insertions(+)


diff --git a/repair/globals.c b/repair/globals.c
index 110d98b6..699a96ee 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -49,6 +49,8 @@ int	rt_spec;		/* Realtime dev specified as option */
 int	convert_lazy_count;	/* Convert lazy-count mode on/off */
 int	lazy_count;		/* What to set if to if converting */
 
+bool	add_needsrepair;	/* forcibly set needsrepair while repairing */
+
 /* misc status variables */
 
 int	primary_sb_modified;
diff --git a/repair/globals.h b/repair/globals.h
index 1d397b35..043b3e8e 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -90,6 +90,8 @@ extern int	rt_spec;		/* Realtime dev specified as option */
 extern int	convert_lazy_count;	/* Convert lazy-count mode on/off */
 extern int	lazy_count;		/* What to set if to if converting */
 
+extern bool	add_needsrepair;
+
 /* misc status variables */
 
 extern int		primary_sb_modified;
diff --git a/repair/phase1.c b/repair/phase1.c
index 00b98584..b26d25f8 100644
--- a/repair/phase1.c
+++ b/repair/phase1.c
@@ -30,6 +30,26 @@ alloc_ag_buf(int size)
 	return(bp);
 }
 
+static void
+set_needsrepair(
+	struct xfs_sb	*sb)
+{
+	if (!xfs_sb_version_hascrc(sb)) {
+		printf(
+	_("needsrepair flag only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (xfs_sb_version_needsrepair(sb)) {
+		printf(_("Filesystem already marked as needing repair.\n"));
+		return;
+	}
+
+	printf(_("Marking filesystem in need of repair.\n"));
+	primary_sb_modified = 1;
+	sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+}
+
 /*
  * this has got to be big enough to hold 4 sectors
  */
@@ -126,6 +146,9 @@ _("Cannot disable lazy-counters on V5 fs\n"));
 		}
 	}
 
+	if (add_needsrepair)
+		set_needsrepair(sb);
+
 	/* shared_vn should be zero */
 	if (sb->sb_shared_vn) {
 		do_warn(_("resetting shared_vn to zero\n"));
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 9dc73854..ee377e8a 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -65,11 +65,13 @@ static char *o_opts[] = {
  */
 enum c_opt_nums {
 	CONVERT_LAZY_COUNT = 0,
+	CONVERT_NEEDSREPAIR,
 	C_MAX_OPTS,
 };
 
 static char *c_opts[] = {
 	[CONVERT_LAZY_COUNT]	= "lazycount",
+	[CONVERT_NEEDSREPAIR]	= "needsrepair",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -302,6 +304,13 @@ process_args(int argc, char **argv)
 					lazy_count = (int)strtol(val, NULL, 0);
 					convert_lazy_count = 1;
 					break;
+				case CONVERT_NEEDSREPAIR:
+					if (!val)
+						do_abort(
+		_("-c needsrepair requires a parameter\n"));
+					if (strtol(val, NULL, 0) == 1)
+						add_needsrepair = true;
+					break;
 				default:
 					unknown('c', val);
 					break;

