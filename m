Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3504DCDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 05:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbjJLFSG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 01:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235420AbjJLFR4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 01:17:56 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057021BE8
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 22:17:16 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 774116732D; Thu, 12 Oct 2023 07:17:13 +0200 (CEST)
Date:   Thu, 12 Oct 2023 07:17:13 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Subject: Re: [PATCH 4/7] xfs: create helpers to convert rt block numbers to
 rt extent numbers
Message-ID: <20231012051713.GC2184@lst.de>
References: <169704721170.1773611.12311239321983752854.stgit@frogsfrogsfrogs> <169704721239.1773611.10087575278257926892.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <169704721239.1773611.10087575278257926892.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2023 at 11:05:27AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create helpers to do unit conversions of rt block numbers to rt extent
> numbers.  There are two variations -- the suffix "t" denotes the one
> that returns only the truncated extent number; the other one also
> returns the misalignment.  Convert all the div_u64_rem users; we'll do
> the do_div users in the next patch.

When trying to work with thee helpers I found the t prefix here a bit
weird, as it works different than the T in say XFS_B_TO_FSB
vs XFS_B_TO_FSBT which give you different results for the two versions.
Here we get the same returned result, just with the additional
return for the remainder.

Maybe have xfs_rtb_to_rtx and xfs_rtb_to_rtx_rem for the version with
the modulo?

We also have quite a few places that only care about the mod,
so an additƣonal xfs_rtb_rem/mod might be useful as well.

