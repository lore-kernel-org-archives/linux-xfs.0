Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34532 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfBVT2s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Feb 2019 14:28:48 -0500
Date: Fri, 22 Feb 2019 11:28:36 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/4] xfs_restore: refactor open-coded file creation code
Message-ID: <20190222192836.GB21626@magnolia>
References: <155085403848.5141.1866278990901950186.stgit@magnolia>
 <155085404462.5141.11851529133557195388.stgit@magnolia>
 <20190222192053.GF15048@tuebingen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190222192053.GF15048@tuebingen.mpg.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andre Noll <maan@tuebingen.mpg.de>
Cc: linux-xfs@vger.kernel.org

On Fri, Feb 22, 2019 at 08:20:53PM +0100, Andre Noll wrote:
> On Fri, Feb 22, 08:47, Darrick J. Wong wrote
> > +	ret = ioctl(fd, XFS_IOC_RESVSP64, &fl);
> > +	if (ret && errno != ENOTTY)
> > +		mlog(MLOG_VERBOSE | MLOG_NOTE,
> > +_("attempt to reserve %lld bytes for %s using %s failed: %s (%d)\n"),
> > +				size, pathname, "XFS_IOC_RESVSP64",
> > +				strerror(errno), errno);
> 
> The "XFS_IOC_RESVSP64" string literal can be included in the format string.

I was trying not to force an update of the i18n message catalogs.

> > +	if (ret == 0)
> > +		goto done;
> > +
> > +done:
> 
> LOL

Yes, it's silly, but gcc will complain if the label doesn't get
used, which it won't if you apply the rest of the series and build
xfsdump on a system that (somehow) doesn't know about fallocate.

> > +	return fd;
> 
> If you really want to return success even if the ioctl() failed, this might
> deserve a comment.

That's what the old code did, hence "try" in "try to reserve space" in
the comment describing what this function does.

--D

> 
> Andre
> -- 
> Max Planck Institute for Developmental Biology
> Max-Planck-Ring 5, 72076 Tübingen, Germany. Phone: (+49) 7071 601 829
> http://people.tuebingen.mpg.de/maan/
