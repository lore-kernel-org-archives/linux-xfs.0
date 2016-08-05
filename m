Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9A6917CBE
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 17:39:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1E320AC006
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 15:39:31 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	AgpvZc0jEn3NM8Cj for <xfs@oss.sgi.com>;
	Fri, 05 Aug 2016 15:39:28 -0700 (PDT)
Date: Sat, 6 Aug 2016 08:39:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v7 00/47] xfs: add reverse mapping support
Message-ID: <20160805223905.GL16044@dastard>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<20160803194536.GJ5316@wotan.suse.de>
	<20160803205520.GQ8590@birch.djwong.org>
	<20160804005843.GJ8593@birch.djwong.org>
	<20160804021852.GK5316@wotan.suse.de>
	<20160804154845.GV8590@birch.djwong.org>
	<20160804235015.GC16044@dastard>
	<20160805183614.GL5316@wotan.suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160805183614.GL5316@wotan.suse.de>
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
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com, "Darrick J. Wong" <darrick.wong@oracle.com>

On Fri, Aug 05, 2016 at 11:36:14AM -0700, Mark Fasheh wrote:
> On Fri, Aug 05, 2016 at 09:50:15AM +1000, Dave Chinner wrote:
> > I'd much prefer that fiemap gives exact information about shared
> > extents. FIEMAP is a diagnostic tool and as such we need it to
> > accurately reflect the exact extent map of the inode being queried
> > so we aren't mislead about the layout of the file during trouble
> > shooting.
> 
> I disagree about fiemap being a diagnostic tool. I mean it's perfectly
> suitable for that task, but it has many uses outside of that.
> 
> In duperemove at least it's used to do things like look for holes and detect
> already deduped extents (via physical offset). We also use EXTENT_SHARED to
> get a rough estimate of space savings though that can be done in better
> ways. It's a performance sensitive area too - there's currently bugs in
> btrfs regarding fiemap taking too long (and one is actually blocking a
> duperemove feature). Figuring EXTENT_SHARED for btrfs in particular is a
> very cpu intensive process.
> 
> None of this is using fiemap to get physical access to an extent btw, which
> is what I think you're most concerned with?

No, I'm talking about the fact that FIEMAP does not reflect the
current state of data in the file. e.g. there can be dirty data in
the page cache over a range, but FIEMAP will report that as
unwritten. If you optimise the copy to preallocate unwritten regions
rahter than copy them, then you will not copy the active data and
the destination will be corrupt.

IOWs, it is safe to use as a query tool as long as the operations
that follow have their own data integrity guarantees, such as a
duperemove operation. It stands alone without the need for FIEMAP -
FIEMAP is just used to optimise the search for candidate blocks, and
if FIEMAP is wrong then it doesn't affect the data in the file at
all - duperemove just does nothing.

The problem comes when the output of FIEMAP is used to determine
ranges for data accessi and retreival (e.g. sparse copies) - in
these cases the output of FIEMAP is incorrect and live data is going
to be missed.  cp doesn't verify the data it copied to guarantee the
destination is identical to the source, so it's going to sliently
generate corrupt copies when these coherency problems occur.

This is what makes FIEMAP a diagnostic tool - you cannot rely on the
output to be valid and correct for followup operations based on that
information.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
