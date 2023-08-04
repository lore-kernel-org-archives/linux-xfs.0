Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A24C001DE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Aug 2023 21:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjHDVSH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Aug 2023 17:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbjHDVRv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Aug 2023 17:17:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDE3E42;
        Fri,  4 Aug 2023 14:17:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0106D620B6;
        Fri,  4 Aug 2023 21:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638F5C433C7;
        Fri,  4 Aug 2023 21:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691183869;
        bh=p09xd1KbMuSTDo044K46jCzD2ljPcJasNDqi80myx3A=;
        h=Date:From:To:Cc:Subject:From;
        b=vPhqXzMKzPEbVF0/UJ/V+DV6Ck+54jcluDJEYWXxES0gjhxIkdrOzddYcjRi+h6jk
         SIZPR5QGk/A5DthBKacLK08XMfUfhy9GJaSfo1GjCzsl5uDcMeY7fBLiw1DY47u+Y9
         JbQBPPgy6BcM9Aqv++vjFwQxjXr2eZ6t1bUiJ/x2d5PV+wP4IXvHNaCdQuAXIDLonw
         EQ+rjCEw6AocqQ07QXT0AZdyBDp3ss/QVOZNySdskvOafoj1r5ufMvwS9rIsg0p//X
         xzrSAQ4DKwsgQaSt+kku07tlXSoW8RWOAunWUAhBx/pksD5+UtkUO1Qq/HC5d0NwAv
         6wuYjSzlfFg6A==
Date:   Fri, 4 Aug 2023 14:17:48 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH] generic/642: fix SOAK_DURATION usage in generic/642
Message-ID: <20230804211748.GN11340@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Misspelled variable name.  Yay bash.

Fixes: 3e85dd4fe4 ("misc: add duration for long soak tests")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/642 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/642 b/tests/generic/642
index e6a475a8b5..4d0c41fd5d 100755
--- a/tests/generic/642
+++ b/tests/generic/642
@@ -49,7 +49,7 @@ for verb in attr_remove removefattr; do
 done
 args+=('-f' "setfattr=20")
 args+=('-f' "attr_set=60")	# sets larger xattrs
-test -n "$DURATION" && args+=(--duration="$DURATION")
+test -n "$SOAK_DURATION" && args+=(--duration="$SOAK_DURATION")
 
 $FSSTRESS_PROG "${args[@]}" $FSSTRESS_AVOID -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus >> $seqres.full
 
