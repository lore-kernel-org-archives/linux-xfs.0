Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p97BgYgR064297 for <xfs@oss.sgi.com>; Fri, 7 Oct 2011 06:42:34 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	pLRA6FVQV9rYZeHb for <xfs@oss.sgi.com>;
	Sun, 15 Jan 2012 15:58:01 -0800 (PST)
Date: Mon, 16 Jan 2012 10:57:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: working on extent locks for i_mutex
Message-ID: <20120115235747.GA6922@dastard>
References: <4F0F9E97.1090403@linux.vnet.ibm.com>
	<20120113043411.GH2806@dastard>
	<4F10992C.3070303@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F10992C.3070303@linux.vnet.ibm.com>
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

On Fri, Jan 13, 2012 at 01:50:52PM -0700, Allison Henderson wrote:
> On 01/12/2012 09:34 PM, Dave Chinner wrote:
> >On Thu, Jan 12, 2012 at 08:01:43PM -0700, Allison Henderson wrote:
> >>Hi All,
> >>
> >>I know this is an old topic, but I am poking it again because I've
> >>had some work items wrap up, and Im planning on picking up on this
> >>one again.  I am thinking about implementing extent locks to replace
> >>i_mutex.  So I just wanted to touch base with folks and see what
> >>people are working on because I know there were some folks out there
> >>that were thing about doing similar solutions.
> >
> >What locking API are you looking at? If you are looking at an
> >something like:
> >
> >read_range_{try}lock(lock, off, len)
> >read_range_unlock(lock, off, len)
> >write_range_{try}lock(lock, off, len)
> >write_range_unlock(lock, off, len)
> >
> >and implementing with an rbtree or a btree for tracking, then I
> >definitely have a use for it in XFS - replacing the current rwsem
> >that is used for the iolock. Range locks like this are the only
> >thing we need to allow concurrent buffered writes to the same file
> >to maintain the per-write exclusion that posix requires.
> 
> Yes that is generally the idea I was thinking about doing, but at
> the time, I was not thinking outside the scope of ext4.  You are
> thinking maybe it should be in vfs layer so that it's something that
> all the filesystems will use?  That seems to be the impression I'm
> getting from folks.  Thx!

Yes, that's what I'm suggesting. Not so much a vfs layer function,
but a library (range locks could be useful outside filesystems) so
locating it in lib/ was what I was thinking....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
