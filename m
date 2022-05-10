Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 357D5C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 05:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbiEJFSb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 01:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235008AbiEJFSb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 01:18:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57602A83FB
        for <linux-xfs@vger.kernel.org>; Mon,  9 May 2022 22:14:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31703B81816
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 05:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18F3C385A6;
        Tue, 10 May 2022 05:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652159671;
        bh=SGH6OItYppxGhWno/2nJospgS8wRFEgstrjtteDLasg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VnZk7A0LQGiuwe7/sa41KAeJO3cegZ/Abxx5thv6yCZSf+v+rNMQjMVO3zqaOiGwn
         Ytss7U/jILH46ZsavVSIv0Wtu2AzFjtbuy3imjvT9jzSWlCShqXnwr/I5pg2RAAIq2
         hUf/Vm8vjmQuiJUeKPmb7z3IEaNDBo0fX8E53U0PldmYSU8NNMt+0Yp0HC+dZwwj5X
         lrDnc5iyOuwBjTC63zoOLNtNpXccxmiWfPk1SobStcP0nd8lrteeKlLRCTAuvKQ/LA
         t42RUJhvE06FfnzbpCH/YcKw+ichrmqm8A1z8wYLJ9soZ3chxQwlE8UQoiPaQOhZdo
         +jysHDDTaoL7A==
Date:   Mon, 9 May 2022 22:14:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chris Dunlop <chris@onthe.net.au>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: Highly reflinked and fragmented considered harmful?
Message-ID: <20220510051431.GZ27195@magnolia>
References: <20220510025541.GA192172@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510025541.GA192172@onthe.net.au>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 10, 2022 at 12:55:41PM +1000, Chris Dunlop wrote:
> Hi Dave,
> 
> On Tue, May 10, 2022 at 09:09:18AM +1000, Dave Chinner wrote:
> > On Mon, May 09, 2022 at 12:46:59PM +1000, Chris Dunlop wrote:
> > > Is it to be expected that removing 29TB of highly reflinked and fragmented
> > > data could take days, the entire time blocking other tasks like "rm" and
> > > "df" on the same filesystem?
> ...
> > At some point, you have to pay the price of creating billions of
> > random fine-grained cross references in tens of TBs of data spread
> > across weeks and months of production. You don't notice the scale of
> > the cross-reference because it's taken weeks and months of normal
> > operations to get there. It's only when you finally have to perform
> > an operation that needs to iterate all those references that the
> > scale suddenly becomes apparent. XFS scales to really large numbers
> > without significant degradation, so people don't notice things like
> > object counts or cross references until something like this
> > happens.
> > 
> > I don't think there's much we can do at the filesystem level to help
> > you at this point - the inode output in the transaction dump above
> > indicates that you haven't been using extent size hints to limit
> > fragmentation or extent share/COW sizes, so the damage is already
> > present and we can't really do anything to fix that up.
> 
> Thanks for taking the time to provide a detailed and informative
> exposition, it certainly helps me understand what I'm asking of the fs, the
> areas that deserve more attention, and how to approach analyzing the
> situation.
> 
> At this point I'm about 3 days from completing copying the data (from a
> snapshot of the troubled fs mounted with 'norecovery') over to a brand new
> fs. Unfortunately the new fs is also rmapbt=1 so I'll go through all the
> copying again (under more controlled circumstances) to get onto a rmapbt=0
> fs (losing the ability to do online repairs whenever that arrives -
> hopefully that won't come back to haunt me).

Hmm.  Were most of the stuck processes running xfs_inodegc_flush?  Maybe
we should try to switch that to something that will stop waiting after
30s, since most of the (non-fsfreeze) callers don't actually *require*
that the work actually finish, they're just trying to return accurate
space accounting to userspace.

> Out of interest:
> 
> > > - with a reboot/remount, does the log replay continue from where it left
> > > off, or start again?
> 
> Sorry, if you provided an answer to this, I didn't understand it.
> 
> Basically the question is, if a recovery on mount were going to take 10
> hours, but the box rebooted and fs mounted again at 8 hours, would the
> recovery this time take 2 hours or once again 10 hours?

In theory yes, it'll restart where it left off, but if 10 seconds go by
and the extent count *hasn't changed* then yikes did we spend that
entire time doing refcount btree updates??

--D

> Cheers,
> 
> Chris
