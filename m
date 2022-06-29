Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0009EC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 22:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiF2WIC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 18:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiF2WIC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 18:08:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884B83916D
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 15:08:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3893AB82744
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 22:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF140C34114;
        Wed, 29 Jun 2022 22:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656540478;
        bh=58mf/3VCSIi5VluwLpOAlspTIDC1DqgUz5xjff8snPA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D0YhyTL8ozjFsXeNsyAzb3t4ac8EtyAuj9cnPa42IrUwzQ2wICYpQ/4Rl8lMYF0AY
         MvM1YjPKia77Im3AK5aIoChs0f4cZxnjYP3fxxu2wvgTeYiwxdRjuILzW2yqB8M7Tj
         gIRTPjO4LNQ4hN7YXxaEtnPG8BQqbkzUrkSkx+O8cXYm0PbAj2i2AU6GESHIsYSrEq
         5arPXU+ATeV2CDjQqao7lY98ngcNUQN987z7kMQXR0/ruUnwaU3XeuXl2Pw4t79uzw
         VgLYSnW+FAS9SEH3jfJwK118MdLdsGxDCaVdR7QT1vT+IP5X7qq2VYaxhASqq64N8c
         cN9TDA96avabQ==
Date:   Wed, 29 Jun 2022 15:07:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Theodore Tso <tytso@mit.edu>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 5.10] MAINTAINERS: add Amir as xfs maintainer for 5.10.y
Message-ID: <YrzNPp6BOujpMvC8@magnolia>
References: <20220629213236.495647-1-amir73il@gmail.com>
 <YrzHuqVgvSgj8gP6@magnolia>
 <CAOQ4uxgjmqB3YGr+tD0G2f-+4aqVoqYBE4sxkbCE3FYTO21nyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgjmqB3YGr+tD0G2f-+4aqVoqYBE4sxkbCE3FYTO21nyw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 30, 2022 at 12:52:57AM +0300, Amir Goldstein wrote:
> On Thu, Jun 30, 2022 at 12:44 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Thu, Jun 30, 2022 at 12:32:36AM +0300, Amir Goldstein wrote:
> > > This is an attempt to direct the bots and human that are testing
> > > LTS 5.10.y towards the maintainer of xfs in the 5.10.y tree.
> > >
> > > This is not an upstream MAINTAINERS entry and 5.15.y and 5.4.y will
> > > have their own LTS xfs maintainer entries.
> > >
> > > Suggested-by: Darrick J. Wong <djwong@kernel.org>
> > > Link: https://lore.kernel.org/linux-xfs/Yrx6%2F0UmYyuBPjEr@magnolia/T/#t
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >  MAINTAINERS | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index 7c118b507912..574151230386 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -19247,6 +19247,7 @@ F:    drivers/xen/*swiotlb*
> > >
> > >  XFS FILESYSTEM
> > >  M:   Darrick J. Wong <darrick.wong@oracle.com>
> > > +M:   Amir Goldstein <amir73il@gmail.com>
> >
> > Sounds good to me, though you might want to move your name to be first
> > in line. :)
> 
> Haha ok I can also add a typo in your email if you like :D
> I'll send it along with the 5.13 backports.

Actually -- can you change it to djwong@kernel.org while you're at it?
Maybe this is why I keep getting community emails chewed to death by
Outlook.

With /my/ email updated and yours first in line,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> Thanks,
> Amir.
