Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B217C433C1
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Mar 2021 20:18:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1F8E6193A
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Mar 2021 20:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbhCTURZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Mar 2021 16:17:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:57468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229883AbhCTURL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 20 Mar 2021 16:17:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52B67601FA;
        Sat, 20 Mar 2021 20:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616271431;
        bh=V9ARt4YfosOGLOxaWrETKn8vH05vjOMCBq+sfWu/4nE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BwLM7dySNe4xNfnHi98ASXhw/eRK65rTEuq/zJeFCt7T3ohrzDHbfAdlNwlzbVFVD
         fu4BtSR2Dx4Yveo8086EtmKrV5l9ETDWRCMRu5ISTiBcJ4A3jSmOy8V7zGrl0Ae+le
         iIWIOqzeWSho8KlyS7QnKHb5DLmMuAPO/AQfnv/Pw5C9bwa3v47RTw0W52Ivi7rDyb
         OoDh/BSyud+nFprNYwh3mhQjHZlNzyfFycK9jhiV3eR7c0qXzjGGl4vjQUejNfmMrN
         qY9QJdh0OP6d4BVpwqdwgjKSEgexUrVtHpmv0M0Q22+tUa0heKcG5bdzFGp0WosVAG
         cplxx4f+GlsZA==
Date:   Sat, 20 Mar 2021 13:17:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3][next] xfs: Replace one-element arrays with
 flexible-array members
Message-ID: <20210320201711.GY22100@magnolia>
References: <20210311042302.GA137676@embeddedor>
 <20210311044700.GU3419940@magnolia>
 <96be7032-a95c-e8d2-a7f8-64b96686ea42@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <96be7032-a95c-e8d2-a7f8-64b96686ea42@embeddedor.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 15, 2021 at 01:31:17PM -0500, Gustavo A. R. Silva wrote:
> 
> 
> On 3/10/21 22:47, Darrick J. Wong wrote:
> > On Wed, Mar 10, 2021 at 10:23:02PM -0600, Gustavo A. R. Silva wrote:
> >> There is a regular need in the kernel to provide a way to declare having
> >> a dynamically sized set of trailing elements in a structure. Kernel code
> >> should always use “flexible array members”[1] for these cases. The older
> >> style of one-element or zero-length arrays should no longer be used[2].
> >>
> >> Refactor the code according to the use of flexible-array members in
> >> multiple structures, instead of one-element arrays. Also, make use of
> >> the new struct_size() helper to properly calculate the size of multiple
> >> structures that contain flexible-array members. Additionally, wrap
> >> some calls to the struct_size() helper in multiple inline functions.
> >>
> >> Below are the results of running xfstests for groups shutdown and log
> >> with the following configuration in local.config:
> >>
> >> export TEST_DEV=/dev/sda3
> >> export TEST_DIR=/mnt/test
> >> export SCRATCH_DEV=/dev/sda4
> >> export SCRATCH_MNT=/mnt/scratch
> >>
> >> The size for both partitions /dev/sda3 and /dev/sda4 is 25GB.
> > 
> > Looks good to me, will toss it at my fstests cloud and see if anything
> > shakes out.  Thanks for cleaning up this goofy thorn-pile!
> 
> Great. It's been fun to work on this. :p

Did you run the /entire/ fstests suite?  With this patch applied to
5.12-rc2, I keep seeing list corruption assertions about an hour into
the test run, and usually on some test that heavily exercises allocating
and deleting file extents.  I'll try to look at this patch more closely
next week, but I figured I should let you know early, on the off chance
something sticks out to you.

--D

> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> Thanks!
> --
> Gustavo
