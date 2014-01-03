Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 64F8C7F3F
	for <xfs@oss.sgi.com>; Fri,  3 Jan 2014 12:29:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4C67C8F8033
	for <xfs@oss.sgi.com>; Fri,  3 Jan 2014 10:29:46 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id h6Ghgozub2hHdI9B for <xfs@oss.sgi.com>;
	Fri, 03 Jan 2014 10:29:44 -0800 (PST)
Message-ID: <52C70198.6090106@sandeen.net>
Date: Fri, 03 Jan 2014 12:29:44 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Bug - xfs_repair asks me to report it
References: <7ED0247242FEFB40BCA665733E613DCA0640C14C985D@V4SERVER.v4.local>
In-Reply-To: <7ED0247242FEFB40BCA665733E613DCA0640C14C985D@V4SERVER.v4.local>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: =?ISO-8859-1?Q?Bj=F6rn_Rafreider?= <bjoern_rafreider@visual4.de>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 12/27/13, 6:42 AM, Bj=F6rn Rafreider wrote:
> Hi,
> over christmas our backup system with XFS on LVM2 on iSCSI on Ubuntu 12.0=
4.03 gave me several errors. Turned out, that the XFS was halted because of=
 an error. XFS_repair fixed several errors but finally quit with the follow=
ing error message:
> =

> corrupt dinode 3328159430, extent total =3D 1, nblocks =3D 0.  This is a =
bug.
> Please capture the filesystem metadata with xfs_metadump and
> report it to xfs@oss.sgi.com.
> cache_node_purge: refcount was 1, not zero (node=3D0x1b928ab0)
> =

> fatal error -- couldn't map inode 3328159430, err =3D 117
> =

> the dump is running at the moment - but it already has 5G - little too bi=
g for sending it by mail so I add a little more information

the metadump should compress quite well, for what it's worth.  Can you try?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
