Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA1AreeY113560 for <xfs@oss.sgi.com>; Tue, 1 Nov 2011 05:53:40 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 040A41CD7A3A
	for <xfs@oss.sgi.com>; Tue,  1 Nov 2011 03:53:39 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8IbFsCDpqbbbNiOB for
	<xfs@oss.sgi.com>; Tue, 01 Nov 2011 03:53:39 -0700 (PDT)
Date: Tue, 1 Nov 2011 11:52:57 +0100
From: Johannes Weiner <jweiner@redhat.com>
Subject: Re: [patch 3/5] mm: try to distribute dirty pages fairly across zones
Message-ID: <20111101105257.GF5819@redhat.com>
References: <1317367044-475-1-git-send-email-jweiner@redhat.com>
	<1317367044-475-4-git-send-email-jweiner@redhat.com>
	<20110930142805.GC869@tiehlicka.suse.cz>
	<20111027155618.GA25524@localhost>
	<20111027161359.GA1319@redhat.com>
	<20111027204743.GA19343@localhost>
	<20111027221258.GA22869@localhost>
	<20111027231933.GB1319@redhat.com>
	<20111028203944.GB20607@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111028203944.GB20607@localhost>
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
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Michal Hocko <mhocko@suse.cz>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Mel Gorman <mgorman@suse.de>, "Li, Shaohua" <shaohua.li@intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Chris Mason <chris.mason@oracle.com>, Minchan Kim <minchan.kim@gmail.com>

On Sat, Oct 29, 2011 at 04:39:44AM +0800, Wu Fengguang wrote:
> [restore CC list]
> 
> > > I'm trying to understand where the performance gain comes from.
> > > 
> > > I noticed that in all cases, before/after patchset, nr_vmscan_write are all zero.
> > > 
> > > nr_vmscan_immediate_reclaim is significantly reduced though:
> > 
> > That's a good thing, it means we burn less CPU time on skipping
> > through dirty pages on the LRU.
> > 
> > Until a certain priority level, the dirty pages encountered on the LRU
> > list are marked PageReclaim and put back on the list, this is the
> > nr_vmscan_immediate_reclaim number.  And only below that priority, we
> > actually ask the FS to write them, which is nr_vmscan_write.
> 
> Yes, it is.
> 
> > I suspect this is where the performance improvement comes from: we
> > find clean pages for reclaim much faster.
> 
> That explains how it could reduce CPU overheads. However the dd's are
> throttled anyway, so I still don't understand how the speedup of dd page
> allocations improve the _IO_ performance.

They are throttled in balance_dirty_pages() when there are too many
dirty pages.  But they are also 'throttled' in direct reclaim when
there are too many clean + dirty pages.  Wild guess: speeding up
direct reclaim allows dirty pages to be generated faster and the
writer can better saturate the BDI?

Not all filesystems ignore all VM writepage requests, either.  xfs
e.g. ignores only direct reclaim but honors requests from kswapd.
ext4 honors writepage whenever it pleases.  On those, I can imagine
the reduced writepage intereference to help.  But that can not be the
only reason as btrfs ignores writepage from the reclaim in general and
still sees improvement.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
