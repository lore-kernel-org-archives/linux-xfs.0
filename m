Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2UIKNYZ208512 for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 13:20:33 -0500
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5411A1C7FE08
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 11:19:37 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id wdy4LjSIu707SRyZ for
	<xfs@oss.sgi.com>; Mon, 30 Mar 2009 11:19:37 -0700 (PDT)
Received: from shambhala.lichtvoll.home
	(DSL01.212.114.235.145.ip-pool.NEFkom.net [212.114.235.145])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 5A34A5ADF6
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 20:19:36 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Corruption of in-memory data
Date: Mon, 30 Mar 2009 20:20:18 +0200
References: <49CD2EF0.9060009@blackopscode.com>
	(sfid-20090328_131214_312532_57B5FB47)
In-Reply-To: <49CD2EF0.9060009@blackopscode.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903302020.19511.Martin@lichtvoll.de>
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
To: xfs@oss.sgi.com

Am Freitag 27 M=E4rz 2009 schrieb Florian Hines:
> Hey everybody,

Hi,

> Over the last few day's I've been getting a rash (8 so far) of disk's
> throwing the error "Filesystem "sdxX": Corruption of in-memory data
> detected.  Shutting down filesystem: sdxX".  xfs_check never seem's to
> find anything and just unmounting and remounting solves the issue at
> least for awhile.   Is this usually caused by bad ram ?  It's happened
> on 6 systems so far (all using Debian Etch AMD64 with the stock 2.6.18
> kernel, each system as a 5 sata drives, not raided).
>
> Can anyone shed some light on what this error actually indicates for me
>  ?
>
> --Full error from dmesg below--
>  Filesystem "sda3": XFS internal error xfs_trans_cancel at line 1138 of
> file fs/xfs/xfs_trans.c.  Caller 0xffffffff8818ead5
>
> Call Trace:
>  [<ffffffff8818fdd0>] :xfs:xfs_trans_cancel+0x5b/0xfe
>  [<ffffffff8818ead5>] :xfs:xfs_rename+0xa13/0xa9a
>  [<ffffffff881a0aac>] :xfs:xfs_vn_rename+0x2c/0x6f
>  [<ffffffff80220104>] __up_read+0x13/0x8a
>  [<ffffffff8817c732>] :xfs:xfs_iunlock+0x57/0x79
>  [<ffffffff80220104>] __up_read+0x13/0x8a
>  [<ffffffff8817c732>] :xfs:xfs_iunlock+0x57/0x79
>  [<ffffffff88195286>] :xfs:xfs_access+0x3d/0x46
>  [<ffffffff80228cc4>] vfs_rename+0x2d5/0x426
>  [<ffffffff802344fb>] sys_renameat+0x180/0x1f9
>  [<ffffffff80221605>] sys_newstat+0x28/0x31
>  [<ffffffff80257c16>] system_call+0x7e/0x83
>
> xfs_force_shutdown(sda3,0x8) called from line 1139 of file
> fs/xfs/xfs_trans.c.  Return address =3D 0xffffffff8818fdee
> Filesystem "sda3": Corruption of in-memory data detected.  Shutting
> down filesystem: sda3

Well we had "Corruption of in-memory data detected" errors with Debian AMD =

64 and the 2.6.22 backports.org kernel. They went away after we upgraded =

to 2.6.26 backports.org kernel. Don't remember the trace tough anymore. I =

posted it on the mailinglist... I think not a long time ago.

Well here is:

Is it possible the check an frozen XFS filesytem to avoid downtime? =

2008-07-14 (was longer ago than I expected ;).

http://oss.sgi.com/archives/xfs/2008-07/msg01475.html

Backtrace look different, but that doesn't have to mean much. =


I would try a newer kernel!

I also recommend having a newer version of xfsprogs at hand in case of =

problems. The one in Etch is completely out-dated. I have made a backport =

back then which is still quite recent:

http://people.teamix.net/~ms/debian/etch-backports/xfsprogs/

Ciao,
-- =

Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
