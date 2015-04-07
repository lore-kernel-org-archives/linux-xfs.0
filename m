Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7D9AB7F6D
	for <xfs@oss.sgi.com>; Tue,  7 Apr 2015 10:30:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6D9698F8033
	for <xfs@oss.sgi.com>; Tue,  7 Apr 2015 08:30:49 -0700 (PDT)
Received: from mail-qc0-f172.google.com (mail-qc0-f172.google.com
	[209.85.216.172]) by cuda.sgi.com with ESMTP id
	WxOOSYS665cfj4F5 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 07 Apr 2015 08:30:48 -0700 (PDT)
Received: by qcgx3 with SMTP id x3so22418456qcg.3
	for <xfs@oss.sgi.com>; Tue, 07 Apr 2015 08:30:47 -0700 (PDT)
Received: from [156.40.66.13] ([156.40.66.13])
	by mx.google.com with ESMTPSA id 132sm5564523qhf.17.2015.04.07.08.30.45
	for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
	Tue, 07 Apr 2015 08:30:46 -0700 (PDT)
From: Charles Weber <chaweber@gmail.com>
Subject: finest and rhel/centos 7.1
Message-Id: <014A8EAA-D469-49D9-9A80-5C4CC455C74E@gmail.com>
Date: Tue, 7 Apr 2015 11:30:44 -0400
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1899210073654739769=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============1899210073654739769==
Content-Type: multipart/alternative; boundary="Apple-Mail=_BB0CDBE2-B5F6-4E28-8A42-1682D2F0A756"


--Apple-Mail=_BB0CDBE2-B5F6-4E28-8A42-1682D2F0A756
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi everyone,
I am building a large storage server and noticed to my delight that =
mkfs.xfs in 7.1 now supports finobts=3D1. But I get mount errors saying =
below. Since the FS in question mount fine so long as I don=E2=80=99t =
specify finobts=3D1 while formatting, should I assume the rest of 7.1 is =
not yet ready for it? Or is there some option I missed?

thanks,
Chuck
xfsprogs-3.2.1-6.el7.x86_64
kernel-3.10.0-229.1.2.el7.x86_64
[75881.037768] SELinux: initialized (dev dm-7, type xfs), uses xattr
[75908.498994] XFS (dm-7): Superblock has unknown read-only compatible =
features (0x1) enabled.
[75908.499035] XFS (dm-7): Attempted to mount read-only compatible =
filesystem read-write.
Filesystem can only be safely mounted read only.
[75908.499058] XFS (dm-7): SB validate failed with error 22.


[root@NIAIRPGL1 share]# modinfo xfs
filename:       =
/lib/modules/3.10.0-229.1.2.el7.x86_64/kernel/fs/xfs/xfs.ko
license:        GPL
description:    SGI XFS with ACLs, security attributes, large =
block/inode numbers, no debug enabled
author:         Silicon Graphics, Inc.
alias:          fs-xfs
rhelversion:    7.1
srcversion:     3E3940432E169BEE955EDE9
depends:        libcrc32c
intree:         Y
vermagic:       3.10.0-229.1.2.el7.x86_64 SMP mod_unload modversions=20
signer:         CentOS Linux kernel signing key
sig_key:        =
34:B5:BC:A2:B7:06:D8:2E:72:A5:BE:3E:E4:09:BE:C7:19:5E:A5:08
sig_hashalgo:   sha256


