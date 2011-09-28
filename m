Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8S5vR3n090422 for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 00:57:27 -0500
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B31151C4D368
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2011 22:57:26 -0700 (PDT)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	koNVA7L4MgBGrYUr for <xfs@oss.sgi.com>;
	Tue, 27 Sep 2011 22:57:26 -0700 (PDT)
Received: by iaeo4 with SMTP id o4so7662440iae.26
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2011 22:57:26 -0700 (PDT)
Date: Wed, 28 Sep 2011 14:57:14 +0900
From: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [patch 1/2/4] mm: writeback: cleanups in preparation for
	per-zone dirty limits
Message-ID: <20110928055714.GC14561@barrios-desktop>
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
Cc: Andrew Morton <akpm@google.com>, Rik van Riel <riel@redhat.com>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Mel Gorman <mgorman@suse.de>, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Wu Fengguang <fengguang.wu@intel.com>, Chris Mason <chris.mason@oracle.com>

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
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
-- 
Kinds regards,
Minchan Kim

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
