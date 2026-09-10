Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8216D3DCDA2
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 09:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789032280; cv=none; b=O54FNNPS3JlxqChOcuyToD3zOSRPEt+Us7wlstPdzogM4pNmlx31EYNz7k5Wtqxjc0MrOQnzquT3ZNuN2pRkxf0UTNRDQ0zyk+ssZrfMFDERF1Eo7EQ87M2rDmwG5qVbL/QdT3WYpXlW2eZF1ZS4kDqiMBa31Ao/xeLHs5Gw//8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789032280; c=relaxed/simple;
	bh=mwwBREZPS43yMSCFQUxhW5Dr+j6tEhEgVYhXKnMnRJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dCTzUbRpklmVaVVSPU2dChOIv8YO80ioFHym/CL8B8VBhAvyL6rRRGW6wgt4q66CGBgrQIdk2SksJP3/60+IaxD0Nc74jwjN9E6KBAZfwToH42OTHZF2gERg0aO8SF0qrY0pSXWJ9uu4nCWXCJ5zMdBQ34R4r4O7oMhGQeJTFbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SqXO0AuF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SqXO0AuF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26551F000FF;
	Thu, 10 Sep 2026 09:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789032267;
	bh=SNXvCvYPXFnmjzZFqBS+bNi4IlwwMrhxXZg3M4N7c6k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SqXO0AuFt8O3nC1ZX9wvpdlul8nntUeWB21BlBolSBPvdpr/RqbsXjDG+0yFlJQQT
	 s/o+qiCubMybjYO+MFjnRlVXb7fd9QRk7kgYbixylF+wC4PJDTaOX2ykfAUGP095wZ
	 fF5BQWkwE/GwSE1cZ4EHdCbMDwmGtzdUdRrjEZj5U10VRUhpMWrSFv2aoy3a485WVA
	 b7h48SAxUQ/szUA2Kr7VK4CJ5xmxFJSPFolRSjNK9GEXT9zr7u4dc80QimjgbV05rI
	 oDaNWa3kjX3ErtWdjAIW52nlE/r9t3UG3PsN9Dyyr/7jIi4xeUF91y4VUBrhK5FJR/
	 LI4pzPz3nI+eg==
Date: Thu, 10 Sep 2026 11:24:24 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: add xfs_error_report the ability to display an
 error code
Message-ID: <aqJ1pZhNeTyvALhl@andromeda.toxiclabs.cc>
References: <20260908145422.232985-1-cem@kernel.org>
 <20260908145422.232985-2-cem@kernel.org>
 <20260908151635.GE2619314@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908151635.GE2619314@frogsfrogsfrogs>

On Tue, Sep 08, 2026 at 08:16:35AM -0700, Darrick J. Wong wrote:
> On Tue, Sep 08, 2026 at 04:54:14PM +0200, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> > 
> > Users could opt to request an error code to be printed now.
> > This relies on errname() and CONFIG_SYMBOLIC_NAME without requiring it
> > to be enabled.
> > Report 'unkown error' If CONFIG_SYMBOLIC_NAME is not enabled or the
> > user passes 0 as an error.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  fs/xfs/xfs_error.c         | 13 ++++++++++---
> >  fs/xfs/xfs_error.h         | 10 +++++-----
> >  fs/xfs/xfs_exchmaps_item.c |  9 ++++++---
> >  fs/xfs/xfs_inode_item.c    |  3 ++-
> >  fs/xfs/xfs_log_recover.c   |  3 ++-
> >  fs/xfs/xfs_trans.c         |  2 +-
> >  6 files changed, 26 insertions(+), 14 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> > index dbd87e137694..3177ec58bb2e 100644
> > --- a/fs/xfs/xfs_error.c
> > +++ b/fs/xfs/xfs_error.c
> > @@ -14,6 +14,7 @@
> >  #include "xfs_error.h"
> >  #include "xfs_sysfs.h"
> >  #include "xfs_inode.h"
> > +#include <linux/errname.h>
> >  
> >  #ifdef DEBUG
> >  
> > @@ -377,15 +378,21 @@ void
> >  xfs_error_report(
> >  	const char		*tag,
> >  	int			level,
> > +	int			error,
> >  	struct xfs_mount	*mp,
> >  	const char		*filename,
> >  	int			linenum,
> >  	xfs_failaddr_t		failaddr)
> >  {
> > +	const char *err_str = errname(error);
> > +
> > +	if (!err_str)
> > +		err_str = "unknown error";
> 
> Should it just snprintf the error number to a buffer?

I thought about that and also about using num_to_str() to print out the
error number *if* the ERRNAME config is disabled. I just thought it
wasn't worth handling an extra buffer here giving ERRNAME is enabled on
most major distros AFAICT.

I quick chat with Eric too and he suggested "unknown error" might be
confusing and perhaps replace the above with a blank string like:

err_str = "";


My whole point though in doing this way by not using a snprintf() and
num_to_str() is I believe it would be an overkill for this and opted to
KISS :)

