Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AE449B5B6
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 15:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789398510; cv=none; b=PU9uaR4LqKJRidRpdZx05hz655An2lbJ/U4R2qtfkUz1etioz3w9bULlNCB64U7d6ROWvDka4lP/2pbqiT7vM0CnsBRuMQunrNMte/VCH/K7nMpS6Ugj/2PSFr4h+qGXSqGRCme5jQAFqhT6HQzrR6bScbXpvjknZNoklPoq+yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789398510; c=relaxed/simple;
	bh=jafSAnu4eCDKccn60wVunrWFQNm/c1gK1kDit0xscjI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aBUnqaXyCisOWmNldL2CJ36TDJ3NBojZgkfdUCCmgpX2tyEoU/EAVJ/BtRZV+RS3KWoI9+EuzWh8iG50N9cgcueQjEcaL3FgFImuYE6nf8WCA4OuD54O5thuzdFVvSSLdiKNHLlreyRzGkIrHnpUDd6RUHE3SXBxGtCgJ1Swex0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cy0DSZr+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cy0DSZr+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5A74C1F00893;
	Mon, 14 Sep 2026 15:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398508;
	bh=jMXO4dZEj5lW3s5df/EwhNdcmui9MnxTJadfnLUfRfc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Cy0DSZr+NiRBYR9M/CW+UQdwsLzsvcFabWUup+Sn6rQFDCgytYkfQOpIME5JJonVQ
	 bkdGrMzGltB9Cqyy5/nOtA3lefWJS05L8+RfvJnL0YcrhXs/VmlCWylFltAXC3Riu7
	 TgLgrDMceTInVRokeLx9Fprs/RSWZFa7zj2zAET0pLLgprgzJrlUGyJw5A8D0wA3Qd
	 tL4hz9iwzc3Ucd+uIIIpebTwzX+xi0IJiCfZ6O6ro16rooPirDsrDWWSLGkCHiA4RU
	 UXi1BtZmL7xO+SgKAmMtbLgsR6i40/CbjAYDtd8+f3Ku1yml1DpbJ8Bgt8QL5/i1zS
	 ROzJf8/iD8bhg==
Date: Mon, 14 Sep 2026 08:08:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: hchc@last.de, sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/3] xfs: add xfs_error_report the ability to display
 an error code
Message-ID: <20260914150827.GP6265@frogsfrogsfrogs>
References: <20260914115746.82122-1-cem@kernel.org>
 <20260914115746.82122-2-cem@kernel.org>
 <20260914144224.GG6283@frogsfrogsfrogs>
 <aqgLft0IEhUocC8R@cronus.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqgLft0IEhUocC8R@cronus.toxiclabs.cc>

