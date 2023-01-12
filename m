Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3395C46467
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Jan 2023 01:56:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbjALB40 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Jan 2023 20:56:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbjALB4Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jan 2023 20:56:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE6618B14
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2023 17:56:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C69A2B81DA2
        for <linux-xfs@vger.kernel.org>; Thu, 12 Jan 2023 01:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DA1C433EF;
        Thu, 12 Jan 2023 01:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673488581;
        bh=r22x0e1UBk28JMjMyXcLsdFeUU1AWRTU7MW1/pdxjBc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Evjaj0H+d+9U/VzZhbjV9sKTg9gHuJJ8hCJNRB9Yo4tg18rLBG10R0kuYXsQDGbCF
         68Zsrrt6+s3d29t/iVQSlGCqpLk+labUOcXHGSLL7hMeH8qTA/Qjg+Rz7Z0IWOYdqf
         WPUX2tsFiZ3vLqWAPW3t2TAn8C2tbxKao19QxcJmxaTq0CeQJlIYuo5ByCtVVSOl42
         NG0TF38PRVHt+akjbJ7EkALCgZTn9pSwi40XdX2N4R6AuiHsxbz9R9MfOnaP23QExB
         Q3WmcrgJGLy3SWkm645chlN1Kh6rSWE4NnWLqQ4cbkIoZhNRDEQhBRbzgGH5nkXPjP
         Esdqmx8FT7vLA==
Date:   Wed, 11 Jan 2023 17:56:20 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Csaba Henk <chenk@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsdocs: add epub output
Message-ID: <Y79oxBdLUovKkn+N@magnolia>
References: <20230111081557.rpmcmkkat7gagqup@nixos>
 <20230111221027.GC360264@dread.disaster.area>
 <20230112014401.ifwjtqx4jzbykeep@nixos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112014401.ifwjtqx4jzbykeep@nixos>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 12, 2023 at 02:44:01AM +0100, Csaba Henk wrote:
> On 23-01-12 09:10:27, Dave Chinner wrote:
> > On Wed, Jan 11, 2023 at 09:15:57AM +0100, Csaba Henk wrote:
> > > ---
> > >  .gitignore                               |  1 +
> > >  admin/Makefile                           | 13 +++++++++++--
> > >  admin/XFS_Performance_Tuning/Makefile    | 13 +++++++++++--
> > >  design/Makefile                          | 13 +++++++++++--
> > >  design/XFS_Filesystem_Structure/Makefile | 13 +++++++++++--
> > >  5 files changed, 45 insertions(+), 8 deletions(-)
> > 
> > The change looks fine, but why do we need to build documentation in
> > epub format? Empty commit messages are generally considered a bad
> 
> Well, we don't *need*; I just found we *can* (a2x spits it out in a
> split second).
> 
> My perception is that epub has become the de facto standard portable
> publication format for on-screen reading. So I thought it would be
> beneficial to make it available.
> 
> If this is not a consensual stance, it's also a possibility to add
> the epub target, but do not include it in default. Ie. make it
> available on demand.

Does epub support add more dependencies that I have to install?

Not opposed, just curious.

> > thing - the commit message should explain to us why building epub
> > format documentation is desired, what problem it solves, what new
> > dependencies it introduces (e.g. build tools), how we should
> > determine that the generated documentation is good, etc so that have
> > some basis from which to evaluate the change from.
> 
> Sorry; I thought a mere subject suffices if it's obvious what's the
> impact of the patch. I agree that giving context / rationale would be
> useful. I'll add that, according to the approach we settle with (ie.
> whether to include it in default).

Yes please. :)

--D

> Regards,
> Csaba
> 
