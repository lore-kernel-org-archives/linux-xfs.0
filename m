Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 503CEC07E99
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 04:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A56E6144A
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 04:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhGIEgC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 00:36:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229597AbhGIEgB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Jul 2021 00:36:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 842956141A;
        Fri,  9 Jul 2021 04:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625805198;
        bh=JoETb+qFklac21gmiO+Lqb/tei8RPr0PpbPzWWMMNfM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SvNcUTYZ+sv8KmyMZLQHaf79yGR4lL0J0MGRyZrTfafBoLs2P/aduZiGJH4eSVeC9
         xisb8VvyDc4dfYOe3v+gtBdjvWPN1neziI2Mo7RQOguu33cZw7024oO6scLkxWLEZb
         pSmE2Fqx6G+c8nR3vpBpbCQytD/TxNvzerziEm/3peOqZ/xtl0A3dWjWGYfvucSrVD
         HplBdW2QEt9zTc8enXryqILml2mCVhLBovOuZHPnhXZoc5VyIwy/A23Ym3pewjzzpj
         U0jPlSrz2SCdr4JI/9bjvYhaiOsoJe2wfBGHhB/9GHCNh+d1KysJEyMIdMnE6rBxIj
         7dxwjddbDa4VA==
Date:   Thu, 8 Jul 2021 21:33:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: convert log flags to an operational state field
Message-ID: <20210709043318.GW11588@locust>
References: <20210630063813.1751007-1-david@fromorbit.com>
 <20210630063813.1751007-5-david@fromorbit.com>
 <YN7LJ8jc4vjojrbs@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YN7LJ8jc4vjojrbs@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 02, 2021 at 09:15:35AM +0100, Christoph Hellwig wrote:
> > @@ -552,6 +552,7 @@ xfs_log_mount(
> >  	xfs_daddr_t	blk_offset,
> 
> >  {
> > +	struct xlog	*log;
> >  	bool		fatal = xfs_sb_version_hascrc(&mp->m_sb);
> >  	int		error = 0;
> >  	int		min_logfsbs;
> > @@ -566,11 +567,12 @@ xfs_log_mount(
> >  		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
> >  	}
> >  
> > -	mp->m_log = xlog_alloc_log(mp, log_target, blk_offset, num_bblks);
> > -	if (IS_ERR(mp->m_log)) {
> > -		error = PTR_ERR(mp->m_log);
> > +	log = xlog_alloc_log(mp, log_target, blk_offset, num_bblks);
> > +	if (IS_ERR(log)) {
> > +		error = PTR_ERR(log);
> >  		goto out;
> >  	}
> > +	mp->m_log = log;
> 
> Additition of the local variable here looks rather unrelated, given
> that the log is only touched twice in relation to the flags.

Same comment as Christoph -- if you wanted to split the variable cutout
into a separate patch, that's fine.  Don't really care that much though.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
