Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2A69C48BDF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Jun 2021 05:30:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1DA3613E1
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Jun 2021 05:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhFXFdM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Jun 2021 01:33:12 -0400
Received: from verein.lst.de ([213.95.11.211]:53053 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230093AbhFXFdM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Jun 2021 01:33:12 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 244BF68AFE; Thu, 24 Jun 2021 07:30:49 +0200 (CEST)
Date:   Thu, 24 Jun 2021 07:30:48 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Felix Kuehling <felix.kuehling@amd.com>
Cc:     Theodore Ts'o <tytso@mit.edu>, Alex Sierra <alex.sierra@amd.com>,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        rcampbell@nvidia.com, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, hch@lst.de, jgg@nvidia.com,
        jglisse@redhat.com
Subject: Re: [PATCH v3 0/8] Support DEVICE_GENERIC memory in migrate_vma_*
Message-ID: <20210624053048.GB25004@lst.de>
References: <20210617151705.15367-1-alex.sierra@amd.com> <YM9NXrGlhdp0qb7S@mit.edu> <905418d1-9099-0ea8-a6e6-84cc8ef3d0b0@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <905418d1-9099-0ea8-a6e6-84cc8ef3d0b0@amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 23, 2021 at 05:49:55PM -0400, Felix Kuehling wrote:
> For the reference counting changes we could use the dax driver with hmem 
> and use efi_fake_mem on the kernel command line to create some 
> DEVICE_GENERIC pages. I'm open to suggestions for good user mode tests to 
> exercise dax functionality on this type of memory.
>
> For the migration helper changes we could modify or parametrize 
> lib/hmm_test.c to create DEVICE_GENERIC pages instead of DEVICE_PRIVATE. 
> Then run tools/testing/selftests/vm/hmm-tests.c.

We'll also need a real in-tree user of the enhanced DEVICE_GENERIC memory.
So while the refcounting cleanups early in the series are something I'd
really like to see upstream as soon as everything is sorted out, the
actual bits that can't only be used by your updated driver should wait
for that.
