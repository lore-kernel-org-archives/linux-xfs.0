Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB262C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 08:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 957AF22B47
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 08:39:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ddjam0kF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgH0Ijx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 04:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbgH0Ijw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 04:39:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376ECC061264;
        Thu, 27 Aug 2020 01:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M2uZojDOOMLE39hrWQtfZ22Q97aL3ayjlw6wCDd+LVA=; b=ddjam0kF1zHBRftbdmXZA7oFBW
        n0D78lJ9zlPjJpIO3e/IRxadnz2vaOXh/2TnZGn1SuTFJeFzyTlk2+4pfs16OyfnRDI6LIahc4Wz0
        CHzRhQoo11OCyDgC6qRONa9DaG5Li8strlXlG7Db8CCU4RJV6X1Iz6ddHjNrSAqXi0r3y/1ZZI2aS
        eiQHcv5MqVH8DLlLPDi8ccqYWnZD6hJbv/z5sFxMM1im+qiuZckEjcWDrqZOiS3PRncA7icaD59sP
        z2hvnmJOn+mGFj3Fti+niOFAKnNLqPvE/5xvbx2tZCl0Q3GY5fnM3BAFxO1UwIOH1f8LlTgktGLvT
        HuAxgdlA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBDRl-00040W-CS; Thu, 27 Aug 2020 08:39:49 +0000
Date:   Thu, 27 Aug 2020 09:39:49 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] iomap: Change calling convention for zeroing
Message-ID: <20200827083949.GE11067@infradead.org>
References: <20200824145511.10500-1-willy@infradead.org>
 <20200824145511.10500-10-willy@infradead.org>
 <20200825222355.GL6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825222355.GL6096@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 25, 2020 at 03:23:55PM -0700, Darrick J. Wong wrote:
> Sorry for my ultra-slow response to this.  The u64 length seems ok to me
> (or uint64_t, I don't care all /that/ much), but using loff_t as a
> return type bothers me because I see that and think that this function
> is returning a new file offset, e.g. (pos + number of bytes zeroed).
> 
> So please, let's use s64 or something that isn't so misleading.
> 
> FWIW, Linus also[0] doesn't[1] like using loff_t for the number of bytes
> copied.

Let's just switch to u64 and s64 then.  Unless we want to come up with
our own typedefs.
