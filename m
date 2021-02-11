Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94825C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 23:30:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E57364E42
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 23:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbhBKX3v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:29:51 -0500
Received: from sandeen.net ([63.231.237.45]:39664 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230042AbhBKX3r (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Feb 2021 18:29:47 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 8CA183321E2;
        Thu, 11 Feb 2021 17:29:04 -0600 (CST)
Subject: Re: [PATCH 08/11] xfs_repair: allow setting the needsrepair flag
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org
References: <161308434132.3850286.13801623440532587184.stgit@magnolia>
 <161308438691.3850286.3501696811159590596.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2e135dfe-9be6-b5f9-7c06-a10e6e45e3da@sandeen.net>
Date:   Thu, 11 Feb 2021 17:29:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <161308438691.3850286.3501696811159590596.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/11/21 4:59 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Quietly set up the ability to tell xfs_repair to set NEEDSREPAIR at
> program start and (presumably) clear it by the end of the run.  This
> code isn't terribly useful to users; it's mainly here so that fstests
> can exercise the functionality.  We don't document this flag in the
> manual pages at all because repair clears needsrepair at exit, which
> means the knobs only exist for fstests to exercise the functionality.
> 
> Note that we can't do any of these upgrades until we've at least done a
> preliminary scan of the primary super and the log.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>


I'm still a little on the fence about the cmdline option for crashing repair at a certain point from the POV that Brian kind of pointed out that this doesn't exactly scale as we need more hooks.

but

ehhhh it's a test-only undocumented option and I guess we could change it later if desired

we do have other debug options on the commandline already as well....


> ---
>  repair/globals.c    |    2 ++
>  repair/globals.h    |    2 ++
>  repair/phase2.c     |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  repair/xfs_repair.c |    9 +++++++
>  4 files changed, 76 insertions(+)
> 
> 
> diff --git a/repair/globals.c b/repair/globals.c
> index 110d98b6..699a96ee 100644
> --- a/repair/globals.c
> +++ b/repair/globals.c
> @@ -49,6 +49,8 @@ int	rt_spec;		/* Realtime dev specified as option */
>  int	convert_lazy_count;	/* Convert lazy-count mode on/off */
>  int	lazy_count;		/* What to set if to if converting */
>  
> +bool	add_needsrepair;	/* forcibly set needsrepair while repairing */
> +
>  /* misc status variables */
>  
>  int	primary_sb_modified;
> diff --git a/repair/globals.h b/repair/globals.h
> index 1d397b35..043b3e8e 100644
> --- a/repair/globals.h
> +++ b/repair/globals.h
> @@ -90,6 +90,8 @@ extern int	rt_spec;		/* Realtime dev specified as option */
>  extern int	convert_lazy_count;	/* Convert lazy-count mode on/off */
>  extern int	lazy_count;		/* What to set if to if converting */
>  
> +extern bool	add_needsrepair;
> +
>  /* misc status variables */
>  
>  extern int		primary_sb_modified;
> diff --git a/repair/phase2.c b/repair/phase2.c
> index 952ac4a5..9a8d42e1 100644
> --- a/repair/phase2.c
> +++ b/repair/phase2.c
> @@ -131,6 +131,63 @@ zero_log(
>  		libxfs_max_lsn = log->l_last_sync_lsn;
>  }
>  
> +static bool
> +set_needsrepair(
> +	struct xfs_mount	*mp)
> +{
> +	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
> +		printf(
> +	_("needsrepair flag only supported on V5 filesystems.\n"));
> +		exit(0);
> +	}
> +
> +	if (xfs_sb_version_needsrepair(&mp->m_sb)) {
> +		printf(_("Filesystem already marked as needing repair.\n"));
> +		exit(0);
> +	}
> +
> +	printf(_("Marking filesystem in need of repair.\n"));
> +	mp->m_sb.sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> +	return true;
> +}
> +
> +/* Perform the user's requested upgrades on filesystem. */
> +static void
> +upgrade_filesystem(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_buf		*bp;
> +	bool			dirty = false;
> +	int			error;
> +
> +	if (add_needsrepair)
> +		dirty |= set_needsrepair(mp);
> +
> +        if (no_modify || !dirty)
> +                return;
> +
> +        bp = libxfs_getsb(mp);
> +        if (!bp || bp->b_error) {
> +                do_error(
> +	_("couldn't get superblock for feature upgrade, err=%d\n"),
> +                                bp ? bp->b_error : ENOMEM);
> +        } else {
> +                libxfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> +
> +                /*
> +		 * Write the primary super to disk immediately so that
> +		 * needsrepair will be set if repair doesn't complete.
> +		 */
> +                error = -libxfs_bwrite(bp);
> +                if (error)
> +                        do_error(
> +	_("filesystem feature upgrade failed, err=%d\n"),
> +                                        error);
> +        }
> +        if (bp)
> +                libxfs_buf_relse(bp);
> +}
> +
>  /*
>   * ok, at this point, the fs is mounted but the root inode may be
>   * trashed and the ag headers haven't been checked.  So we have
> @@ -235,4 +292,10 @@ phase2(
>  				do_warn(_("would correct\n"));
>  		}
>  	}
> +
> +	/*
> +	 * Upgrade the filesystem now that we've done a preliminary check of
> +	 * the superblocks, the AGs, the log, and the metadata inodes.
> +	 */
> +	upgrade_filesystem(mp);
>  }
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 90d1a95a..a613505f 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -65,11 +65,13 @@ static char *o_opts[] = {
>   */
>  enum c_opt_nums {
>  	CONVERT_LAZY_COUNT = 0,
> +	CONVERT_NEEDSREPAIR,
>  	C_MAX_OPTS,
>  };
>  
>  static char *c_opts[] = {
>  	[CONVERT_LAZY_COUNT]	= "lazycount",
> +	[CONVERT_NEEDSREPAIR]	= "needsrepair",
>  	[C_MAX_OPTS]		= NULL,
>  };
>  
> @@ -302,6 +304,13 @@ process_args(int argc, char **argv)
>  					lazy_count = (int)strtol(val, NULL, 0);
>  					convert_lazy_count = 1;
>  					break;
> +				case CONVERT_NEEDSREPAIR:
> +					if (!val)
> +						do_abort(
> +		_("-c needsrepair requires a parameter\n"));
> +					if (strtol(val, NULL, 0) == 1)
> +						add_needsrepair = true;
> +					break;
>  				default:
>  					unknown('c', val);
>  					break;
> 
