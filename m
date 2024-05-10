Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1721607B2
	for <linux-xfs@vger.kernel.org>; Fri, 10 May 2024 09:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715334391; cv=none; b=qS5123mxRT3MilFLsagtXX8I9JOdWfliLAXx/d/S/5vSbXn/bxMJccdJH82CAOWkXBu9lAQiTIyHmSu4fQghqLLGsinCwFokqJdgdyxu1/0ytO95lFNcIESlNYRgM/VjtxtEb8PDHe2FzuTwFnYl3qZEr3/ckubkezPS9Fdkjp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715334391; c=relaxed/simple;
	bh=zC5VuS0qb40AMyX1gyyzJJxL7lB5fWWGgZqzLcviLQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LaBR/ZsFZFywkfDZJbCl8AuHYfJwdDNIe+C3fYmt3E47BbeVEOguia71NdryDeFnJ8VQsdrcb6wTICg5wM7TdyyQV6vbqef91prMSPnGF4eP+LnD3V5lgMWwstVOIFoS+s/3c57vuHSblDB2bY79C5zB874e6MTnWp0daDRaRZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mvj1AftU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mvj1AftU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715334388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jsi8ho13cxKhTMKRCNnyenLmKonKZOtRFXCo/7DgJhk=;
	b=Mvj1AftU9cx/hyC8Nr8uoOqn8iEJzbDa0Qya9y8pRysD+YLvelanyNrYAQ6kvTo/ixk8gk
	xi1jGkDZX7kHMX8xP87ZVF0gJE5tXcH0g/blw6VzkmuEEFuGXXzP6iVckPaNUTsa+ctGRG
	zIEEtUYnUKySd0Xdpk+nnaljhCm/iTg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-cj9_cc-PNOutXi2Ezf9Ldw-1; Fri, 10 May 2024 05:46:26 -0400
X-MC-Unique: cj9_cc-PNOutXi2Ezf9Ldw-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5729fd97df9so623509a12.1
        for <linux-xfs@vger.kernel.org>; Fri, 10 May 2024 02:46:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715334385; x=1715939185;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jsi8ho13cxKhTMKRCNnyenLmKonKZOtRFXCo/7DgJhk=;
        b=EugS4r/9AeMFMVV9jxqmClgnGIZLhmBFI3WBvcU1eCaTTzBMIHLLb3jiv5IacbrKgS
         srWKEFbVOC53VPyNQwJj21qeSmSb4gImjTatr451HxXEAkuZpCsM2B/TNeHyIwOJBD1g
         VnxAtMq2Vs3cd5o9eekko37HmfBsUYumbBG28eU/KABaLePv7x2dfTksCLkqlhHuYw4M
         XfJweBgPoF90RRkrVDDgwXAYptn9/ndsRzpiAitl5n5irsTW3OJFVzeblLyu2QKvIpQF
         0b7OfnDAhiko/+fqi4r6AFg7uAjzgzqdVwDyq6XMeo0ipVRGi1QXBIbrx3ItMlII97Nt
         pfSg==
X-Forwarded-Encrypted: i=1; AJvYcCWhflvo+UoeKM7jhSh32Xk4+B8Kcq/caxwvZNPwO9/OFTwbqk8CHBxsz69qF/EjKpWALyrUB67KaKVpBujkdDHj3FrBDjaIV7eJ
X-Gm-Message-State: AOJu0YwWXNx6HapWPTzoWPBuxJWMDZKDn6FvRdLJt7rKDSoXU0xwu/yB
	0FRA+utbSX3pJUjxZEEJ32KjF7X2OWnX2hg9kr7kXZxRQIq6F8sfFdFzg65+ShiiXg+9gYXgm6t
	To8QLgZqEMbV1zaH60nLJ6jY6/9iBTTCZ/+sOzsFLESKMacRFJN/kKIMV+PVZqxK7
X-Received: by 2002:a50:8711:0:b0:572:7015:f303 with SMTP id 4fb4d7f45d1cf-5734d6f00d7mr1721845a12.35.1715334385336;
        Fri, 10 May 2024 02:46:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFqCVRG8En3jxPPsOIXBYXxbW7zCFYdTR95BwYEb+SvA8nRVmklMRwvTbF9bY0UG+17VdiYmw==
X-Received: by 2002:a50:8711:0:b0:572:7015:f303 with SMTP id 4fb4d7f45d1cf-5734d6f00d7mr1721818a12.35.1715334384772;
        Fri, 10 May 2024 02:46:24 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5733c323887sm1647447a12.89.2024.05.10.02.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 May 2024 02:46:24 -0700 (PDT)
Date: Fri, 10 May 2024 11:46:23 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel@vgre.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: allow setting xattrs on special files
Message-ID: <vrq2zxtotlglhyvr7wictlwgwefy7s2hb5nwksd4ii7kdohrfe@u2l5fvzki7mt>
References: <20240509151459.3622910-2-aalbersh@redhat.com>
 <20240509151459.3622910-5-aalbersh@redhat.com>
 <20240509233406.GT360919@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240509233406.GT360919@frogsfrogsfrogs>

