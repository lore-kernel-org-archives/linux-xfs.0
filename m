Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 234C0C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 01:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED86C64E09
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 01:49:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhCSBtL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 21:49:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229927AbhCSBs4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Mar 2021 21:48:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0E5B64E09;
        Fri, 19 Mar 2021 01:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616118536;
        bh=p9OP4RdJkDNtcSpaWiTpri4LVl8l/CfK+H1oPq5IKKA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TFyVB3o1Moj66AVNoodeUwUVmz3Q4R4AhYhZSn2ymIU5b3NPhA2Ut32Ed7Yf+5mj+
         I742DpWQ4USEGWioGrrrYhUZZQmPmVZJ+XrP3ZuEx+SVn30JtZ8C1z9MLw1ojTldzP
         JMFAbTa2WJ8WeReFWznPAWvPWeemPk6pGIL0e0VX52TtPh+YoZHIRHhlZGb7ObwQlR
         nWSb1jMLEqEbMBdELV7bPOfEBvvbiP2cLl0vj+cQSmXA+doa2hLbFkivq3kllZ0lEd
         3Ca5QKkW+J7WMHlzckEqUYtmx54UHEyO64mPmvjYMmHbnldy5xuCo70VocZGmYk/dE
         +9zEox2Cuu0xA==
Date:   Thu, 18 Mar 2021 18:48:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/11] xfs: refactor the predicate part of
 xfs_free_eofblocks
Message-ID: <20210319014855.GD1670408@magnolia>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543195167.1947934.16237799936089844524.stgit@magnolia>
 <20210315184615.GB140421@infradead.org>
 <20210318043329.GJ22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318043329.GJ22100@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 17, 2021 at 09:33:29PM -0700, Darrick J. Wong wrote:
> On Mon, Mar 15, 2021 at 06:46:15PM +0000, Christoph Hellwig wrote:
> > Going further through the series actually made me go back to this one,
> > so a few more comments:
> > 
> > >  /*
> > > + * Decide if this inode have post-EOF blocks.  The caller is responsible
> > > + * for knowing / caring about the PREALLOC/APPEND flags.
> > 
> > Please spell out the XFS_DIFLAG_ here, as this really confused me.  In
> > fact even with that it still confuses me, as "caller is responsible"
> > here really means: only call this if you previously called
> > xfs_can_free_eofblocks and it return true.
> 
> Sorry about that; I'll spell them out in the future.
> 
> > Which brings me to the structure of this:  I think without much pain
> > we can ensure xfs_can_free_eofblocks is always called with the iolock,
> > in which case we really should merge xfs_can_free_eofblocks and this
> > new helper to avoid the rather confusing fact that we have two similarly
> > named helper doing similiar but not the same thing.
> 
> I'll have a look into that tomorrow morning. :)

The only change that was necessary was moving the can_free_eofblocks
call in the blockgc code until after we've taken the IOLOCK.

> > >  int
> > > +xfs_has_eofblocks(
> > > +	struct xfs_inode	*ip,
> > > +	bool			*has)
> > 
> > I also think the calling convention can be simplified here.  If an
> > error occurs we obviously do not want to free the eofblocks.  So
> > instead of returning two calues we can just return a single bool.
> 
> Yeah, this area needs some simplification.  Will do.

I moved all the stuff in this function upwards into
xfs_can_free_eofblocks and it seems to work ok.

--D

> 
> --D
