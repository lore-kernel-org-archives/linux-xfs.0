Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nATCZRG4067487 for <xfs@OSS.SGI.com>; Sun, 29 Nov 2009 06:35:28 -0600
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 663AE1BB9F4B
	for <xfs@OSS.SGI.com>; Sun, 29 Nov 2009 04:35:55 -0800 (PST)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id I3Yy884ZXlCqHWe3
	for <xfs@OSS.SGI.com>; Sun, 29 Nov 2009 04:35:55 -0800 (PST)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.63 #1) id 1NEj0I-0002Gx-2q
	for <xfs@OSS.SGI.com>; Sun, 29 Nov 2009 12:35:50 +0000
MIME-Version: 1.0
Message-ID: <19218.27301.695506.868704@tree.ty.sabi.co.uk>
Date: Sun, 29 Nov 2009 12:35:49 +0000
Subject: Re: please help me! thanks
In-Reply-To: <20091129093903.GA3357@citd.de>
References: <20091128033325.5032D5C121@mail3-144.sinamail.sina.com.cn>
	<20091128184250.GA30986@citd.de>
	<20091129020258.GA5168@puku.stupidest.org>
	<20091129093903.GA3357@citd.de>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux XFS <xfs@oss.sgi.com>

[ ... ]

>>> .el5 smells like Red Hat, Red Hat doesn't do XFS. At least in
>>> nothing that is currently released AFAIR.

>> 5.4 has XFS

> I googled 5.4 and found a CERT that mentions 2.6.18-164. So i
> guess minimum kernel for 5.4 is way more recent than -128.

I think that while the 'xfs.ko' module is part of the base kernels
available standard with EL 5.4, there is an XFS (including 'xfsprogs'
and support) "layered product" from RedHat (that is an optional
extra license) which has become available starting from EL 5.4.

Apparently RH have finally realized that many of their enterprise
customers have large XFS based storage systems and these are not
going to be moved to 'ext4' any time soon (also because EL6 is not
going to appear for a while yet).

  That's I think way EricS replied to consult the distribution
  vendor.

Alternatively there are the XFS RPMs from ElRepo or CentOSPlus or
SL5; since EL releases are supposed (mostly indeed in my experience)
to be binary-compatible within major releases, they work well across
all EL5 clones.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
