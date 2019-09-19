Return-Path: <SRS0=IJtx=XO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D49EC3A5A6
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 17:20:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AB4F217D6
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 17:20:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388183AbfISRUt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Sep 2019 13:20:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57436 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387569AbfISRUt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Sep 2019 13:20:49 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A80E487642;
        Thu, 19 Sep 2019 17:20:49 +0000 (UTC)
Received: from redhat.com (ovpn-123-212.rdu2.redhat.com [10.10.123.212])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 49F155D6B0;
        Thu, 19 Sep 2019 17:20:49 +0000 (UTC)
Date:   Thu, 19 Sep 2019 12:20:47 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] xfs: assure zeroed memory buffers for certain kmem
 allocations
Message-ID: <20190919172047.GA3806@redhat.com>
References: <20190916153504.30809-1-billodo@redhat.com>
 <20190919150154.30302-1-billodo@redhat.com>
 <20190919170353.GA1646@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919170353.GA1646@infradead.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 19 Sep 2019 17:20:49 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 19, 2019 at 10:03:53AM -0700, Christoph Hellwig wrote:
> On Thu, Sep 19, 2019 at 10:01:54AM -0500, Bill O'Donnell wrote:
> > +	uint			kmflag_mask = 0;
> > +
> > +	if (!(flags & XBF_READ))
> > +		kmflag_mask |= KM_ZERO;
> 
> > @@ -391,7 +396,7 @@ xfs_buf_allocate_memory(
> >  		struct page	*page;
> >  		uint		retries = 0;
> >  retry:
> > -		page = alloc_page(gfp_mask);
> > +		page = alloc_page(gfp_mask | kmflag_mask);
> 
> alloc_page takes GFP_ flags, not KM_.  In fact sparse should have warned
> about this.

I wondered if the KM flag needed conversion to GFP, but saw no warning.
Thanks-
Bill
