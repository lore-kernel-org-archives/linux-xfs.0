Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5U73a2E188021 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 02:03:36 -0500
Date: Thu, 30 Jun 2011 03:03:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/27] xfs: split xfs_setattr
Message-ID: <20110630070333.GC10893@infradead.org>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140337.641422449@bombadil.infradead.org>
	<1309385596.8649.36.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1309385596.8649.36.camel@doink>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jun 29, 2011 at 05:13:16PM -0500, Alex Elder wrote:
> Looks good but I think that you need to mask off the
> ia_valid bits in the calls now made in xfs_vn_setattr().

Why? We call xfs_setattr_size if ATTR_SIZE is set.  The ATTR_SIZE
may also have a few other attributes we can handle, and assert on
those that it can't just to make sure.  Similarly xfs_setattr_nonsize
can handle everything but ATTR_SIZE, and again we have an assert to
protect against breeding incorrect XFS-internal callers.

> Also, I think you may still need to check the file type
> for the size-setting function.  Details below.

The VFS only ever does an ATTR_SIZE setattr on regular files.  We have
an assert to ensure that for debug builds, which is a lot more than
most other filesystems do.

> > +	ASSERT((mask & (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
> > +			ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID|
> > +			ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
> 
> You'll have to mask these off in xfs_vn_setattr() if you're
> going to make this assertion.

No, this is the (implicit) calling convention by the VFS.

> > -		if (S_ISDIR(ip->i_d.di_mode)) {
> > -			code = XFS_ERROR(EISDIR);
> > -			goto error_return;
> > -		} else if (!S_ISREG(ip->i_d.di_mode)) {
> > -			code = XFS_ERROR(EINVAL);
> > -			goto error_return;
> > -		}
> 
> This is the file type checking code I referred to above.

It simply was a leftover from IRIX that we can't hit on Linux.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
