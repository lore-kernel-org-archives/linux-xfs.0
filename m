Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4K0tFlx061977 for <xfs@oss.sgi.com>; Thu, 19 May 2011 19:55:16 -0500
Received: from mail.nethype.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6FEFECEC40A
	for <xfs@oss.sgi.com>; Thu, 19 May 2011 17:55:13 -0700 (PDT)
Received: from mail.nethype.de (mail.nethype.de [78.47.73.129]) by
	cuda.sgi.com with ESMTP id SA9JTRPndiDnGLFF for
	<xfs@oss.sgi.com>; Thu, 19 May 2011 17:55:13 -0700 (PDT)
Received: from [10.0.0.5] (helo=doom.schmorp.de)
	by mail.nethype.de with esmtp (Exim 4.72)
	(envelope-from <schmorp@schmorp.de>) id 1QNDzj-0003Xv-LH
	for xfs@oss.sgi.com; Fri, 20 May 2011 00:55:11 +0000
Received: from [10.0.0.1] (helo=cerebro.laendle)
	by doom.schmorp.de with esmtp (Exim 4.72)
	(envelope-from <schmorp@schmorp.de>) id 1QNDzj-0005jd-GS
	for xfs@oss.sgi.com; Fri, 20 May 2011 00:55:11 +0000
Received: from root by cerebro.laendle with local (Exim 4.72)
	(envelope-from <root@schmorp.de>) id 1QNDzj-0005Ar-F4
	for xfs@oss.sgi.com; Fri, 20 May 2011 02:55:11 +0200
Date: Fri, 20 May 2011 02:55:11 +0200
From: Marc Lehmann <schmorp@schmorp.de>
Subject: drastic changes to allocsize semantics in or around 2.6.38?
Message-ID: <20110520005510.GA15348@schmorp.de>
MIME-Version: 1.0
Content-Disposition: inline
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

Hi!

I have "allocsize=64m" (or simialr sizes, such as 1m, 16m etc.) on many of my
xfs filesystems, in an attempt to fight fragmentation on logfiles.

I am not sure about it's effectiveness, but in 2.6.38 (but not in 2.6.32),
this leads to very unexpected and weird behaviour, namely that files being
written have semi-permanently allocated chunks of allocsize to them.

I realised this when I did a make clean and a make in a buildroot directory,
which cross-compiles uclibc, gcc, and lots of other packages, leading to a
lot of mostly small files.

After a few minutes, the job stopped because it ate 180GB of disk space and
the disk was full. When I came back in the mornng (about 8 hours later), the
disk was still full, and investigation showed that even 3kb files were
allocated the full 64m (as seen with du).

Atfer I deleted some files to get some space and rebooted, I suddenly had
180GB of space again, so it seems an unmount "fixes" this issue.

I often do these kind of build,s and I have allocsize on thee high values for
a very long time, without ever having run into this kind of problem.

It seems that files get temporarily allocated much larger chunks (which is
expoected behaviour), but xfs doesn't free them until there is a unmount
(which is unexpected).

Is this the desired behaviour? I would assume that any allocsize > 0 could
lead to a lot of fragmentation if files that are closed and no longer being
in-use always have extra space allocated for expansion for extremely long
periods of time.

-- 
                The choice of a       Deliantra, the free code+content MORPG
      -----==-     _GNU_              http://www.deliantra.net
      ----==-- _       generation
      ---==---(_)__  __ ____  __      Marc Lehmann
      --==---/ / _ \/ // /\ \/ /      schmorp@schmorp.de
      -=====/_/_//_/\_,_/ /_/\_\

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
