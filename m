Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F69C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 14:21:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1EE0235FF
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 14:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgLGOVj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 09:21:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbgLGOVj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 09:21:39 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5D6C0613D0
        for <linux-xfs@vger.kernel.org>; Mon,  7 Dec 2020 06:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vmxIhbotHS7BYv8yJKXFofUt0FADRRv9JcQyq/fGgEM=; b=T/3/bSxcWfDRZVHpxepi55s/FB
        mprUzFyc3RN8QiW2FddAPJcg6l6ZzcwOhS4YH5reLsSKSzBIQLyMnCAOFKl2NLG8m1aiMSFNYilsZ
        U/cQM8j5r2g/ujEYoudJtuw7jwOwdhm8W7IX8WOIkqz1Z3aGP+R4ps8PG1EmQQACwBCWXT4ICBxRR
        glu1lOQKyYaP7ZAM/2DilSDJwJE5dlO7/l+ztQ1pizybuVdbZQsktTj3oeZD2QQAFat92huUd3qf5
        DrllGK/SoSfBC7nPq8TmxzVgLHEG0MDA9pKX/6Al16yEHlIdyH315o2P3w7/HYITmbib6sWvSd0vU
        CLiI6fPQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kmHNp-0002it-Cq; Mon, 07 Dec 2020 14:20:57 +0000
Date:   Mon, 7 Dec 2020 14:20:57 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: use reflink to assist unaligned copy_file_range
 calls
Message-ID: <20201207142057.GA9865@infradead.org>
References: <160679383048.447787.12488361211673312070.stgit@magnolia>
 <160679383664.447787.14224539520566294960.stgit@magnolia>
 <20201201100206.GA10262@infradead.org>
 <20201206232154.GK629293@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201206232154.GK629293@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 06, 2020 at 03:21:54PM -0800, Darrick J. Wong wrote:
> On Tue, Dec 01, 2020 at 10:02:06AM +0000, Christoph Hellwig wrote:
> > On Mon, Nov 30, 2020 at 07:37:16PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Add a copy_file_range handler to XFS so that we can accelerate file
> > > copies with reflink when the source and destination ranges are not
> > > block-aligned.  We'll use the generic pagecache copy to handle the
> > > unaligned edges and attempt to reflink the middle.
> > 
> > Isn't this something we could better handle in the VFS (or a generic
> > helper) so that all file systems that support reflink could benefit?
> 
> Maybe.  I don't know if it's universally true that all filesystems
> should fall back to reflinking the middle range and pagecache copying
> the unaligned start/end.
> 
> The other thing is that xfs can easily support reflink on rtextsize > 1,
> but that adds the requirement that we set i_blocksize to a larger value
> than we do now... or find some other way to convey allocation unit size
> to a generic version of the fallback.  OTOH that's pretty easy to do
> from xfs_copy_file_range.

I think you can basically turn xfs_want_reflink_copy_range into a
callback supplied by the fs for the generic helper, and to deal with
the rtextsize problem just return the relevant block size from the
helper.
