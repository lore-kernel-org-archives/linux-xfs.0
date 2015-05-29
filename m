Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2C5357F47
	for <xfs@oss.sgi.com>; Fri, 29 May 2015 17:37:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 037EE304053
	for <xfs@oss.sgi.com>; Fri, 29 May 2015 15:37:48 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	HRiUFukQ4rDCL9JK for <xfs@oss.sgi.com>;
	Fri, 29 May 2015 15:37:43 -0700 (PDT)
Date: Sat, 30 May 2015 08:37:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: generic/247 triggers warnings occasionally
Message-ID: <20150529223741.GD24666@dastard>
References: <20150529063214.GP3672@dhcp-13-216.nay.redhat.com>
	<20150529151307.GB36053@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150529151307.GB36053@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Eryu Guan <eguan@redhat.com>, xfs@oss.sgi.com

On Fri, May 29, 2015 at 11:13:07AM -0400, Brian Foster wrote:
> On Fri, May 29, 2015 at 02:32:14PM +0800, Eryu Guan wrote:
> > Hi all,
> > 
> > I've seen generic/247 trigger the following warning occasionally, on
> > 4.1.0-rc5 kernel. And I can reproduce it back on 4.0.0 kernel.
> > 
> > [60397.806729] run fstests generic/247 at 2015-05-29 13:19:55
> > [60400.197970] ------------[ cut here ]------------
> > [60400.199285] WARNING: CPU: 1 PID: 13161 at fs/xfs/xfs_file.c:726 xfs_file_dio_aio_write+0x176/0x2a8 [xfs]()
....
> > fs/xfs/xfs_file.c:723
> >    723			ret = invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
> >    724						pos >> PAGE_CACHE_SHIFT,
> >    725						end >> PAGE_CACHE_SHIFT);
> >    726			WARN_ON_ONCE(ret);
> >    727			ret = 0;
> > 
> > It can be reproduced by running generic/247 in loop(usually within 100
> > loops), without any special parameters/options.
> > 
> > 	while ./check generic/247; do : ; done
> > 
> > Attachments are my xfstests config file and host info requested by
> > http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> > 
> 
> I reproduce this fairly regularly as well. The test initializes a file
> with buffered writes and then runs a forward direct I/O writer and a
> reverse mmap writer on the file in parallel. IIRC, the issue here is
> basically the mmap writes racing with the flush/invalidate that occurs
> as part of the dio write sequence. (Indeed, a quick test to acquire
> mmaplock around the flush/invalidate in xfs_file_dio_aio_write() seems
> to confirm).
> 
> I also vaguely recall some discussion with Dave around why we don't do
> this (perhaps during review of the mmaplock bits). If I recall the
> reasoning there, direct I/O in XFS is designed to allow parallel writes
> to the file and thus the exclusive locks are demoted prior to the write.
> This means the mapped write could still race with the DIO and lead to
> whatever resulting inconsistency is possible now. So assuming my
> understanding is correct there, taking the mmap lock across the
> flush/invalidate just ends up hiding a symptom of a problem that isn't
> really solved.

Pretty much - the page fault just needs to happen at a slightly
different time, and we have the same problem just now it's silent
and we don't know about it. It's a data corruption vector, so I'd
much prefer to be noisy and hear about false positives than be
silent and miss it as the cause of a real corruption..

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
