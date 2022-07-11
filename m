Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D6F6C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jul 2022 23:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiGKXyq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 19:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiGKXyq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 19:54:46 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 983AD2BB38
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jul 2022 16:54:45 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id DF2F162C906;
        Tue, 12 Jul 2022 09:54:44 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oB3Eh-00HOEH-8W; Tue, 12 Jul 2022 09:54:43 +1000
Date:   Tue, 12 Jul 2022 09:54:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs: move and xfs_trans_committed_bulk
Message-ID: <20220711235443.GH3861211@dread.disaster.area>
References: <20220708015558.1134330-1-david@fromorbit.com>
 <20220708015558.1134330-8-david@fromorbit.com>
 <Ysu/SU6RNhJcdU4o@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ysu/SU6RNhJcdU4o@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62ccb845
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=7-415B0cAAAA:8
        a=JuDxSlhT3OO6blO4plAA:9 a=CjuIK1q_8ugA:10 a=n3xvM8a_0i4A:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 10, 2022 at 11:12:25PM -0700, Christoph Hellwig wrote:
> The subjet does not parse.  The and should be dropped at very least.

"move and rename" was what it was supposed to say.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
