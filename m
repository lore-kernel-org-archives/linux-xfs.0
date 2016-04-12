Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B4DE57CA3
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 03:56:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7932D304039
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 01:56:32 -0700 (PDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com
	[74.125.82.46]) by cuda.sgi.com with ESMTP id hvLY2So6VJaGnPG5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2016 01:56:29 -0700 (PDT)
Received: by mail-wm0-f46.google.com with SMTP id a140so44493210wma.0
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 01:56:29 -0700 (PDT)
Message-ID: <B0489CAC12794260BF90FA4C421620CA@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
Subject: RE: [PATCH 4/5] xfs: xfs_inode_free() isn't RCU safe
Date: Tue, 12 Apr 2016 11:55:41 +0300
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2020970989843193602=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: bbice@sgi.com

This is a multi-part message in MIME format.

--===============2020970989843193602==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0041_01D194B2.3CBE5090"

This is a multi-part message in MIME format.

------=_NextPart_000_0041_01D194B2.3CBE5090
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Dave,

Looking at the patch, I see that now we call xfs_idestroy_fork() in RCU =
callback. This can do the following chain:

xfs_iext_destroy =3D> xfs_iext_irec_remove =3D> =
xfs_iext_realloc_indirect=3D> kmem_realloc =3D> kmem_alloc =3D> =
kmem_alloc =3D> congestion_wait()

At least according to documentation, the RCU callback cannot block, =
since it may be called from softirq context. Is this fine?

Thanks,
Alex.

P.S.: I have submitted a patch called =E2=80=9C[PATCH] xfs: optimize =
destruction of the indirection array=E2=80=9D, which changes =
xfs_iext_destroy to call only kmem_free(). But this patch got stuck in =
the spam filter of the mailing list, and Brent is working to release it =
from there.


 
------=_NextPart_000_0041_01D194B2.3CBE5090
Content-Type: text/html;
	charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<HTML><HEAD></HEAD>
<BODY dir=3Dltr>
<DIV dir=3Dltr>
<DIV style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Verdana'; COLOR: #000000">
<DIV>Hello Dave,</DIV>
<DIV>&nbsp;</DIV>
<DIV>Looking at the patch, I see that now we call xfs_idestroy_fork() in =
RCU=20
callback. This can do the following chain:</DIV>
<DIV>&nbsp;</DIV>
<DIV>xfs_iext_destroy =3D&gt; xfs_iext_irec_remove =3D&gt;=20
xfs_iext_realloc_indirect=3D&gt; kmem_realloc =3D&gt; kmem_alloc =3D&gt; =
kmem_alloc=20
=3D&gt; congestion_wait()</DIV>
<DIV>&nbsp;</DIV>
<DIV>At least according to documentation, the RCU callback cannot block, =
since=20
it may be called from softirq context. Is this fine?</DIV>
<DIV>&nbsp;</DIV>
<DIV>Thanks,</DIV>
<DIV>Alex.</DIV>
<DIV>&nbsp;</DIV>
<DIV>P.S.: I have submitted a patch called =E2=80=9C[PATCH] xfs: =
optimize destruction of=20
the indirection array=E2=80=9D, which changes xfs_iext_destroy to call =
only kmem_free().=20
But this patch got stuck in the spam filter of the mailing list, and =
Brent is=20
working to release it from there.</DIV>
<DIV>&nbsp;</DIV>
<DIV>&nbsp;</DIV><PRE>&nbsp;</PRE></DIV></DIV></BODY></HTML>

------=_NextPart_000_0041_01D194B2.3CBE5090--


--===============2020970989843193602==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2020970989843193602==--
