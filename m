Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07FF0C35DEA
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 01:49:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD95D21D7E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 01:49:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nq6XE/tS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgBYBtu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 20:49:50 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57754 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbgBYBtu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 20:49:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yPstBDWt6d6bgib6lzSxq/HWT4OJnZOw1KjPemQQZhk=; b=nq6XE/tSepneJylkylrJT/pjX0
        Spd9n665DMmObVCAJQLiBcVE27W55R0GvvnwfhobI0nmTEDz86mNpQ7jYVEvZB4cBHnXuxzpqbtB2
        dztcP9+wnlj1Npzqvcvw4SBbhcPINCOrW5w/GB5Voz46hys+/yy1cVSQJnvnClSLqQV0BlbT/xSnd
        Nll+nW4Z23UwGg0w+NmFJ+j5Vj9uN8TwBH0aWud5eMbaqI91DlTxC7X8GQe99Ryifnf+8ekuv6cG5
        v3Zi+BLESY98iLiL33OQI7hDesuLmsELZwns1M2tRR8quGkyU/jgISoLGdMjNj/zL8NWKAboOxtDf
        qQluRdMA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6PM5-0005vC-A1; Tue, 25 Feb 2020 01:49:49 +0000
Date:   Mon, 24 Feb 2020 17:49:49 -0800
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 21/24] iomap: Restructure iomap_readpages_actor
Message-ID: <20200225014949.GS24185@bombadil.infradead.org>
References: <20200219210103.32400-1-willy@infradead.org>
 <20200219210103.32400-22-willy@infradead.org>
 <20200220154741.GB19577@infradead.org>
 <20200220162404.GY24185@bombadil.infradead.org>
 <20200224221749.GA22231@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224221749.GA22231@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 02:17:49PM -0800, Christoph Hellwig wrote:
> On Thu, Feb 20, 2020 at 08:24:04AM -0800, Matthew Wilcox wrote:
> > On Thu, Feb 20, 2020 at 07:47:41AM -0800, Christoph Hellwig wrote:
> > > On Wed, Feb 19, 2020 at 01:01:00PM -0800, Matthew Wilcox wrote:
> > > > From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> > > > 
> > > > By putting the 'have we reached the end of the page' condition at the end
> > > > of the loop instead of the beginning, we can remove the 'submit the last
> > > > page' code from iomap_readpages().  Also check that iomap_readpage_actor()
> > > > didn't return 0, which would lead to an endless loop.
> > > 
> > > I'm obviously biassed a I wrote the original code, but I find the new
> > > very much harder to understand (not that the previous one was easy, this
> > > is tricky code..).
> > 
> > Agreed, I found the original code hard to understand.  I think this is
> > easier because now cur_page doesn't leak outside this loop, so it has
> > an obvious lifecycle.
> 
> I really don't like this patch, and would prefer if the series goes
> ahead without it, as the current sctructure works just fine even
> with the readahead changes.

Dave Chinner specifically asked me to do it this way, so please fight
amongst yourselves.
