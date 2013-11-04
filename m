Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 44E0F7F6B
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 09:06:02 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 318E28F8039
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 07:05:58 -0800 (PST)
Received: from kazi.fit.vutbr.cz (kazi.fit.vutbr.cz [147.229.8.12]) by
	cuda.sgi.com with ESMTP id h1jiGGrUxpktpMka (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 04 Nov 2013 07:05:56 -0800 (PST)
Date: Mon, 4 Nov 2013 16:05:49 +0100
From: Kasparek Tomas <kasparek@fit.vutbr.cz>
Subject: Re: How to use increased number of ACL entries?
Message-ID: <20131104150549.GQ9974@fit.vutbr.cz>
References: <20131103081704.GE9974@fit.vutbr.cz>
	<20131104003915.GN6188@dastard> <5277086E.6030905@sandeen.net>
	<52771FFE.8030009@gmail.com> <527723FC.1070401@oracle.com>
	<52773607.30506@gmail.com>
MIME-Version: 1.0
In-Reply-To: <52773607.30506@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3225477477966260735=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: Jeff Liu <jeff.liu@oracle.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com


--===============3225477477966260735==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H2kTGx6mr3R59oXC"
Content-Disposition: inline


--H2kTGx6mr3R59oXC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 04, 2013 at 12:52:07AM -0500, Michael L. Semon wrote:
> >>> but the 3.10.x kernel you're running will IIRC; use "-m crc=3D1" on t=
he mkfs.xfs
> >>> commandline from a git mkfs.xfs.

Did tried and ended with the same problem for filesystem mounting.
> >> root@bpserver:/storage/devel/git-xfsprogs# mkfs/mkfs.xfs -f -m crc=3D1=
 /dev/sdb3

> >> However, it should be dirent (ftype=3D1 in the above output) that keep=
s a=20
> >> vanilla 3.10.17 kernel from mounting the resulting filesystem:
> >>
> >> [438326.624667] XFS (sdb3): Version 5 superblock detected. This kernel=
 has EXPERIMENTAL support enabled!
> >> [438326.624667] Use of these features in this kernel is at your own ri=
sk!
> >> [438326.624762] XFS (sdb3): Superblock has unknown incompatible featur=
es (0x1) enabled.
> >> [438326.624762] Filesystem can not be safely mounted by this kernel.
> >=20
> > looks this problem is irrelevant to CRC check is enabled or not, and
> > Eric has fixed it:
> >=20
> > commit 31625f28ad7be67701dc4cefcf52087addd88af4
> >     xfs: don't emit corruption noise on fs probes

Will try this.

> >> I don't know if the CentOS kernel has any extra patches that would ena=
ble=20
> >> this filesystem to be mounted.
I use vanilla longterm 3.10.x, not CentOS kernel, that is too old for my
HW.

> >> There might be a way to bisect or revert the git xfsprogs back before =
dirent=20
> >> and giving that a try.  However, it seems best to start working with v=
5/CRC=20
> >> XFS starting with kernel 3.11.  If my luck with recent AIO commits was=
 better,=20
> >> I'd recommend 3.12 instead because that's the real correct answer, pro=
blems=20
> >> aside.

I have to use longterm kernel and 3.10.x is the latest available. As I have
seen the commit for more ACLs there, I expected it should be possible to
get it working for this version=20
(https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commi=
t/?id=3D0a8aa1939777dd114479677f0044652c1fd72398)

> That stated, I found some time to revert the git xfsprogs, and there was
> success in making more than 25 ACLs on vanilla kernel 3.10.17.  Again,
> this is not recommended--the later kernel and userspace patches are there
> for good reason--but the output is pasted after my closing.

I will repeat your directions and test it. However, if you as XFS devels do
not see these to be stable enough to be used in production environment, I
may still revert to some other solution (unix groups) even if these are a
night mare to administer for my situation.

Thanks for all the info and advices.

Regards

--=20

  Tomas Kasparek               E-mail: kasparek@fit.vutbr.cz
  CVT FIT VUT Brno, L127       Web:    http://www.fit.vutbr.cz/~kasparek
  Bozetechova 1, 612 66        Fax:    +420 54114-1270
  Brno, Czech Republic         Phone:  +420 54114-1220

  jabber: tomas.kasparek@jabber.cz
  GPG:    2F1E 1AAF FD3B CFA3 1537  63BD DCBE 18FF A035 53BC

  May the command line live forever!

--H2kTGx6mr3R59oXC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (FreeBSD)

iEYEARECAAYFAlJ3t80ACgkQFiofPpFRnYiXwACgmulVLUc2z6ngGM6NQQWtwmGk
U1IAn16MzlXZFGXqVivin1ry06NHuiog
=g7Mt
-----END PGP SIGNATURE-----

--H2kTGx6mr3R59oXC--


--===============3225477477966260735==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3225477477966260735==--
