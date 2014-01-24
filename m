Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 276A07FEB
	for <xfs@oss.sgi.com>; Fri, 24 Jan 2014 02:08:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E28B88F8052
	for <xfs@oss.sgi.com>; Fri, 24 Jan 2014 00:08:37 -0800 (PST)
Received: from zmail.inovex.de (zmail.inovex.de [85.115.6.137]) by
	cuda.sgi.com with ESMTP id 6eWGUf3GfpCsOydR for
	<xfs@oss.sgi.com>; Fri, 24 Jan 2014 00:08:33 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: Weird XFS Corruption Error
From: Sascha Askani <saskani@inovex.de>
In-Reply-To: <20140123151943.281baa04@harpe.intellique.com>
Date: Fri, 24 Jan 2014 09:08:32 +0100
Message-Id: <0EB19DE2-2DB4-426E-B050-1C633B2BD8F6@inovex.de>
References: <CDBC891F-BCF6-4B9B-ADDB-9E143973D188@inovex.de>
	<20140123151943.281baa04@harpe.intellique.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8604896320133601276=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com


--===============8604896320133601276==
Content-Type: multipart/signed; boundary="Apple-Mail=_6F709BC1-5E0D-4C49-9CD5-AA97F617DC76"; protocol="application/pgp-signature"; micalg=pgp-sha512


--Apple-Mail=_6F709BC1-5E0D-4C49-9CD5-AA97F617DC76
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

Hi Emmanuel,

thanks for your reply, sorry for the delayed answer...

Am 23.01.2014 um 15:19 schrieb Emmanuel Florac <eflorac@intellique.com>:

> Le Wed, 22 Jan 2014 17:09:10 +0100
> Sascha Askani <saskani@inovex.de> =E9crivait:
>=20
>> Internal error xfs_bmbt_read_verify at line 789=20
> ...
>> metadata I/O error: block 0x1f0 ("xfs_trans_read_buf_map") error 117
>> numblks 8
>=20
>=20
> A quick glance at the source code seems to indicate that there was an
> actual CRC error (on disk) at this point, so that could be a RAID
> problem;

(Un)fortunately, I don=92t see any kind of controller errors, but I =
definitely second your opinion

>=20
> OTOH it looks really similar to an older bug :
>=20
> http://oss.sgi.com/archives/xfs/2013-02/msg00482.html
>=20
> AFAIK this one could be related to the current Ubuntu LTS lvm stack...
> We need Dave's advice on this one.
>=20
> Was there nothing in the xfs_repair output? nothing in lost+found
> either?

xfs_repair output (which I unfortunately do not have) was sparse =
(ignoring the many dots it printed after having failed to find the =
primary superblock), basically it removed invalid references. lost+found =
contains 1 directory (which is empty)

As for the bug you referenced above: Yes, it looks similar, but we have =
no pvmove going on anywhere at any time, but I=92ll see if I can try to =
reproduce the error with the many files (kernel source) as described in =
the bug.

For reference, the LVM versions currently in use:

root@hsoi-gts3-de02:/# lvdisplay --version
  LVM version:     2.02.66(2) (2010-05-20)
  Library version: 1.02.48 (2010-05-20)
  Driver version:  4.25.0


Thanks so far :)

Best regards,

Sascha=20

--Apple-Mail=_6F709BC1-5E0D-4C49-9CD5-AA97F617DC76
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQGcBAEBCgAGBQJS4h+AAAoJEPgp1oARaIvklo0MAMndaOO+l/yW5EGfMQQQptjp
5cjHufj/DAQSowNb1FKmHoxO32S5PqgBjkRkKGEkNWRhtHVmmseOZRHEBMCr0SIM
uDYEsxoZ4efJXLJmL1UA3rzXtfoV5tQGd2synyECUd8wxCL8Vh2GDRUsruESYsrV
L1roD33ueBy7I3R7lgzQUv+a8+sJksUR1ujnDto1EOlK5WQx4XrBGXeQzXzYLgbV
4QohvYSVeRtd9fKCsiAG62mEdXPPfLMINroSMpIdZ+MxZG25KNKJd3P//Xv+MVPW
SPYo29qLE8gWutVbiAA+tm3UsCOfSmVfk5MjutrR69rAdtFL7NvTt2ytVlFIm3pC
Zqx7j8tUKN0anQQvEW7g6Q0Z6qvPfJHUdxGJIB/A4Q2WifFm4DWZWcM5JCgxkzB/
1tw0I19q2280wTRKWIuSPZzA7ErX1RA1uaVq9yN+iA8oEUgtjFsdT9U19u6jFqu/
QPyVV73ZiBl4SlLuHHTFzgEr75mLE+qFK+WT48EqXg==
=9BqX
-----END PGP SIGNATURE-----

--Apple-Mail=_6F709BC1-5E0D-4C49-9CD5-AA97F617DC76--


--===============8604896320133601276==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8604896320133601276==--
