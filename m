Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E563EC433E6
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 19:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D2EE23108
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 19:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbhASTW7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 14:22:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:42376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404396AbhASTSC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jan 2021 14:18:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A857E20706;
        Tue, 19 Jan 2021 19:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611083840;
        bh=bmzq5km4wUjXHSqtgGo9tvvq65GlOipCeCaKDWiZoxs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OjWxQQOp6zhuAZ8KsW01n2pjnrZwttwG20811K5TNlTHf3JiotogdEH+zB6L4a1R8
         mGTDI41XP5EhU6doWmCXQbFIC4nFPPdWuAUJ/tGg5yW/Pw07zq41K4AOZCUu+IVwPD
         ClbqfcY1FlR8roQFTSn4ctqmv1N6gYV3V1VhRko10TwWuq3aocCfqLHM8FOcz47mKo
         7q3RU5pnHgREW2XRcEY9pZaWNDqJml0RnGWAI1Zit33OAUX2zAjSqjkbw31Gxr+7yG
         uKTAbEiw55fapTQCaMn9fC1MaJ+dU9/JNDxlYtBsHljhm3QIF2OeY1gL01TrkGs5fO
         SvGQNJ/EJUB0g==
Date:   Tue, 19 Jan 2021 11:17:18 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: increase the default parallelism levels of
 pwork clients
Message-ID: <20210119191718.GA3133384@magnolia>
References: <161040739544.1582286.11068012972712089066.stgit@magnolia>
 <161040740189.1582286.17385075679159461086.stgit@magnolia>
 <X/8IfJj+qgnl303O@infradead.org>
 <20210114213259.GF1164246@magnolia>
 <20210114223849.GI1164246@magnolia>
 <20210118173628.GB3134885@infradead.org>
 <20210118195710.GL3134581@magnolia>
 <20210119163711.GA3470705@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210119163711.GA3470705@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 19, 2021 at 04:37:11PM +0000, Christoph Hellwig wrote:
> On Mon, Jan 18, 2021 at 11:57:10AM -0800, Darrick J. Wong wrote:
> > Where should I add a sysfs attributes for per-fs configuration knobs?  I
> > don't really want to add "expected parallelism" to /sys/fs/xfs/*/error
> > because that seems like the wrong place, and /proc/sys/fs/xfs/ is too
> > global for something that could depend on the device.
> 
> Maybe a mount option that can be changed using remount?

Yeah, I'll tack that on the end of the blockgc series as a
CONFIG_XFS_DEBUG=y mount option.

--D
