Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 651077CB1
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 19:05:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 279158F8037
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 17:05:42 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	HYLzEesq5WMJVh2w for <xfs@oss.sgi.com>;
	Wed, 13 Jul 2016 17:05:39 -0700 (PDT)
Date: Thu, 14 Jul 2016 10:05:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: track and serialize in-flight async buffers
	against unmount
Message-ID: <20160714000538.GS1922@dastard>
References: <1468426595-35032-1-git-send-email-bfoster@redhat.com>
	<1468426595-35032-4-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1468426595-35032-4-git-send-email-bfoster@redhat.com>
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

On Wed, Jul 13, 2016 at 12:16:35PM -0400, Brian Foster wrote:
> Newly allocated XFS metadata buffers are added to the LRU once the hold
> count is released, which typically occurs after I/O completion. There is
> no other mechanism at current that tracks the existence or I/O state of
> a new buffer. Further, readahead I/O tends to be submitted
> asynchronously by nature, which means the I/O can remain in flight and
> actually complete long after the calling context is gone. This means
> that file descriptors or any other holds on the filesystem can be
> released, allowing the filesystem to be unmounted while I/O is still in
> flight. When I/O completion occurs, core data structures may have been
> freed, causing completion to run into invalid memory accesses and likely
> to panic.
> 
> This problem is reproduced on XFS via directory readahead. A filesystem
> is mounted, a directory is opened/closed and the filesystem immediately
> unmounted. The open/close cycle triggers a directory readahead that if
> delayed long enough, runs buffer I/O completion after the unmount has
> completed.
> 
> To address this problem, add a mechanism to track all in-flight,
> asynchronous buffers using per-cpu counters in the buftarg. The buffer
> is accounted on the first I/O submission after the current reference is
> acquired and unaccounted once the buffer is returned to the LRU or
> freed. Update xfs_wait_buftarg() to wait on all in-flight I/O before
> walking the LRU list. Once in-flight I/O has completed and the workqueue
> has drained, all new buffers should have been released onto the LRU.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Yup, looks good now. I'll pull it into my test tree...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
