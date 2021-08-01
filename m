Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE399C432BE
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Aug 2021 13:08:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E416610CF
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Aug 2021 13:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbhHANIm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 Aug 2021 09:08:42 -0400
Received: from out20-49.mail.aliyun.com ([115.124.20.49]:40275 "EHLO
        out20-49.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbhHANIm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Aug 2021 09:08:42 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.3515809|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_alarm|0.0885291-0.00263906-0.908832;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047204;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.KtqgI8c_1627823312;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.KtqgI8c_1627823312)
          by smtp.aliyun-inc.com(10.147.42.16);
          Sun, 01 Aug 2021 21:08:32 +0800
Date:   Sun, 1 Aug 2021 21:08:32 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 3/4] generic/570: fix regression when SCRATCH_DEV is
 still formatted
Message-ID: <YQac0CPbZrVDEjrT@desktop>
References: <162743097757.3427426.8734776553736535870.stgit@magnolia>
 <162743099423.3427426.15112820532966726474.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162743099423.3427426.15112820532966726474.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 27, 2021 at 05:09:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Newer versions of mkswap (or at least the one in util-linux 2.34)
> complain to stderr when they're formatting over a device that seems to
> contain existing data:
> 
>     mkswap: /dev/sdf: warning: wiping old btrfs signature.
> 
> This is harmless (since the swap image does get written!) but the extra
> golden output is flagged as a regression.  Update the mkswap usage in
> this test to dump the stderr output to $seqres.full, and complain if the
> exit code is nonzero.
> 
> This fixes a regression that the author noticed when testing btrfs and
> generic/507 and generic/570 run sequentially.  generic/507 calls
> _require_scratch_shutdown to see if the shutdown call is supported.
> btrfs does not support that, so the test is _notrun.  This leaves the
> scratch filesystem mounted, causing the _try_wipe_scratch_devs between
> tests to fail.  When g/570 starts up, the scratch device still contains

Won't your previous patch "check: don't leave the scratch filesystem
mounted after _notrun" fix this issue as well? As _notrun won't leaves
scratch dev mounted & unwiped after that patch. Would you please confirm?

Thanks,
Eryu

> leftovers from the failed attempt to run g/507, which is why the mkswap
> command outputs the above warning.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/generic/570 |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/tests/generic/570 b/tests/generic/570
> index 7d03acfe..02c1d333 100755
> --- a/tests/generic/570
> +++ b/tests/generic/570
> @@ -27,7 +27,7 @@ _require_scratch_nocheck
>  _require_block_device $SCRATCH_DEV
>  test -e /dev/snapshot && _notrun "userspace hibernation to swap is enabled"
>  
> -$MKSWAP_PROG "$SCRATCH_DEV" >> $seqres.full
> +$MKSWAP_PROG -f "$SCRATCH_DEV" &>> $seqres.full || echo "mkswap failed?"
>  
>  # Can you modify the swap dev via previously open file descriptors?
>  for verb in 1 2 3 4; do
