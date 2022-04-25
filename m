Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE20C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Apr 2022 22:42:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235070AbiDYWpz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Apr 2022 18:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234222AbiDYWpy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Apr 2022 18:45:54 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EF63B473B1
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 15:42:48 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id CD2E110E5C57;
        Tue, 26 Apr 2022 08:42:47 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nj7Pq-004WbY-Ke; Tue, 26 Apr 2022 08:42:46 +1000
Date:   Tue, 26 Apr 2022 08:42:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [RFC PATCH v1 2/2] xfs: don't set warns on the id==0 dquot
Message-ID: <20220425224246.GJ1544202@dread.disaster.area>
References: <20220421165815.87837-1-catherine.hoang@oracle.com>
 <20220421165815.87837-3-catherine.hoang@oracle.com>
 <20220422014017.GV1544202@dread.disaster.area>
 <05AA5136-1853-4296-8C56-8153A34F44D1@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05AA5136-1853-4296-8C56-8153A34F44D1@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=626723e8
        a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=7-415B0cAAAA:8 a=yPCof4ZbAAAA:8
        a=VwQbUJbxAAAA:8 a=5keI9wPO6EiDr-IcIcAA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 25, 2022 at 03:34:52PM +0000, Catherine Hoang wrote:
> > On Apr 21, 2022, at 6:40 PM, Dave Chinner <david@fromorbit.com> wrote:
> > 
> > On Thu, Apr 21, 2022 at 09:58:15AM -0700, Catherine Hoang wrote:
> >> Quotas are not enforced on the id==0 dquot, so the quota code uses it
> >> to store warning limits and timeouts.  Having just dropped support for
> >> warning limits, this field no longer has any meaning.  Return -EINVAL
> >> for this dquot id if the fieldmask has any of the QC_*_WARNS set.
> >> 
> >> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> >> ---
> >> fs/xfs/xfs_qm_syscalls.c | 2 ++
> >> 1 file changed, 2 insertions(+)
> >> 
> >> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> >> index e7f3ac60ebd9..bdbd5c83b08e 100644
> >> --- a/fs/xfs/xfs_qm_syscalls.c
> >> +++ b/fs/xfs/xfs_qm_syscalls.c
> >> @@ -290,6 +290,8 @@ xfs_qm_scall_setqlim(
> >> 		return -EINVAL;
> >> 	if ((newlim->d_fieldmask & XFS_QC_MASK) == 0)
> >> 		return 0;
> >> +	if ((newlim->d_fieldmask & QC_WARNS_MASK) && id == 0)
> >> +		return -EINVAL;
> > 
> > Why would we do this for only id == 0? This will still allow
> > non-zero warning values to be written to dquots that have id != 0,
> > but I'm not sure why we'd allow this given that the previous
> > patch just removed all the warning limit checking?
> > 
> > Which then makes me ask: why are we still reading the warning counts
> > from on disk dquots and writing in-memory values back to dquots?
> > Shouldn't xfs_dquot_to_disk() just write zeros to the warning fields
> > now, and xfs_dquot_from_disk() elide reading the warning counts
> > altogether? i.e. can we remove d_bwarns, d_iwarns and d_rtbwarns
> > from the struct fs_disk_quota altogether now?
> > 
> > Which then raises the question of whether copy_from_xfs_dqblk() and
> > friends should still support warn counts up in fs/quota/quota.c...?
> 
> The intent of this patchset is to only remove warning limits, not warning
> counts. The id == 0 dquot stores warning limits, so we no longer want
> warning values to be written here. Dquots with id != 0 store warning
> counts, so we still allow these values to be updated. 

Why? What uses the value? After this patchset the warning count is
not used anywhere in the kernel. Absent in-kernel enforced limits,
the warning count fundamentally useless as a userspace decision tool
because of the warning count is not deterministic in any way.
Nothing can be inferred about the absolute value of the count
because it can't be related back to individual user operations.

i.e. A single write() can get different numbers of warnings issuedi
simply because of file layout or inode config (e.g. DIO vs buffered,
writes into sparse regions, unwritten regions, if extent size hints
are enabled, etc) and so the absolute magnitude of the warning count
doesn't carry any significant meaning.

I still haven't seen a use case for these quota warning counts,
either with or without the limiting code. Who needs this, and why?

> In regards to whether or not warning counts should be removed, it seems
> like they currently do serve a purpose. Although there's some debate about
> this in a previous thread:
> https://lore.kernel.org/linux-xfs/20220303003808.GM117732@magnolia/

Once the warning count increment is removed, there are zero users of
the warning counts.

Legacy functionality policy (as defined by ALLOCSP removal) kicks in
here: remove anything questionable ASAP, before it bites us hard.
And this has already bitten us real hard...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
