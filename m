Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4319C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 01:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235864AbiDNByR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Apr 2022 21:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235553AbiDNByR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Apr 2022 21:54:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893D6222B7;
        Wed, 13 Apr 2022 18:51:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44204B8276C;
        Thu, 14 Apr 2022 01:51:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F96C385A3;
        Thu, 14 Apr 2022 01:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649901111;
        bh=cDuWSp3LrK/aQkhD5BlNGXQ8Vq3HM0xWBv1SIl0modU=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=lvGHlEU7NVc6kMbvSXwfUsiURDnwR5BRhplzttRaOYeZmiOdZYvUDIJOo3V8sl3Np
         mozM3scy1yJjnO2pMoO1bf/tfGBKHhKmPS+4xXoCLt5ToO3LNFyuN1bwg7SPtE0IJs
         qUnqiHeBqtHV//DHHBWJCfY/tu1MDGmmoj3nuxUxvRw1FF9qWe85I0+cU9Tb2Krshj
         IjKPUOe/fuEKH2NKZwQPNm3zMLkx1HZ77fP5Auh1P104XdTmCFYhszAiQq9WyI6TI8
         dT+UKJBfEagDgJxGVw0GgVIcX1e1+E+Za/Y7ZswBA0564LqFrmMhpkl9mz6Yit6FUn
         cHatkGYLnlw0Q==
Date:   Wed, 13 Apr 2022 18:51:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs/216: handle larger log sizes
Message-ID: <20220414015149.GD16774@magnolia>
References: <164971769710.170109.8985299417765876269.stgit@magnolia>
 <164971771391.170109.16368399851366024102.stgit@magnolia>
 <20220413174400.kvbihaz6bcsgz4hy@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220413174400.kvbihaz6bcsgz4hy@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 14, 2022 at 01:44:00AM +0800, Zorro Lang wrote:
> On Mon, Apr 11, 2022 at 03:55:13PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > mkfs will soon refuse to format a log smaller than 64MB, so update this
> > test to reflect the new log sizing calculations.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/216.out |   14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> > 
> > 
> > diff --git a/tests/xfs/216.out b/tests/xfs/216.out
> > index cbd7b652..3c12085f 100644
> > --- a/tests/xfs/216.out
> > +++ b/tests/xfs/216.out
> > @@ -1,10 +1,10 @@
> >  QA output created by 216
> > -fssize=1g log      =internal log           bsize=4096   blocks=2560, version=2
> > -fssize=2g log      =internal log           bsize=4096   blocks=2560, version=2
> > -fssize=4g log      =internal log           bsize=4096   blocks=2560, version=2
> > -fssize=8g log      =internal log           bsize=4096   blocks=2560, version=2
> > -fssize=16g log      =internal log           bsize=4096   blocks=2560, version=2
> > -fssize=32g log      =internal log           bsize=4096   blocks=4096, version=2
> > -fssize=64g log      =internal log           bsize=4096   blocks=8192, version=2
> > +fssize=1g log      =internal log           bsize=4096   blocks=16384, version=2
> > +fssize=2g log      =internal log           bsize=4096   blocks=16384, version=2
> > +fssize=4g log      =internal log           bsize=4096   blocks=16384, version=2
> > +fssize=8g log      =internal log           bsize=4096   blocks=16384, version=2
> > +fssize=16g log      =internal log           bsize=4096   blocks=16384, version=2
> > +fssize=32g log      =internal log           bsize=4096   blocks=16384, version=2
> > +fssize=64g log      =internal log           bsize=4096   blocks=16384, version=2
> 
> So this will break downstream kernel testing too, except it follows this new
> xfs behavior change. Is it possible to get the minimal log size, then help to
> avoid the failure (if it won't mess up the code:)?

Hmm.  I suppose we could do a .out.XXX switcheroo type thing, though I
don't know of a good way to detect which mkfs behavior you've got.

--D

> 
> >  fssize=128g log      =internal log           bsize=4096   blocks=16384, version=2
> >  fssize=256g log      =internal log           bsize=4096   blocks=32768, version=2
> > 
> 
