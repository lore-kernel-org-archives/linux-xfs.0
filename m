Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9712A3BA222
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 03:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773113145; cv=none; b=R695GQF9FPEJJAsMPvBC6a1REgQIYrXqtivCasWgR6u7PYzaGELqQWdPGpuWbWQz0pKdqTjkRhG7rkk1umpbj+Y4aU3dvgnI9wMJ0R0+4lIVtOa8QijTJyrX0czafDTKrnZeXlTnRMiycdulS+WnbWkiU7VWXkwrQ2GGbLRA/uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773113145; c=relaxed/simple;
	bh=3DurqeL/JN5+1PPXkt3k9CNMnzR3ZqczkauS/21dN9o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j7LCepVzGQelblDJjmPkc1j3H2xhbsFzq6xAI388TfyG2zX7qBzihAT1D0Ah5DfVussAEmlSmjnKNuUb5J1u6YsaszFMDHvjLJbCgPYHvEZiRGaxaAMAxlzGFaFbdrEqMxhJAjn8Ns6VRLvjbthrE4w/NV9enhuYq4UdNOv+Is0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=novIcC6B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="novIcC6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1749C2BCAF;
	Tue, 10 Mar 2026 03:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773113144;
	bh=3DurqeL/JN5+1PPXkt3k9CNMnzR3ZqczkauS/21dN9o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=novIcC6BCQ+KHHSIgNXra7gao0KO/Z0BzfgYtypWJ2pjU4iQuDZcdk3/Xj7obkREV
	 eUqhGMmkkv9jLIVypQMXhbSRHFOCsq+OYEFxj56pJnJ8IOlIC+87596G04fSh1H7C0
	 LXRQwevl74v8s94xfTjQD5LLX/vdnQ/T9IWi8PEZ1KUM1/9+KPyGI+xM9UttT7EIKj
	 n1Q260YmWNlFAkzcME8G3dcogrSgMF66vDqC0lVH7ZI83BVeq4JOk89QRSODXhEEyE
	 XOom7U4YyT7BR0xnlQPBiEvpn1OSnpVBihir6VgLPM5QAM+QEdBCir08n7N6N/6cSx
	 B/P2Yv8eeHnZQ==
Date: Mon, 09 Mar 2026 20:25:44 -0700
Subject: [PATCH 4/4] mkfs: fix log sunit automatic configuration
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177311301552.1161719.2460209929845208189.stgit@frogsfrogsfrogs>
In-Reply-To: <177311301461.1161719.5028507121065374411.stgit@frogsfrogsfrogs>
References: <177311301461.1161719.5028507121065374411.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

This patch fixes ~96% failure rates on fstests on my test fleet, some
of which now have 4k LBA disks with unexciting min/opt io geometry:

# lsblk -t /dev/sda
NAME   ALIGNMENT MIN-IO  OPT-IO PHY-SEC LOG-SEC ROTA SCHED RQ-SIZE   RA WSAME
sda            0   4096 1048576    4096     512    1 bfq       256 2048    0B
# mkfs.xfs -f -N /dev/sda3
meta-data=/dev/sda3              isize=512    agcount=4, agsize=2183680 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=1   metadir=0
data     =                       bsize=4096   blocks=8734720, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=4096  sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
         =                       rgcount=0    rgsize=0 extents
         =                       zoned=0      start=0 reserved=0

Note that MIN-IO == PHY-SEC, so dsunit/dswidth are zero.  With this
change, we no longer set the lsunit to the fsblock size if the log
sector size is greater than 512.  Unfortunately, dsunit is also not set,
so mkfs never sets the log sunit and it remains zero.  I think
this causes problems with the log roundoff computation in the kernel:

	if (xfs_has_logv2(mp) && mp->m_sb.sb_logsunit > 1)
		log->l_iclog_roundoff = mp->m_sb.sb_logsunit;
	else
		log->l_iclog_roundoff = BBSIZE;

because now the roundoff factor is less than the log sector size.  After
a while, the filesystem cannot be mounted anymore because:

XFS (sda3): Mounting V5 Filesystem 81b8ffa8-383b-4574-a68c-9b8202707a26
XFS (sda3): Corruption warning: Metadata has LSN (4:2729) ahead of current LSN (4:2727). Please unmount and run xfs_repair (>= v4.3) to resolve.
XFS (sda3): log mount/recovery failed: error -22
XFS (sda3): log mount failed

