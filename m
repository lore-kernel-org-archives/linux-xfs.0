Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D793346A0
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 03:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789961779; cv=none; b=niI4HF246eXZDZ83iKIyI58NVRXjk1GRTQZRu+zViu4uIddBjrf4rZOFzDr906C9aezgMQKJy4tpEGBQBZTtplA4BJAf2uoxbcT+Bkl/d5+r2S2W2WKH4lR+KmPoZor19x1CmlPiLTOUksLLB/Z9wXbFRogiRZIvBqh/eBaNvSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789961779; c=relaxed/simple;
	bh=SBwnvzxTDU+g2HgmrIg2U7Br90YYfqpW9QnmgS0oaPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FBDuDVSL4tI5YLG+dIJBGosBm08cHtlKfgM0G42jb7E99x4HhZYPz1CGM6uHbZW6Xxt50kiun6nmYuykVAFQOEcb5JzbnXWNVF/BOwAOvk/mL+nouW+kylqfH8RaS8zkahuHhAXL4gP6eqKVQ/FLQZ8kRgcaZJrUkcjBIcXJMmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GSJjI+k1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GSJjI+k1"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 13D501F000FF;
	Mon, 21 Sep 2026 03:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789961778;
	bh=J/rN1qayBi/o5/Qd1ZyMjFnmfa9PvrB1xb34MpxHFO0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GSJjI+k1l3aeNI8vWYkUbB6nLll5MTkEvZaWyEZfDdzfh2FfY8FC7/pZXBw4DXdXm
	 0LRNHrE4AmhuK76e4UfbiLTc4TWa8MdNdoFc/WX5Tpj39NcmXYRIwF0vZ+xsrvszDH
	 +5//AZ5KXGkLfuoDbF8FxgYPIkpfNsBMEhy6bpjakBsvFk1tnetuVeXO2FqxvhWRSt
	 QgYHJfDQKfVZa9HPECCZDnPjF+azbQ0kK4EyQzHvVmtY7bWJaRIVG/CtMcfZuej7gN
	 5zjx2FWsHgn5NSRX6qFzglrnV+KqDX00iLMkdRcJwjcpwj/tMkKwRbqOzzO9exfkJr
	 fz6uqq1h9YD4g==
Date: Sun, 20 Sep 2026 20:36:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: hch@lst.de, sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 1/3] xfs: add xfs_error_report the ability to display
 an error code
Message-ID: <20260921033617.GF2705364@frogsfrogsfrogs>
References: <20260917103633.14703-1-cem@kernel.org>
 <20260917103633.14703-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917103633.14703-2-cem@kernel.org>

