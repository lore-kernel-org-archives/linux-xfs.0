Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6TCBc4e252002 for <xfs@oss.sgi.com>; Wed, 29 Jul 2009 07:11:39 -0500
Received: from mail-qy0-f173.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9463312169A6
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2009 05:21:13 -0700 (PDT)
Received: from mail-qy0-f173.google.com (mail-qy0-f173.google.com
	[209.85.221.173]) by cuda.sgi.com with ESMTP id
	y7FjQvuDrHxr53dI for <xfs@oss.sgi.com>;
	Wed, 29 Jul 2009 05:21:13 -0700 (PDT)
Received: by qyk3 with SMTP id 3so888934qyk.20
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2009 05:12:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A6F20D0.4050303@sandeen.net>
References: <362522677.1010811248671789619.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<1938435153.1010831248671852499.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<b094161c0907280550y58cde45fja97b2c413c92a8d4@mail.gmail.com>
	<4A6F0978.4070709@sandeen.net>
	<b094161c0907280759w6c525201vd4a17e22a8c1d582@mail.gmail.com>
	<4A6F20D0.4050303@sandeen.net>
Date: Wed, 29 Jul 2009 20:12:22 +0800
Message-ID: <b094161c0907290512q26efb74jc31f72ff7971210b@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============5181898237879148685=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Lachlan McIlroy <lmcilroy@redhat.com>, xfs@oss.sgi.com

--===============5181898237879148685==
Content-Type: multipart/alternative; boundary=0016364ef40a7bf943046fd71960

--0016364ef40a7bf943046fd71960
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello Eric:

>
> A tool that can be very helpful here is "pahole" found in the dwarves
> package:
>

Nice tool.

>
> So just to be clear, on 2.6.28, arm eabi logs replay fine on x86_64?
>

I don't have x86_64 machine at hand. Replay arm eabi log on ia32 machine
"seems" success (mount "successfully" returns). Actually I guess that's
because 2.6.28 XFS running on ia32 misinterprets unpacked
xfs_inode_log_format produced by arm as xfs_inode_log_format_64. And there
must be something silently goes wrong on disk after replaying the log.
During fixing the problem, I find it is difficult to change the code to
commit packed log item (restricted by xfs_log_iovec_t mechanism). If we
could somehow change this piece of code to use packed structure. The
endianess problem could be solved by add an byte-swap option to xfs_repair
(like e2fsck "-s"). Then we solve the xfs-log-cant-migrate-between-archs
problem.

Thanks
Eddy

--0016364ef40a7bf943046fd71960
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hello Eric: </div>
<div>=A0</div>
<div>&gt;<br>&gt; A tool that can be very helpful here is &quot;pahole&quot=
; found in the dwarves<br>&gt; package:<br>&gt;</div>
<p>Nice tool.</p>
<p>&gt; <br>&gt; So just to be clear, on 2.6.28, arm eabi logs replay fine =
on x86_64?<br>&gt;</p>
<p>I don&#39;t have x86_64 machine at hand. Replay arm eabi log on ia32 mac=
hine &quot;seems&quot; success (mount &quot;successfully&quot; returns). Ac=
tually I guess that&#39;s because 2.6.28 XFS running on ia32 misinterprets =
unpacked xfs_inode_log_format produced by arm as xfs_inode_log_format_64. A=
nd there must be something silently goes wrong on disk after replaying the =
log.</p>

<div>During fixing the problem, I find it is difficult to change the code t=
o commit packed log item (restricted by xfs_log_iovec_t mechanism). If we c=
ould somehow change this piece of code to use packed=A0structure. The endia=
ness problem could be solved by=A0add an byte-swap option to xfs_repair (li=
ke e2fsck &quot;-s&quot;). Then we solve the xfs-log-cant-migrate-between-a=
rchs problem.</div>

<div>=A0</div>
<div>Thanks<br>Eddy</div>

--0016364ef40a7bf943046fd71960--


--===============5181898237879148685==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5181898237879148685==--
