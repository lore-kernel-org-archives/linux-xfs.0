Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 May 2007 11:35:08 -0700 (PDT)
Received: from tur.go2.pl (tur.go2.pl [193.17.41.50])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l47IZ0fB008787
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 11:35:02 -0700
Received: from poczta.o2.pl (mx10.go2.pl [193.17.41.74])
	by tur.go2.pl (o2.pl Mailer 2.0.1) with ESMTP id CF0912349DA
	for <xfs@oss.sgi.com>; Mon,  7 May 2007 20:04:28 +0200 (CEST)
Received: from poczta.o2.pl (mx10.go2.pl [127.0.0.1])
	by poczta.o2.pl (Postfix) with ESMTP id 07A2C58113
	for <xfs@oss.sgi.com>; Mon,  7 May 2007 20:04:26 +0200 (CEST)
Received: from lucke.localnet (xdsl-7687.bielsko.dialog.net.pl [62.87.234.135])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by poczta.o2.pl (Postfix) with ESMTP
	for <xfs@oss.sgi.com>; Mon,  7 May 2007 20:04:25 +0200 (CEST)
From: =?utf-8?q?=C5=81ukasz_Fibinger?= <lucke@o2.pl>
Reply-To: lucke@o2.pl
Subject: RESVSP problems
Date: Mon, 7 May 2007 20:04:22 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705072004.22848.lucke@o2.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello, guys,

I've been trying to implement RESVSP-based allocation in rtorrent. From the 
very beginning it has, alas, misbehaved, thus (also considering my very basic 
programming skills and experience and unfamiliarity with rtorrent's code) 
after hours of trying to determine what's wrong, I finally observed that 
blocks of files allocated with RESVSP (previously ftruncated to a proper 
size) and being downloaded in rtorrent don't have their unwritten flags 
removed (as confirmed by xfs_bmap -vp). In the effect downloaded file 
promptly corrupts (read: changes its md5sum). What is interesting, files 
RESVSP-allocated in ktorrent and then imported to rtorrent seem to download 
properly.

Everything works properly with ALLOCSP (although I've noticed that while 
RESVSP worked with l_start = 0 and l_length = size, ALLOCSP worked with 
l_start = size and l_length = 0; is that intended?).

I'm not quite sure what's at fault here. Perhaps rtorrent, as it prides itself 
on "directly between file pages mapped to memory by the mmap() function and 
the network stack". I haven't been yet able to determine how it actually 
writes chunks to files (aforementioned lacks of skills, experience and 
familiarity). Perhaps it's somehow XFS's fault, hence my posting to this ML. 
Any help/suggestions would be appreciated.

Cheers,

Luke