On Thu, Sep 17, 2026 at 12:35:46PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Users could opt to request an error code to be printed now.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks good,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
> V3:
> 	- Remove stale description aboutt ERRNAME
> V2:
> 	- Fix commit description s/_NAME/_ERRNAME
> 	- xfs_corruption_error should call xfs_error_report with
> 	  -EFSCORRUPTED
> 	- Modify xfs_error_report to only print out the error number if
> 	  it received an error from the caller.
> 	- Don't use errname() anymore.
> 
>  fs/xfs/xfs_error.c         | 16 +++++++++++-----
>  fs/xfs/xfs_error.h         |  9 +++++----
>  fs/xfs/xfs_exchmaps_item.c |  9 ++++++---
>  fs/xfs/xfs_inode_item.c    |  3 ++-
>  fs/xfs/xfs_log_recover.c   |  3 ++-
>  fs/xfs/xfs_trans.c         |  2 +-
>  6 files changed, 27 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 9ece70fd94ca..c943717f1dd7 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -241,16 +241,21 @@ void
>  xfs_error_report(
>  	const char		*tag,
>  	int			level,
> +	int			error,
>  	struct xfs_mount	*mp,
>  	const char		*filename,
>  	int			linenum,
>  	xfs_failaddr_t		failaddr)
>  {
>  	if (level <= xfs_error_level) {
> -		xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
> -		"Internal error %s at line %d of file %s.  Caller %pS",
> -			    tag, linenum, filename, failaddr);
> -
> +		if (error)
> +			xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
> +"Internal error %s (%d) at line %d of file %s.  Caller %pS",
> +				tag, error, linenum, filename, failaddr);
> +		else
> +			xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
> +"Internal error %s at line %d of file %s.  Caller %pS",
> +				tag, linenum, filename, failaddr);
>  		xfs_stack_trace();
>  	}
>  }
> @@ -268,7 +273,8 @@ xfs_corruption_error(
>  {
>  	if (buf && level <= xfs_error_level)
>  		xfs_hex_dump(buf, bufsize);
> -	xfs_error_report(tag, level, mp, filename, linenum, failaddr);
> +	xfs_error_report(tag, level, -EFSCORRUPTED, mp,
> +			 filename, linenum, failaddr);
>  	xfs_alert(mp, "Corruption detected. Unmount and run xfs_repair");
>  }
>  
> diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> index 05fc1d1cf521..3c76d0dad51c 100644
> --- a/fs/xfs/xfs_error.h
> +++ b/fs/xfs/xfs_error.h
> @@ -8,8 +8,9 @@
>  
>  struct xfs_mount;
>  
> -void xfs_error_report(const char *tag, int level, struct xfs_mount *mp,
> -		const char *filename, int linenum, xfs_failaddr_t failaddr);
> +void xfs_error_report(const char *tag, int level, int error,
> +		struct xfs_mount *mp, const char *filename,
> +		int linenum, xfs_failaddr_t failaddr);
>  void xfs_corruption_error(const char *tag, int level, struct xfs_mount *mp,
>  		const void *buf, size_t bufsize, const char *filename,
>  		int linenum, xfs_failaddr_t failaddr);
> @@ -20,8 +21,8 @@ void xfs_verifier_error(struct xfs_buf *bp, int error, xfs_failaddr_t failaddr);
>  void xfs_inode_verifier_error(struct xfs_inode *ip, int error, const char *name,
>  		const void *buf, size_t bufsz, xfs_failaddr_t failaddr);
>  
> -#define	XFS_ERROR_REPORT(e, lvl, mp)	\
> -	xfs_error_report(e, lvl, mp, __FILE__, __LINE__, __return_address)
> +#define	XFS_ERROR_REPORT(e, lvl, error, mp)	\
> +	xfs_error_report(e, lvl, error, mp, __FILE__, __LINE__, __return_address)
>  #define	XFS_CORRUPTION_ERROR(e, lvl, mp, buf, bufsize)	\
>  	xfs_corruption_error(e, lvl, mp, buf, bufsize, \
>  			     __FILE__, __LINE__, __return_address)
> diff --git a/fs/xfs/xfs_exchmaps_item.c b/fs/xfs/xfs_exchmaps_item.c
> index dd5d92ca1010..9f499a80038c 100644
> --- a/fs/xfs/xfs_exchmaps_item.c
> +++ b/fs/xfs/xfs_exchmaps_item.c
> @@ -573,13 +573,15 @@ xlog_recover_xmi_commit_pass2(
>  
>  	len = sizeof(struct xfs_xmi_log_format);
>  	if (item->ri_buf[0].iov_len != len) {
> -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> +				 -EFSCORRUPTED, log->l_mp);
>  		return -EFSCORRUPTED;
>  	}
>  
>  	xmi_formatp = item->ri_buf[0].iov_base;
>  	if (xmi_formatp->__pad != 0) {
> -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> +				 -EFSCORRUPTED, log->l_mp);
>  		return -EFSCORRUPTED;
>  	}
>  
> @@ -614,7 +616,8 @@ xlog_recover_xmd_commit_pass2(
>  
>  	xmd_formatp = item->ri_buf[0].iov_base;
>  	if (item->ri_buf[0].iov_len != sizeof(struct xfs_xmd_log_format)) {
> -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> +				 -EFSCORRUPTED, log->l_mp);
>  		return -EFSCORRUPTED;
>  	}
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 99d6ecccdaa7..a29c90f0650f 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -1229,7 +1229,8 @@ xfs_inode_item_format_convert(
>  	struct xfs_inode_log_format_32	*in_f32 = buf->iov_base;
>  
>  	if (buf->iov_len != sizeof(*in_f32)) {
> -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> +				 -EFSCORRUPTED, NULL);
>  		return -EFSCORRUPTED;
>  	}
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index cf0d610265fe..457617979668 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2948,7 +2948,8 @@ xlog_recover_process(
>  		 * fatal log corruption failure.
>  		 */
>  		if (xfs_has_crc(log->l_mp)) {
> -			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> +			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> +					 -EFSCORRUPTED, log->l_mp);
>  			return -EFSCORRUPTED;
>  		}
>  	}
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 1b36cf12d4e3..5c522790e5be 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -971,7 +971,7 @@ xfs_trans_cancel(
>  	 * here.
>  	 */
>  	if (dirty && !xfs_is_shutdown(mp)) {
> -		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, mp);
> +		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, 0, mp);
>  		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  	}
>  #ifdef DEBUG
> -- 
> 2.55.0
> 
> 
