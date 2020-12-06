Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3083AC4361B
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F206622E03
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbgLFXwh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 18:52:37 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:58448 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726400AbgLFXwh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 18:52:37 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id B81E31ACED6;
        Mon,  7 Dec 2020 10:51:49 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1km3oi-001GJl-VY; Mon, 07 Dec 2020 10:51:48 +1100
Date:   Mon, 7 Dec 2020 10:51:48 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: refactor realtime volume extent validation
Message-ID: <20201206235148.GP3913616@dread.disaster.area>
References: <160729625074.1608297.13414859761208067117.stgit@magnolia>
 <160729626316.1608297.11622795343009336589.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160729626316.1608297.11622795343009336589.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=-Ag_vRqwMI3ehQTpFvIA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 06, 2020 at 03:11:03PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor all the open-coded validation of realtime device extents into a
> single helper.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
