Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0DIac9j154204 for <xfs@OSS.SGI.com>; Fri, 13 Jan 2012 12:36:39 -0600
Received: from anakin.london.02.net (anakin.london.02.net [87.194.255.134]) by
	cuda.sgi.com with ESMTP id YfEJ3eTOp0cJ0uw9 for
	<xfs@OSS.SGI.com>; Fri, 13 Jan 2012 10:36:34 -0800 (PST)
Received: from ty.sabi.co.UK (87.194.99.40) by anakin.london.02.net (8.5.140)
	id 4EEB63D20072A99B for xfs@OSS.SGI.com;
	Fri, 13 Jan 2012 18:36:32 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1Rllyn-0004Gu-8k
	for <xfs@OSS.SGI.com>; Fri, 13 Jan 2012 18:35:57 +0000
MIME-Version: 1.0
Message-ID: <20240.31117.130540.618190@tree.ty.sabi.co.UK>
Date: Fri, 13 Jan 2012 18:35:57 +0000
Subject: Re: xfs version and kernels
In-Reply-To: <20120113174739.26ae0c07@harpe.intellique.com>
References: <20120113174739.26ae0c07@harpe.intellique.com>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux fs XFS <xfs@oss.sgi.com>

> [ ... ] couldn't mount on a RedHat 5.3 (antediluvian kernel
> 2.6.18-128.el5 ).
> running xfs_db version gave this:
> versionnum [0xb4a4+0xa] =3D
> V4,NLINK,ALIGN,DALIGN,DIRV2,LOGV2,EXTFLG,MOREBITS,ATTR2,LAZYSBCOUNT

Interesting issue. But on my SL57 64 bits I get:

----------------------------------------------------------------
versionnum [0xbd84+0x8] =3D V4,ALIGN,DALIGN,DIRV2,LOGV2,EXTFLG,SECTOR,MOREB=
ITS,ATTR2
----------------------------------------------------------------

and that's with kernel 2-6.18-274.12.1.el5 which is nearly the
latest. The only difference is 'LAZYSBCOUNT'. I suspect that you
have omitted to mention whether the two systems are 64b or 32b
or a mix, because IIRC there are some limitations with 32b XFS.

Anyhow I did a search for some of those flags and there is a
potentially relevant but old reply here:

  http://uk.centos.org/modules/newbb/viewtopic.php?topic_id=3D25247&forum=
=3D45

and it seems to be a 32b/64 issue, but not one that I espected:

 =ABMandriva LINUX uses 64-bit extents in its 32-bit kernel -- so
  an XFS volume created on that platform could be up to 16TB
  this doesn't seem to fly on a 32-bit CentOS host The 64-bit
  build of CentOS can mount Mandriva's XFS volumes fine=BB

 =ABWhen I saw you had kmod-xfs, I realized yours was 32-bit,
  therefore, running older version of xfs. The upstream vendor
  added the xfs support to the kernel as of 5.4 but it was only
  for x86_64. If you are running the 32-bit OS, then you are
  limited to the old code. I believe there is a plan to provide
  the xfs support (new code) for i686 and CentOS dev Tru is the
  lead.=BB

That's interesting: the RedHat backports of newer XFS features
were only done for the 64b build. However the reply is dated
2006, and a 2.6.18-128 kernel may well be more ancient than
that, and since it is from 5.3, it is so old it does not have
the backports in the 64b version either as that was done in 5.4.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
