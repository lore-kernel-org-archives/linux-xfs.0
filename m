Return-Path: <SRS0=gMH0=64=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C8C1C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 10:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19486206A5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 10:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbgENKUj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 May 2020 06:20:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:54166 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbgENKUj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 May 2020 06:20:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 03874B03C;
        Thu, 14 May 2020 10:20:39 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id BA9481E12A8; Thu, 14 May 2020 12:20:36 +0200 (CEST)
Date:   Thu, 14 May 2020 12:20:36 +0200
From:   Jan Kara <jack@suse.cz>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     Jan Kara <jack@suse.cz>, linux-xfs <linux-xfs@vger.kernel.org>,
        Petr =?utf-8?B?UMOtc2HFmQ==?= <ppisar@redhat.com>
Subject: Re: [PATCH] quota-tools: Set FS_DQ_TIMER_MASK for individual xfs
 grace times
Message-ID: <20200514102036.GC9569@quack2.suse.cz>
References: <72a454f1-c2ee-b777-90db-6bdfd4a8572c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72a454f1-c2ee-b777-90db-6bdfd4a8572c@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed 13-05-20 22:45:32, Eric Sandeen wrote:
> xfs quota code doesn't currently allow increasing an individual
> user's grace time, but kernel patches are in development for this.
> 
> In order for setquota to be able to send this update via
> setquota -T, we need to add the FS_DQ_TIMER_MASK when we are trying
> to update the grace times on an individual user's dquot.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

The patch looks good to me. I've added it to my tree.

> I wonder if we should only be setting the LIMIT_MASK only if
> (flags & COMMIT_LIMITS), but it doesn't seem to be a problem and
> is unrelated to this change I'm leaving it alone for now, though if
> anyone thinks it's better I can update the patch.
> 
> I'm putting together xfstests cases for this, if you want to wait
> for those, that's fine.  Thanks!

Yeah, that looks like a good thing to do. Also FS_DQ_LIMIT_MASK contains
real-time limits bits which quota tools aren't able to manipulate in any
way so maybe not setting those bits would be wiser... Will you send a patch
or should I just fix it?

								Honza

> 
> diff --git a/quotaio_xfs.c b/quotaio_xfs.c
> index b22c7b4..a4d6f67 100644
> --- a/quotaio_xfs.c
> +++ b/quotaio_xfs.c
> @@ -166,6 +166,8 @@ static int xfs_commit_dquot(struct dquot *dquot, int flags)
>  			xdqblk.d_fieldmask |= FS_DQ_BCOUNT;
>  	} else {
>  		xdqblk.d_fieldmask |= FS_DQ_LIMIT_MASK;
> +		if (flags & COMMIT_TIMES) /* indiv grace period */
> +			xdqblk.d_fieldmask |= FS_DQ_TIMER_MASK;
>  	}
>  
>  	qcmd = QCMD(Q_XFS_SETQLIM, h->qh_type);
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
