Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76361C48BE5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 00:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C46F613CD
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 00:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhFQAKR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 20:10:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230481AbhFQAKQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Jun 2021 20:10:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CD0661351;
        Thu, 17 Jun 2021 00:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623888490;
        bh=xZD4qrY1IGzd68pUbSFv1z5tpQdHSimGPQP1IbbDgx4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QaWur+KbZKNBzuFFbfKcqypO1nGkPzK5dB2rA4J44J8AW5R3kEGQ168EghEXPv7lU
         sQ+P/s+Cf3GBCIJEDT+LdvfXp/gfEDh2tY/9v8wuCHvlxpzfyJp1yGMWXU8lFJ2Vic
         6FBosZK4TNLZ6LD6itRn0sKbXqXRJFk0o85xkSjXh4WRSKKamBpFLTbVqhq1bcWEse
         AOqAOwfjfbeJArw+Y1akGsnIRLhi32wc7YzOBV3i/UOyA6oqjnQJHUYYAvdCl2DWJa
         TA6Ss6kg7dyIdjpMikx3zqDuca3bKwgAHhZEt8WmZoiZhy4sJUND+BWpKUyZU+FI/N
         mivNiiykXCCgw==
Date:   Wed, 16 Jun 2021 17:08:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     guaneryu@gmail.com, Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com
Subject: Re: [PATCH 12/13] fstests: remove test group management code
Message-ID: <20210617000809.GI158209@locust>
References: <162370433910.3800603.9623820748404628250.stgit@locust>
 <162370440523.3800603.5113348731405331858.stgit@locust>
 <YMpl7YYV6UN6sS87@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMpl7YYV6UN6sS87@sol.localdomain>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 16, 2021 at 01:58:21PM -0700, Eric Biggers wrote:
> On Mon, Jun 14, 2021 at 02:00:05PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Remove all the code that manages group files, since we now generate
> > them at build time.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> > Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  tools/mvtest     |   12 ------
> >  tools/sort-group |  112 ------------------------------------------------------
> >  2 files changed, 124 deletions(-)
> >  delete mode 100755 tools/sort-group
> > 
> > 
> > diff --git a/tools/mvtest b/tools/mvtest
> > index 572ae14e..fa967832 100755
> > --- a/tools/mvtest
> > +++ b/tools/mvtest
> > @@ -32,24 +32,12 @@ did="$(basename "${dest}")"
> >  sgroup="$(basename "$(dirname "tests/${src}")")"
> >  dgroup="$(basename "$(dirname "tests/${dest}")")"
> >  
> > -sgroupfile="tests/${sgroup}/group"
> > -dgroupfile="tests/${dgroup}/group"
> 
> The 'sgroup' and 'dgroup' variables are no longer used and should be removed.

Good catch; deleted.

--D

> 
> - Eric
