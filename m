Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3KFWlRM101734 for <xfs@oss.sgi.com>; Wed, 20 Apr 2011 10:32:47 -0500
Date: Wed, 20 Apr 2011 11:36:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: only SetPageUptodate if all buffers are uptodate
Message-ID: <20110420153614.GA11362@infradead.org>
References: <20110419114028.7844.10303.stgit@nfs3>
	<20110420103521.GA20510@infradead.org>
	<20110420145722.GB29759@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110420145722.GB29759@sgi.com>
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
To: bpm@sgi.com
Cc: aelder@sgi.com, xfs@oss.sgi.com

On Wed, Apr 20, 2011 at 09:57:22AM -0500, bpm@sgi.com wrote:
> Wish I did.  The test case that discovered this only applies to CXFS.  I
> would have liked to post a test case for XFS but decided that this has
> been on my TODO list for too long already.  Looks to me like it has to
> be related to the inode size, so you quit probing buffers after the
> first.  Maybe some discussion will ring some bells for somebody.

It would be really good to have one, but the actual patch looks good
enough that I'd consider putting it in.  I can assumes you ran
xfstests with various small blocksize options for both the test
and scratch device and it didn't show any regressions?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
