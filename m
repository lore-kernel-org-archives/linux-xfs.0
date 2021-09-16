Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B827C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 06:16:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46AE4601FC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 06:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbhIPGSR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 02:18:17 -0400
Received: from verein.lst.de ([213.95.11.211]:38674 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234395AbhIPGSQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Sep 2021 02:18:16 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9F53568AFE; Thu, 16 Sep 2021 08:16:54 +0200 (CEST)
Date:   Thu, 16 Sep 2021 08:16:54 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     djwong@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
        dan.j.williams@intel.com, david@fromorbit.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        nvdimm@lists.linux.dev, rgoldwyn@suse.de, viro@zeniv.linux.org.uk,
        willy@infradead.org, Ritesh Harjani <riteshh@linux.ibm.com>
Subject: Re: [PATCH v9 5/8] fsdax: Add dax_iomap_cow_copy() for
 dax_iomap_zero
Message-ID: <20210916061654.GB13306@lst.de>
References: <20210915104501.4146910-1-ruansy.fnst@fujitsu.com> <20210915104501.4146910-6-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915104501.4146910-6-ruansy.fnst@fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 15, 2021 at 06:44:58PM +0800, Shiyang Ruan wrote:
> +	rc = dax_direct_access(iomap->dax_dev, pgoff, 1, &kaddr, NULL);
> +	if (rc < 0)
> +		goto out;
> +	memset(kaddr + offset, 0, size);
> +	if (srcmap->addr != IOMAP_HOLE && srcmap->addr != iomap->addr) {

Should we also check that ->dax_dev for iomap and srcmap are different
first to deal with case of file system with multiple devices?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
