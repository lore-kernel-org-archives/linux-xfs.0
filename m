Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6TDiesd255973 for <xfs@oss.sgi.com>; Wed, 29 Jul 2009 08:44:40 -0500
Received: from mail-qy0-f173.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 37CB0391D56
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2009 06:45:26 -0700 (PDT)
Received: from mail-qy0-f173.google.com (mail-qy0-f173.google.com
	[209.85.221.173]) by cuda.sgi.com with ESMTP id
	tl0KE5BqGzfMdCFj for <xfs@oss.sgi.com>;
	Wed, 29 Jul 2009 06:45:26 -0700 (PDT)
Received: by qyk3 with SMTP id 3so963808qyk.20
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2009 06:45:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b094161c0907290512q26efb74jc31f72ff7971210b@mail.gmail.com>
References: <362522677.1010811248671789619.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<1938435153.1010831248671852499.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<b094161c0907280550y58cde45fja97b2c413c92a8d4@mail.gmail.com>
	<4A6F0978.4070709@sandeen.net>
	<b094161c0907280759w6c525201vd4a17e22a8c1d582@mail.gmail.com>
	<4A6F20D0.4050303@sandeen.net>
	<b094161c0907290512q26efb74jc31f72ff7971210b@mail.gmail.com>
Date: Wed, 29 Jul 2009 21:45:25 +0800
Message-ID: <b094161c0907290645y3bcae541g8cf10b7e1564b526@mail.gmail.com>
Subject: Re: BUG REPORT: XFS LOG FORWARD COMPATIBILITY PROBLEM
From: Eddy Zhao <eddy.y.zhao@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1160121704332350505=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Lachlan McIlroy <lmcilroy@redhat.com>, xfs@oss.sgi.com

--===============1160121704332350505==
Content-Type: multipart/alternative; boundary=0016364ee2ea3c4624046fd8665f

--0016364ee2ea3c4624046fd8665f
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>
> Replay arm eabi log on ia32 machine "seems" success (mount "successfully"
returns). Actually I guess that's because 2.6.28 XFS running on ia32
misinterprets unpacked xfs_inode_log_format produced by arm as
xfs_inode_log_format_64. And there must be something silently goes wrong on
disk after replaying the log.
>

Forget this. There's no misinterpretation. Should be

"Replay arm eabi log on ia32 machine success (mount successfully returns).
2.6.28 XFS running on ia32 interprets unpacked xfs_inode_log_format produced
by arm as xfs_inode_log_format_64"

Sorry for patch myself repeatedly : )

--0016364ee2ea3c4624046fd8665f
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>&gt;</div>
<div>&gt; Replay arm eabi log on ia32 machine &quot;seems&quot; success (mo=
unt &quot;successfully&quot; returns). Actually I guess that&#39;s because =
2.6.28 XFS running on ia32 misinterprets unpacked xfs_inode_log_format prod=
uced by arm as xfs_inode_log_format_64. And there must be something silentl=
y goes wrong on disk after replaying the log.<br>
&gt;</div>
<div>=A0</div>
<div>Forget this. There&#39;s no misinterpretation. Should be</div>
<div>=A0</div>
<div>&quot;Replay arm eabi log on ia32 machine success=A0(mount successfull=
y returns). 2.6.28 XFS running on ia32 interprets unpacked xfs_inode_log_fo=
rmat produced by arm as xfs_inode_log_format_64&quot;</div>
<div>=A0</div>
<div>Sorry for patch myself repeatedly : )</div>

--0016364ee2ea3c4624046fd8665f--


--===============1160121704332350505==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1160121704332350505==--
