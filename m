Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ADF2C3DA7D
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:15:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbiL3XPj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:15:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiL3XPi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:15:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DBD1D0C0;
        Fri, 30 Dec 2022 15:15:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E25EB61C3A;
        Fri, 30 Dec 2022 23:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EE9C433D2;
        Fri, 30 Dec 2022 23:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442136;
        bh=QWAuxTMF0CbtnTKs/1bHLdhFFC2ZdpaCwdf+GMHui3A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jpDHVBz1atjHEWyS3Aue3T0558O9GDaHPLMeUZifbhD592459srUU69U2wIxG5OP+
         vF3MR3dc09PlDBgzgu6PEWfwEhtkubgcbmyUEgBog0GWboMe7ukfEg9kzRZoq0slC2
         8bwjLNtR1dSm3cIs0Z88fjobFS4U/gLYTwj23XL+6NSfYZax5OQvVEiVtsPh+FcuZ1
         UDHqeu1SF2yeZNzs2uiG2Hy5K3ZqsuUadU63n4jZHeGNqDhd0WPIeuuknuEnfrmCkA
         ueQEWlKSXurX3IKkZwJKVGZ8mRuts6Gm7xG2He1c0zUILEqcc/DRcH8wP6n6akrSi5
         +/TSsgObp87Eg==
Subject: [PATCHSET v24.0 0/5] fstests: race online scrub with fsstress
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:06 -0800
Message-ID: <167243874614.722028.11987534226186856347.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Now that we've created a whole loop control infrastructure to ensure
that we can race fsstress and xfs_scrub's rmapbt scanning code, expand
the testing to scrubs of every other type of space and file metadata.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-rtsummary

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-rtsummary
---
 common/fuzzy          |  166 +++++++++++++++++++++++++++-
 common/quota          |   64 +++++++++++
 configure.ac          |    5 +
 doc/group-names.txt   |    1 
 include/builddefs.in  |    4 +
 m4/package_libcdev.m4 |   47 ++++++++
 m4/package_xfslibs.m4 |   16 +++
 src/Makefile          |   10 ++
 src/xfsfind.c         |  290 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/357         |    2 
 tests/xfs/782         |   37 ++++++
 tests/xfs/782.out     |    2 
 tests/xfs/783         |   37 ++++++
 tests/xfs/783.out     |    2 
 tests/xfs/784         |   37 ++++++
 tests/xfs/784.out     |    2 
 tests/xfs/785         |   37 ++++++
 tests/xfs/785.out     |    2 
 tests/xfs/786         |   38 ++++++
 tests/xfs/786.out     |    2 
 tests/xfs/787         |   38 ++++++
 tests/xfs/787.out     |    2 
 tests/xfs/788         |   38 ++++++
 tests/xfs/788.out     |    2 
 tests/xfs/789         |   39 +++++++
 tests/xfs/789.out     |    2 
 tests/xfs/790         |   39 +++++++
 tests/xfs/790.out     |    2 
 tests/xfs/791         |   40 +++++++
 tests/xfs/791.out     |    2 
 tests/xfs/792         |   38 ++++++
 tests/xfs/792.out     |    2 
 tests/xfs/793         |   37 ++++++
 tests/xfs/793.out     |    2 
 tests/xfs/794         |   39 +++++++
 tests/xfs/794.out     |    2 
 tests/xfs/795         |   39 +++++++
 tests/xfs/795.out     |    2 
 tests/xfs/796         |   37 ++++++
 tests/xfs/796.out     |    2 
 tests/xfs/797         |   40 +++++++
 tests/xfs/797.out     |    2 
 tests/xfs/798         |   44 +++++++
 tests/xfs/798.out     |    2 
 tests/xfs/799         |   38 ++++++
 tests/xfs/799.out     |    2 
 tests/xfs/800         |   40 +++++++
 tests/xfs/800.out     |    2 
 tests/xfs/801         |   47 ++++++++
 tests/xfs/801.out     |    2 
 tests/xfs/802         |   40 +++++++
 tests/xfs/802.out     |    2 
 tests/xfs/803         |   40 +++++++
 tests/xfs/803.out     |    2 
 tests/xfs/804         |   40 +++++++
 tests/xfs/804.out     |    2 
 tests/xfs/805         |   38 ++++++
 tests/xfs/805.out     |    2 
 tests/xfs/826         |   38 ++++++
 tests/xfs/826.out     |    2 
 tests/xfs/827         |   39 +++++++
 tests/xfs/827.out     |    2 
 62 files changed, 1662 insertions(+), 9 deletions(-)
 create mode 100644 src/xfsfind.c
 create mode 100755 tests/xfs/782
 create mode 100644 tests/xfs/782.out
 create mode 100755 tests/xfs/783
 create mode 100644 tests/xfs/783.out
 create mode 100755 tests/xfs/784
 create mode 100644 tests/xfs/784.out
 create mode 100755 tests/xfs/785
 create mode 100644 tests/xfs/785.out
 create mode 100755 tests/xfs/786
 create mode 100644 tests/xfs/786.out
 create mode 100755 tests/xfs/787
 create mode 100644 tests/xfs/787.out
 create mode 100755 tests/xfs/788
 create mode 100644 tests/xfs/788.out
 create mode 100755 tests/xfs/789
 create mode 100644 tests/xfs/789.out
 create mode 100755 tests/xfs/790
 create mode 100644 tests/xfs/790.out
 create mode 100755 tests/xfs/791
 create mode 100644 tests/xfs/791.out
 create mode 100755 tests/xfs/792
 create mode 100644 tests/xfs/792.out
 create mode 100755 tests/xfs/793
 create mode 100644 tests/xfs/793.out
 create mode 100755 tests/xfs/794
 create mode 100644 tests/xfs/794.out
 create mode 100755 tests/xfs/795
 create mode 100644 tests/xfs/795.out
 create mode 100755 tests/xfs/796
 create mode 100644 tests/xfs/796.out
 create mode 100755 tests/xfs/797
 create mode 100644 tests/xfs/797.out
 create mode 100755 tests/xfs/798
 create mode 100644 tests/xfs/798.out
 create mode 100755 tests/xfs/799
 create mode 100644 tests/xfs/799.out
 create mode 100755 tests/xfs/800
 create mode 100644 tests/xfs/800.out
 create mode 100755 tests/xfs/801
 create mode 100644 tests/xfs/801.out
 create mode 100755 tests/xfs/802
 create mode 100644 tests/xfs/802.out
 create mode 100755 tests/xfs/803
 create mode 100644 tests/xfs/803.out
 create mode 100755 tests/xfs/804
 create mode 100644 tests/xfs/804.out
 create mode 100755 tests/xfs/805
 create mode 100644 tests/xfs/805.out
 create mode 100755 tests/xfs/826
 create mode 100644 tests/xfs/826.out
 create mode 100755 tests/xfs/827
 create mode 100644 tests/xfs/827.out

