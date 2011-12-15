Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBF2EjKS242755 for <xfs@oss.sgi.com>; Wed, 14 Dec 2011 20:14:46 -0600
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 74F8F15747B8
	for <xfs@oss.sgi.com>; Wed, 14 Dec 2011 18:14:43 -0800 (PST)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	JxRQmO1fL4vHgOWv for <xfs@oss.sgi.com>;
	Wed, 14 Dec 2011 18:14:43 -0800 (PST)
Received: by iakk12 with SMTP id k12so287202iak.26
	for <xfs@oss.sgi.com>; Wed, 14 Dec 2011 18:14:43 -0800 (PST)
MIME-Version: 1.0
From: Andrei Purdea <andrei@purdea.ro>
Date: Thu, 15 Dec 2011 04:14:28 +0200
Message-ID: <CA+mMEgf+k6focwqB8_pZoCMF8=e=_czrrRe-6R8i4bNP614g2Q@mail.gmail.com>
Subject: trim performance on xfs (also reply to: Online TRIM/discard
	performance impact)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

I also recently met with an issue that has been described in a
previous email(http://oss.sgi.com/archives/xfs/2011-11/msg00108.html).
I have an OCZ Agility 3 (also a SandForce 2281 controller),and a
Corsair Performance Pro (non-SandForce controller,with good
non-compressible data speeds)
Removing a linux-3.2-rc5 tree took more then 6 minutes with online
discard,and ext4 was very speedy (less then a second), but only on the
SandForce controller!!For the Corsair performance was good on both
filesystems.
So I decided to debug what is happening.I also noticed that fstrim was
slower on the OCZ(30-40 seconds, vs. 3 seconds on the Corsair)So I had
a hunch that the performance difference comes from the number
ofsectors that are discarded in a single TRIM command.
So i compiled a kernel where I inserted a printk into
blkdev_issue_discard(),to see how many sectors each call asks for.
Results:
Total number of sectors discarded:=A0 =A0ext4: 1032864 =A0 XFS: 1043112
(about the same)Number of calls to blkdev_issue_discard():=A0 =A0ext4: 24
 =A0 =A0 =A0 =A0 =A0XFS: 39395Average number of sectors discarded per call:
ext4: 43036 (21 MiB) =A0 XFS: 26.48 =A0(13.2 KiB)
I made some TRIM performance measurements (see image on
http://purdea.ro/projects/trim_perf/)with a small tool i wrote.
(warning, destructive to data)
It looks like the OCZ needs a really high amount of time to
executeeven the smallest TRIM command.
I made a small post about this here: http://purdea.ro/projects/trim_perf/
Can this be fixed in XFS?
I am curious, do all SandForce controllers exhibit this slow TRIM issue?
Andrew
-- =

Purdea Andrei
http://purdea.ro
student at the =93Politehnica=94 University of Timisoara
Faculty of Automation and Computers (AC)
Master's Degree Program - Computer Engineering (MCE)
2nd year

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
