Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00843C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 05:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A86E364ECE
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 05:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhBZFHe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Feb 2021 00:07:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:43906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229453AbhBZFHd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Feb 2021 00:07:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1391464ED2;
        Fri, 26 Feb 2021 05:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614316012;
        bh=Op4V8FmohIdBJQHSbXuKM+EiJHjwSfC2PB11S5VB8Zw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VQmV8MNUZG8q3QLGNOoIB8guvFvu8fbDrh7Feq9e9EiApn/KYX/a2HbHOP67kI2jr
         7yg4tIG/Wv05Me0YWHOSZyA63pauUUnLPiI9bx9y+tMqbmDJchsSkJ1XI/1mSNFYS9
         SPGUwb+Sa3QxyFc7e1SXLr9dGkN66OWnfQfdQHM+gl6mbqJ4W+G8YbXKPlz5VhzCGh
         vaYgACgGnsvhI/PUB4ZHN7X6NPvNWAF9LAnSL/KYrwe/O/fVw8IPhyWqHN4lcE5bIV
         BniR7CVdgB+DJBfeivEj6qOOsB4VZVg1lsCqwHVD39/JbB+frtfdDzOaJ1GzCSj6oK
         VkSweh0Gz84ZA==
Date:   Thu, 25 Feb 2021 21:06:52 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v15 13/22] xfs: Add state machine tracepoints
Message-ID: <20210226050652.GB7272@magnolia>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-14-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218165348.4754-14-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 09:53:39AM -0700, Allison Henderson wrote:
> This is a quick patch to add a new tracepoint: xfs_das_state_return.  We
> use this to track when ever a new state is set or -EAGAIN is returned
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

