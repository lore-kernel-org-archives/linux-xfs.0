Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8D11F7F50
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 11:51:52 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 753C88F8050
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 09:51:49 -0800 (PST)
Received: from mail-oa0-f45.google.com (mail-oa0-f45.google.com
	[209.85.219.45]) by cuda.sgi.com with ESMTP id Pc5nOB8ncNHEk6OR
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Nov 2013 09:51:48 -0800 (PST)
Received: by mail-oa0-f45.google.com with SMTP id m1so2641528oag.18
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 09:51:48 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 14 Nov 2013 23:51:47 +0600
Message-ID: <CAD5ewrp2X_CyffUt6KUCd9bRE-BJ9_Q2OmZuzPv+d1VBf09OyA@mail.gmail.com>
Subject: xfs_repair
From: Roman Hlynovskiy <roman.hlynovskiy@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8671422103937464507=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8671422103937464507==
Content-Type: multipart/alternative; boundary=001a11c3040856be3304eb26bcbe

--001a11c3040856be3304eb26bcbe
Content-Type: text/plain; charset=ISO-8859-1

hello, after a server crush we are trying to get back access to data on
another server.

out setup is the following:
4 disks in md-array, lvm over it and xfs

xfs_check just stops with 'out of memory error'
xfs_repair after a long list of complains says:

corrupt dinode 2473604576, extent total = 1, nblocks = 0.  This is a bug.
Please capture the filesystem metadata with xfs_metadump and
report it to xfs@oss.sgi.com.
cache_node_purge: refcount was 1, not zero (node=0xb43ab688)

fatal error -- 117 - couldn't iget disconnected inode

I captured this metadata file, but it's 2GB size.
is there a chance to fix the fs?

-- 
...WBR, Roman Hlynovskiy

--001a11c3040856be3304eb26bcbe
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div>hello, after a server crush we are trying t=
o get back access to data on another server.<br><br></div>out setup is the =
following:<br></div>4 disks in md-array, lvm over it and xfs<br><br></div>
xfs_check just stops with &#39;out of memory error&#39;<br><div><div><div><=
div>xfs_repair after a long list of complains says:<br><br>corrupt dinode 2=
473604576, extent total =3D 1, nblocks =3D 0.=A0 This is a bug.<br>Please c=
apture the filesystem metadata with xfs_metadump and<br>
report it to <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a>.<br>cac=
he_node_purge: refcount was 1, not zero (node=3D0xb43ab688)<br><br>fatal er=
ror -- 117 - couldn&#39;t iget disconnected inode<br clear=3D"all"><br></di=
v>
<div>I captured this metadata file, but it&#39;s 2GB size.<br></div><div>is=
 there a chance to fix the fs?<br></div><div><br></div><div>-- <br>...WBR, =
Roman Hlynovskiy
</div></div></div></div></div>

--001a11c3040856be3304eb26bcbe--


--===============8671422103937464507==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8671422103937464507==--
