Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5167BsD111948 for <xfs@oss.sgi.com>; Fri, 1 Jun 2012 01:07:11 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id qxf4IzAD8QkPcj1z
	(version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 31 May 2012 23:07:09 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so3058791pbb.26
	for <xfs@oss.sgi.com>; Thu, 31 May 2012 23:07:08 -0700 (PDT)
Date: Fri, 1 Jun 2012 11:37:02 +0530
From: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Subject: Re:  Re: [PATCH] Printk for ENOSPC due to lack of inodes
Message-ID: <20120601060702.GA3975@Xye.local>
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
Content-Type: multipart/mixed; boundary="===============4018997048431665964=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com


--===============4018997048431665964==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,


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
Yeah, I would certainly send it as a patch. This was just for RFC. :)

>
>If you are changing logic or flow in addition to adding the messages, it s=
hould almost certainly be sent as more than one patch.
Thanks, I will make it so.
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

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJPyFwGAAoJEKYW3KHXK+l3dD8H/RmIxoSRLXIzdVKKhYKjsyvk
PQlQitMc+eHnkpQXiZwSQ5QbqrVdo2cT9uixK/BZjjcPm+RyWtIPOVsn+o0j65qK
e3fWLj+GYza7OGGfXQNpESiH/cJT6FiYCQ9dUKKvgJFyanXnYqSI+1jhYorry7HS
U2EzUZTegpp6f/kTowQTjJzyJ2yVoSXXAm9/8IukSkftOxK/tpsreqij4UQL3HFP
8iv9DEUeTHiAYTlefIE1OjysKzg7SQcpmKlcQOHOc80ck1KC+vGKWSZjB8OqHsX+
7rCbaNiE9Pnxb2ie0Mfdy6ltS/vyd2O01G/eANWxkxhBSrkZiTmdsdZAZuXTBas=
=LADF
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--


--===============4018997048431665964==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4018997048431665964==--
