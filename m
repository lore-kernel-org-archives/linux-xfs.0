Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6DKSWwk099877 for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 15:28:32 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3AA956A9DE
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 13:28:30 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id 3HExMzf4DEzZYzdm
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 13:28:30 -0700 (PDT)
Received: by bwg12 with SMTP id 12so5662049bwg.26
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 13:28:30 -0700 (PDT)
MIME-Version: 1.0
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Wed, 13 Jul 2011 16:28:00 -0400
Message-ID: <CAGpXXZLvvP+idqxCb8a5r1pkO9WhQcjVKGQeK+MGQp-dAp0Ztw@mail.gmail.com>
Subject: Trying xfstest 075 and 112, both are failing
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

All,

I'm trying to get xfstests running in my setup for the first time in years.

I've trying with a btrfs test partition.

./check mostly runs, but 3 tests are failing: 075, 112, and 127

075 and 112 look like very basic errors in the 075.out info.  Makes me
wonder if they work for anyone with a current git pull.

=3D=3D=3D=3D example failure of test 075
# ./check 075
FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 tiger3-64bit 2.6.39.2-36-default
MKFS_OPTIONS  -- /dev/sda1
MOUNT_OPTIONS -- /dev/sda1 /xfstests_mnt_scratch

075 11s ... [failed, exit status 1] - output mismatch (see 075.out.bad)
--- 075.out     2011-06-30 18:41:17.000000000 -0400
+++ 075.out.bad 2011-07-13 16:25:55.000000000 -0400
@@ -4,15 +4,4 @@
 -----------------------------------------------
 fsx.0 : -d -N numops -S 0
 -----------------------------------------------
-
------------------------------------------------
-fsx.1 : -d -N numops -S 0 -x
------------------------------------------------
-
------------------------------------------------
-fsx.2 : -d -N numops -l filelen -S 0
------------------------------------------------
-
------------------------------------------------
-fsx.3 : -d -N numops -l filelen -S 0 -x
------------------------------------------------
+    fsx (-d -N 1000 -S 0) failed, 0 - compare 075.0.{good,bad,fsxlog}
Ran: 075
Failures: 075
Failed 1 of 1 tests
=3D=3D=3D

(by chance, I also documented what I was doing in the openSUSE wiki,
so you can see the exact steps at;
http://en.opensuse.org/SDB:XFStests)

Thanks for any feedback
Greg
-- =

Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
CNN/TruTV Aired Forensic Imaging Demo -
=A0=A0 http://insession.blogs.cnn.com/2010/03/23/how-computer-evidence-gets=
-retrieved/

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
