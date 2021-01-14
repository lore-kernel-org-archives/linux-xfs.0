Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C677C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 01:11:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F034C2343B
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 01:11:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbhANBKO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jan 2021 20:10:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:60808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727051AbhANBJz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Jan 2021 20:09:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0ABB423370;
        Thu, 14 Jan 2021 01:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610586516;
        bh=wxig7LQqnrX4waHh7G9uJFtZlURotXXE9diWiccso+4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KfDCSdxaRetC4jBtC3eQT70rVEWIB6d/nw5g5aSMNOczvIfPG2XtXn+9ts0RWPzXc
         5hPk1q8M8qV4X3Rv1Pyc5UqWO+/JeF11coED3QX8IEIgsyK5VYoPrfeez3cbIesOAz
         xKECFJpskPYDMH59Iy2Az7f74s2bOmuiou8pAKtunF26gADf5+6jD/2BdUDqLuzN0T
         56AeYwPXHs7jYi6OtWGUmi5Rwub8oVoKOd0Ym3IwHEAVv8hLxtcfQUiTPKlXcByZxr
         sMzirgUD+6/aHRFyKIka1IUrGoZjSJAuKt5mB/hQE4N9zIJIZgxusovVkOnP+/foKz
         JrrxXLI3PlLEQ==
Date:   Wed, 13 Jan 2021 17:08:35 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_db: add inobtcnt upgrade path
Message-ID: <20210114010835.GW1164246@magnolia>
References: <161017369911.1142690.8979186737828708317.stgit@magnolia>
 <161017370529.1142690.11100691491331155224.stgit@magnolia>
 <20210113183505.GD1284163@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113183505.GD1284163@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 13, 2021 at 01:35:05PM -0500, Brian Foster wrote:
> On Fri, Jan 08, 2021 at 10:28:25PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Enable users to upgrade their filesystems to support inode btree block
> > counters.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> These two look Ok to me, but I noticed that both commands have weird
> error semantics when run through xfs_admin and the associated features
> are already set. E.g.:
> 
> # xfs_admin -O inobtcount /dev/test/tmp 
> Upgrading V5 filesystem
> Upgraded V5 filesystem.  Please run xfs_repair.
> versionnum [0xb4a5+0x18a] = V5,NLINK,DIRV2,ALIGN,LOGV2,EXTFLG,MOREBITS,ATTR2,LAZYSBCOUNT,PROJID32BIT,CRC,FTYPE,FINOBT,SPARSE_INODES,REFLINK,INOBTCNT
> Running xfs_repair to ensure filesystem consistency.
> # xfs_admin -O inobtcount /dev/test/tmp 
> inode btree counter feature is already enabled
> Running xfs_repair to ensure filesystem consistency.
> Conversion failed, is the filesystem unmounted?
> # mount /dev/test/tmp /mnt/
> # umount /mnt/
> 
> So it looks like we run repair again the second time around even though
> the bit was already set, which is probably unnecessary, but then also
> for some reason report the result as failed.

Hm.  I guess I could define a second exitcode that means "no action
taken", and have xfs_admin exit.

> (I also realized that repair is fixing up some agi metadata in this
> case, so my previous thought around a special repair verify mode is
> probably not relevant..).

<nod>

--D

> Brian
> 
> >  db/sb.c              |   22 ++++++++++++++++++++++
> >  man/man8/xfs_admin.8 |    7 +++++++
> >  man/man8/xfs_db.8    |    3 +++
> >  3 files changed, 32 insertions(+)
> > 
> > 
> > diff --git a/db/sb.c b/db/sb.c
> > index 93e4c405..b89ccdbe 100644
> > --- a/db/sb.c
> > +++ b/db/sb.c
> > @@ -597,6 +597,7 @@ version_help(void)
> >  " 'version attr2'    - enable v2 inline extended attributes\n"
> >  " 'version log2'     - enable v2 log format\n"
> >  " 'version needsrepair' - flag filesystem as requiring repair\n"
> > +" 'version inobtcount' - enable inode btree counters\n"
> >  "\n"
> >  "The version function prints currently enabled features for a filesystem\n"
> >  "according to the version field of its primary superblock.\n"
> > @@ -857,6 +858,27 @@ version_f(
> >  			}
> >  
> >  			v5features.incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> > +		} else if (!strcasecmp(argv[1], "inobtcount")) {
> > +			if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
> > +				dbprintf(
> > +		_("inode btree counter feature is already enabled\n"));
> > +				exitcode = 1;
> > +				return 1;
> > +			}
> > +			if (!xfs_sb_version_hasfinobt(&mp->m_sb)) {
> > +				dbprintf(
> > +		_("inode btree counter feature cannot be enabled on filesystems lacking free inode btrees\n"));
> > +				exitcode = 1;
> > +				return 1;
> > +			}
> > +			if (!xfs_sb_version_hascrc(&mp->m_sb)) {
> > +				dbprintf(
> > +		_("inode btree counter feature cannot be enabled on pre-V5 filesystems\n"));
> > +				exitcode = 1;
> > +				return 1;
> > +			}
> > +
> > +			v5features.ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
> >  		} else if (!strcasecmp(argv[1], "extflg")) {
> >  			switch (XFS_SB_VERSION_NUM(&mp->m_sb)) {
> >  			case XFS_SB_VERSION_1:
> > diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
> > index b423981d..a776b375 100644
> > --- a/man/man8/xfs_admin.8
> > +++ b/man/man8/xfs_admin.8
> > @@ -116,6 +116,13 @@ If this is a V5 filesystem, flag the filesystem as needing repairs.
> >  Until
> >  .BR xfs_repair (8)
> >  is run, the filesystem will not be mountable.
> > +.TP
> > +.B inobtcount
> > +Upgrade a V5 filesystem to support the inode btree counters feature.
> > +This reduces mount time by caching the size of the inode btrees in the
> > +allocation group metadata.
> > +Once enabled, the filesystem will not be writable by older kernels.
> > +The filesystem cannot be downgraded after this feature is enabled.
> >  .RE
> >  .TP
> >  .BI \-U " uuid"
> > diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> > index 7331cf19..1b826e5d 100644
> > --- a/man/man8/xfs_db.8
> > +++ b/man/man8/xfs_db.8
> > @@ -976,6 +976,9 @@ The filesystem can be flagged as requiring a run through
> >  if the
> >  .B needsrepair
> >  option is specified and the filesystem is formatted with the V5 format.
> > +Support for the inode btree counters feature can be enabled by using the
> > +.B inobtcount
> > +option if the filesystem is formatted with the V5 format.
> >  .IP
> >  If no argument is given, the current version and feature bits are printed.
> >  With one argument, this command will write the updated version number
> > 
> 
