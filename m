Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBNFuURT247611 for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 09:56:31 -0600
Date: Wed, 23 Dec 2009 10:57:13 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] improve xfsinvutil man page and argument processing
Message-ID: <20091223155713.GB28192@infradead.org>
References: <4B300507.1070502@sgi.com> <20091223133321.GA10982@infradead.org>
	<20091223152057.GA21306@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091223152057.GA21306@sgi.com>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Dec 23, 2009 at 09:20:59AM -0600, Bill Kendall wrote:
> Reposting to fix whitespace issues introduced by mailer.

The patch looks good and applies cleanly now,

Reviewed-by: Christoph Hellwig <hch@lst.de>


Some notes to look into after this patch:

 - can you provide a testcase for the problems caused by the wrong
   time_t usage?  A patch to xfstests would be perfect, but if you
   have a raw testcase I'll vounteer to wire it up.
 - why do we wrap both ctime and ctime_r?  Currently xfsdump isn't
   multithreaded so we shouldn't need it.  But if the parallel
   dump/restore ever gets merged from IRIX we need to get rid of the
   plain ctime calls.  (Btw, are there any plans for the parallel
   dump/restore port?)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
