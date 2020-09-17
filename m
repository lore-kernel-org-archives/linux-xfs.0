Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7149FC43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 16:08:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1427E22AAA
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 16:08:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qCkZaJPq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgIQQCU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 12:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728125AbgIQQB6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 12:01:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47DB5C06121C;
        Thu, 17 Sep 2020 09:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=t0nM0m+bM0MRfHdfpORsHcwjO5S8B+i5jhUC7fK6/pI=; b=qCkZaJPq8o1w69Twb4di8pYFfj
        8kQaLBPYlWmvDh+6M8Tr0AqZjuuxLWU7vjXixU5N6UWUrcI+HrOTluUOMYAUesdIc4trTVVKI4Mdc
        nZSMU1H2hQjuALDrMTFznZzN9druC5CGTo/9c1AOCRwOkN198JC5rjnekSe39YA5zuKTIBYWE69+j
        tx8himdeDk8w8jlUeC7C4yqzpKTGDzDDT7PwABf78DxvxEDv4OTOCr2zMeivqFtg2oJzPourW3zTx
        UR6ffkvU5IiVdqpKvJTgvqYhRqAl2FvCcSsby6CXhG9jqRItx5YBOKM6H1ZvxTvqBo/V5fW105o4p
        iNfpT45w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIwLm-0004dm-3g; Thu, 17 Sep 2020 16:01:34 +0000
Date:   Thu, 17 Sep 2020 17:01:34 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 05/24] xfs/031: make sure we don't set rtinherit=1 on mkfs
Message-ID: <20200917160134.GA17092@infradead.org>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013420779.2923511.9462939883966946313.stgit@magnolia>
 <20200917075351.GE26262@infradead.org>
 <20200917155747.GZ7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917155747.GZ7955@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 08:57:47AM -0700, Darrick J. Wong wrote:
> On Thu, Sep 17, 2020 at 08:53:51AM +0100, Christoph Hellwig wrote:
> > On Mon, Sep 14, 2020 at 06:43:27PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > mkfs.xfs does not support setting rtinherit on the root directory /and/
> > > pre-populating the filesystem with protofiles, so don't run this test if
> > > rtinherit is in the mkfs options.
> > 
> > That is a bit of a weird limitation.  Any reason we can't fix this in
> > mkfs instead?
> 
> Userspace doesn't implement the rt allocator at all, and the last few
> times I've tried to do any serious surgery in the protofile code, Dave
> grumbled that we should just kill it off instead.

Maybe killing it off is indeed the better option.  And in that case this
patch to disable it for RT devices would be a good start.

> 
> Do people actually /use/ protofile support?  Do they like it?  Or would
> they rather have an option like mke2fs -D, where you point it at a
> directory and it uses ftw to copy-in all the files in that directory
> tree, attributes and all?

I always found the protofile stuff really weird and not actually useful.

mke2fs -D actually does seem useful if you want to generate an xfs
file systems and fill it without having admin privileges.  I think that
is what the mke2fs feature is used for.
