Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0212D7F4E
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2014 06:21:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6E793AC007
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2014 04:21:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XQl53W9jaSm8xk5F (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Oct 2014 04:21:07 -0700 (PDT)
Date: Mon, 13 Oct 2014 07:21:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: dmesg error in xfs_aops.c on kernel 3.14.21
Message-ID: <20141013112104.GA32963@bfoster.bfoster>
References: <54397E0F.2050700@sbcglobal.net>
	<20141012140704.GA35667@bfoster.bfoster>
	<543ACFC2.2090308@sbcglobal.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <543ACFC2.2090308@sbcglobal.net>
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
To: BillStuff <billstuff2001@sbcglobal.net>
Cc: xfs@oss.sgi.com

On Sun, Oct 12, 2014 at 02:00:18PM -0500, BillStuff wrote:
> On 10/12/2014 09:07 AM, Brian Foster wrote:
> >On Sat, Oct 11, 2014 at 01:59:27PM -0500, BillStuff wrote:
> >>Hi,
> >>
> >>I'm running 3.14.21, and got these traces in dmesg; they appear to be from
> >>xfs:
> >>
> >>[56180.816526] ------------[ cut here ]------------
> >>[56180.816550] WARNING: CPU: 5 PID: 67 at fs/xfs/xfs_aops.c:1172
> >
> >	if (WARN_ON(delalloc))
> >		return 0;
> >
> >So this generally looks like stale delalloc blocks on a page that is
> >reclaimed/invalidated or otherwise expected to be clean. We've been
> >seeing this a lot over the past few kernel releases and there have been
> >a variety of fixes in error paths and such so it's hard to say precisely
> >what might be causing this. Some examples:
> >
> >aad3f375 xfs: xfs_vm_write_end truncates too much on failure
> >72ab70a1 xfs: write failure beyond EOF truncates too much data
> >4ab9ed57 xfs: kill buffers over failed write ranges properly
> >
> >It looks like those are in the stable tree as of 3.15, so you could give
> >that a try and see if it helps. Otherwise, can you post xfs_info for the
> >filesytem? Do you have particular workloads or sequences of operations
> >that tend to reproduce this?
> >
> >Brian
> >
> Thanks Brian,
> 
> I'll try out those fixes.
> 

It might be better to move to a more recent stable kernel if you can, as
there could have been other fixes that I've missed.

> The filesystem is home theater recordings on a 6 disk raid5 array:
> 
> meta-data=/dev/md3               isize=256    agcount=81, agsize=15237264
> blks
>          =                       sectsz=4096  attr=2
> data     =                       bsize=4096   blocks=1218981920, imaxpct=5
>          =                       sunit=16     swidth=80 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=32768, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=0
> realtime =none                   extsz=131072 blocks=0, rtextents=0
> 
> I believe it was just starting a recording when I got this message.
> 

So creation of a new file? I guess that could mean reclaim of an old
page to free up memory or something of that sort had detected it. If so,
the problem could have originated any time in the past.

Brian

> -Bill
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
