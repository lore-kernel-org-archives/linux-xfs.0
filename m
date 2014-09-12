Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F1E2E7FB3
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2014 15:05:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C22BA304043
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2014 13:05:44 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id SIB2W0wl3vZVxraO (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 12 Sep 2014 13:05:40 -0700 (PDT)
Date: Fri, 12 Sep 2014 16:05:36 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 0/5] clean up collapse range and handle post-eof
	delalloc
Message-ID: <20140912200536.GB42029@bfoster.bfoster>
References: <1410355231-50495-1-git-send-email-bfoster@redhat.com>
	<20140911044243.GA10111@dastard>
	<20140911152012.GB54638@bfoster.bfoster>
	<20140911211915.GA4322@dastard>
	<20140912195128.GA42029@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140912195128.GA42029@bfoster.bfoster>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Sep 12, 2014 at 03:51:29PM -0400, Brian Foster wrote:
> On Fri, Sep 12, 2014 at 07:19:15AM +1000, Dave Chinner wrote:
> > On Thu, Sep 11, 2014 at 11:20:13AM -0400, Brian Foster wrote:
> > > On Thu, Sep 11, 2014 at 02:42:43PM +1000, Dave Chinner wrote:
> > > > On Wed, Sep 10, 2014 at 09:20:26AM -0400, Brian Foster wrote:
> > > > > Hi all,
> > > > > 
> > > > > Here's v2 of the collapse clean up. We refactor a bit more via the
> > > > > insertion of patch 3, otherwise it's similar to v1. This will see some
> > > > > continued testing, but it survived ~500m fsx operations overnight.
> > > > > 
> > > > > Brian
> > > > 
> > > > I'm not sure about the invalidation patch now. On a 1k block size
> > > > filesystem, generic/127 fails with:
> > > > 
> > > >     +ltp/fsx -q -l 262144 -o 65536 -S 191110531 -N 100000 -R -W fsx_std_nommap
> > > >     +collapse range: 1000 to 3000
> > > >     +do_collapse_range: fallocate: Device or resource busy
> > > > 
> > > > which indicates we had an invalidation failure. This is probably
> > > > exposing some other bug, but I haven't had time to look into it yet
> > > > so I don't know.
> > > > 
> > > 
> > > Yeah, I can reproduce this as well, thanks. I think you're referring to
> > > the xfs_free_file_space() patch (5/5)..?
> > 
> > *nod*
> > 
> > > FWIW, I don't see the problem
> > > without that patch, so it appears that the full pagecache truncate is
> > > still covering up a problem somewhere. I'll try to dig into it...
> > 
> > It's likely that it is leaving a dirty buffer on the page beyond EOF
> > as a result of the truncate zeroing the remainder of the page in
> > memory.
> > 
> > If I get a chance I'll look at it this afternoon, as this patchset
> > also seems to be causing a marked increase in the number of fsstress
> > failures due to stray delalloc blocks in files even on 4k block size
> > filesystems (e.g. at unmount).
> > 
> 
> I think I have a bit of an idea of what's going on here. I'm not sure
> that this one is post-eof delalloc related. For reference, here's the
> command that reproduces for me 100% of the time on a 1k block fs
> (derived from the fsx trace): 
> 
> xfs_io -fc "pwrite 185332 55756" \
> 	-c "fcollapse 28672 40960" \
> 	-c "pwrite 133228 63394" \
> 	-c "fcollapse 0 4096" /mnt/file
> 
> The first write extends the file to 241088 bytes and the first collapse
> targets a hole, but shrinks the file down to 200128 bytes. The last page
> offset of the file is now 196608 and with 1k blocks, eof falls within
> the last block of this page (e.g., within bh offsets 199680-200704). The
> second write falls just into the first block of this page.
> 
> What I see occur on the final collapse is that the
> invalidate_inode_pages2_range() call in the collapse op fails due to
> finding a dirty page at offset 196608. We don't have a launder_page()
> callback, so this results in -EBUSY.
> 
> Given the above, it seems like the filemap_write_and_wait_range() call
> should handle this. Digging further, what I see is one or two
> writepage()->xfs_cluster_write() sequences along the range of the
> previous write. xfs_convert_page() eventually attempts to handle page
> offset 196608 and breaks out at offset 197632 (the second bh in the
> page) near the top of the bh loop:
> 
> 		...
> 		if (!(PageUptodate(page) || buffer_uptodate(bh))) {
> 			done = 1;
> 			break;
> 		}
> 		...
> 
> I suspect the reason the page/buffer is in this particular state is due
> to the previous invalidation (collapse 1), which would have removed the
> page from the mapping. This seems reasonable to me since we only wrote
> into the first bytes of the page since the prior invalidation. The problem is
> that the page somehow has the following buffer_head state at the point of the
> EBUSY inval failure:
> 
> invalidate_inode_pages2_range(648): state 0x29 block 84 size 1024
> invalidate_inode_pages2_range(648): state 0x0 block 18446744073709551615 size 1024
> invalidate_inode_pages2_range(648): state 0x0 block 18446744073709551615 size 1024
> invalidate_inode_pages2_range(648): state 0x2b block 87 size 1024
> 
> The first block is BH_Uptodate|BH_Req|BH_Mapped. I read the next two as
> simply not up to date..? The last block is the same as the first plus
> BH_Dirty. This last block is offset 199680 and the previous write goes
> to 196622, so I'm not sure how this ends up dirty. I think the write
> path to this range of the file might be the spot to dig next...
> 

... and it just hit me that truncate dirties the buffer. ;) So I'm
wondering if we have something like the following sequence of events for
this particular page:

- first pwrite writes to complete page
- first collapse:
	- flush
	- invalidate
	- truncate -> dirty last buffer of page
- second pwrite writes to first buffer in page (dirty first buffer)
	- flush
		- xfs_convert_page() hits the first buffer, breaks out
		  and causes the last buffer to be passed over due to
		  the issue below
	- invalidate
		- finds dirty buffer, error!

Brian

> Brian
> 
> P.S., As a datapoint from experimentation, this problem doesn't occur if
> I ensure that writepage() handles this particular page rather than
> xfs_convert_page(). I can do that by either jumping out of
> xfs_convert_page() sooner, before the page is set for writeback, or
> hacking xfs_start_page_writeback() to use __test_set_page_writeback()
> and keep the write tag such that write_cache_pages() can still find the
> page. This calls out an interesting bit of behavior in
> xfs_convert_page() since commit a49935f2: if we handle a part of a
> page, break and mark the page for writeback without handling the rest,
> we'll still clear the PAGECACHE_TAG_TOWRITE tag and writeback won't
> finish off the page during the current iteration (for WB_SYNC_ALL).
> 
> It's not clear to me if this is contributing to the problem in this
> particular case, but it seems like an independent bug at the very
> least. Thoughts?
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
