Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B35CFC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 12 May 2022 23:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359385AbiELXM6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 May 2022 19:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359384AbiELXM6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 May 2022 19:12:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B397C170F17
        for <linux-xfs@vger.kernel.org>; Thu, 12 May 2022 16:12:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64880B82AF5
        for <linux-xfs@vger.kernel.org>; Thu, 12 May 2022 23:12:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCA0C385B8;
        Thu, 12 May 2022 23:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652397174;
        bh=ID8Azl19ukddhhTmtUw2si39vyTP96krouEdNieNMAU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H/OsJ003QEoJ8Csz3kHy4VxQKuIxfhQfrrSCFro7eJfABwL8hmXjvRYuGsdRDX74d
         s8UYlRtDBiFTtpzmR4lMEinUQmvcgWam0sDyFIZTFg8BKFP9fAVjTpG3tCT7Ooeu/A
         G5fhzuNawtkqoKL+AZMtHU2uHB/pahL9jk6KE14bRYJFj/Abr/czaMp80FrsT8RecN
         gShrCW/fPh5/Bq6kHPXdvHMsjfHH9EFRMxJl57af4/oRCE5XXFdoeanypSn38R19EY
         Itmuu2UYIuuw30xvGBXD80mzj7plu5up0yiKcRmvnuOgS01XnsvNuxmCMHAnu8Ydwz
         d64giu7nvf0Tg==
Date:   Thu, 12 May 2022 16:12:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs_scrub: make phase 4 go straight to fstrim if
 nothing to fix
Message-ID: <20220512231253.GJ27195@magnolia>
References: <165176686186.252160.2880340500532409944.stgit@magnolia>
 <165176688994.252160.6045763886457820977.stgit@magnolia>
 <82de68be-0119-8e2a-c584-def6a0680034@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82de68be-0119-8e2a-c584-def6a0680034@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 12, 2022 at 05:34:37PM -0500, Eric Sandeen wrote:
> On 5/5/22 11:08 AM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > If there's nothing to repair in phase 4, there's no need to hold up the
> > FITRIM call to do the summary count scan that prepares us to repair
> > filesystem metadata.  Rearrange this a bit.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> 
> > +
> > +	/*
> > +	 * If errors remain on the filesystem, do not trim anything.  We don't
> > +	 * have any threads running, so it's ok to skip the ctx lock here.
> > +	 */
> > +	if (ctx->corruptions_found || ctx->unfixable_errors == 0)
> > +		return 0;
> > +
> > +maybe_trim:
> > +	trim_filesystem(ctx);
> > +	return 0;
> >  }
> 
> I'm a little confused by the unfixable_errors test, is that correct?
> 
> Why do you bail out if there are 0 unfixable errors?

Oooops.  That was a logic inversion bug. :(

--D

> -Eric
