Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8A70C54FC9
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 03:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EAEF214AF
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 03:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgDTDK4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 19 Apr 2020 23:10:56 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:52350 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725896AbgDTDK4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Apr 2020 23:10:56 -0400
Received: from dread.disaster.area (pa49-180-0-232.pa.nsw.optusnet.com.au [49.180.0.232])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 6E2183A30E6;
        Mon, 20 Apr 2020 13:10:54 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jQMph-0007yU-Ub; Mon, 20 Apr 2020 13:10:53 +1000
Date:   Mon, 20 Apr 2020 13:10:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/12] xfs: remove unnecessary shutdown check from
 xfs_iflush()
Message-ID: <20200420031053.GG9800@dread.disaster.area>
References: <20200417150859.14734-1-bfoster@redhat.com>
 <20200417150859.14734-5-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417150859.14734-5-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=XYjVcjsg+1UI/cdbgX7I7g==:117 a=XYjVcjsg+1UI/cdbgX7I7g==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=I_BVbZVNeh88xNH7idIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 17, 2020 at 11:08:51AM -0400, Brian Foster wrote:
> The shutdown check in xfs_iflush() duplicates checks down in the
> buffer code. If the fs is shut down, xfs_trans_read_buf_map() always
> returns an error and falls into the same error path. Remove the
> unnecessary check along with the warning in xfs_imap_to_bp()
> that generates excessive noise in the log if the fs is shut down.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
