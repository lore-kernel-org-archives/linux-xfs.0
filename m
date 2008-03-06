Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 06 Mar 2008 08:37:08 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m26GajIM032508
	for <xfs@oss.sgi.com>; Thu, 6 Mar 2008 08:36:48 -0800
Received: from mail.pawisda.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B83C5F2AC2F
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2008 08:37:10 -0800 (PST)
Received: from mail.pawisda.de (mail.pawisda.de [213.157.4.156]) by cuda.sgi.com with ESMTP id 9yr4RmE2NqfN4kkY for <xfs@oss.sgi.com>; Thu, 06 Mar 2008 08:37:10 -0800 (PST)
Subject: Re: REVIEW: xfs_reno #2
From: Ruben Porras <ruben.porras@linworks.de>
In-Reply-To: <20071120013651.GR995458@sgi.com>
References: <op.tznnweh23jf8g2@pc-bnaujok.melbourne.sgi.com>
	 <20071120013651.GR995458@sgi.com>
Content-Type: multipart/mixed; boundary="=-4Da9GvHld0Grtgo95r+H"
Date: Thu, 06 Mar 2008 17:11:46 +0100
Message-Id: <1204819906.4002.40.camel@tecra.thekeening.homeunix.org>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--=-4Da9GvHld0Grtgo95r+H
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Am Dienstag, den 20.11.2007, 12:36 +1100 schrieb David Chinner:
> On Thu, Oct 04, 2007 at 02:25:16PM +1000, Barry Naujok wrote:
> > To make this better, ideally we need some form of
> > "swap inodes" function in the kernel, where the entire
> > contents of the inode themselves are swapped. This form
> > can handle any inode and without any of the dir/file/attr/etc
> > copy/swap mechanisms we have in xfs_reno.
> 
> Something like the attached patch?
> 
> This is proof-of-concept. I've compiled it but I haven't tested
> it. Your mission, Barry, should you choose to accept it, it to

Hello again,

I have this week again time to at xfs_reno and xfs_swapino and
xfs_swap_extents functions. I adapted xfs_reno to use these ioctl
instead of the user space dir/file/attr/..., and I move successfully
files and directories (see the problem description later).

Then I run into two problems, one processing directories, and one
processing symlinks, where I do not now how to proceed, and I would like
to have advice.

Firsts, directories:

At this moment it is not possible to use xfs_swap_extents to for
directories:

(extract from xfs_dfrag.c)

        if (VN_CACHED(tvp) != 0) {
                xfs_inval_cached_trace(tip, 0, -1, 0, -1);
                error = xfs_flushinval_pages(tip, 0, -1,
                                FI_REMAPF_LOCKED);
                if (error)
                        goto error0;
        }

        /* Verify O_DIRECT for ftmp */
        if (VN_CACHED(tvp) != 0) {
                error = XFS_ERROR(EINVAL);
                goto error0;
        }

But it is not posible to do an open(2) on a directory with O_DIRECT. I
was unable to find out if this restriction comes from the kernel or from
the glibc, neither why open on dirs with O_DIRECT needs to be forbidden
(hints would be appreciated ;), but changing this snippet to 

        /* There is no O_DIRECT for directories */
        if (VN_CACHED(tvp) != 0 && VN_ISDIR(tvp) == 0) {
                error = XFS_ERROR(EINVAL);
                goto error0;
        }

does the trick. Can we do that?

Second, symlinks:

xfs_swapino and xfs_swap_extents, require the file descriptors of the
related files. However, it is not possible to get from user space the fd
of a symlink, because open(2) follow always the symlinks. I would change
this functions to accept xfs_inode as parameters instead of file
descriptors, and get them in xfs_reno with stat und lstat, but I would
like to get your opinion before changing the ioctls.

Attached the modified xfs_reno.c (process_slink not working).

Regards.

--=-4Da9GvHld0Grtgo95r+H
Content-Disposition: attachment; filename=xfs_reno.c
Content-Type: text/x-csrc; name=xfs_reno.c; charset=UTF-8
Content-Transfer-Encoding: 7bit

/*
 * Copyright (c) 2007 Silicon Graphics, Inc.
 * All Rights Reserved.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it would be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write the Free Software Foundation,
 * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */

/*
 * xfs_reno - renumber 64-bit inodes
 *
 * xfs_reno [-f] [-n] [-p] [-q] [-v] [-P seconds] path ...
 * xfs_reno [-r] path ...
 *
 * Renumbers all inodes > 32 bits into 32 bit space. Requires the filesytem
 * to be mounted with inode32.
 *
 *	-f		force conversion on all inodes rather than just
 *			those with a 64bit inode number.
 *	-n		nothing, do not renumber inodes
 *	-p		show progress status.
 *	-q		quiet, do not report progress, only errors.
 *	-v		verbose, more -v's more verbose.
 *	-P seconds	set the interval for the progress status in seconds.
 *	-r		recover from an interrupted run.
 */

#include <xfs/xfs.h>

#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <ftw.h>
#include <libgen.h>
#include <malloc.h>
#include <signal.h>
#include <stdint.h>
#include <sys/ioctl.h>
#include <attr/attributes.h>
#include <xfs/xfs_dfrag.h>
#include <xfs/xfs_inum.h>
#include <xfs/xfs_types.h>
#include <xfs/xfs_ag.h>

#define SCAN_PHASE	0x00
#define DIR_PHASE	0x10	/* nothing done or all done */
#define DIR_PHASE_1	0x11	/* temp dir created */
#define DIR_PHASE_2	0x12	/* swapped extents and inodes */
#define DIR_PHASE_3	0x13	/* src dir removed */
#define DIR_PHASE_MAX	0x13	/* renamed temp to source name */
#define FILE_PHASE	0x20	/* nothing done or all done */
#define FILE_PHASE_1	0x21	/* temp file created */
#define FILE_PHASE_2	0x22	/* swapped extents and inodes */
#define FILE_PHASE_3	0x23	/* unlinked source */
#define FILE_PHASE_4	0x24	/* hard links copied */
#define FILE_PHASE_MAX	0x24	/* renamed temp to source name */
#define SLINK_PHASE	0x30	/* nothing done or all done */
#define SLINK_PHASE_1	0x31	/* temp symlink created */
#define SLINK_PHASE_2	0x32	/* symlink attrs copied */
#define SLINK_PHASE_3	0x33	/* unlinked source */
#define SLINK_PHASE_4	0x34	/* hard links copied */
#define SLINK_PHASE_MAX	0x34	/* renamed temp to source name */

