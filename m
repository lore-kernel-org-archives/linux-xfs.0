Return-Path: <SRS0=fGHA=XF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFEABC3A5A2
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Sep 2019 07:01:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEB76216F4
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Sep 2019 07:01:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kdo/KLHS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730213AbfIJHB1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Sep 2019 03:01:27 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55694 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730141AbfIJHB1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Sep 2019 03:01:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6dAsQm3T75NRuXuapuaY3ud4bh1HvlwFPEsnsi3LVr0=; b=kdo/KLHSQVnzJJiCBJiJWbnLa
        /BES3GTaVbGhmI+chrccPWzD+QIVfEYUY3+y/Aw/b78nhFlYi26wmYu255TXdVhLM1phj/6+dLZ5i
        DgRsi2YGq4JtVvuGSP0VRIuVQKb5eE+7IPGGBDGtZ4s6Rmwj+AU/5JgxSqT6qvH4MXOFYeQuaW7IE
        LKnL8szC9yaBjPzPYI0HWV/41/ciKY/6yAXRN0BHBLeHKDccoEPVoRj6sL3I3CryjuJOJKNGdbWbF
        VTW30cap3SrqZHz1aQ9mvq3hBm085PPkz0OHRRvLdFSeFQjyoh/mdiFroDjZy83ryKbdYAYOIOR4l
        OdiNxhSog==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i7a9V-0006B6-3E; Tue, 10 Sep 2019 07:01:25 +0000
Date:   Tue, 10 Sep 2019 00:01:24 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Damien.LeMoal@wdc.com,
        agruenba@redhat.com
Subject: Re: [PATCH v4 0/6] iomap: lift the xfs writepage code into iomap
Message-ID: <20190910070124.GA23712@infradead.org>
References: <156444945993.2682261.3926017251626679029.stgit@magnolia>
 <20190816065229.GA28744@infradead.org>
 <20190817014633.GE752159@magnolia>
 <20190901073440.GB13954@infradead.org>
 <20190901204400.GQ5354@magnolia>
 <20190902171637.GA10893@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190902171637.GA10893@infradead.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 02, 2019 at 10:16:37AM -0700, Christoph Hellwig wrote:
> On Sun, Sep 01, 2019 at 01:44:00PM -0700, Darrick J. Wong wrote:
> > Would you mind rebasing the remaining patches against iomap-for-next and
> > sending that out?  I'll try to get to it before I go on vacation 6 - 15
> > Sept.
> 
> Ok.  Testing right now, but the rebase was trivial.
> 
> > Admittedly I think the controversial questions are still "How much
> > writeback code are we outsourcing to iomap anyway?" and "Do we want to
> > do the added stress of keeping that going without breaking everyone
> > else"?  IOWs, more philosophical than just the mechanics of porting code
> > around.
> 
> At least as far as I'm concerned the more code that is common the
> better so that I don't have to fix up 4 badly maintained half-assed
> forks of the same code (hello mpage, ext4 and f2fs..).

Any news?
