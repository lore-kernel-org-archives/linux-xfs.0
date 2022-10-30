Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B7F6C38A02
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Oct 2022 22:04:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiJ3WEu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Oct 2022 18:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiJ3WEp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Oct 2022 18:04:45 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52208DA4
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 15:04:45 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id f5-20020a17090a4a8500b002131bb59d61so11335132pjh.1
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 15:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m1+I3p4lUS11f6IrNob6bKSE5n/gozuA+FLGNXk/1fM=;
        b=ZkJAIK4z6GWZwCmmKrOrYoKJzBqpsFKG/aUaBFHJPFY6rCUXIjyly0jI0pEUhbCFYh
         fkEhlsoF/JXxJWl9ZeMGIhgOoKYgRBG9i8Noc3Rtj4jHmpswWx/qDyITLmDO0iLHIGyL
         cKZxJOL7o5ESaDhPkSMvoNYG/IEH7NjAOxdwQ6Rp4SjeXj4KPeg8bd+K1rby9rivHbTv
         jbsY+CCgCDIzDM3JEApvmhX3ozkcJsDlBdjWm+KR1IOKsJ+hzDKpzaYpeWhAxvT++6XZ
         Da27DBr40Ctsp9CHfEa3IFBZvOYt4QHKPe3vIz9T783aYiXjTaMoMbxA0qJ/e6MPQX9e
         6z1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m1+I3p4lUS11f6IrNob6bKSE5n/gozuA+FLGNXk/1fM=;
        b=HGuYRL/Ck0TcXktkhg1rFXa+uLw80ZDVfQAMm+lcGuEKe0/ZH/ZUTbV67G7t0Ke235
         GkuiV8qoag4rHvuIN+SvqPbBaPANDYvJAFHw9SjIJF162kMfDRCs1EC3HtWXAc43dhVV
         VgyNg1sjD/OZtVGPdMCdsYVohTF1YkNwzgL4JIF6w86OIoiJpf/7Oc68eg3tEfxTOY6y
         ebrKZsdw6i9nFSujm8IRXqlwCFNOutdCjohsBaY/vQyJTzwm1LN/G1brjPZO1uPBt9S+
         j1R2NwecnScJ82xEVaGfH2kxNuW46xzSvgVf8bMkFYvddRrdY1PxiC5SjkBSP3QbQEbC
         35NQ==
X-Gm-Message-State: ACrzQf0AVmuIcEqPiRsg98Y+dr0SWohnlenOiC17gZnlPVwmUmvYkOjd
        TYVIF90Fyrpqmx/A1YVXrUDYig==
X-Google-Smtp-Source: AMsMyM4+/iHyQXqU8YLY9PzmllF3pZgfKXbAeAcYP9xAaUxDK3lgJbCITRzC7w19hEB8HHj/KabCJw==
X-Received: by 2002:a17:902:e547:b0:186:9c70:9b71 with SMTP id n7-20020a170902e54700b001869c709b71mr11160621plf.159.1667167484834;
        Sun, 30 Oct 2022 15:04:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id r10-20020a170902c60a00b0017f48a9e2d6sm3072639plr.292.2022.10.30.15.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Oct 2022 15:04:44 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1opGQ5-008LsI-DS; Mon, 31 Oct 2022 09:04:41 +1100
Date:   Mon, 31 Oct 2022 09:04:41 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Long Li <leo.lilong@huawei.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, billodo@redhat.com,
        chandan.babu@oracle.com, dchinner@redhat.com, guoxuenan@huawei.com,
        houtao1@huawei.com, linux-xfs@vger.kernel.org, sandeen@redhat.com,
        yi.zhang@huawei.com
Subject: Re: [PATCH v2] xfs: fix sb write verify for lazysbcount
Message-ID: <20221030220441.GH3600936@dread.disaster.area>
References: <20221022020345.GA2699923@ceph-admin>
 <20221025091527.377976-1-leo.lilong@huawei.com>
 <Y1goB8GfadlYSL9T@magnolia>
 <20221026091344.GA490040@ceph-admin>
 <Y1mB7VfIOms3J2Rj@magnolia>
 <20221027132504.GB490040@ceph-admin>
 <Y1qsQaDA3wcCN+K8@magnolia>
 <20221029071601.GA1277642@ceph-admin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221029071601.GA1277642@ceph-admin>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 29, 2022 at 03:16:01PM +0800, Long Li wrote:
> On Thu, Oct 27, 2022 at 09:05:21AM -0700, Darrick J. Wong wrote:
> > On Thu, Oct 27, 2022 at 09:25:04PM +0800, Long Li wrote:
> > > not pass, therefore it will not write a clean umount record
> > > at umount. I also haven't found a code suitable for adding
> > > such checks.
> > 
> > xfs_unmountfs just prior to unmounting the log.
> 
> 
> I tried to add an extra check in xfs_log_unmount_write, when m_icount <
> m_ifree, it will not write a umount log record, after which the summary
> counters will be recalculated at next mount. If m_ifree greater than
> m_icount in memory, sb_i{count,free} (the ondisk superblock inode counters)
> maybe incorrect even after unmount filesystem. After adding such checks,
> it can be corrected on the next mount, instead of going undetected in
> subsequent mounts.
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f1f44c006ab3..e4903c15019e 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1038,7 +1038,9 @@ xfs_log_unmount_write(
>  	 * more details.
>  	 */
>  	if (XFS_TEST_ERROR(xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS), mp,
> -			XFS_ERRTAG_FORCE_SUMMARY_RECALC)) {
> +			XFS_ERRTAG_FORCE_SUMMARY_RECALC) ||
> +			(percpu_counter_sum(&mp->m_icount) <
> +			 percpu_counter_sum(&mp->m_ifree))) {
>  		xfs_alert(mp, "%s: will fix summary counters at next mount",
>  				__func__);
>  		return;

The log code is not the layer at which the mount structures
should be verified. xfs_unmountfs() is where the mount is cleaned up
and all activity is flushed and waited on. THis is where the mount
counters should be checked, before we unmount the log.

Indeed, if you check the mount counters prior to calling
xfs_log_unmount_write(), you could call this:

	xfs_alert(mp, "ifree/icount mismatch at unmount");
	xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);

i.e. check the mount state at the correct level and propagate the
sickness into the mount state and the log code will just do the
right thing....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
