Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C748C3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 23:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F87A2087E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 23:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730303AbfIDXev (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 19:34:51 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:58390 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728008AbfIDXeu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 19:34:50 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id F2AEA2AD941;
        Thu,  5 Sep 2019 09:34:48 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5enX-00009n-QR; Thu, 05 Sep 2019 09:34:47 +1000
Date:   Thu, 5 Sep 2019 09:34:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] libfrog: move workqueue.h to libfrog/
Message-ID: <20190904233447.GW1119@dread.disaster.area>
References: <156757174409.1838135.8885359673458816401.stgit@magnolia>
 <156757179417.1838135.16722106490569097057.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156757179417.1838135.16722106490569097057.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=S7K-1uwK9QwFmhLa_p8A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 03, 2019 at 09:36:34PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move this header to libfrog since the code is there already.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  include/workqueue.h |   41 -----------------------------------------
>  libfrog/Makefile    |    3 ++-
>  libfrog/workqueue.h |   41 +++++++++++++++++++++++++++++++++++++++++
>  repair/threads.h    |    2 +-
>  scrub/fscounters.c  |    2 +-
>  scrub/inodes.c      |    2 +-
>  scrub/phase1.c      |    2 +-
>  scrub/phase2.c      |    2 +-
>  scrub/phase3.c      |    2 +-
>  scrub/phase4.c      |    2 +-
>  scrub/phase5.c      |    2 +-
>  scrub/phase6.c      |    2 +-
>  scrub/read_verify.c |    2 +-
>  scrub/spacemap.c    |    2 +-
>  scrub/vfs.c         |    2 +-
>  15 files changed, 55 insertions(+), 54 deletions(-)
>  delete mode 100644 include/workqueue.h
>  create mode 100644 libfrog/workqueue.h

ok.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> diff --git a/libfrog/workqueue.h b/libfrog/workqueue.h
> new file mode 100644
> index 00000000..a1f3a57c
> --- /dev/null
> +++ b/libfrog/workqueue.h
> @@ -0,0 +1,41 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2017 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + */
> +#ifndef	__LIBFROG_WORKQUEUE_H__
> +#define	__LIBFROG_WORKQUEUE_H__

FWIW, I like that these all have consistent guards now :)

-Dave.

-- 
Dave Chinner
david@fromorbit.com
