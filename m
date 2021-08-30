Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C4A5C432BE
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Aug 2021 08:28:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4522461008
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Aug 2021 08:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234514AbhH3I25 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Aug 2021 04:28:57 -0400
Received: from verein.lst.de ([213.95.11.211]:39672 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233318AbhH3I25 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Aug 2021 04:28:57 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1655A68AFE; Mon, 30 Aug 2021 10:28:00 +0200 (CEST)
Date:   Mon, 30 Aug 2021 10:28:00 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Felix Kuehling <felix.kuehling@amd.com>
Cc:     "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>,
        Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.org,
        linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        jgg@nvidia.com, jglisse@redhat.com
Subject: Re: [PATCH v1 03/14] mm: add iomem vma selection for memory
 migration
Message-ID: <20210830082800.GA6836@lst.de>
References: <20210825034828.12927-1-alex.sierra@amd.com> <20210825034828.12927-4-alex.sierra@amd.com> <20210825074602.GA29620@lst.de> <c4241eb3-07d2-c85b-0f48-cce4b8369381@amd.com> <a9eb2c4a-d8cc-9553-57b7-fd1622679aaa@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9eb2c4a-d8cc-9553-57b7-fd1622679aaa@amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 26, 2021 at 06:27:31PM -0400, Felix Kuehling wrote:
> I think we're missing something here. As far as I can tell, all the work
> we did first with DEVICE_GENERIC and now DEVICE_PUBLIC always used
> normal pages. Are we missing something in our driver code that would
> make these PTEs special? I don't understand how that can be, because
> driver code is not really involved in updating the CPU mappings. Maybe
> it's something we need to do in the migration helpers.

It looks like I'm totally misunderstanding what you are adding here
then.  Why do we need any special treatment at all for memory that
has normal struct pages and is part of the direct kernel map?
