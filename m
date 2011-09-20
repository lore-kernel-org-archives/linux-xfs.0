Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KEEK8Z064833 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 09:14:20 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D702914025E5
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 07:19:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Sajoc6u9McAyE56h for
	<xfs@oss.sgi.com>; Tue, 20 Sep 2011 07:19:37 -0700 (PDT)
Date: Tue, 20 Sep 2011 16:14:03 +0200
From: Johannes Weiner <jweiner@redhat.com>
Subject: Re: [patch 4/4] Btrfs: pass __GFP_WRITE for buffered write page
	allocations
Message-ID: <20110920141403.GA17198@redhat.com>
References: <1316526315-16801-1-git-send-email-jweiner@redhat.com>
	<1316526315-16801-5-git-send-email-jweiner@redhat.com>
	<20110920135631.GB16338@redhat.com> <4E789EA2.8070709@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E789EA2.8070709@redhat.com>
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
To: Josef Bacik <josef@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Mel Gorman <mgorman@suse.de>, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Wu Fengguang <fengguang.wu@intel.com>, Chris Mason <chris.mason@oracle.com>, Minchan Kim <minchan.kim@gmail.com>

On Tue, Sep 20, 2011 at 10:09:38AM -0400, Josef Bacik wrote:
> On 09/20/2011 09:56 AM, Johannes Weiner wrote:
> > On Tue, Sep 20, 2011 at 03:45:15PM +0200, Johannes Weiner wrote:
> >> Tell the page allocator that pages allocated for a buffered write are
> >> expected to become dirty soon.
> >>
> >> Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> >> ---
> >>  fs/btrfs/file.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> >> index e7872e4..ea1b892 100644
> >> --- a/fs/btrfs/file.c
> >> +++ b/fs/btrfs/file.c
> >> @@ -1084,7 +1084,7 @@ static noinline int prepare_pages(struct btrfs_root *root, struct file *file,
> >>  again:
> >>  	for (i = 0; i < num_pages; i++) {
> >>  		pages[i] = find_or_create_page(inode->i_mapping, index + i,
> >> -					       GFP_NOFS);
> >> +					       GFP_NOFS | __GFP_WRITE);
> > 
> > Btw and unrelated to this particular series, I think this should use
> > grab_cache_page_write_begin() in the first place.
> > 
> > Most grab_cache_page calls were replaced recently (a94733d "Btrfs: use
> > find_or_create_page instead of grab_cache_page") to be able to pass
> > GFP_NOFS, but the pages are now also no longer __GFP_HIGHMEM and
> > __GFP_MOVABLE, which irks both x86_32 and memory hotplug.
> > 
> > It might be better to change grab_cache_page instead to take a flags
> > argument that allows passing AOP_FLAG_NOFS and revert the sites back
> > to this helper?
> 
> So I can do
> 
> pages[i] = grab_cache_page_write_begin(inode->i_mapping, index + i,
> 				       AOP_FLAG_NOFS);
> 
> right?  All we need is nofs, so I can just go through and change
> everybody to that.

It does wait_on_page_writeback() in addition, so it may not be
appropriate for every callsite, I haven't checked.  But everything
that grabs a page for writing should be fine if you do it like this.

> I'd rather not have to go through and change grab_cache_page() to
> take a flags argument and change all the callers, I have a bad habit
> of screwing stuff like that up :).

Yeah, there are quite a few.  If we can get around it, all the better.

	Hannes

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
