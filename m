Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 454107F58
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 02:09:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 38423304062
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 00:09:21 -0700 (PDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
	[209.85.212.182]) by cuda.sgi.com with ESMTP id
	p7GUCGMIWlaixBuy (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 14 Jul 2014 00:09:16 -0700 (PDT)
Received: by mail-wi0-f182.google.com with SMTP id d1so1969341wiv.9
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 00:09:15 -0700 (PDT)
Received: from teal.hq.k1024.org (178-83-234-80.dynamic.hispeed.ch.
	[178.83.234.80])
	by mx.google.com with ESMTPSA id eo4sm27770782wid.4.2014.07.14.00.09.14
	for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
	Mon, 14 Jul 2014 00:09:14 -0700 (PDT)
Date: Mon, 14 Jul 2014 09:09:13 +0200
From: Iustin Pop <iusty@k1024.org>
Subject: Error setting extent size on a directory
Message-ID: <20140714070913.GA29541@teal.hq.k1024.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

During the restore of a file system, a few directories failed to have
their extent size set:

xfsrestore: WARNING: attempt to set extended attributes (xflags 0x1080,
extsize = 0x800000, projid = 0x0) of a failed: Invalid argument

Since there were just a few, I've set the nodump flag (0x80 in flags
above) manually, which worked, but trying to set the extent size still
fails:
xfs_io .
xfs_io> extsize
[0] .
xfs_io> extsize 8m
xfs_io: XFS_IOC_FSSETXATTR .: Invalid argument

The xfsctl man page says that an extent size should be settable any time
on a directory, so why would this fail? Looking at the kernel sources,
I see a number of possible cases where EINVAL is returned:

- ip->i_d.di_nextents non-zero
- requested extend size bigger than MAXEXTLEN; not the case here
- extsize_fsb > mp->m_sb.sb_agblocks / 2; not the case
- fa->fsx_extsize % size - extent size not a multiple of FS block size;
  again not the case

So to me this reads as if the di_nextents check can also fail for a
directory which has extents, contradicting the man page. Which one needs
to be updated?

The question arises to if the extent size also applies, then, to
allocating extents for a directory - instead of just being inherited for
files (the man page says no).

thanks,
iustin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
