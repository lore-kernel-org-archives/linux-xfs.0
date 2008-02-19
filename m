Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Feb 2008 01:18:17 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1J9I7Gb022926
	for <xfs@OSS.SGI.com>; Tue, 19 Feb 2008 01:18:13 -0800
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 992AA5EFA90
	for <xfs@OSS.SGI.com>; Tue, 19 Feb 2008 01:18:32 -0800 (PST)
Received: from ty.sabi.co.UK ([192.100.78.57]) by cuda.sgi.com with ESMTP id c8HjJZ1c9HpYqump for <xfs@OSS.SGI.com>; Tue, 19 Feb 2008 01:18:32 -0800 (PST)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.66 #1)
	id 1JRNpo-0007KZ-VP
	for <xfs@OSS.SGI.com>; Tue, 19 Feb 2008 08:28:17 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18362.37642.577718.529415@tree.ty.sabi.co.UK>
Date: Tue, 19 Feb 2008 08:27:54 +0000
Subject: Re: tuning, many small files, small blocksize
In-Reply-To: <e03b90ae0802182058h7a1535c6w749eb46cbe434ef2@mail.gmail.com>
References: <e03b90ae0802152101t2bfa4644kcca5d6329239f9ff@mail.gmail.com>
	<47BA10EC.3090004@tlinx.org>
	<20080218235103.GW155407@sgi.com>
	<47BA2AFD.2060409@tlinx.org>
	<20080219024924.GB155407@sgi.com>
	<e03b90ae0802182058h7a1535c6w749eb46cbe434ef2@mail.gmail.com>
From: pg_xf2@xfs2.for.sabi.co.UK (Peter Grandi)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <xfs@oss.sgi.com>

>>> On Mon, 18 Feb 2008 20:58:56 -0800, "Jeff Breidenbach"
>>> <jeff@jab.org> said:

  jeff> I'm testing xfs for use in storing 100 million+ small
  jeff> files (roughly 4 to 10KB each) and some directories will
  jeff> contain tens of thousands of files. There will be a lot
  jeff> of random reading, and also some random writing, and
  jeff> very little deletion. [ ... ]

jeff> [ ... ] am now several days into copying data onto the
jeff> filesystem. [ ... ]

I have found again an exchange about a similarly absurd (but 100
times smaller) setup, and here are two relevant extracts:

  >> I have a little script, the job of which is to create a lot
  >> of very small files (~1 million files, typically ~50-100bytes
  >> each). [ ... ] It's a bit of a one-off (or twice, maybe)
  >> script, and currently due to finish in about 15 hours, hence
  >> why I don't want to spend too much effort on rebuilding the
  >> box. [ ... ]

  > [ ... ] First, I have appended two little Perl scripts (each
  > rather small), one creates a Berkeley DB database of K
  > records of random length varying between I and J bytes, the
  > second does N accesses at random in that database. I have a
  > 1.6GHz Athlon XP with 512MB of memory, and a relatively
  > standard 80GB disc 7200RPM. The database is being created on
  > a 70% full 8GB JFS filesystem which has been somewhat
  > recently created:
  > ----------------------------------------------------------------
  > $  time perl megamake.pl /var/tmp/db 1000000 50 100
  > real    6m28.947s
  > user    0m35.860s
  > sys     0m45.530s
  > ----------------------------------------------------------------
  > $  ls -sd /var/tmp/db*
  > 130604 /var/tmp/db
  > ----------------------------------------------------------------
  > Now after an interval, but without cold start (for good
  > reasons), 100,000 random fetches:
  > ----------------------------------------------------------------
  > $  time perl megafetch.pl /var/tmp/db 1000000 100000
  > average length: 75.00628
  > real    3m3.491s
  > user    0m2.870s
  > sys     0m2.800s
  > ----------------------------------------------------------------
  > So, we got 130MiB of disc space used in a single file, >2500
  > records sustained per second inserted over 6 minutes and a half,
  > 500 records per second sustained over 3 minutes. [ ... ]

So it is less than 400 seconds instead of 15 hours and counting.

Those are the numbers, here are some comments as to what explains
the vast difference (2 orders of magnitude):

  > [ ... ]
  > * With 1,000,000 files and a fanout of 50, we need 20,000
  >   directories above them, 400 above those and 8 above those.
  >   So 3 directory opens/reads every time a file has to be
  >   accessed, in addition to opening and reading the file.
  > * Each file access will involve therefore four inode accesses
  >   and four filesystem block accesses, probably rather widely
  >   scattered. Depending on the size of the filesystem block and
  >   whether the inode is contiguous to the body of the file this
  >   can involve anything between 32KiB and 2KiB of logical IO per
  >   file access.
  > * It is likely that of the logical IOs those relating to the two
  >   top levels (those comprising 8 and 400 directories) of the
  >   subtree will be avoided by caching between 200KiB and 1.6MiB,
  >   but the other two levels, the 20,000 bottom directories and
  >   the 1,000,000 leaf files, won't likely be cached.
  > [ ... ]

[ ... ]

jeff> Finally, in answer to Linda's question, I don't forsee any
jeff> appends at all. The vast majority of files will be write
jeff> once, read many. [ ... ]

That sounds like a good use for a LDAP database, but using
Berkeley DB directly may be best. One could also do a FUSE module
or a special purpose NFS server that presents a Berkeley DB as a
filesystem, but then we would be getting rather close to ReiserFS.