Looks good!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c        | 31 ++++++++++++++++++++++++++++++-
>  fs/xfs/libxfs/xfs_attr_remote.c |  1 +
>  fs/xfs/xfs_trace.h              | 25 +++++++++++++++++++++++++
>  3 files changed, 56 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index c7b86d5..ba21475 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -313,6 +313,7 @@ xfs_attr_set_fmt(
>  	 * the attr fork to leaf format and will restart with the leaf
>  	 * add.
>  	 */
> +	trace_xfs_attr_set_fmt_return(XFS_DAS_UNINIT, args->dp);
>  	dac->flags |= XFS_DAC_DEFER_FINISH;
>  	return -EAGAIN;
>  }
> @@ -378,6 +379,8 @@ xfs_attr_set_iter(
>  				 * handling code below
>  				 */
>  				dac->flags |= XFS_DAC_DEFER_FINISH;
> +				trace_xfs_attr_set_iter_return(
> +					dac->dela_state, args->dp);
>  				return -EAGAIN;
>  			}
>  			else if (error)
> @@ -400,10 +403,13 @@ xfs_attr_set_iter(
>  				return error;
>  
>  			dac->dela_state = XFS_DAS_FOUND_NBLK;
> +			trace_xfs_attr_set_iter_return(dac->dela_state,
> +						       args->dp);
>  			return -EAGAIN;
>  		}
>  
>  		dac->dela_state = XFS_DAS_FOUND_LBLK;
> +		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
>  		return -EAGAIN;
>  
>          case XFS_DAS_FOUND_LBLK:
> @@ -433,6 +439,8 @@ xfs_attr_set_iter(
>  			if (error)
>  				return error;
>  
> +			trace_xfs_attr_set_iter_return(dac->dela_state,
> +						       args->dp);
>  			return -EAGAIN;
>  		}
>  
> @@ -469,6 +477,7 @@ xfs_attr_set_iter(
>  		 * series.
>  		 */
>  		dac->dela_state = XFS_DAS_FLIP_LFLAG;
> +		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
>  		return -EAGAIN;
>  	case XFS_DAS_FLIP_LFLAG:
>  		/*
> @@ -488,6 +497,9 @@ xfs_attr_set_iter(
>  	case XFS_DAS_RM_LBLK:
>  		if (args->rmtblkno) {
>  			error = __xfs_attr_rmtval_remove(dac);
> +			if (error == -EAGAIN)
> +				trace_xfs_attr_set_iter_return(
> +					dac->dela_state, args->dp);
>  			if (error)
>  				return error;
>  		}
> @@ -545,6 +557,8 @@ xfs_attr_set_iter(
>  				if (error)
>  					return error;
>  
> +				trace_xfs_attr_set_iter_return(
> +					dac->dela_state, args->dp);
>  				return -EAGAIN;
>  			}
>  
> @@ -581,6 +595,7 @@ xfs_attr_set_iter(
>  		 * series
>  		 */
>  		dac->dela_state = XFS_DAS_FLIP_NFLAG;
> +		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
>  		return -EAGAIN;
>  
>  	case XFS_DAS_FLIP_NFLAG:
> @@ -601,6 +616,10 @@ xfs_attr_set_iter(
>  	case XFS_DAS_RM_NBLK:
>  		if (args->rmtblkno) {
>  			error = __xfs_attr_rmtval_remove(dac);
> +			if (error == -EAGAIN)
> +				trace_xfs_attr_set_iter_return(
> +					dac->dela_state, args->dp);
> +
>  			if (error)
>  				return error;
>  		}
> @@ -1214,6 +1233,8 @@ xfs_attr_node_addname(
>  			 * this point.
>  			 */
>  			dac->flags |= XFS_DAC_DEFER_FINISH;
> +			trace_xfs_attr_node_addname_return(
> +					dac->dela_state, args->dp);
>  			return -EAGAIN;
>  		}
>  
> @@ -1394,6 +1415,9 @@ xfs_attr_node_remove_rmt (
>  	 * May return -EAGAIN to request that the caller recall this function
>  	 */
>  	error = __xfs_attr_rmtval_remove(dac);
> +	if (error == -EAGAIN)
> +		trace_xfs_attr_node_remove_rmt_return(dac->dela_state,
> +						      dac->da_args->dp);
>  	if (error)
>  		return error;
>  
> @@ -1513,6 +1537,8 @@ xfs_attr_node_removename_iter(
>  
>  			dac->flags |= XFS_DAC_DEFER_FINISH;
>  			dac->dela_state = XFS_DAS_RM_SHRINK;
> +			trace_xfs_attr_node_removename_iter_return(
> +					dac->dela_state, args->dp);
>  			return -EAGAIN;
>  		}
>  
> @@ -1531,8 +1557,11 @@ xfs_attr_node_removename_iter(
>  		goto out;
>  	}
>  
> -	if (error == -EAGAIN)
> +	if (error == -EAGAIN) {
> +		trace_xfs_attr_node_removename_iter_return(
> +					dac->dela_state, args->dp);
>  		return error;
> +	}
>  out:
>  	if (state)
>  		xfs_da_state_free(state);
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 6af86bf..b242e1a 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -763,6 +763,7 @@ __xfs_attr_rmtval_remove(
>  	 */
>  	if (!done) {
>  		dac->flags |= XFS_DAC_DEFER_FINISH;
> +		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
>  		return -EAGAIN;
>  	}
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 363e1bf..7993f55 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3927,6 +3927,31 @@ DEFINE_EVENT(xfs_eofblocks_class, name,	\
>  DEFINE_EOFBLOCKS_EVENT(xfs_ioc_free_eofblocks);
>  DEFINE_EOFBLOCKS_EVENT(xfs_blockgc_free_space);
>  
> +DECLARE_EVENT_CLASS(xfs_das_state_class,
> +	TP_PROTO(int das, struct xfs_inode *ip),
> +	TP_ARGS(das, ip),
> +	TP_STRUCT__entry(
> +		__field(int, das)
> +		__field(xfs_ino_t, ino)
> +	),
> +	TP_fast_assign(
> +		__entry->das = das;
> +		__entry->ino = ip->i_ino;
> +	),
> +	TP_printk("state change %d ino 0x%llx",
> +		  __entry->das, __entry->ino)
> +)
> +
> +#define DEFINE_DAS_STATE_EVENT(name) \
> +DEFINE_EVENT(xfs_das_state_class, name, \
> +	TP_PROTO(int das, struct xfs_inode *ip), \
> +	TP_ARGS(das, ip))
> +DEFINE_DAS_STATE_EVENT(xfs_attr_set_fmt_return);
> +DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
> +DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
> +DEFINE_DAS_STATE_EVENT(xfs_attr_node_removename_iter_return);
> +DEFINE_DAS_STATE_EVENT(xfs_attr_node_remove_rmt_return);
> +DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
>  #endif /* _TRACE_XFS_H */
>  
>  #undef TRACE_INCLUDE_PATH
> -- 
> 2.7.4
> 
