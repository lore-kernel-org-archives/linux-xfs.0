Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE4CC001DF
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Aug 2023 17:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbjHBROK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Aug 2023 13:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbjHBROJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Aug 2023 13:14:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1671C11D
        for <linux-xfs@vger.kernel.org>; Wed,  2 Aug 2023 10:14:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 655E861A33
        for <linux-xfs@vger.kernel.org>; Wed,  2 Aug 2023 17:14:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA1FC433C7;
        Wed,  2 Aug 2023 17:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690996445;
        bh=FAMhfyoFcTXpY4qbBMtrK5OjsvOjkHly4UEGIn6rfE0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cUNSjd1ln/7ARObYg58Z49cfYsM9ZHtVxncxSyrzXXrwChfCojmvsQRwxYJsimB+m
         ckb2Enk1c1l1r27pH+Sy8m28UNXpuLU4sO9+Jxph/E8jtWhWLEtXh9tpZL+cV6yBAU
         3EFtXAAt1VFjp4eMsu9GwoqDpJVA3skm1yKPodXacwYXfTCUnwRL/BErOEDlKtGsmV
         eBo/3af6DJVYNazo/Iz7vUP5ZDzMrRzL8IJhQpstsARIFra9Gf+EdqFsoH9JMjOHpt
         ZDYeBXYjythBZDPZgqJbly0npE7xJJN045hpI61SjJeH3fRGzHAihXfpLwiRSgUzy+
         UP/q7jvIroiHw==
Date:   Wed, 2 Aug 2023 10:14:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V3 13/23] metadump: Add support for passing version option
Message-ID: <20230802171405.GA11352@frogsfrogsfrogs>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
 <20230724043527.238600-14-chandan.babu@oracle.com>
 <20230801235120.GU11352@frogsfrogsfrogs>
 <87h6phr349.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h6phr349.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 02, 2023 at 06:48:31PM +0530, Chandan Babu R wrote:
> On Tue, Aug 01, 2023 at 04:51:20 PM -0700, Darrick J. Wong wrote:
> > On Mon, Jul 24, 2023 at 10:05:17AM +0530, Chandan Babu R wrote:
> >> The new option allows the user to explicitly specify the version of metadump
> >> to use. However, we will default to using the v1 format.
> >> 
> >> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> >
> > Why did this lose its RVB tag from v2?
> 
> copy_log() and metadump_f() were invoking set_log_cur() for both
> "internal log" and "external log". In this version of the patchset, I
> have modified the copy_log() function to,
> 1. Invoke set_log_cur() when the filesystem has an external log.
> 2. Invoke set_cur() when the filesystem has an internal log.
> 
> I think the above changes warrant a review. Hence, I had to remove your
> RVB.

Ah, ok.  Well, this looks fine still, so...

