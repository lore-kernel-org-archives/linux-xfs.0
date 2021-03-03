Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83517C433E9
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C17A64F4F
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355039AbhCDASQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:18:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:52690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1580941AbhCCS6m (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Mar 2021 13:58:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAC5864ED7;
        Wed,  3 Mar 2021 18:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614797881;
        bh=s9I7/G70aCB42bxmCy6GD3PxHVVrNdCKFJS7bWsekcc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BiALwEP6qbQv5k2ZBZVJs1kaunhkvm3RbYuZmaVQJ1hjkHuv1Mw/mAyIwehJmUv9c
         tHJ5u1i/jGaFtR7PrlxyN8d3nVCgn9D50rX5KKOnlIOzZyvuVN9mCgmoniMcf9OAig
         Omm+fJ/zamO4Gs/NRNyH5O2H2yjeLTcNwIunTFrCaR7C5tWZsxDaBrz5h0bqI/rOxB
         dmAYTVCuP15Qwmk0ai45L4sVQgpK+SAEmZtKHTJhgNstY0NiGpDFFddaLHKPN0h6QA
         7/stEorCsLwDCDJpgZoBdmMchGazaDcmidmrB1gHM61dgGsQCejm14/A4ROSbYyIc2
         Dx4weEvrs5ZOA==
Date:   Wed, 3 Mar 2021 10:57:59 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, dchinner@redhat.com,
        christian.brauner@ubuntu.com
Subject: Re: [PATCH 2/3] xfs: avoid buffer deadlocks in inumbers/bulkstat
Message-ID: <20210303185759.GU7269@magnolia>
References: <161472409643.3421449.2100229515469727212.stgit@magnolia>
 <161472410813.3421449.1691962515820573818.stgit@magnolia>
 <20210303064556.GC7499@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303064556.GC7499@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 03, 2021 at 07:45:56AM +0100, Christoph Hellwig wrote:
> On Tue, Mar 02, 2021 at 02:28:28PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > When we're servicing an INUMBERS or BULKSTAT request, grab an empty
> > transaction so that we don't hit an ABBA buffer deadlock if the inode
> > btree contains a cycle.
> > 
> > Found by fuzzing an inode btree pointer to introduce a cycle into the
> > tree (xfs/365).
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> So basically you want to piggy back on the per-trans recursion using
> xfs_trans_buf_item_match?

Right.

> Why do we need the sb-counter for that?

I was about to say that we need freeze protection to prevent fsfreeze
and inumbers/bulkstat stalling each other out on the buffer LRU, but
then I remembered that Brian changed freeze to wait for IO to complete
without dumping the buffer cache this cycle.  So, I don't think freeze
protection is necessary anymore.

> Can the comments be a little more clear?

/*
 * Grab an empty transaction so that we can use the recursive locking
 * support to detect tree cycles instead of deadlocking.
 */

How does that sound?

> Why don't we want that elsewhere where we're walking the btrees?

I'm merely playing whackamole with tree walks here.  I would guess that
quotacheck will be next for evaluation.

It also occurs to me that inumbers/bulkstat should probably not be
calling copy_to_user() separately for every single record.

--D
