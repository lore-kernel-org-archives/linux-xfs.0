Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1BB137F3F
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2014 21:19:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0983930408E
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2014 19:19:55 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	DXrPnFIRkr0m6xTu for <xfs@oss.sgi.com>;
	Tue, 19 Aug 2014 19:19:53 -0700 (PDT)
Date: Wed, 20 Aug 2014 12:19:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: don't zero partial page cache pages during
	O_DIRECT
Message-ID: <20140820021950.GU20518@dastard>
References: <53E4E03A.7050101@fb.com> <53E61A9C.4020807@fb.com>
	<20140812011743.GU20518@dastard> <53F3A480.6020000@fb.com>
	<20140819223514.GQ20518@dastard> <53F3FFC6.1070706@fb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53F3FFC6.1070706@fb.com>
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
To: Chris Mason <clm@fb.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On Tue, Aug 19, 2014 at 09:54:14PM -0400, Chris Mason wrote:
> On 08/19/2014 06:35 PM, Dave Chinner wrote:
> > On Tue, Aug 19, 2014 at 03:24:48PM -0400, Chris Mason wrote:
> >> On 08/11/2014 09:17 PM, Dave Chinner wrote:
> >>> On Sat, Aug 09, 2014 at 08:57:00AM -0400, Chris Mason wrote:
> >>>>
> >>>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> >>>> index 1f66779..023d575 100644
> >>>> --- a/fs/xfs/xfs_file.c
> >>>> +++ b/fs/xfs/xfs_file.c
> >>>> @@ -295,7 +295,8 @@ xfs_file_read_iter(
> >>>>  				xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
> >>>>  				return ret;
> >>>>  			}
> >>>> -			truncate_pagecache_range(VFS_I(ip), pos, -1);
> >>>> +			invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
> >>>> +					      pos >> PAGE_CACHE_SHIFT, -1);
> >>>>  		}
> >>>>  		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
> >>>>  	}
> >>>
> >>> I added the WARN_ON_ONCE(ret) check to this and I am seeing it fire
> >>> occasionally. It always fires immediately before some other ASSERT()
> >>> they fires with a block map/page cache inconsistency. It usually
> >>> fires in a test that runs fsx or fsstress. The fsx failures are new
> >>> regressions caused by this patch. e.g. generic/263 hasn't failed for
> >>> months on any of my systems and this patch causes it to fail
> >>> reliably on my 1k block size test config.
> >>>
> >>> I'm going to assume at this point that this is uncovering some other
> >>> existing bug, but it means I'm not going to push this fix until I
> >>> understand what is actually happening here. It is possible that what
> >>> I'm seeing is related to Brian's collapse range bug fixes, but until
> >>> I applied this direct IO patch I'd never seen fsx throw ASSERTs in
> >>> xfs_bmap_shift_extents()....
> >>>
> >>> Either way, more testing and understanding is needed.
> >>
> >> Do you have the output from xfs and the command line args it used?  For
> >> my device, it picks:
> >>
> >> -r 4096 -t 512 -w 512 -Z
> >>
> >> And for a blocksize 1024 test I did mkfs.xfs -b size=1024
> > 
> > I'm running:
> > 
> > $ mkfs.xfs -f -m crc=1,finobt=1 -b size=1k /dev/vda
> > $ mount /dev/vda /mnt/test
> > $ ltp/fsx -o 128000   -l 500000 -r 4096 -t 512 -w 512 -Z -d /mnt/test/foo
> > 
> >> But I can't trigger failures with or without the invalidate_inode_pages2
> >> change.  I was hoping to trigger on 3.16, and then jump back to 3.10 +
> >> my patch to see if the patch alone was at fault.
> > 
> > I am seeing failures at operation 1192.
> > 
> > Yesterday, I found a new class of bufferhead state coherency issues
> > to do with EOF handling that are causing the problems. Basically,
> > when the page cache marks a page dirty, the generic code marks all
> > the buffers on the page dirty, even when they are beyond EOF.
> > 
> > As a result, when we go to invalidate the page that spans EOF, it
> > cannot be invalidated because there are dirty buffers on the page.
> > Those buffers persist in that state because they are beyond EOF,
> > have no blocks allocated to them, and cannot be written. And so when
> > we do a direct IO that spans the current EOF, it now fails to
> > invalidate that page and so triggers the warning.
> > 
> > Worse is that it appears that these bufferheads can leak into the
> > internal blocks into the file when the file is extended, leading to
> > all sorts of other ASSERT failures (which I've been seeing for a
> > while now).
> > 
> > I've got the above fsx command to run for somewhere between 100k and
> > 110k operations with the fixes I currently have, but I haven't found
> > the cause of the dirty buffer beyond EOF state leaking into the
> > interior of the file from extend operations yet.
> > 
> > Once I have something that passes a few million fsx ops....
> 
> I have to admit, I'm not sure where this leaves us in terms of safely
> applying my patch to our 3.10 or mainline kernel... Failing to
> invalidate the page and zeroing the page are really both wrong.

Well, yes they are, and that's one of the reasons why I wanted to
ensure we caught failures. As such, I think this invalidation bug
goes back a *long time* because we've never, ever checked for
invalidation failure before this patch.

However, I think I've got a self-contained fix that can be
backported for the invalidation problem now - it's well past 10
million fsx ops at this point with both read and write DIO
invalidation fixes included. I'll post my series when I've done
some more robust testing on it....

> It feels like this zeroing and cleaning should be happening in truncate,
> but that's because I always blame truncate for fsx bugs.

The problem is the other way around - buffers beyond EOF should
never be marked dirty because they can never be written and hence
never be marked clean in a consistent and sane manner.

> Totally unrelated, but I'll abuse this email thread anyway.  With a pull
> to today's xfstests so I can send my shiny new test, ./check -g auto now
> only runs the btrfs tests and nothing else.

Works just fine for me. Did you reformat you test dev to xfs first?
Do you have stray env vars set?  What does ./setup tell you about
your config? And maybe you can bisect - it was only ~20
commits in the last push.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
