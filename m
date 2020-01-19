Return-Path: <SRS0=5eVt=3I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42B31C33CAF
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Jan 2020 21:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 164B5206B7
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Jan 2020 21:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgASV7O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 19 Jan 2020 16:59:14 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:40656 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727556AbgASV7O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Jan 2020 16:59:14 -0500
Received: from dread.disaster.area (pa49-181-172-170.pa.nsw.optusnet.com.au [49.181.172.170])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 38F517E92CD;
        Mon, 20 Jan 2020 08:59:09 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1itIb5-0007l3-4M; Mon, 20 Jan 2020 08:59:07 +1100
Date:   Mon, 20 Jan 2020 08:59:07 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 03/11] xfs: make xfs_buf_get return an error code
Message-ID: <20200119215907.GF9407@dread.disaster.area>
References: <157924221149.3029431.1461924548648810370.stgit@magnolia>
 <157924223066.3029431.11184155620620599754.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157924223066.3029431.11184155620620599754.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=IIEU8dkfCNxGYurWsojP/w==:117 a=IIEU8dkfCNxGYurWsojP/w==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=JuDxSlhT3OO6blO4plAA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 16, 2020 at 10:23:50PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert xfs_buf_get() to return numeric error codes like most
> everywhere else in xfs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Same comments about xfs_buf_get() vs xfs_buf_get_map() as the last
patch (i.e. replace xfs_buf_get with xfs_buf_get_map).

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
