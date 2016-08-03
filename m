Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 870D37CA4
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 21:00:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 57251304032
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 19:00:44 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	IiA4KmXIt54Tk82x for <xfs@oss.sgi.com>;
	Tue, 02 Aug 2016 19:00:41 -0700 (PDT)
Date: Wed, 3 Aug 2016 12:00:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 36/47] xfs: convert unwritten status of reverse mappings
Message-ID: <20160803020039.GR16044@dastard>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907720267.25461.12865808398854547794.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146907720267.25461.12865808398854547794.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

On Wed, Jul 20, 2016 at 10:00:02PM -0700, Darrick J. Wong wrote:
> Provide a function to convert an unwritten extent to a real one and
> vice versa.
> 
> v2: Move unwritten bit to rm_offset.
> 
> v3: Fix a bug where we touched the wrong btree_irec field due to a
> stupid cut-and-paste error.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I've added a comment to the commit message that the algorithm and
code structure has been derived from
xfs_bmap_add_extent_unwritten_real(). It looks to be correct.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
