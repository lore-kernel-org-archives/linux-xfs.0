Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 07C787F4E
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 16:08:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8E9DAAC003
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 14:08:45 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	9JBeZm1TEs13qwCu for <xfs@oss.sgi.com>;
	Mon, 10 Mar 2014 14:08:40 -0700 (PDT)
Date: Tue, 11 Mar 2014 08:08:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [3.14-rc5 xfs] Lockdep warning
Message-ID: <20140310210837.GZ6851@dastard>
References: <201403101955.AAI04114.QJOFFFtHMSOLOV@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201403101955.AAI04114.QJOFFFtHMSOLOV@I-love.SAKURA.ne.jp>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Mar 10, 2014 at 07:55:19PM +0900, Tetsuo Handa wrote:
> I get below lockdep warning as of 1dc3217d on linux.git. I guess the situation
> is same as of v3.14-rc6 because there is no changes in fs/xfs directory between
> 1dc3217d and v3.14-rc6.

False positive.  Lockdep is complaining about having different page
fault lock heirarchies for regular files versus directories. It's
too stupid to understand that the directory and regular inodes have
differnet lock classes and so therefore this:

> [   96.098894]  Possible unsafe locking scenario:
> 
> [   96.099795]        CPU0                    CPU1
> [   96.100234]        ----                    ----
> [   96.100666]   lock(&(&ip->i_lock)->mr_lock);
> [   96.101158]                                lock(&mm->mmap_sem);
> [   96.101597]                                lock(&(&ip->i_lock)->mr_lock);
> [   96.102030]   lock(&mm->mmap_sem);

is impossible, because what it really is:

	CPU0			CPU1
	ilock (IS_DIR)
				lock(mmap_sem)
				ilock(IS_REG)
	lock(mmap_sem)

cannot deadlock because there two different inode locks involved
here.

So, to shut lockdep up, we've got to fundamentally alter the locking
strategy. The current code is not broken, but we've now got to jump
throw complex hoops to make the locking validator understand that
it's not broken. This is a great example of how lockdep can be
considered harmful....

Solutions being discussed in this thread:

http://oss.sgi.com/pipermail/xfs/2014-March/034815.html

> Also, the culprit commits were already backported to
> RHEL7 beta somewhere between 3.10.0-90.el7 and 3.10.0-97.el7 .

That should already be sorted out. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
