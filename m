Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E18C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:31:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02AEE60F4F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235633AbhG0Gbl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:31:41 -0400
Received: from verein.lst.de ([213.95.11.211]:48591 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234803AbhG0Gbl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 02:31:41 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0300B67373; Tue, 27 Jul 2021 08:31:39 +0200 (CEST)
Date:   Tue, 27 Jul 2021 08:31:38 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, nvdimm@lists.linux.dev,
        cluster-devel@redhat.com
Subject: Re: [PATCH 16/27] iomap: switch iomap_bmap to use iomap_iter
Message-ID: <20210727063138.GA10143@lst.de>
References: <20210719103520.495450-1-hch@lst.de> <20210719103520.495450-17-hch@lst.de> <20210719170545.GF22402@magnolia> <20210726081942.GD14853@lst.de> <20210726163922.GA559142@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726163922.GA559142@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 09:39:22AM -0700, Darrick J. Wong wrote:
> The documentation needs to be much more explicit about the fact that you
> cannot "break;" your way out of an iomap_iter loop.  I think the comment
> should be rewritten along these lines:
> 
> "Iterate over filesystem-provided space mappings for the provided file
> range.  This function handles cleanup of resources acquired for
> iteration when the filesystem indicates there are no more space
> mappings, which means that this function must be called in a loop that
> continues as long it returns a positive value.  If 0 or a negative value
> is returned, the caller must not return to the loop body.  Within a loop
> body, there are two ways to break out of the loop body: leave
> @iter.processed unchanged, or set it to the usual negative errno."
> 
> Hm.

Yes, I'll update the documentation.

> Clunky, for sure, but at least we still get to use break as the language
> designers intended.

I can't see any advantage there over just proper documentation.  If you
are totally attached to a working break we might have to come up with
a nasty for_each macro that ensures we have a final iomap_apply, but I
doubt it is worth the effort.
