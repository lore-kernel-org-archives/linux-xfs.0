Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C7FFD7F3F
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2014 16:46:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3B810AC001
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2014 14:46:46 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id zUqQzaiFa6z1QHO6 for <xfs@oss.sgi.com>;
	Sat, 13 Sep 2014 14:46:45 -0700 (PDT)
Message-ID: <5414BB44.6060306@sandeen.net>
Date: Sat, 13 Sep 2014 16:46:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [RFD] xfs_fsr: Doubts related to xfs_fsr code
References: <CAJAKVEFGf5yKBy7BK3K9fRW3DZpZ1+1-bvnzpVpPdpB219Amtw@mail.gmail.com>
In-Reply-To: <CAJAKVEFGf5yKBy7BK3K9fRW3DZpZ1+1-bvnzpVpPdpB219Amtw@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Somdeep Dey <somdeepdey10@gmail.com>, xfs@oss.sgi.com

On 9/13/14 12:07 PM, Somdeep Dey wrote:
> Hi,
> =

> While studying the code and attempting to understand it, we have come up =
against certain doubts that have us in a slight fix. We've included the con=
cerned
>  sections of the code below, along with our specific problem in each of t=
hese =

>  sections. A little pointer in the right direction would be of great help.
> =

> (Source file : fsr_xfs_fsr.c)

If possible, please send mails - especially those containing code - =

in plaintext, not HTML, so it doeesn't get mangled.

> ****** Doubt number 1 ******
> (line 331 onwards)

(re-pasted to avoid html mangling)

                for (; optind < argc; optind++) {
                        argname =3D argv[optind];

                        if (lstat64(argname, &sb) < 0) {
                                fprintf(stderr,
                                        _("%s: could not stat: %s: %s\n"),
                                        progname, argname, strerror(errno));
                                continue;
                        }

                        if (S_ISLNK(sb.st_mode)) {
                                struct stat64 sb2;

                                if (stat64(argname, &sb2) =3D=3D 0 &&
                                    (S_ISBLK(sb2.st_mode) ||
                                     S_ISCHR(sb2.st_mode)))
                                sb =3D sb2;
                        }

                        mntp =3D find_mountpoint(mtab, argname, &sb);

> _________________________________________________________________________=
_______
> =

> We understand that lstat64() and stat64() are used to see if target
>  (file/filesystem) can be stated and if yes then the structure is saved. =

> But we couldn=92t exactly understand its use and why both functions are u=
sed separately.
> Usually the error could not stat: filename : is followed by Permission de=
nied.
>  Is this related to the root permissions i.e. accessibility ?

The code has the net effect of only using the stat information of a link
target if that target is a block or character device.  I don't know for sure
why that is, but I presume that it has to do with the find_mountpoint() cod=
e,
and symlinks in /dev vs. what is found in /proc/mounts.

The manpage mentions this behavior as well:

  A command line name referring to a symbolic link (except to a file system
  device), FIFO, or UNIX domain socket generates a warning message, but is
  otherwise ignored. While traversing the filesystem these types of files a=
re
  silently skipped.

> ****** Doubt number 2 ******
> =

> (line 184 onwards)

        while ((t =3D getmntent(mtabp))) {
                if (S_ISDIR(sb->st_mode)) {             /* mount point */
                        if (stat64(t->mnt_dir, &ms) < 0)
                                continue;
                        if (sb->st_ino !=3D ms.st_ino)
                                continue;
                        if (sb->st_dev !=3D ms.st_dev)
                                continue;
                        if (strcmp(t->mnt_type, MNTTYPE_XFS) !=3D 0)
                                continue;
                } else {                                /* device */
                        struct stat64 sb2;

                        if (stat64(t->mnt_fsname, &ms) < 0)
                                continue;
                        if (sb->st_rdev !=3D ms.st_rdev)
                                continue;
                        if (strcmp(t->mnt_type, MNTTYPE_XFS) !=3D 0)
                                continue;

                        /*
                         * Make sure the mountpoint given by mtab is access=
ible
                         * before using it.
                         */
                        if (stat64(t->mnt_dir, &sb2) < 0)
                                continue;
> _________________________________________________________________________=
_______
> We just wanted to confirm if the basic working of the function is
> 1) To obtain a mount table pointer to the mount table (/etc/mtab/ or /pro=
c/mounts).
> 2)  For each entry in the mount table check if it is a directory or devic=
e and after
>  performing various comparisons (checks) =96 (could you please elaborate =
on the checks
>   performed), this function returns a pointer to the entry. =


We are looking to see if we have been given either a mounted xfs device, or=
 an
xfs mount point.  We iterate over devices from getmntent to find out if the=
re
is a match for a mounted filesystem.

If the cmdline argument was a directory, it might be a mountpoint, so we
check the getmntent entry's mnt_dir (mountpoint) to see if it:

	1) has the same inode number as our argument
	2) is the same device number as our argument (same st_dev)
	3) is of type XFS

