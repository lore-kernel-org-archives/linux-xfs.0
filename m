Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF62BC38A2D
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Oct 2022 01:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiJZB2x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 21:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbiJZB2w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 21:28:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22EB2DBE5E
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 18:28:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0396B81F88
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 01:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52654C433D7;
        Wed, 26 Oct 2022 01:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666747729;
        bh=tUhL/gbYsCQ2gtBG2275b0e3NEZNlnnhRf9D3DM1YfE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ohMhh1NPzJvnnEIC4InyIpCzaRYjNX4Q8SN5d9YnEP8lqPPG56/iH98SwUi9p5qNC
         VhbSAT/Ex194utBdicsUEYUnVZYo0e3gJkkCCBc+bmBJ8sYP8eaHQJ6SnISzVq1gTM
         UM8DFqmFE4PnDtLrNfPumG3uF1QkIm4khhenjsEIvMbVYVpmrw8S4iWYYgJXD2C87F
         TnofhuOexAYbY+QJIIMIrviFcGGvEIfrEHz8v8dLZ+JTYRHw1iOndQDJey4t6I6tVK
         4GwCyFWVu0mkc9Q4erN/5b63k5pR+o6ZfRdQ3SXPh+aRGqea6jwokqfqmuwJsfkgPF
         Qd1S+H+JJ2lxA==
Date:   Tue, 25 Oct 2022 18:28:48 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: check deferred refcount op continuation
 parameters
Message-ID: <Y1iNUJ9qmDZyD6pn@magnolia>
References: <166664718897.2690245.5721183007309479393.stgit@magnolia>
 <166664721743.2690245.17086652152508491843.stgit@magnolia>
 <20221026004603.GM3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026004603.GM3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 26, 2022 at 11:46:03AM +1100, Dave Chinner wrote:
> On Mon, Oct 24, 2022 at 02:33:37PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > If we're in the middle of a deferred refcount operation and decide to
> > roll the transaction to avoid overflowing the transaction space, we need
> > to check the new agbno/aglen parameters that we're about to record in
> > the new intent.  Specifically, we need to check that the new extent is
> > completely within the filesystem, and that continuation does not put us
> > into a different AG.
> 
> Huh. Why would they not be withing the filesystem or AG, given that
> the current transaction should only be operating on an extent within
> the current filesystem/AG?

Math errors.

Callers of xfs_refcount_adjust_extents are supposed to split (and
update) any refcount records that cross the start or end of the range
that we're adjusting.  This guarantees that _adjust_extents will stop at
exactly the end of a refcount record.

However, if a record in the middle of that range has a blockcount that
is longer than *aglen at the point that we encounter the record, we'll
increment agbno beyond the range that we were supposed to adjust.  This
happens either because we fuzzed the refcountbt deliberately, or ...
because we actually did write the refcountbt record block but due to
bugs on the vm host, the write was silently dropped and memory pressure
caused the xfs_buf to get reclaimed and reloaded with stale contents.

(That's an argument for making xfs_refcount_adjust_extents check that
*aglen never underflows; I'll update the patch.

Oh.  I already wrote that patch, but forgot to add it to this series.
Sigh.)

If agbno is now large enough that the segmented xfs_fsblock_t points
into a nonexistent AG, bad things will happen.

> IIUC, this is code intended to catch the sort of refcount irec
> startblock corruption that the series fixes, right? If so, shouldn't it be
> first in the patch series, not last?

<shrug> Based on reviewer feedback over the last few years I got in the
habit of putting the actual bug fixes at the front of the series.
Patches adding more layers of checking so that we can die gracefully
ended up after that.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
