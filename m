Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2F6C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D4EB64EC0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347670AbhCDARG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:17:06 -0500
Received: from verein.lst.de ([213.95.11.211]:35372 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355508AbhCCGsz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Mar 2021 01:48:55 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 25E7A68B05; Wed,  3 Mar 2021 07:48:13 +0100 (CET)
Date:   Wed, 3 Mar 2021 07:48:12 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com,
        christian.brauner@ubuntu.com
Subject: Re: [PATCH 3/3] xfs: force log and push AIL to clear pinned inodes
 when aborting mount
Message-ID: <20210303064812.GD7499@lst.de>
References: <161472409643.3421449.2100229515469727212.stgit@magnolia> <161472411392.3421449.548910053179741704.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161472411392.3421449.548910053179741704.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 02, 2021 at 02:28:34PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If we allocate quota inodes in the process of mounting a filesystem but
> then decide to abort the mount, it's possible that the quota inodes are
> sitting around pinned by the log.  Now that inode reclaim relies on the
> AIL to flush inodes, we have to force the log and push the AIL in
> between releasing the quota inodes and kicking off reclaim to tear down
> all the incore inodes.
> 
> This was originally found during a fuzz test of metadata directories
> (xfs/1546), but the actual symptom was that reclaim hung up on the quota
> inodes.

This looks ok, but I'm a little worried about sprinkling these log
forces and AIL pushes around.  We have a similar one but split int
the regular unmount path, and I wonder if we just need to regularize
that.
