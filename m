Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 140ADC43334
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jun 2022 22:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351685AbiFEW1G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jun 2022 18:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351693AbiFEW1E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jun 2022 18:27:04 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9CBABDF7B
        for <linux-xfs@vger.kernel.org>; Sun,  5 Jun 2022 15:27:02 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 18FA05EC96D;
        Mon,  6 Jun 2022 08:27:00 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nxyi2-0038iZ-La; Mon, 06 Jun 2022 08:26:58 +1000
Date:   Mon, 6 Jun 2022 08:26:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: fix variable state usage control knob
Message-ID: <20220605222658.GK1098723@dread.disaster.area>
References: <YpzbrQdA9voYKRCE@magnolia>
 <YpzcY0ockNGsv5PR@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YpzcY0ockNGsv5PR@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=629d2db4
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=IkcTkHD0fZMA:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=rZzICKGa2mWf3QfdrmwA:9 a=QEXdDO2ut3YA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 05, 2022 at 09:40:03AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The variable @args is fed to a tracepoint, and that's the only place
> it's used.  This is fine for the kernel, but for userspace, tracepoints
> are #define'd out of existence, which results in this warning on gcc
> 11.2:
> 
> xfs_attr.c: In function ‘xfs_attr_node_try_addname’:
> xfs_attr.c:1440:42: warning: unused variable ‘args’ [-Wunused-variable]
>  1440 |         struct xfs_da_args              *args = attr->xattri_da_args;
>       |                                          ^~~~
> 
> Clean this up.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Yeah, I noticed this in the xfsprogs libxfs port and fixed it there
on the port by converting the xfs_attr3_leaf_add(... state->args)
parameter to use args. This way works too, and the xfsprogs libxfs
can easily be cleaned up in the next xfsprogs libxfs sync.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
