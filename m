Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36DC7C4320A
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 22:15:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 199DD6054F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 22:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbhHBWP3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 18:15:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231875AbhHBWPY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 2 Aug 2021 18:15:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8F566054F;
        Mon,  2 Aug 2021 22:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627942513;
        bh=2ZvbvWhK+KSmhDEFN3Z0gKZ1OLvE1zEi/p9SVqNGpDw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G3Y6kWeBY4REDACg0Qjpq9qTp7BOsg6tMXtYGvTeo5gdW3IuU9EJN8AAz0SCy+VEc
         M5u9gzyg0j6w5tu59zJdiTbg+6mufXAXIZpxU6XxSdu5qL6il+pi1B3cnGtM6rxX/A
         f4UYoBG/7yNX+UdKyFdaiKRci25TQS/Ms799Ved+eoWIfzQYh9vnEI0tI6Am8G8BpL
         n1OrNIRdDijagqd7Rwcs6OSFnkGDNmkg+BuTYEAdfPcTDKhFKe+SLOdHbok8Sn8MEc
         zRnlhmdYlpi/a6FxjLWRt6VOBKm2yQ4j4NJugA5sNkxs8nN5MtsnhEMfbKl/TEK2Z9
         uEiGQWOtJ9CCg==
Date:   Mon, 2 Aug 2021 15:15:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eryu Guan <guan@eryu.me>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 3/4] generic/570: fix regression when SCRATCH_DEV is
 still formatted
Message-ID: <20210802221513.GJ3601466@magnolia>
References: <162743097757.3427426.8734776553736535870.stgit@magnolia>
 <162743099423.3427426.15112820532966726474.stgit@magnolia>
 <YQac0CPbZrVDEjrT@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQac0CPbZrVDEjrT@desktop>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 01, 2021 at 09:08:32PM +0800, Eryu Guan wrote:
> On Tue, Jul 27, 2021 at 05:09:54PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Newer versions of mkswap (or at least the one in util-linux 2.34)
> > complain to stderr when they're formatting over a device that seems to
> > contain existing data:
> > 
> >     mkswap: /dev/sdf: warning: wiping old btrfs signature.
> > 
> > This is harmless (since the swap image does get written!) but the extra
> > golden output is flagged as a regression.  Update the mkswap usage in
> > this test to dump the stderr output to $seqres.full, and complain if the
> > exit code is nonzero.
> > 
> > This fixes a regression that the author noticed when testing btrfs and
> > generic/507 and generic/570 run sequentially.  generic/507 calls
> > _require_scratch_shutdown to see if the shutdown call is supported.
> > btrfs does not support that, so the test is _notrun.  This leaves the
> > scratch filesystem mounted, causing the _try_wipe_scratch_devs between
> > tests to fail.  When g/570 starts up, the scratch device still contains
> 
> Won't your previous patch "check: don't leave the scratch filesystem
> mounted after _notrun" fix this issue as well? As _notrun won't leaves
> scratch dev mounted & unwiped after that patch. Would you please confirm?

Yes.  In the end this patch becomes more about failing the test if
mkswap fails than anything else.

--D

> Thanks,
> Eryu
> 
> > leftovers from the failed attempt to run g/507, which is why the mkswap
> > command outputs the above warning.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/generic/570 |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > 
> > diff --git a/tests/generic/570 b/tests/generic/570
> > index 7d03acfe..02c1d333 100755
> > --- a/tests/generic/570
> > +++ b/tests/generic/570
> > @@ -27,7 +27,7 @@ _require_scratch_nocheck
> >  _require_block_device $SCRATCH_DEV
> >  test -e /dev/snapshot && _notrun "userspace hibernation to swap is enabled"
> >  
> > -$MKSWAP_PROG "$SCRATCH_DEV" >> $seqres.full
> > +$MKSWAP_PROG -f "$SCRATCH_DEV" &>> $seqres.full || echo "mkswap failed?"
> >  
> >  # Can you modify the swap dev via previously open file descriptors?
> >  for verb in 1 2 3 4; do
