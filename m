Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 03 Oct 2008 02:08:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9398P3g024914
	for <xfs@oss.sgi.com>; Fri, 3 Oct 2008 02:08:26 -0700
Date: Fri, 3 Oct 2008 05:10:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: TAKE 957103 - Merge up to 2.6.27-rc8
Message-ID: <20081003091001.GA11627@infradead.org>
References: <20081003031258.7886658C52B4@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003031258.7886658C52B4@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

So this patch now has made it out to the CVS on oss, but not the actual
update of the surrouding kernel tree.  Any chance to fix that before the
weekend so we'll actually have a tree the builds?

On Fri, Oct 03, 2008 at 01:12:58PM +1000, Lachlan McIlroy wrote:
> Merge up to 2.6.27-rc8
> 
> Date:  Fri Oct  3 12:16:52 AEST 2008
> Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-fresh
> Inspected by:  lachlan
> Author:  lachlan
> 
> The following file(s) were checked into:
>   longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb
> 
> 
> Modid:  xfs-linux-melb:xfs-kern:32254a
> fs/xfs/xfs_vnodeops.c - 1.775 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> xfs_vnodeops.c.diff?r1=text&tr1=1.775&r2=text&tr2=1.774&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.775&r2=text&tr2=1.774&f=h
> fs/xfs/xfs_inode.c - 1.525 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> xfs_inode.c.diff?r1=text&tr1=1.525&r2=text&tr2=1.524&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.525&r2=text&tr2=1.524&f=h
> fs/xfs/linux-2.6/xfs_lrw.c - 1.283 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> linux-2.6/xfs_lrw.c.diff?r1=text&tr1=1.283&r2=text&tr2=1.282&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.c.diff?r1=text&tr1=1.283&r2=text&tr2=1.282&f=h
> fs/xfs/linux-2.6/xfs_ioctl.c - 1.172 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.172&r2=text&tr2=1.171&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.172&r2=text&tr2=1.171&f=h
> fs/xfs/linux-2.6/xfs_linux.h - 1.171 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> linux-2.6/xfs_linux.h.diff?r1=text&tr1=1.171&r2=text&tr2=1.170&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_linux.h.diff?r1=text&tr1=1.171&r2=text&tr2=1.170&f=h
> fs/xfs/linux-2.6/xfs_super.c - 1.450 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> linux-2.6/xfs_super.c.diff?r1=text&tr1=1.450&r2=text&tr2=1.449&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.450&r2=text&tr2=1.449&f=h
> fs/xfs/linux-2.6/xfs_iops.c - 1.300 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.300&r2=text&tr2=1.299&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.300&r2=text&tr2=1.299&f=h
> fs/xfs/linux-2.6/xfs_aops.c - 1.165 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.165&r2=text&tr2=1.164&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.165&r2=text&tr2=1.164&f=h
> fs/xfs/linux-2.6/kmem.h - 1.48 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> linux-2.6/kmem.h.diff?r1=text&tr1=1.48&r2=text&tr2=1.47&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/kmem.h.diff?r1=text&tr1=1.48&r2=text&tr2=1.47&f=h
> 
> 
> 
---end quoted text---
