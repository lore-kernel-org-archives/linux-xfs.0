Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A19E7C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 08:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72C3960F9B
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 08:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbhGZHpO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 03:45:14 -0400
Received: from verein.lst.de ([213.95.11.211]:44324 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231774AbhGZHpO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Jul 2021 03:45:14 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 66F7767373; Mon, 26 Jul 2021 10:25:38 +0200 (CEST)
Date:   Mon, 26 Jul 2021 10:25:38 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, nvdimm@lists.linux.dev,
        cluster-devel@redhat.com
Subject: Re: [PATCH 20/27] fsdax: switch dax_iomap_rw to use iomap_iter
Message-ID: <20210726082538.GF14853@lst.de>
References: <20210719103520.495450-1-hch@lst.de> <20210719103520.495450-21-hch@lst.de> <20210719221005.GL664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719221005.GL664593@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 20, 2021 at 08:10:05AM +1000, Dave Chinner wrote:
> At first I wondered "iomi? Strange name, why is this one-off name
> used?" and then I realised it's because this function also takes an
> struct iov_iter named "iter".
> 
> That's going to cause confusion in the long run - iov_iter and
> iomap_iter both being generally named "iter", and then one or the
> other randomly changing when both are used in the same function.
> 
> Would it be better to avoid any possible confusion simply by using
> "iomi" for all iomap_iter variables throughout the patchset from the
> start? That way nobody is going to confuse iov_iter with iomap_iter
> iteration variables and code that uses both types will naturally
> have different, well known names...

Hmm.  iomi comes from the original patch from willy and I kinda hate
it.  But given that we have this clash here (and in the direct I/O code)
I kept using it.

Does anyone have any strong opinions here?
