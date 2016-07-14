Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F05067CA2
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 15:19:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B6DFE8F8040
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 13:19:05 -0700 (PDT)
Received: from mail-oi0-f49.google.com (mail-oi0-f49.google.com
	[209.85.218.49]) by cuda.sgi.com with ESMTP id VzTmzdcWne19eTjg
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 Jul 2016 13:19:03 -0700 (PDT)
Received: by mail-oi0-f49.google.com with SMTP id j185so127848808oih.0
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 13:19:03 -0700 (PDT)
MIME-Version: 1.0
From: Marcin Sura <mailing-lists@sura.pl>
Date: Thu, 14 Jul 2016 22:19:02 +0200
Message-ID: <CACNifpVsOMKQyshHk8B7WrmsbGAN_fOz6qpHLBTc_N=K1xY0Dw@mail.gmail.com>
Subject: mkfs.xfs -d su=XXX,sw=YYY and future volume resize
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5860527644940199074=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5860527644940199074==
Content-Type: multipart/alternative; boundary=94eb2c03aee483d1ac05379e3620

--94eb2c03aee483d1ac05379e3620
Content-Type: text/plain; charset=UTF-8

Hi,

When I create filesystem I can specify su and sw paramteres which match
underlying storage device.
So for example, If I have raid 6 volume made of 6 + 2 disks with stripe
size of 256k I create xfs with:

mkfs.xfs -d su=256k,sw=6 <disk>

But what if I will extend original volume by 2 disks. sw will 8. Will be
there a performance panelty compared to filesystem created from scratch
with correct sw parameter?

BR
Marcin

--94eb2c03aee483d1ac05379e3620
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>When I create filesystem I can spec=
ify su and sw paramteres which match underlying storage device.</div><div>S=
o for example, If I have raid 6 volume made of 6 + 2 disks with stripe size=
 of 256k I create xfs with:</div><div><br></div><div>mkfs.xfs -d su=3D256k,=
sw=3D6 &lt;disk&gt;</div><div><br></div><div>But what if I will extend orig=
inal volume by 2 disks. sw will 8. Will be there a performance panelty comp=
ared to filesystem created from scratch with correct sw parameter?</div><di=
v><br></div><div>BR</div><div>Marcin</div></div>

--94eb2c03aee483d1ac05379e3620--


--===============5860527644940199074==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5860527644940199074==--
