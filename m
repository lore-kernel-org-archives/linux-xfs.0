Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF4FC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jul 2022 01:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbiGLBxz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 21:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiGLBxy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 21:53:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C517611179
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jul 2022 18:53:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4876A61653
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jul 2022 01:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF26C34115;
        Tue, 12 Jul 2022 01:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657590832;
        bh=Aa5j6iPT+Kfg+OmmpwQplM6FL9NxFVmkvcFJ/rOABTw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eF9JUvFd9edYL6gsx9c5jAct3s67L9VzU0Kd7T34PcunLWF94g5a23lC67y5z+Zc3
         V9vRzGypWM4TDPqsWs7l1wwI4vRZssfmPZLrk5qwFkXT8FJEa2uS6Gbhnc6ykQfaUy
         O4UrKzlr2U9/VCoLlSAZaV4Yr9+VE3GcZOaDmY9WVDtNPee0oIkJ2yh6ZDyx5iM119
         U7abEV/NZOidAU8z4o+00+o+mk7cFW+RSDj1F4urz+rkuoOMoguG83977Ejpa23CVN
         dO8TAu+aKiZif/HnJ3j3HWrY3aXI1MF0gws0oBkaQLlm0Ma8sCsNwH3lFa/UlEswoL
         VHDCPhsxuZ7qw==
Date:   Mon, 11 Jul 2022 18:53:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, allison.henderson@oracle.com
Subject: Re: [PATCHSET v2 0/5] xfs: make attr forks permanent
Message-ID: <YszUMHbqe+vCAdYx@magnolia>
References: <165740691606.73293.12753862498202082021.stgit@magnolia>
 <Ysu0V1mQovrXQiEo@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ysu0V1mQovrXQiEo@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 10, 2022 at 10:25:43PM -0700, Christoph Hellwig wrote:
> On Sat, Jul 09, 2022 at 03:48:36PM -0700, Darrick J. Wong wrote:
> > Although the race condition itself can be fixed through clever use of a
> > memory barrier, further consideration of the use cases of extended
> > attributes shows that most files always have at least one attribute, so
> > we might as well make them permanent.
> 
> I kinda hat increase the size of the inode even more, but there is no
> arguing about keeping nasty rarely used code simple vs micro-optimizing
> it.  Do you have numbers on hand on how many inodes we can cache in
> an order 0 or 1 cache before and after this?

Hm.  On my laptop running 5.18, xfs_inode before the change was 928 bytes,
and here's what it looks like:

			928 bytes
Order	Pagebytes	Slack	Objs	Slack/Objs
0	4096		384	4	96
1	8192		768	8	96
2	16384		608	17	36
3	32768		288	35	9
4	65536		576	70	9

So I guess that's why it picks order-3 slabs.

On a freshly built djwong-dev kernel, it's now 976 bytes:

			976 bytes
Order	Pagebytes	Slack	Objs	Slack/Objs
0	4096		192	4	48
1	8192		384	8	48
2	16384		768	16	48
3	32768		560	33	17
4	65536		144	67	2

Here it seems to pick order-2 slabs, which admittedly isn't great.

--D
