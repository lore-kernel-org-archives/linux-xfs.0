Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54A55C433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Dec 2021 16:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbhLKQzs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Dec 2021 11:55:48 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:52870 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbhLKQzs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Dec 2021 11:55:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E2FB8CE09E7
        for <linux-xfs@vger.kernel.org>; Sat, 11 Dec 2021 16:55:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B89C004DD;
        Sat, 11 Dec 2021 16:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639241745;
        bh=5b3xujT4/gMdBWJV8gWJokdly0ap8XbC9zojuKeciX8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A/VxdFNrUASLoGFb+w7+8Dhbd3eDmusoPYTYhu1MxS9ORuUndLpMsxbgfM2FXRMPW
         XcYbz4oQ0UJoOGWUkludBMwfDOTPV4jPA1QlPB3cg8mUgUB7u0+OE4TQI4xRv6y6W0
         GRiYSgcB83p0RidPyIfkvmUvNGgwv75w8+gOgBOkwxrkmwD29McChV9dnfuMe6KLEo
         AKi3yDSg14EJ8FKYlTzA+ruhOTqFQyvoU4p6x1HGpKbyz3y8sy+J2C+zjZuJemJNxE
         fXNdigKL6rFr02iPUuoHWOpfyFhKgpG/ag7K4XJpBqN0px+ynISZFrFYRJ573jCUG9
         B/4iTxnYF0X6g==
Date:   Sat, 11 Dec 2021 08:55:44 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs_quota: document unit multipliers used in limit
 command
Message-ID: <20211211165544.GF1218082@magnolia>
References: <1639167697-15392-1-git-send-email-sandeen@sandeen.net>
 <1639167697-15392-2-git-send-email-sandeen@sandeen.net>
 <20211211001518.GA1218082@magnolia>
 <a194a662-ff48-9ffc-a8ef-ad2c3726b878@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a194a662-ff48-9ffc-a8ef-ad2c3726b878@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 10, 2021 at 11:47:07PM -0600, Eric Sandeen wrote:
> On 12/10/21 6:15 PM, Darrick J. Wong wrote:
> > On Fri, Dec 10, 2021 at 02:21:34PM -0600, Eric Sandeen wrote:
> > > From: Eric Sandeen <sandeen@redhat.com>
> > > 
> > > The units used to set limits are never specified in the xfs_quota
> > > man page, and in fact for block limits, the standard k/m/g/...
> > > units are accepted. Document all of this.
> > > 
> > > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > > Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> > > ---
> > >   man/man8/xfs_quota.8 | 8 +++++++-
> > >   1 file changed, 7 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
> > > index 59e603f..f841e3f 100644
> > > --- a/man/man8/xfs_quota.8
> > > +++ b/man/man8/xfs_quota.8
> > > @@ -446,7 +446,13 @@ option reports state on all filesystems and not just the current path.
> > >   .I name
> > >   .br
> > >   Set quota block limits (bhard/bsoft), inode count limits (ihard/isoft)
> > > -and/or realtime block limits (rtbhard/rtbsoft). The
> > > +and/or realtime block limits (rtbhard/rtbsoft) to N, where N is a bare
> > 
> > What is a 'bare' number?
> > 
> > How about (shortened so I don't have to retype the whole thing):
> > 
> > "Set quota block limits...to N.  For block limits, N is a number
> > with a s/b/k/m/g/t/p/e multiplication suffix..."
> 
> it's also allowed w/o the suffix. so I propose ...
> 
> Set quota block limits (bhard/bsoft), inode count limits (ihard/isoft)
> +and/or realtime block limits (rtbhard/rtbsoft) to N, where N is a
> number representing bytes or inodes.
> +For block limits, a number with a s/b/k/m/g/t/p/e multiplication suffix
> +as described in
> +.BR mkfs.xfs (8)
> +is also accepted.
> For inode limits, no suffixes are allowed.
> 
> (I thought about adding suffix support to inodes but meh, that's confusing,
> what is 1 block's worth of inodes?)

...or does "1g" refer to one giga-inode, or one gibi-inode?
Probably best to leave the code as it is.

As for the manpage update, with the new wording,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> > 
> > "For inode limits, N is a bare number; no suffixes are allowed."
> > 
> > ?
> > 
> > --D
> > 
> > > +number representing bytes or inodes.
> > > +For block limits, a number with a s/b/k/m/g/t/p/e multiplication suffix
> > > +as described in
> > > +.BR mkfs.xfs (8)
> > > +is also accepted.
> > > +The
> > >   .B \-d
> > >   option (defaults) can be used to set the default value
> > >   that will be used, otherwise a specific
> > > -- 
> > > 1.8.3.1
> > > 
> > 
