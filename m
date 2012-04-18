Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3I91h7g172650 for <xfs@oss.sgi.com>; Wed, 18 Apr 2012 04:01:43 -0500
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id 0kT7c5WQhESU1Shr for
	<xfs@oss.sgi.com>; Wed, 18 Apr 2012 02:01:41 -0700 (PDT)
Date: Wed, 18 Apr 2012 10:00:51 +0100
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Fragmentation Issue We Are Having
Message-ID: <20120418090051.GA14814@nsrc.org>
References: <CADrkzimg891ZBGK7-UzhGeey16KwH-ZXpEqFr=O3KwD3qA9LwQ@mail.gmail.com>
	<20120412075747.GB30891@nsrc.org>
	<CADrkzi=JNsbXJHkcb=oOZHLEYMBDUkNHu9O8JFT9h+kSArL47A@mail.gmail.com>
	<20120413071905.GA823@nsrc.org> <20120413075634.GD6734@dastard>
	<20120413081725.GA3640@nsrc.org> <20120417002610.GC6734@dastard>
	<20120417085828.GA13168@nsrc.org> <20120418013607.GK6734@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120418013607.GK6734@dastard>
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
Cc: David Fuller <dfuller@epoch.com>, xfs@oss.sgi.com

On Wed, Apr 18, 2012 at 11:36:07AM +1000, Dave Chinner wrote:
> And it assumes that inode32 cannot do locality of
> files at all, when in fact it has tunable locality through a syctl.
> 
> Indeed, here's some the performance enhancing games SGI play that
> can only be achieved by using the inode32 allocator:
> 
> http://techpubs.sgi.com/library/tpl/cgi-bin/getdoc.cgi?coll=linux&db=bks&fname=/SGI_Admin/LX_XFS_AG/ch07.html

Ah, that's new to me. So with inode32 and
  sysctl fs.xfs.rotorstep=255
you can get roughly the same locality benefit for sequentially-written files
as inode64?  (Aside: if you have two processes writing files to two different
directories, will they end up mixing their files in the same AG? That
could hurt performance at readback time if reading them sequentially)

I'm not really complaining about anything here except the dearth of
readily-accessible information. If I download the whole admin book:
http://techpubs.sgi.com/library/manuals/4000/007-4273-004/pdf/007-4273-004.pdf
I see the option inode64 only mentioned once in passing (as being
incompatible with ibound). So if there's detailled information on
what exactly inode64 does and when to use it, it must be somewhere else.

Here's my user story. As a newbie, my first test was to make a 3TB
filesystem on a single drive, and I was doing a simple workload consisting
of writing 1000 files per directory sequentially.  I could achieve a
sequential write speed of 75MB/s but only a sequential read speed of 25MB/s. 
After questioning this on the list and eventually finding that files were
scattered around the disk (thanks to xfs_bmap).  I was pointed to the
inode64 option, which I had seen in the FAQ but hadn't realised how big a
performance difference it would make.

This wasn't just an idle benchmark: my main application is creating a corpus
of files and then processing that corpus of files (either sequentially, or
with multiple processes each working sequentially through subsections of the
corpus)

Regards,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
