Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DBA7C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Nov 2022 19:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbiKVTtM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Nov 2022 14:49:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234677AbiKVTtA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Nov 2022 14:49:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653EA7C6A5
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2022 11:48:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 023E76186E
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2022 19:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62AC0C433D6;
        Tue, 22 Nov 2022 19:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669146538;
        bh=S6xM65jDUpzmhwNGsIFkku4eTe6QAwD2qFn/6A3ct58=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lz7An4DrVg4+J3gNY12WLGhqJJHjiJY5ZRiSTGUgTIYY7KmDJtRhYEWniLS8X+psG
         o+1QgZm2UZuRTwqgtxMm4NfHemIsg5AQRT+3Tbydl+8SvDBOfUkBMbqHVdzorh+nVT
         6kTrFTuQN6zYntw7gndZK7yhe2gtpUq62Oc4Vcv1UTtHzRNNSi9rViW3S4ogOqczik
         MnO5kYF6eLVMVtzDPhFzOnvFcLnYM1KsgkH1WEK4yVumq78KeaqzdrE0X3duEnPcnZ
         A1aQqOfFifhi8d5WSqCcGD6ZJrnoyMchSENOd4oiukMQOxhZhRD9Ye40NdjoenbT9f
         uGDB1wuGjU16A==
Date:   Tue, 22 Nov 2022 11:48:57 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsprogs for-next branch updated
Message-ID: <Y30nqbt/t1YYEgyS@magnolia>
References: <20221121143547.m33n36fufbz2x626@andromeda>
 <0bul_4vxtkpTuol85qbMYtteFmwirc1b8DMYjMK3wzADXA9cxc37kwbs_lr1fMsI_58SzPV43qMy24wj3tGdKw==@protonmail.internalid>
 <Y3wW9SCRYmBX3K9a@magnolia>
 <20221122095300.lt5mwo4lhqr4vlwx@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122095300.lt5mwo4lhqr4vlwx@andromeda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 22, 2022 at 10:53:00AM +0100, Carlos Maiolino wrote:
> On Mon, Nov 21, 2022 at 04:25:25PM -0800, Darrick J. Wong wrote:
> > On Mon, Nov 21, 2022 at 03:35:47PM +0100, Carlos Maiolino wrote:
> > > Hello.
> > >
> > > The xfsprogs, for-next branch located at:
> > >
> > > https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/log/?h=for-next
> > >
> > > has just been updated.
> > >
> > > The new head is:
> > >
> > > b827e2318 xfs: fix sb write verify for lazysbcount
> > >
> > >
> > > This update contains only the libxfs-sync for Linux 6.1, and will serve as a
> > > base for the xfsprogs 6.1 release.
> > > Please, let me know if any issue.
> > >
> > >
> > > The following commits are now in the for-next tree:
> > >
> > > [b827e2318] xfs: fix sb write verify for lazysbcount
> > 
> > Why was this commit merged for xfsprogs 6.1?  That patch is queued for
> > kernel 6.2 in for-next, but the merge window is not open yet.
> > 
> 
> Since 6.1 isn't out yet, I did a `libxfs-apply <last libxfscommit>..`, my fault
> for not spotting you've patches already queued for 6.2. I'm planning to release
> xfsprogs-6.1 some time later after linux 6.1 is out, so this patch will already
> be in Linus's tree by the time. I can also get this patch out of the tree when I
> push the other patches I have queued up, although I'm trying to avoid doing
> forced updates to the tree. Is it ok for you to leave it in the tree, or better
> remove it by now?

For this one patch it doesn't matter since the race only happens when
there are multiple threads updating the inode summary counts.  Userspace
doesn't do any concurrent inobt updates, so the fix arriving early ought
to be benign.

(That said, the only thing you have to do if you push -f is let everyone
know that for-next has been **REBASED**, but I agree with the sentiment
of only doing it when it's really important.)

--D

> Cheers
> 
> -- 
> Carlos Maiolino
