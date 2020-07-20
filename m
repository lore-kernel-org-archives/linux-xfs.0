Return-Path: <SRS0=nIBV=A7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A8EC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jul 2020 03:21:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C7FE2250E
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jul 2020 03:21:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgGTDVt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 19 Jul 2020 23:21:49 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:41660 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726499AbgGTDVt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Jul 2020 23:21:49 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 314A55EC7FB;
        Mon, 20 Jul 2020 13:21:44 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jxMN5-0002S0-Cx; Mon, 20 Jul 2020 13:21:43 +1000
Date:   Mon, 20 Jul 2020 13:21:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] repair: use fs rootino for dummy parent value instead
 of zero
Message-ID: <20200720032143.GC2005@dread.disaster.area>
References: <20200715140836.10197-4-bfoster@redhat.com>
 <20200717115920.59986-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717115920.59986-1-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=qP0JENCKDnoD14qI7MsA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 17, 2020 at 07:59:20AM -0400, Brian Foster wrote:
> If a directory inode has an invalid parent ino on disk, repair
> replaces the invalid value with a dummy value of zero in the buffer
> and NULLFSINO in the in-core parent tracking. The zero value serves
> no functional purpose as it is still an invalid value and the parent
> must be repaired by phase 6 based on the in-core state before the
> buffer can be written out. A consequence of using an invalid dummy
> value is that phase 6 requires custom verifier infrastructure to
> detect the invalid parent inode and temporarily replace it while the
> core fork verifier runs. If we use a valid inode number as a dummy
> value earlier in repair, this workaround can be removed.
> 
> An obvious choice for a valid dummy parent inode value is the
> orphanage inode. However, the orphanage inode is not allocated until
> much later in repair when the filesystem structure is established as
> sound and placement of orphaned inodes is imminent. In this case, it
> is too early to know for sure whether the associated inodes are
> orphaned because a directory traversal later in repair can locate
> references to the inode and repair the parent value based on the
> structure of the directory tree.
> 
> Given all of this, escalate the preexisting workaround from the
> custom verifier in phase 6 and set the root inode value as a dummy
> parent for shortform directories with an invalid on-disk parent. The
> in-core parent is still tracked as NULLFSINO and so forces repair to
> either update the parent or orphan the inode before repair
> completes.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
> 
> v2:
> - Update patch subject and commit log.

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
