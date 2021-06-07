Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C63C4743E
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 01:41:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7A7D610A8
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 01:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhFGBm7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Jun 2021 21:42:59 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:41699 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230099AbhFGBm7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Jun 2021 21:42:59 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 623E68623BD;
        Mon,  7 Jun 2021 11:40:55 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lq4G6-009pnL-7q; Mon, 07 Jun 2021 11:40:54 +1000
Date:   Mon, 7 Jun 2021 11:40:54 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 2/3] xfs: drop IDONTCACHE on inodes when we mark them sick
Message-ID: <20210607014054.GB664593@dread.disaster.area>
References: <162300204472.1202529.17352653046483745148.stgit@locust>
 <162300205695.1202529.8468586379242468573.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162300205695.1202529.8468586379242468573.stgit@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=xHPwnTOxUFtpnuzrqGEA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 06, 2021 at 10:54:17AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When we decide to mark an inode sick, clear the DONTCACHE flag so that
> the incore inode will be kept around until memory pressure forces it out
> of memory.  This increases the chances that the sick status will be
> caught by someone compiling a health report later on.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_health.c |    9 +++++++++
>  1 file changed, 9 insertions(+)

LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
