Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 591A4C7EE24
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 16:04:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236354AbjFFQES (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 12:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbjFFQER (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 12:04:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F063212D
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 09:04:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C8F562C41
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 16:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0A8C433D2;
        Tue,  6 Jun 2023 16:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686067456;
        bh=Gyjdrg9z9ER8pdB5U/cKhZKfGYJjX4KHeaHzvLwx28Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nUpQlrPnZjkF8gaUqnpRSUhRglNbx1Op9G4iZMTafArY6aqcbNj1QknqIt6kzqFIU
         2JUAPF99ZXrfGsYwGy2UpAM39FWE6oOqI7OiEld1hvFad+wB5Vhy4NfFt0Ve0Zy5p1
         k5cujE2Deryk0XDmOOiBIgK3pCZqaZ5DUbrPP7eRXEX+fJMw67Y1iIWN7SLfNY6NoJ
         3DfAz3f46BcD8+ADwUtoPqofEMpPncjVzu5yMc4CApjyCxqCXs/7oEMskoC3nXJ4zU
         EboF8qhUuVQs17qnP+uUcFGOQnqr0MgL1NM+dN1lX2B1AYFP/86S6x+3dqvgRo7vOS
         b/yqouiQW6pow==
Date:   Tue, 6 Jun 2023 18:04:11 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V2 00/23] Metadump v2
Message-ID: <20230606160411.xxvny2bbqpyrdvwr@andromeda>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
 <20230606121017.zvq6d2f4vdroh66q@andromeda>
 <ckqFNm-jDn6ZRkc8bkg_j6755DAjtYc81wdBLt60rMlaHDS3H5pAh0kBRja8qtMHWcRF962bDmSVreTA7Nks7g==@protonmail.internalid>
 <87ttvkhif2.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ttvkhif2.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2023 at 06:08:12PM +0530, Chandan Babu R wrote:
> On Tue, Jun 06, 2023 at 02:10:17 PM +0200, Carlos Maiolino wrote:
> > On Tue, Jun 06, 2023 at 02:57:43PM +0530, Chandan Babu R wrote:
> >> Hi all,
> >>
> >> This patch series extends metadump/mdrestore tools to be able to dump
> >> and restore contents of an external log device. It also adds the
> >> ability to copy larger blocks (e.g. 4096 bytes instead of 512 bytes)
> >> into the metadump file. These objectives are accomplished by
> >> introducing a new metadump file format.
> >>
> >> I have tested the patchset by extending metadump/mdrestore tests in
> >> fstests to cover the newly introduced metadump v2 format. The tests
> >> can be found at
> >> https://github.com/chandanr/xfstests/commits/metadump-v2.
> >>
> >> The patch series can also be obtained from
> >> https://github.com/chandanr/xfsprogs-dev/commits/metadump-v2.
> >
> > There is already a V2 on the list, why is this also tagged as V2?
> 
> The "v2" mentioned in "Metadump v2" refers to the newer version of metadump
> ondisk layout to support

Sorry the noise, I didn't get through the patches yet, just read 2 threads with
the same subject (without spotting the actual V2 in the patch metadata). Thanks,
my bad. :)

> 1. Dumping metadata from external log device and
> 2. Dumping larger extents (4096 bytes instead of 512 bytes).
> 
> --
> chandan
