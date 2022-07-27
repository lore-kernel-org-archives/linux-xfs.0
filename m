Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70E1EC3F6B0
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jul 2022 14:59:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233985AbiG0O76 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jul 2022 10:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbiG0O75 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jul 2022 10:59:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF7A2DA8C;
        Wed, 27 Jul 2022 07:59:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BA8861870;
        Wed, 27 Jul 2022 14:59:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E46C433C1;
        Wed, 27 Jul 2022 14:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658933995;
        bh=AQRwrovBJ4L4+1kQ/Yg6TQiCSBV2+eYI0yAMZhTsNG0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f+sdntA12QbmgyYStSzyKX1hcut66YncvFCmwOknu5FUrly2jHPPLYTyHVPOnUS1D
         dqfdHpNiylZqJaLAueKu84FPRKD9Nu9thLaY2s84U08MICkPFk0fUyjf/EBWU0VsFz
         d5bdZF5xJGerozAbIBojONS7jYp+sBYIKDEte2Q51/yswO4YFBKliRxj201TaZfrMl
         c5Cw6haqUkpdblea40fcftWTXNyKVUunT+MshszXDK9wSkSgFZRP47i9aRKPbdLHDM
         Ce8qI8DJ0WSivC7uCUXAeUlBc10xLPco+kh3SqnBW1LoBhpD7cCDhq1wEqeUNocRAC
         g0BLPO2YNhzPw==
Date:   Wed, 27 Jul 2022 07:59:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs/432: fix this test when external devices are in use
Message-ID: <YuFS6/9iMXzjv/YX@magnolia>
References: <YuBFw4dheeSRHVQd@magnolia>
 <20220727122142.ktp5loclqazchncw@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727122142.ktp5loclqazchncw@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 27, 2022 at 08:21:42PM +0800, Zorro Lang wrote:
> On Tue, Jul 26, 2022 at 12:51:31PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > This program exercises metadump and mdrestore being run against the
> > scratch device.  Therefore, the test must pass external log / rt device
> > arguments to xfs_repair -n to check the "restored" filesystem.  Fix the
> > incorrect usage, and report repair failures, since this test has been
> > silently failing for a while now.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/432 |   11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tests/xfs/432 b/tests/xfs/432
> > index 86012f0b..5c6744ce 100755
> > --- a/tests/xfs/432
> > +++ b/tests/xfs/432
> > @@ -89,7 +89,16 @@ _scratch_xfs_metadump $metadump_file -w
> >  xfs_mdrestore $metadump_file $metadump_img
> >  
> >  echo "Check restored metadump image"
> > -$XFS_REPAIR_PROG -n $metadump_img >> $seqres.full 2>&1
> > +repair_args=('-n')
> > +[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
> > +	repair_args+=('-l' "$SCRATCH_LOGDEV")
> > +
> > +[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
> > +	repair_args+=('-r' "$SCRATCH_RTDEV")
> > +
> > +$XFS_REPAIR_PROG "${repair_args[@]}" $metadump_img >> $seqres.full 2>&1
> > +res=$?
> > +test $res -ne 0 && echo "xfs_repair on restored fs returned $res?"
> 
> Make sense to me, I don't have better idea. One question, is xfs_metadump
> and xfs_mdrestore support rtdev? Due to I didn't find xfs_metadump have
> a "-r" option, although it has "-l logdev" :)

Oops, no it doesn't, so I'll remove that.

> About the "$res", I don't know why we need this extra variable, as it's
> not used in other place.

If you don't pass the correct arguments to xfs_repair or the metadump
trashes the fs, it'll exit with a nonzero code.  All the output goes to
$seqres.full, which means the test runner has no idea anything went
wrong and marks the test passed even though repair failed.

--D

> Thanks,
> Zorro
> 
> >  
> >  # success, all done
> >  status=0
> > 
> 
