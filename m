Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B919EC4338F
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Aug 2021 09:10:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9800760C40
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Aug 2021 09:10:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhHOJKe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 Aug 2021 05:10:34 -0400
Received: from verein.lst.de ([213.95.11.211]:51390 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231194AbhHOJKe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 15 Aug 2021 05:10:34 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9DEF66736F; Sun, 15 Aug 2021 11:10:00 +0200 (CEST)
Date:   Sun, 15 Aug 2021 11:10:00 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Sierra <alex.sierra@amd.com>
Cc:     akpm@linux-foundation.org, Felix.Kuehling@amd.com,
        linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jgg@nvidia.com, jglisse@redhat.com
Subject: Re: [PATCH v6 04/13] drm/amdkfd: add SPM support for SVM
Message-ID: <20210815091000.GB25067@lst.de>
References: <20210813063150.2938-1-alex.sierra@amd.com> <20210813063150.2938-5-alex.sierra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813063150.2938-5-alex.sierra@amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> @@ -880,17 +881,22 @@ int svm_migrate_init(struct amdgpu_device *adev)
>  	 * should remove reserved size
>  	 */
>  	size = ALIGN(adev->gmc.real_vram_size, 2ULL << 20);
> -	res = devm_request_free_mem_region(adev->dev, &iomem_resource, size);
> +	if (xgmi_connected_to_cpu)
> +		res = lookup_resource(&iomem_resource, adev->gmc.aper_base);
> +	else
> +		res = devm_request_free_mem_region(adev->dev, &iomem_resource, size);
> +

Can you explain what the point of the lookup_resource is here? res->start
is obviously identical to the start value you pass in.  So this is used
as a way to query the length, but I'm pretty sure the driver must
already know that as it inserted the resource itself, right?

On a slightly higher level comment svm_migrate_init is a bit of a mess
with all the if/else already, and with the above addressed will become
a bit more.  I think splitting it into a device private and device
generic case would probably help people finding it to understand the code
much better later on.  Even more so with a useful comment.
