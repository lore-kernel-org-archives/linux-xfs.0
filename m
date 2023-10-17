Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD68CDB465
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 00:48:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233549AbjJQAse (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Oct 2023 20:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234300AbjJQAse (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2023 20:48:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA02ED
        for <linux-xfs@vger.kernel.org>; Mon, 16 Oct 2023 17:48:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50498C433CA;
        Tue, 17 Oct 2023 00:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697503712;
        bh=BTnAVfMQCUMCUQz+6fvhGPjTRKl/pPMR/28Cb9Cp3jk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I+8i33YEIih0HbXxa1+4BfHmj5CGlSq7lD9BcbRZTxgGsC7cDwxD0+7gwjqxmgoY6
         Cn2+E8uQvoI3QzuFn16HFpvoxXrNhMJJvyfVF/IIK/UDWuSPaa13QboCv3SXLohGZP
         K810cSRPGJRlbvoM3A2brjCnwC2ayNzqhxqIhCtlpodRloIux75n4JXfj0nHusBnDn
         64+LGRIwjrtfrP0Y6XvpFGX8GVJXaHFZOk7VZT6++ZBQ0Ogr9RnjJDCz/oGbqjhCvX
         xp/F7BPfQvNXGbD2hhDJMI1YdJVx/L5UX9aHDYXBla88/EfhIq368aKCowuYp8ZtZt
         t/8ON0kZuNPsQ==
Date:   Mon, 16 Oct 2023 17:48:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com
Subject: Re: [PATCHSET RFC v1.0 0/7] xfs: clean up realtime type usage
Message-ID: <20231017004831.GD11402@frogsfrogsfrogs>
References: <20231011175711.GM21298@frogsfrogsfrogs>
 <169704720721.1773388.10798471315209727198.stgit@frogsfrogsfrogs>
 <20231012050527.GJ1637@lst.de>
 <20231012223000.GR21298@frogsfrogsfrogs>
 <20231013042434.GB5562@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231013042434.GB5562@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 13, 2023 at 06:24:34AM +0200, Christoph Hellwig wrote:
> On Thu, Oct 12, 2023 at 03:30:00PM -0700, Darrick J. Wong wrote:
> > The primary advantage that I can think of is code readability -- all the
> > xfs_*rtb_ functions take xfs_rtblock_t types, and you can follow them
> > all the way through the rt allocator/rmap/refcount code.  xfs_rtblock_t
> > is a linear quantity even with rtgroups turned on.
> > 
> > The gross part is that one still has to know that br_startblock can be
> > either xfs_fsblock_t or xfs_rtblock_t depending on inode and whichfork.
> 
> Yeah.
> 
> > That said, I don't think gcc actually warns about silent casts from
> > xfs_fsblock_t to xfs_rtblock_t.
> 
> 
> typedefs in C are syntactix shugar.  You will never get a warning about
> mixing typedefs for the same underlying type (and often also not for
> mixing with other integer types).  Having an annotation for a strong
> typedef that can only do arithmetic on itself without casts or special
> annotations would be really handy, though.

We can do it crappily in C with __bitwise and letting the static checker
bots go wild.  Some day when someone rewrites the entire codebase in
Rust (HA!) then we'll be able to do:

struct xfs_fsblock_t(u64);
struct xfs_agblock_t(u32);

and (to the extent that I understand Rust) the Rust compiler will
complain about stuffing xfs_agblock_t into an xfs_fsblock_t without a
proper conversion.

--D