> >
> > --D
> >
> >> ---
> >>  db/metadump.c           | 81 +++++++++++++++++++++++++++++++++++------
> >>  db/xfs_metadump.sh      |  3 +-
> >>  man/man8/xfs_metadump.8 | 14 +++++++
> >>  3 files changed, 86 insertions(+), 12 deletions(-)
> >> 
> >> diff --git a/db/metadump.c b/db/metadump.c
> >> index 9b4ed70d..9fe9fe65 100644
> >> --- a/db/metadump.c
> >> +++ b/db/metadump.c
> >> @@ -37,7 +37,7 @@ static void	metadump_help(void);
> >>  
> >>  static const cmdinfo_t	metadump_cmd =
> >>  	{ "metadump", NULL, metadump_f, 0, -1, 0,
> >> -		N_("[-a] [-e] [-g] [-m max_extent] [-w] [-o] filename"),
> >> +		N_("[-a] [-e] [-g] [-m max_extent] [-w] [-o] [-v 1|2] filename"),
> >>  		N_("dump metadata to a file"), metadump_help };
> >>  
> >>  struct metadump_ops {
> >> @@ -74,6 +74,7 @@ static struct metadump {
> >>  	bool			zero_stale_data;
> >>  	bool			progress_since_warning;
> >>  	bool			dirty_log;
> >> +	bool			external_log;
> >>  	bool			stdout_metadump;
> >>  	xfs_ino_t		cur_ino;
> >>  	/* Metadump file */
> >> @@ -107,6 +108,7 @@ metadump_help(void)
> >>  "   -g -- Display dump progress\n"
> >>  "   -m -- Specify max extent size in blocks to copy (default = %d blocks)\n"
> >>  "   -o -- Don't obfuscate names and extended attributes\n"
> >> +"   -v -- Metadump version to be used\n"
> >>  "   -w -- Show warnings of bad metadata information\n"
> >>  "\n"), DEFAULT_MAX_EXT_SIZE);
> >>  }
> >> @@ -2909,8 +2911,20 @@ copy_log(void)
> >>  		print_progress("Copying log");
> >>  
> >>  	push_cur();
> >> -	set_cur(&typtab[TYP_LOG], XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
> >> -			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
> >> +	if (metadump.external_log) {
> >> +		ASSERT(mp->m_sb.sb_logstart == 0);
> >> +		set_log_cur(&typtab[TYP_LOG],
> >> +				XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
> >> +				mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN,
> >> +				NULL);
> >> +	} else {
> >> +		ASSERT(mp->m_sb.sb_logstart != 0);
> >> +		set_cur(&typtab[TYP_LOG],
> >> +				XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
> >> +				mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN,
> >> +				NULL);
> >> +	}
> >> +
> >>  	if (iocur_top->data == NULL) {
> >>  		pop_cur();
> >>  		print_warning("cannot read log");
> >> @@ -3071,6 +3085,8 @@ init_metadump_v2(void)
> >>  		compat_flags |= XFS_MD2_INCOMPAT_FULLBLOCKS;
> >>  	if (metadump.dirty_log)
> >>  		compat_flags |= XFS_MD2_INCOMPAT_DIRTYLOG;
> >> +	if (metadump.external_log)
> >> +		compat_flags |= XFS_MD2_INCOMPAT_EXTERNALLOG;
> >>  
> >>  	xmh.xmh_compat_flags = cpu_to_be32(compat_flags);
> >>  
> >> @@ -3131,6 +3147,7 @@ metadump_f(
> >>  	int		outfd = -1;
> >>  	int		ret;
> >>  	char		*p;
> >> +	bool		version_opt_set = false;
> >>  
> >>  	exitcode = 1;
> >>  
> >> @@ -3142,6 +3159,7 @@ metadump_f(
> >>  	metadump.obfuscate = true;
> >>  	metadump.zero_stale_data = true;
> >>  	metadump.dirty_log = false;
> >> +	metadump.external_log = false;
> >>  
> >>  	if (mp->m_sb.sb_magicnum != XFS_SB_MAGIC) {
> >>  		print_warning("bad superblock magic number %x, giving up",
> >> @@ -3159,7 +3177,7 @@ metadump_f(
> >>  		return 0;
> >>  	}
> >>  
> >> -	while ((c = getopt(argc, argv, "aegm:ow")) != EOF) {
> >> +	while ((c = getopt(argc, argv, "aegm:ov:w")) != EOF) {
> >>  		switch (c) {
> >>  			case 'a':
> >>  				metadump.zero_stale_data = false;
> >> @@ -3183,6 +3201,17 @@ metadump_f(
> >>  			case 'o':
> >>  				metadump.obfuscate = false;
> >>  				break;
> >> +			case 'v':
> >> +				metadump.version = (int)strtol(optarg, &p, 0);
> >> +				if (*p != '\0' ||
> >> +				    (metadump.version != 1 &&
> >> +						metadump.version != 2)) {
> >> +					print_warning("bad metadump version: %s",
> >> +						optarg);
> >> +					return 0;
> >> +				}
> >> +				version_opt_set = true;
> >> +				break;
> >>  			case 'w':
> >>  				metadump.show_warnings = true;
> >>  				break;
> >> @@ -3197,12 +3226,42 @@ metadump_f(
> >>  		return 0;
> >>  	}
> >>  
> >> -	/* If we'll copy the log, see if the log is dirty */
> >> -	if (mp->m_sb.sb_logstart) {
> >> +	if (mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev)
> >> +		metadump.external_log = true;
> >> +
> >> +	if (metadump.external_log && !version_opt_set)
> >> +		metadump.version = 2;
> >> +
> >> +	if (metadump.version == 2 && mp->m_sb.sb_logstart == 0 &&
> >> +	    !metadump.external_log) {
> >> +		print_warning("external log device not loaded, use -l");
> >> +		return -ENODEV;

/me notes that any nonzero return from a *_f() function will stop
command processing, not just negative errnos:

	pushfile(stdin);
	while (!done) {
		if ((input = fetchline()) == NULL)
			break;
		v = breakline(input, &c);
		if (c)
			done = command(c, v);
		doneline(input, v);
	}

The actual value here doesn't matter, so it's not a bug, just nitpicking
on my part.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> >> +	}
> >> +
> >> +	/*
> >> +	 * If we'll copy the log, see if the log is dirty.
> >> +	 *
> >> +	 * Metadump v1 does not support dumping the contents of an external
> >> +	 * log. Hence we skip the dirty log check.
> >> +	 */
> >> +	if (!(metadump.version == 1 && metadump.external_log)) {
> >>  		push_cur();
> >> -		set_cur(&typtab[TYP_LOG],
> >> -			XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
> >> -			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
> >> +		if (metadump.external_log) {
> >> +			ASSERT(mp->m_sb.sb_logstart == 0);
> >> +			set_log_cur(&typtab[TYP_LOG],
> >> +					XFS_FSB_TO_DADDR(mp,
> >> +							mp->m_sb.sb_logstart),
> >> +					mp->m_sb.sb_logblocks * blkbb,
> >> +					DB_RING_IGN, NULL);
> >> +		} else {
> >> +			ASSERT(mp->m_sb.sb_logstart != 0);
> >> +			set_cur(&typtab[TYP_LOG],
> >> +					XFS_FSB_TO_DADDR(mp,
> >> +							mp->m_sb.sb_logstart),
> >> +					mp->m_sb.sb_logblocks * blkbb,
> >> +					DB_RING_IGN, NULL);
> >> +		}
> >> +
> >>  		if (iocur_top->data) {	/* best effort */
> >>  			struct xlog	log;
> >>  
> >> @@ -3278,8 +3337,8 @@ metadump_f(
> >>  	if (!exitcode)
> >>  		exitcode = !copy_sb_inodes();
> >>  
> >> -	/* copy log if it's internal */
> >> -	if ((mp->m_sb.sb_logstart != 0) && !exitcode)
> >> +	/* copy log */
> >> +	if (!exitcode && !(metadump.version == 1 && metadump.external_log))
> >>  		exitcode = !copy_log();
> >>  
> >>  	/* write the remaining index */
> >> diff --git a/db/xfs_metadump.sh b/db/xfs_metadump.sh
> >> index 9852a5bc..9e8f86e5 100755
> >> --- a/db/xfs_metadump.sh
> >> +++ b/db/xfs_metadump.sh
> >> @@ -8,7 +8,7 @@ OPTS=" "
> >>  DBOPTS=" "
> >>  USAGE="Usage: xfs_metadump [-aefFogwV] [-m max_extents] [-l logdev] source target"
> >>  
> >> -while getopts "aefgl:m:owFV" c
> >> +while getopts "aefgl:m:owFv:V" c
> >>  do
> >>  	case $c in
> >>  	a)	OPTS=$OPTS"-a ";;
> >> @@ -20,6 +20,7 @@ do
> >>  	f)	DBOPTS=$DBOPTS" -f";;
> >>  	l)	DBOPTS=$DBOPTS" -l "$OPTARG" ";;
> >>  	F)	DBOPTS=$DBOPTS" -F";;
> >> +	v)	OPTS=$OPTS"-v "$OPTARG" ";;
> >>  	V)	xfs_db -p xfs_metadump -V
> >>  		status=$?
> >>  		exit $status
> >> diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
> >> index c0e79d77..1732012c 100644
> >> --- a/man/man8/xfs_metadump.8
> >> +++ b/man/man8/xfs_metadump.8
> >> @@ -11,6 +11,9 @@ xfs_metadump \- copy XFS filesystem metadata to a file
> >>  ] [
> >>  .B \-l
> >>  .I logdev
> >> +] [
> >> +.B \-v
> >> +.I version
> >>  ]
> >>  .I source
> >>  .I target
> >> @@ -74,6 +77,12 @@ metadata such as filenames is not considered sensitive.  If obfuscation
> >>  is required on a metadump with a dirty log, please inform the recipient
> >>  of the metadump image about this situation.
> >>  .PP
> >> +The contents of an external log device can be dumped only when using the v2
> >> +format.
> >> +Metadump in v2 format can be generated by passing the "-v 2" option.
> >> +Metadump in v2 format is generated by default if the filesystem has an
> >> +external log and the metadump version to use is not explicitly mentioned.
> >> +.PP
> >>  .B xfs_metadump
> >>  should not be used for any purposes other than for debugging and reporting
> >>  filesystem problems. The most common usage scenario for this tool is when
> >> @@ -134,6 +143,11 @@ this value.  The default size is 2097151 blocks.
> >>  .B \-o
> >>  Disables obfuscation of file names and extended attributes.
> >>  .TP
> >> +.B \-v
> >> +The format of the metadump file to be produced.
> >> +Valid values are 1 and 2.
> >> +The default metadump format is 1.
> >> +.TP
> >>  .B \-w
> >>  Prints warnings of inconsistent metadata encountered to stderr. Bad metadata
> >>  is still copied.
> >> -- 
> >> 2.39.1
> >> 
> 
> -- 
> chandan
