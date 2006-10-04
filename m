Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 04 Oct 2006 13:34:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k94KYeaG016835
	for <linux-xfs@OSS.SGI.com>; Wed, 4 Oct 2006 13:34:43 -0700
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EE20B46B423
	for <linux-xfs@OSS.SGI.com>; Wed,  4 Oct 2006 12:11:00 -0700 (PDT)
Received: from from [127.0.0.1] (helo=base.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.62 #1)
	id 1GVC8W-00072I-Er
	for <linux-xfs@OSS.SGI.com>; Wed, 04 Oct 2006 20:10:32 +0100
Resent-Message-ID: <17700.1830.717329.976455@base.ty.sabi.co.UK>
Resent-To: linux-xfs@oss.sgi.com
Content-Transfer-Encoding: 7bit
Subject: Re: Directories > 2GB
Date: Wed, 4 Oct 2006 20:09:41 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: pg_xfs@xfs.for.sabi.co.UK (Peter Grandi)
Message-ID: <17700.1781.695334.941154@base.ty.sabi.co.UK>
References: <20061004165655.GD22010@schatzie.adilger.int>
In-Reply-To: <20061004165655.GD22010@schatzie.adilger.int>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andreas Dilger <adilger@clusterfs.com>

>>> On Wed, 4 Oct 2006 10:56:56 -0600, Andreas Dilger
>>> <adilger@clusterfs.com> said:

adilger> For ext4 we are exploring the possibility of
adilger> directories being larger than 2GB in size. For
adilger> ext3/ext4 the 2GB limit is about 50M files, and the
adilger> 2-level htree limit is about 25M files (this is a
adilger> kernel code and not disk format limit).

H-trees here have some serious performance problems:

  http://WWW.sabi.co.UK/Notes/anno05-4th.html#051204

which is perhaps because of poor locality, and I suspect that
large hash trees would suffer from it even more.

adilger> Amusingly (or not) some users of very large filesystems
adilger> hit this limit with their HPC batch jobs because they
adilger> have 10,000 or 128,000 processes creating files in a
adilger> directory on an hourly basis (job restart files, data
adilger> dumps for visualization, etc) and it is not always easy
adilger> to change the apps.

Perhaps the users should be gently introduced to the recent idea
of subdirectories or, if the apps can be changed, the even more
novel and experimental notion of DBMSes... :-). And even if apps
cannot be changed one can always use 'LD_PRELOAD' and ''advise''
the 'open' call suitably...

adilger> [ ... ] but that 32-bit systems would need to use
adilger> O_LARGEFILE when opening the file in order to be able
adilger> to read the full directory contents. It might also be
adilger> possible to return -EFBIG only in the case that telldir
adilger> is used beyond 2GB [ ... ]

Well, in theory apps use 'readdir' and 'getdents' so they should
be immunized from exactly how directories are represented. On my
32 bit system with Fedora with GNU LIBC 2.4 I see:

  $ strace ls /
  [ ... ]
  open("/", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 3
  fstat64(3, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
  fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
  getdents64(3, /* 38 entries */, 4096)   = 1024
  getdents64(3, /* 0 entries */, 4096)    = 0
  close(3)                                = 0
  [ ... ]

and this should give some hope.