static void update_recoverfile(void);
#define SET_PHASE(x)	(cur_phase = x, update_recoverfile())

#define LOG_ERR		0
#define LOG_NORMAL	1
#define LOG_INFO	2
#define LOG_DEBUG	3
#define LOG_NITTY	4

#define NH_BUCKETS	65536
#define NH_HASH(ino)	(nodehash + ((ino) % NH_BUCKETS))

typedef struct {
	xfs_ino_t	ino;
	int		ftw_flags;
	nlink_t		numpaths;
	char		**paths;
} bignode_t;

typedef struct {
	bignode_t	*nodes;
	uint64_t	listlen;
	uint64_t	lastnode;
} nodelist_t;

static const char	*cmd_prefix = "xfs_reno_";

static char		*progname;
static int		log_level = LOG_NORMAL;
static int		force_all;
static nodelist_t	*nodehash;
static int		realuid;
static uint64_t		numdirnodes;
static uint64_t		numfilenodes;
static uint64_t		numslinknodes;
static uint64_t		numdirsdone;
static uint64_t		numfilesdone;
static uint64_t		numslinksdone;
static int		poll_interval;
static time_t		starttime;
static bignode_t	*cur_node;
static char		*cur_target;
static int		cur_phase;
static int		highest_numpaths;
static char		*recover_file;
static int		recover_fd;
static volatile int	poll_output;
static int		global_rval;
static int *agmask;


/*
 * message handling
 */
static void
log_message(
	int		level,
	char		*fmt, ...)
{
	char		buf[1024];
	va_list		ap;

	if (log_level < level)
		return;

	va_start(ap, fmt);
	vsnprintf(buf, 1024, fmt, ap);
	va_end(ap);

	printf("%c%s: %s\n", poll_output ? '\n' : '\r', progname, buf);
	poll_output = 0;
}

static void
err_message(
	char		*fmt, ...)
{
	char		buf[1024];
	va_list		ap;

	va_start(ap, fmt);
	vsnprintf(buf, 1024, fmt, ap);
	va_end(ap);

	fprintf(stderr, "%c%s: %s\n", poll_output ? '\n' : '\r', progname, buf);
	poll_output = 0;
}

static void
err_nomem(void)
{
	err_message(_("Out of memory"));
}

static void
err_open(
	const char	*s)
{
	err_message(_("Cannot open %s: %s"), s, strerror(errno));
}

static void
err_not_xfs(
	const char	*s)
{
	err_message(_("%s is not on an XFS filesystem"), s);
}

static void
err_stat(
	const char	*s)
{
	err_message(_("Cannot stat %s: %s\n"), s, strerror(errno));
}

static void
err_swapino(
	    int err,
	    const char *srcname)
{
	if (log_level >= LOG_DEBUG) {
		switch (err) {
		case EIO:
			err_message(_("Filesystem is going down: %s: %s"),
				srcname, strerror(err));
			break;

		default:
			err_message(_("Swap inode failed: %s: %s"),
				srcname, strerror(err));
			break;
		}
	} else
		err_message(_("Swap inode failed: %s: %s"),
				srcname, strerror(err));
}

static void
err_swapext(
	    int err,
	    const char *srcname,
	    xfs_off_t bs_size)
{
	if (log_level >= LOG_DEBUG) {
		switch (err) {
		case ENOTSUP:
			err_message("%s: file type not supported",
				srcname);
			break;
		case EFAULT:
			/* The file has changed since we started the copy */
			err_message("%s: file modified, "
				 "inode renumber aborted: %ld",
				 srcname, bs_size);
			break;
		case EBUSY:
			/* Timestamp has changed or mmap'ed file */
			err_message("%s: file busy", srcname);
			break;
		default:
			err_message(_("Swap extents failed: %s: %s"),
				srcname, strerror(errno));
			break;
		}
	} else
		err_message(_("Swap extents failed: %s: %s"),
				srcname, strerror(errno));
}

/*
 * usage message
 */
static void
usage(void)
{
	fprintf(stderr, _("%s [-fnpqv] [-P <interval>] [-r] <path>\n"),
			progname);
	exit(1);
}


/*
 * XFS interface functions
 */

static int
xfs_bulkstat_single(int fd, xfs_ino_t *lastip, xfs_bstat_t *ubuffer)
{
	xfs_fsop_bulkreq_t  bulkreq;

	bulkreq.lastip = (__u64 *)lastip;
	bulkreq.icount = 1;
	bulkreq.ubuffer = ubuffer;
	bulkreq.ocount = NULL;
	return ioctl(fd, XFS_IOC_FSBULKSTAT_SINGLE, &bulkreq);
}

static int
xfs_swapext(int fd, xfs_swapext_t *sx)
{
	return ioctl(fd, XFS_IOC_SWAPEXT, sx);
}

static int
xfs_get_agflags(const char *filepath)
{
  xfs_fsop_geom_t fsgeo;
  xfs_ioc_agflags_t	ioc_flags;
  int error = 0;
  xfs_agnumber_t agno;

  int fd;

  if ((fd = open(filepath, O_RDONLY /* | O_DIRECT | O_NOATIME */)) == -1) {
    err_open(filepath);
    return -1;
    }

  if ((error = xfsctl(filepath, fd, XFS_IOC_FSGEOMETRY, &fsgeo)) < 0) {
	  fprintf(stderr, _("cannot get geometry of fs: %s\n"),
		  strerror(errno));
	  goto error0; 
  }

  agmask = (int *) calloc(fsgeo.agcount, sizeof(int));

  for (agno = 0; agno < fsgeo.agcount ; agno++) {
    ioc_flags.ag = agno;
			
    if ((error = xfsctl(filepath, fd, XFS_IOC_GET_AGF_FLAGS, &ioc_flags)) < 0) {
		fprintf(stderr,
			_("cannot get flags %d on ag %d at %s: %s\n"),
			ioc_flags.flags,
			ioc_flags.ag, filepath, strerror(errno));

		return error;
	}

	agmask[agno] = ioc_flags.flags & XFS_AGF_FLAGS_ALLOC_DENY;
  }

error0:
  close(fd);

  return error;
}

static int
xfs_swapino(int fd, xfs_swapino_t *iu)
{
	return ioctl(fd, XFS_IOC_SWAPINO, iu);
}

static int
xfs_getxattr(int fd, struct fsxattr *attr)
{
	return ioctl(fd, XFS_IOC_FSGETXATTR, attr);
}

