Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED333C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 06:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C05656120D
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 06:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234410AbhIPGQs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 02:16:48 -0400
Received: from verein.lst.de ([213.95.11.211]:38662 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234395AbhIPGQr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Sep 2021 02:16:47 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id DFDE767357; Thu, 16 Sep 2021 08:15:23 +0200 (CEST)
Date:   Thu, 16 Sep 2021 08:15:22 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     djwong@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
        dan.j.williams@intel.com, david@fromorbit.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        nvdimm@lists.linux.dev, rgoldwyn@suse.de, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject: Re: [PATCH v9 4/8] fsdax: Convert dax_iomap_zero to iter model
Message-ID: <20210916061522.GA13306@lst.de>
References: <20210915104501.4146910-1-ruansy.fnst@fujitsu.com> <20210915104501.4146910-5-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915104501.4146910-5-ruansy.fnst@fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> -s64 dax_iomap_zero(loff_t pos, u64 length, struct iomap *iomap)
> +s64 dax_iomap_zero(struct iomap_iter *iter, loff_t pos, u64 length)

I think we can also mark the iter const.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
