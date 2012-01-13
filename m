Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0D4YFJ3069721 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 22:34:16 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	XInSLlfHSctchxPs for <xfs@oss.sgi.com>;
	Thu, 12 Jan 2012 20:34:14 -0800 (PST)
Date: Fri, 13 Jan 2012 15:34:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: working on extent locks for i_mutex
Message-ID: <20120113043411.GH2806@dastard>
References: <4F0F9E97.1090403@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F0F9E97.1090403@linux.vnet.ibm.com>
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
To: Allison Henderson <achender@linux.vnet.ibm.com>
Cc: Lukas Czerner <lczerner@redhat.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Jan 12, 2012 at 08:01:43PM -0700, Allison Henderson wrote:
> Hi All,
> 
> I know this is an old topic, but I am poking it again because I've
> had some work items wrap up, and Im planning on picking up on this
> one again.  I am thinking about implementing extent locks to replace
> i_mutex.  So I just wanted to touch base with folks and see what
> people are working on because I know there were some folks out there
> that were thing about doing similar solutions.

What locking API are you looking at? If you are looking at an
something like:

read_range_{try}lock(lock, off, len)
read_range_unlock(lock, off, len)
write_range_{try}lock(lock, off, len)
write_range_unlock(lock, off, len)

and implementing with an rbtree or a btree for tracking, then I
definitely have a use for it in XFS - replacing the current rwsem
that is used for the iolock. Range locks like this are the only
thing we need to allow concurrent buffered writes to the same file
to maintain the per-write exclusion that posix requires.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
