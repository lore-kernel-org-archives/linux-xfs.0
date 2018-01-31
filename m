Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:40551 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751625AbeAaUHv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jan 2018 15:07:51 -0500
Received: by mail-it0-f45.google.com with SMTP id 196so1025764iti.5
        for <linux-xfs@vger.kernel.org>; Wed, 31 Jan 2018 12:07:51 -0800 (PST)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <1F1EB539-22C2-4060-AE87-9F9A77F8A015@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_AE1028AD-609E-4E43-91F3-1EAEA4C665EA";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] Parent pointer future use cases
Date: Wed, 31 Jan 2018 13:07:44 -0700
In-Reply-To: <588cad68-78eb-88de-49c3-716330b70cd5@oracle.com>
References: <588cad68-78eb-88de-49c3-716330b70cd5@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>


--Apple-Mail=_AE1028AD-609E-4E43-91F3-1EAEA4C665EA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jan 30, 2018, at 8:56 PM, Allison Henderson =
<allison.henderson@oracle.com> wrote:
>=20
> Hi everyone!
>=20
> Recently I have been working towards adding a new parent pointer patch =
set to xfs.  Briefly summarized, goal of the feature is to enable an =
application to quickly derive an inodes path from the mount point by =
storing information about the inodes parent(s) in an extended attribute. =
 Currently, I am aware of the intent to use the feature as part of an =
online scrub and repair feature.  Looking forward however, I would like =
to know about any other future coding intents that might make use of =
this feature.  For example, optimizing file system shrink or exportfs =
operations?  Are there certain interfaces or test cases that would be =
helpful to have?  I know the patch set has had a complicated history, so =
ideally being aware of how folks may go about using it may help to =
construct test cases to route out flaws sooner rather than later.

We have reverse inode->parent pointers in Lustre already, with a list of
{parent,name} tuples stored in a "link" xattr.  There is a userspace =
command
"lfs fid2path /mountpoint [FID]" that spits out a list of pathnames for =
a
filename relative to /mountpoint when the FID (inode number) is given.

Parent directory links are useful in several areas:
- better reporting in error messages (filename instead of inode number)
- generate pathnames for a hard-linked file for regular users, or tools =
like
  migration/rsync/tar so that they don't need to reverse engineer hard =
links
  by scanning the whole filesystem looking for matching inode numbers
- directory reconstruction in fsck, since each inode can use the xattr =
data
  re-attach itself to the namespace, including the directories =
themselves
  which contain a "link" xattr with their own name in the ".." directory
- being able to generate open file listings on the server from a list of
  FIDs (this is probably not useful for local filesystems)

Cheers, Andreas






--Apple-Mail=_AE1028AD-609E-4E43-91F3-1EAEA4C665EA
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlpyIhAACgkQcqXauRfM
H+DhdQ//YYB2O+6NbJPiRmkchtpglSH3HfmMLqVNwlL9+u94AALLukexHE8tUiAQ
cOHz+y/wFsqf4RYWO/4Bw9toQpI3G4tSV9ayknwcXXb4vlA2nfiwRkIke7UiBN1h
ppjVwg8TqK8P8kqDD1OPwgoBqySuZsbqhga3LXkBEbLnuw1fEngaeMY56R76hl7w
ZnDc1WYdgfeOzfbYURaroWM+y5JDHkLO7HfkMGiGEtz3puqEQmawCJ9myJel5Tbg
vbYzVwr9+Bzr0+eh9kbe3ZK1Q6h1GEDr7LlzTBVRdRRUiVKuis7r+i8ogcoMo0t5
zed9gXkSUe0BUuD0r1vyh/SXteFCyk3DuNpALGYWeQdUbZ/Gj4luFgNKLAY4JME5
+CR0UcKwFWU0n4ESzMX2+Z5NlFkCfbfPaWqQzcoBqCGWekv09BIwNCDZdZ19inU9
j6og9DC5OFVnCquzdhRv9WHZdkzojdKQBnA+RxTYe7Yl1bmwjDUxaSrvlcONviBE
4LiLTrIpb90LdcC6ZbL+0GLq9QjYHVNvgMrgoPPg1TUl0WG7h9Fc0lOi3Gy/pz3z
1zqSjZGrmzduhXw+klFB+isMpa06l9qFak+DnWXTyuUxlbBXrJaAMcI6wAGr+pn4
iN0p3wOoEDKmHUU0hwMXw2ToP89hJuck1fhHVitvtQQvRUh9lw0=
=gdrC
-----END PGP SIGNATURE-----

--Apple-Mail=_AE1028AD-609E-4E43-91F3-1EAEA4C665EA--
