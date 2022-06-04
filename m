Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C964CCA473
	for <linux-xfs@archiver.kernel.org>; Sat,  4 Jun 2022 00:34:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237245AbiFDAeJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jun 2022 20:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbiFDAeI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jun 2022 20:34:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8D41EAEC
        for <linux-xfs@vger.kernel.org>; Fri,  3 Jun 2022 17:34:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B73960F2A
        for <linux-xfs@vger.kernel.org>; Sat,  4 Jun 2022 00:34:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1448C385A9;
        Sat,  4 Jun 2022 00:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654302846;
        bh=fyPHOuskJULXMe/LaUwbRWtB0ZfJVc8ik6ierAlzUaQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XJRbF7N7fi3zMve3fcNjW8PoUTThy5N6DnvlTp1G7lyWcY9fK6MR8BneifTPxeLh1
         RcUfzvZAy0cFqkZjT8b2Gswp5wmzL+sfDbRKd2feR5T7UyAZB/+8LyD3p/Tt2x6hxE
         ACWdwv5UhnwpJDFMQPYW2QazrOs/+PQubya0F/EBvMAXiV/Pyg0a51YiXR6QMH4j+c
         lPM1b5prdHv5qe8ClMSGxRuFpGGUry+8zVTwi7snz094BrwMLW8SCVr7cHEsCn3sJ0
         DEL5KTxmSz6b56jNjdZ70+kOY3TDYLO3okiBQzIrBN2QshWINBI3nMUtRTborEVaaa
         /eQVjVgBwh7VA==
Date:   Fri, 3 Jun 2022 17:34:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Lukas Herbolt <lukas@herbolt.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC v2] xfs: Print XFS UUID on mount and umount events.
Message-ID: <YpqofakhfvHIBWK/@magnolia>
References: <20210519152247.1853357-1-lukas@herbolt.com>
 <781bf2c0-5983-954e-49a5-570e365be515@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <781bf2c0-5983-954e-49a5-570e365be515@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 03, 2022 at 11:14:13AM -0500, Eric Sandeen wrote:
> On 5/19/21 10:22 AM, Lukas Herbolt wrote:
> > As of now only device names are printed out over __xfs_printk().
> > The device names are not persistent across reboots which in case
> > of searching for origin of corruption brings another task to properly
> > identify the devices. This patch add XFS UUID upon every mount/umount
> > event which will make the identification much easier.
> > 
> > Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> > ---
> > V2: Drop void casts and fix long lines
> 
> Can we revisit this? I think it's a nice enhancement.
> 
> The "nouuid" concern raised in the thread doesn't seem like a problem;
> if someone mounts with "-o nouuid" then you'll see 2 different devices
> mounted with the same uuid printed. I don't think that's an argument
> against the patch. Printing the uuid still provides more info than not.

Ok fair.

> I, uh, also don't think the submitter should be required to do a tree-wide
> change for an xfs printk enhancement. Sure, it'd be nice to have ext4
> and btrfs and and and but we have no other requirements that mount-time
> messages must be consistent across all filesystems....

As you pointed out on irc, btrfs already prints its own uuids.  So that
leaves ext4 -- are you all planning to send a patch for that?

(Otherwise, I don't mind this patch, if it helps support perform
forensics on systems with a lot of filesystem activity.)

> Thanks,
> -Eric
> 
> > 
> >  fs/xfs/xfs_log.c   | 10 ++++++----
> >  fs/xfs/xfs_super.c |  2 +-
> >  2 files changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 06041834daa31..8f4f671fd80d5 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -570,12 +570,14 @@ xfs_log_mount(
> >  	int		min_logfsbs;
> >  
> >  	if (!(mp->m_flags & XFS_MOUNT_NORECOVERY)) {
> > -		xfs_notice(mp, "Mounting V%d Filesystem",
> > -			   XFS_SB_VERSION_NUM(&mp->m_sb));
> > +		xfs_notice(mp, "Mounting V%d Filesystem %pU",
> > +			   XFS_SB_VERSION_NUM(&mp->m_sb),
> > +			   &mp->m_sb.sb_uuid);
> >  	} else {
> >  		xfs_notice(mp,
> > -"Mounting V%d filesystem in no-recovery mode. Filesystem will be inconsistent.",
> > -			   XFS_SB_VERSION_NUM(&mp->m_sb));
> > +"Mounting V%d filesystem %pU in no-recovery mode. Filesystem will be inconsistent.",
> > +			   XFS_SB_VERSION_NUM(&mp->m_sb),
> > +			   &mp->m_sb.sb_uuid);

sb_uuid is the uuid that the user can set, not the one that's encoded
identically in all the cloud vm images, right?

--D

> >  		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
> >  	}
> >  
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index e5e0713bebcd8..a4b8a5ad8039f 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1043,7 +1043,7 @@ xfs_fs_put_super(
> >  	if (!sb->s_fs_info)
> >  		return;
> >  
> > -	xfs_notice(mp, "Unmounting Filesystem");
> > +	xfs_notice(mp, "Unmounting Filesystem %pU", &mp->m_sb.sb_uuid);
> >  	xfs_filestream_unmount(mp);
> >  	xfs_unmountfs(mp);
> >  