On Mon, Sep 14, 2026 at 05:00:51PM +0200, Carlos Maiolino wrote:
> On Mon, Sep 14, 2026 at 07:42:24AM -0700, Darrick J. Wong wrote:
> > On Mon, Sep 14, 2026 at 01:57:39PM +0200, cem@kernel.org wrote:
> > > From: Carlos Maiolino <cem@kernel.org>
> > > 
> > > Users could opt to request an error code to be printed now.
> > > This relies on errname() and CONFIG_SYMBOLIC_ERRNAME without requiring it
> > 
> > Eh?  No it doesn't...
> > 
> > > to be enabled.
> > > Report 'unkown error' If CONFIG_SYMBOLIC_ERRNAME is not enabled or the
> > > user passes 0 as an error.
> > > 
> > > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > > 
> > > ---
> > > V2:
> > > 	- Fix commit description s/_NAME/_ERRNAME
> > > 	- xfs_corruption_error should call xfs_error_report with
> > > 	  -EFSCORRUPTED
> > > 	- Modify xfs_error_report to only print out the error number if
> > > 	  it received an error from the caller.
> > > 	- Don't use errname() anymore.
> > 
> > ...right?
> 
> Of course I'd forget something... I'll fix that for next version...
> 
> 
> > 
> > >  fs/xfs/xfs_error.c         | 16 +++++++++++-----
> > >  fs/xfs/xfs_error.h         |  9 +++++----
> > >  fs/xfs/xfs_exchmaps_item.c |  9 ++++++---
> > >  fs/xfs/xfs_inode_item.c    |  3 ++-
> > >  fs/xfs/xfs_log_recover.c   |  3 ++-
> > >  fs/xfs/xfs_trans.c         |  2 +-
> > >  6 files changed, 27 insertions(+), 15 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> > > index 9ece70fd94ca..c943717f1dd7 100644
> > > --- a/fs/xfs/xfs_error.c
> > > +++ b/fs/xfs/xfs_error.c
> > > @@ -241,16 +241,21 @@ void
> > >  xfs_error_report(
> > >  	const char		*tag,
> > >  	int			level,
> > > +	int			error,
> > >  	struct xfs_mount	*mp,
> > >  	const char		*filename,
> > >  	int			linenum,
> > >  	xfs_failaddr_t		failaddr)
> > >  {
> > >  	if (level <= xfs_error_level) {
> > > -		xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
> > > -		"Internal error %s at line %d of file %s.  Caller %pS",
> > > -			    tag, linenum, filename, failaddr);
> > > -
> > > +		if (error)
> > > +			xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
> > > +"Internal error %s (%d) at line %d of file %s.  Caller %pS",
> > > +				tag, error, linenum, filename, failaddr);
> > > +		else
> > > +			xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
> > > +"Internal error %s at line %d of file %s.  Caller %pS",
> > > +				tag, linenum, filename, failaddr);
> > 
> > /me wonders if we should add a tracepoint to these error reporting
> > functions so that one isn't totally reliant on scraping dmesg, but maybe
> > adding fserror_report_metadata is more appropriate for that?  Will have
> > to ruminate on that for a while.
> 
> Hmmm, what you think about controlling with the tracepoint? Spitting out
> the error? *If* that's the case, the problem I see is when users hit the
> error we can't enable a tracepoint on a past error :P so I'd rather have
> it logged in dmesg without needing to rely on having tracepoints enabled
> or not.
> 
> Or perhaps I missed your point here?

I wasn't going to delete anything out of these functions, just add a new
fserror_report_metadata() call.  dmesg scraping would continue working
as it always has, but now a monitoring program could watch for events
via fsnotify.

--D

