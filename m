Return-Path: <SRS0=DNa4=W5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16244C3A59E
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Sep 2019 17:16:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEE70217F4
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Sep 2019 17:16:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LLAPg8XO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbfIBRQj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Sep 2019 13:16:39 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49708 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbfIBRQj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Sep 2019 13:16:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+0oscjXmRLZoSva+RI4oxO2YXk5t5V7oUXwjCDh/M9c=; b=LLAPg8XOE4WfTJmr+i55wi6NS
        RTE5zAlQzCM9nJKxIlB12JrN4N85JuysmktgIyIv5YeePV+AGJH1BQ1IzHX4uHJql3IE6umkCI+KA
        h+mrH9zUu/+I4WLDpbASW/f+7gxDp1EiZnP/5VrtHsW7JCpsSxnFrI1274DJpOWl4bLcx6pLDWbyY
        hTvpI7NFA2UPCz0jI5jPeAVm6SOUlLWiT81/r/v7J09nJQiZrSeKisM3Ajws6CYFQ8BXLSFtlHM/n
        CxT7qt63Ztk43nsSEkSNo/5GFvCIKdVq8z78jPkzsedCrsnsY+icOzkfkWFmjgqKVOTyiSA6bDfCS
        k4yN1Hf0A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i4pwU-00065D-09; Mon, 02 Sep 2019 17:16:38 +0000
Date:   Mon, 2 Sep 2019 10:16:37 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Damien.LeMoal@wdc.com,
        agruenba@redhat.com
Subject: Re: [PATCH v4 0/6] iomap: lift the xfs writepage code into iomap
Message-ID: <20190902171637.GA10893@infradead.org>
References: <156444945993.2682261.3926017251626679029.stgit@magnolia>
 <20190816065229.GA28744@infradead.org>
 <20190817014633.GE752159@magnolia>
 <20190901073440.GB13954@infradead.org>
 <20190901204400.GQ5354@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190901204400.GQ5354@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 01, 2019 at 01:44:00PM -0700, Darrick J. Wong wrote:
> Would you mind rebasing the remaining patches against iomap-for-next and
> sending that out?  I'll try to get to it before I go on vacation 6 - 15
> Sept.

Ok.  Testing right now, but the rebase was trivial.

> Admittedly I think the controversial questions are still "How much
> writeback code are we outsourcing to iomap anyway?" and "Do we want to
> do the added stress of keeping that going without breaking everyone
> else"?  IOWs, more philosophical than just the mechanics of porting code
> around.

At least as far as I'm concerned the more code that is common the
better so that I don't have to fix up 4 badly maintained half-assed
forks of the same code (hello mpage, ext4 and f2fs..).

> I still want a CONFIG_IOMAP_DEBUG which turns on stricter checking of
> the iomap(s) that ->begin_iomap pass to the actor, if you have the time;
> I for one am starting to forget exactly what are the valid combinations
> of iomap flag inputs that ->begin_iomap has to handle for a given actor
> and what are the valid imaps for each actor that it can pass back.  :)

I was actually thinking of killing the input IOMAP_ types entirely,
as that "flags" model just doesn't scale, and instead have more
iomap_ops instances in the callers.  But that is just a vague idea
at the moment.  I'll need some more time to think about it.
