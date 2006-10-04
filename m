Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 04 Oct 2006 11:07:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k94I7haG032704
	for <xfs@oss.sgi.com>; Wed, 4 Oct 2006 11:07:45 -0700
Received: from mail.clusterfs.com (mail.clusterfs.com [206.168.112.78])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CB6BAD178B4B
	for <xfs@oss.sgi.com>; Wed,  4 Oct 2006 09:56:59 -0700 (PDT)
Date: Wed, 4 Oct 2006 10:56:56 -0600
From: Andreas Dilger <adilger@clusterfs.com>
Subject: Directories > 2GB
Message-ID: <20061004165655.GD22010@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

For ext4 we are exploring the possibility of directories being larger
than 2GB in size.  For ext3/ext4 the 2GB limit is about 50M files, and
the 2-level htree limit is about 25M files (this is a kernel code and not
disk format limit).

Amusingly (or not) some users of very large filesystems hit this limit
with their HPC batch jobs because they have 10,000 or 128,000 processes
creating files in a directory on an hourly basis (job restart files,
data dumps for visualization, etc) and it is not always easy to change
the apps.

My question (esp. for XFS folks) is if anyone has looked at this problem
before, and what kind of problems they might have hit in userspace and in
the kernel due to "large" directory sizes (i.e. > 2GB).  It appears at
first glance that 64-bit systems will do OK because off_t is a long
(for telldir output), but that 32-bit systems would need to use O_LARGEFILE
when opening the file in order to be able to read the full directory
contents.  It might also be possible to return -EFBIG only in the case
that telldir is used beyond 2GB (the LFS spec doesn't really talk about
large directories at all).

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