/*
 * A hash table of inode numbers and associated paths.
 */
static nodelist_t *
init_nodehash(void)
{
	nodehash = calloc(NH_BUCKETS, sizeof(nodelist_t));
	if (nodehash == NULL) {
		err_nomem();
		return NULL;
	}

	return nodehash;
}

static int
in_ag_to_free(const char *filepath) {
  xfs_ioc_fileag_t fileag;

  int error;

  if ((fileag.fd = open(filepath, O_RDONLY /* | O_DIRECT | O_NOATIME */)) == -1) {
    err_open(filepath);
    return -1;
    }

  if ((error = xfsctl(filepath, fileag.fd, XFS_IOC_GETFILEAG, &fileag)) < 0) {
    fprintf(stderr, _("%s: cannot get the AG of the file: %s\n"),
		  filepath, strerror(errno));
    close(fileag.fd);
    return error;
  }

  close(fileag.fd);

  if (agmask[fileag.ag] == 1) 
    printf("AG: %d, MASK: %d\t", fileag.ag, agmask[fileag.ag]);

  return agmask[fileag.ag];
}

static void
free_nodehash(void)
{
	int		i, j, k;

	for (i = 0; i < NH_BUCKETS; i++) {
		bignode_t *nodes = nodehash[i].nodes;

		for (j = 0; j < nodehash[i].lastnode; j++) {
			for (k = 0; k < nodes[j].numpaths; k++) {
				free(nodes[j].paths[k]);
			}
			free(nodes[j].paths);
		}

		free(nodes);
	}
	free(nodehash);
}

static nlink_t
add_path(
	bignode_t	*node,
	const char	*path)
{
	node->paths = realloc(node->paths,
			      sizeof(char *) * (node->numpaths + 1));
	if (node->paths == NULL) {
		err_nomem();
		exit(1);
	}

	node->paths[node->numpaths] = strdup(path);
	if (node->paths[node->numpaths] == NULL) {
		err_nomem();
		exit(1);
	}

	node->numpaths++;
	if (node->numpaths > highest_numpaths)
		highest_numpaths = node->numpaths;

	return node->numpaths;
}

static bignode_t *
add_node(
	nodelist_t	*list,
	xfs_ino_t	ino,
	int		ftw_flags,
	const char	*path)
{
	bignode_t	*node;

	if (list->lastnode >= list->listlen) {
		list->listlen += 500;
		list->nodes = realloc(list->nodes,
					sizeof(bignode_t) * list->listlen);
		if (list->nodes == NULL) {
			err_nomem();
			return NULL;
		}
	}

	node = list->nodes + list->lastnode;

	node->ino = ino;
	node->ftw_flags = ftw_flags;
	node->paths = NULL;
	node->numpaths = 0;
	add_path(node, path);

	list->lastnode++;

	return node;
}

static bignode_t *
find_node(
	xfs_ino_t	ino)
{
	int		i;
	nodelist_t	*nodelist;
	bignode_t	*nodes;

	nodelist = NH_HASH(ino);
	nodes = nodelist->nodes;

	for(i = 0; i < nodelist->lastnode; i++) {
		if (nodes[i].ino == ino) {
			return &nodes[i];
		}
	}

	return NULL;
}

static bignode_t *
add_node_path(
	xfs_ino_t	ino,
	int		ftw_flags,
	const char	*path)
{
	nodelist_t	*nodelist;
	bignode_t	*node;

	log_message(LOG_NITTY, "add_node_path: ino %llu, path %s", ino, path);

	node = find_node(ino);
	if (node == NULL) {
		nodelist = NH_HASH(ino);
		return add_node(nodelist, ino, ftw_flags, path);
	}

	add_path(node, path);
	return node;
}

static void
dump_node(
	char		*msg,
	bignode_t	*node)
{
	int		k;

	if (log_level < LOG_DEBUG)
		return;

	log_message(LOG_DEBUG, "%s: %llu %llu %s", msg, node->ino,
			node->numpaths, node->paths[0]);

	for (k = 1; k < node->numpaths; k++)
		log_message(LOG_DEBUG, "\t%s", node->paths[k]);
}

static void
dump_nodehash(void)
{
	int		i, j;

	if (log_level < LOG_NITTY)
		return;

	for (i = 0; i < NH_BUCKETS; i++) {
		bignode_t	*nodes = nodehash[i].nodes;
		for (j = 0; j < nodehash[i].lastnode; j++, nodes++)
			dump_node("nodehash", nodes);
	}
}

static int
for_all_nodes(
	int		(*fn)(bignode_t *node),
	int		ftw_flags,
	int		quit_on_error)
{
	int		i;
	int		j;
	int		rval = 0;

	for (i = 0; i < NH_BUCKETS; i++) {
		bignode_t	*nodes = nodehash[i].nodes;

		for (j = 0; j < nodehash[i].lastnode; j++, nodes++) {
			if (nodes->ftw_flags == ftw_flags) {
				rval = fn(nodes);
				if (rval && quit_on_error)
					goto quit;
			}
		}
	}

quit:
	return rval;
}

/*
 * Adds appropriate files to the inode hash table
 */
static int
nftw_addnodes(
	const char	*path,
	const struct stat64 *st,
	int		flags,
	struct FTW	*sntfw)
{
	if (flags == FTW_F || flags == FTW_D) 
        if (!in_ag_to_free(path) && !force_all)
		    return 0;

    printf("%s\n", path);

	if (flags == FTW_F)
		numfilenodes++;
	else if (flags == FTW_D)
		numdirnodes++;
	else if (flags == FTW_SL)
		numslinknodes++;
	else
		return 0;

	add_node_path(st->st_ino, flags, path);

	return 0;
}

