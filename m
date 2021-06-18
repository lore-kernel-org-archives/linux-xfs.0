Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 332F8C48BDF
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 13:24:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17755613EC
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 13:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhFRN1F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 09:27:05 -0400
Received: from verein.lst.de ([213.95.11.211]:34875 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229877AbhFRN1F (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 Jun 2021 09:27:05 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7D53968D0A; Fri, 18 Jun 2021 15:24:54 +0200 (CEST)
Date:   Fri, 18 Jun 2021 15:24:54 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: factor out a helper to write a log_iovec into
 the iclog
Message-ID: <20210618132454.GB13406@lst.de>
References: <20210616163212.1480297-1-hch@lst.de> <20210616163212.1480297-4-hch@lst.de> <YMt28LSgI5XCllQx@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMt28LSgI5XCllQx@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 17, 2021 at 12:23:12PM -0400, Brian Foster wrote:
> On Wed, Jun 16, 2021 at 06:32:07PM +0200, Christoph Hellwig wrote:
> > Add a new helper to copy the log iovec into the in-core log buffer,
> > and open code the handling continuation opheader as a special case.
> > 
> 
> What do you mean by "open code the handling continuation opheader?"

This is left from my commit message when this and the next patch were
still one and relates to the then removed xlog_write_adv_cnt helper.
In the current form it makes no sense, so I'll reword the commit message.
