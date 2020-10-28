Return-Path: <SRS0=iKFT=ED=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E004C55179
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 22:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3061F20738
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 22:32:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OJXLLC4j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388025AbgJ1WcF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 18:32:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40461 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388003AbgJ1WcE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 18:32:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603924322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hCUX4BfaC+vDuSkpYddYvwRTy0ejMeydmsHxClr4cOA=;
        b=OJXLLC4jTWyKXzN7dE6njKdfLSiVq7Af99uRmiy3SUDAULXqGhi+PYemSeOKgw7qemtvim
        AQBvvCALXVyKX+a089GKJewbtR5xuEBmx47wSEbCPQXqovf0M9x3kWnfc91eouf7mFShc8
        61WsMiIGSNnHMirozWKRCe+Jjn0yZZI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-tknxo5IkO3OwsfLjgZpfsg-1; Wed, 28 Oct 2020 13:29:29 -0400
X-MC-Unique: tknxo5IkO3OwsfLjgZpfsg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03D1E760C6;
        Wed, 28 Oct 2020 17:29:28 +0000 (UTC)
Received: from bfoster (ovpn-113-186.rdu2.redhat.com [10.10.113.186])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 50E6260BF1;
        Wed, 28 Oct 2020 17:29:27 +0000 (UTC)
Date:   Wed, 28 Oct 2020 13:29:25 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs_db: add inobtcnt upgrade path
Message-ID: <20201028172925.GD1611922@bfoster>
References: <160375518573.880355.12052697509237086329.stgit@magnolia>
 <160375521801.880355.2055596956122419535.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375521801.880355.2055596956122419535.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 26, 2020 at 04:33:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Enable users to upgrade their filesystems to support inode btree block
