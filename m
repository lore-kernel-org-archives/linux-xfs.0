Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8C10kDE234695 for <xfs@oss.sgi.com>; Sat, 11 Sep 2010 20:00:46 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C5DE317DABCE
	for <xfs@oss.sgi.com>; Sat, 11 Sep 2010 18:01:31 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	m8YY4nu6hfysshJo for <xfs@oss.sgi.com>;
	Sat, 11 Sep 2010 18:01:31 -0700 (PDT)
Date: Sun, 12 Sep 2010 11:01:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS defragmentation issue
Message-ID: <20100912010127.GA411@dastard>
References: <4C8A4395.5070702@kickstone.com> <4C8B27E4.2050102@kickstone.com>
	<20100911082330.GG705@dastard> <4C8BDAC8.8010203@hardwarefreak.com>
	<20100911195702.GB25185@teal.hq.k1024.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100911195702.GB25185@teal.hq.k1024.org>
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
To: Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

On Sat, Sep 11, 2010 at 09:57:02PM +0200, Iustin Pop wrote:
> On Sat, Sep 11, 2010 at 02:38:48PM -0500, Stan Hoeppner wrote:
> > Dave Chinner put forth on 9/11/2010 3:23 AM:
> > > On Sat, Sep 11, 2010 at 07:55:32AM +0100, John Lister wrote:
> > >>  Stan Hoeppner wrote on 9/10/2010 14:00
> > >>>> On 10/09/2010 15:41, John Lister wrote:
> > >>> Try unmounting and remounting the filesystem, and see if the various
> > >>> tools all report the same thing afterwards. This solved the exact same
> > >>> problem for me very recently, though I'm on kernel 2.6.34.1 and xfsprogs
> > >>> 2.9.8.
> > >>
> > >> Cheers, that got rid of most of it, there is still a slight
> > >> discrepency  (50 extra fragments) which I can live with.
> > > 
> > > xfs_db used buffered IO on the block device, which is not coherent
> > > with the filesystem. If you are using it on an active filesystem,
> > > then running "echo 1 > /proc/sys/vm/drop_caches" before you run
> > > xfs_db should make it read from disk at least once....
> 
> I wonder if xfs_db shouldn't use by default direct I/O, or at least take
> a flag to allow it to do direct I/O only against the blocks it needs.
> Dropping the entire caches on a big box is not nice :)

True - I need to look at whether posix_fadvise(POSIX_FADV_DONTNEED)
will clear the bdev pages, and if so that is the easiest solution.
Rewriting xfs_db to use direct IO is a pretty major undertaking...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
