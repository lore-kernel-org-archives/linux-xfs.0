Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 781077F50
	for <xfs@oss.sgi.com>; Wed,  9 Dec 2015 18:25:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E3CF5AC004
	for <xfs@oss.sgi.com>; Wed,  9 Dec 2015 16:25:08 -0800 (PST)
Received: from mail-qg0-f53.google.com (mail-qg0-f53.google.com
	[209.85.192.53]) by cuda.sgi.com with ESMTP id ubtnSRntLJa8OiaO
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 09 Dec 2015 16:25:07 -0800 (PST)
Received: by qgcc31 with SMTP id c31so110240841qgc.3
	for <xfs@oss.sgi.com>; Wed, 09 Dec 2015 16:25:06 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 9 Dec 2015 16:25:06 -0800
Message-ID: <CACQ+YcuwWv8g5zHk2sMfN_uRPGnW8Xb8WT6NGOLGigN2+0Toag@mail.gmail.com>
Subject: handling device or resource busy errors.
From: Ed Peschko <horos22@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7364884777707555637=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7364884777707555637==
Content-Type: multipart/alternative; boundary=001a114798b81fa2c00526803db3

--001a114798b81fa2c00526803db3
Content-Type: text/plain; charset=UTF-8

All,

we are 'getting device or resource busy' errors which we *know* are
spurious (lsof shows nothing, no multipath daemon, the partition that we
are trying to access was just created).

So the working theory is that the futex in question is spurious, that
something didn't clean up after itself and we are stuck waiting for an
non-existent process to fix it.

And the force option doesn't work for some reason. So a couple of questions.

    1. Why doesn't force work in this case? With parted and partx it does -
in the case of mkfs.xfs it is a fatal error.
    2. could an 'extra force' option - one which ignored the futex - be
added in cases of backwards compatibility?
    3. is there any way to list out what holds mutexes in the linux kernel
so we could try to root out the ultimate cause of the issue? lsof is
useless, as is dmesg and /var/log/messages.
    4. in the case of #2 how easy would it be? Where is the source code
that centos' version of mkfs.xfs uses on the web? And which check would you
remove?

Thanks for any assistance, this is driving me nuts.

greg

--001a114798b81fa2c00526803db3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div><div><div><div><div>All, <br><br></div=
>we are &#39;getting device or resource busy&#39; errors which we *know* ar=
e spurious (lsof shows nothing, no multipath daemon, the partition that we =
are trying to access was just created).<br><br></div><div>So the working th=
eory is that the futex in question is spurious, that something didn&#39;t c=
lean up after itself and we are stuck waiting for an non-existent process t=
o fix it.<br><br></div>And the force option doesn&#39;t work for some reaso=
n. So a couple of questions.<br><br></div>=C2=A0=C2=A0=C2=A0 1. Why doesn&#=
39;t force work in this case? With parted and partx it does - in the case o=
f mkfs.xfs it is a fatal error.<br></div>=C2=A0=C2=A0=C2=A0 2. could an &#3=
9;extra force&#39; option - one which ignored the futex - be added in cases=
 of backwards compatibility? <br></div>=C2=A0=C2=A0=C2=A0 3. is there any w=
ay to list out what holds mutexes in the linux kernel so we could try to ro=
ot out the ultimate cause of the issue? lsof is useless, as is dmesg and /v=
ar/log/messages.<br></div>=C2=A0=C2=A0=C2=A0 4. in the case of #2 how easy =
would it be? Where is the source code that centos&#39; version of mkfs.xfs =
uses on the web? And which check would you remove?<br><br></div>Thanks for =
any assistance, this is driving me nuts.<br><br></div>greg<br><div><div><br=
><br></div></div></div>

--001a114798b81fa2c00526803db3--


--===============7364884777707555637==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7364884777707555637==--
