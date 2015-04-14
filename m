Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E373A7F37
	for <xfs@oss.sgi.com>; Mon, 13 Apr 2015 20:34:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B7FDB30404E
	for <xfs@oss.sgi.com>; Mon, 13 Apr 2015 18:34:55 -0700 (PDT)
Received: from ozlabs.org (ozlabs.org [103.22.144.67]) by cuda.sgi.com with
	ESMTP id mYFmNAe6tmXbNEVo (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Apr 2015 18:34:49 -0700 (PDT)
Date: Tue, 14 Apr 2015 11:34:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the vfs tree with the xfs tree
Message-ID: <20150414113442.62751cdc@canb.auug.org.au>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3211935967495183758=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Al Viro <viro@ZenIV.linux.org.uk>, Ben Myers <bpm@sgi.com>, David Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: David Howells <dhowells@redhat.com>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

--===============3211935967495183758==
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/5O+aYlm=1mAzyMbqBYGBoKU"; protocol="application/pgp-signature"

--Sig_/5O+aYlm=1mAzyMbqBYGBoKU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
fs/xfs/xfs_iops.c between commit 21c3ea18819b ("xfs: unlock i_mutex in
xfs_break_layouts") from the xfs tree and commit 5dd3dc06371a ("VFS:
normal filesystems (and lustre): d_inode() annotations") from the vfs
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/xfs/xfs_iops.c
index 2f1839e4dd1b,54b95232d946..000000000000
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@@ -953,13 -975,9 +953,13 @@@ xfs_vn_setattr
  		uint		iolock =3D XFS_IOLOCK_EXCL;
 =20
  		xfs_ilock(ip, iolock);
- 		error =3D xfs_break_layouts(dentry->d_inode, &iolock, true);
 -		error =3D xfs_break_layouts(d_inode(dentry), &iolock);
 -		if (!error)
++		error =3D xfs_break_layouts(d_inode(dentry), &iolock, true);
 +		if (!error) {
 +			xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
 +			iolock |=3D XFS_MMAPLOCK_EXCL;
 +
  			error =3D xfs_setattr_size(ip, iattr);
 +		}
  		xfs_iunlock(ip, iolock);
  	} else {
  		error =3D xfs_setattr_nonsize(ip, iattr, 0);

--Sig_/5O+aYlm=1mAzyMbqBYGBoKU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVLG63AAoJEMDTa8Ir7ZwVpLYP/3Sag0Zfim2NG4Ls84f8xR7b
uv4FNLtmXMXAW3ioV8H2d4qvT80esCti3mTmdioUzvt6WuXPO9DN/QRoWb3olXfb
sQ4NXn0PJt7cxH+GT98+DhUuwy3VJrm87jUECYoMXGu3nl6t42W9F1UxShW9a36l
vv5HDqyNrR6MdJVy/b6h5mO6qY4t3cmnS5PQvklVz7/4/S9TiC/jdK63PwPzZ5Wt
n4R9LDXiWbtmG9YGaNcDb9mpn5XzJsa5NYQWTz8LofUik50T6+nEqIPxrj9Mv7ae
S9hZN/JZkXtTIEJ4IENej4Qh9akQI19Fxtq251MUOXyIp4J7V8JM8p3zzi99fbIL
MCDpzAbC4S6H+enPp3yKtxwYdjpUZkvVkU6eLCTdQSVNlvvuMCyMZYSpthsmByWn
IfnsnEa7Y1Lb5yBOaqgpKuVBrRx69Ov564asTGG2TiarwhrLusZ/0ky/8sshyTy0
NdrUCCzbEJl955oDqbinbVfPZj6zns0lKFeZiEtNVfQ9NBRDhWkcqcr7EkCQ0Wnm
xucyzesO6XY5ViB5jy5f8TNdmZ/ziO5oBJOiXE9yHKi9X/ixo2bq3xJAqBaNt3+g
yaWDeLuWu4wSnIES4W7dqQmdubqFIGrOOn6NVHqBXe+Vv1imaL7h4PumcO1lHIxA
4ZwIx4wasd/O2LglavGf
=amIj
-----END PGP SIGNATURE-----

--Sig_/5O+aYlm=1mAzyMbqBYGBoKU--


--===============3211935967495183758==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3211935967495183758==--
