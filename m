Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MEYMTq089009 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 09:34:22 -0500
Date: Fri, 22 Jul 2011 10:34:20 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, RFC] xfs: rename "linux-2.6" subdirectory to be simply
	"linux"
Message-ID: <20110722143420.GE19681@infradead.org>
References: <201107211804.p6LI4Rvf006075@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201107211804.p6LI4Rvf006075@stout.americas.sgi.com>
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

On Thu, Jul 21, 2011 at 01:04:26PM -0500, Alex Elder wrote:
> Rename the "linux-2.6" platform-specific subdirectory in XFS to just
> be "linux".  This is consistent with the "new" Linux development
> model (regular stable releases rather than the old even/odd cycle
> with long periods between stable releases).  It was also inspired by
> Linus' recent rename of top-level git repository for the Linux code.

Actually it should just go away.  It's a leftover from when we had
code for Linux 2.4 and Linux 2.6 in the same ptools repository.

I was going to suggest near the end of the merge window that we'll
simply apply a big git rename to kill all the subdirectories which
create nothing but pain.  Now that the modular quota options (which
never made it to mainline anyway) is gone there's absolutely no need
for the quota directly, and support/ only has the uuid helpers left,
which are about to get mostly replaced by common code anyway.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
