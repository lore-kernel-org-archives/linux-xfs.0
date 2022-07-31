Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8D0DC19F2A
	for <linux-xfs@archiver.kernel.org>; Sun, 31 Jul 2022 18:16:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233910AbiGaSQm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jul 2022 14:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiGaSQl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 31 Jul 2022 14:16:41 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE80DF2;
        Sun, 31 Jul 2022 11:16:40 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-118-63.bstnma.fios.verizon.net [173.48.118.63])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 26VIGYWH020810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Jul 2022 14:16:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1659291396; bh=gv3k/I3ni2BhAZC2iVsrn3pdkotSOs6VFQxiCCl/mzQ=;
        h=Date:From:To:Subject;
        b=jIiubI3HD7ZcoHRCMus3PuAy3MI9npQvnQ1edZor24IgjQbz7P/wV/98kzQDe7H6K
         SUUc6hCxt5B+G3hJs7G23qNFiPf8UGHGaUG1ZAVhH20pP/6umq9//iaYvaJkM2r1XS
         yWQspI0NM3DbsnyvtG7GnGdQuv+nv4ITs0juO0YGGOFBSYWJCOwTYiTW4KEzlr49iC
         lcsiUyk/pda5gxvbuDGhSGlKrmYzVgLJkcZp4ms7+ShZYqpSyBbAuqPJ+E5CV0bTqh
         qCAgo/fW0qmcUGQPWf4WeJ6QyOi+cQjdi05iDU/057c77TQ82k9ksVFNpOsGh6dPcS
         p7zvV0dAKqDXA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 76A4815C458B; Sun, 31 Jul 2022 14:16:34 -0400 (EDT)
Date:   Sun, 31 Jul 2022 14:16:34 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: generic/471 failing on linux-next -- KI?
Message-ID: <YubHAqTCPvNj10Mx@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I was just doing a last test of ext4 merged with linux-next before the
merge window opened, and I noticed generic/471 is now failing.  After
some more investigation it's failing for xfs and ext4, with the same
problem:

    --- tests/generic/471.out   2022-07-31 00:02:23.000000000 -0400
    +++ /results/xfs/results-4k/generic/471.out.bad     2022-07-31 14:11:47.045330411 0
    @@ -2,12 +2,10 @@
     pwrite: Resource temporarily unavailable
     wrote 8388608/8388608 bytes at offset 0
     XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
    -RWF_NOWAIT time is within limits.
    +pwrite: Resource temporarily unavailable
    +(standard_in) 1: syntax error
    +RWF_NOWAIT took  seconds
    ...

I haven't had a chance to bisect this yet, and for a day or two --- so
I figured I would ask --- is this a known issue?

This test was *not* failing on a kernel based on 5.19-rc5, so it looks
like something that got added in linux-next.

       	     	     	  	 - Ted