--Apple-Mail=_BB0CDBE2-B5F6-4E28-8A42-1682D2F0A756
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dutf-8"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D"">Hi everyone,<div class=3D"">I am building a large storage =
server and noticed to my delight that mkfs.xfs in 7.1 now supports =
finobts=3D1. But I get mount errors saying below. Since the FS in =
question mount fine so long as I don=E2=80=99t specify finobts=3D1 while =
formatting, should I assume the rest of 7.1 is not yet ready for it? Or =
is there some option I missed?</div><div class=3D""><br =
class=3D""></div><div class=3D"">thanks,</div><div =
class=3D"">Chuck</div><div class=3D""><div style=3D"margin: 0px; =
font-family: Courier; color: rgb(76, 47, 45); background-color: rgb(223, =
219, 196);" class=3D""><span style=3D"font-variant-ligatures: =
no-common-ligatures; color: #ee2207" class=3D""><b =
class=3D"">xfs</b></span>progs-3.2.1-6.el7.x86_64</div></div><div =
style=3D"margin: 0px; font-family: Courier; color: rgb(76, 47, 45); =
background-color: rgb(223, 219, 196);" class=3D""><div style=3D"margin: =
0px;" class=3D"">kernel-3.10.0-229.1.2.el7.x86_64</div></div><div =
class=3D""><div style=3D"margin: 0px; font-family: Courier; color: =
rgb(76, 47, 45); background-color: rgb(223, 219, 196);" =
class=3D"">[75881.037768] SELinux: initialized (dev dm-7, type xfs), =
uses xattr</div><div style=3D"margin: 0px; font-family: Courier; color: =
rgb(76, 47, 45); background-color: rgb(223, 219, 196);" =
class=3D"">[75908.498994] XFS (dm-7): Superblock has unknown read-only =
compatible features (0x1) enabled.</div><div style=3D"margin: 0px; =
font-family: Courier; color: rgb(76, 47, 45); background-color: rgb(223, =
219, 196);" class=3D"">[75908.499035] XFS (dm-7): Attempted to mount =
read-only compatible filesystem read-write.</div><div style=3D"margin: =
0px; font-family: Courier; color: rgb(76, 47, 45); background-color: =
rgb(223, 219, 196);" class=3D"">Filesystem can only be safely mounted =
read only.</div><div style=3D"margin: 0px; font-family: Courier; color: =
rgb(76, 47, 45); background-color: rgb(223, 219, 196);" =
class=3D"">[75908.499058] XFS (dm-7): SB validate failed with error =
22.</div></div><div style=3D"margin: 0px; font-family: Courier; color: =
rgb(76, 47, 45); background-color: rgb(223, 219, 196);" class=3D""><br =
class=3D""></div><div style=3D"margin: 0px; font-family: Courier; color: =
rgb(76, 47, 45); background-color: rgb(223, 219, 196);" class=3D""><br =
class=3D""></div><div style=3D"margin: 0px; font-family: Courier; color: =
rgb(76, 47, 45); background-color: rgb(223, 219, 196);" class=3D""><div =
style=3D"margin: 0px;" class=3D"">[root@NIAIRPGL1 share]# modinfo =
xfs</div><div style=3D"margin: 0px;" class=3D"">filename: &nbsp; &nbsp; =
&nbsp; =
/lib/modules/3.10.0-229.1.2.el7.x86_64/kernel/fs/xfs/xfs.ko</div><div =
style=3D"margin: 0px;" class=3D"">license:&nbsp; &nbsp; &nbsp; &nbsp; =
GPL</div><div style=3D"margin: 0px;" class=3D"">description:&nbsp; =
&nbsp; SGI XFS with ACLs, security attributes, large block/inode =
numbers, no debug enabled</div><div style=3D"margin: 0px;" =
class=3D"">author: &nbsp; &nbsp; &nbsp; &nbsp; Silicon Graphics, =
Inc.</div><div style=3D"margin: 0px;" class=3D"">alias:&nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; fs-xfs</div><div style=3D"margin: 0px;" =
class=3D"">rhelversion:&nbsp; &nbsp; 7.1</div><div style=3D"margin: =
0px;" class=3D"">srcversion: &nbsp; &nbsp; =
3E3940432E169BEE955EDE9</div><div style=3D"margin: 0px;" =
class=3D"">depends:&nbsp; &nbsp; &nbsp; &nbsp; libcrc32c</div><div =
style=3D"margin: 0px;" class=3D"">intree: &nbsp; &nbsp; &nbsp; &nbsp; =
Y</div><div style=3D"margin: 0px;" class=3D"">vermagic: &nbsp; &nbsp; =
&nbsp; 3.10.0-229.1.2.el7.x86_64 SMP mod_unload =
modversions&nbsp;</div><div style=3D"margin: 0px;" class=3D"">signer: =
&nbsp; &nbsp; &nbsp; &nbsp; CentOS Linux kernel signing key</div><div =
style=3D"margin: 0px;" class=3D"">sig_key:&nbsp; &nbsp; &nbsp; &nbsp; =
34:B5:BC:A2:B7:06:D8:2E:72:A5:BE:3E:E4:09:BE:C7:19:5E:A5:08</div><div =
style=3D"margin: 0px;" class=3D"">sig_hashalgo: &nbsp; sha256</div><div =
class=3D""><br class=3D""></div></div></body></html>=

--Apple-Mail=_BB0CDBE2-B5F6-4E28-8A42-1682D2F0A756--


--===============1899210073654739769==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1899210073654739769==--
