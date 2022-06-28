Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB41C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 22:55:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiF1WzG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 18:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiF1WzF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 18:55:05 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CB84519C05
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 15:55:04 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id EC7165ECE1F;
        Wed, 29 Jun 2022 08:55:02 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o6K6n-00CFGk-Ob; Wed, 29 Jun 2022 08:55:01 +1000
Date:   Wed, 29 Jun 2022 08:55:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 0/8] xfsprogs: sync libxfs with 5.19
Message-ID: <20220628225501.GM227878@dread.disaster.area>
References: <165644930619.1089724.12201433387040577983.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165644930619.1089724.12201433387040577983.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62bb86c8
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=wyDEJGck7kJVUeCukb4A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 28, 2022 at 01:48:26PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This series corrects any build errors in libxfs and backports libxfs
> changes from the kernel.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-5.19-sync
> ---
>  db/check.c               |   10 +++++++---
>  db/metadump.c            |   11 +++++++----
>  include/xfs_mount.h      |    7 -------
>  libxfs/util.c            |    6 ------
>  libxfs/xfs_attr.c        |   47 ++++++++++++++--------------------------------
>  libxfs/xfs_attr.h        |   17 +----------------
>  libxfs/xfs_attr_leaf.c   |   37 ++++++++++++++++++++----------------
>  libxfs/xfs_attr_leaf.h   |    3 +--
>  libxfs/xfs_da_btree.h    |    4 +++-
>  logprint/log_print_all.c |    2 +-
>  repair/attr_repair.c     |   20 ++++++++++++++++++++
>  repair/dinode.c          |   14 ++++++++++----
>  12 files changed, 84 insertions(+), 94 deletions(-)

Whole series looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
