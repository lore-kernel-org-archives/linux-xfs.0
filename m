Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BABC6C07E96
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jul 2021 18:35:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9519961C53
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jul 2021 18:35:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbhGFSh7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jul 2021 14:37:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231231AbhGFSh7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Jul 2021 14:37:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BE7D61A11;
        Tue,  6 Jul 2021 18:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625596520;
        bh=H6vYrxaCOFR0sN75BJPkaSnXdaCyjzIzXIQMHMLiXyQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Od6/Rl5kLG90IwKhMe3s6hHQhRcy39CFVzctRAY2Fw+bs1rhiF14mSX1wW6+5Lqu/
         5k5bWlupPvva1Owylbptzi8fmKsOocAZTlDAnAfnfijGM7xRaTtcvLCUZ48tGcxd4D
         X9soKO457QPcsNeZsGJ+T1ogVNMS9prybP17ZfysfRvuaGHgKtZO8FhVUNlUH+MKYw
         Nr3hWrpEZ2nDTYFL017jVBk9sEmpNHfQ0qho55E8USZqrSbyRWL9V09blvzW/cfFQ3
         X8zNhvAuhSs8w+GgCkmp0CaRjtZ+JhjjhUUV9YNWr7LERoFG0OrbbjiucNv1Af2cfP
         cJB2+SZtUQxYw==
Date:   Tue, 6 Jul 2021 11:35:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: reset child dir '..' entry when unlinking child
Message-ID: <20210706183519.GE11588@locust>
References: <20210703030233.GD24788@locust>
 <YOLFnx0F8xHBjvda@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOLFnx0F8xHBjvda@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 05, 2021 at 09:41:03AM +0100, Christoph Hellwig wrote:
> On Fri, Jul 02, 2021 at 08:02:33PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > While running xfs/168, I noticed a second source of post-shrink
> > corruption errors causing shutdowns.
> > 
> > Let's say that directory B has a low inode number and is a child of
> > directory A, which has a high number.  If B is empty but open, and
> > unlinked from A, B's dotdot link continues to point to A.  If A is then
> > unlinked and the filesystem shrunk so that A is no longer a valid inode,
> > a subsequent AIL push of B will trip the inode verifiers because the
> > dotdot entry points outside of the filesystem.
> > 
> > To avoid this problem, reset B's dotdot entry to the root directory when
> > unlinking directories, since the root directory cannot be removed.
> 
> Uggh.  This causes extra overhead for every remove.

Not that much overhead.  A child directory can only be unlinked if it's
empty; empty directories by definition contain only a dotdot entry,
which meanns they're in shortform format; and we already have to log the
inode to reflect the i_nlinks change.

> Can't we make
> the verifieds deal with this situation instead of creating extra
> overhead?

I'll address that in the other thread suggesting I "just fix the
verifiers".

> If we can't please at least limit it to file systems that do
> have parent pointers enabled.

Parent pointers haven't been merged yet; this is the '..' entry that
has been stored in every directory since the beginning.

--D