static int
process_dir(
	bignode_t	*node)
{
	int		sfd = -1;
	int		tfd = -1;
	int		rval = 0;
	struct stat64	st;
	char		*srcname = NULL;
	char		*pname = NULL;
	xfs_swapino_t	si;
	xfs_swapext_t	sx;
	xfs_bstat_t	bstatbuf;
	struct fsxattr	fsx;
	char		target[PATH_MAX] = "";

	SET_PHASE(DIR_PHASE);

	dump_node("directory", node);

	cur_node = node;
	srcname = node->paths[0];

	bzero(&st, sizeof(st));
	bzero(&bstatbuf, sizeof(bstatbuf));
	bzero(&si, sizeof(si));
	bzero(&sx, sizeof(sx));

	if (stat64(srcname, &st) < 0) {
		if (errno != ENOENT) {
			err_stat(srcname);
			global_rval |= 2;
		}
		goto quit;
	}
	if (!in_ag_to_free(srcname) && !force_all) {
		/*
		 * This directory has already changed ino's, probably due
		 * to being moved during processing of a parent directory.
		 */
		log_message(LOG_DEBUG, "process_dir: skipping %s", srcname);
		goto quit;
	}

	rval = 1;

	sfd = open(srcname, O_RDONLY);
	if (sfd == -1) {
		err_open(srcname);
		goto quit;
	}

	if (!platform_test_xfs_fd(sfd)) {
		err_not_xfs(srcname);
		goto quit;
	}

	if (xfs_getxattr(sfd, &fsx) < 0) {
		err_message(_("failed to get inode attrs: %s"), srcname);
		goto quit;
	}
	if (fsx.fsx_xflags & (XFS_XFLAG_IMMUTABLE | XFS_XFLAG_APPEND)) {
		err_message(_("%s: immutable/append, ignoring"), srcname);
		global_rval |= 2;
		goto quit;
	}

	if (realuid != 0 && realuid != st.st_uid) {
		errno = EACCES;
		err_open(srcname);
		goto quit;
	}

	/* mkdir parent/target */
	pname = strdup(srcname);
	if (pname == NULL) {
		err_nomem();
		goto quit;
	}
	dirname(pname);
	sprintf(target, "%s/%sXXXXXX", pname, cmd_prefix);
	if (mkdtemp(target) == NULL) {
		err_message(_("Unable to create directory copy: %s, %s"), srcname, strerror(errno));
		goto quit;
	}
	tfd = open(target, O_RDONLY);
	if (tfd == -1) {
		err_open(target);
		goto quit;
	}

	cur_target = strdup(target);
	if (!cur_target) {
		err_nomem();
		goto quit;
	}

	SET_PHASE(DIR_PHASE_1);

	/* swapino src target */
	si.si_version  = XFS_SI_VERSION;
	si.si_fdtarget = tfd;
	si.si_fdtmp    = sfd;

	/* swap the inodes */
	rval = xfs_swapino(tfd, &si);
	if (rval < 0) {
		err_swapino(rval, srcname);
		goto quit_unlink;
	}

	if (xfs_bulkstat_single(sfd, &st.st_ino, &bstatbuf) < 0) {
		err_message(_("unable to bulkstat source file: %s"),
				srcname);
		unlink(target);
		goto quit;
	}

	if (bstatbuf.bs_ino != st.st_ino) {
		err_message(_("bulkstat of source file returned wrong inode: %s"),
				srcname);
		unlink(target);
		goto quit;
	}

	ftruncate64(tfd, bstatbuf.bs_size);

	/* swapextents src target */
	sx.sx_stat     = bstatbuf; /* struct copy */
	sx.sx_version  = XFS_SX_VERSION;
	sx.sx_fdtarget = sfd;
	sx.sx_fdtmp    = tfd;
	sx.sx_offset   = 0;
	sx.sx_length   = bstatbuf.bs_size;

	/* Swap the extents */
	rval = xfs_swapext(sfd, &sx);
	if (rval < 0) {
		err_swapext(rval, srcname, bstatbuf.bs_size);
		goto quit_unlink;
	}

	SET_PHASE(DIR_PHASE_2);

	/* rmdir src */
	rval = rmdir(srcname);
	if (rval != 0) {
		err_message(_("unable to remove directory: %s, %s"), srcname, strerror(errno));
		goto quit;
	}

	SET_PHASE(DIR_PHASE_3);

	/* rename cur_target src */
	rval = rename(target, srcname);
	if (rval != 0) {
		/*
		 * we can't abort since the src dir is now gone.
		 * let the admin clean this one up
		 */
		err_message(_("unable to rename directory: %s to %s, %s"),
				cur_target, srcname, strerror(errno));
	}
	goto quit;

 quit_unlink:
	rval = rmdir(target);
	if (rval != 0)
		err_message(_("unable to remove directory: %s, %s"), target, strerror(errno));

 quit:

	SET_PHASE(DIR_PHASE);

	if (sfd >= 0)
		close(sfd);
	if (tfd >= 0)
		close(tfd);

	free(pname);
	free(cur_target);

	cur_target = NULL;
	cur_node = NULL;

	numdirsdone++;
	return rval;
}

