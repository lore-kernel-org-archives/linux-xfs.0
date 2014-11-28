Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 251927F4E
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 20:49:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 12E0B304053
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 18:49:49 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	9ELLaiPQ0DP75DBv for <xfs@oss.sgi.com>;
	Thu, 27 Nov 2014 18:49:47 -0800 (PST)
Date: Fri, 28 Nov 2014 13:49:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 1/2] xfs: replace global xfslogd wq with per-mount wq
Message-ID: <20141128024945.GC16151@dastard>
References: <1415906641-43587-1-git-send-email-bfoster@redhat.com>
	<1415906641-43587-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1415906641-43587-2-git-send-email-bfoster@redhat.com>
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
Cc: xfs@oss.sgi.com

On Thu, Nov 13, 2014 at 02:24:00PM -0500, Brian Foster wrote:
> The xfslogd workqueue is a global, single-job workqueue for buffer ioend
> processing. This means we allow for a single work item at a time for all
> possible XFS mounts on a system. fsstress testing in loopback XFS over
> XFS configurations has reproduced xfslogd deadlocks due to the single
> threaded nature of the queue and dependencies introduced between the
> separate XFS instances by online discard (-o discard).
> 
> Discard over a loopback device converts the discard request to a hole
> punch (fallocate) on the underlying file. Online discard requests are
> issued synchronously and from xfslogd context in XFS, hence the xfslogd
> workqueue is blocked in the upper fs waiting on a hole punch request to
> be servied in the lower fs. If the lower fs issues I/O that depends on
> xfslogd to complete, both filesystems end up hung indefinitely. This is
> reproduced reliabily by generic/013 on XFS->loop->XFS test devices with
> the '-o discard' mount option.
> 
> Further, docker implementations appear to use this kind of configuration
> for container instance filesystems by default (container fs->dm->
> loop->base fs) and therefore are subject to this deadlock when running
> on XFS.
> 
> Replace the global xfslogd workqueue with a per-mount variant. This
> guarantees each mount access to a single worker and prevents deadlocks
> due to inter-fs dependencies introduced by discard. Since the queue is
> only responsible for buffer iodone processing at this point in time,
> rename xfslogd to xfs-buf.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good. I'll take this as is and we can refine the way we point
to the workqueue in the patches that separate the log buffer
completions...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