> counters.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/sb.c              |   76 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  db/xfs_admin.sh      |    4 ++-
>  man/man8/xfs_admin.8 |   16 +++++++++++
>  3 files changed, 94 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/db/sb.c b/db/sb.c
> index e3b1fe0b2e6e..b1033e5ef7f0 100644
> --- a/db/sb.c
> +++ b/db/sb.c
> @@ -620,6 +620,44 @@ do_version(xfs_agnumber_t agno, uint16_t version, uint32_t features)
>  	return 1;
>  }
>  
> +/* Add new V5 features to the filesystem. */
> +static bool
> +add_v5_features(
> +	struct xfs_mount	*mp,
> +	uint32_t		compat,
> +	uint32_t		ro_compat,
> +	uint32_t		incompat,
> +	uint32_t		log_incompat)
> +{
> +	struct xfs_sb		tsb;
> +	xfs_agnumber_t		agno;
> +
> +	dbprintf(_("Upgrading V5 filesystem\n"));
> +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> +		if (!get_sb(agno, &tsb))
> +			break;
> +
> +		tsb.sb_features_compat |= compat;
> +		tsb.sb_features_ro_compat |= ro_compat;
> +		tsb.sb_features_incompat |= incompat;
> +		tsb.sb_features_log_incompat |= log_incompat;
> +		libxfs_sb_to_disk(iocur_top->data, &tsb);
> +		write_cur();
> +	}
> +
> +	if (agno != mp->m_sb.sb_agcount) {
> +		dbprintf(
> +_("Failed to upgrade V5 filesystem AG %d\n"), agno);
> +		return false;

Do we need to undo changes if this somehow occurs?

> +	}
> +
> +	mp->m_sb.sb_features_compat |= compat;
> +	mp->m_sb.sb_features_ro_compat |= ro_compat;
> +	mp->m_sb.sb_features_incompat |= incompat;
> +	mp->m_sb.sb_features_log_incompat |= log_incompat;
> +	return true;
> +}
> +
>  static char *
>  version_string(
>  	xfs_sb_t	*sbp)
> @@ -705,6 +743,10 @@ version_f(

The comment above version_f() needs an update if we start to support v5
features.

>  {
>  	uint16_t	version = 0;
>  	uint32_t	features = 0;
> +	uint32_t	upgrade_compat = 0;
> +	uint32_t	upgrade_ro_compat = 0;
> +	uint32_t	upgrade_incompat = 0;
> +	uint32_t	upgrade_log_incompat = 0;
>  	xfs_agnumber_t	ag;
>  
>  	if (argc == 2) {	/* WRITE VERSION */
> @@ -716,7 +758,28 @@ version_f(
>  		}
>  
>  		/* Logic here derived from the IRIX xfs_chver(1M) script. */
> -		if (!strcasecmp(argv[1], "extflg")) {
> +		if (!strcasecmp(argv[1], "inobtcount")) {
> +			if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
> +				dbprintf(
> +		_("inode btree counter feature is already enabled\n"));
> +				exitcode = 1;
> +				return 1;
> +			}
> +			if (!xfs_sb_version_hasfinobt(&mp->m_sb)) {
> +				dbprintf(
> +		_("inode btree counter feature cannot be enabled on filesystems lacking free inode btrees\n"));
> +				exitcode = 1;
> +				return 1;
> +			}
> +			if (!xfs_sb_version_hascrc(&mp->m_sb)) {
> +				dbprintf(
> +		_("inode btree counter feature cannot be enabled on pre-V5 filesystems\n"));
> +				exitcode = 1;
> +				return 1;
> +			}
> +
> +			upgrade_ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
> +		} else if (!strcasecmp(argv[1], "extflg")) {
>  			switch (XFS_SB_VERSION_NUM(&mp->m_sb)) {
>  			case XFS_SB_VERSION_1:
>  				version = 0x0004 | XFS_SB_VERSION_EXTFLGBIT;
> @@ -807,6 +870,17 @@ version_f(
>  			mp->m_sb.sb_versionnum = version;
>  			mp->m_sb.sb_features2 = features;
>  		}
> +
> +		if (upgrade_compat || upgrade_ro_compat || upgrade_incompat ||
> +		    upgrade_log_incompat) {
> +			if (!add_v5_features(mp, upgrade_compat,
> +					upgrade_ro_compat,
> +					upgrade_incompat,
> +					upgrade_log_incompat)) {
> +				exitcode = 1;
> +				return 1;
> +			}
> +		}

What's the purpose of the unused upgrade variables?

Also, it looks like we just update the feature bits here. What about the
counters? Is the user expected to run xfs_repair?

>  	}
>  
>  	if (argc == 3) {	/* VERSIONNUM + FEATURES2 */
> diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
> index bd325da2f776..0f0c8d18d6cb 100755
> --- a/db/xfs_admin.sh
> +++ b/db/xfs_admin.sh
> @@ -9,7 +9,7 @@ DB_OPTS=""
>  REPAIR_OPTS=""
>  USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-U uuid] device [logdev]"
>  
> -while getopts "efjlpuc:L:U:V" c
> +while getopts "efjlpuc:L:O:U:V" c
>  do
>  	case $c in
>  	c)	REPAIR_OPTS=$REPAIR_OPTS" -c lazycount="$OPTARG;;
> @@ -19,6 +19,8 @@ do
>  	l)	DB_OPTS=$DB_OPTS" -r -c label";;
>  	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";;
>  	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'";;
> +	O)	DB_OPTS=$DB_OPTS" -c 'version "$OPTARG"'";
> +		REPAIR_OPTS="$REPAIR_OPTS ";;

Ah, I see.. xfs_admin runs repair if options are specified, hence this
little whitespace hack. It might be worth a comment here so somebody
doesn't fly by and "clean" that up. ;)

BTW, does this also address the error scenario I asked about above...?

>  	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
>  	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'";;
>  	V)	xfs_db -p xfs_admin -V
> diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
> index 8afc873fb50a..65ca6afc1e12 100644
> --- a/man/man8/xfs_admin.8
> +++ b/man/man8/xfs_admin.8
> @@ -6,6 +6,8 @@ xfs_admin \- change parameters of an XFS filesystem
>  [
>  .B \-eflpu
>  ] [
> +.BR \-O " feature"
> +] [
>  .BR "\-c 0" | 1
>  ] [
>  .B \-L
> @@ -103,6 +105,20 @@ The filesystem label can be cleared using the special "\c
>  " value for
>  .IR label .
>  .TP
> +.BI \-O " feature"
> +Add a new feature to the filesystem.
> +Only one feature can be specified at a time.
> +Features are as follows:
> +.RS 0.7i
> +.TP
> +.B inobtcount
> +Upgrade the filesystem to support the inode btree counters feature.
> +This reduces mount time by caching the size of the inode btrees in the
> +allocation group metadata.
> +Once enabled, the filesystem will not be writable by older kernels.
> +The filesystem cannot be downgraded after this feature is enabled.

Any reason for not allowing the downgrade path? It seems like we're
mostly there implementation wise and that might facilitate enabling the
feature by default.

Brian

> +.RE
> +.TP
>  .BI \-U " uuid"
>  Set the UUID of the filesystem to
>  .IR uuid .
> 

