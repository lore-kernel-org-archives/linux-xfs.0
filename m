Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3DEDXxj111655 for <xfs@oss.sgi.com>; Mon, 13 Apr 2009 09:13:44 -0500
Received: from mail-ew0-f158.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA6BC20DC2A
	for <xfs@oss.sgi.com>; Mon, 13 Apr 2009 07:13:15 -0700 (PDT)
Received: from mail-ew0-f158.google.com (mail-ew0-f158.google.com
	[209.85.219.158]) by cuda.sgi.com with ESMTP id
	i82hJUEu98TTYtwV for <xfs@oss.sgi.com>;
	Mon, 13 Apr 2009 07:13:15 -0700 (PDT)
Received: by ewy2 with SMTP id 2so2505844ewy.20
	for <xfs@oss.sgi.com>; Mon, 13 Apr 2009 07:13:14 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 13 Apr 2009 16:13:14 +0200
Message-ID: <dbd747120904130713t7388971axf75ee779b5b1e1f2@mail.gmail.com>
Subject: xfs - fixing wrong xfs size
From: Nebojsa Trpkovic <trx.lists@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9138329030870059763=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============9138329030870059763==
Content-Type: multipart/alternative; boundary=0015174c3e9eab8dac04677050a7

--0015174c3e9eab8dac04677050a7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

hello.

I had problem with raid5 on my system.
after recovering of the array, I can not mount XFS that resides on it.
I've run xfs_check and xfs_repair (which fixed some errors) and now I can
run them all day long without any errors.

but, when I try to mount that partition, I get:

mount: /dev/md0: can't read superblock


and there's

Filesystem "md0": Disabling barriers, not supported by the underlying device
attempt to access beyond end of device
md0: rw=0, want=123024384, limit=123023488
I/O error in filesystem ("md0") meta-data dev md0 block 0x75533f8
 ("xfs_read_buf") error 5 buf count 4096
XFS: size check 2 failed



in the dmesg.


is there any way to "fix" this wrong size of XFS ?

thx.

--0015174c3e9eab8dac04677050a7
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

hello.<br><br>I had problem with raid5 on my system. <br>after recovering o=
f the array, I can not mount XFS that resides on it.<br>I&#39;ve run xfs_ch=
eck and xfs_repair (which fixed some errors) and now I can run them all day=
 long without any errors.<br>
<br>but, when I try to mount that partition, I get:<br><br><pre class=3D"al=
t2" dir=3D"ltr" style=3D"border: 1px inset ; margin: 0px; padding: 6px; ove=
rflow: auto; width: 640px; height: 34px; text-align: left;">mount: /dev/md0=
: can&#39;t read superblock</pre>
<br>and there&#39;s <br><br><pre class=3D"alt2" dir=3D"ltr" style=3D"border=
: 1px inset ; margin: 0px; padding: 6px; overflow: auto; width: 640px; heig=
ht: 98px; text-align: left;">Filesystem &quot;md0&quot;: Disabling barriers=
, not supported by the underlying device<br>
attempt to access beyond end of device<br>md0: rw=3D0, want=3D123024384, li=
mit=3D123023488<br>I/O error in filesystem (&quot;md0&quot;) meta-data dev =
md0 block 0x75533f8       (&quot;xfs_read_buf&quot;) error 5 buf count 4096=
<br>
XFS: size check 2 failed</pre><br><br>in the dmesg.<br><br><br>is there any=
 way to &quot;fix&quot; this wrong size of XFS ?<br><br>thx.<br><br><br>

--0015174c3e9eab8dac04677050a7--


--===============9138329030870059763==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9138329030870059763==--
