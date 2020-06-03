Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B4DC433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 01:27:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD9A92072F
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 01:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgFCB1o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 21:27:44 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:48112 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726112AbgFCB1o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 21:27:44 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 4AD3C105523;
        Wed,  3 Jun 2020 11:27:39 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jgIBq-0001xj-Qv; Wed, 03 Jun 2020 11:27:34 +1000
Date:   Wed, 3 Jun 2020 11:27:34 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: get rid of unnecessary xfs_perag_{get,put} pairs
Message-ID: <20200603012734.GL2040@dread.disaster.area>
References: <20200602145238.1512-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602145238.1512-1-hsiangkao@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=gqxXG31ye7YwG1LAwNUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 10:52:38PM +0800, Gao Xiang wrote:
> Sometimes no need to play with perag_tree since for many
> cases perag can also be accessed by agbp reliably.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Hi Xiang,

One of the quirks of XFS is that we tend towards commit messages
that explain the reason for the change than the actual change being
made in the commit message. That means we'll put iinformation about
how to reproduce bugs, the problem that needed to be solved,
assumptions that are being made, etc into the commit message rather
than describe what the change being made is. We can see what the
change is from the code, but we may not be able to understand why
the change is being made from reading the code.

Hence we try to put the "why?" into the commit message so that
everyone reviewing the code knows this information without having to
ask. This also means that we capture the reasons/thinking/issues
that the commit address in the code repository and hence when we
look up a change (e.g. when considering if we need to back port it
to another kernel), we have a good idea of what problem that change
is addressing. It also means that in a few months/years time when
we've forgotten exactly why a specific change was made, the commit
message should contain enough detail to remind us.

Perhaps something like this?

	In the course of some operations, we look up the perag from
	the mount multiple times to get or change perag information.
	These are often very short pieces of code, so while the
	lookup cost is generally low, the cost of the lookup is far
	higher than the cost of the operation we are doing on the
	perag.

	Since we changed buffers to hold references to the perag
	they are cached in, many modification contexts already hold
	active references to the perag that are held across these
	operations. This is especially true for any operation that
	is serialised by an allocation group header buffer.

	In these cases, we can just use the buffer's reference to
	the perag to avoid needing to do lookups to access the
	perag. This means that many operations don't need to do
	perag lookups at all to access the perag because they've
	already looked up objects that own persistent references
	and hence can use that reference instead.

The first paragraph explains the problem. The second paragraph
explains the underlying assumption the change depends on. And the
third paragraph defines the scope we can apply the general pattern
to.

It takes a while to get used to doing this - for any major change I
tend to write the series description first (the requirements and
design doc), then for each patch I write the commit message before
I start modifying the code (detailed design). Treating the commit
messages as design documentation really helps other people
understand the changes being made....

> ---
> Not sure addressing all the cases, but seems mostly.
> Kindly correct me if something wrong somewhere...
> 
>  fs/xfs/libxfs/xfs_ag.c             |  4 ++--
>  fs/xfs/libxfs/xfs_alloc.c          | 22 ++++++-----------
>  fs/xfs/libxfs/xfs_alloc_btree.c    | 10 ++++----
>  fs/xfs/libxfs/xfs_ialloc.c         | 28 ++++++----------------
>  fs/xfs/libxfs/xfs_refcount_btree.c |  5 ++--
>  fs/xfs/libxfs/xfs_rmap_btree.c     |  5 ++--
>  fs/xfs/xfs_inode.c                 | 38 +++++++++---------------------
>  7 files changed, 35 insertions(+), 77 deletions(-)

There were more places using this pattern than I thought. :)

With an updated commit message,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
