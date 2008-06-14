Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 14 Jun 2008 09:50:34 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5EGoWLO023236
	for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 09:50:32 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AB4CC17C19B6
	for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 09:51:29 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id SVAOuMySlMwL7B98 for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 09:51:29 -0700 (PDT)
Message-ID: <4853F70F.6010400@sandeen.net>
Date: Sat, 14 Jun 2008 11:51:27 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair aborting ... dir2.c:2133
References: <74d4a1e10806140124s3ed8dfa6x7e5ca656fea0e06e@mail.gmail.com>
In-Reply-To: <74d4a1e10806140124s3ed8dfa6x7e5ca656fea0e06e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Paul Guermonprez <paul@guermonprez.eu>
Cc: xfs@oss.sgi.com

Paul Guermonprez wrote:
> hello,
> 
> i have a xfs dump i want to repair under linux ubuntu.
> the partition was created by a storage system ss4000-e.

Do you mean that you did xfsrestore on a previous dump and then tried to
repair the resulting filesystem?  Maybe the dump was corrupt?

> if i use version 2.9.4, i have a segfault
> and version 2.9.8, the proces is aborted with message :
> xfs_repair: dir2.c:2133: process_dir2: Assertion `(ino !=
> mp->m_sb.sb_rootino && ino != *parent) || (ino == mp->m_sb.sb_rootino
> && (ino == *parent || need_root_dotdot == 1))' failed.
> Aborted

If you are willing to provide an xfs_metadump image, Barry would
probably look into it for you :)

Did anything interesting go wrong before your fs got so mangled?

> i also tried to comment this test, but it returns a segfault just as
> version 2.9.4.
> 
> note :
> i already restored 3 xfs dumps from the same machine, and everything
> went in the lost+found, partly with no name, no directory, partly with
> a directory structure and filenames as expected.

xfsrestore did this?  that's pretty weird.

-Eric

> before xfs_repair, the mounted fs was empty, not even the ".." for root !
> 
> thanks, paul.
> 
> 
