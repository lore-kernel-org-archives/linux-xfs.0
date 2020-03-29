Return-Path: <SRS0=WYbU=5O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 715CEC43331
	for <linux-xfs@archiver.kernel.org>; Sun, 29 Mar 2020 23:04:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40E4720732
	for <linux-xfs@archiver.kernel.org>; Sun, 29 Mar 2020 23:04:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgC2XEg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 29 Mar 2020 19:04:36 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:37188 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726032AbgC2XEg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 29 Mar 2020 19:04:36 -0400
Received: from dread.disaster.area (pa49-179-23-206.pa.nsw.optusnet.com.au [49.179.23.206])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 71CCF3A245F;
        Mon, 30 Mar 2020 10:04:34 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jIgym-0005bZ-JN; Mon, 30 Mar 2020 10:04:32 +1100
Date:   Mon, 30 Mar 2020 10:04:32 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: don't write a corrupt unmount record to force
 summary counter recalc
Message-ID: <20200329230432.GW10776@dread.disaster.area>
References: <20200327011417.GF29339@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327011417.GF29339@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=n/Z79dAqQwRlp4tcgfhWYA==:117 a=n/Z79dAqQwRlp4tcgfhWYA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=ohl0Q0OiPZLrrdTzqvoA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 26, 2020 at 06:14:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In commit f467cad95f5e3, I added the ability to force a recalculation of
> the filesystem summary counters if they seemed incorrect.  This was done
> (not entirely correctly) by tweaking the log code to write an unmount
> record without the UMOUNT_TRANS flag set.  At next mount, the log
> recovery code will fail to find the unmount record and go into recovery,
> which triggers the recalculation.
> 
> What actually gets written to the log is what ought to be an unmount
> record, but without any flags set to indicate what kind of record it
> actually is.  This worked to trigger the recalculation, but we shouldn't
> write bogus log records when we could simply write nothing.
> 
> Fixes: f467cad95f5e3 ("xfs: force summary counter recalc at next mount")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_log.c |   27 ++++++++++++++-------------
>  1 file changed, 14 insertions(+), 13 deletions(-)

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
