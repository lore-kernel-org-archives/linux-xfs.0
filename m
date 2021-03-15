Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21439C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 19:07:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE6C264F4B
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 19:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbhCOTGd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Mar 2021 15:06:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232913AbhCOTGM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 Mar 2021 15:06:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A1CC64E41;
        Mon, 15 Mar 2021 19:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615835172;
        bh=nld4sZ/BIJDcO6nzxDftzMYh8wFMOcgo3vXIMOos5hw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SEZ5oVvuvOEPouYR/pzSFrQgyYYw0aJ9/ttOXy1iSCCheqgwaYGjlwzUeshAzLWWo
         pGGk9Sjm8rxne7R7J46gTtp2QxY3CAAKNu56cnlS+Fz+gLJqpqFB7BZGqNOaSK7NDC
         GK9QajwQoCb8GH7q/y0TInCqg7NfxFZtzh69cGoDSswgrH+r7P7vvTJp+HeOQIOKvV
         MUKsAbwltioL2F5gg7w0y1Jo3AbqBENsOLywEvrAQQ861qV/q1qL/NzLrW3DRS/FPx
         Y1GEfcK4W6a6pFskHNHr9x3agbbmG2sS4PPQLoJQcc6Dm2yKaFaX4jk5q8eeKaJ9fP
         6zTGvBaILm+SA==
Date:   Mon, 15 Mar 2021 12:06:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/11] xfs: force inode inactivation and retry fs writes
 when there isn't space
Message-ID: <20210315190611.GF22100@magnolia>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543198495.1947934.14544893595452477454.stgit@magnolia>
 <20210315185453.GE140421@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315185453.GE140421@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 15, 2021 at 06:54:53PM +0000, Christoph Hellwig wrote:
> On Wed, Mar 10, 2021 at 07:06:25PM -0800, Darrick J. Wong wrote:
> > +	error =  xfs_inode_walk(mp, 0, xfs_blockgc_scan_inode, eofb,
> >  			XFS_ICI_BLOCKGC_TAG);
> 
> Nit: strange double whitespace here.

Yeah, that'll go away in the next version.  As part of a new small
series to eliminate the indirect calls in xfs_inode_walk when possible,
I figured out that we could get rid of the flags and tag arguments.

--D