static int
process_file(
	bignode_t	*node)
{
	int		sfd = -1;
	int		tfd = -1;
	int		i = 0;
	int		rval = 0;
	struct stat64	st;
	char		*srcname = NULL;
	char		*pname = NULL;
	xfs_swapino_t	si;
	xfs_swapext_t	sx;
	xfs_bstat_t	bstatbuf;
	struct fsxattr	fsx;
	char		target[PATH_MAX] = "";

	SET_PHASE(FILE_PHASE);

	dump_node("file", node);

	cur_node = node;
	srcname = node->paths[0];

	bzero(&st, sizeof(st));
	bzero(&bstatbuf, sizeof(bstatbuf));
	bzero(&si, sizeof(si));
	bzero(&sx, sizeof(sx));

	if (stat64(srcname, &st) < 0) {
		if (errno != ENOENT) {
			err_stat(srcname);
			global_rval |= 2;
		}
		goto quit;
	}
	if (!in_ag_to_free(srcname) && !force_all)
		/* this file has changed, and no longer needs processing */
		goto quit;

	rval = 1;
	/* open and sync source */
	sfd = open(srcname, O_RDWR | O_DIRECT);
	if (sfd < 0) {
		err_open(srcname);
		goto quit;
	}
	if (!platform_test_xfs_fd(sfd)) {
		err_not_xfs(srcname);
		goto quit;
	}
	if (fsync(sfd) < 0) {
		err_message(_("sync failed: %s: %s"),
				srcname, strerror(errno));
		goto quit;
	}


	/*
	 * Check if a mandatory lock is set on the file to try and
	 * avoid blocking indefinitely on the reads later. Note that
	 * someone could still set a mandatory lock after this check
	 * but before all reads have completed to block xfs_reno reads.
	 * This change just closes the window a bit.
	 */
	if ((st.st_mode & S_ISGID) && !(st.st_mode & S_IXGRP)) {
		struct flock fl;

		fl.l_type = F_RDLCK;
		fl.l_whence = SEEK_SET;
		fl.l_start = (off_t)0;
		fl.l_len = 0;
		if (fcntl(sfd, F_GETLK, &fl) < 0 ) {
			if (log_level >= LOG_DEBUG)
				err_message("locking check failed: %s",
						srcname);
			global_rval |= 2;
			goto quit;
		}
		if (fl.l_type != F_UNLCK) {
			if (log_level >= LOG_DEBUG)
				err_message("mandatory lock: %s: ignoring",
						srcname);
			global_rval |= 2;
			goto quit;
		}
	}

	if (xfs_getxattr(sfd, &fsx) < 0) {
		err_message(_("failed to get inode attrs: %s"), srcname);
		goto quit;
	}
	if (fsx.fsx_xflags & (XFS_XFLAG_IMMUTABLE | XFS_XFLAG_APPEND)) {
		err_message(_("%s: immutable/append, ignoring"), srcname);
		global_rval |= 2;
		goto quit;
	}

	if (realuid != 0 && realuid != st.st_uid) {
		errno = EACCES;
		err_open(srcname);
		goto quit;
	}

	/* creat target */
	pname = strdup(srcname);
	if (pname == NULL) {
		err_nomem();
		goto quit;
	}
	dirname(pname);

	sprintf(target, "%s/%sXXXXXX", pname, cmd_prefix);
	tfd = mkstemp(target);
	if (tfd == -1) {
		err_message("unable to create file copy: %s", strerror(errno));
		goto quit;
	}
	cur_target = strdup(target);
	if (cur_target == NULL) {
		err_nomem();
		goto quit;
	}

	SET_PHASE(FILE_PHASE_1);

	/* swapino src target */
	si.si_version  = XFS_SI_VERSION;
	si.si_fdtarget = sfd;
	si.si_fdtmp    = tfd;

	/* swap the inodes */
	rval = xfs_swapino(sfd, &si);
	if (rval < 0) {
		err_swapino(rval, srcname);
		goto quit_unlink;
	}

	if (xfs_bulkstat_single(sfd, &st.st_ino, &bstatbuf) < 0) {
		err_message(_("unable to bulkstat source file: %s"),
				srcname);
		unlink(target);
		goto quit;
	}

	if (bstatbuf.bs_ino != st.st_ino) {
		err_message(_("bulkstat of source file returned wrong inode: %s"),
				srcname);
		unlink(target);
		goto quit;
	}

	ftruncate64(tfd, bstatbuf.bs_size);

	/* swapextents src target */
	sx.sx_stat     = bstatbuf; /* struct copy */
	sx.sx_version  = XFS_SX_VERSION;
	sx.sx_fdtarget = sfd;
	sx.sx_fdtmp    = tfd;
	sx.sx_offset   = 0;
	sx.sx_length   = bstatbuf.bs_size;

	/* Swap the extents */
	rval = xfs_swapext(sfd, &sx);
	if (rval < 0) {
		err_swapext(rval, srcname, bstatbuf.bs_size);
		goto quit_unlink;
	}

	SET_PHASE(FILE_PHASE_2);

	/* unlink src */
	rval = unlink(srcname);
	if (rval != 0) {
		err_message(_("unable to remove file: %s, %s"), srcname, strerror(errno));
		goto quit;
	}

	SET_PHASE(FILE_PHASE_3);

	/* rename target src */
	rval = rename(target, srcname);
	if (rval != 0) {
		/*
		 * we can't abort since the src file is now gone.
		 * let the admin clean this one up
		 */
		err_message(_("unable to rename file: %s to %s, %s"),
				target, srcname, strerror(errno));
		goto quit;
	}

	SET_PHASE(FILE_PHASE_4);

	/* for each hardlink, unlink and creat pointing to target */
	for (i = 1; i < node->numpaths; i++) {
		/* unlink src */
		rval = unlink(node->paths[i]);
		if (rval != 0) {
			err_message(_("unable to remove file: %s, %s"),
				       node->paths[i], strerror(errno));
			goto quit;
		}

		rval = link(srcname, node->paths[i]);
		if (rval != 0) {
			err_message("unable to link to file: %s, %s", srcname, strerror(errno));
			goto quit;
		}
		numfilesdone++;
	}

 quit_unlink:
	rval = unlink(target);
	if (rval != 0)
		err_message(_("unable to remove file: %s, %s"), target, strerror(errno));

 quit:

	SET_PHASE(FILE_PHASE);

	if (sfd >= 0)
		close(sfd);
	if (tfd >= 0)
		close(tfd);

	free(pname);
	free(cur_target);

	cur_target = NULL;
	cur_node = NULL;

	numfilesdone++;
	return rval;
}


static int
process_slink(
	bignode_t	*node)
{
	int		i = 0;
	int		sfd = -1;
	int		tfd = -1;
	int		rval = 0;
	struct stat64	st;
	char		*srcname = NULL;
	char		*pname = NULL;
	char		target[PATH_MAX] = "";
	char		linkbuf[PATH_MAX];
	xfs_swapino_t	si;

	SET_PHASE(SLINK_PHASE);

	dump_node("symlink", node);

	cur_node = node;
	srcname = node->paths[0];

	bzero(&st, sizeof(st));
	bzero(&si, sizeof(si));

	if (lstat64(srcname, &st) < 0) {
		if (errno != ENOENT) {
			err_stat(srcname);
			global_rval |= 2;
		}
		goto quit;
	}

	rval = 1;

	/* open source */
	sfd = open(srcname, O_RDWR | O_DIRECT);
	if (sfd < 0) {
		err_open(srcname);
		goto quit;
	}

	i = readlink(srcname, linkbuf, sizeof(linkbuf) - 1);
	if (i < 0) {
		err_message(_("unable to read symlink: %s, %s"), srcname, strerror(errno));
		goto quit;
	}
	linkbuf[i] = '\0';

	if (realuid != 0 && realuid != st.st_uid) {
		errno = EACCES;
		err_open(srcname);
		goto quit;
	}

	/* create target */
	pname = strdup(srcname);
	if (pname == NULL) {
		err_nomem();
		goto quit;
	}
	dirname(pname);

	sprintf(target, "%s/%sXXXXXX", pname, cmd_prefix);
	tfd = mkstemp(target);
	if (tfd == -1) {
		err_message(_("unable to create temp symlink name: %s"), strerror(errno));
		goto quit;
	}
	cur_target = strdup(target);
	if (cur_target == NULL) {
		err_nomem();
		goto quit;
	}

	if (symlink(linkbuf, target) != 0) {
		err_message(_("unable to create symlink: %s, %s"), target, strerror(errno));
		goto quit;
	}

	SET_PHASE(SLINK_PHASE_1);

	/* swapino src target */
	si.si_version  = XFS_SI_VERSION;
	si.si_fdtarget = sfd;
	si.si_fdtmp    = tfd;

	/* swap the inodes */
	rval = xfs_swapino(sfd, &si);
	if (rval < 0) {
		err_swapino(rval, srcname);
		goto quit;
	}

	SET_PHASE(SLINK_PHASE_2);

	/* unlink src */
	rval = unlink(srcname);
	if (rval != 0) {
		err_message(_("unable to remove symlink: %s, %s"), srcname, strerror(errno));
		goto quit;
	}

	SET_PHASE(SLINK_PHASE_3);

	/* rename target src */
	rval = rename(target, srcname);
	if (rval != 0) {
		/*
		 * we can't abort since the src file is now gone.
		 * let the admin clean this one up
		 */
		err_message(_("unable to rename symlink: %s to %s, %s"),
				target, srcname, strerror(errno));
		goto quit;
	}

	SET_PHASE(SLINK_PHASE_4);

	/* for each hardlink, unlink and creat pointing to target */
	for (i = 1; i < node->numpaths; i++) {
		/* unlink src */
		rval = unlink(node->paths[i]);
		if (rval != 0) {
			err_message(_("unable to remove symlink: %s, %s"),
				       node->paths[i], strerror(errno));
			goto quit;
		}

		rval = link(srcname, node->paths[i]);
		if (rval != 0) {
			err_message("unable to link to symlink: %s, %s", srcname, strerror(errno));
			goto quit;
		}
		numslinksdone++;
	}

 quit:
	cur_node = NULL;

	SET_PHASE(SLINK_PHASE);

	free(pname);
	free(cur_target);

	cur_target = NULL;

	numslinksdone++;
	return rval;
}

