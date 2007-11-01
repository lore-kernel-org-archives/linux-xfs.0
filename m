Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Nov 2007 15:47:53 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA1MlkaL017277
	for <xfs@oss.sgi.com>; Thu, 1 Nov 2007 15:47:48 -0700
Date: Fri, 2 Nov 2007 09:47:44 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Implement fallocate
Message-ID: <20071101224744.GE995458@sgi.com>
References: <20071029233841.GT995458@sgi.com> <472928C1.5080707@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <472928C1.5080707@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, xfs-dev@sgi.com

On Thu, Nov 01, 2007 at 12:15:45PM +1100, Lachlan McIlroy wrote:
> >+	xfs_ilock(XFS_I(inode), XFS_IOLOCK_EXCL);
> >+	error = xfs_change_file_space(XFS_I(inode), XFS_IOC_RESVSP, &bf,
> >+						0, NULL, ATTR_NOLOCK);
> >+	if (!error && !(mode & FALLOC_FL_KEEP_SIZE) &&
> >+	    offset + len > i_size_read(inode))
> >+		new_size = offset + len;
> >+
> >+	/* Change file size if needed */
> >+	if (new_size) {
> >+		bhv_vattr_t	va;
> >+
> >+		va.va_mask = XFS_AT_SIZE;
> >+		va.va_size = new_size;
> >+		error = xfs_setattr(XFS_I(inode), &va, ATTR_NOLOCK, NULL);
> >+	}
> 
> Is it necessary to call xfs_setattr() here?  Could we just do an explicit
> call to xfs_zero_eof(), set the new size, set i_update_core/size and mark
> the inode dirty?  Hmmm, then again, that approach wouldn't be as clean as
> above.

And it also violates the atomicity that posix_fallocate is supposed
to provide. i.e. if it returns success, the change of file size must
be permanent. i.e. the change of size needs to be recorded in a
transaction. Hence we need to call xfs_setattr....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
