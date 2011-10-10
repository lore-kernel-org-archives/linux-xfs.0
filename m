Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9AGYPfB188669 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 11:34:25 -0500
Date: Mon, 10 Oct 2011 12:34:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsdump: update summaries in preparation for release 3.0.6
Message-ID: <20111010163423.GD11902@infradead.org>
References: <201110052210.p95MAXGI012463@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201110052210.p95MAXGI012463@stout.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 05, 2011 at 05:10:33PM -0500, Alex Elder wrote:
> The following is a draft of summaries to be included in the next
> release of xfsdump.

The content looks good, but it's fairly different and much more verbose
style than we traditionally did, which also generally focussed on user
visible changes.

This is how I would have written the log in the "old" style:

xfsdump-3.0.6 (5 October 2011)
	- unconditionally add checksums to various dump headers in
	  xfsdump.
	- verify checksums if present in xfsrestore.
	- use the POSIX signal API instead of the legacy SysV API.
	- various internal cleanups and refactoring in xfsdump and
	  xfsrestore.
	- lift the limit of options in dialogs from 8 to 99.
	- various build system fixes, thanks to Ted Ts'o.

same applies to the other logs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
