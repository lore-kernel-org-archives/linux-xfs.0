Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37232 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbfFXSAE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 14:00:04 -0400
Date: Mon, 24 Jun 2019 10:59:31 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/10] xfs: mount-api - add fs parameter description
Message-ID: <20190624175931.GZ5387@magnolia>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156134510205.2519.16185588460828778620.stgit@fedora-28>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ian Kent <raven@themaw.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, David Howells <dhowells@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>

On Mon, Jun 24, 2019 at 10:58:22AM +0800, Ian Kent wrote:
> The new mount-api uses an array of struct fs_parameter_spec for
> parameter parsing, create this table populated with the xfs mount
> parameters.
> 
> The new mount-api table definition is wider than the token based
> parameter table and interleaving the option description comments
> between each table line is much less readable than adding them to
> the end of each table entry. So add the option description comment
> to each entry line even though it causes quite a few of the entries
> to be longer than 80 characters.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_super.c |   48 +++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 45 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index a14d11d78bd8..ab8145bf6fff 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -51,6 +51,8 @@
>  #include <linux/kthread.h>
>  #include <linux/freezer.h>
>  #include <linux/parser.h>
> +#include <linux/fs_context.h>
> +#include <linux/fs_parser.h>
>  
>  static const struct super_operations xfs_super_operations;
>  struct bio_set xfs_ioend_bioset;
> @@ -60,9 +62,6 @@ static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
>  static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
>  #endif
>  
> -/*
> - * Table driven mount option parser.
> - */
>  enum {
>  	Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev, Opt_biosize,
>  	Opt_wsync, Opt_noalign, Opt_swalloc, Opt_sunit, Opt_swidth, Opt_nouuid,
> @@ -122,6 +121,49 @@ static const match_table_t tokens = {
>  	{Opt_err,	NULL},
>  };
>  
> +static const struct fs_parameter_spec xfs_param_specs[] = {
> + fsparam_u32	("logbufs",    Opt_logbufs),   /* number of XFS log buffers */
> + fsparam_string ("logbsize",   Opt_logbsize),  /* size of XFS log buffers */
> + fsparam_string ("logdev",     Opt_logdev),    /* log device */
> + fsparam_string ("rtdev",      Opt_rtdev),     /* realtime I/O device */
> + fsparam_u32	("biosize",    Opt_biosize),   /* log2 of preferred buffered io size */
> + fsparam_flag	("wsync",      Opt_wsync),     /* safe-mode nfs compatible mount */
> + fsparam_flag	("noalign",    Opt_noalign),   /* turn off stripe alignment */
> + fsparam_flag	("swalloc",    Opt_swalloc),   /* turn on stripe width allocation */
> + fsparam_u32	("sunit",      Opt_sunit),     /* data volume stripe unit */
> + fsparam_u32	("swidth",     Opt_swidth),    /* data volume stripe width */
> + fsparam_flag	("nouuid",     Opt_nouuid),    /* ignore filesystem UUID */
> + fsparam_flag_no("grpid",      Opt_grpid),     /* group-ID from parent directory (or not) */
> + fsparam_flag	("bsdgroups",  Opt_bsdgroups), /* group-ID from parent directory */
> + fsparam_flag	("sysvgroups", Opt_sysvgroups),/* group-ID from current process */
> + fsparam_string ("allocsize",  Opt_allocsize), /* preferred allocation size */
> + fsparam_flag	("norecovery", Opt_norecovery),/* don't run XFS recovery */
> + fsparam_flag	("inode64",    Opt_inode64),   /* inodes can be allocated anywhere */
> + fsparam_flag	("inode32",    Opt_inode32),   /* inode allocation limited to XFS_MAXINUMBER_32 */
> + fsparam_flag_no("ikeep",      Opt_ikeep),     /* do not free (or keep) empty inode clusters */
> + fsparam_flag_no("largeio",    Opt_largeio),   /* report (or do not report) large I/O sizes in stat() */
> + fsparam_flag_no("attr2",      Opt_attr2),     /* do (or do not) use attr2 attribute format */
> + fsparam_flag	("filestreams",Opt_filestreams), /* use filestreams allocator */
> + fsparam_flag_no("quota",      Opt_quota),     /* disk quotas (user) */
> + fsparam_flag	("usrquota",   Opt_usrquota),  /* user quota enabled */
> + fsparam_flag	("grpquota",   Opt_grpquota),  /* group quota enabled */
> + fsparam_flag	("prjquota",   Opt_prjquota),  /* project quota enabled */
> + fsparam_flag	("uquota",     Opt_uquota),    /* user quota (IRIX variant) */
> + fsparam_flag	("gquota",     Opt_gquota),    /* group quota (IRIX variant) */
> + fsparam_flag	("pquota",     Opt_pquota),    /* project quota (IRIX variant) */
> + fsparam_flag	("uqnoenforce",Opt_uqnoenforce), /* user quota limit enforcement */
> + fsparam_flag	("gqnoenforce",Opt_gqnoenforce), /* group quota limit enforcement */
> + fsparam_flag	("pqnoenforce",Opt_pqnoenforce), /* project quota limit enforcement */
> + fsparam_flag	("qnoenforce", Opt_qnoenforce),  /* same as uqnoenforce */
> + fsparam_flag_no("discard",    Opt_discard),   /* Do (or do not) not discard unused blocks */
> + fsparam_flag	("dax",	       Opt_dax),       /* Enable direct access to bdev pages */
> + {}
> +};
> +
> +static const struct fs_parameter_description xfs_fs_parameters = {
> +	.name		= "xfs",
> +	.specs		= xfs_param_specs,
> +};
>  
>  STATIC int
>  suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)
> 
