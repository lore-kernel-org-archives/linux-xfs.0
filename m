Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B3DAC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 03:01:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52C22610A5
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 03:01:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235679AbhHSDC3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 23:02:29 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:45614 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235743AbhHSDC3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Aug 2021 23:02:29 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id D3E788574E;
        Thu, 19 Aug 2021 13:01:51 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mGYJP-002MPa-Jl; Thu, 19 Aug 2021 13:01:47 +1000
Date:   Thu, 19 Aug 2021 13:01:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/15] xfs: disambiguate units for ftrace fields tagged
 "len"
Message-ID: <20210819030147.GZ3657114@dread.disaster.area>
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <162924378154.761813.12918362378497157448.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162924378154.761813.12918362378497157448.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=HyKVQVrN__wzxTguOF8A:9 a=N66jXuK6_n6sh4hm:21 a=F4ECKou_g6u-gahr:21
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 17, 2021 at 04:43:01PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Some of our tracepoints have a field known as "len".  That name doesn't
> describe any units, which makes the fields not very useful.  Rename the
> fields to capture units and ensure the format is hexadecimal.
> 
> "blockcount" are in units of fs blocks
> "daddrcount" are in units of 512b blocks

Hmmm. This is the first set of units I'll consider suggesting a
change in naming - "blockcount" seems ambiguous and easily mistaken,
while "daddrcount" just seems a bit wierd. Perhaps:

"fsbcount" is a length in units of fs blocks
"bbcount" is a length in units of basic (512b) blocks

.....
> @@ -2363,7 +2363,7 @@ DECLARE_EVENT_CLASS(xfs_log_recover_icreate_item_class,
>  		__entry->length = be32_to_cpu(in_f->icl_length);
>  		__entry->gen = be32_to_cpu(in_f->icl_gen);
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno 0x%x count %u isize %u length %u "
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x count %u isize %u blockcount 0x%x "
>  		  "gen %u", MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno, __entry->agbno, __entry->count, __entry->isize,
>  		  __entry->length, __entry->gen)

THis one could probably do with a bit of help - count is the number
of inodes, so the order of the tracepoint probably should be
reworked to put the fsbcount directly after the agbno. i.e.

TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x isize %u count %u gen %u",
....

The rest of the conversions look good, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
