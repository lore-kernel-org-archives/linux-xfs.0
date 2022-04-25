Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8680C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Apr 2022 22:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbiDYWZl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Apr 2022 18:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236746AbiDYWYw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Apr 2022 18:24:52 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 074E178906
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 15:21:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 804B310E5F06;
        Tue, 26 Apr 2022 08:21:42 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nj75Q-004WAn-1K; Tue, 26 Apr 2022 08:21:40 +1000
Date:   Tue, 26 Apr 2022 08:21:40 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 0/2] xfs: remove quota warning limits
Message-ID: <20220425222140.GI1544202@dread.disaster.area>
References: <20220421165815.87837-1-catherine.hoang@oracle.com>
 <43e8df67-5916-5f4a-ce85-8521729acbb2@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e8df67-5916-5f4a-ce85-8521729acbb2@sandeen.net>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62671ef6
        a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=5xOlfOR4AAAA:8
        a=7-415B0cAAAA:8 a=rTYq5MppkApK2LRI79cA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=SGlsW6VomvECssOqsvzv:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 25, 2022 at 01:19:35PM -0500, Eric Sandeen wrote:
> On 4/21/22 11:58 AM, Catherine Hoang wrote:
> > Hi all,
> > 
> > Based on recent discussion, it seems like there is a consensus that quota
> > warning limits should be removed from xfs quota.
> > https://lore.kernel.org/linux-xfs/94893219-b969-c7d4-4b4e-0952ef54d575@sandeen.net/
> > 
> > Warning limits in xfs quota is an unused feature that is currently
> > documented as unimplemented. These patches remove the quota warning limits
> > and cleans up any related code. 
> > 
> > Comments and feedback are appreciated!
> > 
> > Catherine
> > 
> > Catherine Hoang (2):
> >   xfs: remove quota warning limit from struct xfs_quota_limits
> >   xfs: don't set warns on the id==0 dquot
> > 
> >  fs/xfs/xfs_qm.c          |  9 ---------
> >  fs/xfs/xfs_qm.h          |  5 -----
> >  fs/xfs/xfs_qm_syscalls.c | 19 +++++--------------
> >  fs/xfs/xfs_quotaops.c    |  3 ---
> >  fs/xfs/xfs_trans_dquot.c |  3 +--
> >  5 files changed, 6 insertions(+), 33 deletions(-)
> 
> I have a question about the remaining warning counter infrastructure after these
> patches are applied.
> 
> We still have xfs_dqresv_check() incrementing the warning counter, as was added in
> 4b8628d5 "xfs: actually bump warning counts when we send warnings"
> 
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -589,6 +589,7 @@
>                         return QUOTA_NL_ISOFTLONGWARN;
>                 }
>  
> +               res->warnings++;
>                 return QUOTA_NL_ISOFTWARN;
>         }

/me reads another overnight #xfs explosion over this one line of
code and sighs.

Well, so much for hoping that there would be an amicable resolution
to this sorry saga without having to get directly involved.  I'm fed
up with watching the tantrums, the petty arguments, the refusal to
compromise, acknowledge mistakes, etc.

Enough, OK?

Commit 4b8628d5 is fundamentally broken and causes production
systems regressions - it just doesn't work in any useful way as it
stands.  Eric, send me a patch that reverts this commit, and I will
review and commit it.

Further:

- this is legacy functionality that was never implemented in Linux,
- it cannot be implemented in Linux the (useful) way it was
  implemented in Irix,
- it is documented as unimplemented,
- no use case for the functionality in Linux has been presented
  ("do something useful" is not a use case),
- no documentation has been written for it,
- no fstests coverage of the functionality exists,
- linux userspace already has quota warning infrastructure via
  netlink so just accounting warnings in the kernel is of very
  limited use,
- it broke existing production systems.

Given all this, and considering our new policy of not tolerating
unused or questionable legacy code in the XFS code base any more
(precendence: ALLOCSP), it is clear that all aspects of this quota
warning code should simply be removed ASAP.

Eric and/or Catherine, please send patches to first revert 4b8628d5
and then remove *all* of this quota warning functionality completely
(including making the user APIs see zeros on all reads and sliently
ignore all writes) before I get sufficiently annoyed to simply
remove the code directly myself.

So disappointment.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