static int
open_recoverfile(void)
{
	recover_fd = open(recover_file, O_RDWR | O_SYNC | O_CREAT | O_EXCL,
			0600);
	if (recover_fd < 0) {
		if (errno == EEXIST)
			err_message(_("Recovery file already exists, either "
				"run '%s -r %s' or remove the file."),
				progname, recover_file);
		else
			err_open(recover_file);
		return 1;
	}

	if (!platform_test_xfs_fd(recover_fd)) {
		err_not_xfs(recover_file);
		close(recover_fd);
		return 1;
	}

	return 0;
}

static void
update_recoverfile(void)
{
	static const char null_file[] = "0\n0\n0\n\ntarget: \ntemp: \nend\n";
	static size_t	buf_size = 0;
	static char	*buf = NULL;
	int		i, len;

	if (recover_fd <= 0)
		return;

	if (cur_node == NULL || cur_phase == 0) {
		/* inbetween processing or still scanning */
		lseek(recover_fd, 0, SEEK_SET);
		write(recover_fd, null_file, sizeof(null_file));
		return;
	}

	ASSERT(highest_numpaths > 0);
	if (buf == NULL) {
		buf_size = (highest_numpaths + 3) * PATH_MAX;
		buf = malloc(buf_size);
		if (buf == NULL) {
			err_nomem();
			exit(1);
		}
	}

	len = sprintf(buf, "%d\n%llu\n%d\n", cur_phase,
			(long long)cur_node->ino, cur_node->ftw_flags);

	for (i = 0; i < cur_node->numpaths; i++)
		len += sprintf(buf + len, "%s\n", cur_node->paths[i]);

/*	len += sprintf(buf + len, "target: %s\ntemp: %s\nend\n", */
/*			cur_target, cur_temp); */

	ASSERT(len < buf_size);

	lseek(recover_fd, 0, SEEK_SET);
	ftruncate(recover_fd, 0);
	write(recover_fd, buf, len);
}

static void
cleanup(void)
{
	log_message(LOG_NORMAL, _("Interrupted -- cleaning up..."));

	free_nodehash();

	log_message(LOG_NORMAL, _("Done."));
}

static void
sighandler(int sig)
{
	static char	cycle[4] = "-\\|/";
	static uint64_t	cur_cycle = 0;
	double		percent;
	char		*typename;
	uint64_t	nodes, done;

	alarm(0);

	if (sig != SIGALRM) {
		cleanup();
		exit(1);
	}

	if (cur_phase == SCAN_PHASE) {
		if (log_level >= LOG_INFO)
			fprintf(stderr, _("\r%llu files, %llu dirs and %llu "
				"symlinks to renumber found... %c"),
				(long long)numfilenodes,
				(long long)numdirnodes,
				(long long)numslinknodes,
				cycle[cur_cycle % 4]);
		else
			fprintf(stderr, "\r%c",
				cycle[cur_cycle % 4]);
		cur_cycle++;
	} else {
		if (cur_phase >= DIR_PHASE && cur_phase <= DIR_PHASE_MAX) {
			nodes = numdirnodes;
			done = numdirsdone;
			typename = _("dirs");
		} else
		if (cur_phase >= FILE_PHASE && cur_phase <= FILE_PHASE_MAX) {
			nodes = numfilenodes;
			done = numfilesdone;
			typename = _("files");
		} else {
			nodes = numslinknodes;
			done = numslinksdone;
			typename = _("symlinks");
		}
		percent = 100.0 * (double)done / (double)nodes;
		if (percent > 100.0)
			percent = 100.0;
		if (log_level >= LOG_INFO)
			fprintf(stderr, _("\r%.1f%%, %llu of %llu %s, "
					"%u seconds elapsed"), percent,
					(long long)done, (long long)nodes,
					typename, (int)(time(0) - starttime));
		else
			fprintf(stderr, "\r%.1f%%", percent);
	}
	poll_output = 1;
	signal(SIGALRM, sighandler);

	if (poll_interval)
		alarm(poll_interval);
}

