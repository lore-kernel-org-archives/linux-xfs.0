Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KIfTar076761 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 13:41:29 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE616177BE0
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 11:41:28 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4xUPmV0v2qLB2U05 for
	<xfs@oss.sgi.com>; Tue, 20 Sep 2011 11:41:28 -0700 (PDT)
Message-ID: <4E78DE4C.3040703@redhat.com>
Date: Tue, 20 Sep 2011 14:41:16 -0400
From: Rik van Riel <riel@redhat.com>
MIME-Version: 1.0
Subject: Re: [patch 4/4] Btrfs: pass __GFP_WRITE for buffered write page
	allocations
References: <1316526315-16801-1-git-send-email-jweiner@redhat.com>
	<1316526315-16801-5-git-send-email-jweiner@redhat.com>
In-Reply-To: <1316526315-16801-5-git-send-email-jweiner@redhat.com>
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
> Tell the page allocator that pages allocated for a buffered write are
> expected to become dirty soon.
>
> Signed-off-by: Johannes Weiner<jweiner@redhat.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
