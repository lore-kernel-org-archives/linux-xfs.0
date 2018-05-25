Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:56774 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753116AbeEYDfH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 May 2018 23:35:07 -0400
Date: Thu, 24 May 2018 20:34:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 1/4] mkfs: distinguish between struct sb_feat_args and
 struct cli_params
Message-ID: <20180525033446.GP14384@magnolia>
References: <20180525031943.29440-1-mcgrof@kernel.org>
 <20180525031943.29440-2-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180525031943.29440-2-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Thu, May 24, 2018 at 08:19:40PM -0700, Luis R. Rodriguez wrote:
> The struct sb_feat_args will actually be shared between the code which
> processes command line options and the configuration file, as such we
> need to clarify and reflect this clearly in documentation.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  mkfs/xfs_mkfs.c | 45 ++++++++++++++++++++++++++++-----------------
>  1 file changed, 28 insertions(+), 17 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 3804814b3b8a..95cd6ced13f0 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -707,26 +707,18 @@ cli_opt_set(
>  }
>  
>  /*
> - * Options configured on the command line.
> - *
> - * This stores all the specific config parameters the user sets on the command
> - * line. We do not use these values directly - they are inputs to the mkfs
> - * geometry validation and override any default configuration value we have.
> + * Shared superblock configuration options
>   *
> - * We don't keep flags to indicate what parameters are set - if we need to check
> - * if an option was set on the command line, we check the relevant entry in the
> - * option table which records whether it was specified in the .seen and
> - * .str_seen variables in the table.
> + * These options provide shared configuration tunables for the filesystem
> + * superblock. There are three possible sources for these options set, each
> + * source can overriding the later source:
>   *
> - * Some parameters are stored as strings for post-parsing after their dependent
> - * options have been resolved (e.g. block size and sector size have been parsed
> - * and validated).
> + * 	o built-in defaults
> + * 	o configuration file (XXX)
> + * 	o command line
>   *
> - * This allows us to check that values have been set without needing separate
> - * flags for each value, and hence avoids needing to record and check for each
> - * specific option that can set the value later on in the code. In the cases
> - * where we don't have a cli_params structure around, the above cli_opt_set()
> - * function can be used.
> + * These values are not used directly - they are inputs into the mkfs geometry
> + * validation.
>   */
>  struct sb_feat_args {
>  	int	log_version;
> @@ -747,6 +739,25 @@ struct sb_feat_args {
>  	bool	nortalign;
>  };
>  
> +/*
> + * Options configured on the command line.
> + *
> + * This stores all the specific config parameters the user sets on the command
> + * line.  We don't keep flags to indicate what parameters are set - if we need
> + * to check if an option was set on the command line, we check the relevant
> + * entry in the option table which records whether it was specified in the
> + * .seen and .str_seen variables in the table.
> + *
> + * Some parameters are stored as strings for post-parsing after their dependent
> + * options have been resolved (e.g. block size and sector size have been parsed
> + * and validated).
> + *
> + * This allows us to check that values have been set without needing separate
> + * flags for each value, and hence avoids needing to record and check for each
> + * specific option that can set the value later on in the code. In the cases
> + * where we don't have a cli_params structure around, the function cli_opt_set()
> + * function can be used.
> + */
>  struct cli_params {
>  	int	sectorsize;
>  	int	blocksize;
> -- 
> 2.16.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
