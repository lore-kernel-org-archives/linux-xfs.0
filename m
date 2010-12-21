Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBLB1R2I010443 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 05:01:27 -0600
Received: from mail-fx0-f50.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9AC991CDD7DE
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 03:03:24 -0800 (PST)
Received: from mail-fx0-f50.google.com (mail-fx0-f50.google.com
	[209.85.161.50]) by cuda.sgi.com with ESMTP id IWMDzCgXIcALq7t8
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 03:03:24 -0800 (PST)
Received: by fxm14 with SMTP id 14so3848638fxm.37
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 03:03:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1012211132450.6010@dhcp-lab-213.englab.brq.redhat.com>
References: <1291996407-26251-1-git-send-email-lczerner@redhat.com>
	<20101220174146.GA32680@infradead.org>
	<alpine.LFD.2.00.1012211132450.6010@dhcp-lab-213.englab.brq.redhat.com>
From: Phil Karn <karn@philkarn.net>
Date: Tue, 21 Dec 2010 03:03:03 -0800
Message-ID: <AANLkTi=2J5fi1uQazbzsEQ+658DhoqRaxHuMPN9JPVqW@mail.gmail.com>
Subject: Re: [PATCH] Add test 248: Check filesystem FITRIM implementation
Reply-To: karn@ka9q.net
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7481568468186127459=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7481568468186127459==
Content-Type: multipart/alternative; boundary=001636c5b4d8cdc4460497e995db

--001636c5b4d8cdc4460497e995db
Content-Type: text/plain; charset=UTF-8

What is the plan for TRIM support in XFS? I don't see any mention in the
2.6.36.2 sources, so I guess the code you guys have been discussing must not
be considered stable yet.

How will it eventually work? Will the filesystem automatically issue the
commands to the drive whenever a file is deleted, or will it always require
some sort of prodding from a userspace program?

And what kind of experiences are people having with XFS on current SSDs? I
just put an Intel drive in my newly upgraded box and I'm wondering if this
blazing performance will screech to a halt when my cumulative writes exceed
its 120 GB capacity. Does anyone have a standalone "drive optimizer" that
understands XFS, i.e, that can examine an unmounted file system and issue
the appropriate TRIM commands for every block on the free list?

Or is the Intel drive somehow really good at avoiding write amplification
even without TRIM help from the file system? I've heard that may be the
case, but I don't understand how that can be.

Phil

--001636c5b4d8cdc4460497e995db
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

What is the plan for TRIM support in XFS? I don&#39;t see any mention in th=
e 2.6.36.2 sources, so I guess the code you guys have been discussing must =
not be considered stable yet.<br><br>How will it eventually work? Will the =
filesystem automatically issue the commands to the drive whenever a file is=
 deleted, or will it always require some sort of prodding from a userspace =
program?<br>

<br>And what kind of experiences are people having with XFS on current SSDs=
? I just put an Intel drive in my newly upgraded box and I&#39;m wondering =
if this blazing performance will screech to a halt when my cumulative write=
s exceed its 120 GB capacity. Does anyone have a standalone &quot;drive opt=
imizer&quot; that understands XFS, i.e, that can examine an unmounted file =
system and issue the appropriate TRIM commands for every block on the free =
list?<br>

<br>Or is the Intel drive somehow really good at avoiding write amplificati=
on even without TRIM help from the file system? I&#39;ve heard that may be =
the case, but I don&#39;t understand how that can be.<br><br>Phil<br><br>


--001636c5b4d8cdc4460497e995db--


--===============7481568468186127459==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7481568468186127459==--
