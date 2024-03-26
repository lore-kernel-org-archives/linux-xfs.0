Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD086128387
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 02:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711421997; cv=none; b=otzbdYJDMdi+VxyomzwtKHlYAnoefBzz8KY81fyxPKnIwngOark0a9j5TOTQom0ULk9jzAh1VrUxLJHyP+4bIhZ2M78212IRiLBppYl+DbVqvP8ArLt/R3tX0J3EHHyvWjtQDzqi0LNIc90EXwE3gsk6LXe1CsdSmy0SoVjbEe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711421997; c=relaxed/simple;
	bh=k5KPaUGpiPI7uCm63nYjmdFq96baJlUHljx/PPw0nZo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mxu7gHPU3F0Sced/KayZ0lSNDcXuNg73IXo7ssHC6tvi+X24r5aYMaoFsoWLhT+SVQVl1qWENG7SMFhuGc7St+WKqHpfr5aWUk3xU64wQjue93OXQggCmICuFb+k7VkR83cBR+o49InePt5M83JRv8iFmWnDc7Cg/TgxyeQqRdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aUKkm/ct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aUKkm/ct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC961C433F1;
	Tue, 26 Mar 2024 02:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711421997;
	bh=k5KPaUGpiPI7uCm63nYjmdFq96baJlUHljx/PPw0nZo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aUKkm/ctBoPO46tQjQFFGGcv6GpT3glrBVBWTvgdl9Lcj1DRjVkKTLg79DE6WOKg3
	 CyLPr0yqdvfwO6kadj8aj3MGDk4v79XdElcg3r3fDz9LyKh3ABjuucPQOSuKUdwDoq
	 Xkfvjj6/aLUfE3QE5Q8HBgR2+ZWuPiutYFaamkWsLLlWEEf7s9GIgjoZ3V4NtFCTkg
	 KjuyMTTVoIGH3MLTZwh9+ZP1NZauxu4wP82JZNKdm3HbM72qLfO5Dp4NC/x554THiR
	 kCwF9Icu1wJc6W61hj5LgHk8KqWwXCVUq0bkZRp7DttfoEIhfGZXjFmxgUUC+pV59q
	 f9mB0Kq9V7x+w==
Date: Mon, 25 Mar 2024 19:59:57 -0700
Subject: [PATCH 02/13] mkfs: fix log sunit rounding when external logs are in
 use
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142126338.2211955.7550877407590481079.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs>
References: <171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs>
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

Due to my heinous nature, I set up an external log device with 4k LBAs
using this command:

# losetup -b 4096 -o 4096 --sizelimit $(( (128 * 1048576) - 4096 )) -f /dev/sdb
# blockdev --getsize64 /dev/loop0
134213632

This creates a log device that is slightly smaller than 128MB in size.
Next I ran generic/054, which sets the log sunit to 256k and fails:

# mkfs.xfs -f /dev/sda -l logdev=/dev/loop0,su=256k,version=2 -s size=4096
meta-data=/dev/sda               isize=512    agcount=4, agsize=72448 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       metadir=0
data     =                       bsize=4096   blocks=289792, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
log      =/dev/loop0             bsize=4096   blocks=32768, version=2
         =                       sectsz=4096  sunit=64 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
         =                       rgcount=0    rgsize=0 blks
Discarding blocks...Done.
Discarding blocks...Done.
mkfs.xfs: libxfs_device_zero write failed: No space left on device

Notice that mkfs thinks it should format a 32768-fsblock external log,
but the log device itself is 32767 fsblocks.  Hence the write goes off
the end of the device and we get ENOSPC.

I tracked this behavior down to align_log_size in mkfs, which first
tries to round the log size up to a stripe boundary, then tries to round
it down.  Unfortunately, in the case of an external log we call the
function with XFS_MAX_LOG_BLOCKS without accounting for the possibility
that the log device might be smaller.

Correct the callsite and clean up the open-coded rounding.

Fixes: 8d1bff2be336 ("mkfs: reduce internal log size when log stripe units are in play")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 mkfs/xfs_mkfs.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index fcbf5413269a..b8e2c0da60c4 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3338,13 +3338,13 @@ _("log size %lld is not a multiple of the log stripe unit %d\n"),
 		usage();
 	}
 
-	tmp_logblocks = ((cfg->logblocks + (sunit - 1)) / sunit) * sunit;
+	tmp_logblocks = roundup_64(cfg->logblocks, sunit);
 
 	/* If the log is too large, round down instead of round up */
 	if ((tmp_logblocks > XFS_MAX_LOG_BLOCKS) ||
 	    ((tmp_logblocks << cfg->blocklog) > XFS_MAX_LOG_BYTES) ||
 	    tmp_logblocks > max_logblocks) {
-		tmp_logblocks = (cfg->logblocks / sunit) * sunit;
+		tmp_logblocks = rounddown_64(cfg->logblocks, sunit);
 	}
 	cfg->logblocks = tmp_logblocks;
 }
@@ -3465,6 +3465,7 @@ static void
 calculate_log_size(
 	struct mkfs_params	*cfg,
 	struct cli_params	*cli,
+	struct libxfs_init	*xi,
 	struct xfs_mount	*mp)
 {
 	struct xfs_sb		*sbp = &mp->m_sb;
@@ -3503,8 +3504,13 @@ _("external log device size %lld blocks too small, must be at least %lld blocks\
 		}
 		cfg->logstart = 0;
 		cfg->logagno = 0;
-		if (cfg->lsunit)
-			align_log_size(cfg, cfg->lsunit, XFS_MAX_LOG_BLOCKS);
+		if (cfg->lsunit) {
+			uint64_t	max_logblocks;
+
+			max_logblocks = min(DTOBT(xi->log.size, cfg->blocklog),
+					    XFS_MAX_LOG_BLOCKS);
+			align_log_size(cfg, cfg->lsunit, max_logblocks);
+		}
 
 		validate_log_size(cfg->logblocks, cfg->blocklog, min_logblocks);
 		return;
@@ -4257,7 +4263,7 @@ main(
 	 * With the mount set up, we can finally calculate the log size
 	 * constraints and do default size calculations and final validation
 	 */
-	calculate_log_size(&cfg, &cli, mp);
+	calculate_log_size(&cfg, &cli, &xi, mp);
 
 	finish_superblock_setup(&cfg, mp, sbp);
 

