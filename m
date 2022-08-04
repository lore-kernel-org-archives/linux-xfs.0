Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1826DC3F6B0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 05:06:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236938AbiHDFGU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 01:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbiHDFGT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 01:06:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDE71EACF;
        Wed,  3 Aug 2022 22:06:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED0D96185C;
        Thu,  4 Aug 2022 05:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B48C433D6;
        Thu,  4 Aug 2022 05:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659589577;
        bh=mnQM8BKmF47yDnVzCCAHxXiMSohC8Tl4Poho0Wsi+ag=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F3yF8ZJV+ttn+Ar5y6bq0qYbg0EnnFXVmuqx1xczz13DvY0FTyyJhPwyWFlbNNmV0
         K7rWXkvhINfm0mgzxAYJv4RMTFwYm+riPDkhRiPKpB5uHfGzIGxOPTZerX65i6y/+9
         8XkRO9PPGb2yRWjNaUyNPEAa5XYm7N+YZivfEfNFohgw4Eeq1wPr0shSxOXdY7uGHM
         mMKUsnVvdoT2eFPOb/K38uVzQaPv1Ygr8+1P+RvdCsPGyoIoApEt1OuGVPJvPfzje2
         cQDhGM6tlFFkGt+ffI0bAsvzpUiCcK+19p4Xn47005kN076d6tdb0utPHkwcaKRB76
         JPeRbfdOD4aFg==
Date:   Wed, 3 Aug 2022 22:06:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "xuyang2018.jy@fujitsu.com" <xuyang2018.jy@fujitsu.com>
Cc:     "guaneryu@gmail.com" <guaneryu@gmail.com>,
        "zlang@redhat.com" <zlang@redhat.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "guan@eryu.me" <guan@eryu.me>
Subject: Re: [PATCH 3/3] xfs/533: fix golden output for this test
Message-ID: <YutTyPjPlKp3icSz@magnolia>
References: <165950048029.198815.11843926234080013062.stgit@magnolia>
 <165950049724.198815.5496412458825635633.stgit@magnolia>
 <4094bf3b-9be0-c629-648a-b78999e3ec83@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4094bf3b-9be0-c629-648a-b78999e3ec83@fujitsu.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 04, 2022 at 01:53:31AM +0000, xuyang2018.jy@fujitsu.com wrote:
> on 2022/08/03 12:21, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Not sure what's up with this new test, but the golden output isn't right
> > for upstream xfsprogs for-next.  Change it to pass there...
> 
> It failed becuase libxfs code validates v5 feature fields.
> 
> b12d5ae5d ("xfs: validate v5 feature fields")
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >   tests/xfs/533.out |    2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > 
> > diff --git a/tests/xfs/533.out b/tests/xfs/533.out
> > index 7deb78a3..439fb16e 100644
> > --- a/tests/xfs/533.out
> > +++ b/tests/xfs/533.out
> > @@ -1,5 +1,5 @@
> >   QA output created by 533
> >   Allowing write of corrupted data with good CRC
> >   magicnum = 0
> > -bad magic number

Ohhh, so this is a V4 output.

> > +Superblock has bad magic number 0x0. Not an XFS filesystem?
> 
> Since this case is designed to detect xfs_db bug, should we filter the 
> output?

Yep.  I'll rework this patch to handle V4 and V5.  Well, thanks for
keeping me on my toes! ;)

--D

> Best Regards
> Yang Xu
> >   0
> > 