If it isn't a directory, it might be a device, so we check the getmntent
entry's device by looking at it's mnt_fsname (device) to see if:

	1) is the same device number (same st_rdev)
	2) is of type XFS

> ****** Doubt number 3 ******
> =

> (line 677 onwards)
> static int
> fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
> =

> For the following =


        __s32   buflenout;
...

        fshandlep =3D jdm_getfshandle( mntdir );
        if ( ! fshandlep ) {
                fsrprintf(_("unable to get handle: %s: %s\n"),
                          mntdir, strerror( errno ));
                return -1;
        }

> _________________________________________________________________________=
_______
> =

> We are a bit confused about what is exactly the file handle being returned
>  by jdm_getfshandle().
> Also what exactly is buflenout. Is it a structure field ?
> _________________________________________________________________________=
_______


Let's be inquisitive people, and find out the answers to these questions by
reading the code and the existing documentation:

The fshandlep returned by jdm_getfshandle is passed through jdm_open() to
open_by_fshandle(), which calls the XFS_IOC_OPEN_BY_HANDLE interface, which
is well described in the open_by_handle(3) manpage.


buflenout is passed to xfs_bulkstat() as the *ocount argument, which assign=
s it
to an xfs_fsop_bulkreq_t structure's ocount member.  That structure is then
passed to the XFS_IOC_FSBULKSTAT which is documented in the xfsctl manpage:

  ocount is a pointer to a count of returned values, filled in by the call.
  An output ocount value of zero means that the inode table has been exhaus=
ted.

That manpage also explains what the XFS bulkstat interface does.

> _________________________________________________________________________=
_______

        while ((ret =3D xfs_bulkstat(fsfd,
                                &lastino, GRABSZ, &buf[0], &buflenout) =3D=
=3D 0)) {
                xfs_bstat_t *p;
                xfs_bstat_t *endp;

                if (buflenout =3D=3D 0)
                        goto out0;

                /* Each loop through, defrag targetrange percent of the fil=
es */
                count =3D (buflenout * targetrange) / 100;

                qsort((char *)buf, buflenout, sizeof(struct xfs_bstat), cmp=
);

> In the above code snippet we understand that the while loop will run for =
N(10) =

> passes and defragment top 10% of the defragmented files.
> However we would appreciate if you could further explain the functions:
> =

> (ret =3D xfs_bulkstat(fsfd,&lastino, GRABSZ, &buf[0], &buflenout) =3D=3D =
0)

see the manpage mentioned above; it gets a batch (GRABSZ, or 64) of inodes
to look at.

> qsort((char *)buf, buflenout, sizeof(struct xfs_bstat), cmp);
> =

> We know that the sort function will be used to sort extents based on size=
 and then =

> offset, but a bit more information on how it is exactly working will be r=
eally =

> appreciated, as we believe that this sort() has some other purpose.
> _________________________________________________________________________=
_______

It has nothing to do with the extent *size*

qsort is passed cmp() which compares the number of extents, based on:

        __s32           bs_extents;     /* number of extents            */

and sorts based on that.  So it compares all of the entries returned
by xfs_bulkstat and sorts the buffer by the number of extents in the
entries, that's all.

> For this mail we have listed only a limited number of doubts that we
> think are pressing. Based on further explanations that we might
> receive from you, we will send out another mail for the doubts that
> still linger.

Please also do as much reading of code and the existing documentation as
you can, first. ;)

-Eric

> Regards,
> A-DRS.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
