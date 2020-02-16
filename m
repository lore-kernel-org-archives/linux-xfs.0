Return-Path: <SRS0=TKlC=4E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C704EC3B1BF
	for <linux-xfs@archiver.kernel.org>; Sun, 16 Feb 2020 22:36:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E8D320729
	for <linux-xfs@archiver.kernel.org>; Sun, 16 Feb 2020 22:36:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgBPWgt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 16 Feb 2020 17:36:49 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48124 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726142AbgBPWgt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 16 Feb 2020 17:36:49 -0500
Received: from dread.disaster.area (pa49-179-138-28.pa.nsw.optusnet.com.au [49.179.138.28])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id EDD567EAB0C;
        Mon, 17 Feb 2020 09:36:45 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j3SWq-0003TC-SZ; Mon, 17 Feb 2020 09:36:44 +1100
Date:   Mon, 17 Feb 2020 09:36:44 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 2/4] xfs: clean up whitespace in xfs_isilocked() calls
Message-ID: <20200216223644.GB10776@dread.disaster.area>
References: <20200214185942.1147742-1-preichl@redhat.com>
 <20200214185942.1147742-2-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214185942.1147742-2-preichl@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=zAxSp4fFY/GQY8/esVNjqw==:117 a=zAxSp4fFY/GQY8/esVNjqw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=7i13tFrKQP58Qq6FnrIA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 14, 2020 at 07:59:40PM +0100, Pavel Reichl wrote:
> Make whitespace follow the same pattern in all xfs_isilocked() calls.
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 2 +-
>  fs/xfs/xfs_file.c        | 3 ++-
>  fs/xfs/xfs_inode.c       | 6 +++---
>  fs/xfs/xfs_qm.c          | 2 +-
>  4 files changed, 7 insertions(+), 6 deletions(-)

Simple enough.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
