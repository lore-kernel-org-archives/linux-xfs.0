Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 08 Jul 2007 22:09:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6959FtL013881
	for <xfs@oss.sgi.com>; Sun, 8 Jul 2007 22:09:17 -0700
Subject: PARTIAL TAKE 964469 -  XFS Concurrent Multi-File Data Streams
Message-Id: <20070709050912.53EE758C38F1@chook.melbourne.sgi.com>
Date: Mon,  9 Jul 2007 15:09:12 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Concurrent Multi-File Data Streams

In media spaces, video is often stored in a frame-per-file format.
When dealing with uncompressed realtime HD video streams in this format,
it is crucial that files do not get fragmented and that multiple files
a placed contiguously on disk.

When multiple streams are being ingested and played out at the same
time, it is critical that the filesystem does not cross the streams
and interleave them together as this creates seek and readahead
cache miss latency and prevents both ingest and playout from meeting
frame rate targets.

This patch set creates a "stream of files" concept into the allocator
to place all the data from a single stream contiguously on disk so
that RAID array readahead can be used effectively. Each additional
stream gets placed in different allocation groups within the
filesystem, thereby ensuring that we don't cross any streams. When
an AG fills up, we select a new AG for the stream that is not in
use.

The core of the functionality is the stream tracking - each inode
that we create in a directory needs to be associated with the
directories' stream. Hence every time we create a file, we look up
the directories' stream object and associate the new file with that
object.

Once we have a stream object for a file, we use the AG that the
stream object point to for allocations. If we can't allocate in that
AG (e.g. it is full) we move the entire stream to another AG. Other
inodes in the same stream are moved to the new AG on their next
allocation (i.e. lazy update).

Stream objects are kept in a cache and hold a reference on the
inode. Hence the inode cannot be reclaimed while there is an
outstanding stream reference. This means that on unlink we need to
remove the stream association and we also need to flush all the
associations on certain events that want to reclaim all unreferenced
inodes (e.g.  filesystem freeze).

Date:  Mon Jul  9 15:08:16 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  tes@sgi.com,hch@lst.de,donaldd@sgi.com,bnaujok@sgi.com,vapo@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29096a
fs/xfs/xfs_filestream.h - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_filestream.h
	- Concurrent Multi-File Data Streams feature check in.

fs/xfs/xfs_mru_cache.h - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mru_cache.h
	- Concurrent Multi-File Data Streams feature check in.

fs/xfs/xfs_mru_cache.c - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mru_cache.c
	- Concurrent Multi-File Data Streams feature check in.

fs/xfs/xfs_filestream.c - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_filestream.c
	- Concurrent Multi-File Data Streams feature check in.

fs/xfs/xfsidbg.c - 1.316 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.316&r2=text&tr2=1.315&f=h
	- Concurrent Multi-File Data Streams feature check in.

fs/xfs/xfs_ag.h - 1.60 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ag.h.diff?r1=text&tr1=1.60&r2=text&tr2=1.59&f=h
	- Concurrent Multi-File Data Streams feature check in.

fs/xfs/xfs.h - 1.49 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs.h.diff?r1=text&tr1=1.49&r2=text&tr2=1.48&f=h
	- Concurrent Multi-File Data Streams feature check in.

fs/xfs/xfs_vnodeops.c - 1.702 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.702&r2=text&tr2=1.701&f=h
	- Concurrent Multi-File Data Streams feature check in.

fs/xfs/xfs_fs.h - 1.34 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fs.h.diff?r1=text&tr1=1.34&r2=text&tr2=1.33&f=h
	- Concurrent Multi-File Data Streams feature check in.

fs/xfs/xfs_vfsops.c - 1.522 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.522&r2=text&tr2=1.521&f=h
	- Concurrent Multi-File Data Streams feature check in.

fs/xfs/xfs_clnt.h - 1.55 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_clnt.h.diff?r1=text&tr1=1.55&r2=text&tr2=1.54&f=h
	- Concurrent Multi-File Data Streams feature check in.

fs/xfs/xfs_mount.h - 1.237 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.237&r2=text&tr2=1.236&f=h
	- Concurrent Multi-File Data Streams feature check in.

fs/xfs/xfs_inode.c - 1.465 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.465&r2=text&tr2=1.464&f=h
	- Concurrent Multi-File Data Streams feature check in.

fs/xfs/xfs_inode.h - 1.222 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.222&r2=text&tr2=1.221&f=h
	- Concurrent Multi-File Data Streams feature check in.

fs/xfs/xfs_fsops.c - 1.127 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fsops.c.diff?r1=text&tr1=1.127&r2=text&tr2=1.126&f=h
	- Concurrent Multi-File Data Streams feature check in.

fs/xfs/xfs_bmap.c - 1.371 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.371&r2=text&tr2=1.370&f=h
	- Concurrent Multi-File Data Streams feature check in.

fs/xfs/xfs_dinode.h - 1.81 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dinode.h.diff?r1=text&tr1=1.81&r2=text&tr2=1.80&f=h
	- Concurrent Multi-File Data Streams feature check in.

fs/xfs/Makefile-linux-2.6 - 1.207 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/Makefile-linux-2.6.diff?r1=text&tr1=1.207&r2=text&tr2=1.206&f=h
	- Concurrent Multi-File Data Streams feature check in.

fs/xfs/linux-2.6/xfs_globals.c - 1.70 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_globals.c.diff?r1=text&tr1=1.70&r2=text&tr2=1.69&f=h
	- Concurrent Multi-File Data Streams feature check in.

fs/xfs/linux-2.6/xfs_linux.h - 1.154 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_linux.h.diff?r1=text&tr1=1.154&r2=text&tr2=1.153&f=h
	- Concurrent Multi-File Data Streams feature check in.

fs/xfs/linux-2.6/xfs_sysctl.c - 1.42 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sysctl.c.diff?r1=text&tr1=1.42&r2=text&tr2=1.41&f=h
	- Concurrent Multi-File Data Streams feature check in.

fs/xfs/linux-2.6/xfs_sysctl.h - 1.27 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sysctl.h.diff?r1=text&tr1=1.27&r2=text&tr2=1.26&f=h
	- Concurrent Multi-File Data Streams feature check in.
