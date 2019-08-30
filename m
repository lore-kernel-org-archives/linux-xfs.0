Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1E21C3A59B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 14:49:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77DCF23428
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 14:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfH3Ot0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 10:49:26 -0400
Received: from verein.lst.de ([213.95.11.211]:56170 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727792AbfH3Ot0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Aug 2019 10:49:26 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2C7C968B20; Fri, 30 Aug 2019 16:49:23 +0200 (CEST)
Date:   Fri, 30 Aug 2019 16:49:23 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Murphy Zhou <jencce.kernel@gmail.com>
Subject: Re: [PATCH] xfsprogs: provide a few compatibility typedefs
Message-ID: <20190830144923.GA19710@lst.de>
References: <20190830102227.20932-1-hch@lst.de> <20190830144335.GZ5354@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830144335.GZ5354@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 30, 2019 at 07:43:35AM -0700, Darrick J. Wong wrote:
> On Fri, Aug 30, 2019 at 12:22:27PM +0200, Christoph Hellwig wrote:
> > Add back four typedefs that allow xfsdump to compile against the
> > headers from the latests xfsprogs.
> > 
> > Reported-by: Murphy Zhou <jencce.kernel@gmail.com>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  include/xfs.h | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/include/xfs.h b/include/xfs.h
> > index f2f675df..9ae067dc 100644
> > --- a/include/xfs.h
> > +++ b/include/xfs.h
> > @@ -37,4 +37,13 @@ extern int xfs_assert_largefile[sizeof(off_t)-8];
> >  #include <xfs/xfs_types.h>
> >  #include <xfs/xfs_fs.h>
> >  
> > +/*
> > + * Backards compatibility for users of this header, now that the kernel
> > + * removed these typedefs from xfs_fs.h.
> > + */
> > +typedef struct xfs_bstat xfs_bstat_t;
> > +typedef struct xfs_fsop_bulkreq xfs_fsop_bulkreq_t;
> > +typedef struct xfs_fsop_geom_v1 xfs_fsop
> 
> Missing a semicolon here?

Yes.  And that did blew up when I compiled it and then I fixed it.
Guess I failed to ammend the commit afterwards, sigh..
