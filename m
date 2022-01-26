Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68FAEC2BA4C
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Jan 2022 19:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244471AbiAZTim (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Jan 2022 14:38:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40328 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244455AbiAZTim (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jan 2022 14:38:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2654561515;
        Wed, 26 Jan 2022 19:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BAA8C340E3;
        Wed, 26 Jan 2022 19:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643225921;
        bh=PHh5F7RIN5WWwWDIFE4VGOZrLfQ2SgVqgYBWrJIt84U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j/+90q6JW/5g8L1eoapLWVhkIyGwol5/TlqrNBLAvQXmYkS20YtuAX/8wsGmCCJVz
         fZhg2fsMOz4g1xw99h1AsUQ/da73PdKJOYe9Mp+udm2pF3dtGPoxcqi6BnHtAJP8Xy
         ULD3OnJvLDm/s1fFcIV20ywiusL12MNLxH97MeHi2zAyQXNs7Mq5/2rmVdYYLxd6QB
         wnO8nv268hBsvcVyZIyujXOX9+JV2tOGvFf+mYseU1pX0SBrdVfwRaYQiDxOomaSqn
         mNegRHk6WBCciMhi2hQD6kyO22mStGmPabqPlSvV4uehXYz6uHeuazsLLqx1r6WbO8
         sveBbAqpT2s/g==
Date:   Wed, 26 Jan 2022 11:38:40 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: yet another approach to fix loop autoclear for xfstets xfs/049
Message-ID: <20220126193840.GA2761985@magnolia>
References: <20220126155040.1190842-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126155040.1190842-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 26, 2022 at 04:50:32PM +0100, Christoph Hellwig wrote:
> Hi Jens, hi Tetsuo,
> 
> this series uses the approach from Tetsuo to delay the destroy_workueue
> cll, extended by a delayed teardown of the workers to fix a potential
> racewindow then the workqueue can be still round after finishing the
> commands.  It then also removed the queue freeing in release that is
> not needed to fix the dependency chain for that (which can't be
> reported by lockdep) as well.

[add xfs to cc list]

This fixes all the regressions I've been seeing in xfs/049 and xfs/073,
thank you.  I'll give this a spin with the rest of fstests overnight.

--D
