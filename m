Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9F2E47F55
	for <xfs@oss.sgi.com>; Mon,  9 Sep 2013 10:17:28 -0500 (CDT)
Message-ID: <522DE684.4000903@sgi.com>
Date: Mon, 09 Sep 2013 10:17:24 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] [RFC] xfs: lookaside cache for xfs_buf_find
References: <1378690396-15792-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1378690396-15792-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/08/13 20:33, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> CPU overhead of buffer lookups dominate most metadata intensive
> workloads. The thing is, most such workloads are hitting a
> relatively small number of buffers repeatedly, and so caching
> recently hit buffers is a good idea.
>
> Add a hashed lookaside buffer that records the recent buffer
> lookup successes and is searched first before doing a rb-tree
> lookup. If we get a hit, we avoid the expensive rbtree lookup and
> greatly reduce the overhead of the lookup. If we get a cache miss,
> then we've added an extra CPU cacheline miss into the lookup.

Interesting. The last allocated xfs_buf is placed into the hash.

Might be interesting to know the hit-miss ratio on a real workload.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
