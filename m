Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A36BCC38147
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 16:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjARQpD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 11:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjARQoW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 11:44:22 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1322C54206;
        Wed, 18 Jan 2023 08:44:02 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6550568D17; Wed, 18 Jan 2023 17:43:59 +0100 (CET)
Date:   Wed, 18 Jan 2023 17:43:58 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Hugh Dickins <hughd@google.com>, linux-afs@lists.infradead.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        cluster-devel@redhat.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-nilfs@vger.kernel.org
Subject: Re: [PATCH 4/9] shmem: remove shmem_get_partial_folio
Message-ID: <20230118164358.GD7584@lst.de>
References: <20230118094329.9553-1-hch@lst.de> <20230118094329.9553-5-hch@lst.de> <Y8f6sShghKuFim5E@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8f6sShghKuFim5E@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 18, 2023 at 08:57:05AM -0500, Brian Foster wrote:
> This all seems reasonable to me at a glance, FWIW, but I am a little
> curious why this wouldn't split up into two changes. I.e., switch this
> over to filemap_get_entry() to minimally remove the FGP_ENTRY dependency
> without a behavior change, then (perhaps after the next patch) introduce
> SGP_FIND in a separate patch. That makes it easier to review and
> potentially undo if it happens to pose a problem in the future. Hm?

The minimal change to filemap_get_entry would require to add the
lock, check mapping and retry loop and thus add a fair amount of
code.  So I looked for ways to avoid that and came up with this
version.  But if there is a strong preference to first open code
the logic and then later consolidate it I could do that.
