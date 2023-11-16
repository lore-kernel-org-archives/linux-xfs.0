Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33D56C197A0
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Nov 2023 17:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbjKPRag (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Nov 2023 12:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbjKPRaf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Nov 2023 12:30:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E4F1A8
        for <linux-xfs@vger.kernel.org>; Thu, 16 Nov 2023 09:30:32 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47201C433C8;
        Thu, 16 Nov 2023 17:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700155832;
        bh=hK9n+5IEXIzvqFK2so19votrvVnEE8T2XLLkdRWlfIw=;
        h=Subject:From:To:Cc:Date:From;
        b=BMaAXho63yZBTSesl3m2H1rb66k9C/uGZQqJ+LGT4TNTJDQm0jHA706X+AebZQUOa
         ZeQWdajIbOW89oyAp4M2vIXClgIUm5P8dasr5j6RLq3tuy73cZccwcxaTWetf+RL97
         AhLtEoQI3UoL4uFbkm4SmLOsB0tj0dZvTP5/uIe87moUL5VdexIj2HOAj4Xx5dpRlh
         aOVCUvOCIekoyMv434IOdowxc/R/3+neoOrNwvx4tj6bEh8xTPt0FTN/ygDspwI6LK
         zwT7Hi5LsHYzoWDIOKPDTaXzQhfggelfwz99G8vpgqpvBcuCPCVNiMwjpcO51hSOYd
         AXWLRGTins2Tw==
Subject: [PATCHSET v27.1 0/2] fstests: FIEXCHANGE is now an XFS ioctl
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
        guan@eryu.me, linux-xfs@vger.kernel.org
Date:   Thu, 16 Nov 2023 09:30:31 -0800
Message-ID: <170015583180.3369423.8659956273233504193.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Minor amendments to the fstests code now that we've taken FIEXCHANGE
private to XFS.

v27.1: add hch review tags; rebase and maybe fix merge problems?

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=private-fiexchange
---
 common/xfs            |    2 +-
 configure.ac          |    2 +-
 doc/group-names.txt   |    2 +-
 include/builddefs.in  |    2 +-
 ltp/Makefile          |    4 ++--
 ltp/fsstress.c        |   10 +++++-----
 ltp/fsx.c             |   20 ++++++++++----------
 m4/package_libcdev.m4 |   20 --------------------
 m4/package_xfslibs.m4 |   14 ++++++++++++++
 src/Makefile          |    4 ++++
 src/fiexchange.h      |   44 ++++++++++++++++++++++----------------------
 src/global.h          |    4 +---
 src/vfs/Makefile      |    4 ++++
 tests/generic/709     |    2 +-
 tests/generic/710     |    2 +-
 tests/generic/711     |    2 +-
 tests/generic/712     |    2 +-
 tests/generic/713     |    4 ++--
 tests/generic/714     |    4 ++--
 tests/generic/715     |    4 ++--
 tests/generic/716     |    2 +-
 tests/generic/717     |    2 +-
 tests/generic/718     |    2 +-
 tests/generic/719     |    2 +-
 tests/generic/720     |    2 +-
 tests/generic/722     |    4 ++--
 tests/generic/723     |    6 +++---
 tests/generic/724     |    6 +++---
 tests/generic/725     |    2 +-
 tests/generic/726     |    2 +-
 tests/generic/727     |    2 +-
 tests/xfs/122.out     |    1 +
 tests/xfs/789         |    2 +-
 tests/xfs/790         |    2 +-
 tests/xfs/791         |    6 +++---
 tests/xfs/792         |    2 +-
 36 files changed, 99 insertions(+), 98 deletions(-)

