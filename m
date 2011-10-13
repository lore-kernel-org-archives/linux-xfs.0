Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9DAhV5u166635 for <xfs@oss.sgi.com>; Thu, 13 Oct 2011 05:43:31 -0500
Subject: Re: [PATCH] xfsdump: update summaries in preparation for release 3.0.6
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20111010163423.GD11902@infradead.org>
References: <201110052210.p95MAXGI012463@stout.americas.sgi.com>
	<20111010163423.GD11902@infradead.org>
Date: Thu, 13 Oct 2011 05:43:28 -0500
Message-ID: <1318502608.3172.22.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: xfs@oss.sgi.com

On Mon, 2011-10-10 at 12:34 -0400, Christoph Hellwig wrote:
> On Wed, Oct 05, 2011 at 05:10:33PM -0500, Alex Elder wrote:
> > The following is a draft of summaries to be included in the next
> > release of xfsdump.
> 
> The content looks good, but it's fairly different and much more verbose
> style than we traditionally did, which also generally focussed on user
> visible changes.

This is pretty reasonable feedback and I guess not a
surprise to me.  I was sort of throwing these together
at the end of a long day and didn't really distill them
down before sending them out.

I'll take another pass at all of them and will re-post.
Thanks.

					-Alex

> This is how I would have written the log in the "old" style:
> 
> xfsdump-3.0.6 (5 October 2011)
> 	- unconditionally add checksums to various dump headers in
> 	  xfsdump.
> 	- verify checksums if present in xfsrestore.
> 	- use the POSIX signal API instead of the legacy SysV API.
> 	- various internal cleanups and refactoring in xfsdump and
> 	  xfsrestore.
> 	- lift the limit of options in dialogs from 8 to 99.
> 	- various build system fixes, thanks to Ted Ts'o.
> 
> same applies to the other logs.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
