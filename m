Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7863C393DC5
	for <linux-xfs@vger.kernel.org>; Mon, 25 Aug 2025 09:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756114946; cv=none; b=UMuZ1+jh6V6FSiwk0fuDp6Pu//iF50DV0JPVM3ggVlOCpwWaPB6wII7XNz7D97B2JKuOTDZQJ9oRohDNZsJ844ZJJj9Aw2LuoBvnG4g/ey32waZRg3E1fftKuLCVJHrhSEiJAFNMtp7N8Ymx6dZ6YYHyExcvqCXC/Y4Lqxz43S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756114946; c=relaxed/simple;
	bh=AV0un4Nn0I3ifq74d9lE/8Z94QojQjB4Qu4jEss94a8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g4a0ImzO46sadDkzJrk+vEA6eiBH4MddOMGM51jEoZB7p6hLP8wE4cYODHl5YmnzLFLF9zpawiigopUqGyxwcHXv7RVqeEGI/gEWPvJaSZIc7RSbc9ePlH3RovzSiic5Zws4qdW04Xqzpm9qwdc+nzg5/pCSZKTw8NMZnJyCzLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eyyN8CS8; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eyyN8CS8"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45b4a25ccceso23393395e9.3
        for <linux-xfs@vger.kernel.org>; Mon, 25 Aug 2025 02:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756114942; x=1756719742; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JkntQFXGOZKKWkDzab2N0IQntohiQcNfW846VL3MJFw=;
        b=eyyN8CS8HF1ZT/TpJKqombvCZeDxcnS31Jf6YNfBhfUXWqIqR3JFRyfj9+wJpXoLDd
         3FV5hxFwfw/Ig5FFyPQZ1Xe4kyyrt9c40IAtOjcz1lvC+bL0CWS5cGS5eXiBCpTrs/Gx
         CBz1EbGOFDVfpPDS8YjGATHfok3wkj4JOuKyYx9uPMQAOBzWucQTPDr6aJTlGwLRvQ+E
         PnmBiPeoclVA1BvSessaoNgaHIY01wNzpYbloJytZnh5geTImytWnsIgVBRjNc42EWXC
         cJzAYnyPrI8LpizVawlJJQj5N7DxQkszv+q3JdU6Do5wbi/mQi30kfYVg/baYQp2ZXUX
         B3nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756114942; x=1756719742;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JkntQFXGOZKKWkDzab2N0IQntohiQcNfW846VL3MJFw=;
        b=Gj51790nD5/cZ1IF/HSBpEXCAsJjklqhAiWT+evdlfJORaMLlkqpdVGngEdfHugzV/
         RLn2ATnsuPWZ3PxJ7uL0MfTQ/ddOQ3Fw1FD8nPSMR5dCLv1oRuvzhLkabbwa3zXvQQq7
         HJ62cBna4Lg/lxfa7mJn45WX8J6C5r0d8tZQQuZsp7MvVwdbe71bmUp6jBpal/KBHcQ0
         iCipxbMPDdSU/D+MG/BJfJraUb79urKpBxIRjSj0Y2J28kOpqyuJCN5Ca5C1rMR875ZT
         LDxhpwzRp+PJ2ZR3LAHpl/fzlIMJ7et8GUHrw+mtDZhu7wVk/qMQxaB0CmGdXXI/41hr
         5bNg==
X-Gm-Message-State: AOJu0YxgGvQ+VUva0QpJvzPf1O1FPVMQWl6ptZPtODLMHjeUC0CBCgag
	hvBnbJe1iGQx+bwgkQbG48r3MAg4UyY+6FXwCXikIGmsHbLVEmfFXmiaygei2NWnXtJOymACbBT
	ffgkTfSWJDJrcdqGQQw8Z9T0uRsD1o94=
X-Gm-Gg: ASbGncu74XkDHPZUiKC3Xym6pBSiLbj8VHR0GYVyoypTy1CKdQIXLf/vfZ7i6RZuf7G
	E53MtENJ5pvUKvjgdZy61wn+Y1NpyQKHFltt6SmvohTcRGhbceP3708v2STRWAPh1GR0LRuDnh7
	Keor/Dv7oF/QUpQiOa25ORlAZKVNaXjvADM0+K61W/wBZlom9vfm5wj8EvSrvv4eDRRB+Qdpp33
	dh95AT+Rs+m0W2wtu7rKzLbyZRPszO2wzfyHaBa/HjIZQ==
X-Google-Smtp-Source: AGHT+IE/g/F9v/16YxGzP4Lg2mPx7vtXFpA3qu4Si57UiOIMzUmXKbel/AyEJ1TWG1Z4VTH2QYz9M5mrIYlk4TJjX6w=
X-Received: by 2002:a05:600c:35c9:b0:458:b7d1:99f9 with SMTP id
 5b1f17b1804b1-45b517a0655mr96618095e9.11.1756114941169; Mon, 25 Aug 2025
 02:42:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250730161222.1583872-1-luca.dimaio1@gmail.com>
 <20250730161222.1583872-2-luca.dimaio1@gmail.com> <20250812191424.GP7965@frogsfrogsfrogs>
In-Reply-To: <20250812191424.GP7965@frogsfrogsfrogs>
From: Luca Di Maio <luca.dimaio1@gmail.com>
Date: Mon, 25 Aug 2025 11:42:05 +0200
X-Gm-Features: Ac12FXwxGBShpinPOBOZrID48wOMIkJRs1R60QPnYaHTf38U2NWkMweVa621rbg
Message-ID: <CANSUjYa2pKy2ifjoqAubNTYCkou+HBv1Jbe8zGujTaPn=-7q8w@mail.gmail.com>
Subject: Re: [PATCH v12 1/1] proto: add ability to populate a filesystem from
 a directory
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev, 
	smoser@chainguard.dev, hch@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks a lot Darrick, I'm very glad this worked out in the end

L.

