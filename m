Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5128CC07E9B
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 06:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 351756113C
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 06:33:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234796AbhGTFxP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Jul 2021 01:53:15 -0400
Received: from verein.lst.de ([213.95.11.211]:53895 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235503AbhGTFxM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Jul 2021 01:53:12 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C7DD768AFE; Tue, 20 Jul 2021 08:33:49 +0200 (CEST)
Date:   Tue, 20 Jul 2021 08:33:49 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: remove support for disabling quota accounting
 on a mounted file system
Message-ID: <20210720063349.GA14747@lst.de>
References: <20210712111426.83004-1-hch@lst.de> <20210712111426.83004-2-hch@lst.de> <20210714111049.dxhrtupk46ls4ujb@omega.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714111049.dxhrtupk46ls4ujb@omega.lan>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 01:10:49PM +0200, Carlos Maiolino wrote:
> > -	mutex_unlock(&q->qi_quotaofflock);
> > -	return error;
> > +	/* XXX what to do if error ? Revert back to old vals incore ? */
>
> May be too strict, but I wonder if we shouldn't shut the FS down in case we fail
> here?

This is just the existing code being unindented by one level.  The
usual transaction commit failure cases will cause a shutdown anyway.
