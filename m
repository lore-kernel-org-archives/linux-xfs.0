Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED309C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 08:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CF8520663
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 08:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgGOI0K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 04:26:10 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33272 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728760AbgGOI0K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 04:26:10 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 3ABC9821B5A;
        Wed, 15 Jul 2020 18:26:07 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jvcju-0004DZ-LL; Wed, 15 Jul 2020 18:26:06 +1000
Date:   Wed, 15 Jul 2020 18:26:06 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: preserve inode versioning across remounts
Message-ID: <20200715082606.GG2005@dread.disaster.area>
References: <e8bfbbec-4cb9-0267-08eb-03580e2aedc6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8bfbbec-4cb9-0267-08eb-03580e2aedc6@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=s1AxXtvDNKqF2koCdKIA:9 a=6OsaHtKj_xYtHHR9:21 a=rCXk2kuo_IhF3tId:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 14, 2020 at 03:11:34PM -0700, Eric Sandeen wrote:
> The MS_I_VERSION mount flag is exposed via the VFS, as documented
> in the mount manpages etc; see the iversion and noiversion mount
> options in mount(8).
> 
> As a result, mount -o remount looks for this option in /proc/mounts
> and will only send the I_VERSION flag back in during remount it it
> is present.  Since it's not there, a remount will /remove/ the
> I_VERSION flag at the vfs level, and iversion functionality is lost.
> 
> xfs v5 superblocks intend to always have i_version enabled; it is
> set as a default at mount time, but is lost during remount for the
> reasons above.
> 
> The generic fix would be to expose this documented option in 
> /proc/mounts, but since that was rejected, fix it up again in the
> xfs remount path instead, so that at least xfs won't suffer from
> this misbehavior.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> --
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 379cbff438bc..9239985571af 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1714,6 +1714,10 @@ xfs_fc_reconfigure(
>  	int			flags = fc->sb_flags;
>  	int			error;
>  
> +	/* version 5 superblocks always support version counters. */
> +	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
> +		fc->sb_flags |= SB_I_VERSION;
> +
>  	error = xfs_fc_validate_params(new_mp);
>  	if (error)
>  		return error;

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
