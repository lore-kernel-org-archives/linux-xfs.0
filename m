Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7EE2C3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 23:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99DF02087E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 23:32:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729471AbfIDXcR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 19:32:17 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33960 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727156AbfIDXcR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 19:32:17 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 0EE5443E274;
        Thu,  5 Sep 2019 09:32:14 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5el4-00008v-Dm; Thu, 05 Sep 2019 09:32:14 +1000
Date:   Thu, 5 Sep 2019 09:32:14 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/12] libfrog: move fsgeom.h to libfrog/
Message-ID: <20190904233214.GT1119@dread.disaster.area>
References: <156757174409.1838135.8885359673458816401.stgit@magnolia>
 <156757177526.1838135.183624284465092358.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156757177526.1838135.183624284465092358.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=N0GP8Yvq2OC_SIqX5ZUA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 03, 2019 at 09:36:15PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move this header to libfrog since the code is there already.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/info.c           |    2 +
>  fsr/xfs_fsr.c       |    2 +
>  growfs/xfs_growfs.c |    2 +
>  include/fsgeom.h    |  102 ---------------------------------------------------
>  io/bmap.c           |    2 +
>  io/fsmap.c          |    2 +
>  io/imap.c           |    2 +
>  io/open.c           |    2 +
>  io/stat.c           |    2 +
>  io/swapext.c        |    2 +
>  libfrog/Makefile    |    1 +
>  libfrog/fsgeom.h    |  102 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  mkfs/xfs_mkfs.c     |    2 +
>  quota/free.c        |    2 +
>  quota/quot.c        |    2 +
>  repair/xfs_repair.c |    2 +
>  rtcp/xfs_rtcp.c     |    2 +
>  scrub/inodes.c      |    2 +
>  scrub/phase1.c      |    2 +
>  scrub/xfs_scrub.h   |    2 +
>  spaceman/file.c     |    2 +
>  spaceman/info.c     |    2 +
>  22 files changed, 122 insertions(+), 121 deletions(-)
>  delete mode 100644 include/fsgeom.h
>  create mode 100644 libfrog/fsgeom.h

Looks good. One thing I noticed though:

> diff --git a/libfrog/fsgeom.h b/libfrog/fsgeom.h
> new file mode 100644
> index 00000000..6993dafb
> --- /dev/null
> +++ b/libfrog/fsgeom.h
> @@ -0,0 +1,102 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2000-2005 Silicon Graphics, Inc.  All Rights Reserved.

This copyright is largely stale now. AFAICT, there's no original SGI
code in this header file at all. Separate patch with a commit
message explaining the copyright update?

Otherwise looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
