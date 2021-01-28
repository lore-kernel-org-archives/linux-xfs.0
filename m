Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4873EC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A19964E1B
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhA1SC3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 13:02:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:34570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231398AbhA1SBo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 13:01:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15C0A64E0E;
        Thu, 28 Jan 2021 18:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611856863;
        bh=LoBICtX8BvHhdzxGQGa/JtKN2ItDRgRk2nycKA7JOaE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Aet86LuKWOUXBYOYaMjQxpFq/l6hf/fwLiLL1zCqkaIEfBXoT8Wdb22nWJRGQaHt/
         GlP0MLadrXEPQ86up29qnyTICiUtcHiY0WjJB/t3OUtH3qAZqADnVl67zWvVmv/Tzv
         qGDoILM+IFleF92B7NB1Hn3S5pBO7pMsI/PALWTuRupMypKGw3j0tDhkjvdM8XZIgF
         dAJ3RKSGWsxipRcnBpuRrhbXFI+AFHsX262t601KK8NIdx6mzqneHeeXOpHN7X+B9K
         ZOM0iaf9nv7/q+EjXoBzKzxaDcu2slrw/BFlGMfJoHrfkcqlcVvgEveJTSBJenz6gY
         dvhLgUwIRE98Q==
Date:   Thu, 28 Jan 2021 10:01:02 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: Re: [PATCH 06/13] xfs: reserve data and rt quota at the same time
Message-ID: <20210128180102.GT7698@magnolia>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
 <161181369834.1523592.7003018155732921879.stgit@magnolia>
 <20210128094954.GB1973802@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128094954.GB1973802@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 28, 2021 at 09:49:54AM +0000, Christoph Hellwig wrote:
> On Wed, Jan 27, 2021 at 10:01:38PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Modify xfs_trans_reserve_quota_nblks so that we can reserve data and
> > realtime blocks from the dquot at the same time.  This change has the
> > theoretical side effect that for allocations to realtime files we will
> > reserve from the dquot both the number of rtblocks being allocated and
> > the number of bmbt blocks that might be needed to add the mapping.
> > However, since the mount code disables quota if it finds a realtime
> > device, this should not result in any behavior changes.
> > 
> > This also replaces the flags argument with a force? boolean since we
> > don't need to distinguish between data and rt quota reservations any
> > more, and the only other flag being passed in was FORCE_RES.
> 
> It a removes the entirely unused nino flag, which caused quite some
> confusion to me when reading this patch, so please document that.

D'oh, sorry.  I think I accidentally removed a sentence from the second
paragraph somehow. :(

It /should/ read:

"Now that we've moved the inode creation code away from using the _nblks
function, we can repurpose the (now unused) ninos argument for realtime
blocks, so make that change.  This also replaces the flags argument...

> Otherwise this looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
