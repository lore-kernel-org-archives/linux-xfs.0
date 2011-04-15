Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3F85rxK053539 for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 03:05:53 -0500
Date: Fri, 15 Apr 2011 04:09:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: kick inode writeback when low on memory
Message-ID: <20110415080915.GA10619@infradead.org>
References: <1302157196-1988-1-git-send-email-david@fromorbit.com>
	<1302157196-1988-3-git-send-email-david@fromorbit.com>
	<1302726822.2023.128.camel@doink> <20110414050846.GJ21395@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110414050846.GJ21395@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

On Thu, Apr 14, 2011 at 03:08:46PM +1000, Dave Chinner wrote:
> Unfortunately, we simply can't take the s_umount lock in reclaim
> context. So further hackery is going to be required here - I think
> that writeback_inodes_sb_nr_if_idle() need to use trylocks. if the
> s_umount lock is taken in write mode, then it's pretty certain that
> the sb is busy....

http://thread.gmane.org/gmane.linux.file-systems/48373/focus=48628

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
