Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ozlabs.org ([203.11.71.1]:42257 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728591AbeJaJsh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Oct 2018 05:48:37 -0400
Date: Wed, 31 Oct 2018 11:52:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the vfs tree with the xfs tree
Message-ID: <20181031115247.6adcb659@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/wf7V+EiKui3bl=g5qIjdOB="; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mark Fasheh <mfasheh@suse.de>

--Sig_/wf7V+EiKui3bl=g5qIjdOB=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

[I don't understand why all this new work turned up in the xfs tree
during the merge window ...]

Today's linux-next merge of the vfs tree got a conflict in:

  fs/read_write.c

between commits:

  42ec3d4c0218 ("vfs: make remap_file_range functions take and return bytes=
 completed")
  eca3654e3cc7 ("vfs: enable remap callers that can handle short operations=
")

from the xfs tree and commit:

  5de4480ae7f8 ("vfs: allow dedupe of user owned read-only files")

from the vfs tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc fs/read_write.c
index 50680b900b52,10f9bed985f4..000000000000
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@@ -2014,14 -1880,120 +2013,28 @@@ loff_t vfs_clone_file_range(struct fil
  }
  EXPORT_SYMBOL(vfs_clone_file_range);
 =20
 -/*
 - * Read a page's worth of file data into the page cache.  Return the page
 - * locked.
 - */
 -static struct page *vfs_dedupe_get_page(struct inode *inode, loff_t offse=
t)
 -{
 -	struct address_space *mapping;
 -	struct page *page;
 -	pgoff_t n;
 -
 -	n =3D offset >> PAGE_SHIFT;
 -	mapping =3D inode->i_mapping;
 -	page =3D read_mapping_page(mapping, n, NULL);
 -	if (IS_ERR(page))
 -		return page;
 -	if (!PageUptodate(page)) {
 -		put_page(page);
 -		return ERR_PTR(-EIO);
 -	}
 -	lock_page(page);
 -	return page;
 -}
 -
 -/*
 - * Compare extents of two files to see if they are the same.
 - * Caller must have locked both inodes to prevent write races.
 - */
 -int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 -				  struct inode *dest, loff_t destoff,
 -				  loff_t len, bool *is_same)
 -{
 -	loff_t src_poff;
 -	loff_t dest_poff;
 -	void *src_addr;
 -	void *dest_addr;
 -	struct page *src_page;
 -	struct page *dest_page;
 -	loff_t cmp_len;
 -	bool same;
 -	int error;
 -
 -	error =3D -EINVAL;
 -	same =3D true;
 -	while (len) {
 -		src_poff =3D srcoff & (PAGE_SIZE - 1);
 -		dest_poff =3D destoff & (PAGE_SIZE - 1);
 -		cmp_len =3D min(PAGE_SIZE - src_poff,
 -			      PAGE_SIZE - dest_poff);
 -		cmp_len =3D min(cmp_len, len);
 -		if (cmp_len <=3D 0)
 -			goto out_error;
 -
 -		src_page =3D vfs_dedupe_get_page(src, srcoff);
 -		if (IS_ERR(src_page)) {
 -			error =3D PTR_ERR(src_page);
 -			goto out_error;
 -		}
 -		dest_page =3D vfs_dedupe_get_page(dest, destoff);
 -		if (IS_ERR(dest_page)) {
 -			error =3D PTR_ERR(dest_page);
 -			unlock_page(src_page);
 -			put_page(src_page);
 -			goto out_error;
 -		}
 -		src_addr =3D kmap_atomic(src_page);
 -		dest_addr =3D kmap_atomic(dest_page);
 -
 -		flush_dcache_page(src_page);
 -		flush_dcache_page(dest_page);
 -
 -		if (memcmp(src_addr + src_poff, dest_addr + dest_poff, cmp_len))
 -			same =3D false;
 -
 -		kunmap_atomic(dest_addr);
 -		kunmap_atomic(src_addr);
 -		unlock_page(dest_page);
 -		unlock_page(src_page);
 -		put_page(dest_page);
 -		put_page(src_page);
 -
 -		if (!same)
 -			break;
 -
 -		srcoff +=3D cmp_len;
 -		destoff +=3D cmp_len;
 -		len -=3D cmp_len;
 -	}
 -
 -	*is_same =3D same;
 -	return 0;
 -
 -out_error:
 -	return error;
 -}
 -EXPORT_SYMBOL(vfs_dedupe_file_range_compare);
 -
+ /* Check whether we are allowed to dedupe the destination file */
+ static bool allow_file_dedupe(struct file *file)
+ {
+ 	if (capable(CAP_SYS_ADMIN))
+ 		return true;
+ 	if (file->f_mode & FMODE_WRITE)
+ 		return true;
+ 	if (uid_eq(current_fsuid(), file_inode(file)->i_uid))
+ 		return true;
+ 	if (!inode_permission(file_inode(file), MAY_WRITE))
+ 		return true;
+ 	return false;
+ }
+=20
 -int vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 -			      struct file *dst_file, loff_t dst_pos, u64 len)
 +loff_t vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 +				 struct file *dst_file, loff_t dst_pos,
 +				 loff_t len, unsigned int remap_flags)
  {
 -	s64 ret;
 +	loff_t ret;
 +
 +	WARN_ON_ONCE(remap_flags & ~(REMAP_FILE_DEDUP |
 +				     REMAP_FILE_CAN_SHORTEN));
 =20
  	ret =3D mnt_want_write_file(dst_file);
  	if (ret)

--Sig_/wf7V+EiKui3bl=g5qIjdOB=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlvY/N8ACgkQAVBC80lX
0GyWYwf7BsacbozPlupcw6q8zL6YxFTxk4fzb/GgimWS3Zq2b359YZGLjA5LvGef
iH67sHFyO1th6ZSL3BLeu/41i3OFRSAYrY+7SQKNDu8NPMEKBaV8mmXsWTLbI8l5
0OSpT/IbAs2+AqTiiVzb2IheqHdl6NpUqvaSS8nBQFjFf9feIJTXVHqQh4NpueMR
pCyyHEbuwTi4PQ6PyRx7G9JCzin6nswYhvVcDmaXiDKVtSuDWoPbneuWMX5EUax7
xAVQF6I/gJkhDOE8r5unfFwKjN+90E0Iqm40vZ/tKIvm6d3oxoVoMwsVqYiayNvv
u21e5dEm1rbGX32rrp3evbFmRdR/tA==
=9Zcp
-----END PGP SIGNATURE-----

--Sig_/wf7V+EiKui3bl=g5qIjdOB=--
