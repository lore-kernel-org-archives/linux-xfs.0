Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D92AEC4332F
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Nov 2022 09:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiKDJWl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Nov 2022 05:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiKDJWk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2022 05:22:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF982A704
        for <linux-xfs@vger.kernel.org>; Fri,  4 Nov 2022 02:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667553700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7AZ6XCLS/v9TpTfa5o9Owwxi9jV58VuIiPo0deFIEpg=;
        b=QYb19s+/MJ8zKan4kkmT7LetlQz9/WkP2WSWhMgq1EUmgeHQqKFsMkQ5yLuYI251IXpjd7
        +JUtx26IlWXcLS2cAijFE6IXNADWcaMpDyYlPPCqh/Bg8GjIHEu0cB3iHCO9hM+z9zos4F
        au0ugtWlpgPuh8O94w+ahJcJaf6RHAg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-195-HAdN2d1HPRu8KgAmjFdxdg-1; Fri, 04 Nov 2022 05:21:36 -0400
X-MC-Unique: HAdN2d1HPRu8KgAmjFdxdg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B552101A54E;
        Fri,  4 Nov 2022 09:21:36 +0000 (UTC)
Received: from fedora (ovpn-193-165.brq.redhat.com [10.40.193.165])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EA8AE40C6EE9;
        Fri,  4 Nov 2022 09:21:34 +0000 (UTC)
Date:   Fri, 4 Nov 2022 10:21:32 +0100
From:   Lukas Czerner <lczerner@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Lukas Herbolt <lukas@herbolt.com>
Subject: Re: [PATCH] xfs: Print XFS UUID on mount and umount events.
Message-ID: <20221104092132.32asumwjzrjp67sh@fedora>
References: <l2a3zCkMp4g9yjUsn7MdftktWgI6xqW45ngK9WGU8-OQp_SWHRFpO5xZbUySxT3QRk1C4PyeLgqoVEY3VRRH_w==@protonmail.internalid>
 <f23e8ec8-b4cc-79d2-95b5-df4821878f91@sandeen.net>
 <20221103133252.ycw5awieh7ckiih7@ovpn-192-135.brq.redhat.com>
 <20221103205107.GG3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103205107.GG3600936@dread.disaster.area>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
> 
> -Dave.

I agree that it's easy to do. But the reason I wanted to at least have
the discussion about an alternate way of doing this is that I remember a
discussion at Plumbers, or LFS/MM where people were opposed to putting
more and more UUID and other ugly identifiers into kernel log. My memory
is hazy now, but either you or Christoph may have been one of those
people.

But if the consensus shifted since then, I am fine with that.

Thanks!
-Lukas

> -- 
> Dave Chinner
> david@fromorbit.com
> 

