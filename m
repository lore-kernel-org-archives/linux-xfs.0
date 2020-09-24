Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 632CFC4363D
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 20:08:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB5A42395B
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 20:08:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cb+NX5uY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgIXUIe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 16:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgIXUId (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Sep 2020 16:08:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC28C0613D5;
        Thu, 24 Sep 2020 13:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/yZPu04kDV61eyuWPnLHqBKDuawV+6hPphmNjV2NEVg=; b=cb+NX5uYSNgan22m1MkoYE2cNn
        N/tTfc4rmjNmS1opKm2L7QA6DJScNR/hZvaGMzqoDnayBfXYyz+6Y3Jw0Ss6Xz+/dlwP6sUa0+Exx
        ia4itjUM7aTB0w69I6hu6EmyYazIuecR2zwHaZoAxyC7F4Gu6xUSfp/R/PH/Qj0NyqFuAO3nbD2xA
        rfgGG8hQ0mHDxcN5HYnYJw0ugH51dK5I2+Z6XJLscZJQXTrpWmlMpfBnZNnom9QZh5cVpQSYr7jER
        5cJOOp2hzXBHpFlPCOe2AHsD/NKpmZLzUBP4ylHdKdN1ObRAdGWKZpDFMl0tpL/e7dKNebfFYlphc
        ethvvuvA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kLXRh-0000n9-U1; Thu, 24 Sep 2020 20:02:26 +0000
Date:   Thu, 24 Sep 2020 21:02:25 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Qian Cai <cai@redhat.com>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] iomap: Set all uptodate bits for an Uptodate page
Message-ID: <20200924200225.GC32101@casper.infradead.org>
References: <20200924125608.31231-1-willy@infradead.org>
 <CA+icZUUQGmd3juNPv1sHTWdhzXwZzRv=p1i+Q=20z_WGcZOzbg@mail.gmail.com>
 <20200924151538.GW32101@casper.infradead.org>
 <CA+icZUX4bQf+pYsnOR0gHZLsX3NriL=617=RU0usDfx=idgZmA@mail.gmail.com>
 <20200924152755.GY32101@casper.infradead.org>
 <CA+icZUURRcCh1TYtLs=U_353bhv5_JhVFaGxVPL5Rydee0P1=Q@mail.gmail.com>
 <20200924163635.GZ32101@casper.infradead.org>
 <CA+icZUUgwcLP8O9oDdUMT0SzEQHjn+LkFFkPL3NsLCBhDRSyGw@mail.gmail.com>
 <f623da731d7c2e96e3a37b091d0ec99095a6386b.camel@redhat.com>
 <CA+icZUVO65ADxk5SZkZwV70ax5JCzPn8PPfZqScTTuvDRD1smQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUVO65ADxk5SZkZwV70ax5JCzPn8PPfZqScTTuvDRD1smQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 24, 2020 at 09:54:36PM +0200, Sedat Dilek wrote:
> You are named in "mm: fix misplaced unlock_page in do_wp_page()".
> Is this here a different issue?

Yes, completely different.  That bug is one Linus introduced in this
cycle; the bug that this patch fixes was introduced a couple of years
ago, and we only noticed now because I added an assertion to -next.
Maybe I should add the assertion for 5.9 too.
