Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C00E17F47
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2016 15:06:12 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B6154304059
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2016 13:06:09 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id HpJoISvJJViP6hOi (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Jan 2016 13:06:07 -0800 (PST)
Date: Fri, 15 Jan 2016 13:05:56 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: check sizes of XFS on-disk structures at compile time
Message-ID: <20160115210556.GC5757@birch.djwong.org>
References: <20160111232657.GA7831@birch.djwong.org>
	<56969696.2040206@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56969696.2040206@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Wed, Jan 13, 2016 at 12:25:26PM -0600, Eric Sandeen wrote:
> On 1/11/16 5:26 PM, Darrick J. Wong wrote:
> 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 36bd882..31b69d1 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1812,11 +1812,56 @@ xfs_destroy_workqueues(void)
> >  	destroy_workqueue(xfs_alloc_wq);
> >  }
> >  
> > +static void __init
> > +xfs_check_ondisk_structs(void)
> > +{
> > +	/* on-disk structures */
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,			264);
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_agf,			224);
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_agi,			336);
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_agfl,			36);
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_timestamp,		8);
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_dinode,		176);
> 
> I'm not sure why, but all this hard-coded stuff in the codebase bugs me.
> 
> What if we did it as part of the build, but outside the code, something
> like (pardon my bad Make-fu):
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index f646391..da9ec6d 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -122,3 +122,8 @@ xfs-$(CONFIG_XFS_POSIX_ACL) += xfs_acl.o
>  xfs-$(CONFIG_SYSCTL)           += xfs_sysctl.o
>  xfs-$(CONFIG_COMPAT)           += xfs_ioctl32.o
>  xfs-$(CONFIG_NFSD_PNFS)                += xfs_pnfs.o
> +
> +check_structures: $(obj)/xfs.o
> +       $(src)/scripts/check_structures.sh $(obj)/xfs.o
> +
> +$(obj)/built-in.o: check_structures
> 
> where the script executes pahole or whatever we want, to check the
> structure sizes and possibly even alignment explicitly?  Presumably
> we could make running the check a Kconfig option as well...

We certainly /could/ do that, but now the build depends on pahole or whatever
being installed, whereas this macroey doesn't add more tool dependencies.
I think between this and xfs/122 we're probably fine?

--D

> 
> similar tricks could surely be done for userspace as well.
> 
> -Eric
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
