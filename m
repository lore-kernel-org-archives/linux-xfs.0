Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76B66C77B7F
	for <linux-xfs@archiver.kernel.org>; Wed, 17 May 2023 08:06:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjEQIGV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 May 2023 04:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjEQIGU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 May 2023 04:06:20 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35DD95;
        Wed, 17 May 2023 01:06:17 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 26ECA68C4E; Wed, 17 May 2023 10:06:14 +0200 (CEST)
Date:   Wed, 17 May 2023 10:06:13 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] block: introduce holder ops
Message-ID: <20230517080613.GA31383@lst.de>
References: <20230505175132.2236632-1-hch@lst.de> <20230505175132.2236632-6-hch@lst.de> <20230516-kommode-weizen-4c410968c1f6@brauner> <20230517073031.GF27026@lst.de> <20230517-einreden-dermatologisch-9c6a3327a689@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517-einreden-dermatologisch-9c6a3327a689@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 17, 2023 at 09:57:55AM +0200, Christian Brauner wrote:
> BTW, why is there no code to lookup a bdev by O_PATH fd? It seems weird
> that a lot of ioctls pass the device path to the kernel (btrfs comes to
> mind). I can see certain things that would make this potentially a bit
> tricky e.g., you'd not have access to the path/name of the device if you
> want to show it somewhere such as in mountinfo but nothing that makes it
> impossible afaict.

As far as I can tell you should be able to hold a reference to a block
device file descriptor with an O_PATH fd.   Or did I miss something
that specifically prohibits that?

> Yeah, I'll get to this soon. Josef has mentioned that he'll convert
> btrfs to the new mount api this cycle and we have that recorded on
> video. And I think that otherwise all block device based filesystems
> might have already been converted.

Btrfs is the last "big" file system, but there plenty more.  A quick
grep for mount_bdev fills more than a page on my terminal..
