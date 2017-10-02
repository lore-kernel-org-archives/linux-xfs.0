Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:51288 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751128AbdJBNtl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Oct 2017 09:49:41 -0400
Received: by mail-qt0-f177.google.com with SMTP id q4so7274916qtq.8
        for <linux-xfs@vger.kernel.org>; Mon, 02 Oct 2017 06:49:41 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: Suggested XFS setup/options for 10TB file system w/ 18-20M files.
From: "R. Jason Adams" <rjasonadams@gmail.com>
In-Reply-To: <fb88053a-873d-92f9-198d-ee8d4f841658@sandeen.net>
Date: Mon, 2 Oct 2017 09:49:39 -0400
Content-Transfer-Encoding: quoted-printable
Message-Id: <8066DE0B-5CC2-4B64-ACC1-4EA1462B450A@gmail.com>
References: <65736D53-5B93-46DD-95D2-02496B59D09C@gmail.com>
 <fb88053a-873d-92f9-198d-ee8d4f841658@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

> On what version of kernel & what version of xfsprogs?

We=E2=80=99re on CentOS 7:=20

3.10.0-693.2.2.el7.x86_64
xfsprogs.x86_64  4.5.0-12.el7


>> The application opens the file, writes the data (single call), and =
closes the file. In addition there are a few lines added to the extended =
attributes. The filesystem ends up with 18 to 20 million files when the =
drive is full. The files are currently spread over 128x128 directories =
using a hash of the filename.
>=20
> It's not uncommon for application filename hashing like this to be =
less efficient than the internal xfs directory algorithms, FWIW.

Good to know. We originally had 256x256 and changed to 128x128 to see if =
it would help. I figured 18M files in 1 directory wasn=E2=80=99t ideal =
though.


>> The format command I'm using:
>>=20
>> mkfs.xfs -f -i size=3D1024 ${DRIVE}
>=20
> Why 1k inodes?

Our extended attributes average ~200B .. figured a little extra room =
wouldn=E2=80=99t hurt?

Example:

getfattr -d 3c75666a3279623367406b79633479346c777a2e6c706f7471696e3e

# file: 3c75666a3279623367406b79633479346c777a2e6c706f7471696e3e
user.offset=3D"682"
user.crc=3D"1911595230"
user.date=3D"1506918540"
user.id=3D"f97800a5-66cd-4cb1-9a95-796ae0e8871e"
user.inserted=3D"1506918595"
user.size=3D"793169"


>> Mount options:
>>=20
>> =
rw,noatime,attr2,inode64,allocsize=3D2048k,logbufs=3D8,logbsize=3D256k,noq=
uota
>=20
> Why all these options?

Started with defaults.. started adding options trying to resolve the =
issue ;)


> Perhaps it's taking time reading through a large custom-hashed =
directory tree?  I don't know what that custom directory layout might =
look like.

It=E2=80=99s currently 128 dirs, each with 128 in them.


> Have you tried starting with defaults, and working your way up from =
there (if needed?)

Yep. I=E2=80=99m so used to XFS =E2=80=9Cjust working=E2=80=9D that I =
started trying a lot of options after searching for solutions. Lots of =
suggestions out there. ;)

-R. Jason Adams