static int
read_recover_file(
	char		*recover_file,
	bignode_t	**node,
	char		**target,
	char		**temp,
	int		*phase)
{
	FILE		*file;
	int		rval = 1;
	ino_t		ino;
	int		ftw_flags;
	char		buf[PATH_MAX + 10]; /* path + "target: " */
	struct stat64	st;
	int		first_path;

	/*

	A recovery file should look like:

	<phase>
	<ino number>
	<ftw flags>
	<first path to inode>
	<hardlinks to inode>
	target: <path to target dir or file>
	temp: <path to temp dir if dir phase>
	end
	*/

	file = fopen(recover_file, "r");
	if (file == NULL) {
		err_open(recover_file);
		return 1;
	}

	/* read phase */
	*phase = 0;
	if (fgets(buf, PATH_MAX + 10, file) == NULL) {
		err_message("Recovery failed: unable to read phase");
		goto quit;
	}
	buf[strlen(buf) - 1] = '\0';
	*phase = atoi(buf);
	if (*phase == SCAN_PHASE) {
		fclose(file);
		return 0;
	}
	if ((*phase < DIR_PHASE || *phase > DIR_PHASE_MAX) &&
			(*phase < FILE_PHASE || *phase > FILE_PHASE_MAX)) {
		err_message("Recovery failed: failed to read valid recovery phase");
		goto quit;
	}

	/* read inode number */
	if (fgets(buf, PATH_MAX + 10, file) == NULL) {
		err_message("Recovery failed: unable to read inode number");
		goto quit;
	}
	buf[strlen(buf) - 1] = '\0';
	ino = strtoull(buf, NULL, 10);
	if (ino == 0) {
		err_message("Recovery failed: unable to read inode number");
		goto quit;
	}

	/* read ftw_flags */
	if (fgets(buf, PATH_MAX + 10, file) == NULL) {
		err_message("Recovery failed: unable to read flags");
		goto quit;
	}
	buf[strlen(buf) - 1] = '\0';
	if (buf[1] != '\0' || (buf[0] != '0' && buf[0] != '1')) {
		err_message("Recovery failed: unable to read flags: '%s'", buf);
		goto quit;
	}
	ftw_flags = atoi(buf);

	/* read paths and target path */
	*node = NULL;
	*target = NULL;
	first_path = 1;
	while (fgets(buf, PATH_MAX + 10, file) != NULL) {
		buf[strlen(buf) - 1] = '\0';

		log_message(LOG_DEBUG, "path: '%s'", buf);

		if (buf[0] == '/') {
			if (stat64(buf, &st) < 0) {
				err_message(_("Recovery failed: cannot "
						"stat '%s'"), buf);
				goto quit;
			}
			if (st.st_ino != ino) {
				err_message(_("Recovery failed: inode "
						"number for '%s' does not "
						"match recorded number"), buf);
				goto quit;
			}

			if (first_path) {
				first_path = 0;
				*node = add_node_path(ino, ftw_flags, buf);
			}
			else {
				add_path(*node, buf);
			}
		}
		else if (strncmp(buf, "target: ", 8) == 0) {
			*target = strdup(buf + 8);
			if (*target == NULL) {
				err_nomem();
				goto quit;
			}
			if (stat64(*target, &st) < 0) {
				err_message(_("Recovery failed: cannot "
						"stat '%s'"), *target);
				goto quit;
			}
		}
		else if (strncmp(buf, "temp: ", 6) == 0) {
			*temp = strdup(buf + 6);
			if (*temp == NULL) {
				err_nomem();
				goto quit;
			}
		}
		else if (strcmp(buf, "end") == 0) {
			rval = 0;
			goto quit;
		}
		else {
			err_message(_("Recovery failed: unrecognised "
					"string: '%s'"), buf);
			goto quit;
		}
	}

	err_message(_("Recovery failed: end of recovery file not found"));

 quit:
	if (*node == NULL) {
		err_message(_("Recovery failed: no valid inode or paths "
				"specified"));
		rval = 1;
	}

	if (*target == NULL) {
		err_message(_("Recovery failed: no inode target specified"));
		rval = 1;
	}

	fclose(file);

	return rval;
}

int
recover(
	bignode_t	*node,
	char		*target,
	char		*tname,
	int		phase)
{
	char		*srcname = NULL;
	int		rval = 0;
	int		i;
	int		dir;

	dump_node("recover", node);
	log_message(LOG_DEBUG, "target: %s, phase: %x", target, phase);

	if (node)
		srcname = node->paths[0];

	dir = (phase < DIR_PHASE || phase > DIR_PHASE_MAX);

	switch (phase) {

	case DIR_PHASE_1:
	case FILE_PHASE_1:
	case SLINK_PHASE_1:
		log_message(LOG_NORMAL, _("Unlinking temporary %s: \'%s\'"),
			    dir ? "directory" : "file", target);

		rval = dir ? rmdir(target) : unlink(target);

		if ( rval < 0 && errno != ENOENT)
			err_message(_("unable to remove %s: %s, %s"),
				    dir ? "directory" : "file", target, strerror(errno));

		break;

	case DIR_PHASE_2:
	case FILE_PHASE_2:
	case SLINK_PHASE_2:
		log_message(LOG_NORMAL, _("Unlinking old %s: \'%s\'"),
				dir ? "directory" : "file", srcname);

		rval = dir ? rmdir(target) : unlink(srcname);

		if (rval < 0 && errno != ENOENT) {
			err_message(_("unable to remove %s: %s, %s"), 
				    dir ? "directory" : "file", srcname, strerror(errno));
			break;
		}
		/* FALL THRU */
	case DIR_PHASE_3:
	case FILE_PHASE_3:
	case SLINK_PHASE_3:
		log_message(LOG_NORMAL, _("Renaming: "
				"\'%s\' -> \'%s\'"), target, srcname);
		rval = rename(target, srcname);
		if (rval != 0) {
			/* we can't abort since the src file is now gone.
			 * let the admin clean this one up
			 */
			err_message(_("unable to rename: %s to %s, %s"),
					target, srcname, strerror(errno));
			break;
		}
		if (dir)
			break;
		/* FALL THRU */
	case FILE_PHASE_4:
	case SLINK_PHASE_4:
		/* for each hardlink, unlink and creat pointing to target */
		for (i = 1; i < node->numpaths; i++) {
			if (i == 1)
				log_message(LOG_NORMAL, _("Resetting hardlinks "
						"to new file"));

			rval = unlink(node->paths[i]);
			if (rval != 0) {
				err_message(_("unable to remove file: %s, %s"),
						node->paths[i], strerror(errno));
				break;
			}
			rval = link(srcname, node->paths[i]);
			if (rval != 0) {
				err_message(_("unable to link to file: %s, %s"),
						srcname, strerror(errno));
				break;
			}
		}
		break;
	}

	if (rval == 0) {
		log_message(LOG_NORMAL, _("Removing recover file: \'%s\'"),
				recover_file);
		unlink(recover_file);
		log_message(LOG_NORMAL, _("Recovery done."));
	}
	else {
		log_message(LOG_NORMAL, _("Leaving recover file: \'%s\'"),
				recover_file);
		log_message(LOG_NORMAL, _("Recovery failed."));
	}

	return rval;
}

