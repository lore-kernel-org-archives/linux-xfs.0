Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o123NxmH150879 for <xfs@oss.sgi.com>; Mon, 1 Feb 2010 21:24:09 -0600
Received: from mail-ww0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B458A1A3842
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2010 19:24:34 -0800 (PST)
Received: from mail-ww0-f53.google.com (mail-ww0-f53.google.com
	[74.125.82.53]) by cuda.sgi.com with ESMTP id 66fyaAi4vqPORNeu
	for <xfs@oss.sgi.com>; Mon, 01 Feb 2010 19:24:34 -0800 (PST)
Received: by wwc33 with SMTP id 33so173485wwc.26
	for <xfs@oss.sgi.com>; Mon, 01 Feb 2010 19:24:33 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 1 Feb 2010 21:24:33 -0600
Message-ID: <13bb8ce11002011924h611099feh4955eedcc6e588a6@mail.gmail.com>
Subject: State of XFS on ARM
From: Daniel Goller <morfic@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Dear Sir or Madam,

I Would like to find out about the current state of XFS on ARM.
I have been using XFS for a while successfully on my laptop, and was
using XFS on a ARM device (little endian) since it would hold the same
data i had on the laptop.
It seems i have not been able to unmount it and then mounting it
cleanly once, always required xfs_repair -L   /dev/sdc3
I Could understand power issues or lockups causing this, but on clean
umount and followed mount to see it fail is surprising.
When mounting fails on the headless arm machine i move the drive to a
x86_64 and run xfs_repair there when mounting there fails too (so log
can't be replayed, making -L necessary).
All of this leads me to ask:  "Is XFS as well maintained on ARM as it
is on x86/x86_64?"

Thank you in advance for any info you can provide,

Daniel Goller

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
