Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F2CC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 19:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245647AbiDNTjF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 15:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235993AbiDNTjE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 15:39:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03E9ECB3E;
        Thu, 14 Apr 2022 12:36:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5610AB82922;
        Thu, 14 Apr 2022 19:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13748C385A5;
        Thu, 14 Apr 2022 19:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649964996;
        bh=q8+ZV5+hnyVUldAPUj6twn2XRjhodl/FgTVPB/Udg1U=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=loADvxJDMvMkUXQw02eeRUZIGzz9KzznYJyUgC8aMqSGRtgj41yex4rfTcXpxdh9b
         gsAoWvyJtkdL/KLrXOb4QTbUcrn9xczGLku06myQJC0d/2zFdqohya0G28u6Q8WuZi
         xjI8brAXDHN5RPyM0GrY2L5qpmEno/wsfS5puFuUXrGlZ0DUalCVSu0Eswkc+ywNsq
         GitQ4W1nGbA6cHOlMLThrTbZpv4tWPDR7F1xrabFyWLyNiMuRWFe3eiOVdKbySUJgV
         x3VPfUgncDdka4ue9PtlA0rRg7glAWjPPOaQsPa/SYTsC3F6JUTw0jG20WfnMoLM9T
         gQnRxw0lrQ0Lw==
Date:   Thu, 14 Apr 2022 12:36:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs/216: handle larger log sizes
Message-ID: <20220414193635.GA17025@magnolia>
References: <164971769710.170109.8985299417765876269.stgit@magnolia>
 <164971771391.170109.16368399851366024102.stgit@magnolia>
 <20220413174400.kvbihaz6bcsgz4hy@zlang-mailbox>
 <20220414015149.GD16774@magnolia>
 <20220414192531.56hn4igvgqikdryf@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414192531.56hn4igvgqikdryf@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 15, 2022 at 03:25:31AM +0800, Zorro Lang wrote:
> On Wed, Apr 13, 2022 at 06:51:49PM -0700, Darrick J. Wong wrote:
> > On Thu, Apr 14, 2022 at 01:44:00AM +0800, Zorro Lang wrote:
> > > On Mon, Apr 11, 2022 at 03:55:13PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > mkfs will soon refuse to format a log smaller than 64MB, so update this
> > > > test to reflect the new log sizing calculations.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  tests/xfs/216.out |   14 +++++++-------
> > > >  1 file changed, 7 insertions(+), 7 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/tests/xfs/216.out b/tests/xfs/216.out
> > > > index cbd7b652..3c12085f 100644
> > > > --- a/tests/xfs/216.out
> > > > +++ b/tests/xfs/216.out
> > > > @@ -1,10 +1,10 @@
> > > >  QA output created by 216
> > > > -fssize=1g log      =internal log           bsize=4096   blocks=2560, version=2
> > > > -fssize=2g log      =internal log           bsize=4096   blocks=2560, version=2
> > > > -fssize=4g log      =internal log           bsize=4096   blocks=2560, version=2
> > > > -fssize=8g log      =internal log           bsize=4096   blocks=2560, version=2
> > > > -fssize=16g log      =internal log           bsize=4096   blocks=2560, version=2
> > > > -fssize=32g log      =internal log           bsize=4096   blocks=4096, version=2
> > > > -fssize=64g log      =internal log           bsize=4096   blocks=8192, version=2
> > > > +fssize=1g log      =internal log           bsize=4096   blocks=16384, version=2
> > > > +fssize=2g log      =internal log           bsize=4096   blocks=16384, version=2
> > > > +fssize=4g log      =internal log           bsize=4096   blocks=16384, version=2
> > > > +fssize=8g log      =internal log           bsize=4096   blocks=16384, version=2
> > > > +fssize=16g log      =internal log           bsize=4096   blocks=16384, version=2
> > > > +fssize=32g log      =internal log           bsize=4096   blocks=16384, version=2
> > > > +fssize=64g log      =internal log           bsize=4096   blocks=16384, version=2
> > > 
> > > So this will break downstream kernel testing too, except it follows this new
> > > xfs behavior change. Is it possible to get the minimal log size, then help to
> > > avoid the failure (if it won't mess up the code:)?
> > 
> > Hmm.  I suppose we could do a .out.XXX switcheroo type thing, though I
> > don't know of a good way to detect which mkfs behavior you've got.
> 
> Don't need to take much time to handle it :) How about use a specified filter function,
> filter all log blocks number <= 16384, if the number of blocks=$number <= 16384, transform
> it to blocks=* or what anything else do you like ?
> 
> I think we don't really care how much the log size less than 64M, right? Just hope it
> works (can be mounted and read/write)?

<shrug> Well I already reworked this patch to create 216.out.64mblog and
216.out.classic, and symlink them to 216.out as appropriate given the
log size for a 512m log format, since it probably *is* a good idea to
make sure older mkfs doesn't stray.

--D

> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> > > 
> > > >  fssize=128g log      =internal log           bsize=4096   blocks=16384, version=2
> > > >  fssize=256g log      =internal log           bsize=4096   blocks=32768, version=2
> > > > 
> > > 
> > 
> 
