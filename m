Return-Path: <SRS0=59Ki=B7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDBABC433E3
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 06:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B124020702
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 06:10:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qGBi2DQ7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgHUGKc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Aug 2020 02:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727843AbgHUGKZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Aug 2020 02:10:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB79C061385;
        Thu, 20 Aug 2020 23:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oDJYPV/IVg/Nr7LdxyZSvphedlvluXjRrFI3xf0WQ0E=; b=qGBi2DQ7FpYtGr78K1oewZH4rh
        DSfAs/X1ZkkuDIWEPiTMjGfO322KSnIQfe+f7DC1PkhUUQTG+4IHN9CcfOhWzVg6+qnuXwADOW226
        BAB30dLgEtnC1DUsnDAO7EB8T0YXU8JAgNssTu18VXrBUnLhfg+17PIcSucK5o8nxcP/kspToDj3i
        Uw0rNURT5sjbI/qQROqu61py0P2LeBpUJ49enzzRbcJ9jKFU9gwqeJT3rxy3FsnH04WcsfEWRqcop
        eu2KTSnqDN5Wxej8OdxJcZuLUx1alwmy/qcYAd4SiM/RSkj2w2132/9tP2y5+7HH3S+iCoXmerZ+k
        higl5oIQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k90Fn-0000iE-1z; Fri, 21 Aug 2020 06:10:19 +0000
Date:   Fri, 21 Aug 2020 07:10:19 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Yu Kuai <yukuai3@huawei.com>, hch@infradead.org,
        david@fromorbit.com, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        yi.zhang@huawei.com
Subject: Re: [RFC PATCH V2] iomap: add support to track dirty state of sub
 pages
Message-ID: <20200821061019.GD31091@infradead.org>
References: <20200818134618.2345884-1-yukuai3@huawei.com>
 <20200818155305.GR17456@casper.infradead.org>
 <20200818161229.GK6107@magnolia>
 <20200818165019.GT17456@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818165019.GT17456@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 05:50:19PM +0100, Matthew Wilcox wrote:
> Looks like Christoph changed his mind sometime between that message
> and the first commit: 9dc55f1389f9569acf9659e58dd836a9c70df217

No, as Darrick pointed out it was all about the header dependency.

> My THP patches convert the bit array to be per-block rather than
> per-sector, so this is all going to go away soon ;-)

I've asked a while ago, but let me repeat:  Can you split out all the
useful iomap bits that are not directly dependent on the new THP
infrastructure and send them out ASAP?  I'd like to pre-load this
work at least a merge window before the actual THP bits.
