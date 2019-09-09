Return-Path: <SRS0=Pnyc=XE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B2B0C4740A
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Sep 2019 23:28:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F2B721A4C
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Sep 2019 23:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390015AbfIIX2i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Sep 2019 19:28:38 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:38204 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390012AbfIIX2i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Sep 2019 19:28:38 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9363043D7AC;
        Tue, 10 Sep 2019 09:28:34 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1i7T5F-0006Iw-Ni; Tue, 10 Sep 2019 09:28:33 +1000
Date:   Tue, 10 Sep 2019 09:28:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs_spaceman: report health problems
Message-ID: <20190909232833.GE16973@dread.disaster.area>
References: <156774079152.2643029.531526071920135871.stgit@magnolia>
 <156774079788.2643029.845208737705520807.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156774079788.2643029.845208737705520807.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=aGhw0XUOHEzd7Uy2UDUA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 08:33:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the fs and ag geometry ioctls to report health problems to users.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  libfrog/fsgeom.c        |   16 ++
>  libfrog/fsgeom.h        |    1 
>  man/man8/xfs_spaceman.8 |   28 +++
>  spaceman/Makefile       |    2 
>  spaceman/health.c       |  459 +++++++++++++++++++++++++++++++++++++++++++++++
>  spaceman/init.c         |    1 
>  spaceman/space.h        |    1 
>  7 files changed, 507 insertions(+), 1 deletion(-)
>  create mode 100644 spaceman/health.c

Looks good. Minor nit below, but otherwise:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> +static int
> +report_bulkstat_health(
> +	xfs_agnumber_t		agno)
> +{
> +	struct xfs_bstat	bstat[BULKSTAT_NR];
> +	char			descr[256];
> +	uint64_t		startino = 0;
> +	uint64_t		lastino = -1ULL;
> +	uint32_t		ocount;
> +	uint32_t		i;
> +	int			error;
> +
> +	if (agno != NULLAGNUMBER) {
> +		startino = cvt_agino_to_ino(&file->xfd, agno, 0);
> +		lastino = cvt_agino_to_ino(&file->xfd, agno + 1, 0) - 1;
> +	}
> +
> +	while ((error = xfrog_bulkstat(&file->xfd, &startino, BULKSTAT_NR,
> +			bstat, &ocount) == 0) && ocount > 0) {
> +		for (i = 0; i < ocount; i++) {
> +			if (bstat[i].bs_ino > lastino)
> +				goto out;
> +			snprintf(descr, sizeof(descr) - 1, _("inode %llu"),
> +					bstat[i].bs_ino);
> +			report_sick(descr, inode_flags, bstat[i].bs_sick,
> +					bstat[i].bs_checked);
> +		}
> +	}

This could be done as a do { } while loop:

	do {
		error = xfrog_bulkstat(&file->xfd, &startino, BULKSTAT_NR,
					bstat, &ocount);
		if (error)
			break;
		for (i = 0; i < ocount; i++) {
			[....]
		}
	} while (ocount > 0);

This could be done as a followup patch as it's not critical, just
a little bit of cleanup...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
