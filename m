Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41600 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbfEUQ60 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 May 2019 12:58:26 -0400
Date: Tue, 21 May 2019 09:58:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/12] misc: remove all use of xfs_fsop_geom_t
Message-ID: <20190521165822.GC5141@magnolia>
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
 <155839423901.68606.18360420363137361199.stgit@magnolia>
 <210bdf1c-646c-96dd-287d-929178a62b7d@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <210bdf1c-646c-96dd-287d-929178a62b7d@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Tue, May 21, 2019 at 11:43:43AM -0500, Eric Sandeen wrote:
> On 5/20/19 6:17 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Remove all the uses of the old xfs_fsop_geom_t typedef.
> 
> Ok.  Any complaint if I tab stuff out to line up again when I commit
> it, assuming it doesn't cause 80char problems?

None here.

--D

> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  growfs/xfs_growfs.c |    4 ++--
> >  io/init.c           |    2 +-
> >  io/io.h             |    6 +++---
> >  io/open.c           |    6 +++---
> >  man/man3/xfsctl.3   |    2 +-
> >  spaceman/file.c     |    4 ++--
> >  spaceman/init.c     |    2 +-
> >  spaceman/space.h    |    6 +++---
> >  8 files changed, 16 insertions(+), 16 deletions(-)
> > 
> > 
> > diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
> > index 392e4a00..ffd82f95 100644
> > --- a/growfs/xfs_growfs.c
> > +++ b/growfs/xfs_growfs.c
> > @@ -44,7 +44,7 @@ main(int argc, char **argv)
> >  	int			error;	/* we have hit an error */
> >  	long			esize;	/* new rt extent size */
> >  	int			ffd;	/* mount point file descriptor */
> > -	xfs_fsop_geom_t		geo;	/* current fs geometry */
> > +	struct xfs_fsop_geom	geo;	/* current fs geometry */
> >  	int			iflag;	/* -i flag */
> >  	int			isint;	/* log is currently internal */
> >  	int			lflag;	/* -l flag */
> > @@ -52,7 +52,7 @@ main(int argc, char **argv)
> >  	int			maxpct;	/* -m flag value */
> >  	int			mflag;	/* -m flag */
> >  	int			nflag;	/* -n flag */
> > -	xfs_fsop_geom_t		ngeo;	/* new fs geometry */
> > +	struct xfs_fsop_geom	ngeo;	/* new fs geometry */
> >  	int			rflag;	/* -r flag */
> >  	long long		rsize;	/* new rt size in fs blocks */
> >  	int			xflag;	/* -x flag */
> > diff --git a/io/init.c b/io/init.c
> > index 83f08f2d..7025aea5 100644
> > --- a/io/init.c
> > +++ b/io/init.c
> > @@ -133,7 +133,7 @@ init(
> >  	int		c, flags = 0;
> >  	char		*sp;
> >  	mode_t		mode = 0600;
> > -	xfs_fsop_geom_t	geometry = { 0 };
> > +	struct xfs_fsop_geom geometry = { 0 };
> >  	struct fs_path	fsp;
> >  
> >  	progname = basename(argv[0]);
> > diff --git a/io/io.h b/io/io.h
> > index 6469179e..0848ab98 100644
> > --- a/io/io.h
> > +++ b/io/io.h
> > @@ -38,7 +38,7 @@ typedef struct fileio {
> >  	int		fd;		/* open file descriptor */
> >  	int		flags;		/* flags describing file state */
> >  	char		*name;		/* file name at time of open */
> > -	xfs_fsop_geom_t	geom;		/* XFS filesystem geometry */
> > +	struct xfs_fsop_geom geom;	/* XFS filesystem geometry */
> >  	struct fs_path	fs_path;	/* XFS path information */
> >  } fileio_t;
> >  
> > @@ -70,9 +70,9 @@ extern void *check_mapping_range(mmap_region_t *, off64_t, size_t, int);
> >   */
> >  
> >  extern off64_t		filesize(void);
> > -extern int		openfile(char *, xfs_fsop_geom_t *, int, mode_t,
> > +extern int		openfile(char *, struct xfs_fsop_geom *, int, mode_t,
> >  				 struct fs_path *);
> > -extern int		addfile(char *, int , xfs_fsop_geom_t *, int,
> > +extern int		addfile(char *, int , struct xfs_fsop_geom *, int,
> >  				struct fs_path *);
> >  extern void		printxattr(uint, int, int, const char *, int, int);
> >  
> > diff --git a/io/open.c b/io/open.c
> > index 11805cd7..ce7a5362 100644
> > --- a/io/open.c
> > +++ b/io/open.c
> > @@ -51,7 +51,7 @@ static long extsize;
> >  int
> >  openfile(
> >  	char		*path,
> > -	xfs_fsop_geom_t	*geom,
> > +	struct xfs_fsop_geom *geom,
> >  	int		flags,
> >  	mode_t		mode,
> >  	struct fs_path	*fs_path)
> > @@ -156,7 +156,7 @@ int
> >  addfile(
> >  	char		*name,
> >  	int		fd,
> > -	xfs_fsop_geom_t	*geometry,
> > +	struct xfs_fsop_geom *geometry,
> >  	int		flags,
> >  	struct fs_path	*fs_path)
> >  {
> > @@ -229,7 +229,7 @@ open_f(
> >  	int		c, fd, flags = 0;
> >  	char		*sp;
> >  	mode_t		mode = 0600;
> > -	xfs_fsop_geom_t	geometry = { 0 };
> > +	struct xfs_fsop_geom geometry = { 0 };
> >  	struct fs_path	fsp;
> >  
> >  	if (argc == 1) {
> > diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
> > index 6e5027c4..462ccbd8 100644
> > --- a/man/man3/xfsctl.3
> > +++ b/man/man3/xfsctl.3
> > @@ -640,7 +640,7 @@ operations on XFS filesystems.
> >  For
> >  .B XFS_IOC_FSGEOMETRY
> >  (get filesystem mkfs time information), the output structure is of type
> > -.BR xfs_fsop_geom_t .
> > +.BR struct xfs_fsop_geom .
> >  For
> >  .B XFS_FS_COUNTS
> >  (get filesystem dynamic global information), the output structure is of type
> > diff --git a/spaceman/file.c b/spaceman/file.c
> > index d2acf5db..a9b8461f 100644
> > --- a/spaceman/file.c
> > +++ b/spaceman/file.c
> > @@ -44,7 +44,7 @@ print_f(
> >  int
> >  openfile(
> >  	char		*path,
> > -	xfs_fsop_geom_t	*geom,
> > +	struct xfs_fsop_geom *geom,
> >  	struct fs_path	*fs_path)
> >  {
> >  	struct fs_path	*fsp;
> > @@ -84,7 +84,7 @@ int
> >  addfile(
> >  	char		*name,
> >  	int		fd,
> > -	xfs_fsop_geom_t	*geometry,
> > +	struct xfs_fsop_geom *geometry,
> >  	struct fs_path	*fs_path)
> >  {
> >  	char		*filename;
> > diff --git a/spaceman/init.c b/spaceman/init.c
> > index 181a3446..c845f920 100644
> > --- a/spaceman/init.c
> > +++ b/spaceman/init.c
> > @@ -60,7 +60,7 @@ init(
> >  	char		**argv)
> >  {
> >  	int		c;
> > -	xfs_fsop_geom_t	geometry = { 0 };
> > +	struct xfs_fsop_geom geometry = { 0 };
> >  	struct fs_path	fsp;
> >  
> >  	progname = basename(argv[0]);
> > diff --git a/spaceman/space.h b/spaceman/space.h
> > index bf9cc2bf..b246f602 100644
> > --- a/spaceman/space.h
> > +++ b/spaceman/space.h
> > @@ -7,7 +7,7 @@
> >  #define XFS_SPACEMAN_SPACE_H_
> >  
> >  typedef struct fileio {
> > -	xfs_fsop_geom_t	geom;		/* XFS filesystem geometry */
> > +	struct xfs_fsop_geom geom;		/* XFS filesystem geometry */
> >  	struct fs_path	fs_path;	/* XFS path information */
> >  	char		*name;		/* file name at time of open */
> >  	int		fd;		/* open file descriptor */
> > @@ -17,8 +17,8 @@ extern fileio_t		*filetable;	/* open file table */
> >  extern int		filecount;	/* number of open files */
> >  extern fileio_t		*file;		/* active file in file table */
> >  
> > -extern int	openfile(char *, xfs_fsop_geom_t *, struct fs_path *);
> > -extern int	addfile(char *, int , xfs_fsop_geom_t *, struct fs_path *);
> > +extern int	openfile(char *, struct xfs_fsop_geom *, struct fs_path *);
> > +extern int	addfile(char *, int , struct xfs_fsop_geom *, struct fs_path *);
> >  
> >  extern void	print_init(void);
> >  extern void	help_init(void);
> > 
