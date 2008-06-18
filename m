Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jun 2008 07:44:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5IEildJ028593
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 07:44:48 -0700
Received: from zen.pimp.org.za (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1BE24CE5990
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 07:45:43 -0700 (PDT)
Received: from zen.pimp.org.za (zen.pimp.org.za [70.85.31.111]) by cuda.sgi.com with ESMTP id dp6awqqCybI9fBUY for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 07:45:43 -0700 (PDT)
Received: from area51.pimp.org.za (87-194-135-198.bethere.co.uk [87.194.135.198])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "mail-gateway.pimp.org.za", Issuer "Certificate Authority" (verified OK))
	by zen.pimp.org.za (Postfix) with ESMTP id 3A6B143A4
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 15:45:43 +0100 (BST)
Received: from aurora.pimp.org.za (aurora.pimp.org.za [192.168.1.6])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by area51.pimp.org.za (Postfix) with ESMTPS id 1F94A34846
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 15:45:24 +0100 (BST)
Received: from localhost (localhost [127.0.0.1])
	by aurora.pimp.org.za (Postfix) with ESMTP id 5F9C234833
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 15:45:40 +0100 (BST)
Received: from aurora.pimp.org.za ([127.0.0.1])
	by localhost (aurora.pimp.org.za [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9wwEG3agfpDE for <xfs@oss.sgi.com>;
	Wed, 18 Jun 2008 15:45:34 +0100 (BST)
Date: Wed, 18 Jun 2008 15:45:34 +0100
From: Michael-John Turner <mj@mjturner.net>
Subject: Directory mtime update issue (kernel 2.6.25)
Message-ID: <20080618144534.GC11301@aurora.pimp.org.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi all,

I'm a recent convert to XFS and am experiencing something that I consider
rather odd. When I move a directory on the same filesystem, XFS updates the
directory's mtime, which is something I wouldn't expect to happen. I tested
the same set of commands on a tmpfs filesystem and the renamed directory's
mtime doesn't change. Similarly, when I move a file between directories on
an XFS filesystem, the file's mtime doesn't change (as expected).

Is this behaviour correct? I'm running Linux kernel 2.6.25.6 on an x86_64
system, filesystem mounted with the standard options (see below).

For example (~ and ~/tmp are the same filesystem, /home):

[0] mj@majestic:~/tmp$ mount |grep home
/dev/mapper/data-home on /home type xfs (rw)
[0] mj@majestic:~/tmp$ mkdir test
[0] mj@majestic:~/tmp$ ls -ld test
drwxr-sr-x 2 mj mj 6 Jun 18 15:28 test
[0] mj@majestic:~/tmp$ touch -t 200801011530 test
[0] mj@majestic:~/tmp$ ls -ld test
drwxr-sr-x 2 mj mj 6 Jan  1 15:30 test
[0] mj@majestic:~/tmp$ stat test
  File: `test'
  Size: 6               Blocks: 0          IO Block: 4096   directory
Device: fd00h/64768d    Inode: 951267331   Links: 2
Access: (2755/drwxr-sr-x)  Uid: ( 1000/      mj)   Gid: ( 1000/      mj)
Access: 2008-01-01 15:30:00.000000000 +0000
Modify: 2008-01-01 15:30:00.000000000 +0000
Change: 2008-06-18 15:29:08.173750666 +0100
[0] mj@majestic:~/tmp$ mv test test1
[0] mj@majestic:~/tmp$ ls -ld test1
drwxr-sr-x 2 mj mj 6 Jan  1 15:30 test1
[0] mj@majestic:~/tmp$ mv test1 ..
[0] mj@majestic:~/tmp$ ls -ld ../test1
drwxr-sr-x 2 mj mj 6 Jun 18 15:30 ../test1
  File: `../test1'
  Size: 6               Blocks: 0          IO Block: 4096   directory
Device: fd00h/64768d    Inode: 951267331   Links: 2
Access: (2755/drwxr-sr-x)  Uid: ( 1000/      mj)   Gid: ( 1000/      mj)
Access: 2008-01-01 15:30:00.000000000 +0000
Modify: 2008-06-18 15:30:02.814078187 +0100
Change: 2008-06-18 15:30:02.814078187 +0100

-mj
-- 
Michael-John Turner 
mj@mjturner.net      <>  http://mjturner.net/
