Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359A1470453
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 17:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789149536; cv=none; b=op0yxOf3fV2PjJQR7JnBOhTrLWu+J1ZeqWRsishae8BBivuwBYOizLzkXArdUzK/2t1M0V777cYo8aqz1LGhreWCBLH7NgPJIzT04ZJ0Vhr+Ju9MoVP9ww2ERwvzB17i+KiRHZKzn1L5PBOz/SokvY3iKgQiH8vWVaf25zfeDWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789149536; c=relaxed/simple;
	bh=UmT8OHpBlvJBptQHbQ2eR2GcBs3yO0jwfuh/OTVwptU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ddJ3MbS2mwtEe9J6VgA2RogjDPi6uI5Ob1kIOzDQqfTHObmNV7zn9u6FJgz8n/PZ8P34M4VK/PgeF2O3xd08adWWTAkWEWr1XSWDVMb9VbmJyulFngC5Zjgdd+wW2jJwlvWe7FkKrh0blyEI2p7AkIW7sBSlEzNup+9OnISZHLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RXV7qhWi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RXV7qhWi"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B76341F00893;
	Fri, 11 Sep 2026 17:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789149534;
	bh=rERj60ksCqborNb8L5J+LyDQiwA9+NU1J+DclrjenlM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RXV7qhWiAAjzSXHs6CcKbYQsuQHn6FSsJOGFU6dYRzzisADiBgmKrwj6lvtLuhTMi
	 EiYQ+FnDZ3SXsxv4vPdLT/7o971i7s65g87zApHvSCJAzxEm92rP3h3eqq5EgiS34e
	 bLLZKbxvSbPXgPUVU4ZLN7pIEnKQ2uHDU2uhIHQ9J/UppGSH+SHUP21E3XWLMCD38Y
	 DhMoI1RsLYzV8juzAcFvBO454pOHEeZse6nO+6K5lkzp7eqVksJc8CmeHwZnRWZ+kX
	 qwLJsQrhCKBMFBUhLZ9MI5dO9DmpeK1C/q9/vCr2ToGpd7DaOJqWNkvYfhxSk1k8BN
	 QB/EEH6wTOl1w==
Date: Fri, 11 Sep 2026 10:58:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] makecfg: handle metadir quota options
Message-ID: <20260911175854.GL6265@frogsfrogsfrogs>
References: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
 <178892910621.4047311.16295302909903460048.stgit@frogsfrogsfrogs>
 <aqQi1BNvhModkvb1@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqQi1BNvhModkvb1@infradead.org>

On Fri, Sep 11, 2026 at 08:48:36AM -0700, Christoph Hellwig wrote:
> On Tue, Sep 08, 2026 at 11:01:33PM -0700, Darrick J. Wong wrote:
> >  
> > +/* These should correspond to XFS_[UGP]UOTA_{ACCT,ENFD} */
> 
> CAn we reuse those?  If not at least add the missing Q in QUOTA here :)

Oh!  Yes, we can just reuse them since xfs_log_format.h is in
/usr/include/xfs/.  Well that simplifies things a lot.

> > diff --git a/configure.ac b/configure.ac
> > index 40ccd88aa2a950..8a2505e37c70ab 100644
> > --- a/configure.ac
> > +++ b/configure.ac
> > @@ -195,6 +195,7 @@ if test "$have_listmount" = "yes"; then
> >  fi
> >  AC_HAVE_STATMOUNT_SUPPORTED_MASK
> >  AC_HAVE_FANOTIFY_MOUNTINFO
> > +AC_HAVE_QUOTACTL_FD
> 
> Shouldn't the AC_HAVE_QUOTACTL_FD go into a separate patch, including
> a generic helper?  I assume most other uqotactl users would prefer
> that as well when available.

Yes.  I could hoist xfsquotactl from quota/linux.c into libfrog, and
then adapt it to use quotactl_fd if available:

int
xfsquotactl(
	int			mnt_fd,
	const char		*device,
	enum xfs_quota_cmd	xcommand,
	uint			xtype,
	uint			id,
	void			*addr)
{
	const int		op = QCMD(xcommand_to_qcommand(xcommand),
					  xtype_to_qtype(xtype));
	int			ret = -1;

	errno = ENOSYS;
#ifdef HAVE_QUOTACTL_FD
	if (mnt_fd >= 0)
		ret = syscall(SYS_quotactl_fd, mnt_fd, op, id, addr);
#endif
	if (ret != -1 || errno != ENOSYS)
		return ret;

	return quotactl(op, device, id, addr);
}

This will require some amount of refactoring in xfs_quota, since it
doesn't currently try to open() the filesystem mountpoint.  OTOH now it
will no longer fail if a sysadmin does an lvrename while it's running.

However, doing all that got intense, so I'm splitting all that out into
a separate hoist/cleanup/adapt series.  For now, the get_qflags function
in spaceman will look like this:

	/* GETQSTAT returns qflags for all quota types, not just user */
	ret = quotactl(QCMD(Q_XGETQSTAT, USRQUOTA), f->fs_path.fs_name, 0,
			(void *)&qstat);

until the new series ports it to xfsquotactl.

> Otherwise this looks good from a quick look.

--D
