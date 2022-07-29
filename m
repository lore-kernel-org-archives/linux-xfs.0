Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01C51C00144
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jul 2022 14:11:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiG2OLw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Jul 2022 10:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbiG2OLv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Jul 2022 10:11:51 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E3742AFE;
        Fri, 29 Jul 2022 07:11:50 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 15D2868AA6; Fri, 29 Jul 2022 16:11:46 +0200 (CEST)
Date:   Fri, 29 Jul 2022 16:11:45 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Mel Gorman <mgorman@suse.de>
Cc:     Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Johannes Thumshirn <jth@kernel.org>, cluster-devel@redhat.com,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: remove iomap_writepage v2
Message-ID: <20220729141145.GA31605@lst.de>
References: <20220719041311.709250-1-hch@lst.de> <20220728111016.uwbaywprzkzne7ib@quack3> <20220729092216.GE3493@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729092216.GE3493@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 29, 2022 at 10:22:16AM +0100, Mel Gorman wrote:
> There is some context missing because it's not clear what the full impact is
> but it is definitly the case that writepage is ignored in some contexts for
> common filesystems so lets assume that writepage from reclaim context always
> failed as a worst case scenario. Certainly this type of change is something
> linux-mm needs to be aware of because we've been blind-sided before.

Between willy and Johannes pushing or it I was under the strong assumption
that linux-mm knows of it..

> I don't think it would be incredibly damaging although there *might* be
> issues with small systems or cgroups. 

Johannes specifically mentioned that cgroup writeback will never call
into ->writepage anyway.
