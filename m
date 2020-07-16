Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBCA3C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 23:36:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD6982063A
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 23:36:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbgGPXgS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 19:36:18 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:35602 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725948AbgGPXgS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 19:36:18 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1AC8A7EB02F;
        Fri, 17 Jul 2020 09:36:14 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jwDQD-0001MZ-Jj; Fri, 17 Jul 2020 09:36:13 +1000
Date:   Fri, 17 Jul 2020 09:36:13 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/11] xfs: rename XFS_DQ_{USER,GROUP,PROJ} to
 XFS_DQTYPE_*
Message-ID: <20200716233613.GO2005@dread.disaster.area>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
 <159488193224.3813063.12478435320438781308.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159488193224.3813063.12478435320438781308.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=oueqcIOv51hR7F-S1ewA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 11:45:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We're going to split up the incore dquot state flags from the ondisk
> dquot flags (eventually renaming this "type") so start by renaming the
> three flags and the bitmask that are going to participate in this.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_dquot_buf.c   |    6 ++---
>  fs/xfs/libxfs/xfs_format.h      |    2 +-
>  fs/xfs/libxfs/xfs_quota_defs.h  |   16 +++++++-----
>  fs/xfs/scrub/quota.c            |    6 ++---
>  fs/xfs/scrub/repair.c           |    6 ++---
>  fs/xfs/xfs_buf_item_recover.c   |    6 ++---
>  fs/xfs/xfs_dquot.c              |   36 ++++++++++++++-------------
>  fs/xfs/xfs_dquot.h              |   22 ++++++++---------
>  fs/xfs/xfs_dquot_item_recover.c |   10 ++++----
>  fs/xfs/xfs_icache.c             |    4 ++-
>  fs/xfs/xfs_iomap.c              |   12 +++++----
>  fs/xfs/xfs_qm.c                 |   52 ++++++++++++++++++++-------------------
>  fs/xfs/xfs_qm.h                 |   26 ++++++++++----------
>  fs/xfs/xfs_qm_bhv.c             |    2 +-
>  fs/xfs/xfs_qm_syscalls.c        |   12 +++++----
>  fs/xfs/xfs_quota.h              |    6 ++---
>  fs/xfs/xfs_quotaops.c           |    6 ++---
>  fs/xfs/xfs_trans_dquot.c        |    4 ++-
>  18 files changed, 118 insertions(+), 116 deletions(-)

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
