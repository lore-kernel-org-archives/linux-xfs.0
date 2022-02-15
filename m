Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92AD9C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Feb 2022 18:32:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243104AbiBOScZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 13:32:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243096AbiBOScY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Feb 2022 13:32:24 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14801EEE1;
        Tue, 15 Feb 2022 10:32:13 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4B3BA68AA6; Tue, 15 Feb 2022 19:32:09 +0100 (CET)
Date:   Tue, 15 Feb 2022 19:32:09 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Felix Kuehling <felix.kuehling@amd.com>,
        Alex Sierra <alex.sierra@amd.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jglisse@redhat.com, apopple@nvidia.com,
        willy@infradead.org
Subject: Re: [PATCH v6 01/10] mm: add zone device coherent type memory
 support
Message-ID: <20220215183209.GA24409@lst.de>
References: <20220201154901.7921-1-alex.sierra@amd.com> <20220201154901.7921-2-alex.sierra@amd.com> <beb38138-2266-1ff8-cc82-8fe914bed862@redhat.com> <f2af73c1-396b-168f-7f86-eb10b3b68a26@redhat.com> <a24d82d9-daf9-fa1a-8b9d-5db7fe10655e@amd.com> <078dd84e-ebbc-5c89-0407-f5ecc2ca3ebf@redhat.com> <20220215144524.GR4160@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220215144524.GR4160@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 15, 2022 at 10:45:24AM -0400, Jason Gunthorpe wrote:
> > Do you know if DEVICE_GENERIC pages would end up as PageAnon()? My
> > assumption was that they would be part of a special mapping.
> 
> We need to stop using the special PTEs and VMAs for things that have a
> struct page. This is a mistake DAX created that must be undone.

Yes, we'll get to it.  Maybe we can do it for the non-DAX devmap
ptes first given that DAX is more complicated.
