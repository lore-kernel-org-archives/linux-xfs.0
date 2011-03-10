Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2AHO5gb113568 for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 11:24:15 -0600
Date: Thu, 10 Mar 2011 12:26:45 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfstests: some refinements on "make depend"
Message-ID: <20110310172644.GC13390@infradead.org>
References: <201103041937.p24Jbfh5004820@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201103041937.p24Jbfh5004820@stout.americas.sgi.com>
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

On Fri, Mar 04, 2011 at 01:37:41PM -0600, Alex Elder wrote:
> Make it so "make depend" is a generic target, like "make clean".
> 
> Each Makefile has a "depend" target that indicates whether making
> dependencies means creating ".dep" or creating ".ltdep" (or, I
> suppose, both, though none do that right now).  Both files get
> created even if there are no CFILES to scan (to ensure the target
> up-to-date).  The "default" target now depends on "depend" (there is
> no "ltdepend" any more).
> 
> Remove the "depend" and "ltdepend" definitions from the "buildrules"
> file; only the actual generated files (".dep" and ".ltdep") remain
> as generic targets.  The "depend' target is still defined as phony.
>  
> Do a shell trick when expanding the value of CFILES, to avoid a
> problem that occurs if it is created by "make" by concatentating two
> empty strings.  The problem was that in that case CFILES will
> contain a space, and that wasn't getting treated as empty as
> desired.
> 
> Make the rule for tool/lib dependencies more generic, to reflect the
> general desire that "lib" subdirectories need to be built before
> things in the "tool" subdirectories.

Can we instead port over the generic dependency generation from
xfsprogs/xfsdump?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
