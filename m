Return-Path: <SRS0=DGLX=WX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D87CCC3A5A3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 07:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B252321881
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 07:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbfH0HLK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 03:11:10 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46874 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725825AbfH0HLK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Aug 2019 03:11:10 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C619E436DAD;
        Tue, 27 Aug 2019 17:11:07 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i2VdC-0003gx-BC; Tue, 27 Aug 2019 17:11:06 +1000
Date:   Tue, 27 Aug 2019 17:11:06 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] libfrog: create online fs geometry converters
Message-ID: <20190827071106.GD1119@dread.disaster.area>
References: <156633303230.1215733.4447734852671168748.stgit@magnolia>
 <156633305717.1215733.17610092313024714477.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156633305717.1215733.17610092313024714477.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=9yvanKfmdTXZScau3TQA:9
        a=gh2_tVxYjMzojynW:21 a=oDG3rhvxQqKvqBBx:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 20, 2019 at 01:30:57PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create helper functions to perform unit conversions against a runtime
> filesystem, then remove the open-coded versions in scrub.

.... and there they are...

> +/* Convert fs block number into bytes */
> +static inline uint64_t
> +xfrog_fsb_to_b(
> +	const struct xfs_fd	*xfd,
> +	uint64_t		fsb)
> +{
> +	return fsb << xfd->blocklog;
> +}

FWIW, this is for converting linear offsets in fsb /units/, not the
sparse fsbno (= agno | agbno) to bytes. I've always found it a bit
nasty that this distinction is not clearly made in the core FSB
conversion macros.

perhaps off_fsb_to_b?

> +/* Convert bytes into (rounded down) fs block number */
> +static inline uint64_t
> +xfrog_b_to_fsbt(
> +	const struct xfs_fd	*xfd,
> +	uint64_t		bytes)
> +{
> +	return bytes >> xfd->blocklog;
> +}

Ditto.

Otherwise looks ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
