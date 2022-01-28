Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3F4DC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Jan 2022 22:18:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245422AbiA1WSO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:18:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiA1WSN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jan 2022 17:18:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F99C061714
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jan 2022 14:18:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD98A61EEB
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jan 2022 22:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37434C340E7;
        Fri, 28 Jan 2022 22:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643408292;
        bh=HmpO6NBzcM2Sz4Im0wdk+smED5PigLJWv75liIkBJdc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ViQRxydkZ+lmQw2K7tDtSfSOpXxw3z45MWtiKT4zjWvi10AcrNbziqSJTqcuhszdL
         q93YLnilLNMWMSjhXUo65fnZRL6COmXmtGWXLvoBPnzEC2JDipgiKJ7KUIu9pNlj8j
         DGpjBzMUysze6OufXk5Tn94ZYYXWfgaRe/z5g9t4LdrUBh/xUpfNqNsmLXtmnvvD48
         lnm8NHpGqVevG/X2Avt1tosO2l6sTz4NVIk6jw2buqvyAaZqCcGMjLa50GPOiJILmq
         S1lNHCmwSRMVQZpQfqf63HlC2hwHwKomWIzndI1Q4nKs0FUI/fXvgEYgHEjs17Q9vv
         I1XfG1PV13PEQ==
Date:   Fri, 28 Jan 2022 14:18:11 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 33/45] libxfs: replace xfs_sb_version checks with feature
 flag checks
Message-ID: <20220128221811.GJ13540@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
 <164263802468.860211.15737349840605006073.stgit@magnolia>
 <c874146d-00fb-e443-e4f8-0a7327e0917a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c874146d-00fb-e443-e4f8-0a7327e0917a@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 28, 2022 at 04:13:24PM -0600, Eric Sandeen wrote:
> On 1/19/22 6:20 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Convert the xfs_sb_version_hasfoo() to checks against mp->m_features.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >   libxfs/init.c |    6 +++---
> >   1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/libxfs/init.c b/libxfs/init.c
> > index adee90d5..8fe2f963 100644
> > --- a/libxfs/init.c
> > +++ b/libxfs/init.c
> > @@ -432,17 +432,17 @@ rtmount_init(
> >   	xfs_daddr_t	d;	/* address of last block of subvolume */
> >   	int		error;
> > -	if (mp->m_sb.sb_rblocks == 0)
> > +	if (!xfs_has_realtime(mp))
> 
> This seems a little gratuitous, I think after this we still have several
> checks of mp->m_sb.sb_rblocks [!=]= 0 elsewhere ... since this isn't a
> conversion of sb_version, I'd like to be pedantic and drop this hunk,

<shrug> we only set XFS_FEAT_REALTIME (aka the bit behind
xfs_has_realtime) if the primary super has sb_rblocks > 0, so as far as
I'm concerned they're the same thing.

> and consider an intentional change to switch sb_rblocks checks to
> xfs_has_realtime(mp) across all the tools?

But it might be clearer to do that as a separate conversion of all the
things.  I'll leave that decision up to you. :)

--D

> 
> Otherwise,
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> >   		return 0;
> > -	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> > +	if (xfs_has_reflink(mp)) {
> >   		fprintf(stderr,
> >   	_("%s: Reflink not compatible with realtime device. Please try a newer xfsprogs.\n"),
> >   				progname);
> >   		return -1;
> >   	}
> > -	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> > +	if (xfs_has_rmapbt(mp)) {
> >   		fprintf(stderr,
> >   	_("%s: Reverse mapping btree not compatible with realtime device. Please try a newer xfsprogs.\n"),
> >   				progname);
> > 
