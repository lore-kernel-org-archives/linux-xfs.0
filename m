Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01818C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 20:33:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91D9F23104
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 20:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbhASUdC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 15:33:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:57184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728640AbhASU1R (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jan 2021 15:27:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F82923104;
        Tue, 19 Jan 2021 20:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611087995;
        bh=ITD6CUcTvdkBN1IOqSUac9ZB+htxgKMcj3VO7hD/+jE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vPozWOSrMWXui7+6aAJFzlGCEt0NjcrxAgj1lWcEW1N/B4X9lEZJixD6/fYUbXizR
         VcCCJM3YsZtX/UdepeU3umiE9LQtPkUlbOPPKNeknmWByNRMZCx2jRncVdPwK3bUAM
         OLncFOtvB1ntsB9mwR/diIwH7gphBOHftunqva71c2f7DVMgOidIS0PlwND/vrQHRD
         M9IXzU4mXAbusW6hXbdTg77k0qfvunksQfP6HsvONOEcTMLPt3LSYrzSr7jD9ViFH7
         Y6i8U5M/0EvvMqfpcDKqV/XvHMi4fbkioB607pMGNPnlFDGCHQru9Sb1UePaGVTqMo
         B5bsX405AHitw==
Date:   Tue, 19 Jan 2021 12:26:34 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: create convenience wrappers for incore quota
 block reservations
Message-ID: <20210119202634.GS3134581@magnolia>
References: <161100789347.88678.17195697099723545426.stgit@magnolia>
 <161100791039.88678.6897577495997060048.stgit@magnolia>
 <YAZ/s1a0c7drWZv3@infradead.org>
 <20210119194719.GR3134581@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210119194719.GR3134581@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 19, 2021 at 11:47:19AM -0800, Darrick J. Wong wrote:
> On Tue, Jan 19, 2021 at 07:44:03AM +0100, Christoph Hellwig wrote:
> > > -	error = xfs_trans_reserve_quota_nblks(NULL, ip, (long)alen, 0,
> > > -						XFS_QMOPT_RES_REGBLKS);
> > > +	error = xfs_quota_reserve_blkres(ip, alen, XFS_QMOPT_RES_REGBLKS);
> > 
> > This is the only callsite outside of xfs_quota_unreserve_blkres,
> > so I'm not sure how useful the wrapper is.  Also even on the unreserved
> > side we always pass XFS_QMOPT_RES_REGBLKS except for one case that
> > conditionally passes XFS_QMOPT_RES_RTBLKS.  So if we think these helpers
> > are useful enough I'd at least just pass a bool is_rt argument and hide
> > the flags entirely.
> 
> Seeing as XFS doesn't even let you mount with quota and rt, I elect to
> get rid of the third parameter entirely.  Whoever decides to make them
> work together will have a lot of work to do beyond fixing that one
> unreserve call.

And having said that, I reverse myself, because looking at the rt
reflink patchset I'll have to add that switch to the reserve/unreserve
callers anyway.  I'll change the last arg to 'bool isrt'.

--D

> --D
