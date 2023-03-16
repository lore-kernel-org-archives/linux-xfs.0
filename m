Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20DBBC6FD19
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjCPTTj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbjCPTTe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:19:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA8EE4DB8;
        Thu, 16 Mar 2023 12:19:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C42B3B8231F;
        Thu, 16 Mar 2023 19:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D2EC433EF;
        Thu, 16 Mar 2023 19:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994349;
        bh=W3Ay8IKgL1TERa+P4vMjoInX1ZzW1IRcL1ibD6JeHvs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Z7FXZw0c7uQTlvLRyc77KmQ8AQbmVcmiDkEd9r5U57opky+sn4n9Z1Jfov7rH6w5f
         04172M3sBBXUyYDvzkFcPH4CQr2T7591F9lP/8pEq7SX1VCY7/qU6ZXeTRLzIPE8e3
         gLiB6TDEHBlP6rduzMRFjpVnsMd2HQVWRp+FMN/T1zIHGFIEF7hEEwvws+z1PdxD2q
         9UlEemJSJBi8s/0jQ2do5S2BLAR0BqKpFT1P8u7KWnigborPHcbYvNevFIrOj+TTA7
         O4zo7utSBXG4CgCGO6m/yCuTx0vUd4/Whrdw5Fg4EmeHJpUFeJ0w9kemt7/5TdU8qA
         QKDWrsS6SNrCw==
Date:   Thu, 16 Mar 2023 12:19:09 -0700
Subject: [PATCHSET v10r1d2 00/14] fstests: adjust tests for xfs parent
 pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167899417650.17926.7405859750613330339.stgit@frogsfrogsfrogs>
In-Reply-To: <20230316185414.GH11394@frogsfrogsfrogs>
References: <20230316185414.GH11394@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Adjust fstests as necessary to test the new xfs parent pointers feature.
At some point this section needs to grow some specific functionality
tests for repair and dumping.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=pptrs
---
 common/parent                        |  209 +++++++
 common/populate                      |   38 +
 common/rc                            |    7 
 common/xfs                           |   12 
 doc/group-names.txt                  |    1 
 src/popdir.pl                        |   11 
 tests/generic/050                    |   10 
 tests/generic/050.cfg                |    1 
 tests/generic/050.out.xfsquotaparent |   23 +
 tests/xfs/018                        |    7 
 tests/xfs/021                        |   15 -
 tests/xfs/021.cfg                    |    1 
 tests/xfs/021.out.default            |    0 
 tests/xfs/021.out.parent             |   64 ++
 tests/xfs/122.out                    |    3 
 tests/xfs/191                        |    7 
 tests/xfs/206                        |    3 
 tests/xfs/288                        |    7 
 tests/xfs/306                        |    9 
 tests/xfs/851                        |  116 ++++
 tests/xfs/851.out                    |   69 ++
 tests/xfs/852                        |   69 ++
 tests/xfs/852.out                    | 1002 ++++++++++++++++++++++++++++++++++
 tests/xfs/853                        |   85 +++
 tests/xfs/853.out                    |   14 
 25 files changed, 1772 insertions(+), 11 deletions(-)
 create mode 100644 common/parent
 create mode 100644 tests/generic/050.out.xfsquotaparent
 create mode 100644 tests/xfs/021.cfg
 rename tests/xfs/{021.out => 021.out.default} (100%)
 create mode 100644 tests/xfs/021.out.parent
 create mode 100755 tests/xfs/851
 create mode 100644 tests/xfs/851.out
 create mode 100755 tests/xfs/852
 create mode 100644 tests/xfs/852.out
 create mode 100755 tests/xfs/853
 create mode 100644 tests/xfs/853.out

