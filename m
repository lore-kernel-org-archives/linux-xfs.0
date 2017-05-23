Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36161 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758710AbdEWLIf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 May 2017 07:08:35 -0400
Date: Tue, 23 May 2017 19:08:32 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 2/3] xfs: Fix off-by-in in loop termination in
 xfs_find_get_desired_pgoff()
Message-ID: <20170523110832.GY7250@eguan.usersys.redhat.com>
References: <20170518104850.14508-1-jack@suse.cz>
 <20170518104850.14508-3-jack@suse.cz>
 <20170522175045.GB1473@bfoster.bfoster>
 <20170523032123.GW7250@eguan.usersys.redhat.com>
 <20170523085044.GA1119@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170523085044.GA1119@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Brian Foster <bfoster@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Tue, May 23, 2017 at 10:50:44AM +0200, Jan Kara wrote:
> On Tue 23-05-17 11:21:23, Eryu Guan wrote:
> > On Mon, May 22, 2017 at 01:50:47PM -0400, Brian Foster wrote:
> > > On Thu, May 18, 2017 at 12:48:49PM +0200, Jan Kara wrote:
> > > > There is an off-by-one error in loop termination conditions in
> > > > xfs_find_get_desired_pgoff() since 'end' may index a page beyond end of
> > > > desired range if 'endoff' is page aligned. It doesn't have any visible
> > > > effects but still it is good to fix it.
> > > > 
> > > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > > ---
> > > >  fs/xfs/xfs_file.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > > index f371812e20c6..3714b5736fd3 100644
> > > > --- a/fs/xfs/xfs_file.c
> > > > +++ b/fs/xfs/xfs_file.c
> > > > @@ -1043,7 +1043,7 @@ xfs_find_get_desired_pgoff(
> > > >  
> > > >  	index = startoff >> PAGE_SHIFT;
> > > >  	endoff = XFS_FSB_TO_B(mp, map->br_startoff + map->br_blockcount);
> > > > -	end = endoff >> PAGE_SHIFT;
> > > > +	end = (endoff - 1) >> PAGE_SHIFT;
> > > 
> > > Hmm.. I think this messes with the want count for the pagevec_lookup().
> > > E.g.:
> > > 
> > > # xfs_io -fc "truncate 0" -c "falloc 0 16k" -c "pwrite 0 16k" -c "seek -h 0" /mnt/file 
> > > wrote 16384/16384 bytes at offset 0
> > > 16 KiB, 4 ops; 0.0000 sec (200.321 MiB/sec and 51282.0513 ops/sec)
> > > Whence  Result
> > > HOLE    12288
> > 
> > I think the root cause is that the calculation for 'want' is wrong, it
> > has an off-by-one bug too. I sent a patch[1] to fix it, with my patch
> > applied on top of Jan's patchset, your test case passed (report HOLE at
> > 16k). Can you please take a look if it's a correct fix? Thanks!
> 
> Yes, I've messed that up. It is a bug introduced by my series as Brian
> properly noticed. Thanks guys for noticing and fixing it! Darrick, should I
> fold in Eryu's fix and send v4 of the series or will you just pick up
> Eryu's fix?

I think it's a separate bug, the issue described in my patch can be
reproduced on stock 4.12-rc1 kernel, without your patchset. The
situation for ext4 is similar to XFS, it seems not a bug introduced by
your patches.

Thanks for the review!

Eryu

> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
