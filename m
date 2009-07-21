Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6L1MaBf126063 for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 20:22:38 -0500
Received: from rlogin.dk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 99F8B374E6F
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 18:23:17 -0700 (PDT)
Received: from rlogin.dk (rlogin.dk [81.161.188.225]) by cuda.sgi.com with
	ESMTP id MROdgZnxIluEfFhJ for <xfs@oss.sgi.com>;
	Mon, 20 Jul 2009 18:23:17 -0700 (PDT)
Date: Tue, 21 Jul 2009 03:24:55 +0200
From: Michael Ole Olsen <gnu@gmx.net>
Subject: patch 2.6.30 and 2.6.30.1 xfs/nfs oops fix, radix tree
Message-ID: <20090721012455.GG3229@rlogin.dk>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4806512832089189341=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs <xfs@oss.sgi.com>


--===============4806512832089189341==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sfyO1m2EN8ZOtJL6"
Content-Disposition: inline


--sfyO1m2EN8ZOtJL6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Eric has been very helpful in helping me downgrade xfs in 2.6.30.1 to 2.6.2=
8.7
version (getting 2.6.28.7 to compile in 2.6.30.1) which removed the oopses.

Just wanted to post here for other people like me that don't have an option
of downgrading their kernel (need i.e. mdadm>=3D2.6.30).

for those that use special features of i.e. mdadm for raid which requires at
least 2.6.30 to assemble the raid6 with Q blocks on the last disk i.e. this=
 is
about the only option.

Xfs seems to oops all the time in >=3D2.6.30 on my boxes with radix tree tr=
ace,=20
that is why the downgrade was made.

I havn't had a single issue since downgrading which is a few days ago now,
before I used to get up to 3-4 oopses a day in 2.6.30 or 2.6.30.1 with
nfs+xfs and lots of npd!=3Dnp in dmesg which are now gone

Here is the patch that I got from him that fixes the oopses in >=3D2.6.30 w=
ith
nfs, I will be adding it to the bugzilla as well until the real bug is fixed
http://bugzilla.kernel.org/show_bug.cgi?id=3D13375

The patch is simply the 2.6.28.7 xfs code, modified to compile on 2.6.30
and 2.6.30.1 , no guarantees (although I have extensively tested for some d=
ays
now without problems whatsoever).

# author eric @ xfs.org
# fixes xfs radix tree oopses in 2.6.30 and 2.6.30.1 with nfs kernel server
# and also perhaps selinux oopses (nfs_setuid) as well (havn't tested)
# this patch is based on linux 2.6.28.7 xfs kernel code,
# and should only be needed if you need kernel code from
# 2.6.30 but xfs keeps oopsing in that kernel, i.e. mdadm from >=3D2.6.30 k=
ernel
Index: linux-2.6.28.7/fs/xfs/linux-2.6/xfs_cred.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.28.7.orig/fs/xfs/linux-2.6/xfs_cred.h
+++ linux-2.6.28.7/fs/xfs/linux-2.6/xfs_cred.h
@@ -23,9 +23,7 @@
 /*
  * Credentials
  */
-typedef struct cred {
-       /* EMPTY */
-} cred_t;
+typedef struct cred cred_t;

 extern struct cred *sys_cred;

Index: linux-2.6.28.7/fs/xfs/xfs_acl.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.28.7.orig/fs/xfs/xfs_acl.c
+++ linux-2.6.28.7/fs/xfs/xfs_acl.c
@@ -366,7 +366,7 @@ xfs_acl_allow_set(
                return ENOTDIR;
        if (vp->i_sb->s_flags & MS_RDONLY)
                return EROFS;
-       if (XFS_I(vp)->i_d.di_uid !=3D current->fsuid && !capable(CAP_FOWNE=
R))
+       if (XFS_I(vp)->i_d.di_uid !=3D current_fsuid() && !capable(CAP_FOWN=
ER))
                return EPERM;
        return 0;
 }
