Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q09HeXg1028685 for <xfs@oss.sgi.com>; Mon, 9 Jan 2012 11:40:33 -0600
Received: from mail-lpp01m010-f53.google.com (mail-lpp01m010-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id svbcLCGOyJCSFSed
	for <xfs@oss.sgi.com>; Mon, 09 Jan 2012 09:40:31 -0800 (PST)
Received: by lagr15 with SMTP id r15so1867947lag.26
	for <xfs@oss.sgi.com>; Mon, 09 Jan 2012 09:40:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANBXnM=Ec4zp-5AR3JY00taUR+W-G6+ZKJKhDj94uhpeVsp2tw@mail.gmail.com>
References: <CANBXnM=Ec4zp-5AR3JY00taUR+W-G6+ZKJKhDj94uhpeVsp2tw@mail.gmail.com>
Date: Mon, 9 Jan 2012 23:10:30 +0530
Message-ID: <CADDb1s38ts-NAhzqyt2ZiN8m6mBVzS97uACb0XVKEKrKmV=YJA@mail.gmail.com>
Subject: Re: Cyclic Code?
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Adil Mujeeb <mujeeb.adil@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 9, 2012 at 12:22 PM, Adil Mujeeb <mujeeb.adil@gmail.com> wrote:
> Hi list,
>
> i am new to XFS.
>
> I was going through XFS code (2.4 based) for study purpose. Its old but
> assuming its bit simple as compare to latest one. Moreover the XFS code /
> design structure documents available on the internet is 2.4 based.
May be if you switch to a version around 2.6.20 nearabout - it will
make it easier to understand the code. Prior to that the complete XFS
source code seemed like traversing through a lot of macros... I
started with 2.6.18 and it was really hard to understand from that
version...
>
> The following code snippet is not clear to me (seems cyclic):
>
> ---------
> ...
> ...
> #define XFS_IFORK_NEXTENTS(ip,w) =A0 =A0 =A0 =A0xfs_ifork_nextents(ip,w)
> ...
> xfs_ifork_nextents(xfs_inode_t *ip, int w)
> {
> =A0=A0 =A0 =A0 =A0return XFS_IFORK_NEXTENTS(ip, w);
> }
I guess you missed something while reading the code.... I tried to
look at the repositry.. this is how the code looks...
#if XFS_WANT_FUNCS || (XFS_WANT_SPACE && XFSSO_XFS_IFORK_NEXTENTS)	=

 int xfs_ifork_nextents(xfs_inode_t *ip, int w);	=

 #define XFS_IFORK_NEXTENTS(ip,w)        xfs_ifork_nextents(ip,w)	=

 #else	=

 #define XFS_IFORK_NEXTENTS(ip,w)        XFS_CFORK_NEXTENTS(&ip->i_d, w)	=

 #endif
....
#define XFS_CFORK_NEXTENTS(dcp,w) \
	((w) =3D=3D XFS_DATA_FORK ? (dcp)->di_nextents : (dcp)->di_anextents)

Regards,
Amit Sahrawat
> ...
> ...
> #define XFS_IFORK_NEXTENTS(ip,w) =A0 =A0 =A0 =A0XFS_CFORK_NEXTENTS(&ip->i=
_d, w)
> ...
> #define XFS_CFORK_NEXTENTS(dcp,w) =A0 =A0 =A0 =A0 =A0 =A0xfs_cfork_nexten=
ts(dcp,w)
> ...
> int
> xfs_cfork_nextents(xfs_dinode_core_t *dcp, int w)
> {
> =A0=A0 =A0 =A0 =A0return XFS_CFORK_NEXTENTS(dcp, w);
> }
> ----
>
> Am i missing something?
> Thanks,
> Adil
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
