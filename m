Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44216C433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  9 May 2022 18:20:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240026AbiEISYl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 May 2022 14:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240101AbiEISYl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 May 2022 14:24:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C1C18384
        for <linux-xfs@vger.kernel.org>; Mon,  9 May 2022 11:20:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC13E61632
        for <linux-xfs@vger.kernel.org>; Mon,  9 May 2022 18:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9EFC385B5;
        Mon,  9 May 2022 18:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652120444;
        bh=D6vW7fTicE9ZVgH0GExG6C3mvt7KkINx/UxH3xbvWbM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dq6eoSgHaR+psPdisf1nJFUG7iiGt2qNQBwAQMjEVRi+1pZIgkSFaFRqlMNirmymP
         Tvku7H+F1LRVOKw6F/pYjWL7SCpzDptVRzeAbivMAhn5UWdAjx5RVBZWi2I4IMOqTm
         VfVuG1HDNaCU4r9KMI2Lf6yL4GXpfh6/U4CKRwPUbfrmlw2t1l2VjEgqAcA12BmkT1
         sH4WV/HAdVPKZ96ag6K6rjDoz47hQzea/iedIFJM7/84npAImp0y+4Aj6ZQb9ArbqZ
         9/QD11fiTLg0WeuDS0M8U17TMfRXABlWUAMcmxFUDweKE9gEoyix2lMBWFAz7r5XC7
         zq5glFOEgZf7w==
Date:   Mon, 9 May 2022 11:20:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [QUESTION] Upgrade xfs filesystem to reflink support?
Message-ID: <20220509182043.GW27195@magnolia>
References: <CAOQ4uxjBR_Z-j_g8teFBih7XPiUCtELgf=k8=_ye84J00ro+RA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjBR_Z-j_g8teFBih7XPiUCtELgf=k8=_ye84J00ro+RA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[drop my oracle email from cc, outlook sux]

On Mon, May 09, 2022 at 10:50:20AM +0300, Amir Goldstein wrote:
> Hi Darrick and Dave,
> 
> I might have asked this back when reflink was introduced, but cannot
> find the question nor answer.
> 
> Is there any a priori NACK or exceptional challenges w.r.t implementing
> upgrade of xfs to reflink support?

No, just lack of immediate user demand + time to develop and merge code
+ time to QA the whole mess to make sure it doesn't introduce any
messes.

> We have several customers with xfs formatted pre reflink that we would
> like to consider
> upgrading.
> 
> Back in the time of reflink circa v4.9 there were few xfs features
> that could be
> upgraded, but nowadays, there are several features that could be upgraded.
> 
> If I am not mistaken, the target audience for this upgrade would be
> xfs formatted
> with xfsprogs 4.17 (defaults).
> I realize that journal size may have been smaller at that time (I need to check)
> which may be a source of additional problems,

Yes.  We've found in practice that logsize < 100MB produce serious
scalability problems and increase deadlock opportunities on such old
kernels.  The 64MB floor we just put in for xfsprogs 5.15 was a good
enough downwards estimate assuming that most people will end up on 5.19+
kernels in the (very) long run.

> but hopefully, some of your work
> to do a diet for journal credits for reflink could perhaps mitigate
> that issue(?).

That work reduces the internal transaction size but leaves the existing
minimum log size standards intact.

> Shall I take a swing at it?

It's already written:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=upgrade-older-features

I think the upcoming nrext64 xfsprogs patches took in the first patch in
that series.

Question: Now that mkfs has a min logsize of 64MB, should we refuse
upgrades for any filesystem with logsize < 64MB?

--D

> Thanks,
> Amir.
