Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7DC2E7CA0
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 15:35:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EEC2CAC004
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 13:35:14 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id iZBkLjJr9BX81kvt (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 08 Sep 2016 13:35:12 -0700 (PDT)
Date: Thu, 8 Sep 2016 21:35:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
	detected
Message-ID: <20160908203505.GI2356@ZenIV.linux.org.uk>
References: <723420070.1340881.1472835555274.JavaMail.zimbra@redhat.com>
	<1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com>
	<20160903003919.GI30056@dastard>
	<CA+55aFy17iuUYRSLO=e1e+W5oW8GRYy93myk816UjRgEFxQDOw@mail.gmail.com>
	<20160903014514.GB2356@ZenIV.linux.org.uk>
	<20160906235917.GO30056@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160906235917.GO30056@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, CAI Qian <caiqian@redhat.com>, xfs@oss.sgi.com

On Wed, Sep 07, 2016 at 09:59:17AM +1000, Dave Chinner wrote:

> Not sure I quite follow - where do the pages come from? Do we
> allocate new pages that get put into the bvec, then run the read
> which copies data from the page cache page into them, then hand
> those pages in the bvec to the pipe?

Nope.  generic_file_read_iter() (do_generic_file_read(), in the end)
finds them in page cache, or allocates and sticks them into pagecache,
makes sure that they are uptodate, etc.   And passes them to
copy_page_to_iter(), which would, for this iov_iter flavour, just grab
a reference to page and stash it into bvec.  There's your zero-copy,
exactly as it works now.  Only __generic_file_splice_read() open-codes
everything ->read_iter() would do, sans the locks filesystem would need.

> This has the same "data copy in the splice read path" as the above
> interface. However, I suspect that this interface could actually be
> used for zero copy (by stealing pages from the page cache rather
> than allocating new pages and copying), so it may be a better way to
> proceed...

For copy_page_to_iter() we have a page; for copy_to_iter() the data comes
from hell knows what - kmalloc'ed array into which we'd decrypted something,
results of sprintf() into on-stack array, etc.  So the counterparts of
copy_to_iter() callers must be non-zerocopy.  copy_page_to_iter() is the
potential zerocopy path and we do get zerocopy there that way.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
