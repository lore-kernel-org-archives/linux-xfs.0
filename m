Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E55EC4BA13
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 16:55:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAB572467F
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 16:55:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RimyMKcw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgBZQza (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 11:55:30 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:45286 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727895AbgBZQza (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 11:55:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VkQDPnbPqL9k9TDL64dU9dX41bZnt5P6htBnOOkeSLM=; b=RimyMKcwcKaSAVYBKojqFFq4sE
        17xpKrJNOV8b2VEnWKph4DNR6W/1w1ZPxNArC21BLjFyfjWkbWB6/ZoskHvYdkpZlh6IFOnxxvBW1
        5CDEeWADPqPH6eAkA1e0kjc63Hhiu03SSCh4ZPLLgmTLaQel8cR17FMlvJQNgvHFBNbMGd/h1+uer
        5rXeTeLea4RFJBr/qfYtCMt85CQNYOFNuM6HG42pXEe1OpQCq5G4SkBckHNfwn1zGhJ6xswzXVwuz
        9ogQpU5JpAuKCs6Tk4ym8v2en28qvySpc/Dybbe8U1L37frh+WH/gHYv6kJ80+zRizqgQiQED2id9
        hGgpbU9w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6zy4-0002hW-Jw; Wed, 26 Feb 2020 16:55:28 +0000
Date:   Wed, 26 Feb 2020 08:55:28 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] libfrog: move topology.[ch] to libxfs
Message-ID: <20200226165528.GA5494@infradead.org>
References: <157671084242.190323.8759111252624617622.stgit@magnolia>
 <157671085471.190323.17808121856491080720.stgit@magnolia>
 <60af7775-96f6-7dcb-9310-47b509c8f0f5@sandeen.net>
 <20191219001208.GN7489@magnolia>
 <b48693ed-3c4d-bfc8-c82f-48f871b2dc77@sandeen.net>
 <20200225194010.GU6740@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225194010.GU6740@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 11:40:10AM -0800, Darrick J. Wong wrote:
> On Wed, Dec 18, 2019 at 07:04:32PM -0600, Eric Sandeen wrote:
> > On 12/18/19 6:12 PM, Darrick J. Wong wrote:
> > > On Wed, Dec 18, 2019 at 05:26:44PM -0600, Eric Sandeen wrote:
> > >> On 12/18/19 5:14 PM, Darrick J. Wong wrote:
> > >>> From: Darrick J. Wong <darrick.wong@oracle.com>
> > >>>
> > >>> The functions in libfrog/topology.c rely on internal libxfs symbols and
> > >>> functions, so move this file from libfrog to libxfs.
> > >>
> > >> None of this is used anywhere but mkfs & repair, and it's not really
> > >> part of libxfs per se (i.e. it shares nothing w/ kernel code).
> > >>
> > >> It used to be in libxcmd.  Perhaps it should just be moved back?
> > > 
> > > But the whole point of getting it out of libxcmd was that it had nothing
> > > to do with command processing.
> > 
> > Yeah I almost asked that.  ;)
> >  
> > > I dunno, I kinda wonder if this should just be libxtopo or something.
> > 
> > bleargh, not sure what it gains us to keep creating little internal libraries,
> > either.
> > 
> > I guess I don't really care, tbh.  Doesn't feel right to shove unrelated stuff
> > into libxfs/ though, when its main rationale is to share kernel code.
> 
> OTOH, not having it is now getting in the way of me being able to turn
> XFS_BUF_SET_PRIORITY into a static inline function because the priority
> functions reference libxfs_bcache, which ofc only exists in libxfs.  We
> have gotten away with this because the preprocessor doesn't care, but
> the compiler will.

Feel free to drop the suggestion to turn XFS_BUF_SET_PRIORITY into
an inline function for now.  It is nice to have but not important
enough to block other work.
