Return-Path: <SRS0=OEwr=77=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99364C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 13:56:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DDB8206C3
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 13:56:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jTJkvgIO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgFRN4m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Jun 2020 09:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgFRN4m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jun 2020 09:56:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52481C06174E;
        Thu, 18 Jun 2020 06:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=m7789sLCyjbHjOAuLr012wW0yNomx7QoVtM2ofWyOX0=; b=jTJkvgIORv1ov8++MY6At1I8xl
        n6QHj230U1RbaQrLrT8mxtyaxFmAaI9vSqBaiJDkU2rB5wUehFHWEPuFnNcohi+Ua7qRL5ubbw4Cz
        fgys0Syn5plsSo58iEKLTSrKygOHqvHlfy4GjVVyKP0mTbWoojnOJKENvgvtnq3UyiHINCRP9Hzfd
        BWt1RuRnRMnrxTKQ4eiYb5EhMMBdEA74FoNDAgV/nxy6cuOoI9nkcwQsun+lWQrz30ut87x1dNEhg
        v50o94/McQrWsRYcU/AxYFZLBpG/6dg1tvF5ZfyEHRd9V1B/enRNzOYR6VaZWgFuYx4ShX7lNPOwo
        KBzYn6Gw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jlv1z-0004AS-Qx; Thu, 18 Jun 2020 13:56:39 +0000
Date:   Thu, 18 Jun 2020 06:56:39 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Bob Peterson <rpeterso@redhat.com>
Subject: Re: [PATCH] iomap: Make sure iomap_end is called after iomap_begin
Message-ID: <20200618135639.GA15658@infradead.org>
References: <20200615160244.741244-1-agruenba@redhat.com>
 <20200618013901.GR11245@magnolia>
 <20200618123227.GO8681@bombadil.infradead.org>
 <CAHc6FU5x8+54zX5NWEDdsf5HV5qXLnjS1SM+oYmX1yMrh_mDfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHc6FU5x8+54zX5NWEDdsf5HV5qXLnjS1SM+oYmX1yMrh_mDfA@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 18, 2020 at 02:37:37PM +0200, Andreas Gruenbacher wrote:
> On Thu, Jun 18, 2020 at 2:32 PM Matthew Wilcox <willy@infradead.org> wrote:
> > On Wed, Jun 17, 2020 at 06:39:01PM -0700, Darrick J. Wong wrote:
> > > > -   if (WARN_ON(iomap.offset > pos))
> > > > -           return -EIO;
> > > > -   if (WARN_ON(iomap.length == 0))
> > > > -           return -EIO;
> > > > +   if (WARN_ON(iomap.offset > pos) || WARN_ON(iomap.length == 0)) {
> > >
> > > Why combine these WARN_ON?  Before, you could distinguish between your
> > > iomap_begin method returning zero length vs. bad offset.
> >
> > Does it matter?  They're both the same problem -- the filesystem has
> > returned an invalid iomap.  I'd go further and combine the two:
> >
> >         if (WARN_ON(iomap.offset > pos || iomap.length == 0)) {
> >
> > that'll save a few bytes of .text
> 
> That would be fine by me as well. Christoph may have wanted separate
> warnings for a particular reason though.

Yes.  The line number in the WARN_ON will tell you which condition
you if they are separate, which is really useful to diagnose what is
going on.
