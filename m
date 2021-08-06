Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6F62C4338F
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 23:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E89B60EE9
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 23:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237450AbhHFXFV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 19:05:21 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:53691 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230280AbhHFXFV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 19:05:21 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 7F04380BD69;
        Sat,  7 Aug 2021 09:05:02 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mC8th-00FLLP-G1; Sat, 07 Aug 2021 09:05:01 +1000
Date:   Sat, 7 Aug 2021 09:05:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 00/29] xfsprogs: Drop the 'platform_' prefix
Message-ID: <20210806230501.GG2757197@dread.disaster.area>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=7-415B0cAAAA:8
        a=oTah5r6sZWEs-UvQSI4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 06, 2021 at 11:22:49PM +0200, Pavel Reichl wrote:
> Stop using commands with 'platform_' prefix. Either use directly linux
> standard command or drop the prefix from the function name.

Looks like all of the patches in this series are missing
signed-off-by lines.  Most of them have empty commit messages, too,
which we don't tend to do very often.

>  51 files changed, 284 insertions(+), 151 deletions(-)

IMO, 29 patches for such a small change is way too fine grained for
working through efficiently.  Empty commit messages tend to be a
sign that you can aggregate patches together.... i.e.  One patch for
all the uuid changes (currently 7 patches) with a description of why
you're changing the platform_uuid interface, one for all the mount
related stuff (at least 5 patches now), one for all the block device
stuff (8 or so patches), one for all the path bits, and then one for
whatever is left over.

Every patch has overhead, be it to produce, maintain, review, test,
merge, etc. Breaking stuff down unnecessarily just increases the
amount of work everyone has to do at every step. So if you find that
you are writing dozens of patches that each have a trivial change in
them that you are boiler-plating commit messages, you've probably
made the overall changeset too fine grained.

Also....

>  libxfs/init.c               | 32 ++++++------
>  libxfs/libxfs_io.h          |  2 +-
>  libxfs/libxfs_priv.h        |  3 +-
>  libxfs/rdwr.c               |  4 +-
>  libxfs/xfs_ag.c             |  6 +--
>  libxfs/xfs_attr_leaf.c      |  2 +-
>  libxfs/xfs_attr_remote.c    |  2 +-
>  libxfs/xfs_btree.c          |  4 +-
>  libxfs/xfs_da_btree.c       |  2 +-
>  libxfs/xfs_dir2_block.c     |  2 +-
>  libxfs/xfs_dir2_data.c      |  2 +-
>  libxfs/xfs_dir2_leaf.c      |  2 +-
>  libxfs/xfs_dir2_node.c      |  2 +-
>  libxfs/xfs_dquot_buf.c      |  2 +-
>  libxfs/xfs_ialloc.c         |  4 +-
>  libxfs/xfs_inode_buf.c      |  2 +-
>  libxfs/xfs_sb.c             |  6 +--
>  libxfs/xfs_symlink_remote.c |  2 +-

Why are all these libxfs files being changed?

$ git grep -l platform libxfs/
libxfs/init.c
libxfs/libxfs_io.h
libxfs/libxfs_priv.h
libxfs/rdwr.c
libxfs/xfs_log_format.h
$

IOWs, there are calls to platform_*() functions in most of these
libxfs files, so what is being changed here? If these are code
changes, then they will end up needed to be ported across to the
kernel libxfs, too.

I did a quick scan of a few of the patches but I didn't land on the
one that had these changes in it; another reason for not doing stuff
in such fine grained ways. Hence it's not clear to me why renaming
platform_*() functions would touch these files.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
