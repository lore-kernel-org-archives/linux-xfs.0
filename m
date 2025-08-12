Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02EF260583
	for <linux-xfs@vger.kernel.org>; Tue, 12 Aug 2025 19:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026065; cv=none; b=O/2RTORNlp0PJt4BwXIWJpMk0zXX1cmIorOGhaGsAC+ZqTvFY+1XkSiJX7rOyNF/WmdrgCfb+S8j/Jk64T69otsZqlLdVFX9vuDexWeowP2N80INw/zeCV4YwpWB3uj+JWZzJMcXUVnsTjHD8oIZTpDpQ5w9jlZ7uvHMQnawyc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026065; c=relaxed/simple;
	bh=z5DhH1i/Ff/H/tTinQieG9ecuIUYjvuD0MucEq8iW48=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s6NgSgU2f7ok6ViZTQRZFts0nf7qVtd7I62agDRAIEAhr6ND9vsrp/e7s/A/mW45a7HlOrSkn8KxP9Dw42xLH5pMRgZmDL139k36kI7Lud25u/nC7ajInkSKcgz81UWjcOvg0CsPTS29/YLniVoZkYLYLnnAAVj0r2ZboWJzQ2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a99FkKsK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a99FkKsK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535B1C4CEF0;
	Tue, 12 Aug 2025 19:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755026065;
	bh=z5DhH1i/Ff/H/tTinQieG9ecuIUYjvuD0MucEq8iW48=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a99FkKsK4Rsokq/wHedWN4deitUjJzJ/LZ8bUgnW5Td8/6NzPYKMPCakK5BobPoyO
	 NCc1ykOntmu8lugrQE24T3M6iWBJCkiwp72JmBtt/whL4B5seM4yu4n5e4csTzffse
	 RyqQPWdEgSOCio3fjNjW7Mumf9dhpdnqgGU8w7ERPoTJICGdkV/5F9399T5WNZCMA4
	 1tp6u2qh5nasHqX82MeTFeG8QkF6l+tumg+LE308HXuvi2/U9ecSuc7RdeNR33k64p
	 t3NWncFg0yY6Zl1ck8csb/uvaDVxStKileFBkg061jl0wbxwF/mRu0NzDA/d9uf9Hj
	 DlkR1W5deHggg==
Date: Tue, 12 Aug 2025 12:14:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev, hch@infradead.org
Subject: Re: [PATCH v12 1/1] proto: add ability to populate a filesystem from
 a directory
Message-ID: <20250812191424.GP7965@frogsfrogsfrogs>
References: <20250730161222.1583872-1-luca.dimaio1@gmail.com>
 <20250730161222.1583872-2-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730161222.1583872-2-luca.dimaio1@gmail.com>

On Wed, Jul 30, 2025 at 06:12:22PM +0200, Luca Di Maio wrote:
> This patch implements the functionality to populate a newly created XFS
> filesystem directly from an existing directory structure.
> 
> It resuses existing protofile logic, it branches if input is a
> directory.
> 
> The population process steps are as follows:
>   - create the root inode before populating content
>   - recursively process nested directories
>   - handle regular files, directories, symlinks, char devices, block
>     devices, sockets, fifos
>   - preserve attributes (ownership, permissions)
>   - preserve mtime timestamps from source files to maintain file history
>     - use current time for atime/ctime/crtime
>     - possible to specify atime=1 to preserve atime timestamps from
>       source files
>   - preserve extended attributes and fsxattrs for all file types
>   - preserve hardlinks
> 
> At the moment, the implementation for the hardlink tracking is very
> simple, as it involves a linear search.
> from my local testing using larger source directories
> (1.3mln inodes, ~400k hardlinks) the difference was actually
> just a few seconds (given that most of the time is doing i/o).
> We might want to revisit that in the future if this becomes a
> bottleneck.
> 
> This functionality makes it easier to create populated filesystems
> without having to mount them, it's particularly useful for
> reproducible builds.
> 
> Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>

Looks good to me at long last,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Thank you very much for filling this functionality gap!

--D

