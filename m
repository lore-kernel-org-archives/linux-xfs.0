Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99E47C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:41:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DC7E61A23
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:41:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237639AbhCXSlD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:41:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237714AbhCXSkb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 14:40:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5886161A16;
        Wed, 24 Mar 2021 18:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616611231;
        bh=eDQe9M1YiAA3xugs4gB1I5+1V1pPiQuzKpoSZIeu/y0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uOvATLky8m4wtrdf+ML4+pnLTc5/GlZhgD5B8Kvn0QWmWWZ8bGYEr9EV0KIWlBAVr
         GcAiTTWQzcHI14DwZ4khsJeXVQljGLRkeAWFd+7twcituYC11tou5I4tZWS9F3cck/
         10Qg+zKyK0usJ8sN3cF1TEjQfnSpQhm7ttCKKNAs6b2Dw5Yg2ZyHmtToPwZcayaeGO
         IcnzPzrND7d2l1zoGE1lhEj7Hh3IdaZCoxKSCq+4oUW/l0idm94Nypzc8LCiEXPhgv
         5nu7qIxgcRV0ymKhsSefoDxzoZ7HyatVjrX+O1wlvM8z4prl9mj3GlthpLW/nrVPaE
         aX9wXltVLCYdg==
Date:   Wed, 24 Mar 2021 11:40:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/18] xfs: don't clear the "dinode core" in
 xfs_inode_alloc
Message-ID: <20210324184030.GS22100@magnolia>
References: <20210324142129.1011766-1-hch@lst.de>
 <20210324142129.1011766-7-hch@lst.de>
 <20210324182725.GH22100@magnolia>
 <20210324182849.GA17119@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324182849.GA17119@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 07:28:49PM +0100, Christoph Hellwig wrote:
> On Wed, Mar 24, 2021 at 11:27:25AM -0700, Darrick J. Wong wrote:
> > On Wed, Mar 24, 2021 at 03:21:17PM +0100, Christoph Hellwig wrote:
> > > The xfs_icdinode structure just contains a random mix of inode field,
> > > which are all read from the on-disk inode and mostly not looked at
> > > before reading the inode or initializing a new inode cluster.  The
> > > only exceptions are the forkoff and blocks field, which are used
> > > in sanity checks for freshly allocated inodes.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Hmm, does this fix the crash I complained about last time?
> > 
> > https://lore.kernel.org/linux-xfs/20200702183426.GD7606@magnolia/
> > 
> > I /think/ it does, but can't tell for sure from the comments. :/
> 
> Your crash was due to the uninitialized diflags2, which is fixed very
> early on in the series.

Ah, ok.  I thought that might be the proper fix for that.  At the very
least, the repro instructions don't lead to a crash this time, so I'll
toss this series at fstests cloud and see if anything falls out.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

