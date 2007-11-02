Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Nov 2007 18:49:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA21n3ug011063
	for <xfs@oss.sgi.com>; Thu, 1 Nov 2007 18:49:07 -0700
Date: Fri, 2 Nov 2007 12:48:55 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] show all mount args in /proc/mounts
Message-ID: <20071102014855.GH995458@sgi.com>
References: <20071029233543.GQ995458@sgi.com> <20071030100617.GB23489@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030100617.GB23489@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, xfs-dev@sgi.com

On Tue, Oct 30, 2007 at 10:06:17AM +0000, Christoph Hellwig wrote:
> On Tue, Oct 30, 2007 at 10:35:43AM +1100, David Chinner wrote:
> > There are several mount options that don't show up in /proc/mounts.
> > Add them in and clean up the showargs code at the same time.
> 
> Looks good.  Care to submit a patch ontop of this to move all the mount
> option handling to xfs_super.c as it's entirely linux-specific in this
> form?

Sure. This what you mean?

-----

Mount option parsing is platform specific. Move it out of core code into
the platform specific superblock operation file.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/linux-2.6/xfs_super.c |  430 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_vfsops.c          |  430 -------------------------------------------
 fs/xfs/xfs_vfsops.h          |    3 
 3 files changed, 430 insertions(+), 433 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_super.c	2007-10-24 16:01:47.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c	2007-10-31 10:24:31.412771393 +1100
@@ -50,6 +50,7 @@
 #include "xfs_vnodeops.h"
 #include "xfs_vfsops.h"
 #include "xfs_version.h"
+#include "xfs_log_priv.h"
 
 #include <linux/namei.h>
 #include <linux/init.h>
@@ -88,6 +89,435 @@ xfs_args_allocate(
 	return args;
 }
 
