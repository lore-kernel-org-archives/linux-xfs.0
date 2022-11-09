Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ECBAC433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 11:28:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiKIL23 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Nov 2022 06:28:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiKIL22 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Nov 2022 06:28:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E75E2FB
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 03:28:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33CFEB81D9F
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 11:28:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092F8C433D6;
        Wed,  9 Nov 2022 11:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667993301;
        bh=H8ztReJ688TrJbGA5IQqwToavIjFXWyxSXonqwt+ROU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o50RoMUjP24w5mMzDhrqLH2/q290DuaKIG3D9EiNz4Vql/nN8kmKxYu18vVlhsY8G
         xuo40eIrMW1pQF9wLx8livCmFB1qhSwIagozSxPBBStm6BXHRlLTbo5zPG1HqGFz1v
         pYs+8v8QovyFPSvPUDIvxfOL3yJxil1m2mQCpjDXCAeiOXEKh+xB6Q8PR5AiZeHkZ9
         yOgi65Nj8xv8/oaZCyI6P71KUWUGx/awBK6tD1u2XEmvu5COR4A+IbmPaU8SkKZdVN
         hw7ovFd7tLnuFHczpZQUrZGlaJZfnDHzc/5yrMjPg1bdZQCskCnVj70cQjWG1wBBFu
         L6mKKFREmNFkA==
Date:   Wed, 9 Nov 2022 12:28:09 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_repair: Fix check_refcount() error path
Message-ID: <20221109112809.d4erwrydzfuh3l22@andromeda>
References: <166212614879.31305.11337231919093625864.stgit@andromeda>
 <166212621918.31305.17388002689404843538.stgit@andromeda>
 <tVoGmfcAatKg-ouPdfZ7AXjfQoZE56EAH9d7-THujiFxvfw4TrOZ_hgBZFB1NGqDxvyDL6u_oMyBEkSHEi6OWw==@protonmail.internalid>
 <YxJsFQb+MdmeRmak@magnolia>
 <20220905070524.ew6bqxlpn2x4extw@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220905070524.ew6bqxlpn2x4extw@andromeda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 05, 2022 at 09:05:28AM +0200, Carlos Maiolino wrote:
> On Fri, Sep 02, 2022 at 01:48:21PM -0700, Darrick J. Wong wrote:
> > On Fri, Sep 02, 2022 at 03:43:39PM +0200, Carlos Maiolino wrote:
> > > From: Carlos Maiolino <cmaiolino@redhat.com>
> > >
> > > Add proper exit error paths to avoid checking all pointers at the current path
> > >
> > > Fixes-coverity-id: 1512651
> > >
> > > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > > ---
> > >  repair/rmap.c |   23 +++++++++++------------
> > >  1 file changed, 11 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/repair/rmap.c b/repair/rmap.c
> > > index a7c4b25b1..0253c0c36 100644
> > > --- a/repair/rmap.c
> > > +++ b/repair/rmap.c
> > > @@ -1377,7 +1377,7 @@ check_refcounts(
> > >  	if (error) {
> > >  		do_warn(_("Could not read AGF %u to check refcount btree.\n"),
> > >  				agno);
> > > -		goto err;
> > > +		goto err_agf;
> > 
> > Shouldn't this       ^^^^^^^ be err_pag, since we're erroring out and
> > releasing the perag group reference?
> 
> At first I named it err_pag, but pag is used here only to read the agf, and when
> reading agf fail is why we end up reaching this error path, so I thought it
> would be more specific to name it err_agf.
> > 
> > Also ... don't the "if (XXX) free(XXX)" bits take care of all this?
> > 
> 
> Yeah, it does. But that's exactly what coverity is complaining about. We check
> for a NULL pointer 'after' we dereference it earlier, to be more specific:
> 
> ---
> Type: Dereference before NULL check
> Null-checking pag suggests that it may be null, but it has already been
> dereferenced on all paths leading to the check
> ---
> 
> Both patches fix the same issue type.
> 
> > (I can't access Coverity any more, so I don't know what's in the
> > report.)
> > 
> > --D
> > 
> > >  	}

Hi Darrick. Do you have any other opinion at this? Or should I consider it a
no-no and discard those patches?

Cheers.

-- 
Carlos Maiolino
