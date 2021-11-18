Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A94C9C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Nov 2021 04:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8119560EFD
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Nov 2021 04:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239312AbhKREqx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Nov 2021 23:46:53 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:36145 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241924AbhKREqv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Nov 2021 23:46:51 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 284EC1093D9;
        Thu, 18 Nov 2021 15:43:48 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mnZH1-00AAmR-Hr; Thu, 18 Nov 2021 15:43:47 +1100
Date:   Thu, 18 Nov 2021 15:43:47 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/16] xfs: embed the xlog_op_header in the commit record
Message-ID: <20211118044347.GW449541@dread.disaster.area>
References: <20211109015055.1547604-1-david@fromorbit.com>
 <20211109015055.1547604-5-david@fromorbit.com>
 <YYzNhAdj9xPGO5HX@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYzNhAdj9xPGO5HX@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6195da04
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=kj9zAlcOel0A:10 a=vIxV3rELxO4A:10 a=7-415B0cAAAA:8
        a=U41ynZoNYofviH7sKOcA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 11, 2021 at 12:00:04AM -0800, Christoph Hellwig wrote:
> On Tue, Nov 09, 2021 at 12:50:43PM +1100, Dave Chinner wrote:
> > -			if (optype & XLOG_START_TRANS) {
> > +			if (optype) {
> 
> Shouldn't this explicitly check for XLOG_START_TRANS or
> XLOG_UNMOUNT_TRANS?  The cont flags can't really happen here, so it
> won't make a functional difference, but it would document the intent
> much better.

This scaffolding disappears completely in a couple of patches time,
so it's not worth the effort to polishing it to perfection.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!
-- 
Dave Chinner
david@fromorbit.com
