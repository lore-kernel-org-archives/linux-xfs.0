Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jul 2008 12:28:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6TJSlFC031138
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:28:52 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C6F6ECE20B
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:29:59 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 5imATotgBnZq9DtT for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:29:59 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6TJU0IF019123
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 21:30:00 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6TJU0YG019121
	for xfs@oss.sgi.com; Tue, 29 Jul 2008 21:30:00 +0200
Date: Tue, 29 Jul 2008 21:30:00 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 00/21] btree cleanups and unification
Message-ID: <20080729193000.GA19104@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This is the full btree unficiation based on Dave's initial patches plus
various cleanups.  This second versions post now contains the complete
btree refactoring, and passes XFSQA.

The two first patches from the first round have been merged, so they are
not included anymore.  In the reposted patches not much has changed,
only the readahead helpers have been renamed and the tracing infrastructure
has been improved a little.

The real news is the missing btree operations, including all the hairy
ones.  These have been reimplemented looking at the three original
btrees and Daves code, in doubt going with the former.  That means the
small helpers to insert/remove/move records are gone now in favour of
following the original code more closely.  This fixed the one off error
showing up in the intial refactoring.

There's a lot of new comments and empty lines, so by diffstat the new
code isn't all that much smaller:

	36 files changed, 6041 insertions(+), 7128 deletions(-)

but the (debug) binary modules is almost 15kb smaller:

	   text	   data	    bss	    dec	    hex	filename
	 631577	   4227	   3092	 638896	  9bfb0	fs/xfs/xfs.ko.old
	 616929	   4435	   3124	 624488	  98768	fs/xfs/xfs.ko.btree

I have not run any benchmarks yet to see what the performance impact is,
and I still have some ideas to optimize the code.
-- 
