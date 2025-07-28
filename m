Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E065D271A84
	for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 15:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753716446; cv=none; b=eKOLC63cli0bIyId196XYNlF5btqhwE3AvoyUVHQx3DFNwmYkdO7FSZYnfmsokIAvr8HhlHPavziCVN0XfoutLK5Hagr1lGQP+qH44mH9f18eHSP/pf1nvQOVw/gG2I2mhNulu4YxnQ+vp8/eJ6yYrqEUEM1f/p+yO9DVgV9pS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753716446; c=relaxed/simple;
	bh=sgzd2P9HBsaS42a4n87TLEPJYK94CQPKdokUUkxfIAM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sWzA5GzNZ4uQvYfHIec7kR3iAVWE2BGDPoT6NaTFPOESqMwahPgRJyQVWyyG+boJgkjad1uxRO9neEXNG+QdgAq9e48hCYpXDxVc+UTiDbTuqBZUrsgVneHyXp+XX7MdG2G2qKFAXJn0OlQfZfEgLf7w9ekIXAViCjue6O2XOR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ECdmqlUc; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ECdmqlUc"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a57c8e247cso4126869f8f.1
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 08:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753716441; x=1754321241; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uRqRvpWs+b+1WqoFFUTTJIe1FojZPQm9A4tVNBKtOPs=;
        b=ECdmqlUctRSHRRN1oMzSBiQGTBqTczpAW2QuwadfFlXDQ6ZXyfBtpANKJBNEBxIap5
         3MF7016/CzPNYp/Es6oY8cSi/Hv/boxThdr0pVsmjxiau8HIn/hXAVx324dE9IR3Y+yr
         DCLmhHj0ie9h7iD3RAJfj2qoR+HSKmedCAstRM4nS6cTu3vg5VerPgdXrenP704Yy16s
         Bd/EsTHJ1rGMhO13Ob7pzzb4uS+zO8l3XxSKCQgFTOvGOPB9ietZPIO44fmYUhwxjD6N
         hue9MziMqJPWhF6eAgM2Mo+MDhAZrfAOwWJNFCNc6mtyZ9X2LijKwIMYdOqtX11At8jy
         glRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753716441; x=1754321241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uRqRvpWs+b+1WqoFFUTTJIe1FojZPQm9A4tVNBKtOPs=;
        b=P7WCpHOkAmpMyVtevSad+sguJ3STF+0oKQqKT3I1p3XILHsRm/oSAwh5WfR37WI2Rw
         t5yg/mbDj3qneJ329eQOJndwsNquBI9Yn/u7DrfiBqBvUjtrFLOzZGp/+NvlNBPNbxLO
         dZ12yPcmNkeJk88/40bqChhidQq7wm8NSzwBQv9nuwQKmxFRn4t1sw6rs989KWV2kGI1
         AMXUhXWdSfqXdzIfoFrLtOusdjlxFuSHloCEcFLVO8BmIyTrXb0c4Km1U7MuCflnv/hj
         8Z/5685JvqL/+lw2mwSlgsLMAyQB+Ye7NhG0mmE50JD3QlFmaQ6NLsWZqkmabYDU84e3
         BBrA==
X-Gm-Message-State: AOJu0Yxed2O8Ln4+Zc8HD95KjHxMLwLbtxm92m8CS35xYdNsu6U8CBTO
	Qq3FgAM1DA4yejm4jhJZfhwcQMAqQbFpyWdcU/mL5T9M9oDTLrjr5gxmwJyDNBOzlSQJd+DBnYn
	yplYsgCD/s8ZJP0BY4VgAFr8TpwrjwaQ=
X-Gm-Gg: ASbGncvrEn82JsmMaMtFWfF5Q+o4n1Ty3isJNXYiO+ZKq0emuT4zXl6g5ur0Hdobz93
	CvVAwXItVPbSr3mKsY0zsWUX2oZqmvibq9V5MIj4tN8lFJlUaL9VPBluRyaxpG5es8z8RJVkmzv
	ujMyqhLqgJTDFRzascCt6DFVL2U75pulqM+9d4hlLTERgZJEzKwhrvjhEQO6p96OXp2sY5CKP+2
	C6T
X-Google-Smtp-Source: AGHT+IFhuZJ7NfVQPtmQPGR35FrCTr3PtRVTddIHUYDErXpQOGM/IwhbVDKXpfb7IidnH4RIRaVJb4zjrs5rFv/zfP8=
X-Received: by 2002:a05:6000:2287:b0:3b7:8d3f:6669 with SMTP id
 ffacd0b85a97d-3b78d3f6aeemr580457f8f.32.1753716440548; Mon, 28 Jul 2025
 08:27:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250522211003.85919-1-luca.dimaio1@gmail.com>
 <20250522211003.85919-2-luca.dimaio1@gmail.com> <20250529015150.GE8303@frogsfrogsfrogs>
