Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8BEC67CB4
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 09:58:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 135558F8033
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 07:58:44 -0700 (PDT)
Received: from mail-io0-f171.google.com (mail-io0-f171.google.com
	[209.85.223.171]) by cuda.sgi.com with ESMTP id
	pNG0yl1RN3uMnkU7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Apr 2016 07:58:40 -0700 (PDT)
Received: by mail-io0-f171.google.com with SMTP id g185so134733151ioa.2
	for <xfs@oss.sgi.com>; Fri, 08 Apr 2016 07:58:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5706FA7C.7020103@sandeen.net>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-16-git-send-email-jtulak@redhat.com>
	<5706FA7C.7020103@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 8 Apr 2016 16:58:19 +0200
Message-ID: <CACj3i73JEzCj-4kp3=H9mjXCKYgcOUYCOyq-aZSWZFXUih+0MA@mail.gmail.com>
Subject: Re: [PATCH 15/19] mkfs: don't treat files as though they are block
	devices
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8985250109711113274=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============8985250109711113274==
Content-Type: multipart/alternative; boundary=001a113ebe201e4c5c052ffa6eff

--001a113ebe201e4c5c052ffa6eff
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 8, 2016 at 2:25 AM, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 3/24/16 6:15 AM, jtulak@redhat.com wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > CHANGELOG
> > o Fix where xi.dname was incorrectly used instead of dfile
> > o Variable alignment (tabs)
> > o Added error handling for stat/statfs in init.c
> > o Remove a duplicate pread in zero_old_xfs_structures and for the
> > remaining call, save the return value in a more meaningful variable.
> > o A chunk moved to previous patch.
> >
> > If the device is actually a file, and "-d file" is not specified,
> > mkfs will try to treat it as a block device and get stuff wrong.
> > Image files don't necessarily have the same sector sizes as the
> > block device or filesystem underlying the image file, nor should we
> > be issuing discard ioctls on image files.
> >
> > To fix this sanely, only require "-d file" if the device name is
> > invalid to trigger creation of the file. Otherwise, use stat() to
> > determine if the device is a file or block device and deal with that
> > appropriately by setting the "isfile" variables and turning off
> > direct IO. Then ensure that we check the "isfile" options before
> > doing things that are specific to block devices.  Also, as direct IO
> > is disabled for files, use statfs() for getting host FS blocksize,
> > not platform_findsizes().
> >
> > These changes, however, can cause some tests to fail when the test
> > partition on which the file is created has blocksize bigger than 512.
> > Before, the underlying fs was ignored. Now, an attempt to create
> > a fs in a file with blocksize 512 on a 4096 underlying partition will
> > fail.
> >
> > Other file/blockdev issues fixed:
> >       - use getstr to detect specifying the data device name
> >         twice.
> >       - check file/size/name parameters before anything else.
> >       - overwrite checks need to be done before the image file is
> >         opened and potentially truncated.
> >       - blkid_get_topology() should not be called for image files,
> >         so warn when it is called that way.
> >       - zero_old_xfs_structures() emits a spurious error:
> >               "existing superblock read failed: Success"
> >         when it is run on a truncated image file. Don't warn if we
> >         see this problem on an image file.
> >       - Don't issue discards on image files.
> >       - Use fsync() for image files, not BLKFLSBUF in
> >         platform_flush_device() for Linux.
>
> This one causes at least one interesting issue:
>
> #mkfs/mkfs.xfs
> Error accessing specified device (null): Bad address
> Usage: mkfs.xfs
> ...
>
> because:
>
>         check_device_type(dfile, &xi.disfile, !dsize, !dfile,
>                           Nflag ? NULL : &xi.dcreat, force_overwrite, "d"=
);
>
> so "dfile" can be NULL, but that function immediately tries to stat it.
>

=E2=80=8BA simple if NULL, then usage() should take care of this...


> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Jan Tulak <jtulak@redhat.com>
> > ---
> >  libxfs/init.c   |  12 ++++
> >  libxfs/linux.c  |  12 +++-
> >  mkfs/xfs_mkfs.c | 181
> ++++++++++++++++++++++++++++++++++++++------------------
> >  3 files changed, 147 insertions(+), 58 deletions(-)
> >
> > diff --git a/libxfs/init.c b/libxfs/init.c
> > index 8d747e8..268136f 100644
> > --- a/libxfs/init.c
> > +++ b/libxfs/init.c
> > @@ -246,6 +246,9 @@ libxfs_init(libxfs_init_t *a)
> >       char            rtpath[25];
> >       int             rval =3D 0;
> >       int             flags;
> > +     struct          stat st;
> > +     struct          statfs stfs;
> > +     int             statres;
> >
> >       dpath[0] =3D logpath[0] =3D rtpath[0] =3D '\0';
> >       dname =3D a->dname;
> > @@ -278,6 +281,15 @@ libxfs_init(libxfs_init_t *a)
> >                       a->ddev=3D libxfs_device_open(dname, a->dcreat,
> flags,
> >                                                   a->setblksize);
> >                       a->dfd =3D libxfs_device_to_fd(a->ddev);
> > +                     statres =3D stat(dname, &st);
> > +                     statres +=3D statfs(dname, &stfs);
> > +                     if(statres){
>                           ^space   ^space
> > +                             fprintf(stderr, _("%s: stat failed.\n"),
> > +                                     progname);
> > +                             goto done;
> > +                     }
> > +                     a->dsize =3D st.st_size/BBSIZE;
> > +                     a->dbsize =3D stfs.f_bsize;
>
> ok so for a file you choose ->dsize to be file size in 512-sector units,
> and ->dbsize to be the fs block size.
>
> This is all under if (a->disfile); if we didn't actually specify "-dfile"
> but it *is* a file, then we get to platform_findsizes() - which handles
> files.  And handles them differently.


