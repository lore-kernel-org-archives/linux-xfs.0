Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 14 Jun 2008 01:23:43 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5E8NgAd008236
	for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 01:23:42 -0700
Received: from fk-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5CB2322F5D9
	for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 01:24:38 -0700 (PDT)
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.191]) by cuda.sgi.com with ESMTP id XipLm9DejwmluhGG for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 01:24:38 -0700 (PDT)
Received: by fk-out-0910.google.com with SMTP id 26so2841356fkx.4
        for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 01:24:37 -0700 (PDT)
Message-ID: <74d4a1e10806140124s3ed8dfa6x7e5ca656fea0e06e@mail.gmail.com>
Date: Sat, 14 Jun 2008 10:24:37 +0200
From: "Paul Guermonprez" <paul@guermonprez.eu>
Subject: xfs_repair aborting ... dir2.c:2133
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

hello,

i have a xfs dump i want to repair under linux ubuntu.
the partition was created by a storage system ss4000-e.

if i use version 2.9.4, i have a segfault
and version 2.9.8, the proces is aborted with message :
xfs_repair: dir2.c:2133: process_dir2: Assertion `(ino !=
mp->m_sb.sb_rootino && ino != *parent) || (ino == mp->m_sb.sb_rootino
&& (ino == *parent || need_root_dotdot == 1))' failed.
Aborted

i also tried to comment this test, but it returns a segfault just as
version 2.9.4.

note :
i already restored 3 xfs dumps from the same machine, and everything
went in the lost+found, partly with no name, no directory, partly with
a directory structure and filenames as expected.
before xfs_repair, the mounted fs was empty, not even the ".." for root !

thanks, paul.
