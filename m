Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03DBECA9EAE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 22:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D22E420874
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 22:30:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbfJ2WaA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 18:30:00 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:44017 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725830AbfJ2WaA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 18:30:00 -0400
Received: from dread.disaster.area (pa49-180-67-183.pa.nsw.optusnet.com.au [49.180.67.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7378B7E9788;
        Wed, 30 Oct 2019 09:29:56 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iPZzv-0006db-EI; Wed, 30 Oct 2019 09:29:55 +1100
Date:   Wed, 30 Oct 2019 09:29:55 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: properly serialise fallocate against AIO+DIO
Message-ID: <20191029222955.GO4614@dread.disaster.area>
References: <20191029034850.8212-1-david@fromorbit.com>
 <20191029041908.GB15222@magnolia>
 <20191029044133.GN4614@dread.disaster.area>
 <20191029100342.GA41131@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029100342.GA41131@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=3wLbm4YUAFX2xaPZIabsgw==:117 a=3wLbm4YUAFX2xaPZIabsgw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=7-415B0cAAAA:8 a=VJdo7SFpqPpZvIhtoxgA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 29, 2019 at 06:03:42AM -0400, Brian Foster wrote:
> On Tue, Oct 29, 2019 at 03:41:33PM +1100, Dave Chinner wrote:
> 
> FWIW, I find something like the following a bit more clear/concise on
> the whole:
> 
>         /*
> +        * Once AIO and DIO has drained we flush and (if necessary) invalidate
> +        * the cached range over the first operation we are about to run. We
> +        * include zero and collapse here because they both start with a hole
> +        * punch over the target range. Insert and collapse both invalidate the
> +        * broader range affected by the shift in xfs_prepare_shift().
>          */

Yup, much better. Thanks! :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