=E2=80=8BNo, a->disfile is set to 1 implicitly if the target is a file
in check_device_type():
1070        if (S_ISREG(statbuf.st_mode)) {
1071               if (!*isfile)
1072                      *isfile =3D 1;




> Hm but you removed that (see below)
> and added more stat() calls...?
>
> What is the reason for adding these stats at this point?
>
=E2=80=8BWhat is removed? Where exactly? Or it should be "above"?
> +                     statres =3D stat(dname, &st);
> +                     statres +=3D statfs(dname, &stfs);
This is to get dsize and dbsize values for the file.

(and if there's a reason, why only for ->disfile but not ->lisfile?)
>
=E2=80=8BBecause I forgot or didn't noticed. :-) Adding to lisfile and rtfi=
le too.
=E2=80=8B


>
> >               } else {
> >                       if (!check_open(dname, flags, &rawfile,
> &blockfile))
> >                               goto done;
> > diff --git a/libxfs/linux.c b/libxfs/linux.c
> > index f6ea1b2..adb8ff1 100644
> > --- a/libxfs/linux.c
> > +++ b/libxfs/linux.c
> > @@ -18,6 +18,7 @@
> >
> >  #define ustat __kernel_ustat
> >  #include <mntent.h>
> > +#include <sys/vfs.h>
> >  #include <sys/stat.h>
> >  #undef ustat
> >  #include <sys/ustat.h>
> > @@ -125,7 +126,16 @@ platform_set_blocksize(int fd, char *path, dev_t
> device, int blocksize, int fata
> >  void
> >  platform_flush_device(int fd, dev_t device)
> >  {
> > -     if (major(device) !=3D RAMDISK_MAJOR)
> > +     struct stat64   st;
> > +     if (major(device) =3D=3D RAMDISK_MAJOR)
> > +             return;
> > +
> > +     if (fstat64(fd, &st) < 0)
> > +             return;
> > +
> > +     if (S_ISREG(st.st_mode))
> > +             fsync(fd);
> > +     else
> >               ioctl(fd, BLKFLSBUF, 0);
> >  }
> >
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 9261ed5..7bd9fd5 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -787,7 +787,7 @@ calc_stripe_factors(
> >  #ifdef ENABLE_BLKID
> >  static int
> >  check_overwrite(
> > -     char            *device)
> > +     const char      *device)
> >  {
> >       const char      *type;
> >       blkid_probe     pr =3D NULL;
> > @@ -804,7 +804,7 @@ check_overwrite(
> >       fd =3D open(device, O_RDONLY);
> >       if (fd < 0)
> >               goto out;
> > -     platform_findsizes(device, fd, &size, &bsz);
> > +     platform_findsizes((char *)device, fd, &size, &bsz);
> >       close(fd);
> >
> >       /* nothing to overwrite on a 0-length device */
> > @@ -851,7 +851,6 @@ check_overwrite(
> >                       "according to blkid\n"), progname, device);
> >       }
> >       ret =3D 1;
> > -
> >  out:
> >       if (pr)
> >               blkid_free_probe(pr);
> > @@ -877,8 +876,12 @@ static void blkid_get_topology(
> >       struct stat statbuf;
> >
> >       /* can't get topology info from a file */
> > -     if (!stat(device, &statbuf) && S_ISREG(statbuf.st_mode))
> > +     if (!stat(device, &statbuf) && S_ISREG(statbuf.st_mode)) {
> > +             fprintf(stderr,
> > +     _("%s: Warning: trying to probe topology of a file %s!\n"),
> > +                     progname, device);
> >               return;
> > +     }
> >
> >       pr =3D blkid_new_probe_from_filename(device);
> >       if (!pr)
> > @@ -976,35 +979,35 @@ static void get_topology(
> >       struct fs_topology      *ft,
> >       int                     force_overwrite)
> >  {
> > -     struct stat statbuf;
> >       char *dfile =3D xi->volname ? xi->volname : xi->dname;
> > +     struct stat statbuf;
> > +     struct statfs statfsbuf;
> >
> >       /*
> > -      * If our target is a regular file, use platform_findsizes
> > -      * to try to obtain the underlying filesystem's requirements
> > -      * for direct IO; we'll set our sector size to that if possible.
> > +      * If our target is a regular file, use statfs
> > +      * to try to obtain the underlying filesystem's blocksize.
> >        */
> >       if (xi->disfile ||
> > -         (!stat(dfile, &statbuf) && S_ISREG(statbuf.st_mode))) {
> > +             (!stat(dfile, &statbuf) && S_ISREG(statbuf.st_mode))) {
>
> dave pointed out that this indentation "fix" is incorrect, the line is
> fine as
> it is; it's part of the same conditional; it shouldn't be tabbed into the
> code
> block under the conditional.
>

=E2=80=8BI'm removing this change.



> >               int fd;
> >               int flags =3D O_RDONLY;
> > -             long long dummy;
> >
> >               /* with xi->disfile we may not have the file yet! */
> >               if (xi->disfile)
> >                       flags |=3D O_CREAT;
> >
> >               fd =3D open(dfile, flags, 0666);
> > +
> >               if (fd >=3D 0) {
> > -                     platform_findsizes(dfile, fd, &dummy,
> &ft->lsectorsize);
> > +                     fstatfs(fd, &statfsbuf);
>
> no error checking on fstatfs, but...
>
=E2=80=8BAdded.=E2=80=8B


>
> > +                     ft->lsectorsize =3D statfsbuf.f_bsize;
>
> Ok, platform_findsizes already explicitly handled regular files, and trie=
s
> to
> find out via an xfs ioctl what the minimum DIO size is, and uses that for
> the sector size for the filesystem in the iamge.


> Now you stat & get the blocksize, and use that instead, but it's likely
> to be different:
>
> i.e. before:
>
> # mkfs/mkfs.xfs -f fsfile
> meta-data=3Dfsfile                 isize=3D512    agcount=3D4, agsize=3D6=
5536 blks
>          =3D                       sectsz=3D512   attr=3D2, projid32bit=
=3D1
>
> after:
>
> # mkfs/mkfs.xfs -f fsfile
> meta-data=3Dfsfile                 isize=3D512    agcount=3D4, agsize=3D6=
5536 blks
>          =3D                       sectsz=3D4096  attr=3D2, projid32bit=
=3D1
>
> and also, now:
>
> # mkfs/mkfs.xfs -f -dfile,name=3Dfsfile,size=3D1g -b size=3D2048
> block size 2048 cannot be smaller than logical sector size 4096
>
> What prompted you to make this change, was there some other problem you
> needed to fix?
>

=E2=80=8BBut DIO is disabled for the files, per the commit message:
[...] and turning off
direct IO. Then ensure that we check the "isfile" options before
doing things that are specific to block devices.  Also, as direct IO
is disabled for files, use statfs() for getting host FS blocksize,
not platform_findsizes().=E2=80=8B

So we have to use whatever the underlying fs tells us, not what the
physical device has, right?

=E2=80=8BRather, I wonder if there is any reason to keep the platform_finds=
izes
part about regular files - it shouldn't get into the branch ever.



>
> >                       close(fd);
> > -                     ft->psectorsize =3D ft->lsectorsize;
>
> hm, now psectorsize isn't set at all?
>

=E2=80=8BThis looks like a bug, I think the assignment should stay here.
=E2=80=8B


>
> >               } else
> >                       ft->psectorsize =3D ft->lsectorsize =3D BBSIZE;
> >       } else {
> >               blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth,
> > -                                &ft->lsectorsize, &ft->psectorsize,
> > -                                force_overwrite);
> > +                                     &ft->lsectorsize, &ft->psectorsiz=
e,
> > +                                     force_overwrite);
>
> please don't change these lines, they line up w/ the function opening
> paren as
> they should.
>
> =E2=80=8BSure. =E2=80=8B



> >       }
> >
> >       if (xi->rtname && !xi->risfile) {
> > @@ -1016,6 +1019,75 @@ static void get_topology(
> >  }
> >
> >  static void
> > +check_device_type(
> > +     const char      *name,
> > +     int             *isfile,
> > +     bool            no_size,
> > +     bool            no_name,
> > +     int             *create,
> > +     bool            force_overwrite,
> > +     const char      *optname)
> > +{
> > +     struct stat64 statbuf;
> > +
> > +     if (*isfile && (no_size || no_name)) {
> > +             fprintf(stderr,
> > +     _("if -%s file then -%s name and -%s size are required\n"),
> > +                     optname, optname, optname);
> > +             usage();
> > +     }
> > +
> > +     if (stat64(name, &statbuf)) {
> > +             if (errno =3D=3D ENOENT && *isfile) {
> > +                     if (create)
> > +                             *create =3D 1;
> > +                     return;
> > +             }
> > +
> > +             fprintf(stderr,
> > +     _("Error accessing specified device %s: %s\n"),
> > +                             name, strerror(errno));
> > +             usage();
> > +             return;
> > +     }
> > +
> > +     if (!force_overwrite && check_overwrite(name)) {
> > +             fprintf(stderr,
> > +     _("%s: Use the -f option to force overwrite.\n"),
> > +                     progname);
> > +             exit(1);
> > +     }
> > +
> > +     /*
> > +      * We only want to completely truncate and recreate an existing
> file if
> > +      * we were specifically told it was a file. Set the create flag
> only in
> > +      * this case to trigger that behaviour.
> > +      */
> > +     if (S_ISREG(statbuf.st_mode)) {
> > +             if (!*isfile)
> > +                     *isfile =3D 1;
> > +             else if (create)
> > +                     *create =3D 1;
> > +             return;
> > +     }
> > +
> > +     if (S_ISBLK(statbuf.st_mode)) {
> > +             if (*isfile) {
> > +                     fprintf(stderr,
> > +     _("specified \"-%s file\" on a block device %s\n"),
> > +                             optname, name);
> > +                     usage();
> > +             }
> > +             return;
> > +     }
> > +
> > +     fprintf(stderr,
> > +     _("specified device %s not a file or block device\n"),
> > +             name);
> > +     usage();
> > +}
> > +
> > +static void
> >  fixup_log_stripe_unit(
> >       int             lsflag,
> >       int             sunit,
> > @@ -1279,7 +1351,6 @@ zero_old_xfs_structures(
> >       __uint32_t              bsize;
> >       int                     i;
> >       xfs_off_t               off;
> > -     int                     tmp;
> >
> >       /*
> >        * We open regular files with O_TRUNC|O_CREAT. Nothing to do
> here...
> > @@ -1299,15 +1370,23 @@ zero_old_xfs_structures(
> >       }
> >       memset(buf, 0, new_sb->sb_sectsize);
> >
> > -     tmp =3D pread(xi->dfd, buf, new_sb->sb_sectsize, 0);
> > -     if (tmp < 0) {
> > +     off =3D pread(xi->dfd, buf, new_sb->sb_sectsize, 0);
> > +     if (off < 0) {
> >               fprintf(stderr, _("existing superblock read failed: %s\n"=
),
> >                       strerror(errno));
> >               goto done;
> >       }
> > -     if (tmp !=3D new_sb->sb_sectsize) {
> > -             fprintf(stderr,
> > -     _("warning: could not read existing superblock, skip zeroing\n"))=
;
> > +     /*
> > +      * If we are creating an image file, it might be of zero length a=
t
> this
> > +      * point in time. Hence reading the existing superblock is going =
to
> > +      * return zero bytes. It's not a failure we need to warn about in
> this
> > +      * case.
> > +      */
>
> except you already did "if (off < 0) fail" above this.
>
> Ok, at this point I think it might be best to revert to Dave's original
> version.
>
> If there were specific problems you were trying to address, can you point
> them out?
>
> Thanks,
> -Eric
>
> =E2=80=8B(inserting your next email)=E2=80=8B


>
> On 4/7/16 7:25 PM, Eric Sandeen wrote:
> >> @@ -1299,15 +1370,23 @@ zero_old_xfs_structures(
> >> >    }
> >> >    memset(buf, 0, new_sb->sb_sectsize);
> >> >
> >> > -  tmp =3D pread(xi->dfd, buf, new_sb->sb_sectsize, 0);
> >> > -  if (tmp < 0) {
> >> > +  off =3D pread(xi->dfd, buf, new_sb->sb_sectsize, 0);
> >> > +  if (off < 0) {
> >> >            fprintf(stderr, _("existing superblock read failed: %s\n"=
),
> >> >                    strerror(errno));
> >> >            goto done;
> >> >    }
> >> > -  if (tmp !=3D new_sb->sb_sectsize) {
> >> > -          fprintf(stderr,
> >> > -  _("warning: could not read existing superblock, skip zeroing\n"))=
;
> >> > +  /*
> >> > +   * If we are creating an image file, it might be of zero length a=
t
> this
> >> > +   * point in time. Hence reading the existing superblock is going =
to
> >> > +   * return zero bytes. It's not a failure we need to warn about in
> this
> >> > +   * case.
> >> > +   */
> > except you already did "if (off < 0) fail" above this.
>
> (oh, right, < 0 is different than =3D=3D 0, sorry; so that part is ok)
>
> Possibly better as:
>
> if (off < 0 || (tmp !=3D new_sb->sb_sectsize && !xi->disfile))
>         fprintf("error reading existing superblock ...")
>
=E2=80=8BOK, better to be sure. :-)
=E2=80=8B


>
>
> I still think this patch might need a reset though :)
>
> Thanks,
> -Eric
>
> > Ok, at this point I think it might be best to revert to Dave's original
> version.
> >
> > If there were specific problems you were trying to address, can you
> point them out?
>

=E2=80=8BOn few places, the original patch looked as if files had direct IO=
 still
enabled=E2=80=8B (using platform_findsize...), and I think it was causing s=
ome
failures - fixing issues is why I did most of the changes.

I will revert to the original version and see what exactly fails. But with
being Friday late afternoon, the results will be available the next week
(Wednesday and further, all my courses at university are stuffed in
Mon/Tue).

Cheers,
Jan


--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a113ebe201e4c5c052ffa6eff
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Fri, Ap=
r 8, 2016 at 2:25 AM, Eric Sandeen </span><span dir=3D"ltr" style=3D"font-f=
amily:arial,sans-serif">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=
=3D"_blank">sandeen@sandeen.net</a>&gt;</span><span style=3D"font-family:ar=
ial,sans-serif"> wrote:</span></div><div class=3D"gmail_extra"><div class=
=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px =
0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-l=
eft-style:solid;padding-left:1ex"><div class=3D""><div class=3D"h5">
On 3/24/16 6:15 AM, <a href=3D"mailto:jtulak@redhat.com">jtulak@redhat.com<=
/a> wrote:<br>
&gt; From: Dave Chinner &lt;<a href=3D"mailto:dchinner@redhat.com">dchinner=
@redhat.com</a>&gt;<br>
&gt;<br>
&gt; CHANGELOG<br>
&gt; o Fix where xi.dname was incorrectly used instead of dfile<br>
&gt; o Variable alignment (tabs)<br>
&gt; o Added error handling for stat/statfs in init.c<br>
&gt; o Remove a duplicate pread in zero_old_xfs_structures and for the<br>
&gt; remaining call, save the return value in a more meaningful variable.<b=
r>
&gt; o A chunk moved to previous patch.<br>
&gt;<br>
&gt; If the device is actually a file, and &quot;-d file&quot; is not speci=
fied,<br>
&gt; mkfs will try to treat it as a block device and get stuff wrong.<br>
&gt; Image files don&#39;t necessarily have the same sector sizes as the<br=
>
&gt; block device or filesystem underlying the image file, nor should we<br=
>
&gt; be issuing discard ioctls on image files.<br>
&gt;<br>
&gt; To fix this sanely, only require &quot;-d file&quot; if the device nam=
e is<br>
&gt; invalid to trigger creation of the file. Otherwise, use stat() to<br>
&gt; determine if the device is a file or block device and deal with that<b=
r>
&gt; appropriately by setting the &quot;isfile&quot; variables and turning =
off<br>
&gt; direct IO. Then ensure that we check the &quot;isfile&quot; options be=
fore<br>
&gt; doing things that are specific to block devices.=C2=A0 Also, as direct=
 IO<br>
&gt; is disabled for files, use statfs() for getting host FS blocksize,<br>
&gt; not platform_findsizes().<br>
&gt;<br>
&gt; These changes, however, can cause some tests to fail when the test<br>
&gt; partition on which the file is created has blocksize bigger than 512.<=
br>
&gt; Before, the underlying fs was ignored. Now, an attempt to create<br>
&gt; a fs in a file with blocksize 512 on a 4096 underlying partition will<=
br>
&gt; fail.<br>
&gt;<br>
&gt; Other file/blockdev issues fixed:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0- use getstr to detect specifying the data d=
evice name<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0twice.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0- check file/size/name parameters before any=
thing else.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0- overwrite checks need to be done before th=
e image file is<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0opened and potentially truncated.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0- blkid_get_topology() should not be called =
for image files,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0so warn when it is called that way.<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0- zero_old_xfs_structures() emits a spurious=
 error:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;existing s=
uperblock read failed: Success&quot;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0when it is run on a truncated image f=
ile. Don&#39;t warn if we<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0see this problem on an image file.<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0- Don&#39;t issue discards on image files.<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0- Use fsync() for image files, not BLKFLSBUF=
 in<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0platform_flush_device() for Linux.<br=
>
<br>
</div></div>This one causes at least one interesting issue:<br>
<br>
#mkfs/mkfs.xfs<br>
Error accessing specified device (null): Bad address<br>
Usage: mkfs.xfs<br>
...<br>
<br>
because:<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 check_device_type(dfile, &amp;xi.disfile, !dsiz=
e, !dfile,<br>
<span class=3D"">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Nflag ? NULL : &amp;xi.dcreat, force_ove=
rwrite, &quot;d&quot;);<br>
<br>
</span>so &quot;dfile&quot; can be NULL, but that function immediately trie=
s to stat it.<br></blockquote><div><br></div><div><div class=3D"gmail_defau=
lt" style=3D"font-family:arial,helvetica,sans-serif;display:inline">=E2=80=
=8BA simple if NULL, then usage() should take care of this...</div></div><d=
iv><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-s=
erif;display:inline"><br></div></div><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(2=
04,204,204);border-left-style:solid;padding-left:1ex">
<div><div class=3D"h5"><br>
&gt; Signed-off-by: Dave Chinner &lt;<a href=3D"mailto:dchinner@redhat.com"=
>dchinner@redhat.com</a>&gt;<br>
&gt; Signed-off-by: Jan Tulak &lt;<a href=3D"mailto:jtulak@redhat.com">jtul=
ak@redhat.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 libxfs/init.c=C2=A0 =C2=A0|=C2=A0 12 ++++<br>
&gt;=C2=A0 libxfs/linux.c=C2=A0 |=C2=A0 12 +++-<br>
&gt;=C2=A0 mkfs/xfs_mkfs.c | 181 ++++++++++++++++++++++++++++++++++++++----=
--------------<br>
&gt;=C2=A0 3 files changed, 147 insertions(+), 58 deletions(-)<br>
&gt;<br>
&gt; diff --git a/libxfs/init.c b/libxfs/init.c<br>
&gt; index 8d747e8..268136f 100644<br>
&gt; --- a/libxfs/init.c<br>
&gt; +++ b/libxfs/init.c<br>
&gt; @@ -246,6 +246,9 @@ libxfs_init(libxfs_init_t *a)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0char=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 rtpath[25];<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0rval =3D 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0flags;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 stat st;=
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 statfs s=
tfs;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0statres;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0dpath[0] =3D logpath[0] =3D rtpath[0] =3D &#=
39;\0&#39;;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0dname =3D a-&gt;dname;<br>
&gt; @@ -278,6 +281,15 @@ libxfs_init(libxfs_init_t *a)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0a-&gt;ddev=3D libxfs_device_open(dname, a-&gt;dcreat, flags,<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0a-&gt;setblksize);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0a-&gt;dfd =3D libxfs_device_to_fd(a-&gt;ddev);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0statres =3D stat(dname, &amp;st);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0statres +=3D statfs(dname, &amp;stfs);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0if(statres){<br>
</div></div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ^space=C2=A0 =C2=A0^space<br>
<span class=3D"">&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stderr, _(&quot=
;%s: stat failed.\n&quot;),<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0progname);<b=
r>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto done;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0a-&gt;dsize =3D st.st_size/BBSIZE;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0a-&gt;dbsize =3D stfs.f_bsize;<br>
<br>
</span>ok so for a file you choose -&gt;dsize to be file size in 512-sector=
 units,<br>
and -&gt;dbsize to be the fs block size.<br>
<br>
This is all under if (a-&gt;disfile); if we didn&#39;t actually specify &qu=
ot;-dfile&quot;<br>
but it *is* a file, then we get to platform_findsizes() - which handles<br>
files.=C2=A0 And handles them differently.=C2=A0 =C2=A0</blockquote><div><b=
r></div><div><div class=3D"gmail_default" style=3D"font-family:arial,helvet=
ica,sans-serif">=E2=80=8BNo, a-&gt;disfile is set to 1 implicitly if the ta=
rget is a file in=C2=A0check_device_type():</div><div class=3D"gmail_defaul=
t" style=3D"font-family:arial,helvetica,sans-serif"><div class=3D"gmail_def=
ault">1070 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (S_ISREG(statbuf.st_mode)) {</div>=
<div class=3D"gmail_default">1071 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (!*isfile)</div><div class=3D"gmail_default">1072 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*isfile =3D 1=
;</div><div class=3D"gmail_default"><br></div></div><br></div><div>=C2=A0</=
div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bor=
der-left-width:1px;border-left-color:rgb(204,204,204);border-left-style:sol=
id;padding-left:1ex">Hm but you removed that (see below)<br>
and added more stat() calls...?<br>
<br>
What is the reason for adding these stats at this point?<br></blockquote><d=
iv><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-s=
erif;display:inline">=E2=80=8BWhat is removed? Where exactly? Or it should =
be &quot;above&quot;?</div></div><div><div class=3D"gmail_default" style=3D=
"font-family:arial,helvetica,sans-serif;display:inline"><span style=3D"colo=
r:rgb(80,0,80);font-family:arial,sans-serif">&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0statres =3D stat(dname,=
 &amp;st);</span><br style=3D"color:rgb(80,0,80);font-family:arial,sans-ser=
if"><span style=3D"color:rgb(80,0,80);font-family:arial,sans-serif">&gt; +=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0statres +=3D statfs(dname, &amp;stfs);</span><br></div></div>This is to =
get dsize and dbsize values for the file.</div><div class=3D"gmail_quote"><=
br></div><div class=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(20=
4,204,204);border-left-style:solid;padding-left:1ex">
(and if there&#39;s a reason, why only for -&gt;disfile but not -&gt;lisfil=
e?)<br></blockquote><div><div class=3D"gmail_default" style=3D"font-family:=
arial,helvetica,sans-serif;display:inline">=E2=80=8BBecause I forgot or did=
n&#39;t noticed. :-) Adding to lisfile and rtfile too.</div></div><div><div=
 class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;di=
splay:inline">=E2=80=8B</div>=C2=A0</div><blockquote class=3D"gmail_quote" =
style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:r=
gb(204,204,204);border-left-style:solid;padding-left:1ex">
<div><div class=3D"h5"><br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0if (!check_open(dname, flags, &amp;rawfile, &amp;blockfile))<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto done;<br>
&gt; diff --git a/libxfs/linux.c b/libxfs/linux.c<br>
&gt; index f6ea1b2..adb8ff1 100644<br>
&gt; --- a/libxfs/linux.c<br>
&gt; +++ b/libxfs/linux.c<br>
&gt; @@ -18,6 +18,7 @@<br>
&gt;<br>
&gt;=C2=A0 #define ustat __kernel_ustat<br>
&gt;=C2=A0 #include &lt;mntent.h&gt;<br>
&gt; +#include &lt;sys/vfs.h&gt;<br>
&gt;=C2=A0 #include &lt;sys/stat.h&gt;<br>
&gt;=C2=A0 #undef ustat<br>
&gt;=C2=A0 #include &lt;sys/ustat.h&gt;<br>
&gt; @@ -125,7 +126,16 @@ platform_set_blocksize(int fd, char *path, dev_t =
device, int blocksize, int fata<br>
&gt;=C2=A0 void<br>
&gt;=C2=A0 platform_flush_device(int fd, dev_t device)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (major(device) !=3D RAMDISK_MAJOR)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct stat64=C2=A0 =C2=A0st;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (major(device) =3D=3D RAMDISK_MAJOR)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (fstat64(fd, &amp;st) &lt; 0)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (S_ISREG(st.st_mode))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fsync(fd);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0else<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioctl(fd, BLKFLS=
BUF, 0);<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt; diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c<br>
&gt; index 9261ed5..7bd9fd5 100644<br>
&gt; --- a/mkfs/xfs_mkfs.c<br>
&gt; +++ b/mkfs/xfs_mkfs.c<br>
&gt; @@ -787,7 +787,7 @@ calc_stripe_factors(<br>
&gt;=C2=A0 #ifdef ENABLE_BLKID<br>
&gt;=C2=A0 static int<br>
&gt;=C2=A0 check_overwrite(<br>
&gt; -=C2=A0 =C2=A0 =C2=A0char=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *de=
vice)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0const char=C2=A0 =C2=A0 =C2=A0 *device)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0const char=C2=A0 =C2=A0 =C2=A0 *type;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0blkid_probe=C2=A0 =C2=A0 =C2=A0pr =3D NULL;<=
br>
&gt; @@ -804,7 +804,7 @@ check_overwrite(<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0fd =3D open(device, O_RDONLY);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (fd &lt; 0)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0platform_findsizes(device, fd, &amp;size, &amp;bs=
z);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0platform_findsizes((char *)device, fd, &amp;size,=
 &amp;bsz);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0close(fd);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* nothing to overwrite on a 0-length device=
 */<br>
&gt; @@ -851,7 +851,6 @@ check_overwrite(<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0&quot;according to blkid\n&quot;), progname, device);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D 1;<br>
&gt; -<br>
&gt;=C2=A0 out:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (pr)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0blkid_free_probe=
(pr);<br>
&gt; @@ -877,8 +876,12 @@ static void blkid_get_topology(<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct stat statbuf;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* can&#39;t get topology info from a file *=
/<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (!stat(device, &amp;statbuf) &amp;&amp; S_ISRE=
G(statbuf.st_mode))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!stat(device, &amp;statbuf) &amp;&amp; S_ISRE=
G(statbuf.st_mode)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stderr,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0_(&quot;%s: Warning: trying to probe topology of =
a file %s!\n&quot;),<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0progname, device);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0pr =3D blkid_new_probe_from_filename(device)=
;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!pr)<br>
&gt; @@ -976,35 +979,35 @@ static void get_topology(<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct fs_topology=C2=A0 =C2=A0 =C2=A0 *ft,<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0force_overwrite)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0struct stat statbuf;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0char *dfile =3D xi-&gt;volname ? xi-&gt;voln=
ame : xi-&gt;dname;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct stat statbuf;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct statfs statfsbuf;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 * If our target is a regular file, use platform_=
findsizes<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 * to try to obtain the underlying filesystem&#39=
;s requirements<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 * for direct IO; we&#39;ll set our sector size t=
o that if possible.<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * If our target is a regular file, use statfs<br=
>
&gt; +=C2=A0 =C2=A0 =C2=A0 * to try to obtain the underlying filesystem&#39=
;s blocksize.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (xi-&gt;disfile ||<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(!stat(dfile, &amp;statbuf) &amp;&a=
mp; S_ISREG(statbuf.st_mode))) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(!stat(dfile, &amp;st=
atbuf) &amp;&amp; S_ISREG(statbuf.st_mode))) {<br>
<br>
</div></div>dave pointed out that this indentation &quot;fix&quot; is incor=
rect, the line is fine as<br>
it is; it&#39;s part of the same conditional; it shouldn&#39;t be tabbed in=
to the code<br>
block under the conditional.<br></blockquote><div><br></div><div><div class=
=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;display:=
inline">=E2=80=8BI&#39;m removing this change.</div></div><div><br></div><d=
iv><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px =
0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-left-=
style:solid;padding-left:1ex">
<span class=3D""><br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int fd;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int flags =3D O_=
RDONLY;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0long long dummy;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* with xi-&gt;d=
isfile we may not have the file yet! */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (xi-&gt;disfi=
le)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0flags |=3D O_CREAT;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fd =3D open(dfil=
e, flags, 0666);<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (fd &gt;=3D 0=
) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0platform_findsizes(dfile, fd, &amp;dummy, &amp;ft-&gt;lsectorsize);<=
br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0fstatfs(fd, &amp;statfsbuf);<br>
<br>
</span>no error checking on fstatfs, but...<br></blockquote><div><div class=
=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;display:=
inline">=E2=80=8BAdded.=E2=80=8B</div>=C2=A0</div><blockquote class=3D"gmai=
l_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-lef=
t-color:rgb(204,204,204);border-left-style:solid;padding-left:1ex">
<span class=3D""><br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0ft-&gt;lsectorsize =3D statfsbuf.f_bsize;<br>
<br>
</span>Ok, platform_findsizes already explicitly handled regular files, and=
 tries to<br>
find out via an xfs ioctl what the minimum DIO size is, and uses that for<b=
r>
the sector size for the filesystem in the iamge.=C2=A0</blockquote><blockqu=
ote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-wid=
th:1px;border-left-color:rgb(204,204,204);border-left-style:solid;padding-l=
eft:1ex">
<br>
Now you stat &amp; get the blocksize, and use that instead, but it&#39;s li=
kely<br>
to be different:<br>
<br>
i.e. before:<br>
<br>
# mkfs/mkfs.xfs -f fsfile<br>
meta-data=3Dfsfile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0isize=3D512=C2=A0 =C2=A0 agcount=3D4, agsize=3D65536 blks<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sectsz=3D512=C2=A0 =C2=A0attr=
=3D2, projid32bit=3D1<br>
<br>
after:<br>
<br>
# mkfs/mkfs.xfs -f fsfile<br>
meta-data=3Dfsfile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0isize=3D512=C2=A0 =C2=A0 agcount=3D4, agsize=3D65536 blks<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sectsz=3D4096=C2=A0 attr=3D2, =
projid32bit=3D1<br>
<br>
and also, now:<br>
<br>
# mkfs/mkfs.xfs -f -dfile,name=3Dfsfile,size=3D1g -b size=3D2048<br>
block size 2048 cannot be smaller than logical sector size 4096<br>
<br>
What prompted you to make this change, was there some other problem you<br>
needed to fix?<br></blockquote><div><br></div><div><div class=3D"gmail_defa=
ult" style=3D"font-family:arial,helvetica,sans-serif">=E2=80=8BBut DIO is d=
isabled for the files, per the commit message:</div><div class=3D"gmail_def=
ault" style=3D"font-family:arial,helvetica,sans-serif">[...] and turning of=
f</div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sa=
ns-serif">direct IO. Then ensure that we check the &quot;isfile&quot; optio=
ns before</div><div class=3D"gmail_default" style=3D"font-family:arial,helv=
etica,sans-serif">doing things that are specific to block devices.=C2=A0 Al=
so, as direct IO</div><div class=3D"gmail_default" style=3D"font-family:ari=
al,helvetica,sans-serif">is disabled for files, use statfs() for getting ho=
st FS blocksize,</div><div class=3D"gmail_default" style=3D"font-family:ari=
al,helvetica,sans-serif">not platform_findsizes().=E2=80=8B</div><div class=
=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif"><br></d=
iv><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-s=
erif">So we have to use whatever the underlying fs tells us, not what the p=
hysical device has, right?</div><br></div><div><div class=3D"gmail_default"=
 style=3D"font-family:arial,helvetica,sans-serif">=E2=80=8BRather, I wonder=
 if there is any reason to keep the platform_findsizes part about regular f=
iles - it shouldn&#39;t get into the branch ever.</div><br></div><div>=C2=
=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8e=
x;border-left-width:1px;border-left-color:rgb(204,204,204);border-left-styl=
e:solid;padding-left:1ex">
<span class=3D""><br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0close(fd);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0ft-&gt;psectorsize =3D ft-&gt;lsectorsize;<br>
<br>
</span>hm, now psectorsize isn&#39;t set at all?<br></blockquote><div><br><=
/div><div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica=
,sans-serif;display:inline">=E2=80=8BThis looks like a bug, I think the ass=
ignment should stay here.</div></div><div><div class=3D"gmail_default" styl=
e=3D"font-family:arial,helvetica,sans-serif;display:inline">=E2=80=8B</div>=
=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0=
.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-left-s=
tyle:solid;padding-left:1ex">
<span class=3D""><br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0ft-&gt;psectorsize =3D ft-&gt;lsectorsize =3D BBSIZE;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0blkid_get_topolo=
gy(dfile, &amp;ft-&gt;dsunit, &amp;ft-&gt;dswidth,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;ft-&gt;lsectorsize, &amp;ft=
-&gt;psectorsize,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 force_overwrite);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&amp;ft-&gt;=
lsectorsize, &amp;ft-&gt;psectorsize,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0force_overwr=
ite);<br>
<br>
</span>please don&#39;t change these lines, they line up w/ the function op=
ening paren as<br>
they should.<br>
<div><div class=3D"h5"><br></div></div></blockquote><div><div class=3D"gmai=
l_default" style=3D"font-family:arial,helvetica,sans-serif">=E2=80=8BSure. =
=E2=80=8B</div><br></div><div>=C2=A0</div><blockquote class=3D"gmail_quote"=
 style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:=
rgb(204,204,204);border-left-style:solid;padding-left:1ex"><div class=3D"h5=
">
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (xi-&gt;rtname &amp;&amp; !xi-&gt;risfile=
) {<br>
&gt; @@ -1016,6 +1019,75 @@ static void get_topology(<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 static void<br>
&gt; +check_device_type(<br>
&gt; +=C2=A0 =C2=A0 =C2=A0const char=C2=A0 =C2=A0 =C2=A0 *name,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0*isfile,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0bool=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 no_=
size,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0bool=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 no_=
name,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0*create,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0bool=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for=
ce_overwrite,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0const char=C2=A0 =C2=A0 =C2=A0 *optname)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct stat64 statbuf;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (*isfile &amp;&amp; (no_size || no_name)) {<br=
>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stderr,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0_(&quot;if -%s file then -%s name and -%s size ar=
e required\n&quot;),<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0optname, optname, optname);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0usage();<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (stat64(name, &amp;statbuf)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (errno =3D=3D ENOE=
NT &amp;&amp; *isfile) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0if (create)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*create =3D 1;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0return;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stderr,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0_(&quot;Error accessing specified device %s: %s\n=
&quot;),<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0name, strerror(errno));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0usage();<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!force_overwrite &amp;&amp; check_overwrite(n=
ame)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stderr,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0_(&quot;%s: Use the -f option to force overwrite.=
\n&quot;),<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0progname);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0exit(1);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * We only want to completely truncate and recrea=
te an existing file if<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * we were specifically told it was a file. Set t=
he create flag only in<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * this case to trigger that behaviour.<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (S_ISREG(statbuf.st_mode)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!*isfile)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0*isfile =3D 1;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else if (create)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0*create =3D 1;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (S_ISBLK(statbuf.st_mode)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (*isfile) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0fprintf(stderr,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0_(&quot;specified \&quot;-%s file\&quot; on a blo=
ck device %s\n&quot;),<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0optname, name);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0usage();<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0fprintf(stderr,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0_(&quot;specified device %s not a file or block d=
evice\n&quot;),<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0name);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0usage();<br>
&gt; +}<br>
&gt; +<br>
&gt; +static void<br>
&gt;=C2=A0 fixup_log_stripe_unit(<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0lsflag,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0sunit,<br>
&gt; @@ -1279,7 +1351,6 @@ zero_old_xfs_structures(<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0__uint32_t=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 bsize;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0i;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0xfs_off_t=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0off;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0int=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tmp;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 * We open regular files with O_TRUNC|O_CREA=
T. Nothing to do here...<br>
&gt; @@ -1299,15 +1370,23 @@ zero_old_xfs_structures(<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0memset(buf, 0, new_sb-&gt;sb_sectsize);<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0tmp =3D pread(xi-&gt;dfd, buf, new_sb-&gt;sb_sect=
size, 0);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (tmp &lt; 0) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0off =3D pread(xi-&gt;dfd, buf, new_sb-&gt;sb_sect=
size, 0);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (off &lt; 0) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stderr, =
_(&quot;existing superblock read failed: %s\n&quot;),<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0strerror(errno));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto done;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (tmp !=3D new_sb-&gt;sb_sectsize) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stderr,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0_(&quot;warning: could not read existing superblo=
ck, skip zeroing\n&quot;));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * If we are creating an image file, it might be =
of zero length at this<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * point in time. Hence reading the existing supe=
rblock is going to<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * return zero bytes. It&#39;s not a failure we n=
eed to warn about in this<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * case.<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 */<br><br></div></blockquote><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;bo=
rder-left-color:rgb(204,204,204);border-left-style:solid;padding-left:1ex">=
<div><div class=3D"h5">
</div></div>except you already did &quot;if (off &lt; 0) fail&quot; above t=
his.<br>
<br>
Ok, at this point I think it might be best to revert to Dave&#39;s original=
 version.<br>
<br>
If there were specific problems you were trying to address, can you point t=
hem out?<br>
<br>
Thanks,<br>
-Eric<br>
<div class=3D""><div class=3D"h5"><span style=3D"color:rgb(34,34,34)"><br><=
/span></div></div></blockquote><div><div class=3D"gmail_default" style=3D"f=
ont-family:arial,helvetica,sans-serif;display:inline">=E2=80=8B(inserting y=
our next email)=E2=80=8B</div>=C2=A0</div><blockquote class=3D"gmail_quote"=
 style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:=
rgb(204,204,204);border-left-style:solid;padding-left:1ex"><div class=3D"">=
<div class=3D"h5"><span style=3D"color:rgb(34,34,34)"><br>On 4/7/16 7:25 PM=
, Eric Sandeen wrote:<br>&gt;&gt; @@ -1299,15 +1370,23 @@ zero_old_xfs_stru=
ctures(<br>&gt;&gt; &gt;=C2=A0 =C2=A0 }<br>&gt;&gt; &gt;=C2=A0 =C2=A0 memse=
t(buf, 0, new_sb-&gt;sb_sectsize);<br>&gt;&gt; &gt;<br>&gt;&gt; &gt; -=C2=
=A0 tmp =3D pread(xi-&gt;dfd, buf, new_sb-&gt;sb_sectsize, 0);<br>&gt;&gt; =
&gt; -=C2=A0 if (tmp &lt; 0) {<br>&gt;&gt; &gt; +=C2=A0 off =3D pread(xi-&g=
t;dfd, buf, new_sb-&gt;sb_sectsize, 0);<br>&gt;&gt; &gt; +=C2=A0 if (off &l=
t; 0) {<br>&gt;&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(s=
tderr, _(&quot;existing superblock read failed: %s\n&quot;),<br>&gt;&gt; &g=
t;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 str=
error(errno));<br>&gt;&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 go=
to done;<br>&gt;&gt; &gt;=C2=A0 =C2=A0 }<br>&gt;&gt; &gt; -=C2=A0 if (tmp !=
=3D new_sb-&gt;sb_sectsize) {<br>&gt;&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 fprintf(stderr,<br>&gt;&gt; &gt; -=C2=A0 _(&quot;warning: could not=
 read existing superblock, skip zeroing\n&quot;));<br>&gt;&gt; &gt; +=C2=A0=
 /*<br>&gt;&gt; &gt; +=C2=A0 =C2=A0* If we are creating an image file, it m=
ight be of zero length at this<br>&gt;&gt; &gt; +=C2=A0 =C2=A0* point in ti=
me. Hence reading the existing superblock is going to<br>&gt;&gt; &gt; +=C2=
=A0 =C2=A0* return zero bytes. It&#39;s not a failure we need to warn about=
 in this<br>&gt;&gt; &gt; +=C2=A0 =C2=A0* case.<br>&gt;&gt; &gt; +=C2=A0 =
=C2=A0*/<br>&gt; except you already did &quot;if (off &lt; 0) fail&quot; ab=
ove this.<br><br></span><span style=3D"color:rgb(34,34,34)">(oh, right, &lt=
; 0 is different than =3D=3D 0, sorry; so that part is ok)</span><br style=
=3D"color:rgb(34,34,34)"><br style=3D"color:rgb(34,34,34)"><span style=3D"c=
olor:rgb(34,34,34)">Possibly better as:</span><br style=3D"color:rgb(34,34,=
34)"><br style=3D"color:rgb(34,34,34)"><span style=3D"color:rgb(34,34,34)">=
if (off &lt; 0 || (tmp !=3D new_sb-&gt;sb_sectsize &amp;&amp; !xi-&gt;disfi=
le))</span><br style=3D"color:rgb(34,34,34)"><span style=3D"color:rgb(34,34=
,34)">=C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(&quot;error reading existing supe=
rblock ...&quot;)</span></div></div></blockquote><div><div class=3D"gmail_d=
efault" style=3D"font-family:arial,helvetica,sans-serif;display:inline">=E2=
=80=8BOK, better to be sure. :-)</div></div><div><div class=3D"gmail_defaul=
t" style=3D"font-family:arial,helvetica,sans-serif;display:inline">=E2=80=
=8B</div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px =
0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);bord=
er-left-style:solid;padding-left:1ex"><div class=3D""><div class=3D"h5"><br=
 style=3D"color:rgb(34,34,34)"><br style=3D"color:rgb(34,34,34)"><span styl=
e=3D"color:rgb(34,34,34)">I still think this patch might need a reset thoug=
h :)</span><br style=3D"color:rgb(34,34,34)"><br style=3D"color:rgb(34,34,3=
4)"><span style=3D"color:rgb(34,34,34)">Thanks,</span><br style=3D"color:rg=
b(34,34,34)"><span style=3D"color:rgb(34,34,34)">-Eric</span><br style=3D"c=
olor:rgb(34,34,34)"><span style=3D"color:rgb(34,34,34)"><br>&gt; Ok, at thi=
s point I think it might be best to revert to Dave&#39;s original version.<=
br>&gt;<br>&gt; If there were specific problems you were trying to address,=
 can you point them out?<br></span></div></div></blockquote><div><br></div>=
