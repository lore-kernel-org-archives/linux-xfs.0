Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 109A0C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjEZCAF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjEZCAE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:00:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FEDE7;
        Thu, 25 May 2023 19:00:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F86064C45;
        Fri, 26 May 2023 02:00:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8632C433D2;
        Fri, 26 May 2023 02:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066401;
        bh=NUXboTrnOb/PC+9DQwpQyEXWw6zheVznB+um4a1CUBM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=q/uKEpR+ftOpj+0dXx7h8TdAbAJL19z65u3owC+KYjjUR+uDi/6VzDmAkcWiuMC1/
         d3Pt9ROnjgTajvhg3CT6R60CfU95TT2jPm8CX+mDZUcHzcdTeLkxieclihUEJ3Xbzk
         7/eWOEOWGqQ3cuZtdzKlAhFpGAb8m2+kf4FE/H9EYCcVnQCJ+oNmQiVG6S3X0J0J6U
         QbTPwC3GjwSsuui7urnhD3oYclcFrRBfhiu7pBRFWvgXX3YjCND3OGdabtCFS3BaJp
         2XWXkxtbXo96ewjIyQwnKhi5pBBQQtELEf6hn1S4QcNP9H9HfCQzwRz+//LVSWuTjJ
         0Gw7z7pIBSgGQ==
Date:   Thu, 25 May 2023 19:00:01 -0700
Subject: [PATCHSET RFC v12.0 00/11] fstests: adjust tests for xfs parent
 pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        allison.henderson@oracle.com, catherine.hoang@oracle.com
Message-ID: <168506060845.3732476.15364197106064737675.stgit@frogsfrogsfrogs>
In-Reply-To: <20230526000710.GG11642@frogsfrogsfrogs>
References: <20230526000710.GG11642@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

These are the test adjustments that are required for parent pointers.
There's also a few new tests to ensure that the GETPARENTS ioctl (and
 file extent can cross an rtgroup boundary.

The best advantage for rtgroups will become evident later when we get to
adding rmap and reflink to the realtime volume, since the geometry
constraints are the same for rt groups and AGs.  Hence we can reuse all
that code directly.

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
 tests/generic/050                    |   20 +
 tests/generic/050.cfg                |    1 
 tests/generic/050.out.xfsquotaparent |   23 +
 tests/xfs/018                        |    7 
 tests/xfs/021                        |   15 -
 tests/xfs/021.cfg                    |    1 
 tests/xfs/021.out.default            |    0 
 tests/xfs/021.out.parent             |   62 ++
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
 25 files changed, 1778 insertions(+), 13 deletions(-)
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

