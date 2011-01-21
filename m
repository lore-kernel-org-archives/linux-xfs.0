Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0L3dqNu204585 for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 21:39:52 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DB94027B601
	for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 19:42:11 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	gLuAwjcNLdmM8ThF for <xfs@oss.sgi.com>;
	Thu, 20 Jan 2011 19:42:11 -0800 (PST)
Date: Fri, 21 Jan 2011 14:42:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs used disk space bug in 2.6.38-rc1 (commit
	6e857567dbbfe14dd6cc3f7414671b047b1ff5c7)
Message-ID: <20110121034208.GZ16267@dastard>
References: <87zkqvtet2.fsf@sycorax.lbl.gov>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87zkqvtet2.fsf@sycorax.lbl.gov>
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
To: Alex Romosan <romosan@sycorax.lbl.gov>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jan 20, 2011 at 02:01:45PM -0800, Alex Romosan wrote:
> my home directory is using xfs and i noticed that when i try to compile
> a program or do any kind of disk access (like git pull, etc) the amount
> of space used jumps by tens of gigabytes causing the disk to seemingly
> become full (eventually). on reboot the used disk space goes back to the
> correct value. i did a 'git bisect start -- fs/xfs' and i tracked it
> down to commit 6e857567dbbfe14dd6cc3f7414671b047b1ff5c7. if i revert

When you quote a commit, can you please include the name of the
commit. e.g:

6e85756 ("xfs: don't truncate prealloc from frequently accessed inodes")

> this patch then disk usage doesn't increase unexpectedly (i have 270GB
> free and the disk became full by simply trying to compile wine). i can
> try patches if somebody comes up with one.

I don't think you tracked the problem down to the correct commit.
The previous commit:

055388a xfs: dynamic speculative EOF preallocation

Is the one with the known bug that causes excessive preallocation
when files are zero sized. The candidate fix is here:

http://oss.sgi.com/archives/xfs/2011-01/msg00281.html

Can you see if that solves your problem?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
