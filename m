Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07814C433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Feb 2022 02:54:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiBZCz2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Feb 2022 21:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiBZCz2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Feb 2022 21:55:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C653338A6
        for <linux-xfs@vger.kernel.org>; Fri, 25 Feb 2022 18:54:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D1E8B81FC1
        for <linux-xfs@vger.kernel.org>; Sat, 26 Feb 2022 02:54:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5698C340E7;
        Sat, 26 Feb 2022 02:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645844090;
        bh=9/0/vkWGPSuvEN+DBEic2MrJzta+5w7E5fx36sbNbJA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I7TiRhUNwhrf+emrzpkdTxvDsnqbPUSIS3dPCHxu2dnGODW+V0YbupUMaCFDnnJT0
         3p6XpjNWOBPM1s1FUB5ifjklWUUV/RqAAfxBboZhK3bgunXHH4k2k3e4SCx7nuhsum
         kVTzZMSvuOSH0sAKVI7WtDIV5+QRmIKYj/AV2oAo1lGPJZNywrEnzqZB5Jt5+xOamy
         mrbq8bnN741evou8VqFPU3R4s3N+o/jORjiOu5FkD8T/RZTIt9QsS136kpuqgd0W+1
         7+qWWwHZebeI/ssnnaFA6vl6Gf7IzoEQZZQXhZYbEvtEEqTBRUX2HuRVdWfIJRSReN
         cXEApDM2PNitA==
Date:   Fri, 25 Feb 2022 18:54:50 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net
Cc:     Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Subject: [PATCH 19/17] mkfs: increase default log size for new (aka bigtime)
 filesystems
Message-ID: <20220226025450.GY8313@magnolia>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164263809453.863810.8908193461297738491.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Recently, the upstream kernel maintainer has been taking a lot of heat on
account of writer threads encountering high latency when asking for log
grant space when the log is small.  The reported use case is a heavily
threaded indexing product logging trace information to a filesystem
ranging in size between 20 and 250GB.  The meetings that result from the
complaints about latency and stall warnings in dmesg both from this use
case and also a large well known cloud product are now consuming 25% of
the maintainer's weekly time and have been for months.

For small filesystems, the log is small by default because we have
defaulted to a ratio of 1:2048 (or even less).  For grown filesystems,
this is even worse, because big filesystems generate big metadata.
However, the log size is still insufficient even if it is formatted at
the larger size.

Therefore, if we're writing a new filesystem format (aka bigtime), bump
the ratio unconditionally from 1:2048 to 1:256.  On a 220GB filesystem,
the 99.95% latencies observed with a 200-writer file synchronous append
workload running on a 44-AG filesystem (with 44 CPUs) spread across 4
hard disks showed:

Log Size (MB)	Latency (ms)	Throughput (MB/s)
10		520		243
20		220		308
40		140		360
80		92		363
160		86		364

For 4 NVME, the results were:

10		201		409
20		177		488
40		122		550
80		120		549
160		121		545

Hence we increase the ratio by 16x because there doesn't seem to be much
improvement beyond that, and we don't want the log to grow /too/ large.
This change does not affect filesystems larger than 4TB, nor does it
affect formatting to older formats.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 96682f9a..7178d798 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3308,7 +3308,17 @@ _("external log device size %lld blocks too small, must be at least %lld blocks\
 
 	/* internal log - if no size specified, calculate automatically */
 	if (!cfg->logblocks) {
-		if (cfg->dblocks < GIGABYTES(1, cfg->blocklog)) {
+		if (cfg->sb_feat.bigtime) {
+			/*
+			 * Starting with bigtime, everybody gets a 256:1 ratio
+			 * of fs size to log size unless they say otherwise.
+			 * Larger logs reduce contention for log grant space,
+			 * which is now a problem with the advent of small
+			 * non-rotational storage devices.
+			 */
+			cfg->logblocks = (cfg->dblocks << cfg->blocklog) / 256;
+			cfg->logblocks = cfg->logblocks >> cfg->blocklog;
+		} else if (cfg->dblocks < GIGABYTES(1, cfg->blocklog)) {
 			/* tiny filesystems get minimum sized logs. */
 			cfg->logblocks = min_logblocks;
 		} else if (cfg->dblocks < GIGABYTES(16, cfg->blocklog)) {
