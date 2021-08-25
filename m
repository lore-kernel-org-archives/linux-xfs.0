Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 922BCC4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Aug 2021 07:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BFF461214
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Aug 2021 07:47:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238764AbhHYHrp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Aug 2021 03:47:45 -0400
Received: from verein.lst.de ([213.95.11.211]:55156 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238651AbhHYHrp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Aug 2021 03:47:45 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5C7676736F; Wed, 25 Aug 2021 09:46:58 +0200 (CEST)
Date:   Wed, 25 Aug 2021 09:46:57 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Sierra <alex.sierra@amd.com>
Cc:     akpm@linux-foundation.org, Felix.Kuehling@amd.com,
        linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jgg@nvidia.com, jglisse@redhat.com
Subject: Re: [PATCH v1 09/14] mm: call pgmap->ops->page_free for
 DEVICE_PUBLIC pages
Message-ID: <20210825074657.GB29620@lst.de>
References: <20210825034828.12927-1-alex.sierra@amd.com> <20210825034828.12927-10-alex.sierra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825034828.12927-10-alex.sierra@amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 24, 2021 at 10:48:23PM -0500, Alex Sierra wrote:
> Add MEMORY_DEVICE_PUBLIC case to free_zone_device_page callback.
> Device public type memory case is now able to free its pages properly.

This really should go into patch 4.  And it might make sense to introduce
free_device_private_page directly with the free_device_page name instead
of renaming it a little later.
