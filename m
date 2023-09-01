Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8645ECA0FE1
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Sep 2023 14:53:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350071AbjIAOxj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Sep 2023 10:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232246AbjIAOxi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2023 10:53:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F359CE7E;
        Fri,  1 Sep 2023 07:53:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 35CFBCE22C7;
        Fri,  1 Sep 2023 14:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B60CC433C7;
        Fri,  1 Sep 2023 14:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693580012;
        bh=10PsdMfdVKov+1D/1U7o8o3hKnI1CouI7N8ujcy0UJw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m8w9JtFRHUgRqpU6A2kafdyaVpZMNAdUavOJfN1DuNxzYHI2HvJPLqW515nFlhd2N
         yN9xi6ANca6PC13f7osV1e5X3msqC05PFiagGbVrJ4TsgQmR1MFAnPQxTucX8UXgv6
         CNNnMNRQasqAOup3vp+ROxz/r7lDxG32ALT1T3p1hqOEoi8o+do62WNn1qAS9sRmKH
         +t5cYLSgOHzlHpz6eFx769/uKK4OPSl/iWQmLCaSCP+bzSp0SYXCZOPrbX8F0me16p
         Qj3lGoW+hfGBLOAAG1ulvjTpAmM1+LXk6DRwiZL2apNr6RSqXdhIGjCTaLSIAObPeQ
         pTHAjk9NmoUkw==
Date:   Fri, 1 Sep 2023 07:53:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: [PATCH v2 1/2] generic/61[67]: support SOAK_DURATION
Message-ID: <20230901145331.GP28186@frogsfrogsfrogs>
References: <169335094811.3534600.13011878728080983620.stgit@frogsfrogsfrogs>
 <169335095385.3534600.13449847282467855019.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169335095385.3534600.13449847282467855019.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that I've finally gotten liburing installed on my test machine, I
can actually test io_uring.  Adapt these two tests to support
SOAK_DURATION so I can add it to that too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v2: add to soak group
---
 tests/generic/616 |    3 ++-
 tests/generic/617 |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tests/generic/616 b/tests/generic/616
index 538b480ba7..5b0b02c5e4 100755
--- a/tests/generic/616
+++ b/tests/generic/616
@@ -8,7 +8,7 @@
 # fsx ops to limit the testing time to be an auto group test.
 #
 . ./common/preamble
-_begin_fstest auto rw io_uring stress
+_begin_fstest auto rw io_uring stress soak
 
 # Import common functions.
 . ./common/filter
@@ -33,6 +33,7 @@ fsx_args+=(-N $nr_ops)
 fsx_args+=(-p $((nr_ops / 100)))
 fsx_args+=(-o $op_sz)
 fsx_args+=(-l $file_sz)
+test -n "$SOAK_DURATION" && fsx_args+=(--duration="$SOAK_DURATION")
 
 run_fsx "${fsx_args[@]}" | sed -e '/^fsx.*/d'
 
diff --git a/tests/generic/617 b/tests/generic/617
index 3bb3112e99..a977870023 100755
--- a/tests/generic/617
+++ b/tests/generic/617
@@ -8,7 +8,7 @@
 # fsx ops to limit the testing time to be an auto group test.
 #
 . ./common/preamble
-_begin_fstest auto rw io_uring stress
+_begin_fstest auto rw io_uring stress soak
 
 # Import common functions.
 . ./common/filter
@@ -39,6 +39,7 @@ fsx_args+=(-r $min_dio_sz)
 fsx_args+=(-t $min_dio_sz)
 fsx_args+=(-w $min_dio_sz)
 fsx_args+=(-Z)
+test -n "$SOAK_DURATION" && fsx_args+=(--duration="$SOAK_DURATION")
 
 run_fsx "${fsx_args[@]}" | sed -e '/^fsx.*/d'
 
