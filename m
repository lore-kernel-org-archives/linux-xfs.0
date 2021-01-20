Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B62DC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 18:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17BE6233FA
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 18:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbhATSiD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 13:38:03 -0500
Received: from verein.lst.de ([213.95.11.211]:57113 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731611AbhATSgC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Jan 2021 13:36:02 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id DC01C68B05; Wed, 20 Jan 2021 19:35:16 +0100 (CET)
Date:   Wed, 20 Jan 2021 19:35:16 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, avi@scylladb.com
Subject: Re: [PATCH 09/11] iomap: pass a flags argument to iomap_dio_rw
Message-ID: <20210120183516.GA29032@lst.de>
References: <20210118193516.2915706-1-hch@lst.de> <20210118193516.2915706-10-hch@lst.de> <20210120181704.GB3134581@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120181704.GB3134581@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 20, 2021 at 10:17:04AM -0800, Darrick J. Wong wrote:
> > @@ -598,11 +597,11 @@ EXPORT_SYMBOL_GPL(__iomap_dio_rw);
> >  ssize_t
> >  iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> >  		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
> > -		bool wait_for_completion)
> > +		unsigned int flags)
> 
> Can this be named "dio_flags", since it's passed directly into
> __iomap_dio_rw?
> 
> >  struct iomap_dio *__iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> >  		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
> > -		bool wait_for_completion);
> > +		unsigned int flags);
> 
> ...and please make the naming of that last parameter consistent with the
> definitions. :)

Ok.
