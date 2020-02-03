Return-Path: <SRS0=dEjd=3X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D92C35247
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 23:15:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A345920732
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 23:15:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgBCXPO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Feb 2020 18:15:14 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:43939 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726331AbgBCXPN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Feb 2020 18:15:13 -0500
Received: from dread.disaster.area (pa49-181-161-120.pa.nsw.optusnet.com.au [49.181.161.120])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 4658B3A1DFF;
        Tue,  4 Feb 2020 10:15:11 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iykvu-0006Sa-34; Tue, 04 Feb 2020 10:15:10 +1100
Date:   Tue, 4 Feb 2020 10:15:10 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v2 1/7] xfs: Add xfs_is_{i,io,mmap}locked functions
Message-ID: <20200203231510.GD20628@dread.disaster.area>
References: <20200203175850.171689-1-preichl@redhat.com>
 <20200203175850.171689-2-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203175850.171689-2-preichl@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=SkgQWeG3jiSQFIjTo4+liA==:117 a=SkgQWeG3jiSQFIjTo4+liA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=3W1jmwQ0IJRVJLf8A-0A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 03, 2020 at 06:58:44PM +0100, Pavel Reichl wrote:
> Add xfs_is_ilocked(), xfs_is_iolocked() and xfs_is_mmaplocked()

The commit description is supposed to explain "Why?" rather than
describe what the code does.

So why are we adding these interfaces?

> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> Suggested-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_inode.h |  3 +++
>  2 files changed, 56 insertions(+)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c5077e6326c7..80874c80df6d 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -372,6 +372,59 @@ xfs_isilocked(
>  	ASSERT(0);
>  	return 0;
>  }
> +
> +static inline bool
> +__xfs_is_ilocked(
> +	struct rw_semaphore	*rwsem,
> +	bool			shared,
> +	bool			excl)
> +{
> +	bool locked = false;
> +
> +	if (!rwsem_is_locked(rwsem))
> +		return false;
> +
> +	if (!debug_locks)
> +		return true;
> +
> +	if (shared)
> +		locked = lockdep_is_held_type(rwsem, 0);
> +
> +	if (excl)
> +		locked |= lockdep_is_held_type(rwsem, 1);
> +
> +	return locked;
> +}

This needs a comment explaining the reason why it is structured this
way. I can see quite clearly what it is doing, but why it is done
this way is not immediately apparent from the code.

In a few months, I'm not going to remember the reasons for this
code, and if the neither the code nor the commit description
explains the reasons why the code is like this, then it's really
quite difficult and time consuming to try to discover the reason for
the code being this way.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
