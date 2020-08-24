Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D223FC433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 00:01:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8E4120720
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 00:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgHXABP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Aug 2020 20:01:15 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:56413 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726817AbgHXABP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Aug 2020 20:01:15 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 81483106C04;
        Mon, 24 Aug 2020 10:01:08 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k9zv9-0000mq-Vj; Mon, 24 Aug 2020 10:01:07 +1000
Date:   Mon, 24 Aug 2020 10:01:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 03/11] xfs: refactor default quota grace period setting
 code
Message-ID: <20200824000107.GL7941@dread.disaster.area>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
 <159797590685.965217.9321446937142682044.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159797590685.965217.9321446937142682044.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=P29xswxyXZqDUBmGjRgA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 07:11:47PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the code that sets the default quota grace period into a helper
> function so that we can override the ondisk behavior later.

Same comments as last patch.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
