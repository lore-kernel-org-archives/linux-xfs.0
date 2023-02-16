Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7F50C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjBPUcO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBPUcN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:32:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74543196A9;
        Thu, 16 Feb 2023 12:32:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E06FDCE24A9;
        Thu, 16 Feb 2023 20:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3862EC433EF;
        Thu, 16 Feb 2023 20:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579529;
        bh=cYgZ65YwF9VUXYmPXMOy+IpSZagV2X0B5toKAmtIGPI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=RG5zK9lM0VMwNxjG354g+qz1/75Y37zuMxHjx7A4ZLOlcE6BXmefM5Ll0um+Wf+Cw
         KOhPe9V4HFAwkpqZYPc9uhhsW8n4W0Ia+BPVnRr/17NZOTXRtAYJlaOcZCVFetHE3J
         ozCM1caehOq5arFde0gOdaZUDv/k3fgejhBH7woxSNmFsNBBwLK1HYm/KLR/cXBbwA
         N0c6kMmwQ4vYs2GE4UMZRbqV37gT8/3BPFdFiWpXVPWDS0QxntQELa0yKZKhkEdz15
         7nI53/foHIYfM3owlm3PMkoSInUQiXAYR6SBDDgxAhOYeeBexEUQZ1Nmi7UurYLOSH
         nCG4P630iXlUA==
Date:   Thu, 16 Feb 2023 12:32:08 -0800
Subject: [PATCHSET 00/14] fstests: adjust tests for xfs parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167657884480.3481377.14824439551809919632.stgit@magnolia>
In-Reply-To: <Y+6MxEgswrJMUNOI@magnolia>
References: <Y+6MxEgswrJMUNOI@magnolia>
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
 tests/generic/050                    |    9 
 tests/generic/050.cfg                |    1 
 tests/generic/050.out.xfsquotaparent |   23 +
 tests/xfs/018                        |    7 
 tests/xfs/021                        |   15 -
 tests/xfs/021.cfg                    |    1 
 tests/xfs/021.out.default            |    0 
 tests/xfs/021.out.parent             |   64 ++
 tests/xfs/122.out                    |    4 
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

