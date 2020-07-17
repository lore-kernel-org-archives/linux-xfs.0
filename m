Return-Path: <SRS0=+9Bg=A4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4FDBC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 00:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86CD2206F4
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 00:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgGQAIN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 20:08:13 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:39254 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725948AbgGQAIN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 20:08:13 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id A2889D5DA6A;
        Fri, 17 Jul 2020 10:08:07 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jwDv4-0001Xs-2V; Fri, 17 Jul 2020 10:08:06 +1000
Date:   Fri, 17 Jul 2020 10:08:06 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/11] xfs: create xfs_dqtype_t to represent quota types
Message-ID: <20200717000806.GV2005@dread.disaster.area>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
 <159488197642.3813063.4673664984532713595.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159488197642.3813063.4673664984532713595.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=lFzalqYIiyxPblJoTDMA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 11:46:16PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a new type (xfs_dqtype_t) to represent the type of an incore
> dquot (user, group, project, or none).  Rename the incore dquot's
> dq_flags field to q_type.
> 
> This allows us to replace all the "uint type" arguments to the quota
> functions with "xfs_dqtype_t type", to make it obvious when we're
> passing a quota type argument into a function.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_dquot_buf.c  |    2 +-
>  fs/xfs/libxfs/xfs_format.h     |    9 +++++++++
>  fs/xfs/libxfs/xfs_quota_defs.h |   27 ++++++++++++---------------
>  fs/xfs/scrub/quota.c           |    8 ++++----
>  fs/xfs/scrub/repair.c          |    4 ++--
>  fs/xfs/scrub/repair.h          |    4 +++-
>  fs/xfs/xfs_dquot.c             |   37 +++++++++++++++++++------------------
>  fs/xfs/xfs_dquot.h             |   33 +++++++++++++++++----------------
>  fs/xfs/xfs_iomap.c             |   24 ++++++++++++------------
>  fs/xfs/xfs_qm.c                |   22 +++++++++++-----------
>  fs/xfs/xfs_qm.h                |   26 ++++++++++++++++----------
>  fs/xfs/xfs_qm_syscalls.c       |    8 ++++----
>  fs/xfs/xfs_quota.h             |    4 ++--
>  fs/xfs/xfs_quotaops.c          |    2 +-
>  fs/xfs/xfs_trace.h             |   21 +++++++++++++++------
>  15 files changed, 128 insertions(+), 103 deletions(-)

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
