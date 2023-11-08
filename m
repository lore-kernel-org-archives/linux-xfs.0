Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0380C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Nov 2023 21:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbjKHVpY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Nov 2023 16:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbjKHVpX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 16:45:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9038258A
        for <linux-xfs@vger.kernel.org>; Wed,  8 Nov 2023 13:45:21 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F4FC433CC;
        Wed,  8 Nov 2023 21:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699479921;
        bh=yGcXQaz+88ExucXh/JZc6d9VqW2YiOC6j2/6v9a+HzY=;
        h=Subject:From:To:Cc:Date:From;
        b=pVwxZPzgKnjFHdUzw6L2CjbeyUxdcK2gL1rm/OPceNO6c8q/Eu/nmcfWij6zBiSEK
         r1te1y1dr6rVoc1HDkijwe7RA7Zy9cWEY6kAqi0vmndZZHzxqddpEZXTE7W12EdR0I
         qV8NoeTqmEAX8EpNqPSfIPKoMH54vAVrnVQ3jUdvoombUSfAG/7RHVlYzaWsofzYQY
         mzZHTlKv5UociUUhd7qpIWDKt+qFVdB4fXa3rhLlT7QMA43jTtB32Y0AA8A8jI2iIE
         7KwCbfqGFA25WxGcT33S1viXGWDO8L6pH4NgLKThTeRtMAZm0sIb0/ztug09PKESca
         +ydXtBKYuTD3w==
Subject: [PATCHSET v27.0 0/2] fstests: FIEXCHANGE is now an XFS ioctl
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        guan@eryu.me
Date:   Wed, 08 Nov 2023 13:45:20 -0800
Message-ID: <169947992096.220003.8427995158013553083.stgit@frogsfrogsfrogs>
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
 m4/package_libcdev.m4 |   19 -------------------
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
 36 files changed, 99 insertions(+), 97 deletions(-)

