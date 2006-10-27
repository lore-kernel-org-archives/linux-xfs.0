Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Oct 2006 10:31:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9RHVbaG028546
	for <xfs@oss.sgi.com>; Fri, 27 Oct 2006 10:31:39 -0700
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com [208.42.117.202])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F652D1AD03B
	for <xfs@oss.sgi.com>; Fri, 27 Oct 2006 10:30:50 -0700 (PDT)
Subject: Re: Kernel Oops
From: Russell Cattelan <cattelan@thebarn.com>
In-Reply-To: <4541CA71.5040909@ac-dijon.fr>
References: <4541CA71.5040909@ac-dijon.fr>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-m2jOD/3i8tkygx1fouoq"
Date: Fri, 27 Oct 2006 12:30:29 -0500
Message-Id: <1161970230.26171.15.camel@xenon.msp.redhat.com>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?ISO-8859-1?Q?Jo=EBl?= Cuissinat <joel.cuissinat@ac-dijon.fr>
Cc: xfs@oss.sgi.com

--=-m2jOD/3i8tkygx1fouoq
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Do you have a test case that can reproduce this?

If so please file a bug
http://oss.sgi.com/bugzilla
and attach the test program.

Include any other relevant info.



On Fri, 2006-10-27 at 10:59 +0200, Jo=C3=ABl Cuissinat wrote:
> Hello,
>=20
> I'm working for the french national education.
> We work on a server for students since 3 years.
> The solution is based on a Mandrake 9.1 but with a large number of update=
s.
> Our kernel is : 2.4.32 and the xfstools are updated :
> - xfsdump-2.2.42
> - xfsprogs-2.8.11
> - libxfs1-2.8.11
> We made a tool  to create students and about 1 time over 10 we have a=20
> kernel Oops.
> With the same data we can reproduce the crash and it always append at=20
> the same place (the same student).
> It was the same 2 years ago with older kernel and xfs releases but we=20
> hadn't enough student databases to test.  Now, the project is growing=20
> and the number of crashes in schools too !
>=20
> The user creation process is composed with :
> mkdir, setfacl, chown, setquota for a pam-ldap authentification.
>=20
> The Oops usually happends on the chown instruction but if we remove it,=
=20
> it happends on the setquota instruction which is one line behind.
>=20
> Cheers,
>=20
> Jo=C3=ABl Cuissinat
>=20
> plain text document attachment (ksymoops.txt)
> Oct 25 18:17:52 jscribe kernel: Unable to handle kernel NULL pointer dere=
ference at virtual address 00000006                                        =
       Oct 25 18:17:52 jscribe kernel:  printing eip:
> Oct 25 18:17:52 jscribe kernel: c021de83                                 =
                                                                           =
       Oct 25 18:17:52 jscribe kernel: *pgd =3D 0000000000000000
> Oct 25 18:17:52 jscribe kernel: CPU:    0                                =
                                                                           =
       Oct 25 18:17:52 jscribe kernel: EIP:    0010:[xfs_trans_brelse+51/24=
0]    Not tainted
> Oct 25 18:17:52 jscribe kernel: EIP:    0010:[<c021de83>]    Not tainted =
                                                                           =
       Oct 25 18:17:52 jscribe kernel: EFLAGS: 00010246
> Using defaults from ksymoops -t elf32-i386 -a i386
> Oct 25 18:17:52 jscribe kernel: eax: 00000000   ebx: c59ed790   ecx: c59e=
d790   edx: 00000000                                                       =
       Oct 25 18:17:52 jscribe kernel: esi: c5352e98   edi: ce520d80   ebp:=
 ce520d80   esp: c6b97d2c
