Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CC8BCDB47E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 22:30:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347413AbjJLWaD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 18:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344180AbjJLWaD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 18:30:03 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076F4CF
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 15:30:01 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E183C433C8;
        Thu, 12 Oct 2023 22:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697149800;
        bh=XS/IZ73GRg4FDgZXabNnN/LglP9at4CrCPlWjLakCbY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eC/rdI4S6x8njn1/wYBbG/yCmQ9Hv/4Mf2yWz5nUQpUyXR5/QsZkd3xbPkwdiTIrS
         +woLQ6f3am2xzT/E/I4zrdhnEr0G163SRaPKzwTldP+8SvmqzPubRFilTmgaNvq5ve
         TRrSstB5t46F306DZb6MInudgSHfUU88psj9g4yv4Sz/bkoA6kUilRYMFpkADgQlcc
         2yVmXmcpxil2053pv6Tdxnwe1A9WjfrfVdqDEbYVyA6KRifw9oePDcNbcgFf0n4HoH
         Kdkxa7bk642JZWFe43+boAKyoKDBo9Mv/4TBt0E5zCKHweUWLGbBc3Cw2SbxiPA7E5
         VKzewVvpMjMqA==
Date:   Thu, 12 Oct 2023 15:30:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com
Subject: Re: [PATCHSET RFC v1.0 0/7] xfs: clean up realtime type usage
Message-ID: <20231012223000.GR21298@frogsfrogsfrogs>
References: <20231011175711.GM21298@frogsfrogsfrogs>
 <169704720721.1773388.10798471315209727198.stgit@frogsfrogsfrogs>
 <20231012050527.GJ1637@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012050527.GJ1637@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 07:05:27AM +0200, Christoph Hellwig wrote:
> On Wed, Oct 11, 2023 at 11:01:16AM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > The realtime code uses xfs_rtblock_t and xfs_fsblock_t in a lot of
> > places, and it's very confusing.  Clean up all the type usage so that an
> > xfs_rtblock_t is always a block within the realtime volume, an
> > xfs_fileoff_t is always a file offset within a realtime metadata file,
> > and an xfs_rtxnumber_t is always a rt extent within the realtime volume.
> 
> Question as a follow up:  now that we have proper types for all
> the RT-specific units, what's the point of even keeping xfs_rtblock_t
> around vs always using xfs_fsblock_t or xfs_rfsblock_t?

The primary advantage that I can think of is code readability -- all the
xfs_*rtb_ functions take xfs_rtblock_t types, and you can follow them
all the way through the rt allocator/rmap/refcount code.  xfs_rtblock_t
is a linear quantity even with rtgroups turned on.

The gross part is that one still has to know that br_startblock can be
either xfs_fsblock_t or xfs_rtblock_t depending on inode and whichfork.

That said, I don't think gcc actually warns about silent casts from
xfs_fsblock_t to xfs_rtblock_t.

--D
