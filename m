Return-Path: <SRS0=R26v=BK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C72C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jul 2020 06:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CFFC206DA
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jul 2020 06:55:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pEz909hX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731419AbgGaGzd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 31 Jul 2020 02:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731224AbgGaGzd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Jul 2020 02:55:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DBEC061574
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2020 23:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lDPhqZJ+h2x8vflUI/zQuI0ucwOizyF+pPy1oQvpF+4=; b=pEz909hXcQb5JEwPyPJE3kKsOd
        Mabs+j11U+E7XzxCmHO5TuloNiSAPoW4sBlvin/Qd5/JaONCgsaN3ukmr3PvpDuM//O+NaiCQ3eri
        nzHj/gl7BPi/YMRoUrtgrRmZ4L+bFtHE+H2R4ia+nCtfMhoPnEBKoKhEcK+emW9+1/+1qSqROTX7B
        hLG9aW6d9x3p8f2Pnkw9QjQMIHTzN1yrJlmEWdfNbGTZSxvyAQI6em+fjTekWbGbLC058Fx9lhDOi
        nEXUgH4oHFElF8w1uyNY+wMf9WCZxJ+PoFU2C54p9sRzI+yUvbx9MmXBhe2BNsPZXK1UXExmQS2FA
        9rSoMMKg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k1Owv-0007bt-ON; Fri, 31 Jul 2020 06:55:25 +0000
Date:   Fri, 31 Jul 2020 07:55:25 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Zhengyuan Liu <liuzhengyuang521@gmail.com>,
        linux-xfs@vger.kernel.org, Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [Question] About XFS random buffer write performance
Message-ID: <20200731065525.GC25674@infradead.org>
References: <CAOOPZo45E+hVAo9S_2psMJQzrzwmVKo_WjWOM7Zwhm_CS0J3iA@mail.gmail.com>
 <20200728153453.GC3151642@magnolia>
 <20200728154753.GS23808@casper.infradead.org>
 <20200729015458.GY2005@dread.disaster.area>
 <20200729021231.GV23808@casper.infradead.org>
 <20200729051923.GZ2005@dread.disaster.area>
 <20200729185035.GX23808@casper.infradead.org>
 <20200729230503.GA2005@dread.disaster.area>
 <20200730135040.GD23808@casper.infradead.org>
 <20200730220857.GD2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730220857.GD2005@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[delayed and partial response because I'm on vacation, still feeling
 like I should shime in]

On Fri, Jul 31, 2020 at 08:08:57AM +1000, Dave Chinner wrote:
> In which case, you just identified why the uptodate array is
> necessary and can't be removed. If we do a sub-page write() the page
> is not fully initialised, and so if we then mmap it readpage needs
> to know what part of the page requires initialisation to bring the
> page uptodate before it is exposed to userspace.
> 
> But that also means the behaviour of the 4kB write on 64kB page size
> benchmark is unexplained, because that should only be marking the
> written pages of the page up to date, and so it should be behaving
> exactly like ext4 and only writing back individual uptodate chunks
> on the dirty page....

We have two different cases here:  file read in through read or mmap,
or just writing to a not cached file.  In the former case redpage
reads everything in, and everything will also be written out.  If
OTOH write only read in parts only those parts will be written out.

> > You're clearly talking to different SSD people than I am.
> 
> Perhaps so.
> 
> But it was pretty clear way back in the days of early sandforce SSD
> controllers that compression and zero detection at the FTL level
> resulted in massive reductions in write amplification right down at
> the hardware level. The next generation of controllers all did this
> so they could compete on performance. They still do this, which is
> why industry benchmarks test performance with incompressible data so
> that they expose the flash write perofrmance, not just the rate at
> which the drive can detect and elide runs of zeros...

I don't know of any modern SSDs doing zeroes detection.

> IOWs, showing that even high end devices end up bandwidth limited
> under common workloads using default configurations is a much more
> convincing argument...

Not every SSD is a high end device.  If you have an enterprise SSD
with a non-volatile write cache and a full blown PCIe interface bandwith
is not going to a limitation.  If on the other hand you have an
el-cheapo ATA SSD or a 2x gen3 PCIe consumer with very few flash
channels OTOH..