Reverting this patch makes the problem go away, but I think you're
trying to make it so that mkfs will set lsunit = dsunit if dsunit>0 and
the caller didn't specify any -lsunit= parameter, right?

But there's something that just seems off with this whole function.  If
the user provided a -lsunit/-lsu option then we need to validate the
value and either use it if it makes sense, or complain if not.  If the
user didn't specify any option, then we should figure it out
automatically from the other data device geometry options (internal) or
the external log device probing.

But that's not what this function does.  Why would you do this:

	else if (cfg->lsectorsize > XLOG_HEADER_SIZE)
		lsu = cfg->blocksize; /* lsunit matches filesystem block size */

and then loudly validate that lsu (bytes) is congruent with the fsblock
size?  This is trivially true, but then it disables the "make lsunit use
dsunit if set" logic below:

	} else if (cfg->sb_feat.log_version == 2 &&
		   cfg->loginternal && cfg->dsunit) {
		/* lsunit and dsunit now in fs blocks */
		cfg->lsunit = cfg->dsunit;
	}

AFAICT, the "lsunit matches fs block size" logic is buggy.  This code
was added with no justification as part of a "reworking" commit
2f44b1b0e5adc4 ("mkfs: rework stripe calculations") back in 2017.  I
think the correct logic is to move the "lsunit matches fs block size"
logic to the no-lsunit-option code after the validation code.

This seems to set sb_logsunit to 4096 on my test VM, to 0 on the even
more boring VMs with 512 physical sectors, and to 262144 with the
scsi_debug device that Lukas Herbolt created with:

# modprobe scsi_debug inq_vendor=XFS_TEST physblk_exp=3 sector_size=512 \
opt_xferlen_exp=9 opt_blks=512 dev_size_mb=100 virtual_gb=1000

We also need to adjust the external log lsunit computation code, which
was omitted from the first version of this patch.

Cc: <linux-xfs@vger.kernel.org> # v4.15.0
Fixes: 2f44b1b0e5adc4 ("mkfs: rework stripe calculations")
Fixes: ca1eb448e116da ("mkfs.xfs fix sunit size on 512e and 4kN disks.")
Link: https://lore.kernel.org/linux-xfs/20250926123829.2101207-2-lukas@herbolt.com/
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index ece20905b28313..527a662f3ac858 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3624,10 +3624,8 @@ _("%s: Stripe unit(%d) or stripe width(%d) is not a multiple of the block size(%
 		lsunit = cli->lsunit;
 	else if (cli_opt_set(&lopts, L_SU))
 		lsu = getnum(cli->lsu, &lopts, L_SU);
-	else if (cfg->lsectorsize > XLOG_HEADER_SIZE)
-		lsu = cfg->blocksize; /* lsunit matches filesystem block size */
 
-	if (cli->lsu) {
+	if (lsu) {
 		/* verify if lsu is a multiple block size */
 		if (lsu % cfg->blocksize != 0) {
 			fprintf(stderr,
@@ -3651,14 +3649,22 @@ _("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
 	if (lsunit) {
 		/* convert from 512 byte blocks to fs blocks */
 		cfg->lsunit = DTOBT(lsunit, cfg->blocklog);
-	} else if (cfg->sb_feat.log_version == 2 &&
-		   cfg->loginternal && cfg->dsunit) {
-		/* lsunit and dsunit now in fs blocks */
-		cfg->lsunit = cfg->dsunit;
-	} else if (cfg->sb_feat.log_version == 2 &&
-		   !cfg->loginternal) {
-		/* use the external log device properties */
-		cfg->lsunit = DTOBT(ft->log.sunit, cfg->blocklog);
+	} else if (cfg->sb_feat.log_version == 2 && cfg->loginternal) {
+		if (cfg->dsunit) {
+			/* lsunit and dsunit now in fs blocks */
+			cfg->lsunit = cfg->dsunit;
+		} else if (cfg->lsectorsize > XLOG_HEADER_SIZE) {
+			/* lsunit matches filesystem block size */
+			cfg->lsunit = 1;
+		}
+	} else if (cfg->sb_feat.log_version == 2 && !cfg->loginternal) {
+		if (ft->log.sunit > 0) {
+			/* use the external log device properties */
+			cfg->lsunit = DTOBT(ft->log.sunit, cfg->blocklog);
+		} else if (cfg->lsectorsize > XLOG_HEADER_SIZE) {
+			/* lsunit matches filesystem block size */
+			cfg->lsunit = 1;
+		}
 	}
 
 	if (cfg->sb_feat.log_version == 2 &&

