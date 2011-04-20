Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3KEt9c2099522 for <xfs@oss.sgi.com>; Wed, 20 Apr 2011 09:55:09 -0500
Date: Wed, 20 Apr 2011 09:57:22 -0500
From: bpm@sgi.com
Subject: Re: [PATCH] xfs: only SetPageUptodate if all buffers are uptodate
Message-ID: <20110420145722.GB29759@sgi.com>
References: <20110419114028.7844.10303.stgit@nfs3>
	<20110420103521.GA20510@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110420103521.GA20510@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, aelder@sgi.com

Hey Christoph,

On Wed, Apr 20, 2011 at 06:35:21AM -0400, Christoph Hellwig wrote:
> On Tue, Apr 19, 2011 at 06:40:28AM -0500, Ben Myers wrote:
> > xfs_vm_writepage and xfs_page_convert set a page uptodate if it is determined
> > that all of the buffer_heads attached to that page are uptodate.
> > 
> > Currently we use the flag variable 'uptodate'.  The flag is initially set = 1
> > and it is cleared if a !buffer_uptodate buffer is encountered.  In addition we
> > check that bh == head in order to ensure that all of the buffer_heads have been
> > checked.  However, it is possible to break out of the buffer_head loop early
> > having processed only the first buffer.  This leaves uptodate == 1 and bh ==
> > head, so the uptodate bit can be set on a page even if not all of the buffers
> > have been checked.  This can lead to data corruption on platforms with > 1
> > buffer per page.
> 
> Dou have a testcase to reproduce this issue?

Wish I did.  The test case that discovered this only applies to CXFS.  I
would have liked to post a test case for XFS but decided that this has
been on my TODO list for too long already.  Looks to me like it has to
be related to the inode size, so you quit probing buffers after the
first.  Maybe some discussion will ring some bells for somebody.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
