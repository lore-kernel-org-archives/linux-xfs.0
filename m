Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6FFCEB64D9
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 07:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjGLHT2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 03:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjGLHT1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 03:19:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE84B9C
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 00:19:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54239615BC
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 07:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B85BC433C7;
        Wed, 12 Jul 2023 07:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689146365;
        bh=uq+rt0VoJyI87V4xJA95oJ7OGflq/02vQmZW5VzQ1gY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bxJFTNk1CBmdj+olMQ58UX/yiR3dQG2+ac74hxdMzeWbch57JkxPiqKZZnTOND0pR
         Fz1a9hSaMiLbrYt0e1VRVJa+2F1hVnJj+w2ERoNaKuV4Z+oyXJpP/OT7PoEAd1E37f
         AdxRFFrZi/34MBGfdyd6AelJsqmhmU3a5CRFtmEpBeOkjjhO3HlRdJCKYNp+4rFHG9
         IB8HB2Hg1fNAhfhpvluiyDcZTK9jue4oH9ZoMAxE7j2wmd7bvsSUQ6YKDhfdkOUDUZ
         /gsmtagplAtgvHv9Z4QWgWRPKSr7E44GKA9707I8oX6SgyK/1kOx9Yw5rc2n07Pb1C
         1gQvdZ6f4j47A==
Date:   Wed, 12 Jul 2023 09:19:21 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] misc: remove bogus fstest
Message-ID: <20230712071921.apdvx34iohqlqsmx@andromeda>
References: <DNb0uIBsmTk-4VL37ZmBH-nqyWm2cSqdM-Zd_bAXcZPV1pCBQsbvInqpO9Y-wscHogOqvlrjO_98ujQlmB6EEg==@protonmail.internalid>
 <20230709223750.GC11456@frogsfrogsfrogs>
 <20230711132454.y4jmjlwyuhxmeylc@andromeda>
 <20230711145441.GB108251@frogsfrogsfrogs>
 <h8Qt0-HKorFHK6L7J-S372p9ryurQZbvCz9OlGiEWb1atBk5mzn54uniz5RFn2alUgb33Jm11S4BsEcKIxx71w==@protonmail.internalid>
 <ZK3r9Q1vLrRnfPE/@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZK3r9Q1vLrRnfPE/@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 12, 2023 at 09:55:33AM +1000, Dave Chinner wrote:
> On Tue, Jul 11, 2023 at 07:54:41AM -0700, Darrick J. Wong wrote:
> > On Tue, Jul 11, 2023 at 03:24:54PM +0200, Carlos Maiolino wrote:
> > > On Sun, Jul 09, 2023 at 03:37:50PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > >
> > > > Remove this test, not sure why it was committed...
> > > >
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  tests/xfs/999     |   66 -----------------------------------------------------
> > > >  tests/xfs/999.out |   15 ------------
> > > >  2 files changed, 81 deletions(-)
> > > >  delete mode 100755 tests/xfs/999
> > > >  delete mode 100644 tests/xfs/999.out
> > >
> > > Thanks for spotting it. I'm quite sure this was a result of my initial attempts
> > > of using b4 to retrieve the xfsprogs patch from the list, and it ended up
> > > retrieving the whole thread which included xfstests patches.
> > >
> > > Won't happen again, thanks for the heads up.
> >
> > Well I'm glad that /one/ of us now actually knows how to use b4, because
> > I certainly don't.  Maybe that's why Konstantin or whoever was talking
> > about how every patch should include a link to a gitbranch or whatever.
> 
> If all you want to do is pull stuff from the mailing list, then all
> you need to know is this command:
> 
> 'b4 am -o - <msgid> | git am -s'
> 
> This pull the entire series from the thread associated with that
> msgid into the current branch with all the rvb/sob tags updated. I
> -think- this has all been rolled up into the newfangled 'b4 shazam'
> command, but I much prefer to use the original, simple, obvious
> put-the-pieces-together-yourself approach.

This was exactly the case, the problem is, both xfstests patch and its xfsprogs
counterpart were sent under the same thread, which caused b4 to pull both of
them.
What I noticed (and haven't until I looked a bit deeper during my PTO) is that
b4 has an option to pull the patches into quilt format, so, that will make
things way easier.

Eitherway, I spoke with Darrick past night, and I'll rebase for-next to get rid
of that patch, there is no point in pushing it to a new xfsprogs release.

-- 
Carlos

> 
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