+#define MNTOPT_LOGBUFS	"logbufs"	/* number of XFS log buffers */
+#define MNTOPT_LOGBSIZE	"logbsize"	/* size of XFS log buffers */
+#define MNTOPT_LOGDEV	"logdev"	/* log device */
+#define MNTOPT_RTDEV	"rtdev"		/* realtime I/O device */
+#define MNTOPT_BIOSIZE	"biosize"	/* log2 of preferred buffered io size */
+#define MNTOPT_WSYNC	"wsync"		/* safe-mode nfs compatible mount */
+#define MNTOPT_INO64	"ino64"		/* force inodes into 64-bit range */
+#define MNTOPT_NOALIGN	"noalign"	/* turn off stripe alignment */
+#define MNTOPT_SWALLOC	"swalloc"	/* turn on stripe width allocation */
+#define MNTOPT_SUNIT	"sunit"		/* data volume stripe unit */
+#define MNTOPT_SWIDTH	"swidth"	/* data volume stripe width */
+#define MNTOPT_NOUUID	"nouuid"	/* ignore filesystem UUID */
+#define MNTOPT_MTPT	"mtpt"		/* filesystem mount point */
+#define MNTOPT_GRPID	"grpid"		/* group-ID from parent directory */
+#define MNTOPT_NOGRPID	"nogrpid"	/* group-ID from current process */
+#define MNTOPT_BSDGROUPS    "bsdgroups"    /* group-ID from parent directory */
+#define MNTOPT_SYSVGROUPS   "sysvgroups"   /* group-ID from current process */
+#define MNTOPT_ALLOCSIZE    "allocsize"    /* preferred allocation size */
+#define MNTOPT_NORECOVERY   "norecovery"   /* don't run XFS recovery */
+#define MNTOPT_BARRIER	"barrier"	/* use writer barriers for log write and
+					 * unwritten extent conversion */
+#define MNTOPT_NOBARRIER "nobarrier"	/* .. disable */
+#define MNTOPT_OSYNCISOSYNC "osyncisosync" /* o_sync is REALLY o_sync */
+#define MNTOPT_64BITINODE   "inode64"	/* inodes can be allocated anywhere */
+#define MNTOPT_IKEEP	"ikeep"		/* do not free empty inode clusters */
+#define MNTOPT_NOIKEEP	"noikeep"	/* free empty inode clusters */
+#define MNTOPT_LARGEIO	   "largeio"	/* report large I/O sizes in stat() */
+#define MNTOPT_NOLARGEIO   "nolargeio"	/* do not report large I/O sizes
+					 * in stat(). */
+#define MNTOPT_ATTR2	"attr2"		/* do use attr2 attribute format */
+#define MNTOPT_NOATTR2	"noattr2"	/* do not use attr2 attribute format */
+#define MNTOPT_FILESTREAM  "filestreams" /* use filestreams allocator */
+#define MNTOPT_QUOTA	"quota"		/* disk quotas (user) */
+#define MNTOPT_NOQUOTA	"noquota"	/* no quotas */
+#define MNTOPT_USRQUOTA	"usrquota"	/* user quota enabled */
+#define MNTOPT_GRPQUOTA	"grpquota"	/* group quota enabled */
+#define MNTOPT_PRJQUOTA	"prjquota"	/* project quota enabled */
+#define MNTOPT_UQUOTA	"uquota"	/* user quota (IRIX variant) */
+#define MNTOPT_GQUOTA	"gquota"	/* group quota (IRIX variant) */
+#define MNTOPT_PQUOTA	"pquota"	/* project quota (IRIX variant) */
+#define MNTOPT_UQUOTANOENF "uqnoenforce"/* user quota limit enforcement */
+#define MNTOPT_GQUOTANOENF "gqnoenforce"/* group quota limit enforcement */
+#define MNTOPT_PQUOTANOENF "pqnoenforce"/* project quota limit enforcement */
+#define MNTOPT_QUOTANOENF  "qnoenforce"	/* same as uqnoenforce */
+#define MNTOPT_DMAPI	"dmapi"		/* DMI enabled (DMAPI / XDSM) */
+#define MNTOPT_XDSM	"xdsm"		/* DMI enabled (DMAPI / XDSM) */
+#define MNTOPT_DMI	"dmi"		/* DMI enabled (DMAPI / XDSM) */
+
+STATIC unsigned long
+suffix_strtoul(char *s, char **endp, unsigned int base)
+{
+	int	last, shift_left_factor = 0;
+	char	*value = s;
+
+	last = strlen(value) - 1;
+	if (value[last] == 'K' || value[last] == 'k') {
+		shift_left_factor = 10;
+		value[last] = '\0';
+	}
+	if (value[last] == 'M' || value[last] == 'm') {
+		shift_left_factor = 20;
+		value[last] = '\0';
+	}
+	if (value[last] == 'G' || value[last] == 'g') {
+		shift_left_factor = 30;
+		value[last] = '\0';
+	}
+
+	return simple_strtoul((const char *)s, endp, base) << shift_left_factor;
+}
+
+STATIC int
+xfs_parseargs(
+	struct xfs_mount	*mp,
+	char			*options,
+	struct xfs_mount_args	*args,
+	int			update)
+{
+	char			*this_char, *value, *eov;
+	int			dsunit, dswidth, vol_dsunit, vol_dswidth;
+	int			iosize;
+	int			ikeep = 0;
+
+	args->flags |= XFSMNT_BARRIER;
+	args->flags2 |= XFSMNT2_COMPAT_IOSIZE;
+
+	if (!options)
+		goto done;
+
+	iosize = dsunit = dswidth = vol_dsunit = vol_dswidth = 0;
+
+	while ((this_char = strsep(&options, ",")) != NULL) {
+		if (!*this_char)
+			continue;
+		if ((value = strchr(this_char, '=')) != NULL)
+			*value++ = 0;
+
+		if (!strcmp(this_char, MNTOPT_LOGBUFS)) {
+			if (!value || !*value) {
+				cmn_err(CE_WARN,
+					"XFS: %s option requires an argument",
+					this_char);
+				return EINVAL;
+			}
+			args->logbufs = simple_strtoul(value, &eov, 10);
+		} else if (!strcmp(this_char, MNTOPT_LOGBSIZE)) {
+			if (!value || !*value) {
+				cmn_err(CE_WARN,
+					"XFS: %s option requires an argument",
+					this_char);
+				return EINVAL;
+			}
+			args->logbufsize = suffix_strtoul(value, &eov, 10);
+		} else if (!strcmp(this_char, MNTOPT_LOGDEV)) {
+			if (!value || !*value) {
+				cmn_err(CE_WARN,
+					"XFS: %s option requires an argument",
+					this_char);
+				return EINVAL;
+			}
+			strncpy(args->logname, value, MAXNAMELEN);
+		} else if (!strcmp(this_char, MNTOPT_MTPT)) {
+			if (!value || !*value) {
+				cmn_err(CE_WARN,
+					"XFS: %s option requires an argument",
+					this_char);
+				return EINVAL;
+			}
+			strncpy(args->mtpt, value, MAXNAMELEN);
+		} else if (!strcmp(this_char, MNTOPT_RTDEV)) {
+			if (!value || !*value) {
+				cmn_err(CE_WARN,
+					"XFS: %s option requires an argument",
+					this_char);
+				return EINVAL;
+			}
+			strncpy(args->rtname, value, MAXNAMELEN);
+		} else if (!strcmp(this_char, MNTOPT_BIOSIZE)) {
+			if (!value || !*value) {
+				cmn_err(CE_WARN,
+					"XFS: %s option requires an argument",
+					this_char);
+				return EINVAL;
+			}
+			iosize = simple_strtoul(value, &eov, 10);
+			args->flags |= XFSMNT_IOSIZE;
+			args->iosizelog = (uint8_t) iosize;
+		} else if (!strcmp(this_char, MNTOPT_ALLOCSIZE)) {
+			if (!value || !*value) {
+				cmn_err(CE_WARN,
+					"XFS: %s option requires an argument",
+					this_char);
+				return EINVAL;
+			}
+			iosize = suffix_strtoul(value, &eov, 10);
+			args->flags |= XFSMNT_IOSIZE;
+			args->iosizelog = ffs(iosize) - 1;
+		} else if (!strcmp(this_char, MNTOPT_GRPID) ||
+			   !strcmp(this_char, MNTOPT_BSDGROUPS)) {
+			mp->m_flags |= XFS_MOUNT_GRPID;
+		} else if (!strcmp(this_char, MNTOPT_NOGRPID) ||
+			   !strcmp(this_char, MNTOPT_SYSVGROUPS)) {
+			mp->m_flags &= ~XFS_MOUNT_GRPID;
+		} else if (!strcmp(this_char, MNTOPT_WSYNC)) {
+			args->flags |= XFSMNT_WSYNC;
+		} else if (!strcmp(this_char, MNTOPT_OSYNCISOSYNC)) {
+			args->flags |= XFSMNT_OSYNCISOSYNC;
+		} else if (!strcmp(this_char, MNTOPT_NORECOVERY)) {
+			args->flags |= XFSMNT_NORECOVERY;
+		} else if (!strcmp(this_char, MNTOPT_INO64)) {
+			args->flags |= XFSMNT_INO64;
+#if !XFS_BIG_INUMS
+			cmn_err(CE_WARN,
+				"XFS: %s option not allowed on this system",
+				this_char);
+			return EINVAL;
+#endif
+		} else if (!strcmp(this_char, MNTOPT_NOALIGN)) {
+			args->flags |= XFSMNT_NOALIGN;
+		} else if (!strcmp(this_char, MNTOPT_SWALLOC)) {
+			args->flags |= XFSMNT_SWALLOC;
+		} else if (!strcmp(this_char, MNTOPT_SUNIT)) {
+			if (!value || !*value) {
+				cmn_err(CE_WARN,
+					"XFS: %s option requires an argument",
+					this_char);
+				return EINVAL;
+			}
+			dsunit = simple_strtoul(value, &eov, 10);
+		} else if (!strcmp(this_char, MNTOPT_SWIDTH)) {
+			if (!value || !*value) {
+				cmn_err(CE_WARN,
+					"XFS: %s option requires an argument",
+					this_char);
+				return EINVAL;
+			}
+			dswidth = simple_strtoul(value, &eov, 10);
+		} else if (!strcmp(this_char, MNTOPT_64BITINODE)) {
+			args->flags &= ~XFSMNT_32BITINODES;
+#if !XFS_BIG_INUMS
+			cmn_err(CE_WARN,
+				"XFS: %s option not allowed on this system",
+				this_char);
+			return EINVAL;
+#endif
+		} else if (!strcmp(this_char, MNTOPT_NOUUID)) {
+			args->flags |= XFSMNT_NOUUID;
+		} else if (!strcmp(this_char, MNTOPT_BARRIER)) {
+			args->flags |= XFSMNT_BARRIER;
+		} else if (!strcmp(this_char, MNTOPT_NOBARRIER)) {
+			args->flags &= ~XFSMNT_BARRIER;
+		} else if (!strcmp(this_char, MNTOPT_IKEEP)) {
+			ikeep = 1;
+			args->flags &= ~XFSMNT_IDELETE;
+		} else if (!strcmp(this_char, MNTOPT_NOIKEEP)) {
+			args->flags |= XFSMNT_IDELETE;
+		} else if (!strcmp(this_char, MNTOPT_LARGEIO)) {
+			args->flags2 &= ~XFSMNT2_COMPAT_IOSIZE;
+		} else if (!strcmp(this_char, MNTOPT_NOLARGEIO)) {
+			args->flags2 |= XFSMNT2_COMPAT_IOSIZE;
+		} else if (!strcmp(this_char, MNTOPT_ATTR2)) {
+			args->flags |= XFSMNT_ATTR2;
+		} else if (!strcmp(this_char, MNTOPT_NOATTR2)) {
+			args->flags &= ~XFSMNT_ATTR2;
+		} else if (!strcmp(this_char, MNTOPT_FILESTREAM)) {
+			args->flags2 |= XFSMNT2_FILESTREAMS;
+		} else if (!strcmp(this_char, MNTOPT_NOQUOTA)) {
+			args->flags &= ~(XFSMNT_UQUOTAENF|XFSMNT_UQUOTA);
+			args->flags &= ~(XFSMNT_GQUOTAENF|XFSMNT_GQUOTA);
+		} else if (!strcmp(this_char, MNTOPT_QUOTA) ||
+			   !strcmp(this_char, MNTOPT_UQUOTA) ||
+			   !strcmp(this_char, MNTOPT_USRQUOTA)) {
+			args->flags |= XFSMNT_UQUOTA | XFSMNT_UQUOTAENF;
+		} else if (!strcmp(this_char, MNTOPT_QUOTANOENF) ||
+			   !strcmp(this_char, MNTOPT_UQUOTANOENF)) {
+			args->flags |= XFSMNT_UQUOTA;
+			args->flags &= ~XFSMNT_UQUOTAENF;
+		} else if (!strcmp(this_char, MNTOPT_PQUOTA) ||
+			   !strcmp(this_char, MNTOPT_PRJQUOTA)) {
+			args->flags |= XFSMNT_PQUOTA | XFSMNT_PQUOTAENF;
+		} else if (!strcmp(this_char, MNTOPT_PQUOTANOENF)) {
+			args->flags |= XFSMNT_PQUOTA;
+			args->flags &= ~XFSMNT_PQUOTAENF;
+		} else if (!strcmp(this_char, MNTOPT_GQUOTA) ||
+			   !strcmp(this_char, MNTOPT_GRPQUOTA)) {
+			args->flags |= XFSMNT_GQUOTA | XFSMNT_GQUOTAENF;
+		} else if (!strcmp(this_char, MNTOPT_GQUOTANOENF)) {
+			args->flags |= XFSMNT_GQUOTA;
+			args->flags &= ~XFSMNT_GQUOTAENF;
+		} else if (!strcmp(this_char, MNTOPT_DMAPI)) {
+			args->flags |= XFSMNT_DMAPI;
+		} else if (!strcmp(this_char, MNTOPT_XDSM)) {
+			args->flags |= XFSMNT_DMAPI;
+		} else if (!strcmp(this_char, MNTOPT_DMI)) {
+			args->flags |= XFSMNT_DMAPI;
+		} else if (!strcmp(this_char, "ihashsize")) {
+			cmn_err(CE_WARN,
+	"XFS: ihashsize no longer used, option is deprecated.");
+		} else if (!strcmp(this_char, "osyncisdsync")) {
+			/* no-op, this is now the default */
+			cmn_err(CE_WARN,
+	"XFS: osyncisdsync is now the default, option is deprecated.");
+		} else if (!strcmp(this_char, "irixsgid")) {
+			cmn_err(CE_WARN,
+	"XFS: irixsgid is now a sysctl(2) variable, option is deprecated.");
+		} else {
+			cmn_err(CE_WARN,
+				"XFS: unknown mount option [%s].", this_char);
+			return EINVAL;
+		}
+	}
+
+	if (args->flags & XFSMNT_NORECOVERY) {
+		if ((mp->m_flags & XFS_MOUNT_RDONLY) == 0) {
+			cmn_err(CE_WARN,
+				"XFS: no-recovery mounts must be read-only.");
+			return EINVAL;
+		}
+	}
+
+	if ((args->flags & XFSMNT_NOALIGN) && (dsunit || dswidth)) {
+		cmn_err(CE_WARN,
+	"XFS: sunit and swidth options incompatible with the noalign option");
+		return EINVAL;
+	}
+
+	if ((args->flags & XFSMNT_GQUOTA) && (args->flags & XFSMNT_PQUOTA)) {
+		cmn_err(CE_WARN,
+			"XFS: cannot mount with both project and group quota");
+		return EINVAL;
+	}
+
+	if ((args->flags & XFSMNT_DMAPI) && *args->mtpt == '\0') {
+		printk("XFS: %s option needs the mount point option as well\n",
+			MNTOPT_DMAPI);
+		return EINVAL;
+	}
+
+	if ((dsunit && !dswidth) || (!dsunit && dswidth)) {
+		cmn_err(CE_WARN,
+			"XFS: sunit and swidth must be specified together");
+		return EINVAL;
+	}
+
+	if (dsunit && (dswidth % dsunit != 0)) {
+		cmn_err(CE_WARN,
+	"XFS: stripe width (%d) must be a multiple of the stripe unit (%d)",
+			dswidth, dsunit);
+		return EINVAL;
+	}
+
+	/*
+	 * Applications using DMI filesystems often expect the
+	 * inode generation number to be monotonically increasing.
+	 * If we delete inode chunks we break this assumption, so
+	 * keep unused inode chunks on disk for DMI filesystems
+	 * until we come up with a better solution.
+	 * Note that if "ikeep" or "noikeep" mount options are
+	 * supplied, then they are honored.
+	 */
+	if (!(args->flags & XFSMNT_DMAPI) && !ikeep)
+		args->flags |= XFSMNT_IDELETE;
+
+	if ((args->flags & XFSMNT_NOALIGN) != XFSMNT_NOALIGN) {
+		if (dsunit) {
+			args->sunit = dsunit;
+			args->flags |= XFSMNT_RETERR;
+		} else {
+			args->sunit = vol_dsunit;
+		}
+		dswidth ? (args->swidth = dswidth) :
+			  (args->swidth = vol_dswidth);
+	} else {
+		args->sunit = args->swidth = 0;
+	}
+
+done:
+	if (args->flags & XFSMNT_32BITINODES)
+		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
+	if (args->flags2)
+		args->flags |= XFSMNT_FLAGS2;
+	return 0;
+}
+
+struct proc_xfs_info {
+	int	flag;
+	char	*str;
+};
+
+STATIC int
+xfs_showargs(
+	struct xfs_mount	*mp,
+	struct seq_file		*m)
+{
+	static struct proc_xfs_info xfs_info_set[] = {
+		/* the few simple ones we can get from the mount struct */
+		{ XFS_MOUNT_WSYNC,		"," MNTOPT_WSYNC },
+		{ XFS_MOUNT_INO64,		"," MNTOPT_INO64 },
+		{ XFS_MOUNT_NOALIGN,		"," MNTOPT_NOALIGN },
+		{ XFS_MOUNT_SWALLOC,		"," MNTOPT_SWALLOC },
+		{ XFS_MOUNT_NOUUID,		"," MNTOPT_NOUUID },
+		{ XFS_MOUNT_NORECOVERY,		"," MNTOPT_NORECOVERY },
+		{ XFS_MOUNT_OSYNCISOSYNC,	"," MNTOPT_OSYNCISOSYNC },
+		{ XFS_MOUNT_ATTR2,		"," MNTOPT_ATTR2 },
+		{ XFS_MOUNT_FILESTREAMS,	"," MNTOPT_FILESTREAM },
+		{ XFS_MOUNT_DMAPI,		"," MNTOPT_DMAPI },
+		{ XFS_MOUNT_GRPID,		"," MNTOPT_GRPID },
+		{ 0, NULL }
+	};
+	static struct proc_xfs_info xfs_info_unset[] = {
+		/* the few simple ones we can get from the mount struct */
+		{ XFS_MOUNT_IDELETE,		"," MNTOPT_IKEEP },
+		{ XFS_MOUNT_COMPAT_IOSIZE,	"," MNTOPT_LARGEIO },
+		{ XFS_MOUNT_BARRIER,		"," MNTOPT_NOBARRIER },
+		{ XFS_MOUNT_SMALL_INUMS,	"," MNTOPT_64BITINODE },
+		{ 0, NULL }
+	};
+	struct proc_xfs_info	*xfs_infop;
+
+	for (xfs_infop = xfs_info_set; xfs_infop->flag; xfs_infop++) {
+		if (mp->m_flags & xfs_infop->flag)
+			seq_puts(m, xfs_infop->str);
+	}
+	for (xfs_infop = xfs_info_unset; xfs_infop->flag; xfs_infop++) {
+		if (!(mp->m_flags & xfs_infop->flag))
+			seq_puts(m, xfs_infop->str);
+	}
+
+	if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
+		seq_printf(m, "," MNTOPT_ALLOCSIZE "=%dk",
+				(int)(1 << mp->m_writeio_log) >> 10);
+
+	if (mp->m_logbufs > 0)
+		seq_printf(m, "," MNTOPT_LOGBUFS "=%d", mp->m_logbufs);
+	if (mp->m_logbsize > 0)
+		seq_printf(m, "," MNTOPT_LOGBSIZE "=%dk", mp->m_logbsize >> 10);
+
+	if (mp->m_logname)
+		seq_printf(m, "," MNTOPT_LOGDEV "=%s", mp->m_logname);
+	if (mp->m_rtname)
+		seq_printf(m, "," MNTOPT_RTDEV "=%s", mp->m_rtname);
+
+	if (mp->m_dalign > 0)
+		seq_printf(m, "," MNTOPT_SUNIT "=%d",
+				(int)XFS_FSB_TO_BB(mp, mp->m_dalign));
+	if (mp->m_swidth > 0)
+		seq_printf(m, "," MNTOPT_SWIDTH "=%d",
+				(int)XFS_FSB_TO_BB(mp, mp->m_swidth));
+
+	if (mp->m_qflags & (XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD))
+		seq_puts(m, "," MNTOPT_USRQUOTA);
+	else if (mp->m_qflags & XFS_UQUOTA_ACCT)
+		seq_puts(m, "," MNTOPT_UQUOTANOENF);
+
+	if (mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))
+		seq_puts(m, "," MNTOPT_PRJQUOTA);
+	else if (mp->m_qflags & XFS_PQUOTA_ACCT)
+		seq_puts(m, "," MNTOPT_PQUOTANOENF);
+
+	if (mp->m_qflags & (XFS_GQUOTA_ACCT|XFS_OQUOTA_ENFD))
+		seq_puts(m, "," MNTOPT_GRPQUOTA);
+	else if (mp->m_qflags & XFS_GQUOTA_ACCT)
+		seq_puts(m, "," MNTOPT_GQUOTANOENF);
+
+	if (!(mp->m_qflags & XFS_ALL_QUOTA_ACCT))
+		seq_puts(m, "," MNTOPT_NOQUOTA);
+
+	return 0;
+}
 __uint64_t
 xfs_max_file_offset(
 	unsigned int		blockshift)
