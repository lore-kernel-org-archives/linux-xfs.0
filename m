Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6490C76188
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Apr 2023 15:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238409AbjDEPkZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 11:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237845AbjDEPkY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 11:40:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3813FAC
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 08:40:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9158628D9
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 15:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326F1C433EF;
        Wed,  5 Apr 2023 15:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680709223;
        bh=k8//CpAQikr7ukg8QHx0aN7/TvVW7LK9KAc31SOB0gE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pppx68jqofnQgtNLWRRbPD1ufLZKyvGJ0mDyRUBQUCz8klu4jqwJv4ImvPNPw8N4D
         8h8YoH0g5IOTibufT0aeYb0s1eJOdHnrDeEtj9/mzp1dp2oVecbpbEpDJA0P0sqhsV
         LkbLUY88abgQh503zM498apZbn2Bl6EcS68ZhNeny2raO30Pn+FVZHd3vun4//9FgF
         cAZmP2JluVKZ9vqvigcr8xFPYAd9g3OwrfRV0Jggi1D3H4gFGtNel8u419GfTeCpSs
         BcRWOd99tVxjKhUUmgvFFif4XXskFrlCL77/NfDVp65X9sVPeFA5x9nMjg70HsAe32
         JtpSsDn33QKAQ==
Date:   Wed, 5 Apr 2023 08:40:22 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/3] xfs: stabilize the tolower function used for
 ascii-ci dir hash computation
Message-ID: <20230405154022.GF303486@frogsfrogsfrogs>
References: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs>
 <168062802637.174368.12108206682992075671.stgit@frogsfrogsfrogs>
 <CAHk-=whe9kmyMojhse3cZ-zpHPfvGf_bA=PzNfuV0t+F5S1JxA@mail.gmail.com>
 <20230404183214.GG109974@frogsfrogsfrogs>
 <ZC0RaOeTFtCxFfhx@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZC0RaOeTFtCxFfhx@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 04, 2023 at 11:12:56PM -0700, Christoph Hellwig wrote:
> On Tue, Apr 04, 2023 at 11:32:14AM -0700, Darrick J. Wong wrote:
> > Yeah, I get that.  Fifteen years ago, Barry Naujok and Christoph merged
> > this weird ascii-ci feature for XFS that purportedly does ... something.
> > It clearly only works properly if you force userspace to use latin1,
> > which is totally nuts in 2023 given that the distros default to UTF8
> > and likely don't test anything else.  It probably wasn't even a good
> > idea in *2008*, but it went in anyway.  Nobody tested this feature,
> > metadump breaks with this feature enabled, but as maintainer I get to
> > maintain these poorly designed half baked projects.
> 
> IIRC the idea was that it should do 7-bit ASCII only, so even accepting
> Latin 1 characters seems like a bug compared to what it was documented
> to do.
> 
> > I wouldn't ever enable this feature on any computer I use, and I think
> > the unicode case-insensitive stuff that's been put in to ext4 and f2fs
> > lately are not a tarpit that I ever want to visit in XFS.  Directory
> > names should be sequences of bytes that don't include nulls or slashes,
> > end of story.
> 
> That works fine if all you care is classic Linux / Unix users.  And
> while I'd prefer if all the world was like that, the utf8 based CI
> has real use cases.  Initially mostly for Samba file serving, but
> apparently Wine also really benefits from it, so some people have CI
> directories for that.  XFS ignoring this means we are missing out on
> those usrers.

<shrug> Welllll... if someone presents a strong case for adopting the
utf8 casefolding feature that f2fs and ext4 added some ways back, I
could be persuaded to import that, bugs and all, into XFS.  However,
given all the weird problems I've uncovered with "ascii"-ci, I'm going
to be very hardnosed about adding test cases and making sure /all/ the
tooling works properly.

I wasn't thrilled at all the "Handle invalid UTF8 sequence as either an
error or as an opaque byte sequence." that went into the ext4 code.
While I concede that it's the least-legacy-code-regressive solution to
people demanding to create non-utf8 filenames on a "utf8-casefold"
filesystem, it's just ... compromised.

Really it's "utf8 casefolded lookups if all the names you create are
valid utf8 byte sequences, and if you fail at that then we fall back to
memcmp(); also there's a strict-utf8 creat mode but you can't enable it".

Gross.

> The irony is all the utf8 infrastruture was developed for XFS use
> by SGI, never made it upstream back then and got picked up for ext4.
> And while it is objectively horrible, plugging into this actually
> working infrastructure would be the right thing for XFS instead
> of the whacky ASCII only mode only done as a stepping stone while
> the utf8 infrastructure got finished.

fsdevel, the gift that keeps on giving...

--D
