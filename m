Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7C92C7EE22
	for <linux-xfs@archiver.kernel.org>; Wed, 10 May 2023 15:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237680AbjEJPN4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 May 2023 11:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237677AbjEJPNz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 May 2023 11:13:55 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625D612D;
        Wed, 10 May 2023 08:13:54 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1E3EE68BEB; Wed, 10 May 2023 17:13:51 +0200 (CEST)
Date:   Wed, 10 May 2023 17:13:50 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] block: introduce holder ops
Message-ID: <20230510151350.GA11333@lst.de>
References: <20230505175132.2236632-1-hch@lst.de> <20230505175132.2236632-6-hch@lst.de> <20230505185119.GI15394@frogsfrogsfrogs> <20230509133501.GD841@lst.de> <20230509221958.GV3223426@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509221958.GV3223426@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 10, 2023 at 08:19:58AM +1000, Dave Chinner wrote:
> The userspace shutdown code already does this by default - it
> actually calls freeze_bdev() to cause the filesystem to be made
> consistent on the block device before it executes the shutdown.
> So, in effect, we already have the "shutdown before turning off
> block device" paths in the filesystems and extremely well tested.

Yes.

> Indeed, if the device is being removed, why not call freeze_bdev()
> before doing anything else? It guarantees that applications will be
> quiesced and the filesystem will stabilise and not try to change
> anything until the shutdown occurs when the device is pulled...

Because the primary use case of using sysfs to yank a block device
out under a live fs is testing the shutdown path.  Changing behavior
here will not improve any actual user live, because no user actually
intentially does this, but at the same time we add new odd code
we need to test, while breaking existing tests.
