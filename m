Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F1AC47257
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 16:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A093024955
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 16:50:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbgEAQuU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 12:50:20 -0400
Received: from verein.lst.de ([213.95.11.211]:47794 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728919AbgEAQuU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 May 2020 12:50:20 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8E11C68C65; Fri,  1 May 2020 18:50:17 +0200 (CEST)
Date:   Fri, 1 May 2020 18:50:17 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs: remove xfs_ifork_ops
Message-ID: <20200501165017.GA20127@lst.de>
References: <20200501081424.2598914-1-hch@lst.de> <20200501081424.2598914-9-hch@lst.de> <20200501155649.GO40250@bfoster> <20200501160809.GT6742@magnolia> <20200501163809.GA18426@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200501163809.GA18426@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 06:38:09PM +0200, Christoph Hellwig wrote:
> That being said my approach here was a little too dumb.  Once we are
> all in the same code base we can stop the stupid patching of the
> parent and just handle the case directly.  Something like this
> incremental diff on top of the sent out version (not actually tested).
> 
> Total diffstate with the original patch is:
> 
>  4 files changed, 37 insertions(+), 35 deletions(-)
> 
> and this should also help with online repair while killing a horrible
> kludge.

Btw, І wonder if for repair / online repair just skipping the verifiers
entirely would make more sense.  But I think we can go there
incrementally and just keep the existing repair behavior for now.