@@ -413,13 +413,13 @@ xfs_acl_access(
                switch (fap->acl_entry[i].ae_tag) {
                case ACL_USER_OBJ:
                        seen_userobj =3D 1;
-                       if (fuid !=3D current->fsuid)
+                       if (fuid !=3D current_fsuid())
                                continue;
                        matched.ae_tag =3D ACL_USER_OBJ;
                        matched.ae_perm =3D allows;
                        break;
                case ACL_USER:
-                       if (fap->acl_entry[i].ae_id !=3D current->fsuid)
+                       if (fap->acl_entry[i].ae_id !=3D current_fsuid())
                                continue;
                        matched.ae_tag =3D ACL_USER;
                        matched.ae_perm =3D allows;
Index: linux-2.6.28.7/fs/xfs/linux-2.6/xfs_ioctl.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.28.7.orig/fs/xfs/linux-2.6/xfs_ioctl.c
+++ linux-2.6.28.7/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -256,6 +256,7 @@ xfs_open_by_handle(
        struct file             *parfilp,
        struct inode            *parinode)
 {
+       const struct cred       *cred =3D current_cred();
        int                     error;
        int                     new_fd;
        int                     permflag;
@@ -321,7 +322,7 @@ xfs_open_by_handle(
        mntget(parfilp->f_path.mnt);

        /* Create file pointer. */
-       filp =3D dentry_open(dentry, parfilp->f_path.mnt, hreq.oflags);
+       filp =3D dentry_open(dentry, parfilp->f_path.mnt, hreq.oflags, cred=
);
        if (IS_ERR(filp)) {
                put_unused_fd(new_fd);
                return -XFS_ERROR(-PTR_ERR(filp));
@@ -1007,7 +1008,7 @@ xfs_ioctl_setattr(
         * to the file owner ID, except in cases where the
         * CAP_FSETID capability is applicable.
         */
-       if (current->fsuid !=3D ip->i_d.di_uid && !capable(CAP_FOWNER)) {
+       if (current_fsuid() !=3D ip->i_d.di_uid && !capable(CAP_FOWNER)) {
                code =3D XFS_ERROR(EPERM);
                goto error_return;
        }
Index: linux-2.6.28.7/fs/xfs/linux-2.6/xfs_iops.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.28.7.orig/fs/xfs/linux-2.6/xfs_iops.c
+++ linux-2.6.28.7/fs/xfs/linux-2.6/xfs_iops.c
@@ -228,7 +228,7 @@ xfs_vn_mknod(
        xfs_dentry_to_name(&name, dentry);

        if (IS_POSIXACL(dir) && !default_acl)
-               mode &=3D ~current->fs->umask;
+               mode &=3D ~current_umask();

        switch (mode & S_IFMT) {
        case S_IFCHR:
@@ -422,7 +422,7 @@ xfs_vn_symlink(
        mode_t          mode;

        mode =3D S_IFLNK |
-               (irix_symlink_mode ? 0777 & ~current->fs->umask : S_IRWXUGO=
);
+               (irix_symlink_mode ? 0777 & ~current_umask() : S_IRWXUGO);
        xfs_dentry_to_name(&name, dentry);

        error =3D xfs_symlink(XFS_I(dir), &name, symname, mode, &cip, NULL);
Index: linux-2.6.28.7/fs/xfs/linux-2.6/xfs_super.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.28.7.orig/fs/xfs/linux-2.6/xfs_super.c
+++ linux-2.6.28.7/fs/xfs/linux-2.6/xfs_super.c
@@ -1351,14 +1351,15 @@ xfs_fs_remount(
  * need to take care of themetadata. Once that's done write a dummy
  * record to dirty the log in case of a crash while frozen.
  */
-STATIC void
-xfs_fs_lockfs(
+STATIC int
+xfs_fs_freeze(
        struct super_block      *sb)
 {
        struct xfs_mount        *mp =3D XFS_M(sb);

        xfs_attr_quiesce(mp);
        xfs_fs_log_dummy(mp);
+       return 0;
 }

 STATIC int
@@ -1847,7 +1848,7 @@ static struct super_operations xfs_super
        .put_super              =3D xfs_fs_put_super,
        .write_super            =3D xfs_fs_write_super,
        .sync_fs                =3D xfs_fs_sync_super,
-       .write_super_lockfs     =3D xfs_fs_lockfs,
+       .freeze_fs              =3D xfs_fs_freeze,
        .statfs                 =3D xfs_fs_statfs,
        .remount_fs             =3D xfs_fs_remount,
        .show_options           =3D xfs_fs_show_options,
Index: linux-2.6.28.7/fs/xfs/linux-2.6/xfs_file.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.28.7.orig/fs/xfs/linux-2.6/xfs_file.c
+++ linux-2.6.28.7/fs/xfs/linux-2.6/xfs_file.c
@@ -299,9 +299,9 @@ xfs_file_ioctl_invis(
 STATIC int
 xfs_vm_page_mkwrite(
        struct vm_area_struct   *vma,
-       struct page             *page)
+       struct vm_fault         *vmf)
 {
-       return block_page_mkwrite(vma, page, xfs_get_blocks);
+       return block_page_mkwrite(vma, vmf, xfs_get_blocks);
 }

 const struct file_operations xfs_file_operations =3D {

--sfyO1m2EN8ZOtJL6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBAgAGBQJKZRjmAAoJECXlragqp/ZIp8gP/2//Xig2wxQalk1QVmY16X3j
65WFd8pzpxdiWU82s6pahNuMuEO00tafenruvuMDLIg65itRvUJt24u2VjwZVsh/
mr7wxlOxSdsPA3Qu9CbQWzspBDVOh/noRIxmNxSzg6emuNZs3fRD+Lky/JBoUN7H
BVCOL2KApGltilhxXNn6DIHhKTpCdo6vEJprMyNG6gJc465/hh5MV4jB3AePS93z
jXB8Q2Wd0bEgQKB8qQFXNdIvOmOzMKWD17OkWYvDM9wIvLygDPrG8nG1CTj1k1Rq
oARiwp9IeQR6sDED6fuC1EJkI0u2G45dYOj6N2fiSlPdHAuzZnwqxqahWFFUoeA8
ri2FI40homDGh+vyfHs7IJ0OO+pMtGMY79LanVtwNhaJj799DiDNJL/QWq890Jey
DDlsJdLpzRNNQbMvnX1uC9e+DnNsN4A+aR5yc869lZoDduRmSVl2XbTdOysM2gi0
0z5/34y4B/81VQDwpq2ZTbMYzpyJ8btgkfQ9UBeyYEsK6ueFYugSgEBy5tFRAt4W
rLF5K+nZPshFcVj9OlAZweAYKp/09Yqn0KOSs1j250Oulrl30n1ZKaLYYRhCxhYo
MhvScJQacdIKrefRKvN8dvNDaLazUsjrT6JRetUE2q+meEO9ehmEivMyWFpJ0Jhx
OeZdLdVjSwAgjSaZex5Q
=U5NG
-----END PGP SIGNATURE-----

--sfyO1m2EN8ZOtJL6--


--===============4806512832089189341==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4806512832089189341==--
