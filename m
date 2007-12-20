Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Dec 2007 15:45:30 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBJNjPxJ032165
	for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 15:45:27 -0800
Received: from ogre.sisk.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 52D234A1D72
	for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 15:45:33 -0800 (PST)
Received: from ogre.sisk.pl (ogre.sisk.pl [217.79.144.158]) by cuda.sgi.com with ESMTP id ZUuNmEGSWMwJjA8d for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 15:45:33 -0800 (PST)
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: xfs mknod regression
Date: Thu, 20 Dec 2007 01:04:49 +0100
References: <dda83e780712172048n4d40cfcbw4a4d3106fc99f02e@mail.gmail.com> <20071218173642.GA7338@infradead.org> <20071219003745.GR4396912@sgi.com>
In-Reply-To: <20071219003745.GR4396912@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200104.50252.rjw@sisk.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Bret Towe <magnade@gmail.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wednesday, 19 of December 2007, David Chinner wrote:
> On Tue, Dec 18, 2007 at 05:36:42PM +0000, Christoph Hellwig wrote:
> > 
> > This was broken by my '[XFS] simplify xfs_create/mknod/symlink prototype',
> > which assigned the re-shuffled ondisk dev_t back to the rdev variable in
> > xfs_vn_mknod.  Because of that i_rdev is set to the ondisk dev_t instead
> > of the linux dev_t later down the function.
> > 
> > Fortunately the fix for it is trivial:  we can just remove the
> > assignment because xfs_revalidate_inode has done the proper job before
> > unlocking the inode.
> > 
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
> > ===================================================================
> > --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-12-18 18:23:32.000000000 +0100
> > +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2007-12-18 18:23:43.000000000 +0100
> > @@ -345,9 +345,7 @@ xfs_vn_mknod(
> >  		ASSERT(vp);
> >  		ip = vn_to_inode(vp);
> >  
> > -		if (S_ISCHR(mode) || S_ISBLK(mode))
> > -			ip->i_rdev = rdev;
> > -		else if (S_ISDIR(mode))
> > +		if (S_ISDIR(mode))
> >  			xfs_validate_fields(ip);
> >  		d_instantiate(dentry, ip);
> >  		xfs_validate_fields(dir);
> 
> Thanks for this, Christoph - I'll run some tests on it and check it in.
> 
> Rafael - this is a regression introduced in 2.6.24-rc1 if you want to
> track it.

I do, thanks.

Added to the list, http://bugzilla.kernel.org/show_bug.cgi?id=9608 .
I'll close it when the fix is upstream.

Thanks,
Rafael
