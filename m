Return-Path: <SRS0=V0Y3=4A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEA5BC35242
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Feb 2020 00:35:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A3D320842
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Feb 2020 00:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbgBLAfZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Feb 2020 19:35:25 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:35483 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728041AbgBLAfZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Feb 2020 19:35:25 -0500
Received: from dread.disaster.area (pa49-179-138-28.pa.nsw.optusnet.com.au [49.179.138.28])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id B12507EB3E9;
        Wed, 12 Feb 2020 11:35:19 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j1fzq-0004L8-8m; Wed, 12 Feb 2020 11:35:18 +1100
Date:   Wed, 12 Feb 2020 11:35:18 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 2/4] xfs: Fix WS in xfs_isilocked() calls
Message-ID: <20200212003518.GP10776@dread.disaster.area>
References: <20200211221018.709125-1-preichl@redhat.com>
 <20200211221018.709125-2-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200211221018.709125-2-preichl@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=zAxSp4fFY/GQY8/esVNjqw==:117 a=zAxSp4fFY/GQY8/esVNjqw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=-qBKg64vyifKu9ZPFvsA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 11, 2020 at 11:10:16PM +0100, Pavel Reichl wrote:
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 2 +-
>  fs/xfs/xfs_file.c        | 3 ++-
>  fs/xfs/xfs_inode.c       | 6 +++---
>  fs/xfs/xfs_qm.c          | 2 +-
>  4 files changed, 7 insertions(+), 6 deletions(-)

Hi Pavel,

I don't know what this patch does from reading the subject line,
and the commit message doesn't tell me, either. :)

IOWs, please don't use abbreviations in the subject line because not
everyone understands what the abbreviation you used means. This
makes it hard to read the git history once the patch is committed.
Similarly, subjects that say "Fix the frobnozzle" can be better
written as something like:

xfs: clean up whitespace in xfs_isilocked() calls

So that the output of 'git log --oneline fs/xfs' it's totally
obvious what the commit is doing from the summary.  "Fix the
frobnozzle" is ambiguous because "fix" can mean many things, hence
to find out you need to look at the specific commit in more detail
and that slows down code and history searches....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