In-Reply-To: <20250529015150.GE8303@frogsfrogsfrogs>
From: Luca Di Maio <luca.dimaio1@gmail.com>
Date: Mon, 28 Jul 2025 17:27:04 +0200
X-Gm-Features: Ac12FXyNXN-xhSxfquy9EfYbbgILEcPp2VG364zvyiSaoV35NPVpae4j8QZOlo4
Message-ID: <CANSUjYYZd-jFVfXt7sx9i7hkSD_jqG6skQ2Why5szRDJtQ2-Ow@mail.gmail.com>
Subject: Re: [PATCH v10 1/1] proto: add ability to populate a filesystem from
 a directory
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the review Christoph, Darrick
Sorry for the long delay, a v11 path will be sent in a bit, addressing
the issues raised in you reviews

Thanks
L.

On Thu, May 29, 2025 at 3:51=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Thu, May 22, 2025 at 05:10:03PM -0400, Luca Di Maio wrote:
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
>
> In addition to all of hch's comments...
>
> > Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
> > ---
> >  man/man8/mkfs.xfs.8.in |  41 ++-
> >  mkfs/proto.c           | 765 ++++++++++++++++++++++++++++++++++++++++-
> >  mkfs/proto.h           |  18 +-
> >  mkfs/xfs_mkfs.c        |  23 +-
> >  4 files changed, 821 insertions(+), 26 deletions(-)
> >
> > diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
> > index 37e3a88e..bb38c148 100644
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
> > @@ -977,30 +977,39 @@ option set.
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
ctory.
> > +Content, timestamps (atime, mtime), attributes and extended attributes=
 are preserved
