Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 05:22:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7NCMD4p024232
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 05:22:15 -0700
Subject: PARTIAL TAKE 968563 - use filldir internally
Message-Id: <20070823122208.6416058C38F1@chook.melbourne.sgi.com>
Date: Thu, 23 Aug 2007 22:22:08 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

use filldir internally

Currently xfs has a rather complicated internal scheme to allow for
different directory formats in IRIX.  This patch rips all code related
to this out and pushes useage of the Linux filldir callback into the
lowlevel directory code.  This does not make the code any less portable
because filldir can be used to create dirents of all possible variations
(including the IRIX ones as proved by the IRIX binary emulation code
under arch/mips/).

This patch get rid of an unessecary copy in the readdir path, about
400 lines of code and one of the last two users of the uio structure.

This version is updated to deal with dmapi aswell which greatly
simplifies the get_dirattrs code.  The dmapi part has been tested
using the get_dirattrs tools from the xfstest dmapi suite1 with various
small and large directories.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Thu Aug 23 22:21:37 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29478a
fs/xfs/xfs_vnodeops.c - 1.706 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.706&r2=text&tr2=1.705&f=h
	- Use the generic filldir directory formatter callbacks rather than
	  the complex xfs_uio_move based implementation. Removes a copy
	  and simplifies the code greatly.

fs/xfs/xfs_dir2_block.c - 1.56 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_block.c.diff?r1=text&tr1=1.56&r2=text&tr2=1.55&f=h
	- Use the generic filldir directory formatter callbacks rather than
	  the complex xfs_uio_move based implementation. Removes a copy
	  and simplifies the code greatly.

fs/xfs/xfs_dir2_block.h - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_block.h.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
	- Use the generic filldir directory formatter callbacks rather than
	  the complex xfs_uio_move based implementation. Removes a copy
	  and simplifies the code greatly.

fs/xfs/xfs_dir2_sf.h - 1.24 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_sf.h.diff?r1=text&tr1=1.24&r2=text&tr2=1.23&f=h
	- Use the generic filldir directory formatter callbacks rather than
	  the complex xfs_uio_move based implementation. Removes a copy
	  and simplifies the code greatly.

fs/xfs/xfs_dir2_sf.c - 1.48 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_sf.c.diff?r1=text&tr1=1.48&r2=text&tr2=1.47&f=h
	- Use the generic filldir directory formatter callbacks rather than
	  the complex xfs_uio_move based implementation. Removes a copy
	  and simplifies the code greatly.

fs/xfs/xfs_dir2_leaf.c - 1.59 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_leaf.c.diff?r1=text&tr1=1.59&r2=text&tr2=1.58&f=h
	- Use the generic filldir directory formatter callbacks rather than
	  the complex xfs_uio_move based implementation. Removes a copy
	  and simplifies the code greatly.

fs/xfs/xfs_dir2_leaf.h - 1.25 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_leaf.h.diff?r1=text&tr1=1.25&r2=text&tr2=1.24&f=h
	- Use the generic filldir directory formatter callbacks rather than
	  the complex xfs_uio_move based implementation. Removes a copy
	  and simplifies the code greatly.

fs/xfs/xfs_types.h - 1.80 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_types.h.diff?r1=text&tr1=1.80&r2=text&tr2=1.79&f=h
	- Use the generic filldir directory formatter callbacks rather than
	  the complex xfs_uio_move based implementation. Removes a copy
	  and simplifies the code greatly.

fs/xfs/xfs_dir2.h - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2.h.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
	- Use the generic filldir directory formatter callbacks rather than
	  the complex xfs_uio_move based implementation. Removes a copy
	  and simplifies the code greatly.

fs/xfs/xfs_dir2.c - 1.57 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2.c.diff?r1=text&tr1=1.57&r2=text&tr2=1.56&f=h
	- Use the generic filldir directory formatter callbacks rather than
	  the complex xfs_uio_move based implementation. Removes a copy
	  and simplifies the code greatly.

fs/xfs/linux-2.6/xfs_file.c - 1.152 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_file.c.diff?r1=text&tr1=1.152&r2=text&tr2=1.151&f=h
	- Use the generic filldir directory formatter callbacks rather than
	  the complex xfs_uio_move based implementation. Removes a copy
	  and simplifies the code greatly.

fs/xfs/linux-2.6/xfs_vnode.h - 1.129 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.129&r2=text&tr2=1.128&f=h
	- Use the generic filldir directory formatter callbacks rather than
	  the complex xfs_uio_move based implementation. Removes a copy
	  and simplifies the code greatly.

fs/xfs/linux-2.6/xfs_ksyms.c - 1.63 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.63&r2=text&tr2=1.62&f=h
	- Use the generic filldir directory formatter callbacks rather than
	  the complex xfs_uio_move based implementation. Removes a copy
	  and simplifies the code greatly.

fs/xfs/dmapi/xfs_dm.c - 1.43 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.43&r2=text&tr2=1.42&f=h
	- Use the generic filldir directory formatter callbacks rather than
	  the complex xfs_uio_move based implementation. Removes a copy
	  and simplifies the code greatly.
