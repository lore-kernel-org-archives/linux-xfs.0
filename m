Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8E9iMt9059574 for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 04:44:22 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id jbaGIORaYsE788pi (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Sep 2012 02:45:29 -0700 (PDT)
Date: Fri, 14 Sep 2012 10:45:23 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 020/102] xfs: warn if direct reclaim tries to writeback
	pages
Message-ID: <20120914094523.GD11266@suse.de>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
	<1345698180-13612-21-git-send-email-david@fromorbit.com>
	<20120827181742.GA13970@infradead.org>
	<20120905113242.GL11266@suse.de> <50523E20.5000508@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50523E20.5000508@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On Thu, Sep 13, 2012 at 03:12:16PM -0500, Mark Tinguely wrote:
> On 09/05/12 06:32, Mel Gorman wrote:
> >On Mon, Aug 27, 2012 at 02:17:42PM -0400, Christoph Hellwig wrote:
> >>On Thu, Aug 23, 2012 at 03:01:38PM +1000, Dave Chinner wrote:
> >>>From: Mel Gorman<mgorman@suse.de>
> >>>
> >>>Upstream commit: 94054fa3fca1fd78db02cb3d68d5627120f0a1d4
> >>>
> >>>Direct reclaim should never writeback pages.  For now, handle the
> >>>situation and warn about it.  Ultimately, this will be a BUG_ON.
> >>
> >>Is this actually the case on 3.0-stable?
> >>
> >
> >No, it is not. AFAIK, 3.0-stable does not contain [ee72886d: mm: vmscan:
> >do not writeback filesystem pages in direct reclaim] which is the absolute
> >minimum required for commit [94054fa3: xfs: warn if direct reclaim tries
> >to writeback pages] to make sense.
> >
> 
> I hit this warning testing on a linux-30.42 with a x86_64.
> 

Just to be clear, this was linux 3.0.42 with this series of patches
applied on top, right?

> WARNING: at fs/xfs/linux-2.6/xfs_aops.c:961 xfs_vm_writepage+0x63c/0x6a0()
> Hardware name: S2721-533 Thunder i7501 Pro
> Modules linked in: ext4 jbd2 crc16
> Pid: 12122, comm: cp Not tainted 3.0.42 #2

I ask because on 3.0.42 this warning is not present. This patch should
not be merged to 3.0-stable.

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
