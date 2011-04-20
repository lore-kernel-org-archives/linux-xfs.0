Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3KAVssg089445 for <xfs@oss.sgi.com>; Wed, 20 Apr 2011 05:31:56 -0500
Date: Wed, 20 Apr 2011 06:35:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: only SetPageUptodate if all buffers are uptodate
Message-ID: <20110420103521.GA20510@infradead.org>
References: <20110419114028.7844.10303.stgit@nfs3>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110419114028.7844.10303.stgit@nfs3>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com, aelder@sgi.com

On Tue, Apr 19, 2011 at 06:40:28AM -0500, Ben Myers wrote:
> xfs_vm_writepage and xfs_page_convert set a page uptodate if it is determined
> that all of the buffer_heads attached to that page are uptodate.
> 
> Currently we use the flag variable 'uptodate'.  The flag is initially set = 1
> and it is cleared if a !buffer_uptodate buffer is encountered.  In addition we
> check that bh == head in order to ensure that all of the buffer_heads have been
> checked.  However, it is possible to break out of the buffer_head loop early
> having processed only the first buffer.  This leaves uptodate == 1 and bh ==
> head, so the uptodate bit can be set on a page even if not all of the buffers
> have been checked.  This can lead to data corruption on platforms with > 1
> buffer per page.

Dou have a testcase to reproduce this issue?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