Index: 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vfsops.c	2007-10-31 10:06:18.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c	2007-10-31 10:24:25.909483756 +1100
@@ -1482,433 +1482,3 @@ xfs_vget(
 	return 0;
 }
 
-
-#define MNTOPT_LOGBUFS	"logbufs"	/* number of XFS log buffers */
-#define MNTOPT_LOGBSIZE	"logbsize"	/* size of XFS log buffers */
-#define MNTOPT_LOGDEV	"logdev"	/* log device */
-#define MNTOPT_RTDEV	"rtdev"		/* realtime I/O device */
-#define MNTOPT_BIOSIZE	"biosize"	/* log2 of preferred buffered io size */
-#define MNTOPT_WSYNC	"wsync"		/* safe-mode nfs compatible mount */
-#define MNTOPT_INO64	"ino64"		/* force inodes into 64-bit range */
-#define MNTOPT_NOALIGN	"noalign"	/* turn off stripe alignment */
-#define MNTOPT_SWALLOC	"swalloc"	/* turn on stripe width allocation */
-#define MNTOPT_SUNIT	"sunit"		/* data volume stripe unit */
-#define MNTOPT_SWIDTH	"swidth"	/* data volume stripe width */
-#define MNTOPT_NOUUID	"nouuid"	/* ignore filesystem UUID */
-#define MNTOPT_MTPT	"mtpt"		/* filesystem mount point */
-#define MNTOPT_GRPID	"grpid"		/* group-ID from parent directory */
-#define MNTOPT_NOGRPID	"nogrpid"	/* group-ID from current process */
-#define MNTOPT_BSDGROUPS    "bsdgroups"    /* group-ID from parent directory */
-#define MNTOPT_SYSVGROUPS   "sysvgroups"   /* group-ID from current process */
-#define MNTOPT_ALLOCSIZE    "allocsize"    /* preferred allocation size */
-#define MNTOPT_NORECOVERY   "norecovery"   /* don't run XFS recovery */
-#define MNTOPT_BARRIER	"barrier"	/* use writer barriers for log write and
-					 * unwritten extent conversion */
-#define MNTOPT_NOBARRIER "nobarrier"	/* .. disable */
-#define MNTOPT_OSYNCISOSYNC "osyncisosync" /* o_sync is REALLY o_sync */
-#define MNTOPT_64BITINODE   "inode64"	/* inodes can be allocated anywhere */
-#define MNTOPT_IKEEP	"ikeep"		/* do not free empty inode clusters */
-#define MNTOPT_NOIKEEP	"noikeep"	/* free empty inode clusters */
-#define MNTOPT_LARGEIO	   "largeio"	/* report large I/O sizes in stat() */
-#define MNTOPT_NOLARGEIO   "nolargeio"	/* do not report large I/O sizes
-					 * in stat(). */
-#define MNTOPT_ATTR2	"attr2"		/* do use attr2 attribute format */
-#define MNTOPT_NOATTR2	"noattr2"	/* do not use attr2 attribute format */
-#define MNTOPT_FILESTREAM  "filestreams" /* use filestreams allocator */
-#define MNTOPT_QUOTA	"quota"		/* disk quotas (user) */
-#define MNTOPT_NOQUOTA	"noquota"	/* no quotas */
-#define MNTOPT_USRQUOTA	"usrquota"	/* user quota enabled */
-#define MNTOPT_GRPQUOTA	"grpquota"	/* group quota enabled */
-#define MNTOPT_PRJQUOTA	"prjquota"	/* project quota enabled */
-#define MNTOPT_UQUOTA	"uquota"	/* user quota (IRIX variant) */
-#define MNTOPT_GQUOTA	"gquota"	/* group quota (IRIX variant) */
-#define MNTOPT_PQUOTA	"pquota"	/* project quota (IRIX variant) */
-#define MNTOPT_UQUOTANOENF "uqnoenforce"/* user quota limit enforcement */
-#define MNTOPT_GQUOTANOENF "gqnoenforce"/* group quota limit enforcement */
-#define MNTOPT_PQUOTANOENF "pqnoenforce"/* project quota limit enforcement */
-#define MNTOPT_QUOTANOENF  "qnoenforce"	/* same as uqnoenforce */
-#define MNTOPT_DMAPI	"dmapi"		/* DMI enabled (DMAPI / XDSM) */
-#define MNTOPT_XDSM	"xdsm"		/* DMI enabled (DMAPI / XDSM) */
-#define MNTOPT_DMI	"dmi"		/* DMI enabled (DMAPI / XDSM) */
-
-STATIC unsigned long
-suffix_strtoul(char *s, char **endp, unsigned int base)
-{
-	int	last, shift_left_factor = 0;
-	char	*value = s;
-
-	last = strlen(value) - 1;
-	if (value[last] == 'K' || value[last] == 'k') {
-		shift_left_factor = 10;
-		value[last] = '\0';
-	}
-	if (value[last] == 'M' || value[last] == 'm') {
-		shift_left_factor = 20;
-		value[last] = '\0';
-	}
-	if (value[last] == 'G' || value[last] == 'g') {
-		shift_left_factor = 30;
-		value[last] = '\0';
-	}
-
-	return simple_strtoul((const char *)s, endp, base) << shift_left_factor;
-}
-
-int
-xfs_parseargs(
-	struct xfs_mount	*mp,
-	char			*options,
-	struct xfs_mount_args	*args,
-	int			update)
-{
-	char			*this_char, *value, *eov;
-	int			dsunit, dswidth, vol_dsunit, vol_dswidth;
-	int			iosize;
-	int			ikeep = 0;
-
-	args->flags |= XFSMNT_BARRIER;
-	args->flags2 |= XFSMNT2_COMPAT_IOSIZE;
-
-	if (!options)
-		goto done;
-
-	iosize = dsunit = dswidth = vol_dsunit = vol_dswidth = 0;
-
-	while ((this_char = strsep(&options, ",")) != NULL) {
-		if (!*this_char)
-			continue;
-		if ((value = strchr(this_char, '=')) != NULL)
-			*value++ = 0;
-
-		if (!strcmp(this_char, MNTOPT_LOGBUFS)) {
-			if (!value || !*value) {
-				cmn_err(CE_WARN,
-					"XFS: %s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			args->logbufs = simple_strtoul(value, &eov, 10);
-		} else if (!strcmp(this_char, MNTOPT_LOGBSIZE)) {
-			if (!value || !*value) {
-				cmn_err(CE_WARN,
-					"XFS: %s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			args->logbufsize = suffix_strtoul(value, &eov, 10);
-		} else if (!strcmp(this_char, MNTOPT_LOGDEV)) {
-			if (!value || !*value) {
-				cmn_err(CE_WARN,
-					"XFS: %s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			strncpy(args->logname, value, MAXNAMELEN);
-		} else if (!strcmp(this_char, MNTOPT_MTPT)) {
-			if (!value || !*value) {
-				cmn_err(CE_WARN,
-					"XFS: %s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			strncpy(args->mtpt, value, MAXNAMELEN);
-		} else if (!strcmp(this_char, MNTOPT_RTDEV)) {
-			if (!value || !*value) {
-				cmn_err(CE_WARN,
-					"XFS: %s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			strncpy(args->rtname, value, MAXNAMELEN);
-		} else if (!strcmp(this_char, MNTOPT_BIOSIZE)) {
-			if (!value || !*value) {
-				cmn_err(CE_WARN,
-					"XFS: %s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			iosize = simple_strtoul(value, &eov, 10);
-			args->flags |= XFSMNT_IOSIZE;
-			args->iosizelog = (uint8_t) iosize;
-		} else if (!strcmp(this_char, MNTOPT_ALLOCSIZE)) {
-			if (!value || !*value) {
-				cmn_err(CE_WARN,
-					"XFS: %s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			iosize = suffix_strtoul(value, &eov, 10);
-			args->flags |= XFSMNT_IOSIZE;
-			args->iosizelog = ffs(iosize) - 1;
-		} else if (!strcmp(this_char, MNTOPT_GRPID) ||
-			   !strcmp(this_char, MNTOPT_BSDGROUPS)) {
-			mp->m_flags |= XFS_MOUNT_GRPID;
-		} else if (!strcmp(this_char, MNTOPT_NOGRPID) ||
-			   !strcmp(this_char, MNTOPT_SYSVGROUPS)) {
-			mp->m_flags &= ~XFS_MOUNT_GRPID;
-		} else if (!strcmp(this_char, MNTOPT_WSYNC)) {
-			args->flags |= XFSMNT_WSYNC;
-		} else if (!strcmp(this_char, MNTOPT_OSYNCISOSYNC)) {
-			args->flags |= XFSMNT_OSYNCISOSYNC;
-		} else if (!strcmp(this_char, MNTOPT_NORECOVERY)) {
-			args->flags |= XFSMNT_NORECOVERY;
-		} else if (!strcmp(this_char, MNTOPT_INO64)) {
-			args->flags |= XFSMNT_INO64;
-#if !XFS_BIG_INUMS
-			cmn_err(CE_WARN,
-				"XFS: %s option not allowed on this system",
-				this_char);
-			return EINVAL;
-#endif
-		} else if (!strcmp(this_char, MNTOPT_NOALIGN)) {
-			args->flags |= XFSMNT_NOALIGN;
-		} else if (!strcmp(this_char, MNTOPT_SWALLOC)) {
-			args->flags |= XFSMNT_SWALLOC;
-		} else if (!strcmp(this_char, MNTOPT_SUNIT)) {
-			if (!value || !*value) {
-				cmn_err(CE_WARN,
-					"XFS: %s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			dsunit = simple_strtoul(value, &eov, 10);
-		} else if (!strcmp(this_char, MNTOPT_SWIDTH)) {
-			if (!value || !*value) {
-				cmn_err(CE_WARN,
-					"XFS: %s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			dswidth = simple_strtoul(value, &eov, 10);
-		} else if (!strcmp(this_char, MNTOPT_64BITINODE)) {
-			args->flags &= ~XFSMNT_32BITINODES;
-#if !XFS_BIG_INUMS
-			cmn_err(CE_WARN,
-				"XFS: %s option not allowed on this system",
-				this_char);
-			return EINVAL;
-#endif
-		} else if (!strcmp(this_char, MNTOPT_NOUUID)) {
-			args->flags |= XFSMNT_NOUUID;
-		} else if (!strcmp(this_char, MNTOPT_BARRIER)) {
-			args->flags |= XFSMNT_BARRIER;
-		} else if (!strcmp(this_char, MNTOPT_NOBARRIER)) {
-			args->flags &= ~XFSMNT_BARRIER;
-		} else if (!strcmp(this_char, MNTOPT_IKEEP)) {
-			ikeep = 1;
-			args->flags &= ~XFSMNT_IDELETE;
-		} else if (!strcmp(this_char, MNTOPT_NOIKEEP)) {
-			args->flags |= XFSMNT_IDELETE;
-		} else if (!strcmp(this_char, MNTOPT_LARGEIO)) {
-			args->flags2 &= ~XFSMNT2_COMPAT_IOSIZE;
-		} else if (!strcmp(this_char, MNTOPT_NOLARGEIO)) {
-			args->flags2 |= XFSMNT2_COMPAT_IOSIZE;
-		} else if (!strcmp(this_char, MNTOPT_ATTR2)) {
-			args->flags |= XFSMNT_ATTR2;
-		} else if (!strcmp(this_char, MNTOPT_NOATTR2)) {
-			args->flags &= ~XFSMNT_ATTR2;
-		} else if (!strcmp(this_char, MNTOPT_FILESTREAM)) {
-			args->flags2 |= XFSMNT2_FILESTREAMS;
-		} else if (!strcmp(this_char, MNTOPT_NOQUOTA)) {
-			args->flags &= ~(XFSMNT_UQUOTAENF|XFSMNT_UQUOTA);
-			args->flags &= ~(XFSMNT_GQUOTAENF|XFSMNT_GQUOTA);
-		} else if (!strcmp(this_char, MNTOPT_QUOTA) ||
-			   !strcmp(this_char, MNTOPT_UQUOTA) ||
-			   !strcmp(this_char, MNTOPT_USRQUOTA)) {
-			args->flags |= XFSMNT_UQUOTA | XFSMNT_UQUOTAENF;
-		} else if (!strcmp(this_char, MNTOPT_QUOTANOENF) ||
-			   !strcmp(this_char, MNTOPT_UQUOTANOENF)) {
-			args->flags |= XFSMNT_UQUOTA;
-			args->flags &= ~XFSMNT_UQUOTAENF;
-		} else if (!strcmp(this_char, MNTOPT_PQUOTA) ||
-			   !strcmp(this_char, MNTOPT_PRJQUOTA)) {
-			args->flags |= XFSMNT_PQUOTA | XFSMNT_PQUOTAENF;
-		} else if (!strcmp(this_char, MNTOPT_PQUOTANOENF)) {
-			args->flags |= XFSMNT_PQUOTA;
-			args->flags &= ~XFSMNT_PQUOTAENF;
-		} else if (!strcmp(this_char, MNTOPT_GQUOTA) ||
-			   !strcmp(this_char, MNTOPT_GRPQUOTA)) {
-			args->flags |= XFSMNT_GQUOTA | XFSMNT_GQUOTAENF;
-		} else if (!strcmp(this_char, MNTOPT_GQUOTANOENF)) {
-			args->flags |= XFSMNT_GQUOTA;
-			args->flags &= ~XFSMNT_GQUOTAENF;
-		} else if (!strcmp(this_char, MNTOPT_DMAPI)) {
-			args->flags |= XFSMNT_DMAPI;
-		} else if (!strcmp(this_char, MNTOPT_XDSM)) {
-			args->flags |= XFSMNT_DMAPI;
-		} else if (!strcmp(this_char, MNTOPT_DMI)) {
-			args->flags |= XFSMNT_DMAPI;
-		} else if (!strcmp(this_char, "ihashsize")) {
-			cmn_err(CE_WARN,
-	"XFS: ihashsize no longer used, option is deprecated.");
-		} else if (!strcmp(this_char, "osyncisdsync")) {
-			/* no-op, this is now the default */
-			cmn_err(CE_WARN,
-	"XFS: osyncisdsync is now the default, option is deprecated.");
-		} else if (!strcmp(this_char, "irixsgid")) {
-			cmn_err(CE_WARN,
-	"XFS: irixsgid is now a sysctl(2) variable, option is deprecated.");
-		} else {
-			cmn_err(CE_WARN,
-				"XFS: unknown mount option [%s].", this_char);
-			return EINVAL;
-		}
-	}
-
-	if (args->flags & XFSMNT_NORECOVERY) {
-		if ((mp->m_flags & XFS_MOUNT_RDONLY) == 0) {
-			cmn_err(CE_WARN,
-				"XFS: no-recovery mounts must be read-only.");
-			return EINVAL;
-		}
-	}
-
-	if ((args->flags & XFSMNT_NOALIGN) && (dsunit || dswidth)) {
-		cmn_err(CE_WARN,
-	"XFS: sunit and swidth options incompatible with the noalign option");
-		return EINVAL;
-	}
-
-	if ((args->flags & XFSMNT_GQUOTA) && (args->flags & XFSMNT_PQUOTA)) {
-		cmn_err(CE_WARN,
-			"XFS: cannot mount with both project and group quota");
-		return EINVAL;
-	}
-
-	if ((args->flags & XFSMNT_DMAPI) && *args->mtpt == '\0') {
-		printk("XFS: %s option needs the mount point option as well\n",
-			MNTOPT_DMAPI);
-		return EINVAL;
-	}
-
-	if ((dsunit && !dswidth) || (!dsunit && dswidth)) {
-		cmn_err(CE_WARN,
-			"XFS: sunit and swidth must be specified together");
-		return EINVAL;
-	}
-
-	if (dsunit && (dswidth % dsunit != 0)) {
-		cmn_err(CE_WARN,
-	"XFS: stripe width (%d) must be a multiple of the stripe unit (%d)",
-			dswidth, dsunit);
-		return EINVAL;
-	}
-
-	/*
-	 * Applications using DMI filesystems often expect the
-	 * inode generation number to be monotonically increasing.
-	 * If we delete inode chunks we break this assumption, so
-	 * keep unused inode chunks on disk for DMI filesystems
-	 * until we come up with a better solution.
-	 * Note that if "ikeep" or "noikeep" mount options are
-	 * supplied, then they are honored.
-	 */
-	if (!(args->flags & XFSMNT_DMAPI) && !ikeep)
-		args->flags |= XFSMNT_IDELETE;
-
-	if ((args->flags & XFSMNT_NOALIGN) != XFSMNT_NOALIGN) {
-		if (dsunit) {
-			args->sunit = dsunit;
-			args->flags |= XFSMNT_RETERR;
-		} else {
-			args->sunit = vol_dsunit;
-		}
-		dswidth ? (args->swidth = dswidth) :
-			  (args->swidth = vol_dswidth);
-	} else {
-		args->sunit = args->swidth = 0;
-	}
-
-done:
-	if (args->flags & XFSMNT_32BITINODES)
-		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
-	if (args->flags2)
-		args->flags |= XFSMNT_FLAGS2;
-	return 0;
-}
-
-struct proc_xfs_info {
-	int	flag;
-	char	*str;
-};
-
-int
-xfs_showargs(
-	struct xfs_mount	*mp,
-	struct seq_file		*m)
-{
-	static struct proc_xfs_info xfs_info_set[] = {
-		/* the few simple ones we can get from the mount struct */
-		{ XFS_MOUNT_WSYNC,		"," MNTOPT_WSYNC },
-		{ XFS_MOUNT_INO64,		"," MNTOPT_INO64 },
-		{ XFS_MOUNT_NOALIGN,		"," MNTOPT_NOALIGN },
-		{ XFS_MOUNT_SWALLOC,		"," MNTOPT_SWALLOC },
-		{ XFS_MOUNT_NOUUID,		"," MNTOPT_NOUUID },
-		{ XFS_MOUNT_NORECOVERY,		"," MNTOPT_NORECOVERY },
-		{ XFS_MOUNT_OSYNCISOSYNC,	"," MNTOPT_OSYNCISOSYNC },
-		{ XFS_MOUNT_ATTR2,		"," MNTOPT_ATTR2 },
-		{ XFS_MOUNT_FILESTREAMS,	"," MNTOPT_FILESTREAM },
-		{ XFS_MOUNT_DMAPI,		"," MNTOPT_DMAPI },
-		{ XFS_MOUNT_GRPID,		"," MNTOPT_GRPID },
-		{ 0, NULL }
-	};
-	static struct proc_xfs_info xfs_info_unset[] = {
-		/* the few simple ones we can get from the mount struct */
-		{ XFS_MOUNT_IDELETE,		"," MNTOPT_IKEEP },
-		{ XFS_MOUNT_COMPAT_IOSIZE,	"," MNTOPT_LARGEIO },
-		{ XFS_MOUNT_BARRIER,		"," MNTOPT_NOBARRIER },
-		{ XFS_MOUNT_SMALL_INUMS,	"," MNTOPT_64BITINODE },
-		{ 0, NULL }
-	};
-	struct proc_xfs_info	*xfs_infop;
-
-	for (xfs_infop = xfs_info_set; xfs_infop->flag; xfs_infop++) {
-		if (mp->m_flags & xfs_infop->flag)
-			seq_puts(m, xfs_infop->str);
-	}
-	for (xfs_infop = xfs_info_unset; xfs_infop->flag; xfs_infop++) {
-		if (!(mp->m_flags & xfs_infop->flag))
-			seq_puts(m, xfs_infop->str);
-	}
-
-	if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
-		seq_printf(m, "," MNTOPT_ALLOCSIZE "=%dk",
-				(int)(1 << mp->m_writeio_log) >> 10);
-
-	if (mp->m_logbufs > 0)
-		seq_printf(m, "," MNTOPT_LOGBUFS "=%d", mp->m_logbufs);
-	if (mp->m_logbsize > 0)
-		seq_printf(m, "," MNTOPT_LOGBSIZE "=%dk", mp->m_logbsize >> 10);
-
-	if (mp->m_logname)
-		seq_printf(m, "," MNTOPT_LOGDEV "=%s", mp->m_logname);
-	if (mp->m_rtname)
-		seq_printf(m, "," MNTOPT_RTDEV "=%s", mp->m_rtname);
-
-	if (mp->m_dalign > 0)
-		seq_printf(m, "," MNTOPT_SUNIT "=%d",
-				(int)XFS_FSB_TO_BB(mp, mp->m_dalign));
-	if (mp->m_swidth > 0)
-		seq_printf(m, "," MNTOPT_SWIDTH "=%d",
-				(int)XFS_FSB_TO_BB(mp, mp->m_swidth));
-
-	if (mp->m_qflags & (XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD))
-		seq_puts(m, "," MNTOPT_USRQUOTA);
-	else if (mp->m_qflags & XFS_UQUOTA_ACCT)
-		seq_puts(m, "," MNTOPT_UQUOTANOENF);
-
-	if (mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))
-		seq_puts(m, "," MNTOPT_PRJQUOTA);
-	else if (mp->m_qflags & XFS_PQUOTA_ACCT)
-		seq_puts(m, "," MNTOPT_PQUOTANOENF);
-
-	if (mp->m_qflags & (XFS_GQUOTA_ACCT|XFS_OQUOTA_ENFD))
-		seq_puts(m, "," MNTOPT_GRPQUOTA);
-	else if (mp->m_qflags & XFS_GQUOTA_ACCT)
-		seq_puts(m, "," MNTOPT_GQUOTANOENF);
-
-	if (!(mp->m_qflags & XFS_ALL_QUOTA_ACCT))
-		seq_puts(m, "," MNTOPT_NOQUOTA);
-
-	return 0;
-}
Index: 2.6.x-xfs-new/fs/xfs/xfs_vfsops.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vfsops.h	2007-10-02 16:01:48.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vfsops.h	2007-10-31 10:24:35.088295625 +1100
@@ -16,9 +16,6 @@ int xfs_mntupdate(struct xfs_mount *mp, 
 int xfs_root(struct xfs_mount *mp, bhv_vnode_t **vpp);
 int xfs_sync(struct xfs_mount *mp, int flags);
 int xfs_vget(struct xfs_mount *mp, bhv_vnode_t **vpp, struct xfs_fid *xfid);
-int xfs_parseargs(struct xfs_mount *mp, char *options,
-		struct xfs_mount_args *args, int update);
-int xfs_showargs(struct xfs_mount *mp, struct seq_file *m);
 void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
 		int lnnum);
 void xfs_attr_quiesce(struct xfs_mount *mp);
