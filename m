Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CDF0C43142
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F04DB64EC4
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355042AbhCDASR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:18:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:55118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233480AbhCCTDL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Mar 2021 14:03:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F6A264ED7;
        Wed,  3 Mar 2021 19:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614798145;
        bh=Pbm0cYjC0RRZUDAfzrg2QmMh09/CHNh/NM2fXSOm58c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WI4araC/2wdG+3huKQS9EpFfSpu4cyEIFAFpTw63u8TKn1QaNecI6XEGqSAwJXgRL
         B8Ime4bG9oWuo1zRHsY+io1sfHwttqkSD9tu/vcgL8BUZ+u1U9Mxxkq4/TA5/Kd5mn
         HTJmLSuJzHMTnGJ4Df+9nRTD1swbdado0lRu+O6YSoRGpjize6O/K+HyAhC9UaGbvT
         mZzPickcycqBdIs5Kax6cc3eyay1l/VkULQNx7otyWThTKU+km4cAO5WOgLWenHdem
         Xsbg44mIoG/ecjOZyj7fl6yjV2gn8llRgsgSCgp38e/8G+soyICLMv/heQkXeXSH5r
         PYMu8xAvSIgsw==
Date:   Wed, 3 Mar 2021 11:02:24 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, dchinner@redhat.com,
        christian.brauner@ubuntu.com
Subject: Re: [PATCH 3/3] xfs: force log and push AIL to clear pinned inodes
 when aborting mount
Message-ID: <20210303190224.GV7269@magnolia>
References: <161472409643.3421449.2100229515469727212.stgit@magnolia>
 <161472411392.3421449.548910053179741704.stgit@magnolia>
 <20210303064812.GD7499@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303064812.GD7499@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 03, 2021 at 07:48:12AM +0100, Christoph Hellwig wrote:
> On Tue, Mar 02, 2021 at 02:28:34PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > If we allocate quota inodes in the process of mounting a filesystem but
> > then decide to abort the mount, it's possible that the quota inodes are
> > sitting around pinned by the log.  Now that inode reclaim relies on the
> > AIL to flush inodes, we have to force the log and push the AIL in
> > between releasing the quota inodes and kicking off reclaim to tear down
> > all the incore inodes.
> > 
> > This was originally found during a fuzz test of metadata directories
> > (xfs/1546), but the actual symptom was that reclaim hung up on the quota
> > inodes.
> 
> This looks ok, but I'm a little worried about sprinkling these log
> forces and AIL pushes around.  We have a similar one but split int
> the regular unmount path, and I wonder if we just need to regularize
> that.

Hmm, the unmount path splits the log force and the ail split while we
wait for free extents to get discarded.  Log replay can free extents, so
at the very least I think we need to do that here too.

--D
