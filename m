Return-Path: <SRS0=XxdV=7D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15AECC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 09:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE70A2072C
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 09:31:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="myogrUYL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbgEUJbl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 05:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728704AbgEUJbl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 05:31:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0EE8C061A0E
        for <linux-xfs@vger.kernel.org>; Thu, 21 May 2020 02:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cIl8ozS2BvwurQ0UFuNd4WZpVDk9EtuClQSJ/a6GFNQ=; b=myogrUYLxSPOayhw0iZDMqsUZ1
        yO0NMDPMk23OIFRWC71wG6snE5lmuWkKtpbxwROfiQ+x6uIjqO1JIrGOX7+mEp1FJe1XsGj4DrIGA
        FyzHEyK5M1WbfEwqkLdsGh5r2sYP4BmQjeKqADhwRP4CezXxZVd7P3KgjwihKy6RPv+nH0ZZ3bqOy
        We/EPXqOUh5ad/6Qxtz0qcxW9xMAfFZMa6/kKNbe4M6rjGb+5PIigaScoIQ8Rm3QRuYiCC4Zh9mIS
        MX+Qr1AqU0XKrN9XK/2MJLr8XDxZbSxJBVpIl7AuR5+NRgsWQNW3ja4gpr7heDxLARqsYEdJaGRxL
        cdbcZN1A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbhYC-0007M2-Ka; Thu, 21 May 2020 09:31:40 +0000
Date:   Thu, 21 May 2020 02:31:40 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Subject: Re: [PATCH 3/3] xfs: measure all contiguous previous extents for
 prealloc size
Message-ID: <20200521093140.GA17015@infradead.org>
References: <158984934500.619853.3585969653869086436.stgit@magnolia>
 <158984936387.619853.12262802837092587871.stgit@magnolia>
 <20200519125437.GA15081@infradead.org>
 <20200520211716.GH17627@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520211716.GH17627@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 20, 2020 at 02:17:16PM -0700, Darrick J. Wong wrote:
> On Tue, May 19, 2020 at 05:54:37AM -0700, Christoph Hellwig wrote:
> > The actual logic looks good, but I think the new helper and another
> > third set of comment explaining what is going on makes this area even
> > more confusing.  What about something like this instead?
> 
> This seems reasonable, but the callsite cleanups ought to be a separate
> patch from the behavior change.

Do you want me to send prep patches, or do you want to split it our
yourself?

> > +	if (eof && offset + count > XFS_ISIZE(ip)) {
> > +		/*
> > +		 * Determine the initial size of the preallocation.
> > + 		 * We clean up any extra preallocation when the file is closed.
> > +		 */
> > +		if (mp->m_flags & XFS_MOUNT_ALLOCSIZE)
> > +			prealloc_blocks = mp->m_allocsize_blocks;
> > +		else
> > +			prealloc_blocks = xfs_iomap_prealloc_size(ip, allocfork,
> > +						offset, count, &icur);
> 
> I'm not sure how much we're really gaining from moving the
> MOUNT_ALLOCSIZE check out to the caller, but I don't feel all that
> passionate about this.

From the pure code stats point of view it doensn't matter.  But from the
software architecture POV it does - now xfs_iomap_prealloc_size contains
the dynamic prealloc size algorithm, while the hard coded case is
handled in the caller.

