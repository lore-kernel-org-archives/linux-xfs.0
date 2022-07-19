Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13DFEC43334
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jul 2022 08:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbiGSIpA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jul 2022 04:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiGSIon (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jul 2022 04:44:43 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE6428E11
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jul 2022 01:44:41 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id 125so2315791vsd.5
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jul 2022 01:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=14+29eL+Z9M/gJ7q/d+5h+r0S9odToAPN3JiREuddFQ=;
        b=hkNn8svhqqYwrGFNLW/FuRw3fNW64BJK6dsg+HkfFYuVJPAEIENLU5tICCaJreHO+Z
         GHuvoDJ/fLsqPxaRVDveL1gDvxB418pCECRRAnklGh/jTidjT4Lh1KffdkddiQUOmA8P
         wR/cs6dGCXYFB4VqLdmUNmm47WfUI0VHlDqcEoVJxrxXBqe2kkRV5iLLV1anaNuvHYsW
         DShBkSowSxD4ywh6UO8ryhNEAbVpsnZIY1jX2/MQUYmEkOsY7G5gjKLFzeyemfHcU1Ot
         qqUe7WmVzlt8Ef3YV381eP4c936HeLqKXt0q7M+SX3BQ87VnJnTxU5Jun4X1VEZTZcug
         +Vmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=14+29eL+Z9M/gJ7q/d+5h+r0S9odToAPN3JiREuddFQ=;
        b=1bw8kwD6jmI3+yIXwHy9CmQII36Nf0EEjDfCq0jokExeQN6XcTWC1tJXL3kortGPrF
         QNTy7S5vJsA4R4t5/2S7UIQ8B8GvQVIseJSnQJigaEDVljZnLvoQJmnMCP9uTPVq3clJ
         yjR11QlqeJjqCPePnZs5X4+4RAWTwZaSGwSm4HLORqfa0eY2STjTAUzzC0nVJEUqKbQ2
         XMeT7t0i8ygwCnEYhjenqdeo6rHwe+oePePuKuXiDbbEPTNEWNr/9XoBuveYI0BL7Vzo
         5KkEC/4xOniHNy3xAwsDN73rVsXDRdVBLJPsDaQcbDNQpeJE2WdaHY/GJzOfl2f7ufLq
         kw5A==
X-Gm-Message-State: AJIora85W+TzCBkcpuj9Ecvf60xvXuMiwSGipm7E7Vg3uF5ZW1Wfd4ID
        TbbWgX180+m8/a5OiLlQD0jx7UxcLIdY8rrsOuQ=
X-Google-Smtp-Source: AGRyM1sA1d1HuqPRPjjqF83W3ZG8m1ae/B2JWeWduN1k2aFh/bRt7B0WPxHhRVFH40wyc/LPx982PmQY11w2V1HvQL0=
X-Received: by 2002:a05:6102:834:b0:357:e3b9:56d5 with SMTP id
 k20-20020a056102083400b00357e3b956d5mr2073121vsb.72.1658220281004; Tue, 19
 Jul 2022 01:44:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220718202959.1611129-1-leah.rumancik@gmail.com> <YtXXhQuOioUeSltH@magnolia>
In-Reply-To: <YtXXhQuOioUeSltH@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 19 Jul 2022 10:44:29 +0200
Message-ID: <CAOQ4uxh13NPtWP98E-R7Sxfy=dkgCHxk7tysEykJ2rg3yhJ__A@mail.gmail.com>
Subject: Re: [PATCH 5.15 CANDIDATE 0/9] xfs stable candidate patches for
 5.15.y (part 3)
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 19, 2022 at 12:05 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Mon, Jul 18, 2022 at 01:29:50PM -0700, Leah Rumancik wrote:
> > Hi again,
> >
> > This set contains fixes from 5.16 to 5.17. The normal testing was run
> > for this set with no regressions found.
> >
> > I included some fixes for online scrub. I am not sure if this
> > is in use for 5.15 though so please let me know if these should be
> > dropped.
> >
> > Some refactoring patches were included in this set as dependencies:
> >
> > bf2307b19513 xfs: fold perag loop iteration logic into helper function
> >     dependency for f1788b5e5ee25bedf00bb4d25f82b93820d61189
> > f1788b5e5ee2 xfs: rename the next_agno perag iteration variable
> >     dependency for 8ed004eb9d07a5d6114db3e97a166707c186262d
> >
> > Thanks,
> > Leah
> >
> >
> > Brian Foster (4):
> >   xfs: fold perag loop iteration logic into helper function
> >   xfs: rename the next_agno perag iteration variable
> >   xfs: terminate perag iteration reliably on agcount
> >   xfs: fix perag reference leak on iteration race with growfs
> >
> > Dan Carpenter (1):
> >   xfs: prevent a WARN_ONCE() in xfs_ioc_attr_list()
> >
> > Darrick J. Wong (4):
> >   xfs: fix maxlevels comparisons in the btree staging code
>
> Up to this point,
> Acked-by: Darrick J. Wong <djwong@kernel.org>
>
> >   xfs: fix incorrect decoding in xchk_btree_cur_fsbno
> >   xfs: fix quotaoff mutex usage now that we don't support disabling it
> >   xfs: fix a bug in the online fsck directory leaf1 bestcount check
>
> No objections to these last three, since they're legitimate fixes for
> bugs in 5.15, but I would advise y'all not to worry too much about fixes
> for EXPERIMENTAL features.

FWIW, from the set above, I only picked Dan Carpenter's fix for 5.10.
I'll include it in one of the following updates.

Thanks,
Amir.
