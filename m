Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KIaLQm076514 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 13:36:21 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 47293177469
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 11:36:20 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 28g1eXvf1wbu9s7F for
	<xfs@oss.sgi.com>; Tue, 20 Sep 2011 11:36:20 -0700 (PDT)
Message-ID: <4E78DD10.4000900@redhat.com>
Date: Tue, 20 Sep 2011 14:36:00 -0400
From: Rik van Riel <riel@redhat.com>
MIME-Version: 1.0
Subject: Re: [patch 2/4] mm: writeback: distribute write pages across allowable
	zones
References: <1316526315-16801-1-git-send-email-jweiner@redhat.com>
	<1316526315-16801-3-git-send-email-jweiner@redhat.com>
In-Reply-To: <1316526315-16801-3-git-send-email-jweiner@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Johannes Weiner <jweiner@redhat.com>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Mel Gorman <mgorman@suse.de>, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Wu Fengguang <fengguang.wu@intel.com>, Chris Mason <chris.mason@oracle.com>, Minchan Kim <minchan.kim@gmail.com>

On 09/20/2011 09:45 AM, Johannes Weiner wrote:
> This patch allows allocators to pass __GFP_WRITE when they know in
> advance that the allocated page will be written to and become dirty
> soon.  The page allocator will then attempt to distribute those
> allocations across zones, such that no single zone will end up full of
> dirty, and thus more or less, unreclaimable pages.
>
> The global dirty limits are put in proportion to the respective zone's
> amount of dirtyable memory and allocations diverted to other zones
> when the limit is reached.
>
> For now, the problem remains for NUMA configurations where the zones
> allowed for allocation are in sum not big enough to trigger the global
> dirty limits, but a future approach to solve this can reuse the
> per-zone dirty limit infrastructure laid out in this patch to have
> dirty throttling and the flusher threads consider individual zones.
>
> Signed-off-by: Johannes Weiner<jweiner@redhat.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

The amount of work done in a __GFP_WRITE allocation looks
a little daunting, but doing that a million times probably
outweighs waiting on the disk even once, so...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