> Warning (Oops_set_regs): garbage 'Oct 25 18:17:52 jscribe kernel: esi: c5=
352e98   edi: ce520d80   ebp: ce520d80   esp: c6b97d2c' at end of register =
line ignored
> Oct 25 18:17:52 jscribe kernel: ds: 0018   es: 0018   ss: 0018           =
                                                                           =
       Oct 25 18:17:52 jscribe kernel: Process chown (pid: 15389, stackpage=
=3Dc6b97000)
> Oct 25 18:17:52 jscribe kernel: Stack: 00000000 00000000 c5352e98 c0235f2=
c c5352e98 ce520d80 00000000 c5d7f198                                      =
       Oct 25 18:17:52 jscribe kernel:        ce520d80 00000000 c5352e98 cf=
f310a0 00000004 c0235fbf c5352e98 0000302d
> Oct 25 18:17:52 jscribe kernel:        cff310a0 00000402 cf8b0980 cf8b098=
4 0000302d cf8b0c00 c023621a cf8b0c00                                      =
       Oct 25 18:17:52 jscribe kernel: Call Trace:    [xfs_qm_dqread+188/20=
8] [xfs_qm_idtodq+127/224] [xfs_qm_dqget+218/848] [xfs_qm_vop_dqalloc+245/6=
24] [xfs_set
> Oct 25 18:17:52 jscribe kernel:   [<c01d6d28>] [<c022d7f7>] [<c017f678>] =
[<c0165a11>] [<c0165a9e>] [<c012bf13>]                                     =
       Oct 25 18:17:52 jscribe kernel:
> Oct 25 18:17:52 jscribe kernel: Code: 8a 42 06 83 e0 01 84 c0 75 f2 f6 43=
 30 04 75 ec 52 56 e8 a6
>=20
>                                                                          =
                                                                           =
       >>EIP; c021de83 <xfs_trans_brelse+33/f0>   <=3D=3D=3D=3D=3D
>=20
> >>ebx; c59ed790 <_end+556a7ec/103890bc>                                  =
                                                                           =
       >>ecx; c59ed790 <_end+556a7ec/103890bc>
>                                                                          =
                                                                           =
       Code;  c021de83 <xfs_trans_brelse+33/f0>
> 00000000 <_EIP>:                                                         =
                                                                           =
       Code;  c021de83 <xfs_trans_brelse+33/f0>   <=3D=3D=3D=3D=3D
>    0:   8a 42 06                  mov    0x6(%edx),%al   <=3D=3D=3D=3D=3D=
                                                                           =
                 Code;  c021de86 <xfs_trans_brelse+36/f0>
>    3:   83 e0 01                  and    $0x1,%eax                       =
                                                                           =
       Code;  c021de89 <xfs_trans_brelse+39/f0>
>    6:   84 c0                     test   %al,%al
> Code;  c021de8b <xfs_trans_brelse+3b/f0>
>    8:   75 f2                     jne    fffffffc <_EIP+0xfffffffc>
> Code;  c021de8d <xfs_trans_brelse+3d/f0>
>    a:   f6 43 30 04               testb  $0x4,0x30(%ebx)
> Code;  c021de91 <xfs_trans_brelse+41/f0>
>    e:   75 ec                     jne    fffffffc <_EIP+0xfffffffc>
> Code;  c021de93 <xfs_trans_brelse+43/f0>
>   10:   52                        push   %edx
> Code;  c021de94 <xfs_trans_brelse+44/f0>
>   11:   56                        push   %esi
> Code;  c021de95 <xfs_trans_brelse+45/f0>
>   12:   e8 a6 00 00 00            call   bd <_EIP+0xbd>
>=20
>=20
> 2 warnings and 1 error issued.  Results may not be reliable.
>=20
--=20
Russell Cattelan <cattelan@thebarn.com>

--=-m2jOD/3i8tkygx1fouoq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFQkI1NRmM+OaGhBgRApJSAJwOEeoPA40YIM2ClV66KVLpaRFrIgCeIZ3G
0EYbftqQ+nc04p1RyvpnQXI=
=Ah+g
-----END PGP SIGNATURE-----

--=-m2jOD/3i8tkygx1fouoq--