> ---
>  man/man8/mkfs.xfs.8.in |  38 +-
>  mkfs/proto.c           | 771 ++++++++++++++++++++++++++++++++++++++++-
>  mkfs/proto.h           |  18 +-
>  mkfs/xfs_mkfs.c        |  23 +-
>  4 files changed, 817 insertions(+), 33 deletions(-)
> 
> diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
> index bc804931..4497468f 100644
> --- a/man/man8/mkfs.xfs.8.in
> +++ b/man/man8/mkfs.xfs.8.in
> @@ -28,7 +28,7 @@ mkfs.xfs \- construct an XFS filesystem
>  .I naming_options
>  ] [
>  .B \-p
> -.I protofile_options
> +.I prototype_options
>  ] [
>  .B \-q
>  ] [
> @@ -977,30 +977,40 @@ option set.
>  .PP
>  .PD 0
>  .TP
> -.BI \-p " protofile_options"
> +.BI \-p " prototype_options"
>  .TP
>  .BI "Section Name: " [proto]
>  .PD
> -These options specify the protofile parameters for populating the filesystem.
> +These options specify the prototype parameters for populating the filesystem.
>  The valid
> -.I protofile_options
> +.I prototype_options
>  are:
>  .RS 1.2i
>  .TP
> -.BI [file=] protofile
> +.BI [file=]
>  The
>  .B file=
>  prefix is not required for this CLI argument for legacy reasons.
>  If specified as a config file directive, the prefix is required.
> -
> +.TP
> +.BI [file=] directory
>  If the optional
>  .PD
> -.I protofile
> -argument is given,
> +.I prototype
> +argument is given, and it's a directory,
>  .B mkfs.xfs
> -uses
> -.I protofile
> -as a prototype file and takes its directions from that file.
> +will populate the root file system with the contents of the given directory
> +tree.
> +Content, timestamps (atime, mtime), attributes and extended attributes
> +are preserved for all file types.
> +.TP
> +.BI [file=] protofile
> +If the optional
> +.PD
> +.I prototype
> +argument is given, and points to a regular file,
> +.B mkfs.xfs
> +uses it as a prototype file and takes its directions from that file.
>  The blocks and inodes specifiers in the
>  .I protofile
>  are provided for backwards compatibility, but are otherwise unused.
> @@ -1136,8 +1146,12 @@ always terminated with the dollar (
>  .B $
>  ) token.
>  .TP
> +.BI atime= value
> +If set to 1,  mkfs will copy in access timestamps from the source files.
> +Otherwise, access timestamps will be set to the current time.
> +.TP
>  .BI slashes_are_spaces= value
> -If set to 1, slashes ("/") in the first token of each line of the protofile
> +If set to 1, slashes ("/") in the first token of each line of the prototype file
>  are converted to spaces.
>  This enables the creation of a filesystem containing filenames with spaces.
>  By default, this is set to 0.
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index 7f80bef8..bd73d38c 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -5,6 +5,8 @@
>   */
> 
>  #include "libxfs.h"
> +#include <dirent.h>
> +#include <sys/resource.h>
>  #include <sys/stat.h>
>  #include <sys/xattr.h>
>  #include <linux/xattr.h>
> @@ -21,6 +23,11 @@ static void rsvfile(xfs_mount_t *mp, xfs_inode_t *ip, long long len);
>  static int newregfile(char **pp, char **fname);
>  static void rtinit(xfs_mount_t *mp);
>  static off_t filesize(int fd);
> +static void populate_from_dir(struct xfs_mount *mp, struct fsxattr *fsxp,
> +		char *source_dir);
> +static void walk_dir(struct xfs_mount *mp, struct xfs_inode *pip,
> +		struct fsxattr *fsxp, char *path_buf, int path_len);
> +static int preserve_atime;
>  static int slashes_are_spaces;
> 
>  /*
> @@ -54,23 +61,49 @@ getnum(
>  	return i;
>  }
> 
> -char *
> +struct proto_source
>  setup_proto(
> -	char	*fname)
> +	char			*fname)
>  {
> -	char		*buf = NULL;
> -	static char	dflt[] = "d--755 0 0 $";
> -	int		fd;
> -	long		size;
> +	struct proto_source	result = {};
> +	struct stat		statbuf;
> +	char			*buf = NULL;
> +	static char		dflt[] = "d--755 0 0 $";
> +	int			fd;
> +	long			size;
> +
> +	/*
> +	 * If no prototype path is supplied, use the default protofile which
> +	 * creates only a root directory.
> +	 */
> +	if (!fname) {
> +		result.type = PROTO_SRC_PROTOFILE;
> +		result.data = dflt;
> +		return result;
> +	}
> 
> -	if (!fname)
> -		return dflt;
>  	if ((fd = open(fname, O_RDONLY)) < 0 || (size = filesize(fd)) < 0) {
>  		fprintf(stderr, _("%s: failed to open %s: %s\n"),
>  			progname, fname, strerror(errno));
>  		goto out_fail;
>  	}
> 
> +	if (fstat(fd, &statbuf) < 0)
> +		fail(_("invalid or unreadable source path"), errno);
> +
> +	/*
> +	 * Handle directory inputs.
> +	 */
> +	if (S_ISDIR(statbuf.st_mode)) {
> +		close(fd);
> +		result.type = PROTO_SRC_DIR;
> +		result.data = fname;
> +		return result;
> +	}
> +
> +	/*
> +	 * Else this is a protofile, let's handle traditionally.
> +	 */
>  	buf = malloc(size + 1);
>  	if (read(fd, buf, size) < size) {
>  		fprintf(stderr, _("%s: read failed on %s: %s\n"),
> @@ -90,7 +123,10 @@ setup_proto(
>  	(void)getnum(getstr(&buf), 0, 0, false);	/* block count */
>  	(void)getnum(getstr(&buf), 0, 0, false);	/* inode count */
>  	close(fd);
> -	return buf;
> +
> +	result.type = PROTO_SRC_PROTOFILE;
> +	result.data = buf;
> +	return result;
> 
>  out_fail:
>  	if (fd >= 0)
> @@ -379,6 +415,13 @@ writeattr(
>  	int			error;
> 
>  	ret = fgetxattr(fd, attrname, valuebuf, valuelen);
> +	/*
> +	 * In case of filedescriptors with O_PATH, fgetxattr() will fail with
> +	 * EBADF.
> +	 * Let's try to fallback to lgetxattr() using input path.
> +	 */
> +	if (ret < 0 && errno == EBADF)
> +		ret = lgetxattr(fname, attrname, valuebuf, valuelen);
>  	if (ret < 0) {
>  		if (errno == EOPNOTSUPP)
>  			return;
> @@ -425,6 +468,13 @@ writeattrs(
>  		fail(_("error allocating xattr name buffer"), errno);
> 
>  	ret = flistxattr(fd, namebuf, XATTR_LIST_MAX);
> +	/*
> +	 * In case of filedescriptors with O_PATH, flistxattr() will fail with
> +	 * EBADF.
> +	 * Let's try to fallback to llistxattr() using input path.
> +	 */
> +	if (ret < 0 && errno == EBADF)
> +		ret = llistxattr(fname, namebuf, XATTR_LIST_MAX);
>  	if (ret < 0) {
>  		if (errno == EOPNOTSUPP)
>  			goto out_namebuf;
> @@ -931,13 +981,29 @@ parseproto(
> 
>  void
>  parse_proto(
> -	xfs_mount_t	*mp,
> -	struct fsxattr	*fsx,
> -	char		**pp,
> -	int		proto_slashes_are_spaces)
> +	xfs_mount_t		*mp,
> +	struct fsxattr		*fsx,
> +	struct proto_source	*protosource,
> +	int			proto_slashes_are_spaces,
> +	int			proto_preserve_atime)
>  {
> +	preserve_atime = proto_preserve_atime;
>  	slashes_are_spaces = proto_slashes_are_spaces;
> -	parseproto(mp, NULL, fsx, pp, NULL);
> +
> +	/*
> +	 * In case of a file input, we will use the prototype file logic else
> +	 * we will fallback to populate from dir.
> +	 */
> +	switch(protosource->type) {
> +	case PROTO_SRC_PROTOFILE:
> +		parseproto(mp, NULL, fsx, &protosource->data, NULL);
> +		break;
> +	case PROTO_SRC_DIR:
> +		populate_from_dir(mp, fsx, protosource->data);
> +		break;
> +	case PROTO_SRC_NONE:
> +		fail(_("invalid or unreadable source path"), ENOENT);
> +	}
>  }
> 
>  /* Create a sb-rooted metadata file. */
> @@ -1172,3 +1238,680 @@ filesize(
>  		return -1;
>  	return stb.st_size;
>  }
> +
> +/* Try to allow as many open directories as possible. */
> +static void
> +bump_max_fds(void)
> +{
> +	struct rlimit	rlim = {};
> +	int		ret;
> +
> +	ret = getrlimit(RLIMIT_NOFILE, &rlim);
> +	if (ret)
> +		return;
> +
> +	rlim.rlim_cur = rlim.rlim_max;
> +	ret = setrlimit(RLIMIT_NOFILE, &rlim);
> +	if (ret < 0)
> +		fprintf(stderr, _("%s: could not bump fd limit: [ %d - %s]\n"),
> +			progname, errno, strerror(errno));
> +}
> +
> +static void
> +writefsxattrs(
> +	struct xfs_inode	*ip,
> +	struct fsxattr		*fsxp)
> +{
> +	ip->i_projid  = fsxp->fsx_projid;
> +	ip->i_extsize = fsxp->fsx_extsize;
> +	ip->i_diflags = xfs_flags2diflags(ip, fsxp->fsx_xflags);
> +	if (xfs_has_v3inodes(ip->i_mount)) {
> +		ip->i_diflags2   = xfs_flags2diflags2(ip, fsxp->fsx_xflags);
> +		ip->i_cowextsize = fsxp->fsx_cowextsize;
> +	}
> +}
> +
> +static void
> +writetimestamps(
> +	struct xfs_inode	*ip,
> +	struct stat		*statbuf)
> +{
> +	struct timespec64	ts;
> +
> +	/*
> +	 * Copy timestamps from source file to destination inode.
> +	 * Usually reproducible archives will delete or not register
> +	 * atime and ctime, for example:
> +	 *    https://www.gnu.org/software/tar/manual/html_section/Reproducibility.html
> +	 * hence we will only copy mtime, and let ctime/crtime be set to
> +	 * current time.
> +	 * atime will be copied over if atime is true.
> +	 */
> +	ts.tv_sec  = statbuf->st_mtim.tv_sec;
> +	ts.tv_nsec = statbuf->st_mtim.tv_nsec;
> +	inode_set_mtime_to_ts(VFS_I(ip), ts);
> +
> +	/*
> +	 * In case of atime option, we will copy the atime  timestamp
> +	 * from source.
> +	 */
> +	if (preserve_atime) {
> +		ts.tv_sec  = statbuf->st_atim.tv_sec;
> +		ts.tv_nsec = statbuf->st_atim.tv_nsec;
> +		inode_set_atime_to_ts(VFS_I(ip), ts);
> +	}
> +}
> +
> +struct hardlink {
> +	ino_t		src_ino;
> +	xfs_ino_t	dst_ino;
> +};
> +
> +struct hardlinks {
> +	size_t		count;
> +	size_t		size;
> +	struct hardlink	*entries;
> +};
> +
> +/* Growth strategy for hardlink tracking array */
> +/* Double size for small arrays */
> +#define HARDLINK_DEFAULT_GROWTH_FACTOR	2
> +/* Grow by 25% for large arrays */
> +#define HARDLINK_LARGE_GROWTH_FACTOR	0.25
> +/* Threshold to switch growth strategies */
> +#define HARDLINK_THRESHOLD		1024
> +/* Initial allocation size */
> +#define HARDLINK_TRACKER_INITIAL_SIZE	4096
> +
> +/*
> + * Keep track of source inodes that are from hardlinks so we can retrieve them
> + * when needed to setup in destination.
> + */
> +static struct hardlinks hardlink_tracker = { 0 };
> +
> +static void
> +init_hardlink_tracker(void)
> +{
> +	hardlink_tracker.size = HARDLINK_TRACKER_INITIAL_SIZE;
> +	hardlink_tracker.entries = calloc(
> +			hardlink_tracker.size,
> +			sizeof(struct hardlink));
> +	if (!hardlink_tracker.entries)
> +		fail(_("error allocating hardlinks tracking array"), errno);
> +}
> +
> +static void
> +cleanup_hardlink_tracker(void)
> +{
> +	free(hardlink_tracker.entries);
> +	hardlink_tracker.entries = NULL;
> +	hardlink_tracker.count = 0;
> +	hardlink_tracker.size = 0;
> +}
> +
> +static xfs_ino_t
> +get_hardlink_dst_inode(
> +	xfs_ino_t	i_ino)
> +{
> +	for (size_t i = 0; i < hardlink_tracker.count; i++) {
> +		if (hardlink_tracker.entries[i].src_ino == i_ino)
> +			return hardlink_tracker.entries[i].dst_ino;
> +	}
> +	return 0;
> +}
> +
> +static void
> +track_hardlink_inode(
> +	ino_t	src_ino,
> +	xfs_ino_t	dst_ino)
> +{
> +	if (hardlink_tracker.count >= hardlink_tracker.size) {
> +		/*
> +		 * double for smaller capacity.
> +		 * instead grow by 25% steps for larger capacities.
> +		 */
> +		const size_t old_size = hardlink_tracker.size;
> +		size_t new_size = old_size * HARDLINK_DEFAULT_GROWTH_FACTOR;
> +		if (old_size > HARDLINK_THRESHOLD)
> +			new_size = old_size + (old_size * HARDLINK_LARGE_GROWTH_FACTOR);
> +
> +		struct hardlink *resized_array = reallocarray(
> +				hardlink_tracker.entries,
> +				new_size,
> +				sizeof(struct hardlink));
> +		if (!resized_array)
> +			fail(_("error enlarging hardlinks tracking array"), errno);
> +
> +		memset(&resized_array[old_size], 0,
> +				(new_size - old_size) * sizeof(struct hardlink));
> +
> +		hardlink_tracker.entries = resized_array;
> +		hardlink_tracker.size = new_size;
> +	}
> +	hardlink_tracker.entries[hardlink_tracker.count].src_ino = src_ino;
> +	hardlink_tracker.entries[hardlink_tracker.count].dst_ino = dst_ino;
> +	hardlink_tracker.count++;
> +}
> +
> +/*
> + * This function will first check in our tracker if the input hardlink has
> + * already been stored, if not report false so create_nondir_inode() can continue
> + * handling the inode as regularly, and later save the source inode in our
> + * buffer for future consumption.
> + */
> +static bool
> +handle_hardlink(
> +	struct xfs_mount	*mp,
> +	struct xfs_inode	*pip,
> +	struct xfs_name		xname,
> +	struct stat		file_stat)
> +{
> +	int			error;
> +	xfs_ino_t		dst_ino;
> +	struct xfs_inode	*ip;
> +	struct xfs_trans	*tp;
> +	struct xfs_parent_args	*ppargs = NULL;
> +
> +	tp = getres(mp, 0);
> +	ppargs = newpptr(mp);
> +	dst_ino = get_hardlink_dst_inode(file_stat.st_ino);
> +
> +	/*
> +	 * We didn't find the hardlink inode, this means it's the first time
> +	 * we see it, report error so create_nondir_inode() can continue handling the
> +	 * inode as a regular file type, and later save the source inode in our
> +	 * buffer for future consumption.
> +	 */
> +	if (dst_ino == 0)
> +		return false;
> +
> +	error = libxfs_iget(mp, NULL, dst_ino, 0, &ip);
> +	if (error)
> +		fail(_("failed to get inode"), error);
> +
> +	/*
> +	 * In case the inode was already in our tracker we need to setup the
> +	 * hardlink and skip file copy.
> +	 */
> +	libxfs_trans_ijoin(tp, pip, 0);
> +	libxfs_trans_ijoin(tp, ip, 0);
> +	newdirent(mp, tp, pip, &xname, ip, ppargs);
> +
> +	/*
> +	 * Increment the link count
> +	 */
> +	libxfs_bumplink(tp, ip);
> +
> +	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +
> +	error = -libxfs_trans_commit(tp);
> +	if (error)
> +		fail(_("Error encountered creating file from prototype file"), error);
> +
> +	libxfs_parent_finish(mp, ppargs);
> +	libxfs_irele(ip);
> +
> +	return true;
> +}
> +
> +static void
> +create_directory_inode(
> +	struct xfs_mount	*mp,
> +	struct xfs_inode	*pip,
> +	struct fsxattr		*fsxp,
> +	int			mode,
> +	struct cred		creds,
> +	struct xfs_name		xname,
> +	int			flags,
> +	struct stat		file_stat,
> +	int			fd,
> +	char			*entryname,
> +	char			*path_buf,
> +	int			path_len)
> +{
> +
> +	int			error;
> +	struct xfs_inode	*ip;
> +	struct xfs_trans	*tp;
> +	struct xfs_parent_args	*ppargs = NULL;
> +
> +	tp = getres(mp, 0);
> +	ppargs = newpptr(mp);
> +
> +	error = creatproto(&tp, pip, mode, 0, &creds, fsxp, &ip);
> +	if (error)
> +		fail(_("Inode allocation failed"), error);
> +
> +	libxfs_trans_ijoin(tp, pip, 0);
> +
> +	newdirent(mp, tp, pip, &xname, ip, ppargs);
> +
> +	libxfs_bumplink(tp, pip);
> +	libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
> +	newdirectory(mp, tp, ip, pip);
> +
> +	/*
> +	 * Copy over timestamps.
> +	 */
> +	writetimestamps(ip, &file_stat);
> +
> +	libxfs_trans_log_inode(tp, ip, flags);
> +
> +	error = -libxfs_trans_commit(tp);
> +	if (error)
> +		fail(_("Directory inode allocation failed."), error);
> +
> +	libxfs_parent_finish(mp, ppargs);
> +	tp = NULL;
> +
> +	/*
> +	 * Copy over attributes.
> +	 */
> +	writeattrs(ip, entryname, fd);
> +	writefsxattrs(ip, fsxp);
> +	close(fd);
> +
> +	walk_dir(mp, ip, fsxp, path_buf, path_len);
> +
> +	libxfs_irele(ip);
> +}
> +
> +static void
> +create_nondir_inode(
> +	struct xfs_mount	*mp,
> +	struct xfs_inode	*pip,
> +	struct fsxattr		*fsxp,
> +	int			mode,
> +	struct cred		creds,
> +	struct xfs_name		xname,
> +	int			flags,
> +	struct stat		file_stat,
> +	xfs_dev_t		rdev,
> +	int			fd,
> +	char			*src_fname)
> +{
> +
> +	char			link_target[XFS_SYMLINK_MAXLEN];
> +	int			error;
> +	ssize_t			link_len = 0;
> +	struct xfs_inode	*ip;
> +	struct xfs_trans	*tp;
> +	struct xfs_parent_args	*ppargs = NULL;
> +
> +	/*
> +	 * If handle_hardlink() returns true it means the hardlink has been
> +	 * correctly found and set, so we don't need to do anything else.
> +	 */
> +	if (file_stat.st_nlink > 1 && handle_hardlink(mp, pip, xname, file_stat)) {
> +		close(fd);
> +		return;
> +	}
> +	/*
> +	 * If instead we have an error it means the hardlink was not registered,
> +	 * so we proceed to treat it like a regular file, and save it to our
> +	 * tracker later.
> +	 */
> +	tp = getres(mp, 0);
> +	/*
> +	 * In case of symlinks, we need to handle things a little differently.
> +	 * We need to read out our link target and act accordingly.
> +	 */
> +	if (xname.type == XFS_DIR3_FT_SYMLINK) {
> +		link_len = readlink(src_fname, link_target, XFS_SYMLINK_MAXLEN);
> +		if (link_len < 0)
> +			fail(_("could not resolve symlink"), errno);
> +		if (link_len >= PATH_MAX)
> +			fail(_("symlink target too long"), ENAMETOOLONG);
> +		tp = getres(mp, XFS_B_TO_FSB(mp, link_len));
> +	}
> +	ppargs = newpptr(mp);
> +
> +	error = creatproto(&tp, pip, mode, rdev, &creds, fsxp, &ip);
> +	if (error)
> +		fail(_("Inode allocation failed"), error);
> +
> +	/*
> +	 * In case of symlinks, we now write it down, for other file types
> +	 * this is handled later before cleanup.
> +	 */
> +	if (xname.type == XFS_DIR3_FT_SYMLINK)
> +		writesymlink(tp, ip, link_target, link_len);
> +
> +	libxfs_trans_ijoin(tp, pip, 0);
> +	newdirent(mp, tp, pip, &xname, ip, ppargs);
> +
> +	/*
> +	 * Copy over timestamps.
> +	 */
> +	writetimestamps(ip, &file_stat);
> +
> +	libxfs_trans_log_inode(tp, ip, flags);
> +
> +	error = -libxfs_trans_commit(tp);
> +	if (error)
> +		fail(_("Error encountered creating non dir inode"), error);
> +
> +	libxfs_parent_finish(mp, ppargs);
> +
> +	/*
> +	 * Copy over file content, attributes, extended attributes and
> +	 * timestamps.
> +	 */
> +	if (fd >= 0) {
> +		/* We need to writefile only when not dealing with a symlink. */
> +		if (xname.type != XFS_DIR3_FT_SYMLINK)
> +			writefile(ip, src_fname, fd);
> +		writeattrs(ip, src_fname, fd);
> +		close(fd);
> +	}
> +	/*
> +	 * We do fsxattr also for file types where we don't have an fd,
> +	 * for example FIFOs.
> +	 */
> +	writefsxattrs(ip, fsxp);
> +
> +	/*
> +	 * If we're here it means this is the first time we're encountering an
> +	 * hardlink, so we need to store it.
> +	 */
> +	if (file_stat.st_nlink > 1)
> +		track_hardlink_inode(file_stat.st_ino, ip->i_ino);
> +
> +	libxfs_irele(ip);
> +}
> +
> +static void
> +handle_direntry(
> +	struct xfs_mount	*mp,
> +	struct xfs_inode	*pip,
> +	struct fsxattr		*fsxp,
> +	char			*path_buf,
> +	int			path_len,
> +	struct dirent		*entry)
> +{
> +	char			*fname = "";
> +	int			flags;
> +	int			majdev;
> +	int			mindev;
> +	int			mode;
> +	int			pathfd,fd = -1;
> +	int			rdev = 0;
> +	struct stat		file_stat;
> +	struct xfs_name		xname;
> +
> +	pathfd = open(path_buf, O_NOFOLLOW | O_PATH);
> +	if (pathfd < 0){
> +		fprintf(stderr, _("%s: cannot open %s: %s\n"), progname,
> +			path_buf, strerror(errno));
> +		exit(1);
> +	}
> +
> +	/*
> +	 * Symlinks and sockets will need to be opened with O_PATH to work, so
> +	 * we handle this special case.
> +	 */
> +	fd = openat(pathfd, entry->d_name, O_NOFOLLOW | O_PATH);
> +	if(fd < 0) {
> +		fprintf(stderr, _("%s: cannot open %s: %s\n"), progname,
> +			path_buf, strerror(errno));
> +		exit(1);
> +	}
> +
> +	if (fstat(fd, &file_stat) < 0) {
> +		fprintf(stderr, _("%s: cannot stat '%s': %s (errno=%d)\n"),
> +			progname, path_buf, strerror(errno), errno);
> +		exit(1);
> +	}
> +
> +	/* Ensure we're within the limits of PATH_MAX. */
> +	size_t avail = PATH_MAX - path_len;
> +	size_t wrote = snprintf(path_buf + path_len, avail, "/%s", entry->d_name);
> +	if (wrote > avail)
> +		fail(path_buf, ENAMETOOLONG);
> +
> +	/*
> +	 * Regular files instead need to be reopened with broader flags so we
> +	 * check if that's the case and reopen those.
> +	 */
> +	if (!S_ISSOCK(file_stat.st_mode) &&
> +	    !S_ISLNK(file_stat.st_mode)  &&
> +	    !S_ISFIFO(file_stat.st_mode)) {
> +		close(fd);
> +		/*
> +		 * Try to open the source file noatime to avoid a flood of
> +		 * writes to the source fs, but we can fall back to plain
> +		 * readonly mode if we don't have enough permission.
> +		 */
> +		fd = openat(pathfd, entry->d_name,
> +			    O_NOFOLLOW | O_RDONLY | O_NOATIME);
> +		if (fd < 0)
> +			fd = openat(pathfd, entry->d_name,
> +				    O_NOFOLLOW | O_RDONLY);
> +		if(fd < 0) {
> +			fprintf(stderr, _("%s: cannot open %s: %s\n"), progname,
> +				path_buf, strerror(errno));
> +			exit(1);
> +		}
> +	}
> +
> +	struct cred creds = {
> +		.cr_uid = file_stat.st_uid,
> +		.cr_gid = file_stat.st_gid,
> +	};
> +
> +	xname.name = (unsigned char *)entry->d_name;
> +	xname.len = strlen(entry->d_name);
> +	xname.type = 0;
> +	mode = file_stat.st_mode;
> +	flags = XFS_ILOG_CORE;
> +
> +	switch (file_stat.st_mode & S_IFMT) {
> +	case S_IFDIR:
> +		xname.type = XFS_DIR3_FT_DIR;
> +		create_directory_inode(mp, pip, fsxp, mode, creds, xname, flags,
> +				       file_stat, fd, entry->d_name, path_buf,
> +				       path_len + strlen(entry->d_name) + 1);
> +		goto out;
> +	case S_IFREG:
> +		xname.type = XFS_DIR3_FT_REG_FILE;
> +		fname = entry->d_name;
> +		break;
> +	case S_IFCHR:
> +		flags |= XFS_ILOG_DEV;
> +		xname.type = XFS_DIR3_FT_CHRDEV;
> +		majdev = major(file_stat.st_rdev);
> +		mindev = minor(file_stat.st_rdev);
> +		rdev = IRIX_MKDEV(majdev, mindev);
> +		fname = entry->d_name;
> +		break;
> +	case S_IFBLK:
> +		flags |= XFS_ILOG_DEV;
> +		xname.type = XFS_DIR3_FT_BLKDEV;
> +		majdev = major(file_stat.st_rdev);
> +		mindev = minor(file_stat.st_rdev);
> +		rdev = IRIX_MKDEV(majdev, mindev);
> +		fname = entry->d_name;
> +		break;
> +	case S_IFLNK:
> +		/*
> +		 * Being a symlink we opened the filedescriptor with O_PATH
> +		 * this will make flistxattr() and fgetxattr() fail with EBADF,
> +		 * so we  will need to fallback to llistxattr() and lgetxattr(),
> +		 * this will need the full path to the original file, not just
> +		 * the entry name.
> +		 */
> +		xname.type = XFS_DIR3_FT_SYMLINK;
> +		fname = path_buf;
> +		break;
> +	case S_IFIFO:
> +		/*
> +		 * Being a fifo we opened the filedescriptor with O_PATH
> +		 * this will make flistxattr() and fgetxattr() fail with EBADF,
> +		 * so we  will need to fallback to llistxattr() and lgetxattr(),
> +		 * this will need the full path to the original file, not just
> +		 * the entry name.
> +		 */
> +		xname.type = XFS_DIR3_FT_FIFO;
> +		fname = path_buf;
> +		break;
> +	case S_IFSOCK:
> +		/*
> +		 * Being a socket we opened the filedescriptor with O_PATH
> +		 * this will make flistxattr() and fgetxattr() fail with EBADF,
> +		 * so we  will need to fallback to llistxattr() and lgetxattr(),
> +		 * this will need the full path to the original file, not just
> +		 * the entry name.
> +		 */
> +		xname.type = XFS_DIR3_FT_SOCK;
> +		fname = path_buf;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	create_nondir_inode(mp, pip, fsxp, mode, creds, xname, flags, file_stat,
> +			    rdev, fd, fname);
> +out:
> +	/* Reset path_buf to original */
> +	path_buf[path_len] = '\0';
> +}
> +
> +/*
> + * Walk_dir will recursively list files and directories and populate the
> + * mountpoint *mp with them using handle_direntry().
> + */
> +static void
> +walk_dir(
> +	struct xfs_mount	*mp,
> +	struct xfs_inode	*pip,
> +	struct fsxattr		*fsxp,
> +	char			*path_buf,
> +	int			path_len)
> +{
> +	DIR			*dir;
> +	struct dirent		*entry;
> +
> +	/*
> +	 * Open input directory and iterate over all entries in it.
> +	 * when another directory is found, we will recursively call walk_dir.
> +	 */
> +	if ((dir = opendir(path_buf)) == NULL) {
> +		fprintf(stderr, _("%s: cannot open input dir: %s [%d - %s]\n"),
> +				progname, path_buf, errno, strerror(errno));
> +		exit(1);
> +	}
> +	while ((entry = readdir(dir)) != NULL) {
> +		if (strcmp(entry->d_name, ".") == 0 ||
> +		    strcmp(entry->d_name, "..") == 0)
> +			continue;
> +
> +		handle_direntry(mp, pip, fsxp, path_buf, path_len, entry);
> +	}
> +	closedir(dir);
> +}
> +
> +static void
> +populate_from_dir(
> +	struct xfs_mount	*mp,
> +	struct fsxattr		*fsxp,
> +	char			*cur_path)
> +{
> +	int			error;
> +	int			mode;
> +	int			fd = -1;
> +	char			path_buf[PATH_MAX];
> +	struct stat		file_stat;
> +	struct xfs_inode	*ip;
> +	struct xfs_trans	*tp;
> +
> +	/*
> +	 * Initialize path_buf cur_path, strip trailing slashes they're
> +	 * automatically added when walking the dir.
> +	 */
> +	if (strlen(cur_path) > 1 && cur_path[strlen(cur_path)-1] == '/')
> +		cur_path[strlen(cur_path)-1] = '\0';
> +	if (snprintf(path_buf, PATH_MAX, "%s", cur_path) >= PATH_MAX)
> +		fail(_("path name too long"), ENAMETOOLONG);
> +
> +	if (lstat(path_buf, &file_stat) < 0) {
> +		fprintf(stderr, _("%s: cannot stat '%s': %s (errno=%d)\n"),
> +			progname, path_buf, strerror(errno), errno);
> +		exit(1);
> +	}
> +	fd = open(path_buf, O_NOFOLLOW | O_RDONLY | O_NOATIME);
> +	if (fd < 0) {
> +		fprintf(stderr, _("%s: cannot open %s: %s\n"),
> +			progname, path_buf, strerror(errno));
> +		exit(1);
> +	}
> +
> +	/*
> +	 * We first ensure we have the root inode.
> +	 */
> +	struct cred creds = {
> +		.cr_uid = file_stat.st_uid,
> +		.cr_gid = file_stat.st_gid,
> +	};
> +	mode = file_stat.st_mode;
> +
> +	tp = getres(mp, 0);
> +
> +	error = creatproto(&tp, NULL, mode | S_IFDIR, 0, &creds, fsxp, &ip);
> +	if (error)
> +		fail(_("Inode allocation failed"), error);
> +
> +	mp->m_sb.sb_rootino = ip->i_ino;
> +	libxfs_log_sb(tp);
> +	newdirectory(mp, tp, ip, ip);
> +	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +
> +	error = -libxfs_trans_commit(tp);
> +	if (error)
> +		fail(_("Inode allocation failed"), error);
> +
> +	libxfs_parent_finish(mp, NULL);
> +
> +	/*
> +	 * Copy over attributes.
> +	 */
> +	writeattrs(ip, path_buf, fd);
> +	writefsxattrs(ip, fsxp);
> +	close(fd);
> +
> +	/*
> +	 * RT initialization. Do this here to ensure that the RT inodes get
> +	 * placed after the root inode.
> +	 */
> +	error = create_metadir(mp);
> +	if (error)
> +		fail(_("Creation of the metadata directory inode failed"), error);
> +
> +	rtinit(mp);
> +
> +	/*
> +	 * By nature of walk_dir() we could be opening a great number of fds
> +	 * for deeply nested directory trees. try to bump max fds limit.
> +	 */
> +	bump_max_fds();
> +
> +	/*
> +	 * Initialize the hardlinks tracker.
> +	 */
> +	init_hardlink_tracker();
> +	/*
> +	 * Now that we have a root inode, let's walk the input dir and populate
> +	 * the partition.
> +	 */
> +	walk_dir(mp, ip, fsxp, path_buf, strlen(cur_path));
> +
> +	/*
> +	 * Cleanup hardlinks tracker.
> +	 */
> +	cleanup_hardlink_tracker();
> +
> +	/*
> +	 * We free up our root inode only when we finished populating the root
> +	 * filesystem.
> +	 */
> +	libxfs_irele(ip);
> +}
> diff --git a/mkfs/proto.h b/mkfs/proto.h
> index be1ceb45..476f7851 100644
> --- a/mkfs/proto.h
> +++ b/mkfs/proto.h
> @@ -6,9 +6,21 @@
>  #ifndef MKFS_PROTO_H_
>  #define MKFS_PROTO_H_
> 
> -char *setup_proto(char *fname);
> -void parse_proto(struct xfs_mount *mp, struct fsxattr *fsx, char **pp,
> -		int proto_slashes_are_spaces);
> +enum proto_source_type {
> +	PROTO_SRC_NONE = 0,
> +	PROTO_SRC_PROTOFILE,
> +	PROTO_SRC_DIR
> +};
> +struct proto_source {
> +	enum	proto_source_type type;
> +	char	*data;
> +};
> +
> +struct proto_source setup_proto(char *fname);
> +void parse_proto(struct xfs_mount *mp, struct fsxattr *fsx,
> +		 struct proto_source *protosource,
> +		 int proto_slashes_are_spaces,
> +		 int proto_preserve_atime);
>  void res_failed(int err);
> 
>  #endif /* MKFS_PROTO_H_ */
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 812241c4..885377f1 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -123,6 +123,7 @@ enum {
> 
>  enum {
>  	P_FILE = 0,
> +	P_ATIME,
>  	P_SLASHES,
>  	P_MAX_OPTS,
>  };
> @@ -714,6 +715,7 @@ static struct opt_params popts = {
>  	.ini_section = "proto",
>  	.subopts = {
>  		[P_FILE] = "file",
> +		[P_ATIME] = "atime",
>  		[P_SLASHES] = "slashes_are_spaces",
>  		[P_MAX_OPTS] = NULL,
>  	},
> @@ -722,6 +724,12 @@ static struct opt_params popts = {
>  		  .conflicts = { { NULL, LAST_CONFLICT } },
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
> +		{ .index = P_ATIME,
> +		  .conflicts = { { NULL, LAST_CONFLICT } },
> +		  .minval = 0,
> +		  .maxval = 1,
> +		  .defaultval = 1,
> +		},
>  		{ .index = P_SLASHES,
>  		  .conflicts = { { NULL, LAST_CONFLICT } },
>  		  .minval = 0,
> @@ -1079,6 +1087,7 @@ struct cli_params {
>  	int	lsunit;
>  	int	is_supported;
>  	int	proto_slashes_are_spaces;
> +	int	proto_atime;
>  	int	data_concurrency;
>  	int	log_concurrency;
>  	int	rtvol_concurrency;
> @@ -1206,6 +1215,7 @@ usage( void )
>  /* naming */		[-n size=num,version=2|ci,ftype=0|1,parent=0|1]]\n\
>  /* no-op info only */	[-N]\n\
>  /* prototype file */	[-p fname]\n\
> +/* populate from directory */	[-p dirname,atime=0|1]\n\
>  /* quiet */		[-q]\n\
>  /* realtime subvol */	[-r extsize=num,size=num,rtdev=xxx,rgcount=n,rgsize=n,\n\
>  			    concurrency=num,zoned=0|1,start=n,reserved=n]\n\
> @@ -2131,6 +2141,9 @@ proto_opts_parser(
>  	case P_SLASHES:
>  		cli->proto_slashes_are_spaces = getnum(value, opts, subopt);
>  		break;
> +	case P_ATIME:
> +		cli->proto_atime = getnum(value, opts, subopt);
> +		break;
>  	case P_FILE:
>  		fallthrough;
>  	default:
> @@ -5682,7 +5695,7 @@ main(
>  	int			discard = 1;
>  	int			force_overwrite = 0;
>  	int			quiet = 0;
> -	char			*protostring = NULL;
> +	struct proto_source	protosource;
>  	int			worst_freelist = 0;
> 
>  	struct libxfs_init	xi = {
> @@ -5832,8 +5845,6 @@ main(
>  	 */
>  	cfgfile_parse(&cli);
> 
> -	protostring = setup_proto(cli.protofile);
> -
>  	/*
>  	 * Extract as much of the valid config as we can from the CLI input
>  	 * before opening the libxfs devices.
> @@ -6010,7 +6021,11 @@ main(
>  	/*
>  	 * Allocate the root inode and anything else in the proto file.
>  	 */
> -	parse_proto(mp, &cli.fsx, &protostring, cli.proto_slashes_are_spaces);
> +	protosource = setup_proto(cli.protofile);
> +	parse_proto(mp, &cli.fsx,
> +			&protosource,
> +			cli.proto_slashes_are_spaces,
> +			cli.proto_atime);
> 
>  	/*
>  	 * Protect ourselves against possible stupidity
> --
> 2.50.0
> 