> > 
> > In the meantime, this patch looks fine to me,
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> Thanks!
> 
> 
> > 
> > --D
> > 
> > >  		xfs_stack_trace();
> > >  	}
> > >  }
> > > @@ -268,7 +273,8 @@ xfs_corruption_error(
> > >  {
> > >  	if (buf && level <= xfs_error_level)
> > >  		xfs_hex_dump(buf, bufsize);
> > > -	xfs_error_report(tag, level, mp, filename, linenum, failaddr);
> > > +	xfs_error_report(tag, level, -EFSCORRUPTED, mp,
> > > +			 filename, linenum, failaddr);
> > >  	xfs_alert(mp, "Corruption detected. Unmount and run xfs_repair");
> > >  }
> > >  
> > > diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> > > index 05fc1d1cf521..3c76d0dad51c 100644
> > > --- a/fs/xfs/xfs_error.h
> > > +++ b/fs/xfs/xfs_error.h
> > > @@ -8,8 +8,9 @@
> > >  
> > >  struct xfs_mount;
> > >  
> > > -void xfs_error_report(const char *tag, int level, struct xfs_mount *mp,
> > > -		const char *filename, int linenum, xfs_failaddr_t failaddr);
> > > +void xfs_error_report(const char *tag, int level, int error,
> > > +		struct xfs_mount *mp, const char *filename,
> > > +		int linenum, xfs_failaddr_t failaddr);
> > >  void xfs_corruption_error(const char *tag, int level, struct xfs_mount *mp,
> > >  		const void *buf, size_t bufsize, const char *filename,
> > >  		int linenum, xfs_failaddr_t failaddr);
> > > @@ -20,8 +21,8 @@ void xfs_verifier_error(struct xfs_buf *bp, int error, xfs_failaddr_t failaddr);
> > >  void xfs_inode_verifier_error(struct xfs_inode *ip, int error, const char *name,
> > >  		const void *buf, size_t bufsz, xfs_failaddr_t failaddr);
> > >  
> > > -#define	XFS_ERROR_REPORT(e, lvl, mp)	\
> > > -	xfs_error_report(e, lvl, mp, __FILE__, __LINE__, __return_address)
> > > +#define	XFS_ERROR_REPORT(e, lvl, error, mp)	\
> > > +	xfs_error_report(e, lvl, error, mp, __FILE__, __LINE__, __return_address)
> > >  #define	XFS_CORRUPTION_ERROR(e, lvl, mp, buf, bufsize)	\
> > >  	xfs_corruption_error(e, lvl, mp, buf, bufsize, \
> > >  			     __FILE__, __LINE__, __return_address)
> > > diff --git a/fs/xfs/xfs_exchmaps_item.c b/fs/xfs/xfs_exchmaps_item.c
> > > index dd5d92ca1010..9f499a80038c 100644
> > > --- a/fs/xfs/xfs_exchmaps_item.c
> > > +++ b/fs/xfs/xfs_exchmaps_item.c
> > > @@ -573,13 +573,15 @@ xlog_recover_xmi_commit_pass2(
> > >  
> > >  	len = sizeof(struct xfs_xmi_log_format);
> > >  	if (item->ri_buf[0].iov_len != len) {
> > > -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> > > +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> > > +				 -EFSCORRUPTED, log->l_mp);
> > >  		return -EFSCORRUPTED;
> > >  	}
> > >  
> > >  	xmi_formatp = item->ri_buf[0].iov_base;
> > >  	if (xmi_formatp->__pad != 0) {
> > > -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> > > +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> > > +				 -EFSCORRUPTED, log->l_mp);
> > >  		return -EFSCORRUPTED;
> > >  	}
> > >  
> > > @@ -614,7 +616,8 @@ xlog_recover_xmd_commit_pass2(
> > >  
> > >  	xmd_formatp = item->ri_buf[0].iov_base;
> > >  	if (item->ri_buf[0].iov_len != sizeof(struct xfs_xmd_log_format)) {
> > > -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> > > +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> > > +				 -EFSCORRUPTED, log->l_mp);
> > >  		return -EFSCORRUPTED;
> > >  	}
> > >  
> > > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > > index 99d6ecccdaa7..a29c90f0650f 100644
> > > --- a/fs/xfs/xfs_inode_item.c
> > > +++ b/fs/xfs/xfs_inode_item.c
> > > @@ -1229,7 +1229,8 @@ xfs_inode_item_format_convert(
> > >  	struct xfs_inode_log_format_32	*in_f32 = buf->iov_base;
> > >  
> > >  	if (buf->iov_len != sizeof(*in_f32)) {
> > > -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
> > > +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> > > +				 -EFSCORRUPTED, NULL);
> > >  		return -EFSCORRUPTED;
> > >  	}
> > >  
> > > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > > index e7e49529658b..e92afc455d0f 100644
> > > --- a/fs/xfs/xfs_log_recover.c
> > > +++ b/fs/xfs/xfs_log_recover.c
> > > @@ -2945,7 +2945,8 @@ xlog_recover_process(
> > >  		 * fatal log corruption failure.
> > >  		 */
> > >  		if (xfs_has_crc(log->l_mp)) {
> > > -			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> > > +			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> > > +					 -EFSCORRUPTED, log->l_mp);
> > >  			return -EFSCORRUPTED;
> > >  		}
> > >  	}
> > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > index 1b36cf12d4e3..5c522790e5be 100644
> > > --- a/fs/xfs/xfs_trans.c
> > > +++ b/fs/xfs/xfs_trans.c
> > > @@ -971,7 +971,7 @@ xfs_trans_cancel(
> > >  	 * here.
> > >  	 */
> > >  	if (dirty && !xfs_is_shutdown(mp)) {
> > > -		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, mp);
> > > +		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, 0, mp);
> > >  		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > >  	}
> > >  #ifdef DEBUG
> > > -- 
> > > 2.55.0
> > > 
> > 
> 
