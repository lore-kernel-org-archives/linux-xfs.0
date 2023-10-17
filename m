Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E2DCDB474
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 00:51:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbjJQAvN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Oct 2023 20:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233590AbjJQAvM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2023 20:51:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C76AF
        for <linux-xfs@vger.kernel.org>; Mon, 16 Oct 2023 17:51:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A69C433C8;
        Tue, 17 Oct 2023 00:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697503871;
        bh=rAwySVAhRAprSWZOLxywjKTEgwdcxUlHEyFui/QXvXU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IPaTF/s76KC/8mHwD8vdSM+LYO9VFAYTTm2H0C3TT0rE3q5axLNMZYdEMqTETzfhx
         QfaHB5icsre0rBZsCQThmnRXHMDgHAQU50X3/Jh8xboB77ntKwfACuYeSJqzRj4tWn
         miyWtAVtUG36pe7++P/fM7dSl9ARhXOBoVp8T7ZzkrE1+EqNQm1ryifTWki4n9y5e8
         Jkz4ze6sOlzwuZ5HC66bBQ7KU3z+YyEZWdWN+hcjUQIrp/J3g+EmhIldEqGDSj9R08
         3EprFw0ENa9EV9znsu+awTqi3WGay2P/oNzU9WopFdXamfE0tDDx5sItY24AgVqdox
         T0eCCSAGnRGug==
Date:   Mon, 16 Oct 2023 17:51:10 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: use shifting and masking when converting rt
 extents, if possible
Message-ID: <20231017005110.GF11402@frogsfrogsfrogs>
References: <169704721170.1773611.12311239321983752854.stgit@frogsfrogsfrogs>
 <169704721284.1773611.1915589661676489.stgit@frogsfrogsfrogs>
 <20231012052511.GF2184@lst.de>
 <20231012181908.GK21298@frogsfrogsfrogs>
 <ZS1ws+S+R9anbrdg@telecaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZS1ws+S+R9anbrdg@telecaster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 16, 2023 at 10:19:47AM -0700, Omar Sandoval wrote:
> On Thu, Oct 12, 2023 at 11:19:08AM -0700, Darrick J. Wong wrote:
> > On Thu, Oct 12, 2023 at 07:25:11AM +0200, Christoph Hellwig wrote:
> > > On Wed, Oct 11, 2023 at 11:06:14AM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Avoid the costs of integer division (32-bit and 64-bit) if the realtime
> > > > extent size is a power of two.
> > > 
> > > Looks good:
> > > 
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > 
> > > Do you have any data on how common non-power of two rtext sizes are?
> > > Might it be worth to add unlikely annotations?
> > 
> > I don't really know about the historical uses.  There might be old
> > filesystems out there with a non-power-of-2 raid stripe size that are
> > set up for full stripe allocations for speed.
> > 
> > We (oracle) are interested in using rt for PMD allocations on pmem/cxl
> > devices and atomic writes on scsi/nvme devices.  Both of those cases
> > will only ever use powers of 2.
> > 
> > I'll add some if-test annotations and we'll see if anyone notices. ;)
> > 
> > --D
> 
> We are using 1044KB realtime extents (blocksize = 4096, rextsize = 261)
> for our blob storage system. It's a goofy number, but IIRC it was chosen
> because their most common blob sizes were single-digit multiples of a
> megabyte, and they wanted a large-ish (~1MB) realtime extent size to
> reduce external fragmentation, but they also wanted to store a bit of
> extra metadata without requiring an extra realtime extent and blowing up
> internal fragmentation.

LOL, and here I thought I was only pushing weird sizes like 28k to drive
willy crazy. ;)  I wrapped some of the if tests in likely(); they can
get ripped back out.

--D
