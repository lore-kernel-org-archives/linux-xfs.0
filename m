Return-Path: <SRS0=sZmN=5D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC49C10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 07:54:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CEB32076F
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 07:54:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O4AC9Wyx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgCRHyZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Mar 2020 03:54:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36188 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgCRHyZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Mar 2020 03:54:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HouNVHvMelsMPW3Va1xvwZaP0gHrLhJSoexQ7+ZDTeE=; b=O4AC9WyxivztuP4hUfHLpatOIy
        xL+taQmGEu6c5Y9xJiq9fom9iPhRbrB/ol+/PfnMxtztbVrYl9BEQHmEDtTLyNKh97zmw5ftejReF
        VCUw90PNRLSONCYkd/FYkPP/AkpBJMB5oMPlxVOTASC2pgQU5mKI5IOAHpULImkcn8T425K/c5hFa
        8FC4k7MYEVs2ow7aE6U756rwL2YqvBrhReQgVgFsxHAj6/SEHtCGKSRyi9YTkEBNDZ7yicDmihkO2
        mDbooMUCJ8xgf9BDkb/BX1wKDJOkAKplTjfNrC4axDHb63iBzm1ju3W7wTvKBhiz2LTTIuPdTIutR
        7LzTuMtQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jETWy-0000wG-7h; Wed, 18 Mar 2020 07:54:24 +0000
Date:   Wed, 18 Mar 2020 00:54:24 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Ober, Frank" <frank.ober@intel.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: write atomicity with xfs ... current status?
Message-ID: <20200318075424.GA24276@infradead.org>
References: <MW3PR11MB46974637E20D2ED949A7A47E8BF90@MW3PR11MB4697.namprd11.prod.outlook.com>
 <20200317191954.GA29982@infradead.org>
 <20200317225505.GU10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317225505.GU10776@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 18, 2020 at 09:55:05AM +1100, Dave Chinner wrote:
> > That being said while I had a prototype to use the NVMe atomic write
> > size I will never submit that to mainline in that paticular form.
> > 
> > NVMe does not have any flag to force atomic writes, thus a too large
> > or misaligned write will be executed by the device withour errors.
> > That kind of interface is way too fragile to be used in production.
> 
> I didn't realise that the NVMe standard had such a glaring flaw.
> That basically makes atomic writes useless for anything that
> actually requires atomicity. Has the standard been fixed yet?

No.

> And
> does this means that hardware with usable atomic writes is still
> years away?

At least for the hardware I'm familiar with checking a flag and failing
it if the conditions are not met might be a relatively simple firmware
fix.  It just needs a big enough customer to ask for, not just some
Linux developers.