int
main(
	int		argc,
	char		*argv[])
{
	int		c = 0;
	int		rval = 0;
	int		q_opt = 0;
	int		v_opt = 0;
	int		p_opt = 0;
	int		n_opt = 0;
	char		pathname[PATH_MAX];
	struct stat64	st;

	progname = basename(argv[0]);

	setlocale(LC_ALL, "");
	bindtextdomain(PACKAGE, LOCALEDIR);
	textdomain(PACKAGE);

	while ((c = getopt(argc, argv, "fnpqvP:r:")) != -1) {
		switch (c) {
		case 'f':
			force_all = 1;
			break;
		case 'n':
			n_opt++;
			break;
		case 'p':
			p_opt++;
			break;
		case 'q':
			if (v_opt)
				err_message(_("'q' option incompatible "
						"with 'v' option"));
			q_opt++;
			log_level=0;
			break;
		case 'v':
			if (q_opt)
				err_message(_("'v' option incompatible "
						"with 'q' option"));
			v_opt++;
			log_level++;
			break;
		case 'P':
			poll_interval = atoi(optarg);
			break;
		case 'r':
			recover_file = optarg;
			break;
		default:
			err_message(_("%s: illegal option -- %c\n"), c);
			usage();
			/* NOTREACHED */
			break;
		}
	}

	if (optind != argc - 1 && recover_file == NULL) {
		usage();
		exit(1);
	}

	realuid = getuid();
	starttime = time(0);

	init_nodehash();

	signal(SIGALRM, sighandler);
	signal(SIGABRT, sighandler);
	signal(SIGHUP, sighandler);
	signal(SIGINT, sighandler);
	signal(SIGQUIT, sighandler);
	signal(SIGTERM, sighandler);

	if (p_opt && poll_interval == 0) {
		poll_interval = 1;
	}
	if (poll_interval)
		alarm(poll_interval);

	if (recover_file) {
		bignode_t	*node = NULL;
		char		*target = NULL;
		char		*tname = NULL;
		int		phase = 0;

		if (n_opt)
			goto quit;

		/* read node info from recovery file */
		if (read_recover_file(recover_file, &node, &target,
				&tname, &phase) != 0)
			exit(1);

		rval = recover(node, target, tname, phase);

		free(target);
		free(tname);

		return rval;
	}

	recover_file = malloc(PATH_MAX);
	if (recover_file == NULL) {
		err_nomem();
		exit(1);
	}
	recover_file[0] = '\0';

	strcpy(pathname, argv[optind]);
	if (pathname[0] != '/') {
		err_message(_("pathname must begin with a slash ('/')"));
		exit(1);
	}

	if (stat64(pathname, &st) < 0) {
		err_stat(pathname);
		exit(1);
	}
	if (S_ISREG(st.st_mode)) {
		/* single file specified */
		if (st.st_nlink > 1) {
			err_message(_("cannot process single file with a "
					"link count greater than 1"));
			exit(1);
		}

		strcpy(recover_file, pathname);
		dirname(recover_file);

		strcpy(recover_file + strlen(recover_file), "/xfs_reno.recover");
		if (!n_opt) {
			if (open_recoverfile() != 0)
				exit(1);
		}
		add_node_path(st.st_ino, FTW_F, pathname);
	}
	else if (S_ISDIR(st.st_mode)) {
		/* directory tree specified */
		strcpy(recover_file, pathname);

		strcpy(recover_file + strlen(recover_file), "/xfs_reno.recover");
		if (!n_opt) {
			if (open_recoverfile() != 0)
				exit(1);
		}

		/* directory scan */
		log_message(LOG_INFO, _("\rScanning directory tree..."));
		SET_PHASE(SCAN_PHASE);
	    if (xfs_get_agflags(pathname) != 0) {
            err_message(_("Could not get non-allocatable AGs info\n"));
            exit(1);
        }

		nftw64(pathname, nftw_addnodes, 100, FTW_PHYS | FTW_MOUNT);
	}
	else {
		err_message(_("pathname must be either a regular file "
				"or directory"));
		exit(1);
	}

	dump_nodehash();

	if (n_opt) {
		/* n flag set, don't do anything */
		if (numdirnodes)
			log_message(LOG_NORMAL, "\rWould process %d %s",
					numdirnodes, numdirnodes == 1 ?
						"directory" : "directories");
		else
			log_message(LOG_NORMAL, "\rNo directories to process");

		if (numfilenodes)
			/* process files */
			log_message(LOG_NORMAL, "\rWould process %d %s",
					numfilenodes, numfilenodes == 1 ?
						"file" : "files");
		else
			log_message(LOG_NORMAL, "\rNo files to process");
		if (numslinknodes)
			/* process files */
			log_message(LOG_NORMAL, "\rWould process %d %s",
					numslinknodes, numslinknodes == 1 ?
						"symlinx" : "symlinks");
		else
			log_message(LOG_NORMAL, "\rNo symlinks to process");
	} else {
		/* process directories */
		if (numdirnodes) {
			log_message(LOG_INFO, _("\rProcessing %d %s..."),
					numdirnodes, numdirnodes == 1 ?
					    _("directory") : _("directories"));
			cur_phase = DIR_PHASE;
			rval = for_all_nodes(process_dir, FTW_D, 1);
			if (rval != 0)
				goto quit;
		}
		else
			log_message(LOG_INFO, _("\rNo directories to process..."));

		if (numfilenodes) {
			/* process files */
			log_message(LOG_INFO, _("\rProcessing %d %s..."),
					numfilenodes, numfilenodes == 1 ?
						_("file") : _("files"));
			cur_phase = FILE_PHASE;
			for_all_nodes(process_file, FTW_F, 0);
		}
		else
			log_message(LOG_INFO, _("\rNo files to process..."));

		if (numslinknodes) {
			/* process symlinks */
			log_message(LOG_INFO, _("\rProcessing %d %s..."),
					numslinknodes, numslinknodes == 1 ?
						_("symlink") : _("symlinks"));
			cur_phase = SLINK_PHASE;
			for_all_nodes(process_slink, FTW_SL, 0);
		}
		else
			log_message(LOG_INFO, _("\rNo symlinks to process..."));

	}
quit:
	free_nodehash();

	close(recover_fd);

	if (rval == 0)
		unlink(recover_file);

	log_message(LOG_DEBUG, "\r%u seconds elapsed", time(0) - starttime);
	log_message(LOG_INFO, _("\rDone.     "));

	return rval | global_rval;
}

--=-4Da9GvHld0Grtgo95r+H--
