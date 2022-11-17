Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78FF1C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Nov 2022 01:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239074AbiKQBQC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Nov 2022 20:16:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238971AbiKQBPx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Nov 2022 20:15:53 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6171543ACD
        for <linux-xfs@vger.kernel.org>; Wed, 16 Nov 2022 17:15:52 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 62so548621pgb.13
        for <linux-xfs@vger.kernel.org>; Wed, 16 Nov 2022 17:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JxipC0LJHNCGjvUKQVQlhGMQOiwBTHC0MrzuSTcVoaA=;
        b=1aO2YR/Q772skurjKf1hHODgxP9PgZ2ytPw2ANFEPQDMsj3uWpqnyS+1qtGtTg5OWp
         azxo8LQ89nLDbVyxlbPsyGJ/6CKvch+AtPrpFjc3EFdHiFyGyfxhV3KgCLPlgvx9AjeL
         SHjQida60F1CWWRksPTgQdVHW7AOBGzvwxubIr2vHNhjXFvoBlcoCZXyOujthAN4l11r
         GY908JT5vrEotc8fStqgQEwUNeVyNE+vnyVNmFq2z9y/xYekCei//WZ+ztFx861SSG60
         lt9DO1OUv1TxC0utNHa4MTz7bFunnlo4ZSPzmEOVazJwnhukor+h8eu7Iyxi2C7tq/Za
         MHwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JxipC0LJHNCGjvUKQVQlhGMQOiwBTHC0MrzuSTcVoaA=;
        b=ZgIH2vP2a03AIc2knAA92MLKe4CK5LY4aNfqbX1i5FeEJeg2IiRcLpJs3vDS+7Y+cc
         Pi2wgCtgxjOpQmSmxvRoSy5/zmVzCZrhG+laXHOTkE50Q6rF5SeYTV5bHYCg0PvzN0kL
         8S9eswygYYOD4sF9/geAO5bTodubitBxzuBN03jMrn3fTaR3SBnsr/sej0EgxeJnJaYf
         ZqGa91QEediPlvGEfiQ8a5oCwm55qJNAOivVVNgPArG3PaG/IT8YLz4sLAzG639qwQ9q
         aP7NaUOa9yEkT4fe/+W3QHeNuvbydRlxTvgI8psF3Oq8yQ1hSy06SgSfdBC9gBHxumdd
         PfjA==
X-Gm-Message-State: ANoB5pmk8qZ4HKs3etZ+5G63E8k2Y/2VLlxzqw5qQ4yfvjNDhMCmzWgk
        6fBKRhJUMjd3fOgNYNnHVDdH4r3Qm0427g==
X-Google-Smtp-Source: AA0mqf5jXfIzJd0WuKJJvpWR1oeUvqZw1g8NOApKS2hsnlx2ndRF4g2fhZaDJ3a8VCYC2NvhJ9ly1w==
X-Received: by 2002:a63:887:0:b0:460:633b:5702 with SMTP id 129-20020a630887000000b00460633b5702mr45250pgi.9.1668647751778;
        Wed, 16 Nov 2022 17:15:51 -0800 (PST)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id r5-20020aa79885000000b0057293b17d64sm3108415pfl.177.2022.11.16.17.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 17:15:51 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ovTVM-00F6uT-A0; Thu, 17 Nov 2022 12:15:48 +1100
Date:   Thu, 17 Nov 2022 12:15:48 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: retain the AGI when we can't iget an inode to
 scrub the core
Message-ID: <20221117011548.GF3600936@dread.disaster.area>
References: <166473482923.1084685.3060991494529121939.stgit@magnolia>
 <166473482971.1084685.9939611867095895186.stgit@magnolia>
 <20221115040816.GY3600936@dread.disaster.area>
 <Y3RPqgRr2AOBFbyc@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3RPqgRr2AOBFbyc@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 15, 2022 at 06:49:14PM -0800, Darrick J. Wong wrote:
> On Tue, Nov 15, 2022 at 03:08:16PM +1100, Dave Chinner wrote:
> > On Sun, Oct 02, 2022 at 11:20:29AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > xchk_get_inode is not quite the right function to be calling from the
> > > inode scrubber setup function.  The common get_inode function either
> > > gets an inode and installs it in the scrub context, or it returns an
> > > error code explaining what happened.  This is acceptable for most file
> > > scrubbers because it is not in their scope to fix corruptions in the
> > > inode core and fork areas that cause iget to fail.
> > > 
> > > Dealing with these problems is within the scope of the inode scrubber,
> > > however.  If iget fails with EFSCORRUPTED, we need to xchk_inode to flag
> > > that as corruption.  Since we can't get our hands on an incore inode, we
> > > need to hold the AGI to prevent inode allocation activity so that
> > > nothing changes in the inode metadata.
> > > 
> > > Looking ahead to the inode core repair patches, we will also need to
> > > hold the AGI buffer into xrep_inode so that we can make modifications to
> > > the xfs_dinode structure without any other thread swooping in to
> > > allocate or free the inode.
> > > 
> > > Adapt the xchk_get_inode into xchk_setup_inode since this is a one-off
> > > use case where the error codes we check for are a little different, and
> > > the return state is much different from the common function.
> > 
> > The code look fine, but...
> > 
> > ... doesn't this mean that xchk_setup_inode() and xchk_get_inode()
> > now are almost identical apart from the xchk_prepare_iscrub() bits?
> 
> Yes, they're /nearly/ identical in the helper functions they call, but
> they're not so similar in intent and how they handle @error values:
> 
> xchk_setup_inode prepares to check or repair an inode record, so it must
> continue the scrub operation even if the inode/inobt verifiers cause
> xfs_iget to return EFSCORRUPTED.  This is done by attaching the locked
> AGI buffer to the scrub transaction and returning 0 to move on to the
> actual scrub.  (Later, the online inode repair code will also want the
> xfs_imap structure so that it can reset the ondisk xfs_dinode
> structure.)
> 
> xchk_get_inode retrieves an inode on behalf of a scrubber that operates
> on an incore inode -- data/attr/cow forks, directories, xattrs,
> symlinks, parent pointers, etc.  If the inode/inobt verifiers fail and
> xfs_iget returns EFSCORRUPTED, we want to exit to userspace (because the
> caller should be fix the inode first) and drop everything we acquired
> along the way.
> 
> A behavior common to both functions is that it's possible that xfs_scrub
> asked for a scrub-by-handle concurrent with the inode being freed or the
> passed-in inumber is invalid.  In this case, we call xfs_imap to see if
> the inobt index thinks the inode is allocated, and return ENOENT
> ("nothing to check here") to userspace if this is not the case.  The
> imap lookup is why both functions call xchk_iget_agi.

Ok, so given all this, all I really want then is better names for
the functions, as "setup" and "get" don't convey any of this. :)

Perhaps xchk_setup_inode() -> xchk_iget_for_record_check() and
xchk_get_inode() -> xchk_iget_for_scrubbing(). This gives an
indication taht they are being used for different purposes, and the
implementation is tailored to the requirements of those specific
operations....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
