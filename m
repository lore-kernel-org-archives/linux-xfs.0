Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12A25C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jun 2022 22:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbiFVWMf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 18:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbiFVWMe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 18:12:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744EC3EBBD
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 15:12:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11CC061A08
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 22:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545E6C34114;
        Wed, 22 Jun 2022 22:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655935952;
        bh=Va9ay1HTHDnnobdOZVzh8rgBJ1RlaagVQ2bnXBJcIJQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H6KmDYCO7I2GyJRvAXXZg2u5Wj31SYG0ErpD4NSvhfKCsMhJQTCjk7Wf/sUMdNhiG
         N8AztTeTPFacPeuC5BVePsI6xmFwGKZ/GyNmGbYZlfC9ebF5uEtxVKd57wXj62jL9m
         vlqKDxWhMJnF6Vl7Gz7fXM9tDSuHh/ibq63c+Jxtgu5ulBAHWTT0ORzDwTogrvGwF5
         pQdxVkroCpuR1THFXaS7s4mbi9iRwmWRafg+1X9h/+T8SfQB+VYgWFlFo60qznDiNW
         ofQJZkUns/JypCFlN0jv0WZ7r6U+67HxgOxmS8K4j/77taFOeRib+wp4J9FQxhD6wo
         c61g1WlRo2CFw==
Date:   Wed, 22 Jun 2022 15:12:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/5] xfs_repair: check filesystem geometry before
 allowing upgrades
Message-ID: <YrOTz236fFQqx59l@magnolia>
References: <20220525053630.734938-1-chandan.babu@oracle.com>
 <20220525053630.734938-2-chandan.babu@oracle.com>
 <66855f31-32a0-7ccf-4cc2-ab56e39fe4f2@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66855f31-32a0-7ccf-4cc2-ab56e39fe4f2@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 22, 2022 at 01:57:52PM -0500, Eric Sandeen wrote:
> On 5/25/22 12:36 AM, Chandan Babu R wrote:
> > From: "Darrick J. Wong" <djwong@kernel.org>
> > 
> > Currently, the two V5 feature upgrades permitted by xfs_repair do not
> > affect filesystem space usage, so we haven't needed to verify the
> > geometry.
> > 
> > However, this will change once we start to allow the sysadmin to add new
> > metadata indexes to existing filesystems.  Add all the infrastructure we
> > need to ensure that the log will still be large enough, that there's
> > enough space for metadata space reservations, and the root inode will
> > still be where we expect it to be after the upgrade.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> > [Recompute transaction reservation values; Exit with error if upgrade fails]
> 
> This is a lot to digest; I'd like to go ahead and merge 3 patches out of
> this 5 patch series and leave this + the upgrade patch until I get a chance
> to digest it a bit more.
> 
> One thing at least, though:
> 
> 
> > +	/*
> > +	 * Would we have at least 10% free space in the data device after all
> > +	 * the upgrades?
> > +	 */
> > +	if (mp->m_sb.sb_fdblocks < mp->m_sb.sb_dblocks / 10)
> > +		printf(_("Filesystem will be low on space after upgrade.\n"));
> > +
> 
> This should be removed, IMHO; what is the point? The user can't do anything about
> it, it proceeds anyway, and for all we know they started with less than 10% free.
> So why bother printing something that might generate questions and support
> calls? I don't think it's useful or actionable information.

Would you rather this exit(1)'d afterwards?  i.e. refuse the upgrade if
the fs doesn't have enough free space?

--D

> Thanks,
> -Eric
