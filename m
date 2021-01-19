Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52FEEC433E6
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 21:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08199230FE
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 21:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbhASVuu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 16:50:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728536AbhASVng (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jan 2021 16:43:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 939B5230FE;
        Tue, 19 Jan 2021 21:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611092573;
        bh=fq5GKahGqlF5MIqa4LWiqmDp3cXqG/DnnA3ZDvtoSgY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Emf4GsjdjZCRMU0y1OInzlu7vC9XXEYvD0BVSz+U2zQz7vij3fhhOOr5bHUWD89Ch
         8lVYTGSiUFNe68BTge4eIzVApV70PX4lj0XU1k2Qc5tGTWChhOkFAOHHvVSav+P4xX
         BWFMivWibi9VQmqRlzNn9RT6kmtEtEMZgClzGu4XTeSzPmdjpyaKordnj6ya7p+dar
         p1WsySS9n72HPvYplPZlrQDUo6Dr1yp4YK5s04jYvAi5J2Lk9DXKMgxzG+2MC9nKPK
         84uTyJrI1eKQwbsX7MA6wm6a6aYl0FB2D16HexxP2M3Sj1xE+viY6Dc4QLh+PwgIoG
         GMImP7PAIOusQ==
Date:   Tue, 19 Jan 2021 13:42:52 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Nathan Scott <nathans@redhat.com>
Cc:     Bastian Germann <bastiangermann@fishpost.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2 0/6] debian: xfsprogs package clean-up
Message-ID: <20210119214252.GU3134581@magnolia>
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
 <20210116092328.2667-1-bastiangermann@fishpost.de>
 <49ecc92b-6f67-5938-af41-209a0e303e8e@sandeen.net>
 <522af0f2-8485-148f-1ec2-96576925f88e@fishpost.de>
 <e96dc035-ba4b-1a50-bc2d-fba2d3e552d8@sandeen.net>
 <3a1bd0e4-a4b2-5822-ed1a-d9a443b8ace7@fishpost.de>
 <CAFMei7MbBu9zfoXfE9+mTo1TtMzov-DEPWj6KPfw7Aa_PMnU4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFMei7MbBu9zfoXfE9+mTo1TtMzov-DEPWj6KPfw7Aa_PMnU4g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 20, 2021 at 08:26:45AM +1100, Nathan Scott wrote:
> Hey all,
> 
> On Wed, Jan 20, 2021 at 4:16 AM Bastian Germann
> <bastiangermann@fishpost.de> wrote:
> > [...]
> > Nathan uploaded most of the versions, so I guess he can upload.
> > The Debian package is "team maintained" though with this list address as
> > recorded maintainer.
> >
> 
> You should have the necessary permissions to do uploads since
> yesterday Bastian - is that not the case?
> 
> BTW Eric, not directly related but I think the -rc versions being
> added to the debian/changelog can lead to some confusion - I *think*
> dpkg finds that version suffix to be more recent than the actual
> release version string (seems odd, but that seemed to be the behaviour
> I observed recently).  Could the release script(s) skip adding -rc
> versions to debian/changelog?

The release maintainer could also skip adding the ~rc tags to
debian/changelog since it's not like we're going to upload /that/ into
debian anyway.  All of my internal builds add their own tag with dch, so
it wouldn't matter much to me.

(But let's see if Dave has opinions...)

--D

> cheers.
> 
> --
> Nathan
> 
