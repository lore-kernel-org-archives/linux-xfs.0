Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB34C7EE23
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jun 2023 14:28:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235712AbjFGO2Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Jun 2023 10:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235633AbjFGO2P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jun 2023 10:28:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8960B1AE
        for <linux-xfs@vger.kernel.org>; Wed,  7 Jun 2023 07:28:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 229946398E
        for <linux-xfs@vger.kernel.org>; Wed,  7 Jun 2023 14:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DCF1C433D2;
        Wed,  7 Jun 2023 14:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686148093;
        bh=M0lqQRYGijECYYCLTFbV4UC+y8Di9NJPgKVAoQE2n1w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sIUJO4ntH9ra6rhUoVJu3VSY/x59rnguEiGH3M1CVOW0OoLEZmuRMwixKmJ6VLQNt
         /+SnD3ZaXogVTT0qyswybG7sY6hIXjWdRu0jJW52m78wB/ZO63kUCCVTF6hG7LjOfp
         mtjAdVXHRVeuZnWivv5n2pyWDNPOzMMtezhWGUP1hJxPPn6H3q/pkngbRAcrQLTpWx
         Y3ZXWCCEXYAkBaylXMBGyDS5j2MmgkK47/S1CwH6xSgVKNBHcXyM7augcCmDEC1uGa
         pZPB7zib6UxfetLqU5xyN0ZGmo6NPX0+lsmuneudE4da8VfM52ankhUs+mnPgz85qX
         kp78eYBbJK/pg==
Date:   Wed, 7 Jun 2023 07:28:12 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: Comment out unreachable code within
 xchk_fscounters()
Message-ID: <20230607142812.GR1325469@frogsfrogsfrogs>
References: <20230606151122.853315-1-cem@kernel.org>
 <i5VjxsfPIrRyvOoqV6BqW6qno66Gxsc-zGbsc1RZ60MawgxcwuoRtOODkv1SKvanvnXaNriVpBuIGtR99YA_Vw==@protonmail.internalid>
 <ZIAmCHghf8Acr26I@infradead.org>
 <20230607073757.zwfhie3qbn7mox5i@andromeda>
 <k8Kj2sTeNZWAzveaTqq0fnhlyrNj59s_SwIZn82YJTtQHnnXOS7GM08VCbW5V8M4uXSjuMxVJ3umucWeAYqxLQ==@protonmail.internalid>
 <ZIA2NLCSw7nVMh6w@infradead.org>
 <20230607084804.vh3dz6qvgbkotjav@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607084804.vh3dz6qvgbkotjav@andromeda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 07, 2023 at 10:48:04AM +0200, Carlos Maiolino wrote:
> On Wed, Jun 07, 2023 at 12:48:04AM -0700, Christoph Hellwig wrote:
> > On Wed, Jun 07, 2023 at 09:37:57AM +0200, Carlos Maiolino wrote:
> > > The code isn't dead, it's temporarily broken. I spoke with Darrick about
> > > removing it, but by doing that, later, 'reverting' the patch that removed the
> > > broken code, will break the git history (specifically for git blame), and I
> > > didn't want to give Darrick extra work by needing to re-add back all this code
> > > later when he come back to work on this.
> > > Anyway, just an attempt to quiet built test warning alerts :)
> > > I'm totally fine ^R'ing these emails :)
> > 
> > #if 0 is a realy bad thing.  I'd much prefer to remvoe it and re-added
> > it when needed.  But even if Darrick insists on just disabling it, you
> > need to add a comment explaining what is going on, because otherwise
> > people will just trip over the complete undocumented #if 0 with a
> > completely meaningless commit message in git-blame.  That's how people
> > dealt with code in the early 90s and not now.
> 
> You are right, I should have added at least some comment on that, I'll wait for
> Darrick to wake up and see if we deal with it somehow or just leave it as-is.

*Someone* please just review the fixes for fscounters.c that I put on
the list two weeks ago.  The first two patches of the patchset are
sufficient to fix this problem.

https://lore.kernel.org/linux-xfs/168506061483.3732954.5178462816967376906.stgit@frogsfrogsfrogs/

--D
