Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 799C3C3F6B0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jul 2022 02:01:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbiG1CBS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jul 2022 22:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbiG1CBR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jul 2022 22:01:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB594F1AC;
        Wed, 27 Jul 2022 19:01:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 311B661778;
        Thu, 28 Jul 2022 02:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A30C433C1;
        Thu, 28 Jul 2022 02:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658973675;
        bh=Tz69SP7jpDpA3Y2VDaXKyOdOnVyZaUdpykNUzUVIPrk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HtHMDNPh0NoxCUY0SXRmar3jMG5b833hb5T1PA2BMYnMyE5lnUCqASduJt9DIN4hr
         TxiDIJ8RZmpFz39qwD6LS75JqB/tG7KcMJAkRCwHpo5ZzZmyOJ3v5W1WiBta1YmbDD
         x/A1MSbQ6/X4krNcWipr9uCFnssbpdX81bU0YWz36HZOjQddeFc7yr73XE5hA0iV3Z
         3LPMg0Fa3l5i+AUT2YvWY+KU3trZkD1T+TJR7/4ntFe4XPo+uUhf+TonDsH2a7o1cZ
         MTHFtHEF2GTcYnwC1SgzA6qXeS0+XLbZIh41+8I+xocKEVagIsJ4eBFty4iLOnc7tL
         TEXaou4gr+X5w==
Date:   Wed, 27 Jul 2022 19:01:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH 5.10 CANDIDATE 0/9] xfs stable candidate patches for
 5.10.y (from v5.13+)
Message-ID: <YuHt65YWtkqLxlpv@magnolia>
References: <20220726092125.3899077-1-amir73il@gmail.com>
 <CAOQ4uxi=VYa+86A7G3wqCX84n2Aezx2mYqfYrFTAVtSpYmeq_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi=VYa+86A7G3wqCX84n2Aezx2mYqfYrFTAVtSpYmeq_Q@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 27, 2022 at 09:17:47PM +0200, Amir Goldstein wrote:
> On Tue, Jul 26, 2022 at 11:21 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Darrick,
> >
> > This backport series contains mostly fixes from v5.14 release along
> > with three deferred patches from the joint 5.10/5.15 series [1].
> >
> > I ran the auto group 10 times on baseline (v5.10.131) and this series
> > with no observed regressions.
> >
> > I ran the recoveryloop group 100 times with no observed regressions.
> > The soak group run is in progress (10+) with no observed regressions
> > so far.
> >
> > I am somewhat disappointed from not seeing any improvement in the
> > results of the recoveryloop tests comapred to baseline.
> >
> > This is the summary of the recoveryloop test results on both baseline
> > and backport branch:
> >
> > generic,455, generic/457, generic/646: pass
> > generic/019, generic/475, generic/648: failing often in all config

<nod> I posted a couple of patchsets to fstests@ yesterday that might
help with these recoveryloop tests failing.

https://lore.kernel.org/fstests/165886493457.1585218.32410114728132213.stgit@magnolia/T/#t
https://lore.kernel.org/fstests/165886492580.1585149.760428651537119015.stgit@magnolia/T/#t
https://lore.kernel.org/fstests/165886491119.1585061.14285332087646848837.stgit@magnolia/T/#t

> > generic/388: failing often with reflink_1024
> > generic/388: failing at ~1/50 rate for any config
> > generic/482: failing often on V4 configs
> > generic/482: failing at ~1/100 rate for V5 configs
> > xfs/057: failing at ~1/200 rate for any config
> >
> > I observed no failures in soak group so far neither on baseline nor
> > on backport branch. I will update when I have more results.
> >
> 
> Some more results after 1.5 days of spinning:
> 1. soak group reached 100 runs (x5 configs) with no failures
> 2. Ran all the tests also on debian/testing with xfsprogs 5.18 and
>     observed a very similar fail/pass pattern as with xfsprogs 5.10
> 3. Started to run the 3 passing recoveryloop tests 1000 times and
>     an interesting pattern emerged -
> 
> generic/455 failed 3 times on baseline (out of 250 runs x 5 configs),
> but if has not failed on backport branch yet (700 runs x 5 configs).
> 
> And it's not just failures, it's proper data corruptions, e.g.
> "testfile2.mark1 md5sum mismatched" (and not always on mark1)

Oh good!


> 
> I will keep this loop spinning, but I am cautiously optimistic about
> this being an actual proof of bug fix.
> 
> If these results don't change, I would be happy to get an ACK for the
> series so I can post it after the long soaking.

Patches 4-9 are an easy
Acked-by: Darrick J. Wong <djwong@kernel.org>



--D

> Thanks,
> Amir.
