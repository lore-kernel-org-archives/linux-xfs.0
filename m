Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q835RoW8146960 for <xfs@oss.sgi.com>; Mon, 3 Sep 2012 00:27:50 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	KPHZ8CRO3UWrFEpg for <xfs@oss.sgi.com>;
	Sun, 02 Sep 2012 22:28:46 -0700 (PDT)
Date: Mon, 3 Sep 2012 15:28:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 4/4] xfs: add background scanning to clear EOFBLOCKS
	inodes
Message-ID: <20120903052842.GT15292@dastard>
References: <1346097111-4476-1-git-send-email-bfoster@redhat.com>
	<1346097111-4476-5-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1346097111-4476-5-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 27, 2012 at 03:51:51PM -0400, Brian Foster wrote:
> Create a delayed_work to enable background scanning and freeing
> of EOFBLOCKS inodes. The scanner kicks in once speculative
> preallocation occurs and stops requeueing itself when no EOFBLOCKS
> inodes exist.
> 
> Scans are queued on the existing syncd workqueue and the interval
> is tied to the syncd interval, which is a default of 30s. The
> minimum file size for a background scan is hardcoded to 100MB.

I'd set it to be much longer than the xfs_syncd_centisecs period.
The data may not be written back for a long while, and a file that
is open, written and closed repeatedly (NFS write patterns for large
and/or slowly written files) should not have it's preallocation
truncated every 30s.

I'd suggest that a 5 minute sweep is probably sufficiently frequent
to avoid most fragmentation issues and long term buildup of speculative
preallocation whilst not perturbing large/slow writers too much....

Apart from that, there isn't anything wrong with the code, except
I'll note again that it conflicts with my syncd removal patchset....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
