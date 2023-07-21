Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A10F6EB64DD
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jul 2023 06:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbjGUG0o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 02:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbjGUG0e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 02:26:34 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE5D271F;
        Thu, 20 Jul 2023 23:26:31 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id F15BC6732D; Fri, 21 Jul 2023 08:26:28 +0200 (CEST)
Date:   Fri, 21 Jul 2023 08:26:28 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Bob Peterson <rpeterso@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Brauner <christian@brauner.io>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        cluster-devel <cluster-devel@redhat.com>
Subject: Re: allow building a kernel without buffer_heads
Message-ID: <20230721062628.GC20845@lst.de>
References: <20230720140452.63817-1-hch@lst.de> <251d9862-e335-243e-d65a-c5538b4df253@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <251d9862-e335-243e-d65a-c5538b4df253@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 20, 2023 at 09:51:30AM -0500, Bob Peterson wrote:
> Gfs2 still uses buffer_heads to manage the metadata being pushed through 
> its journals. We've been reducing our dependency on them but eliminating 
> them altogether is a large and daunting task. We can still work toward that 
> goal, but it will take time.

That's fine - gfs2 selects CONFIG_BUFFER_HEAD after this series and
will be perfectly fine.
