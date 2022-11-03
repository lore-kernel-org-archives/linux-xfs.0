Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2CEAC433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Nov 2022 22:42:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbiKCWmL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Nov 2022 18:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiKCWmJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2022 18:42:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FFE1EC7F
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 15:42:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8045AB82A3F
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 22:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03627C433C1;
        Thu,  3 Nov 2022 22:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667515326;
        bh=gOByN7HAbbFglgHmbEX7l1ZWSEWQwvL1kdJoOhmb9I0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IKkp3s4QarS2gsHXscQZzj0pm1FLYY+EVh2qlxwe392ogpPl4rrXDLTiZfwCKKwDF
         dNZqXvOfSGLzPFbM9bfn6e2JL8QqhAgIpLazQVU/O0C5swSMD6DfxUbLOHDJsM3w9g
         yfQLCKrOZogTNN/IU4u35h7DBiwQtEAuQ6YxdAzFbXhOw3xJQYvZZoeVDE84JnCN5X
         sjBLeYExd+Kjux8IOLlVNuWzaQO5ZVU+v6sqI9/DuO1eUtXyqrgpoiTgg9/BYj+h67
         dAU8eemOr+HBDyPcnRMtUxOixlvlfzbNf8xGQV9iwiqSlConnFHd7953iuNtAJEHuX
         yYI4/4jqtYYlw==
Date:   Thu, 3 Nov 2022 15:42:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Lukas Czerner <lczerner@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        xfs <linux-xfs@vger.kernel.org>,
        Lukas Herbolt <lukas@herbolt.com>
Subject: Re: [PATCH] xfs: Print XFS UUID on mount and umount events.
Message-ID: <Y2RDvUWqLY1kQ24X@magnolia>
References: <l2a3zCkMp4g9yjUsn7MdftktWgI6xqW45ngK9WGU8-OQp_SWHRFpO5xZbUySxT3QRk1C4PyeLgqoVEY3VRRH_w==@protonmail.internalid>
 <f23e8ec8-b4cc-79d2-95b5-df4821878f91@sandeen.net>
 <20221103133252.ycw5awieh7ckiih7@ovpn-192-135.brq.redhat.com>
 <20221103205107.GG3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103205107.GG3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 04, 2022 at 07:51:07AM +1100, Dave Chinner wrote:
> On Thu, Nov 03, 2022 at 02:32:52PM +0100, Lukas Czerner wrote:
> > On Tue, Nov 01, 2022 at 12:19:06PM -0500, Eric Sandeen wrote:
> > > From: Lukas Herbolt <lukas@herbolt.com>
> > > 
> > > As of now only device names are printed out over __xfs_printk().
> > > The device names are not persistent across reboots which in case
> > > of searching for origin of corruption brings another task to properly
> > > identify the devices. This patch add XFS UUID upon every mount/umount
> > > event which will make the identification much easier.
> > > 
> > > Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> > > [sandeen: rebase onto current upstream kernel]
> > > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > 
> > Hi,
> > 
> > it is a simple enough, nonintrusive change so it may not really matter as
> > much, but I was wondering if there is a way to map the device name to
> > the fs UUID already and I think there may be.
> > 
> > I know that udev daemon is constantly scanning devices then they are
> > closed in order to be able to read the signatures. It should know
> > exactly what is on the device and I know it is able to track the history
> > of changes. What I am not sure about is whether it is already logged
> > somewhere?
> > 
> > If it's not already, maybe it can be done and then we can cross
> > reference kernel log with udev log when tracking down problems to see
> > exactly what is going on without needing to sprinkle UUIDs in kernel log ?
> > 
> > Any thoughts?
> 
> Don't like it. Emitting the UUID on the fs mount/unmount log message
> is a trivial change that has zero impact on anything as well as
> being really easy for log scrapers to deal with.
> 
> Screwing around with udev to manage and/or find this correlationi
> is ... unnecssarily awful.

/me wonders what problem is needing to be solved here -- if support is
having difficulty mapping fs uuids to block devices for $purpose, then
why not capture the blkid output in the sosreport and go from there?

That said, I thought logging the super device name ("sda1") and the fs
uuid in dmesg was sufficient to accomplish that task?

/me shrugs, doesn't understand, wanders off to more code refactoring...

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
