Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4096C432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 05:49:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B374C60F38
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 05:49:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbhHQFtf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 01:49:35 -0400
Received: from verein.lst.de ([213.95.11.211]:57152 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233928AbhHQFtf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Aug 2021 01:49:35 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 140406736F; Tue, 17 Aug 2021 07:49:01 +0200 (CEST)
Date:   Tue, 17 Aug 2021 07:49:00 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>
Cc:     Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.org,
        Felix.Kuehling@amd.com, linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        jgg@nvidia.com, jglisse@redhat.com
Subject: Re: [PATCH v6 05/13] drm/amdkfd: generic type as sys mem on
 migration to ram
Message-ID: <20210817054900.GB4895@lst.de>
References: <20210813063150.2938-1-alex.sierra@amd.com> <20210813063150.2938-6-alex.sierra@amd.com> <20210815153825.GB32384@lst.de> <694ea624-9dc7-7a25-78a6-308ee0debaea@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <694ea624-9dc7-7a25-78a6-308ee0debaea@amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 16, 2021 at 02:53:18PM -0500, Sierra Guiza, Alejandro (Alex) wrote:
> For above’s condition equal to connected_to_cpu , we’re explicitly 
> migrating from
> device memory to system memory with device generic type. In this type, 
> device PTEs are
> present in CPU page table.
>
> During migrate_vma_collect_pmd walk op at migrate_vma_setup call, there’s 
> a condition
> for present pte that require migrate->flags be set for 
> MIGRATE_VMA_SELECT_SYSTEM.
> Otherwise, the migration for this entry will be ignored.

I think we might need a new SELECT flag here for IOMEM.
