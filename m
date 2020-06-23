Return-Path: <SRS0=nlsN=AE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A54B3C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 11:32:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F8672072E
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 11:32:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sPxY8Eb/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732466AbgFWLc2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 07:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732450AbgFWLc0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jun 2020 07:32:26 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A654DC061573;
        Tue, 23 Jun 2020 04:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nU2p89RvjTFjAGOQygxX4Hxib0SVdt+Fk8yoHdziDoQ=; b=sPxY8Eb/Vs+HUyBqnPAu9cx4lU
        EcuS1rdqgJKKm75FyITu5nEgDaOJl9fOVjzjVbmFE8RlJKsZN3dThJiBIYOm7nD4mUSxxAjI3vANE
        Y5O5PvZ94lUcuQ0hpQXhO1H1z9TzGqsECb4do6JfJcdBPfrEw1ryHMI5L/mhfnRC1MvFOmhwlou2o
        MzCHdUgaLGsOq2g2tjyda8p+eQqRiH2f0wJQQXPtiTklLXvRVWTMjKB4cE4AT4OsszU/zYB83JOGU
        sPBVQd6EJSo6/OVlrQVzBr++P7e8Ud1ii3dCvFXLvqZFsMda6WudhngD8JYZoU11hThDE6a96SKmY
        Y+Q0GZvQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jnh9o-0007DX-A2; Tue, 23 Jun 2020 11:32:04 +0000
Date:   Tue, 23 Jun 2020 12:32:04 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Andreas Gr??nbacher <andreas.gruenbacher@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Bob Peterson <rpeterso@redhat.com>
Subject: Re: [PATCH v2] iomap: Make sure iomap_end is called after iomap_begin
Message-ID: <20200623113204.GA27620@infradead.org>
References: <20200618122408.1054092-1-agruenba@redhat.com>
 <20200619131347.GA22412@infradead.org>
 <CAHc6FU7uKUV-R+qJ9ifLAJkS6aPoG_6qWe7y7wJOb7EbWRL4dQ@mail.gmail.com>
 <20200623103605.GA20464@infradead.org>
 <CAHpGcM+bCGJMB_k842pr57Ms1VMC6fva++XXaN+aF7rZ2roAvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHpGcM+bCGJMB_k842pr57Ms1VMC6fva++XXaN+aF7rZ2roAvQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 23, 2020 at 12:51:00PM +0200, Andreas Gr??nbacher wrote:
> > Yes, it merges the WARN_ONs, and thus reduces their usefulness.  How
> > about a patch that just fixes your reported issue insted of messing up
> > other things for no good reason?
> 
> So you're saying you prefer this:
> 
> +       if (WARN_ON(iomap.offset > pos)) {
> +               written = -EIO;
> +               goto out;
> +       }
> +       if (WARN_ON(iomap.length == 0)) {
> +               written = -EIO;
> +               goto out;
> +       }
> 
> to this:
> 
> +       if (WARN_ON(iomap.offset > pos) ||
> +           WARN_ON(iomap.length == 0)) {
> +               written = -EIO;
> +               goto out;
> +       }
> 
> Well fine, you don't need to accuse me of messing up things for that.

Yes.  And we had discussion on exactly that on the previous iteration..
