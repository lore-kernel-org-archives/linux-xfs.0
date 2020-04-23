Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F9F5C2BA19
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 04:55:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5943206B9
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 04:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbgDWEzD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 00:55:03 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:45886 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725854AbgDWEzD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 00:55:03 -0400
Received: from dread.disaster.area (pa49-180-0-232.pa.nsw.optusnet.com.au [49.180.0.232])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 4435C3A4371;
        Thu, 23 Apr 2020 14:55:00 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jRTt5-0000Pr-Jn; Thu, 23 Apr 2020 14:54:59 +1000
Date:   Thu, 23 Apr 2020 14:54:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 09/13] xfs: clean up AIL log item removal functions
Message-ID: <20200423045459.GK27860@dread.disaster.area>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-10-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422175429.38957-10-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=XYjVcjsg+1UI/cdbgX7I7g==:117 a=XYjVcjsg+1UI/cdbgX7I7g==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=A_9m50bce8_LDx_uPpgA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 22, 2020 at 01:54:25PM -0400, Brian Foster wrote:
> We have two AIL removal functions with slightly different semantics.
> xfs_trans_ail_delete() expects the caller to have the AIL lock and
> for the associated item to be AIL resident. If not, the filesystem
> is shut down. xfs_trans_ail_remove() acquires the AIL lock, checks
> that the item is AIL resident and calls the former if so.
> 
> These semantics lead to confused usage between the two. For example,
> the _remove() variant takes a shutdown parameter to pass to the
> _delete() variant, but immediately returns if the AIL bit is not
> set. This means that _remove() would never shut down if an item is
> not AIL resident, even though it appears that many callers would
> expect it to.
> 
> Make the following changes to clean up both of these functions:
> 
> - Most callers of xfs_trans_ail_delete() acquire the AIL lock just
>   before the call. Update _delete() to acquire the lock and open
>   code the couple of callers that make additional checks under AIL
>   lock.
> - Drop the unnecessary ailp parameter from _delete().
> - Drop the unused shutdown parameter from _remove() and open code
>   the implementation.
> 
> In summary, this leaves a _delete() variant that expects an AIL
> resident item and a _remove() helper that checks the AIL bit. Audit
> the existing callsites for use of the appropriate function and
> update as necessary.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

In conjunction with the followed patch to combine the remove and
delete functions, I'm good with this.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