On 2024-05-09 16:34:06, Darrick J. Wong wrote:
> On Thu, May 09, 2024 at 05:14:59PM +0200, Andrey Albershteyn wrote:
> > As XFS didn't have ioctls for special files setting an inode
> > extended attributes was rejected for them in xfs_fileattr_set().
> > Same applies for reading.
> > 
> > With XFS's project quota directories this is necessary. When project
> > is setup, xfs_quota opens and calls FS_IOC_SETFSXATTR on every inode
> > in the directory. However, special files are skipped due to open()
> > returning a special inode for them. So, they don't even get to this
> > check.
> > 
> > The further patch introduces XFS_IOC_SETFSXATTRAT which will call
> > xfs_fileattr_set/get() on a special file. This patch add handling of
> > setting xflags and project ID for special files.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > ---
> >  fs/xfs/xfs_ioctl.c | 96 ++++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 92 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index f0117188f302..515c9b4b862d 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -459,9 +459,6 @@ xfs_fileattr_get(
> >  {
> >  	struct xfs_inode	*ip = XFS_I(d_inode(dentry));
> >  
> > -	if (d_is_special(dentry))
> > -		return -ENOTTY;
> > -
> >  	xfs_ilock(ip, XFS_ILOCK_SHARED);
> >  	xfs_fill_fsxattr(ip, XFS_DATA_FORK, fa);
> >  	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> > @@ -721,6 +718,97 @@ xfs_ioctl_setattr_check_projid(
> >  	return 0;
> >  }
> >  
> > +static int
> > +xfs_fileattr_spec_set(
> > +	struct mnt_idmap	*idmap,
> > +	struct dentry		*dentry,
> > +	struct fileattr		*fa)
> > +{
> > +	struct xfs_inode *ip = XFS_I(d_inode(dentry));
> > +	struct xfs_mount *mp = ip->i_mount;
> > +	struct xfs_trans *tp;
> > +	struct xfs_dquot *pdqp = NULL;
> > +	struct xfs_dquot *olddquot = NULL;
> > +	int error;
> > +
> > +	if (!fa->fsx_valid)
> > +		return -EOPNOTSUPP;
> > +
> > +	if (fa->fsx_extsize ||
> > +	    fa->fsx_nextents ||
> > +	    fa->fsx_cowextsize)
> > +		return -EOPNOTSUPP;
> > +
> > +	error = xfs_ioctl_setattr_check_projid(ip, fa);
> > +	if (error)
> > +		return error;
> > +
> > +	/*
> > +	 * If disk quotas is on, we make sure that the dquots do exist on disk,
> > +	 * before we start any other transactions. Trying to do this later
> > +	 * is messy. We don't care to take a readlock to look at the ids
> > +	 * in inode here, because we can't hold it across the trans_reserve.
> > +	 * If the IDs do change before we take the ilock, we're covered
> > +	 * because the i_*dquot fields will get updated anyway.
> > +	 */
> > +	if (fa->fsx_valid && XFS_IS_QUOTA_ON(mp)) {
> 
> Didn't we already check fsx_valid?

oh, right

> 
> Also, what's different about the behavior of setxattr on special files
> (vs. directories and regular files) such that we need a separate function?
> Is it to disable the ability to set the extent size hints or the xflags?

yes, that's it, and the function looks a bit easier to follow for me
here

> 
> --D
> 
> > +		error = xfs_qm_vop_dqalloc(ip, VFS_I(ip)->i_uid,
> > +					   VFS_I(ip)->i_gid, fa->fsx_projid,
> > +					   XFS_QMOPT_PQUOTA, NULL, NULL, &pdqp);
> > +		if (error)
> > +			return error;
> > +	}
> > +
> > +	tp = xfs_ioctl_setattr_get_trans(ip, pdqp);
> > +	if (IS_ERR(tp)) {
> > +		error = PTR_ERR(tp);
> > +		goto error_free_dquots;
> > +	}
> > +
> > +	error = xfs_ioctl_setattr_xflags(tp, ip, fa);
> > +	if (error)
> > +		goto error_trans_cancel;
> > +
> > +	/*
> > +	 * Change file ownership.  Must be the owner or privileged.  CAP_FSETID
> > +	 * overrides the following restrictions:
> > +	 *
> > +	 * The set-user-ID and set-group-ID bits of a file will be cleared upon
> > +	 * successful return from chown()
> > +	 */
> > +
> > +	if ((VFS_I(ip)->i_mode & (S_ISUID | S_ISGID)) &&
> > +	    !capable_wrt_inode_uidgid(idmap, VFS_I(ip), CAP_FSETID))
> > +		VFS_I(ip)->i_mode &= ~(S_ISUID | S_ISGID);
> > +
> > +	/* Change the ownerships and register project quota modifications */
> > +	if (ip->i_projid != fa->fsx_projid) {
> > +		if (XFS_IS_PQUOTA_ON(mp)) {
> > +			olddquot =
> > +				xfs_qm_vop_chown(tp, ip, &ip->i_pdquot, pdqp);
> > +		}
> > +		ip->i_projid = fa->fsx_projid;
> > +	}
> > +
> > +	error = xfs_trans_commit(tp);
> > +
> > +	/*
> > +	 * Release any dquot(s) the inode had kept before chown.
> > +	 */
> > +	xfs_qm_dqrele(olddquot);
> > +	xfs_qm_dqrele(pdqp);
> > +
> > +	return error;
> > +
> > +error_trans_cancel:
> > +	xfs_trans_cancel(tp);
> > +error_free_dquots:
> > +	xfs_qm_dqrele(pdqp);
> > +	return error;
> > +
> > +	return 0;
> > +}
> > +
> >  int
> >  xfs_fileattr_set(
> >  	struct mnt_idmap	*idmap,
> > @@ -737,7 +825,7 @@ xfs_fileattr_set(
> >  	trace_xfs_ioctl_setattr(ip);
> >  
> >  	if (d_is_special(dentry))
> > -		return -ENOTTY;
> > +		return xfs_fileattr_spec_set(idmap, dentry, fa);
> >  
> >  	if (!fa->fsx_valid) {
> >  		if (fa->flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL |
> > -- 
> > 2.42.0
> > 
> > 
> 

-- 
- Andrey

