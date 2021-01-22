Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB11EC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 21:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82C8723A7A
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 21:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbhAVVKg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Jan 2021 16:10:36 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:43513 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730555AbhAVVJK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jan 2021 16:09:10 -0500
Received: from dread.disaster.area (pa49-180-243-77.pa.nsw.optusnet.com.au [49.180.243.77])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 68B1E8DD1;
        Sat, 23 Jan 2021 08:08:22 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1l33fI-001KyH-Kv; Sat, 23 Jan 2021 08:08:20 +1100
Date:   Sat, 23 Jan 2021 08:08:20 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: refactor xfs_file_fsync
Message-ID: <20210122210820.GE4662@dread.disaster.area>
References: <20210122164643.620257-1-hch@lst.de>
 <20210122164643.620257-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122164643.620257-2-hch@lst.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=juxvdbeFDU67v5YkIhU0sw==:117 a=juxvdbeFDU67v5YkIhU0sw==:17
        a=kj9zAlcOel0A:10 a=EmqxpYm9HcoA:10 a=in2YdIHcAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=9axWC5lwl49RHUwTxuIA:9 a=CjuIK1q_8ugA:10
        a=jvJaD-jWAXz1fu1h5wd8:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 22, 2021 at 05:46:42PM +0100, Christoph Hellwig wrote:
> Factor out the log syncing logic into two helpers to make the code easier
> to read and more maintainable.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
