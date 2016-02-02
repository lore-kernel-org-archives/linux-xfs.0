Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 933917CB0
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 16:32:52 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 65FCF304053
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 14:32:52 -0800 (PST)
Received: from mail-ob0-f179.google.com (mail-ob0-f179.google.com
	[209.85.214.179]) by cuda.sgi.com with ESMTP id
	ak7IPnJuQ4H4vq0g (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Feb 2016 14:32:47 -0800 (PST)
Received: by mail-ob0-f179.google.com with SMTP id wb13so4420813obb.1
	for <xfs@oss.sgi.com>; Tue, 02 Feb 2016 14:32:47 -0800 (PST)
MIME-Version: 1.0
From: Dilip Simha <nmdilipsimha@gmail.com>
Date: Tue, 2 Feb 2016 14:32:27 -0800
Message-ID: <CAFHL4X1JU02LFYntkqhYg1N++ZU46ML3v5higo1nRsPyoZxL5A@mail.gmail.com>
Subject: Request for information on bloated writes using Swift
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8437939540294338409=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8437939540294338409==
Content-Type: multipart/alternative; boundary=089e013a0112a80116052ad11447

--089e013a0112a80116052ad11447
Content-Type: text/plain; charset=UTF-8

Hi,

I have a question regarding speculated preallocation in XFS, w.r.t kernel
version: 3.16.0-46-generic.
I am using Swift version: 1.0 and mkfs.xfs version 3.2.1

When I write a 256KiB file to Swift, I see that the underlying XFS uses 3x
the amount of space/blocks to write that data.
Upon performing detailed experiments, I see that when Swift uses fallocate
(default approach), XFS doesn't reclaim the preallocated blocks that XFS
allocated. Swift fallocate doesn't exceed the body size(256 KiB).

Interestingly, when either allocsize=4k or when swift doesn't use
fallocate, XFS doesn't consume additional space.

Can you please let me know if this is a known bug and if its fixed in the
later versions?

Thanks & Regards,
Dilip

--089e013a0112a80116052ad11447
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>I have a question regarding specula=
ted preallocation in XFS, w.r.t kernel version: 3.16.0-46-generic.</div><di=
v>I am using Swift version: 1.0 and mkfs.xfs version 3.2.1</div>







<div><br></div><div>When I write a 256KiB file to Swift, I see that the und=
erlying XFS uses 3x the amount of space/blocks to write that data.</div><di=
v>Upon performing detailed experiments, I see that when Swift uses fallocat=
e (default approach), XFS doesn&#39;t reclaim the preallocated blocks that =
XFS allocated. Swift fallocate doesn&#39;t exceed the body size(256 KiB).</=
div><div><br></div><div>Interestingly, when either allocsize=3D4k or when s=
wift doesn&#39;t use fallocate, XFS doesn&#39;t consume additional space.</=
div><div><br></div><div>Can you please let me know if this is a known bug a=
nd if its fixed in the later versions?</div><div><br></div><div>Thanks &amp=
; Regards,</div><div>Dilip</div>







</div>

--089e013a0112a80116052ad11447--


--===============8437939540294338409==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8437939540294338409==--
