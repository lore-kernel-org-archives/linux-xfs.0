Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF3D7C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0EAE61A1C
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237514AbhCXS3G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:29:06 -0400
Received: from verein.lst.de ([213.95.11.211]:38250 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237549AbhCXS2v (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 14:28:51 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 77E6F68B05; Wed, 24 Mar 2021 19:28:49 +0100 (CET)
Date:   Wed, 24 Mar 2021 19:28:49 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/18] xfs: don't clear the "dinode core" in
 xfs_inode_alloc
Message-ID: <20210324182849.GA17119@lst.de>
References: <20210324142129.1011766-1-hch@lst.de> <20210324142129.1011766-7-hch@lst.de> <20210324182725.GH22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324182725.GH22100@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 11:27:25AM -0700, Darrick J. Wong wrote:
> On Wed, Mar 24, 2021 at 03:21:17PM +0100, Christoph Hellwig wrote:
> > The xfs_icdinode structure just contains a random mix of inode field,
> > which are all read from the on-disk inode and mostly not looked at
> > before reading the inode or initializing a new inode cluster.  The
> > only exceptions are the forkoff and blocks field, which are used
> > in sanity checks for freshly allocated inodes.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Hmm, does this fix the crash I complained about last time?
> 
> https://lore.kernel.org/linux-xfs/20200702183426.GD7606@magnolia/
> 
> I /think/ it does, but can't tell for sure from the comments. :/

Your crash was due to the uninitialized diflags2, which is fixed very
early on in the series.
