Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1BC9C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:24:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiJBSYF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiJBSYF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:24:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8372725295
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:24:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34B5AB80D81
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:24:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F0DC433D6;
        Sun,  2 Oct 2022 18:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735041;
        bh=e4BcLPqXbJzno2nuIG83GithbYwoO43JvmFOY9FVRnA=;
        h=Subject:From:To:Cc:Date:From;
        b=LB1NIUoMExraF5oRCCT7NBcP4XDGeMcxZ6CzBW++t0KzumY8aAUF0TqvfCSS+aWlI
         DQ6GeDWtz63FbjgKA65eAnQDfoKiHi0bs2I3b8yNJmX2LxMylwtgwPx3Q5GtvwYH2V
         I5Za+2bRvaIoUHJCiDo+KJMOb+x6V3eQxxDdYg08PFi/RW8tGa282Kj7iZ/y42frkB
         3bFXHwMEk71TYWoHx85aSowXH7js8riQmhVLVCuczdDhwa/bKoytwWL6eIDAP6ZyRO
         8i4PTYS4ipMIDwod5S7VcQh36S2spishCAenj7O0LGElVADUVQrMnYwtyyxNF7L33P
         fKs/jxojp9njA==
Subject: [PATCHSET v23.1 0/6] xfs: strengthen file mapping scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:08 -0700
Message-ID: <166473480864.1083927.11062319917293302327.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series strengthens the file extent mapping scrubber in various
ways, such as confirming that there are enough bmap records to match up
with the rmap records for this file, checking delalloc reservations,
checking for no unwritten extents in metadata files, invalid CoW fork
formats, and weird things like shared CoW fork extents.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-bmap-enhancements
---
 fs/xfs/scrub/bmap.c  |  147 ++++++++++++++++++++++++++++++++++++++++----------
 fs/xfs/scrub/quota.c |    6 +-
 2 files changed, 123 insertions(+), 30 deletions(-)

