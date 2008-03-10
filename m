Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 09 Mar 2008 17:02:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2A02b7V013246
	for <xfs@OSS.SGI.com>; Sun, 9 Mar 2008 17:02:40 -0700
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 81D6D1201019
	for <xfs@OSS.SGI.com>; Sun,  9 Mar 2008 17:03:07 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138]) by cuda.sgi.com with ESMTP id y0hC2ZHKVnGh8vBY for <xfs@OSS.SGI.com>; Sun, 09 Mar 2008 17:03:07 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.66 #1)
	id 1JYVTA-0008LW-Pq
	for <xfs@OSS.SGI.com>; Mon, 10 Mar 2008 00:02:20 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18388.31367.314074.624135@tree.ty.sabi.co.uk>
Date: Mon, 10 Mar 2008 00:02:15 +0000
Subject: Re: xfs for free hosting on linux ? performance questions
In-Reply-To: <47D45926.5070806@gmail.com>
References: <47D45926.5070806@gmail.com>
From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <xfs@oss.sgi.com>

[ ... 

> data will be in many directories, users files are in
> /var/www/users/username and i have more than 100 000
> accounts. also a policy to make max 3 MB files, so most of my
> files are around 50 KB i think.

This is a much better situation than the frequent inane one
where someone asks about using a filesystem as a database for
small records.

But a ''source files'' filesystem is still a bit of challenge.

> [ ... ] mount -o nobarrier,noatime,logbufs=8,logbsize=256k [
> ... ]

Even with backups, 'nobarrier' means begging for trouble.

> [ ... ] number of files 10k, transactions 10k, subdirs 20k,
> was giving very very slow reads, around 200KB/s, while
> reiser4/btrfs were like 2MB/s reads, but even ext3 was faster
> - any idea why? i tested on 2.6.24.3 and 2.6.25-rc4 ) [ ... ] 
> that 3 disks RAID-0 array with tweaked xfs is as fast as just
> one disk with reiser4 (my free hosting with millions of files)
> [ ... ]

Just use the by now very well tested ReiserFS version 3 for
that. Just as you would use XFS for bulk streaming of large
files.

Recently on the same 4x(1+1) RAID10 f2 I did some (single
threaded, single file reading and writing) tests involving
various file systems with both large files (2-12 2GB ones) and a
directory tree contain lots of small Java source files (6.5GB in
50k directories containing 150k files).

While most file systems could reach something like 250MB/s
writing and 430MB/s reading with the small set of large files
(with XFS a few dozen MB/s ahead of most of the others and would
have been more so on multithreaded), on the directory tree
ReiserFS did around 57MB/s, JFS around 36MB/s, and XFS around
20-25MB/s.

There are several reasons why ReiserFS is better suited for
large directory tree with lots of small files; one of them is
that it was designed for that :-).
