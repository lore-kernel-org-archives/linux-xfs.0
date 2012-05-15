Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4FMmRxZ223923 for <xfs@oss.sgi.com>; Tue, 15 May 2012 17:48:27 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 35qP50YzhRTlFfnF (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 May 2012 15:48:24 -0700 (PDT)
Date: Wed, 16 May 2012 00:48:05 +0200
From: Jan Kara <jack@suse.cz>
Subject: Hole punching and mmap races
Message-ID: <20120515224805.GA25577@quack.suse.cz>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org, linux-ext4@vger.kernel.org, Hugh Dickins <hughd@google.com>, xfs@oss.sgi.com

  Hello,

  Hugh pointed me to ext4 hole punching code which is clearly missing some
locking. But looking at the code more deeply I realized I don't see
anything preventing the following race in XFS or ext4:

TASK1				TASK2
				punch_hole(file, 0, 4096)
				  filemap_write_and_wait()
				  truncate_pagecache_range()
addr = mmap(file);
addr[0] = 1
  ^^ writeably fault a page
				  remove file blocks

						FLUSHER
						write out file
						  ^^ interesting things can
happen because we expect blocks under the first page to be allocated /
reserved but they are not...

I'm pretty sure ext4 has this problem, I'm not completely sure whether
XFS has something to protect against such race but I don't see anything.

It's not easy to protect against these races. For truncate, i_size protects
us against similar races but for hole punching we don't have any such
mechanism. One way to avoid the race would be to hold mmap_sem while we are
invalidating the page cache and punching hole but that sounds a bit ugly.
Alternatively we could just have some special lock (rwsem?) held during
page_mkwrite() (for reading) and during whole hole punching (for writing)
to serialize these two operations.

Another alternative, which doesn't really look more appealing, is to go
page-by-page and always free corresponding blocks under page lock.

Any other ideas or thoughts?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
