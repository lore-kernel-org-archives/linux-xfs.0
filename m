Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q81N7Vma194605 for <xfs@oss.sgi.com>; Sat, 1 Sep 2012 18:07:31 -0500
Date: Sat, 1 Sep 2012 19:08:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: flush workers before stopping log
Message-ID: <20120901230824.GB6896@infradead.org>
References: <20120829134624.316257238@sgi.com>
	<20120829134628.835024558@sgi.com> <20120830002335.GB15292@dastard>
	<20120830172549.GG3274@sgi.com> <20120830223504.GE15292@dastard>
	<5040FF25.1010501@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5040FF25.1010501@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Fri, Aug 31, 2012 at 01:15:01PM -0500, Mark Tinguely wrote:
> I see your point on fixing problems in older branches when/if they
> are reported by an user. I am not glowing with pride with the patch,
> it is something that survived a week of testing that would cause a
> panic in a couple hours without the patch. Since we hit this problem
> with such frequency, that we wanted to push for a little proactive
> attention to prevent future panics.

I'd love to see a relatively minimal patch which can also be backported.
I also have to say that your patch as-is scares me a bit.  Everytime we
move the current xfs_sync_init/stop monsters around we created another
set of problems.  So I'd prefer at least taking the bits from Dave's
series that kill these helpers and do individual calls, and only move
those that are needed.   The other thing that I don't like about the
patch is that it causes assymetry in the mount/unmount path by moving
the stop into xfs_unmountfs but not the start into xfs_mountfs.  That
might be needed in some cases, but that should be some detailed comments
explaining why.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