> > +
> >  	if (level <= xfs_error_level) {
> >  		xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
> > -		"Internal error %s at line %d of file %s.  Caller %pS",
> > -			    tag, linenum, filename, failaddr);
> > +		"Internal error %s (%s) at line %d of file %s.  Caller %pS",
> > +			    tag, err_str, linenum, filename, failaddr);
> >  
> >  		xfs_stack_trace();
> >  	}
> > @@ -404,7 +411,7 @@ xfs_corruption_error(
> >  {
> >  	if (buf && level <= xfs_error_level)
> >  		xfs_hex_dump(buf, bufsize);
> > -	xfs_error_report(tag, level, mp, filename, linenum, failaddr);
> > +	xfs_error_report(tag, level, 0, mp, filename, linenum, failaddr);
> 
> Shouldn't this be -EFSCORRUPTED too?

Indeed, I didn't want to change any 'implicit' error handling in this
patch specifically. I was hoping to do that in a future patch adding
errors where pertinent. But I have zero objection in changing this.

> 
> --D
> 
> >  	xfs_alert(mp, "Corruption detected. Unmount and run xfs_repair");
> >  }
> >  
> > diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> > index 0b9c5ba8a598..f3b5564c2f4f 100644
> > --- a/fs/xfs/xfs_error.h
> > +++ b/fs/xfs/xfs_error.h
> > @@ -8,9 +8,9 @@
> >  
> >  struct xfs_mount;
> >  
> > -extern void xfs_error_report(const char *tag, int level, struct xfs_mount *mp,
> > -			const char *filename, int linenum,
> > -			xfs_failaddr_t failaddr);
> > +void xfs_error_report(const char *tag, int level, int error,
> > +		struct xfs_mount *mp, const char *filename,
> > +		int linenum, xfs_failaddr_t failaddr);
> >  extern void xfs_corruption_error(const char *tag, int level,
> >  			struct xfs_mount *mp, const void *buf, size_t bufsize,
> >  			const char *filename, int linenum,
> > @@ -25,8 +25,8 @@ extern void xfs_inode_verifier_error(struct xfs_inode *ip, int error,
> >  			const char *name, const void *buf, size_t bufsz,
> >  			xfs_failaddr_t failaddr);
> >  
> > -#define	XFS_ERROR_REPORT(e, lvl, mp)	\
> > -	xfs_error_report(e, lvl, mp, __FILE__, __LINE__, __return_address)
> > +#define	XFS_ERROR_REPORT(e, lvl, error, mp)	\
> > +	xfs_error_report(e, lvl, error, mp, __FILE__, __LINE__, __return_address)
> >  #define	XFS_CORRUPTION_ERROR(e, lvl, mp, buf, bufsize)	\
> >  	xfs_corruption_error(e, lvl, mp, buf, bufsize, \
> >  			     __FILE__, __LINE__, __return_address)
> > diff --git a/fs/xfs/xfs_exchmaps_item.c b/fs/xfs/xfs_exchmaps_item.c
> > index 264a121c5e16..2cbc1b9aee43 100644
> > --- a/fs/xfs/xfs_exchmaps_item.c
> > +++ b/fs/xfs/xfs_exchmaps_item.c
> > @@ -559,13 +559,15 @@ xlog_recover_xmi_commit_pass2(
> >  
> >  	len = sizeof(struct xfs_xmi_log_format);
> >  	if (item->ri_buf[0].i_len != len) {
> > -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> > +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> > +				 -EFSCORRUPTED, log->l_mp);
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> >  	xmi_formatp = item->ri_buf[0].i_addr;
> >  	if (xmi_formatp->__pad != 0) {
> > -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> > +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> > +				 -EFSCORRUPTED, log->l_mp);
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > @@ -600,7 +602,8 @@ xlog_recover_xmd_commit_pass2(
> >  
> >  	xmd_formatp = item->ri_buf[0].i_addr;
> >  	if (item->ri_buf[0].i_len != sizeof(struct xfs_xmd_log_format)) {
> > -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> > +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> > +				 -EFSCORRUPTED, log->l_mp);
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > index c6cb0b6b9e46..c361e02110a0 100644
> > --- a/fs/xfs/xfs_inode_item.c
> > +++ b/fs/xfs/xfs_inode_item.c
> > @@ -1185,7 +1185,8 @@ xfs_inode_item_format_convert(
> >  	struct xfs_inode_log_format_32	*in_f32 = buf->i_addr;
> >  
> >  	if (buf->i_len != sizeof(*in_f32)) {
> > -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
> > +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> > +				 -EFSCORRUPTED, NULL);
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 2f76531842f8..b1979d00d2e3 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -2932,7 +2932,8 @@ xlog_recover_process(
> >  		 * fatal log corruption failure.
> >  		 */
> >  		if (xfs_has_crc(log->l_mp)) {
> > -			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> > +			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> > +					 -EFSCORRUPTED, log->l_mp);
> >  			return -EFSCORRUPTED;
> >  		}
> >  	}
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index c6657072361a..792a67a7ec28 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -999,7 +999,7 @@ xfs_trans_cancel(
> >  	 * here.
> >  	 */
> >  	if (dirty && !xfs_is_shutdown(mp)) {
> > -		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, mp);
> > +		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, 0, mp);
> >  		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> >  	}
> >  #ifdef DEBUG
> > -- 
> > 2.55.0
> > 
> > 
> 
