Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAACEC76195
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Mar 2023 01:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjC1Bii (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Mar 2023 21:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjC1Bii (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2023 21:38:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FADA1FEF
        for <linux-xfs@vger.kernel.org>; Mon, 27 Mar 2023 18:38:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DCF16155B
        for <linux-xfs@vger.kernel.org>; Tue, 28 Mar 2023 01:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE375C433D2;
        Tue, 28 Mar 2023 01:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679967516;
        bh=O1F9eYXqGVxHd2WJ++HyERgwAGWsTM4PN9ai7J6Sna0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HI64zs/RRVgUScC37Vn5i2xw0Y268oakV2seGfmqgyzZXeRfYAXVWj4X+l/4fMyB3
         CGOtRY5u9QUrBtkGMGYs39hCEJ3Vb4dP2uPNWAse7dG0sTq0wMkR35AMO3KB+au7Kk
         cLqpvspFYmqEXecQx11RQkTuHt5eTYyBg610qDlkC9nt71S5y9J0pFZrVJIn9+USKw
         EYrMXgkydvgUnz73c38VDjV/k/k1j39fcPkre8SU9pKY1w/rX8PJflZd4EL4XhnY5Q
         oiQr+sF4Q5cQy7o8xl73MSoEimmE4eyEbd6Uba9/iW+tBd2h3OxGVebflzfUqnoqcx
         XUGqFNYNH+tYQ==
Date:   Mon, 27 Mar 2023 18:38:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v1 0/4] setting uuid of online filesystems
Message-ID: <20230328013835.GF16180@frogsfrogsfrogs>
References: <20230314042109.82161-1-catherine.hoang@oracle.com>
 <20230314062847.GQ360264@dread.disaster.area>
 <953CAB5C-E645-4BB2-88E2-E992C5CC565D@oracle.com>
 <ZBZUcGLcTSgKVXa5@destitution>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBZUcGLcTSgKVXa5@destitution>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 19, 2023 at 11:16:48AM +1100, Dave Chinner wrote:
> On Thu, Mar 16, 2023 at 08:41:14PM +0000, Catherine Hoang wrote:
> > > On Mar 13, 2023, at 11:28 PM, Dave Chinner <david@fromorbit.com> wrote:
> > > 
> > > On Mon, Mar 13, 2023 at 09:21:05PM -0700, Catherine Hoang wrote:
> > >> Hi all,
> > >> 
> > >> This series of patches implements a new ioctl to set the uuid of mounted
> > >> filesystems. Eventually this will be used by the 'xfs_io fsuuid' command
> > >> to allow userspace to update the uuid.
> > >> 
> > >> Comments and feedback appreciated!
> > > 
> > > What's the use case for this?
> > 
> > We want to be able to change the uuid on newly mounted clone vm images
> > so that each deployed system has a different uuid. We need to do this the
> > first time the system boots, but after the root fs is mounted so that fsuuid
> > can run in parallel with other service startup to minimize deployment times.
> 
> Why can't you do it offline immediately after the offline clone of
> the golden image? I mean, cloning images and setting up their

That /is/ how they do it currently.  The goal here was to reduce the
number of scripts that then must be worked into every distro's bespoke
initrd generation system (update-initramfs, dracut, etc.).  Doing this
from systemd bypasses that, and it means it can get done in the
background during first boot, instead of rewriting superblocks in the
singlethreaded initramfs hot path during deployments.

They need the fsuuid to change after the VM starts up, but it doesn't
have to get done until just before we start handing out NFS leases.
Granted that was before we hit the wall of "lots of subsystems encode
the fs uuid into things and hand them out"...

> contents is something the external orchestration software does
> and will always have to do, so i don't really understand why UUID
> needs to be modified at first mount vs at clone time. Can you
> describe why it actually needs to be done after first mount?
> 
> > >>  xfs: add XFS_IOC_SETFSUUID ioctl
> > >>  xfs: export meta uuid via xfs_fsop_geom
> > > 
> > > For what purpose does userspace ever need to know the sb_meta_uuid?
> > 
> > Userspace would need to know the meta uuid if we want to restore
> > the original uuid after it has been changed.
> 
> I don't understand why you'd want to restore the original UUID given
> the use case you've describe. Can you explain the situation where
> you want to return a cloned image to the original golden image UUID?

I can't think of any, and was assuming that Catherine did that to
maintain parity with the offline fsuuid setting command...

--D

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
