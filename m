Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA8F1C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jul 2022 21:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbiGYVES (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Jul 2022 17:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbiGYVEI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jul 2022 17:04:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E47237CB
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jul 2022 14:04:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31BDE61209
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jul 2022 21:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A7EC341C6;
        Mon, 25 Jul 2022 21:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658783046;
        bh=cdIuVU/hLm6Bi/W4YO0xrgrkvKNnO7X5eXx60BReEIg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G4HnF0MRZe5EPHovtmxus348MOaGp70t7kWfB0vAEuoSSZtRoZCFMRt+5BCvDHnVy
         eofcSCzzNdcmCEtpLJMHexAZ/GV1j0/scQ3IcvBh/6SbUnuqvirmbNMm8hyg6ESmp3
         PY6GeLHkxZvoWHjxgUDJWoQGS56+gPkfQf35BgGXwflkQQGUDsbi0ekqfh/Zuny/Xs
         5jujgQCMCIGmWU/y6DMj6YV9YeDzLwrLNSuB0WcjV2JWNQfcpEmmvt9vnvuLCISnvB
         gdZVzM1QhdqBiR3uBVv+KsPSZmWuQqsHZ+Ig5VR6VmjWIB4+JAiZJIbrrlcuZo/0/u
         BzNqNX6HPvvww==
Date:   Mon, 25 Jul 2022 14:04:06 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v3 0/2] mkfs: stop allowing tiny filesystems
Message-ID: <Yt8FRiODvmtDxrL0@magnolia>
References: <jClQwnsHFSREVSitFnWiO2spgHLt1kaTBHjtDn1V9WeXRB1qq0BOBhwGw25IoTL-aMmeeElWwy2pVsHv9ywuMA==@protonmail.internalid>
 <165826709801.3268874.7256134380224140720.stgit@magnolia>
 <20220725075942.erejjxcyjkyhopa3@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725075942.erejjxcyjkyhopa3@orion>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 25, 2022 at 09:59:42AM +0200, Carlos Maiolino wrote:
> On Tue, Jul 19, 2022 at 02:44:58PM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > The maintainers have been besieged by a /lot/ of complaints recently
> > from people who format tiny filesystems and growfs them into huge ones,
> > and others who format small filesystems.  We don't really want people to
> > have filesystems with no backup superblocks, and there are myriad
> > performance problems on modern-day filesystems when the log gets too
> > small.
> > 
> > Empirical evidence shows that increasing the minimum log size to 64MB
> > eliminates most of the stalling problems and other unwanted behaviors,
> > so this series makes that change and then disables creation of small
> > filesystems, which are defined as single-AGs fses, fses with a log size
> > smaller than 64MB, and fses smaller than 300MB.
> > 
> > v2: rebase to 5.19
> > v3: disable automatic detection of raid stripes when the device is less
> >     than 1G to avoid formatting failures
> > 
> > If you're going to start using this mess, you probably ought to just
> > pull from my git trees, which are linked below.
> > 
> > This is an extraordinary way to destroy everything.  Enjoy!
> > Comments and questions are, as always, welcome.
> > 
> 
> Both changes looks good to me, but IMHO we really require it to be documented in
> manpages otherwise we'll get (even more) questions about "why can't I create
> small FS'es anymore?".
> But anyway, I can help with the manpages once these patches hit for-next if you
> are ok with it.

Oooh, good point, Eric and I have been too busy figuring out the weird
corner cases and forgot that.  I'll add some manpage updates and send
that out tomorrow.

--D

> 
> -- 
> Carlos Maiolino
