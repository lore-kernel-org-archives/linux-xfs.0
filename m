Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q556kLMQ052526 for <xfs@oss.sgi.com>; Tue, 5 Jun 2012 01:46:21 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id VB8YZsoFXy5TbLfI
	(version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Jun 2012 23:46:20 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so8869640pbb.26
	for <xfs@oss.sgi.com>; Mon, 04 Jun 2012 23:46:19 -0700 (PDT)
Date: Tue, 5 Jun 2012 12:16:14 +0530
From: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Subject: Re:  Re: [PATCH] Printk for ENOSPC due to lack of inodes
Message-ID: <20120605064614.GB1758@Xye.local>
References: <20120227003733.GA28162@Xye> <4F579D4C.4040208@sandeen.net>
	<20120531193616.GA3953@Xye.local> <4FC83789.8010900@sandeen.net>
MIME-Version: 1.0
In-Reply-To: <4FC83789.8010900@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8192344647022544872=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com


--===============8192344647022544872==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z6Eq5LdranGa6ru8"
Content-Disposition: inline


--z6Eq5LdranGa6ru8
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Thanks for reviewing earlier.

I have sent the patch series here from: http://oss.sgi.com/archives/xfs/201=
2-06/msg00020.html to http://oss.sgi.com/archives/xfs/2012-06/msg00023.html


* On Thu, May 31, 2012 at 10:31:21PM -0500, Eric Sandeen <sandeen@sandeen.n=
et> wrote:
>On 5/31/12 2:36 PM, Raghavendra D Prabhu wrote:
>> Hi,
>>
>> Thanks for the review. I have now moved it inside xfs_dialloc. Along wit=
h adding the message, I noticed that the loop
>>
>>     while (!agi->agi_freecount) {
>>     }
>>
>> is redundant when noroom=3D1 and okalloc=3D0.
>>
>> Also, xfs_ialloc_ag_alloc function in the loop calls
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>     if (mp->m_maxicount &&
>>         mp->m_sb.sb_icount + XFS_IALLOC_INODES(mp) > mp->m_maxicount) {
>>
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>> condition again.
>>
>> So I have moved xfs_tran_brelse etc. into the condition along with messa=
ge.
>>
>> Is this logic valid? If it is, then I will look into rate-limiting the m=
essage etc.
>
>It'd be easiest to understand this new change as a patch rather than as a =
description.
>
>If you are changing logic or flow in addition to adding the messages, it s=
hould almost certainly be sent as more than one patch.
>
>Thanks,
>
>-eric
>
>_______________________________________________
>xfs mailing list
>xfs@oss.sgi.com
>http://oss.sgi.com/mailman/listinfo/xfs
>




Regards,
--=20
Raghavendra Prabhu
GPG Id : 0xD72BE977
Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
www: wnohang.net

--z6Eq5LdranGa6ru8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJPzas2AAoJEKYW3KHXK+l3mRIIAMBSUuLk+2oyRvlFsKhkFZ0N
asuonOrTTTZ0BD/hR9IQ+/D1cx+uhWEncrAK4Nv9DlDuweaDeLlGppjdJApK0KqV
N+RL3NLjW4OSBF/NrxFiIkuvSM2drEpKbvQmj8YwRoUPVzwE6lhj/qgH23sTLn2U
dqhO4HqhCbavXBqUP0WHFMhWyO9EmEivOBGsCPZWkX5sU9tGDm0boLkTE5L6Lhn4
wCJJTi9qcATn7kXsvz/9XZPiEqA28XZyzWQoBNKINQ60sDNyOAMHAy/7VLBEoD3V
wlZwiR1UDkq4z9MMyOz4Q0+Nnq3Qessfocl5uF2Ysz53wjMbH8RdmXChCQT+XZU=
=1Bml
-----END PGP SIGNATURE-----

--z6Eq5LdranGa6ru8--


--===============8192344647022544872==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8192344647022544872==--
