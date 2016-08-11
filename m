Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B616F7CA3
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 07:43:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 87DF98F8035
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 05:43:11 -0700 (PDT)
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id doROzdNyNX4otyuq (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Aug 2016 05:43:07 -0700 (PDT)
Received: from [IPv6:2003:81:6f37:f112:e0dd:34e9:2242:2c11]
	(p200300061517B312E0DD34E922422C11.dip0.t-ipconnect.de
	[IPv6:2003:6:1517:b312:e0dd:34e9:2242:2c11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested) (Authenticated sender: whissi)
	by smtp.gentoo.org (Postfix) with ESMTPSA id A55E2340B19
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 12:43:05 +0000 (UTC)
From: Thomas Deutschmann <whissi@gentoo.org>
Subject: xfsprogs-4.7.0 are conflicting with glibc's MS_RDONLY definition
Message-ID: <2608952f-e6c4-0f20-8f49-818d67896dd3@gentoo.org>
Date: Thu, 11 Aug 2016 14:42:50 +0200
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Hi,

collectd [1] now longer builds against xfsprogs-4.7.0 due to a
conflict with MS_RDONLY definition in sys/mount.h by glibc vs exposed
kernels header by xfsprogs due to the include of linux/fs.h.

Upstream bug: https://github.com/collectd/collectd/issues/1877

Gentoo-Bug: https://bugs.gentoo.org/590998


I am bringing this to your attention to ask if you want to do anything
to fix this in xfsprogs or do you consider that as a bug in collectd.

Thanks!


[1] https://collectd.org/


- -- 
Regards,
Thomas
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.1

iQJ8BAEBCgBmBQJXrHK/XxSAAAAAAC4AKGlzc3Vlci1mcHJAbm90YXRpb25zLm9w
ZW5wZ3AuZmlmdGhob3JzZW1hbi5uZXQzM0M1ODQ4MkM0MDIyOTJEMkUzQzVDMDY5
NzA5RjkwQzNDOTZGRkM4AAoJEJcJ+Qw8lv/IDqoQALTIBw+n+P8ZAW1mksVrY15d
PjYFnPl50ZYbm5KXedOdY9iaEzvTG12bAPGm7HGnmURdC/yRcs50JMua6fNWTYi0
r6gwdxijynMmUv0omgp1LDl+d/d7od5DkFZrQ0fP0TUHrbW4D+8FFHETPTWigtk2
YOi1VsGYuRuSflSCWDvUjVeJVjkozYYZO/9Moz7V1Cvaw3ghvGz74AqCdHZDVnKB
iCDndcxmNNUBp+ouzrgwJVcQYGBjeAyNfByw4EN5i2doYA/flqP6epgG21y6+YFk
h6/ZTCZV68BkXVu6N2VOjMY2GaQC2wPb8CkDxYFqV8dDszb+bI1XJ7vEEMzl3mRp
3LbiK5fATOc6mSSzYyMmqZq2TyLVDnHxsO5agTLlVaOjAufCrADpUD/T7jGgDVnV
K4TJ6P+oa0GoYvuCstglwFj2beqpldIQFwOJICNrV7IqpduuNgUG0d+lO19Yws3g
uu/2RNd2s7MUqiodEtFfADSm6p5W/Wrdc7tR9O+O5UqlQAJWHz/G8ZjTytZ0eJ+X
Gun2bsAsRAirXpqGltgEMFj81O6isKGyAnVLibQRMsAFPJdUrbATF1L8ZK9yrGN0
TM0GC2kvgroNVetT/S1aNw2spTsC8eXe2v+guEa1syzeIXElMASdQSj5BcBDmOv3
ccalRiV+rhJU8/Y+wTO/
=K3bt
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