On Tue, Aug 12, 2025 at 9:14=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Wed, Jul 30, 2025 at 06:12:22PM +0200, Luca Di Maio wrote:
> > This patch implements the functionality to populate a newly created XFS
> > filesystem directly from an existing directory structure.
> >
> > It resuses existing protofile logic, it branches if input is a
> > directory.
> >
> > The population process steps are as follows:
> >   - create the root inode before populating content
> >   - recursively process nested directories
> >   - handle regular files, directories, symlinks, char devices, block
> >     devices, sockets, fifos
> >   - preserve attributes (ownership, permissions)
> >   - preserve mtime timestamps from source files to maintain file histor=
y
> >     - use current time for atime/ctime/crtime
> >     - possible to specify atime=3D1 to preserve atime timestamps from
> >       source files
> >   - preserve extended attributes and fsxattrs for all file types
> >   - preserve hardlinks
> >
> > At the moment, the implementation for the hardlink tracking is very
> > simple, as it involves a linear search.
> > from my local testing using larger source directories
> > (1.3mln inodes, ~400k hardlinks) the difference was actually
> > just a few seconds (given that most of the time is doing i/o).
> > We might want to revisit that in the future if this becomes a
> > bottleneck.
> >
> > This functionality makes it easier to create populated filesystems
> > without having to mount them, it's particularly useful for
> > reproducible builds.
> >
> > Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
>
> Looks good to me at long last,
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
>
> Thank you very much for filling this functionality gap!
>
> --D
>
> > ---
> >  man/man8/mkfs.xfs.8.in |  38 +-
> >  mkfs/proto.c           | 771 ++++++++++++++++++++++++++++++++++++++++-
> >  mkfs/proto.h           |  18 +-
> >  mkfs/xfs_mkfs.c        |  23 +-
> >  4 files changed, 817 insertions(+), 33 deletions(-)
> >
> > diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
> > index bc804931..4497468f 100644
> > --- a/man/man8/mkfs.xfs.8.in
> > +++ b/man/man8/mkfs.xfs.8.in
> > @@ -28,7 +28,7 @@ mkfs.xfs \- construct an XFS filesystem
> >  .I naming_options
> >  ] [
> >  .B \-p
> > -.I protofile_options
> > +.I prototype_options
> >  ] [
> >  .B \-q
> >  ] [
> > @@ -977,30 +977,40 @@ option set.
> >  .PP
> >  .PD 0
> >  .TP
> > -.BI \-p " protofile_options"
> > +.BI \-p " prototype_options"
> >  .TP
> >  .BI "Section Name: " [proto]
> >  .PD
> > -These options specify the protofile parameters for populating the file=
system.
> > +These options specify the prototype parameters for populating the file=
system.
> >  The valid
> > -.I protofile_options
> > +.I prototype_options
> >  are:
> >  .RS 1.2i
> >  .TP
> > -.BI [file=3D] protofile
> > +.BI [file=3D]
> >  The
> >  .B file=3D
> >  prefix is not required for this CLI argument for legacy reasons.
> >  If specified as a config file directive, the prefix is required.
> > -
> > +.TP
> > +.BI [file=3D] directory
> >  If the optional
> >  .PD
> > -.I protofile
> > -argument is given,
> > +.I prototype
> > +argument is given, and it's a directory,
> >  .B mkfs.xfs
> > -uses
> > -.I protofile
> > -as a prototype file and takes its directions from that file.
> > +will populate the root file system with the contents of the given dire=
ctory
> > +tree.
> > +Content, timestamps (atime, mtime), attributes and extended attributes
> > +are preserved for all file types.
> > +.TP
> > +.BI [file=3D] protofile
> > +If the optional
> > +.PD
> > +.I prototype
> > +argument is given, and points to a regular file,
> > +.B mkfs.xfs
> > +uses it as a prototype file and takes its directions from that file.
> >  The blocks and inodes specifiers in the
> >  .I protofile
> >  are provided for backwards compatibility, but are otherwise unused.
> > @@ -1136,8 +1146,12 @@ always terminated with the dollar (
> >  .B $
> >  ) token.
> >  .TP
> > +.BI atime=3D value
> > +If set to 1,  mkfs will copy in access timestamps from the source file=
s.
> > +Otherwise, access timestamps will be set to the current time.
> > +.TP
> >  .BI slashes_are_spaces=3D value
> > -If set to 1, slashes ("/") in the first token of each line of the prot=
ofile
> > +If set to 1, slashes ("/") in the first token of each line of the prot=
otype file
> >  are converted to spaces.
> >  This enables the creation of a filesystem containing filenames with sp=
aces.
> >  By default, this is set to 0.
> > diff --git a/mkfs/proto.c b/mkfs/proto.c
> > index 7f80bef8..bd73d38c 100644
> > --- a/mkfs/proto.c
> > +++ b/mkfs/proto.c
> > @@ -5,6 +5,8 @@
> >   */
> >
> >  #include "libxfs.h"
> > +#include <dirent.h>
> > +#include <sys/resource.h>
> >  #include <sys/stat.h>
> >  #include <sys/xattr.h>
> >  #include <linux/xattr.h>
> > @@ -21,6 +23,11 @@ static void rsvfile(xfs_mount_t *mp, xfs_inode_t *ip=
, long long len);
> >  static int newregfile(char **pp, char **fname);
> >  static void rtinit(xfs_mount_t *mp);
> >  static off_t filesize(int fd);
> > +static void populate_from_dir(struct xfs_mount *mp, struct fsxattr *fs=
xp,
> > +             char *source_dir);
> > +static void walk_dir(struct xfs_mount *mp, struct xfs_inode *pip,
> > +             struct fsxattr *fsxp, char *path_buf, int path_len);
> > +static int preserve_atime;
> >  static int slashes_are_spaces;
> >
> >  /*
> > @@ -54,23 +61,49 @@ getnum(
> >       return i;
> >  }
> >
> > -char *
> > +struct proto_source
> >  setup_proto(
> > -     char    *fname)
> > +     char                    *fname)
> >  {
> > -     char            *buf =3D NULL;
> > -     static char     dflt[] =3D "d--755 0 0 $";
> > -     int             fd;
> > -     long            size;
> > +     struct proto_source     result =3D {};
> > +     struct stat             statbuf;
> > +     char                    *buf =3D NULL;
> > +     static char             dflt[] =3D "d--755 0 0 $";
> > +     int                     fd;
> > +     long                    size;
> > +
> > +     /*
> > +      * If no prototype path is supplied, use the default protofile wh=
ich
> > +      * creates only a root directory.
> > +      */
> > +     if (!fname) {
> > +             result.type =3D PROTO_SRC_PROTOFILE;
> > +             result.data =3D dflt;
> > +             return result;
> > +     }
> >
> > -     if (!fname)
> > -             return dflt;
> >       if ((fd =3D open(fname, O_RDONLY)) < 0 || (size =3D filesize(fd))=
 < 0) {
> >               fprintf(stderr, _("%s: failed to open %s: %s\n"),
> >                       progname, fname, strerror(errno));
> >               goto out_fail;
> >       }
> >
> > +     if (fstat(fd, &statbuf) < 0)
> > +             fail(_("invalid or unreadable source path"), errno);
> > +
> > +     /*
> > +      * Handle directory inputs.
> > +      */
> > +     if (S_ISDIR(statbuf.st_mode)) {
> > +             close(fd);
> > +             result.type =3D PROTO_SRC_DIR;
> > +             result.data =3D fname;
> > +             return result;
> > +     }
> > +
> > +     /*
> > +      * Else this is a protofile, let's handle traditionally.
> > +      */
> >       buf =3D malloc(size + 1);
> >       if (read(fd, buf, size) < size) {
> >               fprintf(stderr, _("%s: read failed on %s: %s\n"),
> > @@ -90,7 +123,10 @@ setup_proto(
> >       (void)getnum(getstr(&buf), 0, 0, false);        /* block count */
> >       (void)getnum(getstr(&buf), 0, 0, false);        /* inode count */
> >       close(fd);
> > -     return buf;
> > +
> > +     result.type =3D PROTO_SRC_PROTOFILE;
> > +     result.data =3D buf;
> > +     return result;
> >
> >  out_fail:
> >       if (fd >=3D 0)
> > @@ -379,6 +415,13 @@ writeattr(
> >       int                     error;
> >
> >       ret =3D fgetxattr(fd, attrname, valuebuf, valuelen);
> > +     /*
> > +      * In case of filedescriptors with O_PATH, fgetxattr() will fail =
with
> > +      * EBADF.
> > +      * Let's try to fallback to lgetxattr() using input path.
> > +      */
> > +     if (ret < 0 && errno =3D=3D EBADF)
> > +             ret =3D lgetxattr(fname, attrname, valuebuf, valuelen);
> >       if (ret < 0) {
> >               if (errno =3D=3D EOPNOTSUPP)
> >                       return;
> > @@ -425,6 +468,13 @@ writeattrs(
> >               fail(_("error allocating xattr name buffer"), errno);
> >
> >       ret =3D flistxattr(fd, namebuf, XATTR_LIST_MAX);
> > +     /*
> > +      * In case of filedescriptors with O_PATH, flistxattr() will fail=
 with
> > +      * EBADF.
> > +      * Let's try to fallback to llistxattr() using input path.
> > +      */
> > +     if (ret < 0 && errno =3D=3D EBADF)
> > +             ret =3D llistxattr(fname, namebuf, XATTR_LIST_MAX);
> >       if (ret < 0) {
> >               if (errno =3D=3D EOPNOTSUPP)
> >                       goto out_namebuf;
> > @@ -931,13 +981,29 @@ parseproto(
> >
> >  void
> >  parse_proto(
> > -     xfs_mount_t     *mp,
> > -     struct fsxattr  *fsx,
> > -     char            **pp,
> > -     int             proto_slashes_are_spaces)
> > +     xfs_mount_t             *mp,
> > +     struct fsxattr          *fsx,
> > +     struct proto_source     *protosource,
> > +     int                     proto_slashes_are_spaces,
> > +     int                     proto_preserve_atime)
> >  {
> > +     preserve_atime =3D proto_preserve_atime;
> >       slashes_are_spaces =3D proto_slashes_are_spaces;
> > -     parseproto(mp, NULL, fsx, pp, NULL);
> > +
> > +     /*
> > +      * In case of a file input, we will use the prototype file logic =
else
> > +      * we will fallback to populate from dir.
> > +      */
> > +     switch(protosource->type) {
> > +     case PROTO_SRC_PROTOFILE:
> > +             parseproto(mp, NULL, fsx, &protosource->data, NULL);
> > +             break;
> > +     case PROTO_SRC_DIR:
> > +             populate_from_dir(mp, fsx, protosource->data);
> > +             break;
> > +     case PROTO_SRC_NONE:
> > +             fail(_("invalid or unreadable source path"), ENOENT);
> > +     }
> >  }
> >
> >  /* Create a sb-rooted metadata file. */
> > @@ -1172,3 +1238,680 @@ filesize(
> >               return -1;
> >       return stb.st_size;
> >  }
> > +
> > +/* Try to allow as many open directories as possible. */
> > +static void
> > +bump_max_fds(void)
> > +{
> > +     struct rlimit   rlim =3D {};
> > +     int             ret;
> > +
> > +     ret =3D getrlimit(RLIMIT_NOFILE, &rlim);
> > +     if (ret)
> > +             return;
> > +
> > +     rlim.rlim_cur =3D rlim.rlim_max;
> > +     ret =3D setrlimit(RLIMIT_NOFILE, &rlim);
> > +     if (ret < 0)
> > +             fprintf(stderr, _("%s: could not bump fd limit: [ %d - %s=
]\n"),
> > +                     progname, errno, strerror(errno));
> > +}
> > +
> > +static void
> > +writefsxattrs(
> > +     struct xfs_inode        *ip,
> > +     struct fsxattr          *fsxp)
> > +{
> > +     ip->i_projid  =3D fsxp->fsx_projid;
> > +     ip->i_extsize =3D fsxp->fsx_extsize;
> > +     ip->i_diflags =3D xfs_flags2diflags(ip, fsxp->fsx_xflags);
> > +     if (xfs_has_v3inodes(ip->i_mount)) {
> > +             ip->i_diflags2   =3D xfs_flags2diflags2(ip, fsxp->fsx_xfl=
ags);
> > +             ip->i_cowextsize =3D fsxp->fsx_cowextsize;
> > +     }
> > +}
> > +
> > +static void
> > +writetimestamps(
> > +     struct xfs_inode        *ip,
> > +     struct stat             *statbuf)
> > +{
> > +     struct timespec64       ts;
> > +
> > +     /*
> > +      * Copy timestamps from source file to destination inode.
> > +      * Usually reproducible archives will delete or not register
> > +      * atime and ctime, for example:
> > +      *    https://www.gnu.org/software/tar/manual/html_section/Reprod=
ucibility.html
> > +      * hence we will only copy mtime, and let ctime/crtime be set to
> > +      * current time.
> > +      * atime will be copied over if atime is true.
> > +      */
> > +     ts.tv_sec  =3D statbuf->st_mtim.tv_sec;
> > +     ts.tv_nsec =3D statbuf->st_mtim.tv_nsec;
> > +     inode_set_mtime_to_ts(VFS_I(ip), ts);
> > +
> > +     /*
> > +      * In case of atime option, we will copy the atime  timestamp
> > +      * from source.
> > +      */
> > +     if (preserve_atime) {
> > +             ts.tv_sec  =3D statbuf->st_atim.tv_sec;
> > +             ts.tv_nsec =3D statbuf->st_atim.tv_nsec;
> > +             inode_set_atime_to_ts(VFS_I(ip), ts);
> > +     }
> > +}
> > +
> > +struct hardlink {
> > +     ino_t           src_ino;
> > +     xfs_ino_t       dst_ino;
> > +};
> > +
> > +struct hardlinks {
> > +     size_t          count;
> > +     size_t          size;
> > +     struct hardlink *entries;
> > +};
> > +
> > +/* Growth strategy for hardlink tracking array */
> > +/* Double size for small arrays */
> > +#define HARDLINK_DEFAULT_GROWTH_FACTOR       2
> > +/* Grow by 25% for large arrays */
> > +#define HARDLINK_LARGE_GROWTH_FACTOR 0.25
> > +/* Threshold to switch growth strategies */
> > +#define HARDLINK_THRESHOLD           1024
> > +/* Initial allocation size */
> > +#define HARDLINK_TRACKER_INITIAL_SIZE        4096
> > +
> > +/*
> > + * Keep track of source inodes that are from hardlinks so we can retri=
eve them
> > + * when needed to setup in destination.
> > + */
> > +static struct hardlinks hardlink_tracker =3D { 0 };
> > +
> > +static void
> > +init_hardlink_tracker(void)
> > +{
> > +     hardlink_tracker.size =3D HARDLINK_TRACKER_INITIAL_SIZE;
> > +     hardlink_tracker.entries =3D calloc(
> > +                     hardlink_tracker.size,
> > +                     sizeof(struct hardlink));
> > +     if (!hardlink_tracker.entries)
> > +             fail(_("error allocating hardlinks tracking array"), errn=
o);
> > +}
> > +
> > +static void
> > +cleanup_hardlink_tracker(void)
> > +{
> > +     free(hardlink_tracker.entries);
> > +     hardlink_tracker.entries =3D NULL;
> > +     hardlink_tracker.count =3D 0;
> > +     hardlink_tracker.size =3D 0;
> > +}
> > +
> > +static xfs_ino_t
> > +get_hardlink_dst_inode(
> > +     xfs_ino_t       i_ino)
> > +{
> > +     for (size_t i =3D 0; i < hardlink_tracker.count; i++) {
> > +             if (hardlink_tracker.entries[i].src_ino =3D=3D i_ino)
> > +                     return hardlink_tracker.entries[i].dst_ino;
> > +     }
> > +     return 0;
> > +}
> > +
> > +static void
> > +track_hardlink_inode(
> > +     ino_t   src_ino,
> > +     xfs_ino_t       dst_ino)
> > +{
> > +     if (hardlink_tracker.count >=3D hardlink_tracker.size) {
> > +             /*
> > +              * double for smaller capacity.
> > +              * instead grow by 25% steps for larger capacities.
> > +              */
> > +             const size_t old_size =3D hardlink_tracker.size;
> > +             size_t new_size =3D old_size * HARDLINK_DEFAULT_GROWTH_FA=
CTOR;
> > +             if (old_size > HARDLINK_THRESHOLD)
> > +                     new_size =3D old_size + (old_size * HARDLINK_LARG=
E_GROWTH_FACTOR);
> > +
> > +             struct hardlink *resized_array =3D reallocarray(
> > +                             hardlink_tracker.entries,
> > +                             new_size,
> > +                             sizeof(struct hardlink));
> > +             if (!resized_array)
> > +                     fail(_("error enlarging hardlinks tracking array"=
), errno);
> > +
> > +             memset(&resized_array[old_size], 0,
> > +                             (new_size - old_size) * sizeof(struct har=
dlink));
> > +
> > +             hardlink_tracker.entries =3D resized_array;
> > +             hardlink_tracker.size =3D new_size;
> > +     }
> > +     hardlink_tracker.entries[hardlink_tracker.count].src_ino =3D src_=
ino;
> > +     hardlink_tracker.entries[hardlink_tracker.count].dst_ino =3D dst_=
ino;
> > +     hardlink_tracker.count++;
> > +}
> > +
> > +/*
> > + * This function will first check in our tracker if the input hardlink=
 has
> > + * already been stored, if not report false so create_nondir_inode() c=
an continue
> > + * handling the inode as regularly, and later save the source inode in=
 our
> > + * buffer for future consumption.
> > + */
> > +static bool
> > +handle_hardlink(
> > +     struct xfs_mount        *mp,
> > +     struct xfs_inode        *pip,
> > +     struct xfs_name         xname,
> > +     struct stat             file_stat)
> > +{
> > +     int                     error;
> > +     xfs_ino_t               dst_ino;
> > +     struct xfs_inode        *ip;
> > +     struct xfs_trans        *tp;
> > +     struct xfs_parent_args  *ppargs =3D NULL;
> > +
> > +     tp =3D getres(mp, 0);
> > +     ppargs =3D newpptr(mp);
> > +     dst_ino =3D get_hardlink_dst_inode(file_stat.st_ino);
> > +
> > +     /*
> > +      * We didn't find the hardlink inode, this means it's the first t=
ime
> > +      * we see it, report error so create_nondir_inode() can continue =
handling the
> > +      * inode as a regular file type, and later save the source inode =
in our
> > +      * buffer for future consumption.
> > +      */
> > +     if (dst_ino =3D=3D 0)
> > +             return false;
> > +
> > +     error =3D libxfs_iget(mp, NULL, dst_ino, 0, &ip);
> > +     if (error)
> > +             fail(_("failed to get inode"), error);
> > +
> > +     /*
> > +      * In case the inode was already in our tracker we need to setup =
the
> > +      * hardlink and skip file copy.
> > +      */
> > +     libxfs_trans_ijoin(tp, pip, 0);
> > +     libxfs_trans_ijoin(tp, ip, 0);
> > +     newdirent(mp, tp, pip, &xname, ip, ppargs);
> > +
> > +     /*
> > +      * Increment the link count
> > +      */
> > +     libxfs_bumplink(tp, ip);
> > +
> > +     libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> > +
> > +     error =3D -libxfs_trans_commit(tp);
> > +     if (error)
> > +             fail(_("Error encountered creating file from prototype fi=
le"), error);
> > +
> > +     libxfs_parent_finish(mp, ppargs);
> > +     libxfs_irele(ip);
> > +
> > +     return true;
> > +}
> > +
> > +static void
> > +create_directory_inode(
> > +     struct xfs_mount        *mp,
> > +     struct xfs_inode        *pip,
> > +     struct fsxattr          *fsxp,
> > +     int                     mode,
> > +     struct cred             creds,
> > +     struct xfs_name         xname,
> > +     int                     flags,
> > +     struct stat             file_stat,
> > +     int                     fd,
> > +     char                    *entryname,
> > +     char                    *path_buf,
> > +     int                     path_len)
> > +{
> > +
> > +     int                     error;
> > +     struct xfs_inode        *ip;
> > +     struct xfs_trans        *tp;
> > +     struct xfs_parent_args  *ppargs =3D NULL;
> > +
> > +     tp =3D getres(mp, 0);
> > +     ppargs =3D newpptr(mp);
> > +
> > +     error =3D creatproto(&tp, pip, mode, 0, &creds, fsxp, &ip);
> > +     if (error)
> > +             fail(_("Inode allocation failed"), error);
> > +
> > +     libxfs_trans_ijoin(tp, pip, 0);
> > +
> > +     newdirent(mp, tp, pip, &xname, ip, ppargs);
> > +
> > +     libxfs_bumplink(tp, pip);
> > +     libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
> > +     newdirectory(mp, tp, ip, pip);
> > +
> > +     /*
> > +      * Copy over timestamps.
> > +      */
> > +     writetimestamps(ip, &file_stat);
> > +
> > +     libxfs_trans_log_inode(tp, ip, flags);
> > +
> > +     error =3D -libxfs_trans_commit(tp);
> > +     if (error)
> > +             fail(_("Directory inode allocation failed."), error);
> > +
> > +     libxfs_parent_finish(mp, ppargs);
> > +     tp =3D NULL;
> > +
> > +     /*
> > +      * Copy over attributes.
> > +      */
> > +     writeattrs(ip, entryname, fd);
> > +     writefsxattrs(ip, fsxp);
> > +     close(fd);
> > +
> > +     walk_dir(mp, ip, fsxp, path_buf, path_len);
> > +
> > +     libxfs_irele(ip);
> > +}
> > +
> > +static void
> > +create_nondir_inode(
> > +     struct xfs_mount        *mp,
> > +     struct xfs_inode        *pip,
> > +     struct fsxattr          *fsxp,
> > +     int                     mode,
> > +     struct cred             creds,
> > +     struct xfs_name         xname,
> > +     int                     flags,
> > +     struct stat             file_stat,
> > +     xfs_dev_t               rdev,
> > +     int                     fd,
> > +     char                    *src_fname)
> > +{
> > +
> > +     char                    link_target[XFS_SYMLINK_MAXLEN];
> > +     int                     error;
> > +     ssize_t                 link_len =3D 0;
> > +     struct xfs_inode        *ip;
> > +     struct xfs_trans        *tp;
> > +     struct xfs_parent_args  *ppargs =3D NULL;
> > +
> > +     /*
> > +      * If handle_hardlink() returns true it means the hardlink has be=
en
> > +      * correctly found and set, so we don't need to do anything else.
> > +      */
> > +     if (file_stat.st_nlink > 1 && handle_hardlink(mp, pip, xname, fil=
e_stat)) {
> > +             close(fd);
> > +             return;
> > +     }
> > +     /*
> > +      * If instead we have an error it means the hardlink was not regi=
stered,
> > +      * so we proceed to treat it like a regular file, and save it to =
our
> > +      * tracker later.
> > +      */
> > +     tp =3D getres(mp, 0);
> > +     /*
> > +      * In case of symlinks, we need to handle things a little differe=
ntly.
> > +      * We need to read out our link target and act accordingly.
> > +      */
> > +     if (xname.type =3D=3D XFS_DIR3_FT_SYMLINK) {
> > +             link_len =3D readlink(src_fname, link_target, XFS_SYMLINK=
_MAXLEN);
> > +             if (link_len < 0)
> > +                     fail(_("could not resolve symlink"), errno);
> > +             if (link_len >=3D PATH_MAX)
> > +                     fail(_("symlink target too long"), ENAMETOOLONG);
> > +             tp =3D getres(mp, XFS_B_TO_FSB(mp, link_len));
> > +     }
> > +     ppargs =3D newpptr(mp);
> > +
> > +     error =3D creatproto(&tp, pip, mode, rdev, &creds, fsxp, &ip);
> > +     if (error)
> > +             fail(_("Inode allocation failed"), error);
> > +
> > +     /*
> > +      * In case of symlinks, we now write it down, for other file type=
s
> > +      * this is handled later before cleanup.
> > +      */
> > +     if (xname.type =3D=3D XFS_DIR3_FT_SYMLINK)
> > +             writesymlink(tp, ip, link_target, link_len);
> > +
> > +     libxfs_trans_ijoin(tp, pip, 0);
> > +     newdirent(mp, tp, pip, &xname, ip, ppargs);
> > +
> > +     /*
> > +      * Copy over timestamps.
> > +      */
> > +     writetimestamps(ip, &file_stat);
> > +
> > +     libxfs_trans_log_inode(tp, ip, flags);
> > +
> > +     error =3D -libxfs_trans_commit(tp);
> > +     if (error)
> > +             fail(_("Error encountered creating non dir inode"), error=
);
> > +
> > +     libxfs_parent_finish(mp, ppargs);
> > +
> > +     /*
> > +      * Copy over file content, attributes, extended attributes and
> > +      * timestamps.
> > +      */
> > +     if (fd >=3D 0) {
> > +             /* We need to writefile only when not dealing with a syml=
ink. */
> > +             if (xname.type !=3D XFS_DIR3_FT_SYMLINK)
> > +                     writefile(ip, src_fname, fd);
> > +             writeattrs(ip, src_fname, fd);
> > +             close(fd);
> > +     }
> > +     /*
> > +      * We do fsxattr also for file types where we don't have an fd,
> > +      * for example FIFOs.
> > +      */
> > +     writefsxattrs(ip, fsxp);
> > +
> > +     /*
> > +      * If we're here it means this is the first time we're encounteri=
ng an
> > +      * hardlink, so we need to store it.
> > +      */
> > +     if (file_stat.st_nlink > 1)
> > +             track_hardlink_inode(file_stat.st_ino, ip->i_ino);
> > +
> > +     libxfs_irele(ip);
> > +}
> > +
> > +static void
> > +handle_direntry(
> > +     struct xfs_mount        *mp,
> > +     struct xfs_inode        *pip,
> > +     struct fsxattr          *fsxp,
> > +     char                    *path_buf,
> > +     int                     path_len,
> > +     struct dirent           *entry)
> > +{
> > +     char                    *fname =3D "";
> > +     int                     flags;
> > +     int                     majdev;
> > +     int                     mindev;
> > +     int                     mode;
> > +     int                     pathfd,fd =3D -1;
> > +     int                     rdev =3D 0;
> > +     struct stat             file_stat;
> > +     struct xfs_name         xname;
> > +
> > +     pathfd =3D open(path_buf, O_NOFOLLOW | O_PATH);
> > +     if (pathfd < 0){
> > +             fprintf(stderr, _("%s: cannot open %s: %s\n"), progname,
> > +                     path_buf, strerror(errno));
> > +             exit(1);
> > +     }
> > +
> > +     /*
> > +      * Symlinks and sockets will need to be opened with O_PATH to wor=
k, so
> > +      * we handle this special case.
> > +      */
> > +     fd =3D openat(pathfd, entry->d_name, O_NOFOLLOW | O_PATH);
> > +     if(fd < 0) {
> > +             fprintf(stderr, _("%s: cannot open %s: %s\n"), progname,
> > +                     path_buf, strerror(errno));
> > +             exit(1);
> > +     }
> > +
> > +     if (fstat(fd, &file_stat) < 0) {
> > +             fprintf(stderr, _("%s: cannot stat '%s': %s (errno=3D%d)\=
n"),
> > +                     progname, path_buf, strerror(errno), errno);
> > +             exit(1);
> > +     }
> > +
> > +     /* Ensure we're within the limits of PATH_MAX. */
> > +     size_t avail =3D PATH_MAX - path_len;
> > +     size_t wrote =3D snprintf(path_buf + path_len, avail, "/%s", entr=
y->d_name);
> > +     if (wrote > avail)
> > +             fail(path_buf, ENAMETOOLONG);
> > +
> > +     /*
> > +      * Regular files instead need to be reopened with broader flags s=
o we
> > +      * check if that's the case and reopen those.
> > +      */
> > +     if (!S_ISSOCK(file_stat.st_mode) &&
> > +         !S_ISLNK(file_stat.st_mode)  &&
> > +         !S_ISFIFO(file_stat.st_mode)) {
> > +             close(fd);
> > +             /*
> > +              * Try to open the source file noatime to avoid a flood o=
f
> > +              * writes to the source fs, but we can fall back to plain
> > +              * readonly mode if we don't have enough permission.
> > +              */
> > +             fd =3D openat(pathfd, entry->d_name,
> > +                         O_NOFOLLOW | O_RDONLY | O_NOATIME);
> > +             if (fd < 0)
> > +                     fd =3D openat(pathfd, entry->d_name,
> > +                                 O_NOFOLLOW | O_RDONLY);
> > +             if(fd < 0) {
> > +                     fprintf(stderr, _("%s: cannot open %s: %s\n"), pr=
ogname,
> > +                             path_buf, strerror(errno));
> > +                     exit(1);
> > +             }
> > +     }
> > +
> > +     struct cred creds =3D {
> > +             .cr_uid =3D file_stat.st_uid,
> > +             .cr_gid =3D file_stat.st_gid,
> > +     };
> > +
> > +     xname.name =3D (unsigned char *)entry->d_name;
> > +     xname.len =3D strlen(entry->d_name);
> > +     xname.type =3D 0;
> > +     mode =3D file_stat.st_mode;
> > +     flags =3D XFS_ILOG_CORE;
> > +
> > +     switch (file_stat.st_mode & S_IFMT) {
> > +     case S_IFDIR:
> > +             xname.type =3D XFS_DIR3_FT_DIR;
> > +             create_directory_inode(mp, pip, fsxp, mode, creds, xname,=
 flags,
> > +                                    file_stat, fd, entry->d_name, path=
_buf,
> > +                                    path_len + strlen(entry->d_name) +=
 1);
> > +             goto out;
> > +     case S_IFREG:
> > +             xname.type =3D XFS_DIR3_FT_REG_FILE;
> > +             fname =3D entry->d_name;
> > +             break;
> > +     case S_IFCHR:
> > +             flags |=3D XFS_ILOG_DEV;
> > +             xname.type =3D XFS_DIR3_FT_CHRDEV;
> > +             majdev =3D major(file_stat.st_rdev);
> > +             mindev =3D minor(file_stat.st_rdev);
> > +             rdev =3D IRIX_MKDEV(majdev, mindev);
> > +             fname =3D entry->d_name;
> > +             break;
> > +     case S_IFBLK:
> > +             flags |=3D XFS_ILOG_DEV;
> > +             xname.type =3D XFS_DIR3_FT_BLKDEV;
> > +             majdev =3D major(file_stat.st_rdev);
> > +             mindev =3D minor(file_stat.st_rdev);
> > +             rdev =3D IRIX_MKDEV(majdev, mindev);
> > +             fname =3D entry->d_name;
> > +             break;
> > +     case S_IFLNK:
> > +             /*
> > +              * Being a symlink we opened the filedescriptor with O_PA=
TH
> > +              * this will make flistxattr() and fgetxattr() fail with =
EBADF,
> > +              * so we  will need to fallback to llistxattr() and lgetx=
attr(),
> > +              * this will need the full path to the original file, not=
 just
> > +              * the entry name.
> > +              */
> > +             xname.type =3D XFS_DIR3_FT_SYMLINK;
> > +             fname =3D path_buf;
> > +             break;
> > +     case S_IFIFO:
> > +             /*
> > +              * Being a fifo we opened the filedescriptor with O_PATH
> > +              * this will make flistxattr() and fgetxattr() fail with =
EBADF,
> > +              * so we  will need to fallback to llistxattr() and lgetx=
attr(),
> > +              * this will need the full path to the original file, not=
 just
> > +              * the entry name.
> > +              */
> > +             xname.type =3D XFS_DIR3_FT_FIFO;
> > +             fname =3D path_buf;
> > +             break;
> > +     case S_IFSOCK:
> > +             /*
> > +              * Being a socket we opened the filedescriptor with O_PAT=
H
> > +              * this will make flistxattr() and fgetxattr() fail with =
EBADF,
> > +              * so we  will need to fallback to llistxattr() and lgetx=
attr(),
> > +              * this will need the full path to the original file, not=
 just
> > +              * the entry name.
> > +              */
> > +             xname.type =3D XFS_DIR3_FT_SOCK;
> > +             fname =3D path_buf;
> > +             break;
> > +     default:
> > +             break;
> > +     }
> > +
> > +     create_nondir_inode(mp, pip, fsxp, mode, creds, xname, flags, fil=
e_stat,
> > +                         rdev, fd, fname);
> > +out:
> > +     /* Reset path_buf to original */
> > +     path_buf[path_len] =3D '\0';
> > +}
> > +
> > +/*
> > + * Walk_dir will recursively list files and directories and populate t=
he
> > + * mountpoint *mp with them using handle_direntry().
> > + */
> > +static void
> > +walk_dir(
> > +     struct xfs_mount        *mp,
> > +     struct xfs_inode        *pip,
> > +     struct fsxattr          *fsxp,
> > +     char                    *path_buf,
> > +     int                     path_len)
> > +{
> > +     DIR                     *dir;
> > +     struct dirent           *entry;
> > +
> > +     /*
> > +      * Open input directory and iterate over all entries in it.
> > +      * when another directory is found, we will recursively call walk=
_dir.
> > +      */
> > +     if ((dir =3D opendir(path_buf)) =3D=3D NULL) {
> > +             fprintf(stderr, _("%s: cannot open input dir: %s [%d - %s=
]\n"),
> > +                             progname, path_buf, errno, strerror(errno=
));
> > +             exit(1);
> > +     }
> > +     while ((entry =3D readdir(dir)) !=3D NULL) {
> > +             if (strcmp(entry->d_name, ".") =3D=3D 0 ||
> > +                 strcmp(entry->d_name, "..") =3D=3D 0)
> > +                     continue;
> > +
> > +             handle_direntry(mp, pip, fsxp, path_buf, path_len, entry)=
;
> > +     }
> > +     closedir(dir);
> > +}
> > +
> > +static void
> > +populate_from_dir(
> > +     struct xfs_mount        *mp,
> > +     struct fsxattr          *fsxp,
> > +     char                    *cur_path)
> > +{
> > +     int                     error;
> > +     int                     mode;
> > +     int                     fd =3D -1;
> > +     char                    path_buf[PATH_MAX];
> > +     struct stat             file_stat;
> > +     struct xfs_inode        *ip;
> > +     struct xfs_trans        *tp;
> > +
> > +     /*
> > +      * Initialize path_buf cur_path, strip trailing slashes they're
> > +      * automatically added when walking the dir.
> > +      */
> > +     if (strlen(cur_path) > 1 && cur_path[strlen(cur_path)-1] =3D=3D '=
/')
> > +             cur_path[strlen(cur_path)-1] =3D '\0';
> > +     if (snprintf(path_buf, PATH_MAX, "%s", cur_path) >=3D PATH_MAX)
> > +             fail(_("path name too long"), ENAMETOOLONG);
> > +
> > +     if (lstat(path_buf, &file_stat) < 0) {
> > +             fprintf(stderr, _("%s: cannot stat '%s': %s (errno=3D%d)\=
n"),
> > +                     progname, path_buf, strerror(errno), errno);
> > +             exit(1);
> > +     }
> > +     fd =3D open(path_buf, O_NOFOLLOW | O_RDONLY | O_NOATIME);
> > +     if (fd < 0) {
> > +             fprintf(stderr, _("%s: cannot open %s: %s\n"),
> > +                     progname, path_buf, strerror(errno));
> > +             exit(1);
> > +     }
> > +
> > +     /*
> > +      * We first ensure we have the root inode.
> > +      */
> > +     struct cred creds =3D {
> > +             .cr_uid =3D file_stat.st_uid,
> > +             .cr_gid =3D file_stat.st_gid,
> > +     };
> > +     mode =3D file_stat.st_mode;
> > +
> > +     tp =3D getres(mp, 0);
> > +
> > +     error =3D creatproto(&tp, NULL, mode | S_IFDIR, 0, &creds, fsxp, =
&ip);
> > +     if (error)
> > +             fail(_("Inode allocation failed"), error);
> > +
> > +     mp->m_sb.sb_rootino =3D ip->i_ino;
> > +     libxfs_log_sb(tp);
> > +     newdirectory(mp, tp, ip, ip);
> > +     libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> > +
> > +     error =3D -libxfs_trans_commit(tp);
> > +     if (error)
> > +             fail(_("Inode allocation failed"), error);
> > +
> > +     libxfs_parent_finish(mp, NULL);
> > +
> > +     /*
> > +      * Copy over attributes.
> > +      */
> > +     writeattrs(ip, path_buf, fd);
> > +     writefsxattrs(ip, fsxp);
> > +     close(fd);
> > +
> > +     /*
> > +      * RT initialization. Do this here to ensure that the RT inodes g=
et
> > +      * placed after the root inode.
> > +      */
> > +     error =3D create_metadir(mp);
> > +     if (error)
> > +             fail(_("Creation of the metadata directory inode failed")=
, error);
> > +
> > +     rtinit(mp);
> > +
> > +     /*
> > +      * By nature of walk_dir() we could be opening a great number of =
fds
> > +      * for deeply nested directory trees. try to bump max fds limit.
> > +      */
> > +     bump_max_fds();
> > +
> > +     /*
> > +      * Initialize the hardlinks tracker.
> > +      */
> > +     init_hardlink_tracker();
> > +     /*
> > +      * Now that we have a root inode, let's walk the input dir and po=
pulate
> > +      * the partition.
> > +      */
> > +     walk_dir(mp, ip, fsxp, path_buf, strlen(cur_path));
> > +
> > +     /*
> > +      * Cleanup hardlinks tracker.
> > +      */
> > +     cleanup_hardlink_tracker();
> > +
> > +     /*
> > +      * We free up our root inode only when we finished populating the=
 root
> > +      * filesystem.
> > +      */
> > +     libxfs_irele(ip);
> > +}
> > diff --git a/mkfs/proto.h b/mkfs/proto.h
> > index be1ceb45..476f7851 100644
> > --- a/mkfs/proto.h
> > +++ b/mkfs/proto.h
> > @@ -6,9 +6,21 @@
> >  #ifndef MKFS_PROTO_H_
> >  #define MKFS_PROTO_H_
> >
> > -char *setup_proto(char *fname);
> > -void parse_proto(struct xfs_mount *mp, struct fsxattr *fsx, char **pp,
> > -             int proto_slashes_are_spaces);
> > +enum proto_source_type {
> > +     PROTO_SRC_NONE =3D 0,
> > +     PROTO_SRC_PROTOFILE,
> > +     PROTO_SRC_DIR
> > +};
> > +struct proto_source {
> > +     enum    proto_source_type type;
> > +     char    *data;
> > +};
> > +
> > +struct proto_source setup_proto(char *fname);
> > +void parse_proto(struct xfs_mount *mp, struct fsxattr *fsx,
> > +              struct proto_source *protosource,
> > +              int proto_slashes_are_spaces,
> > +              int proto_preserve_atime);
> >  void res_failed(int err);
> >
> >  #endif /* MKFS_PROTO_H_ */
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 812241c4..885377f1 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -123,6 +123,7 @@ enum {
> >
> >  enum {
> >       P_FILE =3D 0,
> > +     P_ATIME,
> >       P_SLASHES,
> >       P_MAX_OPTS,
> >  };
> > @@ -714,6 +715,7 @@ static struct opt_params popts =3D {
> >       .ini_section =3D "proto",
> >       .subopts =3D {
> >               [P_FILE] =3D "file",
> > +             [P_ATIME] =3D "atime",
> >               [P_SLASHES] =3D "slashes_are_spaces",
> >               [P_MAX_OPTS] =3D NULL,
> >       },
> > @@ -722,6 +724,12 @@ static struct opt_params popts =3D {
> >                 .conflicts =3D { { NULL, LAST_CONFLICT } },
> >                 .defaultval =3D SUBOPT_NEEDS_VAL,
> >               },
> > +             { .index =3D P_ATIME,
> > +               .conflicts =3D { { NULL, LAST_CONFLICT } },
> > +               .minval =3D 0,
> > +               .maxval =3D 1,
> > +               .defaultval =3D 1,
> > +             },
> >               { .index =3D P_SLASHES,
> >                 .conflicts =3D { { NULL, LAST_CONFLICT } },
> >                 .minval =3D 0,
> > @@ -1079,6 +1087,7 @@ struct cli_params {
> >       int     lsunit;
> >       int     is_supported;
> >       int     proto_slashes_are_spaces;
> > +     int     proto_atime;
> >       int     data_concurrency;
> >       int     log_concurrency;
> >       int     rtvol_concurrency;
> > @@ -1206,6 +1215,7 @@ usage( void )
> >  /* naming */         [-n size=3Dnum,version=3D2|ci,ftype=3D0|1,parent=
=3D0|1]]\n\
> >  /* no-op info only */        [-N]\n\
> >  /* prototype file */ [-p fname]\n\
> > +/* populate from directory */        [-p dirname,atime=3D0|1]\n\
> >  /* quiet */          [-q]\n\
> >  /* realtime subvol */        [-r extsize=3Dnum,size=3Dnum,rtdev=3Dxxx,=
rgcount=3Dn,rgsize=3Dn,\n\
> >                           concurrency=3Dnum,zoned=3D0|1,start=3Dn,reser=
ved=3Dn]\n\
> > @@ -2131,6 +2141,9 @@ proto_opts_parser(
> >       case P_SLASHES:
> >               cli->proto_slashes_are_spaces =3D getnum(value, opts, sub=
opt);
> >               break;
> > +     case P_ATIME:
> > +             cli->proto_atime =3D getnum(value, opts, subopt);
> > +             break;
> >       case P_FILE:
> >               fallthrough;
> >       default:
> > @@ -5682,7 +5695,7 @@ main(
> >       int                     discard =3D 1;
> >       int                     force_overwrite =3D 0;
> >       int                     quiet =3D 0;
> > -     char                    *protostring =3D NULL;
> > +     struct proto_source     protosource;
> >       int                     worst_freelist =3D 0;
> >
> >       struct libxfs_init      xi =3D {
> > @@ -5832,8 +5845,6 @@ main(
> >        */
> >       cfgfile_parse(&cli);
> >
> > -     protostring =3D setup_proto(cli.protofile);
> > -
> >       /*
> >        * Extract as much of the valid config as we can from the CLI inp=
ut
> >        * before opening the libxfs devices.
> > @@ -6010,7 +6021,11 @@ main(
> >       /*
> >        * Allocate the root inode and anything else in the proto file.
> >        */
> > -     parse_proto(mp, &cli.fsx, &protostring, cli.proto_slashes_are_spa=
ces);
> > +     protosource =3D setup_proto(cli.protofile);
> > +     parse_proto(mp, &cli.fsx,
> > +                     &protosource,
> > +                     cli.proto_slashes_are_spaces,
> > +                     cli.proto_atime);
> >
> >       /*
> >        * Protect ourselves against possible stupidity
> > --
> > 2.50.0
> >
