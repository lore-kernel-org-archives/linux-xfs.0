Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C45EC8743
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Sep 2023 16:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbjIGQvn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Sep 2023 12:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235871AbjIGQvn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Sep 2023 12:51:43 -0400
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F1B1FCE
        for <linux-xfs@vger.kernel.org>; Thu,  7 Sep 2023 09:51:16 -0700 (PDT)
Received: by mail-vk1-xa2c.google.com with SMTP id 71dfb90a1353d-49351972caeso403685e0c.1
        for <linux-xfs@vger.kernel.org>; Thu, 07 Sep 2023 09:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1694105402; x=1694710202; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A7DOp6AnKZY5h4Jv31ICUvptqkR06ZrBW+7zJhFDmIk=;
        b=zljD/4AgrjlOnPrYHuohuhdY0+CZrwmv+UkBoNi2BnC0xxRiLf//MvKAlUMjzN6NML
         4qqNQ+yeBqsUQaXcHgoAkfG/8sRJo0X6MX0k8WDV5cQarLOx55C3e8F2TuURc0enpR2P
         0kh1XV9DiYtHoJSCP6fEYhDvpMbwASB4AlV6tl3g3D6Cm2X5DJeTiGjhSBpAep6FQ7UK
         MoBQ3AtErSjlc7/YHRWPXxryhV4xngB+Ac6gEg1cfF41VUrWGMIMEaV5Qx1eN9y5fk/H
         65PpSin9KPA8Zcu4lcyXrnEkrSE4wGgTtnIQUbJPFbPdo56MhwdLZzj+TCQLTYD5nLp+
         VCnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694105402; x=1694710202;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A7DOp6AnKZY5h4Jv31ICUvptqkR06ZrBW+7zJhFDmIk=;
        b=tf8mMIqXQA0/tVNULICEkJVuAdpUCF+1uOJix/F36MzcdGR1qSt4NwUJhHdzfXaOJM
         Dl8aZLfVErgg+vQ9bh0LMNUNIBYMkFh3rTovR8Rypi4ZX8z3uZymptx/Zyg50YXBY8Sw
         JcY2L0s7C1a68f82N/wIxSNAZTjoR74V/kPr9Zm2lniYkgr5YwU54fFDeDsT3SnURbdg
         n6t3i5VxHTHOFD5llS1cJSLITmSYyEnIVXHQzysuuMb6i0DnRBK1uoF+strIcb1uoCvI
         v9GtbSPSuevpQDqi+aOo5lGBSVgeJTvlPlWLTqtefpKnev/uynX/1QHafgmD2Kxz73wm
         m3aA==
X-Gm-Message-State: AOJu0Ywb0Skz1NkEMMWap4ygDcVh5gkVl0YQKiYYgXmoyRlVxat9JM+B
        ECgsZs0GoSLDOE0IXT6ozsC5rtV+0Zu++xjUeh0=
X-Google-Smtp-Source: AGHT+IE7TSUeBksYc9nhW8Du+f+gfAbtlYNONDgFGCcIdMz5/au0PsskkU/e2WENW1MwQFc+gBiU6w==
X-Received: by 2002:a92:c910:0:b0:34b:ae46:803d with SMTP id t16-20020a92c910000000b0034bae46803dmr17846970ilp.4.1694070716678;
        Thu, 07 Sep 2023 00:11:56 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id mz8-20020a17090b378800b0025bfda134ccsm877225pjb.16.2023.09.07.00.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Sep 2023 00:11:56 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qe9BB-00Bvgs-0u;
        Thu, 07 Sep 2023 17:11:53 +1000
Date:   Thu, 7 Sep 2023 17:11:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1.1 3/3] xfs: make inode unlinked bucket recovery work
 with quotacheck
Message-ID: <ZPl3ucKG33L7NI8B@dread.disaster.area>
References: <169375774749.3323693.18063212270653101716.stgit@frogsfrogsfrogs>
 <169375776451.3323693.17265659636054853468.stgit@frogsfrogsfrogs>
 <20230905163303.GU28186@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230905163303.GU28186@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 05, 2023 at 09:33:03AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Teach quotacheck to reload the unlinked inode lists when walking the
> inode table.  This requires extra state handling, since it's possible
> that a reloaded inode will get inactivated before quotacheck tries to
> scan it; in this case, we need to ensure that the reloaded inode does
> not have dquots attached when it is freed.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v1.1: s/CONFIG_QUOTA/CONFIG_XFS_QUOTA/ and fix tracepoint flags decoding
> ---
>  fs/xfs/xfs_inode.c |   12 +++++++++---
>  fs/xfs/xfs_inode.h |    5 ++++-
>  fs/xfs/xfs_mount.h |   10 +++++++++-
>  fs/xfs/xfs_qm.c    |    7 +++++++
>  4 files changed, 29 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 56f6bde6001b..22af7268169b 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1743,9 +1743,13 @@ xfs_inactive(
>  	     ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0))
>  		truncate = 1;
>  
> -	error = xfs_qm_dqattach(ip);
> -	if (error)
> -		goto out;
> +	if (xfs_iflags_test(ip, XFS_IQUOTAUNCHECKED)) {
> +		xfs_qm_dqdetach(ip);
> +	} else {
> +		error = xfs_qm_dqattach(ip);
> +		if (error)
> +			goto out;
> +	}

That needs a comment - I'm not going to remember why sometimes we
detatch dquots instead of attach them here....


....
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 6abcc34fafd8..7256090c3895 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1160,6 +1160,10 @@ xfs_qm_dqusage_adjust(
>  	if (error)
>  		return error;
>  
> +	error = xfs_inode_reload_unlinked(ip);
> +	if (error)
> +		goto error0;

Same comment here about doing millions of transaction create/cancel
for inodes that have non-zero link counts....

Also, same comment here about shutting down on reload error because
the irele() call will inactivate the inode and try to remove it from
the unlinked list....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