<div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-seri=
f">=E2=80=8BOn few places, the original patch looked as if files had direct=
 IO still enabled=E2=80=8B (using platform_findsize...), and I think it was=
 causing some failures - fixing issues is why I did most of the changes.</d=
iv><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-s=
erif"><br></div><div class=3D"gmail_default" style=3D"font-family:arial,hel=
vetica,sans-serif">I will revert to the original version and see what exact=
ly fails. But with being Friday late afternoon, the results will be availab=
le the next week (Wednesday and further, all my courses at university are s=
tuffed in Mon/Tue).</div><div class=3D"gmail_default" style=3D"font-family:=
arial,helvetica,sans-serif"><br></div><div class=3D"gmail_default" style=3D=
"font-family:arial,helvetica,sans-serif">Cheers,</div><div class=3D"gmail_d=
efault" style=3D"font-family:arial,helvetica,sans-serif">Jan</div><div>=C2=
=A0</div></div><div><br></div>-- <br><div class=3D"gmail_signature"><div di=
r=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:j=
tulak@redhat.com" target=3D"_blank">jtulak@redhat.com</a>=C2=A0/ <a href=3D=
"mailto:jan@tulak.me" target=3D"_blank">jan@tulak.me</a></div></div></div><=
/div>
</div></div>

--001a113ebe201e4c5c052ffa6eff--


--===============8985250109711113274==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8985250109711113274==--
