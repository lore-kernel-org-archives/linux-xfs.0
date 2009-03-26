Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2QGabmv176818 for <xfs@oss.sgi.com>; Thu, 26 Mar 2009 11:36:47 -0500
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E8431C7BFB
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2009 09:36:10 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id 6HYxZC4P5RtBoGPY for
	<xfs@oss.sgi.com>; Thu, 26 Mar 2009 09:36:10 -0700 (PDT)
Received: from shambhala.lichtvoll.home
	(DSL01.212.114.230.144.ip-pool.NEFkom.net [212.114.230.144])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id CC0815ADB7
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2009 17:36:09 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: accidentally deleted very large file (3.5TB) but still available
	through loop device
Date: Thu, 26 Mar 2009 17:36:52 +0100
References: <49CBA221.2090701@cjx.com> (sfid-20090326_172934_176693_DA0712EB)
	(sfid-20090326_172934_176693_DA0712EB)
	(sfid-20090326_172934_176693_DA0712EB)
In-Reply-To: <49CBA221.2090701@cjx.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903261736.53093.Martin@lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Am Donnerstag 26 M=E4rz 2009 schrieb Chris Allen:
> Hi,

Hi Chris,

> In a nutshell, I did the following:
>
> 1. dd if=3Dsome_filesystem_dump of=3Dsome_file (where some_file resides on
> an XFS filesystem and is 3.5TB large)
>
> 2. losetup /dev/loop0 some_file
>
> 3. mount /dev/loop0 /recovered
>
> [.... i can now access my recovered filesystem through /recovered ...]
>
> 4. rm some_file (remotely via an nfs export) (oops!)
>
> So, I just removed my 3.5TB file even though it is attached to the loop
> device and mounted (XFS did this almost instantly).
>
>
> Now it *appears* that the filesystem as attached to /dev/loop0 and
> mounted on /recovered is still OK. I
> can cd around it and copy files off.
>
> So I have these questions:
>
>
> 1. Is there any way I can get back the 1 file that I accidentally
> deleted (nothing else has been written to that partition since)

dd if=3D/dev/loop0 of=3Dsomefile-restore

should work IMHO.

> 2. Am I safe in accessing my filesystem through /dev/loop0 and
> /recovered even though the underlying file has been zapped? If so
> I can quickly copy everything off onto another partition.

Yes. XFS as other linux filesystems perform the real delete - i.e. freeing =

the blocks the file occupies - only after the last user of it has closed =

it. Before just the directory entry of the file is removed.

> 3. Will this command: dd if=3D/dev/loop0 of=3Dsaved_file get my file back?

I think it will. Just try it.

Ciao,
-- =

Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