> > +for all file types.
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
> > @@ -1136,8 +1145,16 @@ always terminated with the dollar (
> >  .B $
> >  ) token.
> >  .TP
> > +.BI atime=3D value
> > +If set to 1, when we're populating the root filesystem from a director=
y (
> > +.B file=3Ddirectory
> > +option)
> > +access times are going to be preserved and are copied from the source =
files.
> > +Set to 0 to set access times to the current time instead.
> > +By default, this is set to 0.
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
> > index 7f56a3d8..0c456248 100644
> > --- a/mkfs/proto.c
> > +++ b/mkfs/proto.c
> > @@ -5,6 +5,10 @@
> >   */
> >
> >  #include "libxfs.h"
> > +#include "xfs_format.h"
> > +#include <dirent.h>
> > +#include <fcntl.h>
> > +#include <sys/resource.h>
> >  #include <sys/stat.h>
> >  #include <sys/xattr.h>
> >  #include <linux/xattr.h>
> > @@ -21,6 +25,11 @@ static void rsvfile(xfs_mount_t *mp, xfs_inode_t *ip=
, long long len);
> >  static int newregfile(char **pp, char **fname);
> >  static void rtinit(xfs_mount_t *mp);
> >  static off_t filesize(int fd);
> > +static void populate_from_dir(struct xfs_mount *mp,
> > +                             struct fsxattr *fsxp, char *source_dir);
> > +static void walk_dir(struct xfs_mount *mp, struct xfs_inode *pip,
> > +                             struct fsxattr *fsxp, char *path_buf);
> > +static int preserve_atime;
> >  static int slashes_are_spaces;
> >
> >  /*
> > @@ -54,7 +63,7 @@ getnum(
> >       return i;
> >  }
> >
> > -char *
> > +struct proto_source
> >  setup_proto(
> >       char    *fname)
> >  {
> > @@ -63,8 +72,37 @@ setup_proto(
> >       int             fd;
> >       long            size;
> >
> > -     if (!fname)
> > -             return dflt;
> > +     struct proto_source     result =3D {0};
> > +     struct stat     statbuf;
> > +
> > +     /*
> > +      * If no prototype path is
> > +      * supplied, use the default protofile
> > +      * which creates only a root
> > +      * directory.
> > +      */
> > +     if (!fname) {
> > +             result.type =3D PROTO_SRC_PROTOFILE;
> > +             result.data =3D dflt;
> > +             return result;
> > +     }
> > +
> > +     if (stat(fname, &statbuf) < 0) {
> > +             fail(_("invalid or unreadable source path"), errno);
> > +     }
> > +
> > +     /*
> > +      * handle directory inputs
> > +      */
> > +     if (S_ISDIR(statbuf.st_mode)) {
> > +             result.type =3D PROTO_SRC_DIR;
> > +             result.data =3D fname;
> > +             return result;
> > +     }
> > +
> > +     /*
> > +      * else this is a protofile, let's handle traditionally
> > +      */
> >       if ((fd =3D open(fname, O_RDONLY)) < 0 || (size =3D filesize(fd))=
 < 0) {
> >               fprintf(stderr, _("%s: failed to open %s: %s\n"),
> >                       progname, fname, strerror(errno));
> > @@ -90,7 +128,10 @@ setup_proto(
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
> > @@ -379,6 +420,13 @@ writeattr(
> >       int                     error;
> >
> >       ret =3D fgetxattr(fd, attrname, valuebuf, valuelen);
> > +     /*
> > +      * in case of filedescriptors with O_PATH, fgetxattr() will
> > +      * fail with EBADF. let's try to fallback to lgetxattr() using in=
put
> > +      * path.
> > +      */
> > +     if (ret < 0 && errno =3D=3D EBADF)
> > +             ret =3D lgetxattr(fname, attrname, valuebuf, valuelen);
> >       if (ret < 0) {
> >               if (errno =3D=3D EOPNOTSUPP)
> >                       return;
> > @@ -425,6 +473,13 @@ writeattrs(
> >               fail(_("error allocating xattr name buffer"), errno);
> >
> >       ret =3D flistxattr(fd, namebuf, XATTR_LIST_MAX);
> > +     /*
> > +      * in case of filedescriptors with O_PATH, flistxattr() will
> > +      * fail with EBADF. let's try to fallback to llistxattr() using i=
nput
> > +      * path.
> > +      */
> > +     if (ret < 0 && errno =3D=3D EBADF)
> > +             ret =3D llistxattr(fname, namebuf, XATTR_LIST_MAX);
> >       if (ret < 0) {
> >               if (errno =3D=3D EOPNOTSUPP)
> >                       goto out_namebuf;
> > @@ -933,11 +988,27 @@ void
> >  parse_proto(
> >       xfs_mount_t     *mp,
> >       struct fsxattr  *fsx,
> > -     char            **pp,
> > -     int             proto_slashes_are_spaces)
> > +     struct proto_source     *protosource,
> > +     int             proto_slashes_are_spaces,
> > +     int             proto_preserve_atime)
> >  {
> >       slashes_are_spaces =3D proto_slashes_are_spaces;
> > -     parseproto(mp, NULL, fsx, pp, NULL);
> > +     preserve_atime =3D proto_preserve_atime;
> > +
> > +     /*
> > +      * in case of a file input, we will use the prototype file logic
> > +      * else we will fallback to populate from dir.
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
> > @@ -1171,3 +1242,683 @@ filesize(
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
> > +                             progname, errno, strerror(errno));
> > +}
> > +
> > +static void
> > +writefsxattrs(
> > +     struct xfs_inode        *ip,
> > +     struct fsxattr  *fsxp)
> > +{
> > +     ip->i_projid =3D fsxp->fsx_projid;
> > +     ip->i_extsize =3D fsxp->fsx_extsize;
> > +     ip->i_diflags =3D xfs_flags2diflags(ip, fsxp->fsx_xflags);
> > +     if (xfs_has_v3inodes(ip->i_mount)) {
> > +             ip->i_diflags2 =3D xfs_flags2diflags2(ip, fsxp->fsx_xflag=
s);
> > +             ip->i_cowextsize =3D fsxp->fsx_cowextsize;
> > +     }
> > +}
> > +
> > +static void
> > +writetimestamps(
> > +     struct xfs_inode        *ip,
> > +     struct stat     *statbuf)
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
> > +     ts.tv_sec =3D statbuf->st_mtim.tv_sec;
> > +     ts.tv_nsec =3D statbuf->st_mtim.tv_nsec;
> > +     inode_set_mtime_to_ts(VFS_I(ip), ts);
> > +
> > +     /*
> > +      * in case of atime option, we will copy the atime
> > +      * timestamp from source.
> > +      */
> > +     if (preserve_atime) {
> > +             ts.tv_sec =3D statbuf->st_atim.tv_sec;
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
> > +#define HARDLINK_DEFAULT_GROWTH_FACTOR       2       /* Double size fo=
r small arrays */
> > +#define HARDLINK_LARGE_GROWTH_FACTOR 0.25    /* Grow by 25% for large =
arrays */
> > +#define HARDLINK_THRESHOLD           1024    /* Threshold to switch gr=
owth strategies */
> > +#define HARDLINK_TRACKER_INITIAL_SIZE        4096    /* Initial alloca=
tion size */
> > +
> > +/*
> > + * keep track of source inodes that are from hardlinks
> > + * so we can retrieve them when needed to setup in
> > + * destination.
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
>
> Please zero out hardlink_tracker now that you've freed the array so that
> some future user won't accidentally add code that walks off the end of a
> dead pointer if they call get_hardlink_dst_inode after
> cleanup_hardlink_tracker.
>
> > +}
> > +
> > +static xfs_ino_t
> > +get_hardlink_dst_inode(
> > +     xfs_ino_t       i_ino)
> > +{
> > +     for (size_t i =3D 0; i < hardlink_tracker.count; i++) {
> > +             if (hardlink_tracker.entries[i].src_ino =3D=3D i_ino) {
> > +                     return hardlink_tracker.entries[i].dst_ino;
> > +             }
> > +     }
> > +     return 0;
> > +}
> > +
> > +static void
> > +track_hardlink_inode(
> > +     ino_t           src_ino,
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
> > +                     hardlink_tracker.entries,
> > +                     new_size,
> > +                     sizeof(struct hardlink));
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
> > +
> > +     hardlink_tracker.entries[hardlink_tracker.count].src_ino =3D src_=
ino;
> > +     hardlink_tracker.entries[hardlink_tracker.count].dst_ino =3D dst_=
ino;
> > +     hardlink_tracker.count++;
> > +}
> > +
> > +/*
> > + * this function will first check in our tracker if
> > + * the input hardlink has already been stored, if not
> > + * report false so create_file() can continue handling
> > + * the inode as a regular file type, and later save
> > + * the source inode in our buffer for future consumption.
> > + */
> > +static bool
> > +handle_hardlink(
> > +     struct xfs_mount        *mp,
> > +     struct xfs_inode        *pip,
> > +     struct xfs_name xname,
> > +     struct stat     file_stat)
> > +{
> > +     int             error;
> > +     xfs_ino_t               dst_ino;
> > +     struct xfs_inode        *ip;
> > +     struct xfs_trans        *tp;
> > +     struct xfs_parent_args *ppargs =3D NULL;
> > +
> > +     tp =3D getres(mp, 0);
> > +     ppargs =3D newpptr(mp);
> > +     dst_ino =3D get_hardlink_dst_inode(file_stat.st_ino);
> > +
> > +     /*
> > +      * we didn't find the hardlink inode, this means
> > +      * it's the first time we see it, report error
> > +      * so create_file() can continue handling the inode
> > +      * as a regular file type, and later save
> > +      * the source inode in our buffer for future consumption.
> > +      */
> > +     if (dst_ino =3D=3D 0)
> > +             return false;
> > +
> > +     error =3D libxfs_iget(mp, NULL, dst_ino, 0, &ip);
> > +     if (error)
> > +             fail(_("failed to get inode"), error);
> > +
> > +     /*
> > +      * In case the inode was already in our tracker
> > +      * we need to setup the hardlink and skip file
> > +      * copy.
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
> > +create_file(
> > +     struct xfs_mount        *mp,
> > +     struct xfs_inode        *pip,
> > +     struct fsxattr  *fsxp,
> > +     int             mode,
> > +     struct cred     creds,
> > +     struct xfs_name xname,
> > +     int             flags,
> > +     struct stat     file_stat,
> > +     xfs_dev_t               rdev,
> > +     int             fd,
> > +     char            *fname)
> > +{
> > +
> > +     int             error;
> > +     struct xfs_inode        *ip;
> > +     struct xfs_trans        *tp;
> > +     struct xfs_parent_args *ppargs =3D NULL;
> > +
> > +     /*
> > +      * if handle_hardlink() returns true it means the hardlink has
> > +      * been correctly found and set, so we don't need to
> > +      * do anything else.
> > +      */
> > +     if (file_stat.st_nlink > 1 && handle_hardlink(mp, pip, xname, fil=
e_stat)) {
> > +             close(fd);
> > +             return;
> > +     }
> > +     /*
> > +      * if instead we have an error it means the hardlink
> > +      * was not registered, so we proceed to treat it like
> > +      * a regular file, and save it to our tracker later.
> > +      */
> > +     tp =3D getres(mp, 0);
> > +     ppargs =3D newpptr(mp);
> > +
> > +     error =3D creatproto(&tp, pip, mode, rdev, &creds, fsxp, &ip);
> > +     if (error)
> > +             fail(_("Inode allocation failed"), error);
> > +
> > +     libxfs_trans_ijoin(tp, pip, 0);
> > +     newdirent(mp, tp, pip, &xname, ip, ppargs);
> > +
> > +     /*
> > +      * copy over timestamps
> > +      */
> > +     writetimestamps(ip, &file_stat);
> > +
> > +     libxfs_trans_log_inode(tp, ip, flags);
> > +
> > +     error =3D -libxfs_trans_commit(tp);
> > +     if (error)
> > +             fail(_("Error encountered creating file from prototype fi=
le"), error);
> > +
> > +     libxfs_parent_finish(mp, ppargs);
> > +
> > +     /*
> > +      * copy over file content, attributes,
> > +      * extended attributes and timestamps
> > +      */
> > +     if (fd >=3D 0) {
> > +             writefile(ip, fname, fd);
> > +             writeattrs(ip, fname, fd);
> > +             close(fd);
> > +     }
> > +     /*
> > +      * we do fsxattr also for file types where we don't have
> > +      * an fd, for example FIFOs
> > +      */
> > +     writefsxattrs(ip, fsxp);
> > +
> > +     /*
> > +      * if we're here it means this is the first time we're
> > +      * encountering an hardlink, so we need to store it
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
> > +     struct fsxattr  *fsxp,
> > +     char            *path_buf,
> > +     struct dirent   *entry)
> > +{
> > +     char            link_target[XFS_SYMLINK_MAXLEN];
> > +     int             error;
> > +     int             fd =3D -1;
> > +     int             flags;
> > +     int             majdev;
> > +     int             mindev;
> > +     int             mode;
>
> Nit: space ^ before tab; and all the variable names should be lined up
> to the same column...
>
> > +     struct stat     file_stat;
> > +     struct xfs_name xname;
> > +     struct xfs_inode        *ip;
> > +     struct xfs_trans        *tp;
> > +     struct xfs_parent_args *ppargs =3D NULL;
> > +
> > +     /*
> > +      * save original path length so we can
> > +      * restore the original value at the end
> > +      * of the function
> > +      */
> > +     size_t path_save_len =3D strlen(path_buf);
> > +     size_t path_len =3D path_save_len;
> > +     size_t entry_len =3D strlen(entry->d_name);
> > +
> > +     /*
> > +      * ensure the constructed path is within PATH_MAX limits
> > +      */
> > +     size_t remaining =3D PATH_MAX - path_len;
> > +     size_t written =3D snprintf(path_buf + path_len, remaining, "/%s"=
,
> > +                     entry->d_name);
>
> ...and you can do things like:
>
>         size_t                  written =3D
>                 snprintf(...);
>
> if the columns go far enough to the right that you can't fit them all on
> one line.
>
> > +     if (written >=3D remaining) {
> > +             fail(_("path name too long"), ENAMETOOLONG);
> > +     }
> > +
> > +     if (lstat(path_buf, &file_stat) < 0) {
> > +             fprintf(stderr, _("%s: cannot stat '%s': %s (errno=3D%d)\=
n"),
> > +                             progname, path_buf, strerror(errno), errn=
o);
> > +             exit(1);
> > +     }
> > +
> > +     /*
> > +      * avoid opening FIFOs as they're blocking
> > +      */
> > +     int open_flags =3D O_NOFOLLOW | O_RDONLY | O_NOATIME;
> > +     /*
> > +      * symlinks and sockets will need to be opened with O_PATH to wor=
k,
> > +      * so we handle this special case.
> > +      */
> > +     if (S_ISSOCK(file_stat.st_mode) ||
> > +                     S_ISLNK(file_stat.st_mode) ||
> > +                     S_ISFIFO(file_stat.st_mode))
>
> Line these up, please:
>
>         if (S_ISSOCK(...) ||
>             S_ISLNK(...) ||
>             S_ISFIFO(...))
>
> > +             open_flags =3D O_NOFOLLOW | O_PATH;
> > +     if ((fd =3D open(path_buf, open_flags)) < 0) {
>
>
>         fd =3D open(...);
>         if (fd < 0) {
>
> > +             fprintf(stderr, _("%s: cannot open %s: %s\n"), progname, =
path_buf,
> > +                     strerror(errno));
> > +             exit(1);
> > +     }
> > +
> > +     struct cred creds =3D {
> > +             .cr_uid =3D file_stat.st_uid,
> > +             .cr_gid =3D file_stat.st_gid,
> > +     };
> > +
> > +     xname.name =3D (unsigned char *)entry->d_name;
> > +     xname.len =3D entry_len;
> > +     xname.type =3D 0;
> > +     mode =3D file_stat.st_mode;
> > +     flags =3D XFS_ILOG_CORE;
> > +
> > +     switch (file_stat.st_mode & S_IFMT) {
> > +     case S_IFDIR:
> > +             tp =3D getres(mp, 0);
> > +             ppargs =3D newpptr(mp);
> > +
> > +             error =3D creatproto(&tp, pip, mode, 0, &creds, fsxp, &ip=
);
> > +             if (error)
> > +                     fail(_("Inode allocation failed"), error);
> > +
> > +             libxfs_trans_ijoin(tp, pip, 0);
> > +
> > +             xname.type =3D XFS_DIR3_FT_DIR;
> > +             newdirent(mp, tp, pip, &xname, ip, ppargs);
> > +
> > +             libxfs_bumplink(tp, pip);
> > +             libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
> > +             newdirectory(mp, tp, ip, pip);
> > +
> > +             /*
> > +              * copy over timestamps
> > +              */
> > +             writetimestamps(ip, &file_stat);
> > +
> > +             libxfs_trans_log_inode(tp, ip, flags);
> > +
> > +             error =3D -libxfs_trans_commit(tp);
> > +             if (error)
> > +                     fail(_("Directory inode allocation failed."), err=
or);
> > +
> > +             libxfs_parent_finish(mp, ppargs);
> > +             tp =3D NULL;
> > +
> > +             /*
> > +              * copy over attributes
> > +              */
> > +             writeattrs(ip, entry->d_name, fd);
> > +             writefsxattrs(ip, fsxp);
> > +             close(fd);
> > +
> > +             walk_dir(mp, ip, fsxp, path_buf);
> > +
> > +             libxfs_irele(ip);
>
> Yeah, each of these cases ought to be broken out into smaller function
> that each take care of a single child file type.  Not sure why some of
> these cases call create_file() and others don't?
>
> > +             break;
> > +     case S_IFLNK:
> > +             /*
> > +              * if handle_hardlink() returns true it means the hardlin=
k has
> > +              * been correctly found and set, so we don't need to
> > +              * do anything else.
> > +              */
> > +             if (file_stat.st_nlink > 1 &&
> > +                             handle_hardlink(mp, pip, xname, file_stat=
)) {
> > +                     close(fd);
> > +                     break;
> > +             }
> > +             /*
> > +              * if instead we have false it means the hardlink
> > +              * was not registered, so we proceed to treat it like
> > +              * a regular symlink, and save it to our tracker later.
> > +              */
> > +             ssize_t len =3D readlink(path_buf, link_target, XFS_SYMLI=
NK_MAXLEN - 1);
> > +             if (len < 0)
> > +                     fail(_("could not resolve symlink"), errno);
> > +             if (len >=3D PATH_MAX -1)
> > +                     fail(_("symlink target too long"), ENAMETOOLONG);
> > +             link_target[len] =3D '\0';
>
> Link targets don't require null terminators, they have explicit lengths.
>
> > +
> > +             tp =3D getres(mp, XFS_B_TO_FSB(mp, len));
> > +             ppargs =3D newpptr(mp);
> > +
> > +             error =3D creatproto(&tp, pip, mode, 0, &creds, fsxp, &ip=
);
> > +             if (error)
> > +                     fail(_("Inode allocation failed"), error);
> > +
> > +             writesymlink(tp, ip, link_target, len);
> > +             libxfs_trans_ijoin(tp, pip, 0);
> > +
> > +             xname.type =3D XFS_DIR3_FT_SYMLINK;
> > +             newdirent(mp, tp, pip, &xname, ip, ppargs);
> > +
> > +             /*
> > +              * copy over timestamps
> > +              */
> > +             writetimestamps(ip, &file_stat);
> > +
> > +             libxfs_trans_log_inode(tp, ip, flags);
> > +
> > +             error =3D -libxfs_trans_commit(tp);
> > +             if (error)
> > +                     fail(_("Error encountered creating file from prot=
otype file"),
> > +                          error);
> > +
> > +             libxfs_parent_finish(mp, ppargs);
> > +
> > +             /*
> > +              * copy over attributes
> > +              *
> > +              * being a symlink we opened the filedescriptor with O_PA=
TH
> > +              * this will make flistxattr() and fgetxattr() fail wil E=
BADF,
> > +              * so we  will need to fallback to llistxattr() and lgetx=
attr(),
> > +              * this will need the full path to the original file, not=
 just the
> > +              * entry name.
> > +              */
> > +             writeattrs(ip, path_buf, fd);
> > +             writefsxattrs(ip, fsxp);
> > +             close(fd);
> > +
> > +             /*
> > +              * if we're here it means this is the first time we're
> > +              * encountering an hardlink, so we need to store it
> > +              */
> > +             if (file_stat.st_nlink > 1)
> > +                     track_hardlink_inode(file_stat.st_ino, ip->i_ino)=
;
> > +
> > +             libxfs_irele(ip);
> > +             break;
> > +     case S_IFREG:
> > +             xname.type =3D XFS_DIR3_FT_REG_FILE;
> > +             create_file(mp, pip, fsxp, mode, creds, xname, flags, fil=
e_stat,
> > +                         0, fd, entry->d_name);
> > +             break;
> > +     case S_IFCHR:
> > +             flags |=3D XFS_ILOG_DEV;
> > +             xname.type =3D XFS_DIR3_FT_CHRDEV;
> > +             majdev =3D major(file_stat.st_rdev);
> > +             mindev =3D minor(file_stat.st_rdev);
> > +             create_file(mp, pip, fsxp, mode, creds, xname, flags, fil=
e_stat,
> > +                         IRIX_MKDEV(majdev, mindev), fd, entry->d_name=
);
> > +             break;
> > +     case S_IFBLK:
> > +             flags |=3D XFS_ILOG_DEV;
> > +             xname.type =3D XFS_DIR3_FT_BLKDEV;
> > +             majdev =3D major(file_stat.st_rdev);
> > +             mindev =3D minor(file_stat.st_rdev);
> > +             create_file(mp, pip, fsxp, mode, creds, xname, flags, fil=
e_stat,
> > +                         IRIX_MKDEV(majdev, mindev), fd, entry->d_name=
);
> > +             break;
> > +     case S_IFIFO:
> > +             /*
> > +              * being a fifo we opened the filedescriptor with O_PATH
> > +              * this will make flistxattr() and fgetxattr() fail wil E=
BADF,
> > +              * so we  will need to fallback to llistxattr() and lgetx=
attr(),
> > +              * this will need the full path to the original file, not=
 just the
> > +              * entry name.
> > +              */
> > +             create_file(mp, pip, fsxp, mode, creds, xname, flags, fil=
e_stat,
> > +                         0, fd, path_buf);
> > +             break;
> > +     case S_IFSOCK:
> > +             /*
> > +              * being a socket we opened the filedescriptor with O_PAT=
H
> > +              * this will make flistxattr() and fgetxattr() fail wil E=
BADF,
> > +              * so we  will need to fallback to llistxattr() and lgetx=
attr(),
> > +              * this will need the full path to the original file, not=
 just the
> > +              * entry name.
> > +              */
> > +             create_file(mp, pip, fsxp, mode, creds, xname, flags, fil=
e_stat,
> > +                         0, fd, path_buf);
>
> These two (FIFO/SOCK) need to set xname.type too.  Maybe that ought to
> be refactored out of parseproto since there's already a
> libxfs_mode_to_ftype function for that?
>
> > +             break;
> > +     default:
> > +             break;
> > +     }
> > +
> > +     /*
> > +      * restore path buffer to original length before returning
> > +      * */
> > +     path_buf[path_save_len] =3D '\0';
> > +}
> > +
> > +/*
> > + * walk_dir will recursively list files and directories
> > + * and populate the mountpoint *mp with them using handle_direntry().
> > + */
> > +static void
> > +walk_dir(
> > +     struct xfs_mount        *mp,
> > +     struct xfs_inode        *pip,
> > +     struct fsxattr  *fsxp,
> > +     char            *path_buf)
> > +{
> > +     DIR             *dir;
> > +     struct dirent   *entry;
>
> It's a little strange   ^ that some variable names are aligned to this
> column yet others are aligned   ^ to this column; they all should be the
> same.
>
> (I wish I could point you at an automatic reformatter but I don't know
> of any...)
>
> > +
> > +     /*
> > +      * open input directory and iterate over all entries in it.
> > +      * when another directory is found, we will recursively call
> > +      * walk_dir.
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
> > +             handle_direntry(mp, pip, fsxp, path_buf, entry);
> > +     }
> > +     closedir(dir);
> > +}
> > +
> > +static void
> > +populate_from_dir(
> > +     struct xfs_mount        *mp,
> > +     struct fsxattr  *fsxp,
> > +     char            *cur_path)
> > +{
> > +     int             error;
> > +     int             mode;
> > +     int             fd =3D -1;
>
> Nit: space ^ here before a tab.
>
> > +     char            path_buf[PATH_MAX];
> > +     struct stat     file_stat;
> > +     struct xfs_inode        *ip;
> > +     struct xfs_trans        *tp;
> > +
> > +     /*
> > +      * initialize path_buf cur_path, strip trailing slashes
> > +      * they're automatically added when walking the dir
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
> > +                             progname, path_buf, strerror(errno), errn=
o);
> > +             exit(1);
> > +     }
> > +     if ((fd =3D open(path_buf, O_NOFOLLOW | O_RDONLY | O_NOATIME)) < =
0) {
> > +             fprintf(stderr, _("%s: cannot open %s: %s\n"), progname, =
path_buf,
> > +                     strerror(errno));
> > +             exit(1);
> > +     }
> > +
> > +     /*
> > +      * we first ensure we have the root inode
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
> > +      * copy over attributes
> > +      */
> > +     writeattrs(ip, path_buf, fd);
> > +     writefsxattrs(ip, fsxp);
> > +
> > +     /*
> > +      * RT initialization.  Do this here to ensure that
> > +      * the RT inodes get placed after the root inode.
> > +      */
> > +     error =3D create_metadir(mp);
> > +     if (error)
> > +             fail(_("Creation of the metadata directory inode failed")=
, error);
> > +
> > +     rtinit(mp);
> > +
> > +     /*
> > +      * by nature of walk_dir() we could be opening
> > +      * a great number of fds for deeply nested directory
> > +      * trees.
> > +      * try to bump max fds limit.
> > +      */
> > +     bump_max_fds();
> > +
> > +     /*
> > +      * initialize the hardlinks tracker
> > +      */
> > +     init_hardlink_tracker();
> > +     /*
> > +      * now that we have a root inode, let's
> > +      * walk the input dir and populate the partition
> > +      */
> > +     walk_dir(mp, ip, fsxp, path_buf);
> > +
> > +     /*
> > +      * cleanup hardlinks tracker
> > +      */
> > +     cleanup_hardlink_tracker();
> > +
> > +     /*
> > +      * we free up our root inode
> > +      * only when we finished populating the
> > +      * root filesystem
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
> > index 3f4455d4..a32c077e 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -121,6 +121,7 @@ enum {
> >
> >  enum {
> >       P_FILE =3D 0,
> > +     P_ATIME,
> >       P_SLASHES,
> >       P_MAX_OPTS,
> >  };
> > @@ -709,6 +710,7 @@ static struct opt_params popts =3D {
> >       .ini_section =3D "proto",
> >       .subopts =3D {
> >               [P_FILE] =3D "file",
> > +             [P_ATIME] =3D "atime",
> >               [P_SLASHES] =3D "slashes_are_spaces",
> >               [P_MAX_OPTS] =3D NULL,
> >       },
> > @@ -717,6 +719,12 @@ static struct opt_params popts =3D {
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
> > @@ -1045,6 +1053,7 @@ struct cli_params {
> >       int     lsunit;
> >       int     is_supported;
> >       int     proto_slashes_are_spaces;
> > +     int     proto_atime;
> >       int     data_concurrency;
> >       int     log_concurrency;
> >       int     rtvol_concurrency;
> > @@ -1170,6 +1179,7 @@ usage( void )
> >  /* naming */         [-n size=3Dnum,version=3D2|ci,ftype=3D0|1,parent=
=3D0|1]]\n\
> >  /* no-op info only */        [-N]\n\
> >  /* prototype file */ [-p fname]\n\
> > +/* populate from directory */        [-p dirname,atime=3D0|1]\n\
> >  /* quiet */          [-q]\n\
> >  /* realtime subvol */        [-r extsize=3Dnum,size=3Dnum,rtdev=3Dxxx,=
rgcount=3Dn,rgsize=3Dn,\n\
> >                           concurrency=3Dnum]\n\
> > @@ -2067,6 +2077,9 @@ proto_opts_parser(
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
> > @@ -5162,7 +5175,7 @@ main(
> >       int                     discard =3D 1;
> >       int                     force_overwrite =3D 0;
> >       int                     quiet =3D 0;
> > -     char                    *protostring =3D NULL;
> > +     struct proto_source     protosource;
> >       int                     worst_freelist =3D 0;
> >
> >       struct libxfs_init      xi =3D {
> > @@ -5311,8 +5324,6 @@ main(
> >        */
> >       cfgfile_parse(&cli);
> >
> > -     protostring =3D setup_proto(cli.protofile);
> > -
> >       /*
> >        * Extract as much of the valid config as we can from the CLI inp=
ut
> >        * before opening the libxfs devices.
> > @@ -5480,7 +5491,11 @@ main(
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
>
> I almost wonder if we should just dump all the proto* options into
> struct proto_source and pass that into parse_proto (instead of five
> separate arguments) but that's a cleanup that can happen later...
>
> --D
>
> >
> >       /*
> >        * Protect ourselves against possible stupidity
> > --
> > 2.49.0
> >
