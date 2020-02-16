Return-Path: <SRS0=TKlC=4E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD6ADC76199
	for <linux-xfs@archiver.kernel.org>; Sun, 16 Feb 2020 22:37:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9130A20729
	for <linux-xfs@archiver.kernel.org>; Sun, 16 Feb 2020 22:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgBPWhI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 16 Feb 2020 17:37:08 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:49818 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726719AbgBPWhI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 16 Feb 2020 17:37:08 -0500
Received: from dread.disaster.area (pa49-179-138-28.pa.nsw.optusnet.com.au [49.179.138.28])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 04BA87EA637;
        Mon, 17 Feb 2020 09:37:04 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j3SX9-0003TI-2P; Mon, 17 Feb 2020 09:37:03 +1100
Date:   Mon, 17 Feb 2020 09:37:03 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 3/4] xfs: xfs_isilocked() can only check a single lock
 type
Message-ID: <20200216223703.GC10776@dread.disaster.area>
References: <20200214185942.1147742-1-preichl@redhat.com>
 <20200214185942.1147742-3-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214185942.1147742-3-preichl@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=zAxSp4fFY/GQY8/esVNjqw==:117 a=zAxSp4fFY/GQY8/esVNjqw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=MVqQPy646RGYROeipP8A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 14, 2020 at 07:59:41PM +0100, Pavel Reichl wrote:
> In its current form, xfs_isilocked() is only able to test one lock type
> at a time - ilock, iolock, or mmap lock, but combinations are not
> properly handled. The intent here is to check that both XFS_IOLOCK_EXCL
> and XFS_ILOCK_EXCL are held, so test them each separately.
> 
> The commit ecfea3f0c8c6 ("xfs: split xfs_bmap_shift_extents") ORed the
> flags together which was an error, so this patch reverts that part of
> the change and check the locks independently.
> 
> Fixes: ecfea3f0c8c6 ("xfs: split xfs_bmap_shift_extents")
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> Suggested-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Pavel Reichl <preichl@redhat.com>

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
