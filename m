Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 May 2007 06:12:04 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l42DBvfB029629
	for <xfs@oss.sgi.com>; Wed, 2 May 2007 06:12:00 -0700
Date: Wed, 2 May 2007 23:11:44 +1000
From: David Chinner <dgc@sgi.com>
Subject: Missing TAKE 958522 (was Re: [Bug 756]  New: File data corruption.....)
Message-ID: <20070502131144.GZ77450368@melbourne.sgi.com>
References: <200705012104.l41L4CI3029767@oss.sgi.com> <20070502105241.GA15399@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502105241.GA15399@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, May 02, 2007 at 12:52:41PM +0200, Christoph Hellwig wrote:
> > Note that a similar issue existed in the 2.6 SGI kernel up until it was resolved
> > by this recent change:
> > http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c.diff?r1=1.258;r2=1.259;f=h
> 
> Seems like someone forgot to send TAKEs to the xfs list once again..

Hmmm - that was a bad one to miss considering the importance of the
problem it fixes......

-----

TAKE 958522 - XFS has conflicting strategies between metadata and file data flushing

Fix to prevent the notorious 'NULL files' problem after a crash.

The problem that has been addressed is that of synchronising updates of
the file size with writes that extend a file.  Without the fix the update
of a file's size, as a result of a write beyond eof, is independent of
when the cached data is flushed to disk.  Often the file size update would
be written to the filesystem log before the data is flushed to disk.  When
a system crashes between these two events and the filesystem log is
replayed on mount the file's size will be set but since the contents never
made it to disk the file is full of holes.  If some of the cached data was
flushed to disk then it may just be a section of the file at the end that
has holes.

There are existing fixes to help alleviate this problem, particularly in
the case where a file has been truncated, that force cached data to be
flushed to disk when the file is closed.  If the system crashes while the
file(s) are still open then this flushing will never occur.

The fix that we have implemented is to introduce a second file size, called
the in-memory file size, that represents the current file size as viewed by
the user.  The existing file size, called the on-disk file size, is the one
that get's written to the filesystem log and we only update it when it is
safe to do so.  When we write to a file beyond eof we only update the in-
memory file size in the write operation.  Later when the I/O operation, that
flushes the cached data to disk completes, an I/O completion routine will
update the on-disk file size.  The on-disk file size will be updated to the
maximum offset of the I/O or to the value of the in-memory file size if the
I/O includes eof.

Date:  Fri Mar 30 02:24:06 AEST 2007
Workarea:  vpn-emea-sw-emea-160-18.emea.sgi.com:/home/lachlan/isms/2.6.x-null
Inspected by:  dgc,tes

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb

Modid:  xfs-linux-melb:xfs-kern:28322a
fs/xfs/xfsidbg.c - 1.312 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.312&r2=text&tr2=1.311&f=h
        - Fix to prevent the notorious 'NULL files' problem after a crash.

fs/xfs/xfs_vnodeops.c - 1.693 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.693&r2=text&tr2=1.692&f=h
        - Fix to prevent the notorious 'NULL files' problem after a crash.

fs/xfs/xfs_iocore.c - 1.52 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iocore.c.diff?r1=text&tr1=1.52&r2=text&tr2=1.51&f=h
        - Fix to prevent the notorious 'NULL files' problem after a crash.

fs/xfs/xfs_inode.c - 1.463 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.463&r2=text&tr2=1.462&f=h
        - Fix to prevent the notorious 'NULL files' problem after a crash.

fs/xfs/xfs_inode.h - 1.219 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.219&r2=text&tr2=1.218&f=h
        - Fix to prevent the notorious 'NULL files' problem after a crash.

fs/xfs/xfs_bmap.c - 1.367 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.367&r2=text&tr2=1.366&f=h
        - Fix to prevent the notorious 'NULL files' problem after a crash.

fs/xfs/xfs_iomap.h - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iomap.h.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
        - Fix to prevent the notorious 'NULL files' problem after a crash.

fs/xfs/xfs_iomap.c - 1.52 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iomap.c.diff?r1=text&tr1=1.52&r2=text&tr2=1.51&f=h
        - Fix to prevent the notorious 'NULL files' problem after a crash.

fs/xfs/linux-2.6/xfs_lrw.c - 1.259 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.c.diff?r1=text&tr1=1.259&r2=text&tr2=1.258&f=h
        - Fix to prevent the notorious 'NULL files' problem after a crash.

fs/xfs/linux-2.6/xfs_aops.c - 1.142 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.142&r2=text&tr2=1.141&f=h
        - Fix to prevent the notorious 'NULL files' problem after a crash.

fs/xfs/dmapi/xfs_dm.c - 1.34 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.34&r2=text&tr2=1.33&f=h
        - Fix to prevent the notorious 'NULL files' problem after a crash.

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
