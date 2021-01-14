Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 012CCC433E9
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 09:42:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3E9723A22
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 09:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbhANJmW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 04:42:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39540 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727750AbhANJmV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jan 2021 04:42:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610617262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d5JlPXLPACpd+EbTSngGrA1ibcUG4foKhJK92CC8jkk=;
        b=DmLnjAH9QWDrJwYxNHXr1fa7FMwo0K2x+WSqFgjTrsquM/g1NRf9avYjLVHv+kRZZ4WV2+
        bj6QHD/O9I0ZSdSJFfGaMCaSsD0D97+lUNXs8DROvLP8lhqAAy54n0yiWZJtc6mu7xU7wo
        UgF8lymYqzd4Ax4Y3qvxGI5iePi5L/A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-2jfIWc0GOWm7T-PYAFtptg-1; Thu, 14 Jan 2021 04:41:00 -0500
X-MC-Unique: 2jfIWc0GOWm7T-PYAFtptg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73FAF806660;
        Thu, 14 Jan 2021 09:40:59 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CA2D118A60;
        Thu, 14 Jan 2021 09:40:58 +0000 (UTC)
Date:   Thu, 14 Jan 2021 04:40:57 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_db: add inobtcnt upgrade path
Message-ID: <20210114094057.GC1333929@bfoster>
References: <161017369911.1142690.8979186737828708317.stgit@magnolia>
 <161017370529.1142690.11100691491331155224.stgit@magnolia>
 <20210113183505.GD1284163@bfoster>
 <20210114010835.GW1164246@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114010835.GW1164246@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 13, 2021 at 05:08:35PM -0800, Darrick J. Wong wrote:
> On Wed, Jan 13, 2021 at 01:35:05PM -0500, Brian Foster wrote:
> > On Fri, Jan 08, 2021 at 10:28:25PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Enable users to upgrade their filesystems to support inode btree block
> > > counters.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > 
> > These two look Ok to me, but I noticed that both commands have weird
> > error semantics when run through xfs_admin and the associated features
> > are already set. E.g.:
> > 
> > # xfs_admin -O inobtcount /dev/test/tmp 
> > Upgrading V5 filesystem
> > Upgraded V5 filesystem.  Please run xfs_repair.
> > versionnum [0xb4a5+0x18a] = V5,NLINK,DIRV2,ALIGN,LOGV2,EXTFLG,MOREBITS,ATTR2,LAZYSBCOUNT,PROJID32BIT,CRC,FTYPE,FINOBT,SPARSE_INODES,REFLINK,INOBTCNT
> > Running xfs_repair to ensure filesystem consistency.
> > # xfs_admin -O inobtcount /dev/test/tmp 
> > inode btree counter feature is already enabled
> > Running xfs_repair to ensure filesystem consistency.
> > Conversion failed, is the filesystem unmounted?
> > # mount /dev/test/tmp /mnt/
> > # umount /mnt/
> > 
> > So it looks like we run repair again the second time around even though
> > the bit was already set, which is probably unnecessary, but then also
> > for some reason report the result as failed.
> 
> Hm.  I guess I could define a second exitcode that means "no action
> taken", and have xfs_admin exit.
> 

It's not totally clear to me what the expected flow is supposed to be if
a particular feature upgrade fails or is otherwise interrupted partway
through. If the expectation is for the user to rerun the xfs_admin
command, it might be worth making sure that we somehow or another fall
back through to repair when appropriate (whether it be unconditionally,
by checking if NEEDSREPAIR is still set, etc.)..

Brian

> > (I also realized that repair is fixing up some agi metadata in this
> > case, so my previous thought around a special repair verify mode is
> > probably not relevant..).
> 
> <nod>
> 
> --D
> 
> > Brian
> > 
> > >  db/sb.c              |   22 ++++++++++++++++++++++
> > >  man/man8/xfs_admin.8 |    7 +++++++
> > >  man/man8/xfs_db.8    |    3 +++
> > >  3 files changed, 32 insertions(+)
> > > 
> > > 
> > > diff --git a/db/sb.c b/db/sb.c
> > > index 93e4c405..b89ccdbe 100644
> > > --- a/db/sb.c
> > > +++ b/db/sb.c
> > > @@ -597,6 +597,7 @@ version_help(void)
> > >  " 'version attr2'    - enable v2 inline extended attributes\n"
> > >  " 'version log2'     - enable v2 log format\n"
> > >  " 'version needsrepair' - flag filesystem as requiring repair\n"
> > > +" 'version inobtcount' - enable inode btree counters\n"
> > >  "\n"
> > >  "The version function prints currently enabled features for a filesystem\n"
> > >  "according to the version field of its primary superblock.\n"
> > > @@ -857,6 +858,27 @@ version_f(
> > >  			}
> > >  
> > >  			v5features.incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> > > +		} else if (!strcasecmp(argv[1], "inobtcount")) {
> > > +			if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
> > > +				dbprintf(
> > > +		_("inode btree counter feature is already enabled\n"));
> > > +				exitcode = 1;
> > > +				return 1;
> > > +			}
> > > +			if (!xfs_sb_version_hasfinobt(&mp->m_sb)) {
> > > +				dbprintf(
> > > +		_("inode btree counter feature cannot be enabled on filesystems lacking free inode btrees\n"));
> > > +				exitcode = 1;
> > > +				return 1;
> > > +			}
> > > +			if (!xfs_sb_version_hascrc(&mp->m_sb)) {
> > > +				dbprintf(
> > > +		_("inode btree counter feature cannot be enabled on pre-V5 filesystems\n"));
> > > +				exitcode = 1;
> > > +				return 1;
> > > +			}
> > > +
> > > +			v5features.ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
> > >  		} else if (!strcasecmp(argv[1], "extflg")) {
> > >  			switch (XFS_SB_VERSION_NUM(&mp->m_sb)) {
> > >  			case XFS_SB_VERSION_1:
> > > diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
> > > index b423981d..a776b375 100644
> > > --- a/man/man8/xfs_admin.8
> > > +++ b/man/man8/xfs_admin.8
> > > @@ -116,6 +116,13 @@ If this is a V5 filesystem, flag the filesystem as needing repairs.
> > >  Until
> > >  .BR xfs_repair (8)
> > >  is run, the filesystem will not be mountable.
> > > +.TP
> > > +.B inobtcount
> > > +Upgrade a V5 filesystem to support the inode btree counters feature.
> > > +This reduces mount time by caching the size of the inode btrees in the
> > > +allocation group metadata.
> > > +Once enabled, the filesystem will not be writable by older kernels.
> > > +The filesystem cannot be downgraded after this feature is enabled.
> > >  .RE
> > >  .TP
> > >  .BI \-U " uuid"
> > > diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> > > index 7331cf19..1b826e5d 100644
> > > --- a/man/man8/xfs_db.8
> > > +++ b/man/man8/xfs_db.8
> > > @@ -976,6 +976,9 @@ The filesystem can be flagged as requiring a run through
> > >  if the
> > >  .B needsrepair
> > >  option is specified and the filesystem is formatted with the V5 format.
> > > +Support for the inode btree counters feature can be enabled by using the
> > > +.B inobtcount
> > > +option if the filesystem is formatted with the V5 format.
> > >  .IP
> > >  If no argument is given, the current version and feature bits are printed.
> > >  With one argument, this command will write the updated version number
> > > 
> > 
> 

