Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8S9RRnY099110 for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 04:27:28 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CCA351C444BD
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 02:27:26 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id qwo4m95YzD0hFSKY for <xfs@oss.sgi.com>;
	Wed, 28 Sep 2011 02:27:26 -0700 (PDT)
Date: Wed, 28 Sep 2011 10:27:19 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [patch 1/2/4] mm: writeback: cleanups in preparation for
	per-zone dirty limits
Message-ID: <20110928092718.GD11313@suse.de>
References: <1316526315-16801-1-git-send-email-jweiner@redhat.com>
	<1316526315-16801-3-git-send-email-jweiner@redhat.com>
	<20110921160226.1bf74494.akpm@google.com>
	<20110922085242.GA29046@redhat.com>
	<20110923144107.GB2606@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110923144107.GB2606@redhat.com>
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
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@google.com>, Rik van Riel <riel@redhat.com>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Minchan Kim <minchan.kim@gmail.com>, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Wu Fengguang <fengguang.wu@intel.com>, Chris Mason <chris.mason@oracle.com>

On Fri, Sep 23, 2011 at 04:41:07PM +0200, Johannes Weiner wrote:
> On Thu, Sep 22, 2011 at 10:52:42AM +0200, Johannes Weiner wrote:
> > On Wed, Sep 21, 2011 at 04:02:26PM -0700, Andrew Morton wrote:
> > > Should we rename determine_dirtyable_memory() to
> > > global_dirtyable_memory(), to get some sense of its relationship with
> > > zone_dirtyable_memory()?
> > 
> > Sounds good.
> 
> ---
> 
> The next patch will introduce per-zone dirty limiting functions in
> addition to the traditional global dirty limiting.
> 
> Rename determine_dirtyable_memory() to global_dirtyable_memory()
> before adding the zone-specific version, and fix up its documentation.
> 
> Also, move the functions to determine the dirtyable memory and the
> function to calculate the dirty limit based on that together so that
> their relationship is more apparent and that they can be commented on
> as a group.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>

Acked-by: Mel Gorman <mel@suse.de>

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
