Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52C3DC433E2
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:16:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29D2861A1E
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:16:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237418AbhCXSQI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:16:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237497AbhCXSP5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 14:15:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9471E61A1B;
        Wed, 24 Mar 2021 18:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616609756;
        bh=Ib6F/3yY76znp6USSjQh21grfAwF1V55wEUSAAW9a50=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dxQrgMEIvUDrcAwQd50QSmjRJVlKRVQ3HtCTxWDwarRhO6YU24SgZe3u/usm0j+Qt
         PjtIHY8jg9sDdN4Ftb/D6oGqdlWWsrBEJYQBWA7SpfEGPMY8wrgLCPtCyJlxiiMB/0
         nVBSVYNAhPJz3AmEKqqhezCxXligQ+sGjpVcC/t6myetBq6dFxDmf5hETxvDw7NPAt
         VDTXhIsvI+ZM+04bP5QhHmzFMcZMQLUwrSe+rmuv/u3Fiiv6SbYUWYRdnnbIXvh6pr
         zFNHi2OSigdTdd54ixsxdQGy5kE9AEmEjKW/QKZ4c4WGoGRg2nIrigniGqIEqFmgMm
         z4S3wAkNTqWZg==
Date:   Wed, 24 Mar 2021 11:15:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 3/3] common/populate: change how we describe cached
 populated images
Message-ID: <20210324181555.GJ1670408@magnolia>
References: <161647318241.3429609.1862044070327396092.stgit@magnolia>
 <161647319905.3429609.14862078528489327236.stgit@magnolia>
 <20210324181157.GC2779737@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324181157.GC2779737@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 06:11:57PM +0000, Christoph Hellwig wrote:
> On Mon, Mar 22, 2021 at 09:19:59PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The device name of a secondary storage device isn't all that important,
> > but the size is.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  common/populate |   14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/common/populate b/common/populate
> > index c01b7e0e..94bf5ce9 100644
> > --- a/common/populate
> > +++ b/common/populate
> > @@ -808,13 +808,23 @@ _fill_fs()
> >  _scratch_populate_cache_tag() {
> >  	local extra_descr=""
> >  	local size="$(blockdev --getsz "${SCRATCH_DEV}")"
> > +	local logdev="none"
> > +	local rtdev="none"
> > +
> > +	if [ "${USE_EXTERNAL}" = "yes" ] && [ -n "${SCRATCH_LOGDEV}" ]; then
> > +		logdev="$(blockdev --getsz "${SCRATCH_LOGDEV}")"
> > +	fi
> > +
> > +	if [ "${USE_EXTERNAL}" = "yes" ] && [ -n "${SCRATCH_RTDEV}" ]; then
> > +		rtdev="$(blockdev --getsz "${SCRATCH_RTDEV}")"
> 
> Shouldn't these variables be called LOGDEV_SIZE and RTDEV_SIZE?

Oops, yeah.

--D
