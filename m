Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC20C77B7A
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jun 2023 15:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241580AbjFGP4c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Jun 2023 11:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241582AbjFGP4X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jun 2023 11:56:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9450B1BEA;
        Wed,  7 Jun 2023 08:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XiJmAxCcVnammsjusWpIlT8SktTQqnalw7i+smLf4bw=; b=kxxxeAYh8e0qrbadqlZTRu1UEy
        dFExcYLfN+bqeydOLFcmTqdu+0WQ3O0KPBkm55Nv2d+KrRnahXbYFOtRQVa3UlC5GhXvgfKAAw/Yh
        LvuBAcLTXEupbkAlWDsu4PNEG8hi9fp6/aOpGn0iARcjGCjiEp3gQ/KM2EgxiNWsdC+9nKPDpMgNR
        gmOnEbVDdedpPdleke+RirBPMRX2gV8gGJkNTJ/YFEimBW2AccUk+73RZV1JYt17AhHNsyWi1Gr4J
        xwG3b4UaBPi7R30pbF6YyaFgu4QIEghi+rph4e+SGaK0XALUUNmndhXhjS4Nnlysaoxa+fbkEGlTm
        V0MxXVFg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1q6vVx-00EPGa-Qk; Wed, 07 Jun 2023 15:56:01 +0000
Date:   Wed, 7 Jun 2023 16:56:01 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Yin Fengwei <fengwei.yin@intel.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Wang Yugui <wangyugui@e16-tech.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2 7/7] iomap: Copy larger chunks from userspace
Message-ID: <ZICokf3KS5IRbWFh@casper.infradead.org>
References: <20230602222445.2284892-1-willy@infradead.org>
 <20230602222445.2284892-8-willy@infradead.org>
 <20230604182952.GH72241@frogsfrogsfrogs>
 <ZH0MDtoTyUMQ7eok@casper.infradead.org>
 <d47f280e-9e98-ffd2-1386-097fc8dc11b5@intel.com>
 <ZH91+QWd3k8a2x/Z@casper.infradead.org>
 <8307ce42-7b70-8c4f-105e-bd47e4ef734c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8307ce42-7b70-8c4f-105e-bd47e4ef734c@intel.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 07, 2023 at 02:40:02PM +0800, Yin Fengwei wrote:
> > +	page += offset / PAGE_SIZE;
> > +	offset %= PAGE_SIZE;
> > +	if (PageHighMem(page))
> > +		n = min_t(size_t, bytes, PAGE_SIZE);
> Should be PAGE_SIZE - offset instead of PAGE_SIZE?

Yes, it should.  Thanks.

