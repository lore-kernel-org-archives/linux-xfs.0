Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36717 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751553AbdEPLmd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 16 May 2017 07:42:33 -0400
Date: Tue, 16 May 2017 13:42:31 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] xfs: Move handling of missing page into one place in
 xfs_find_get_desired_pgoff()
Message-ID: <20170516114231.GA5991@quack2.suse.cz>
References: <20170511165023.29887-1-jack@suse.cz>
 <20170511165023.29887-2-jack@suse.cz>
 <20170515132834.GB27809@bfoster.bfoster>
 <20170515144421.GJ16182@quack2.suse.cz>
 <20170515145542.GA29084@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170515145542.GA29084@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Jan Kara <jack@suse.cz>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Mon 15-05-17 10:55:42, Brian Foster wrote:
> On Mon, May 15, 2017 at 04:44:21PM +0200, Jan Kara wrote:
> > On Mon 15-05-17 09:28:37, Brian Foster wrote:
> > > On Thu, May 11, 2017 at 06:50:23PM +0200, Jan Kara wrote:
> > > > Currently several places in xfs_find_get_desired_pgoff() handle the case
> > > > of a missing page. Make them all handled in one place after the loop has
> > > > terminated.
> > > > 
> > > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > > ---
> > > >  fs/xfs/xfs_file.c | 24 ++++++++----------------
> > > >  1 file changed, 8 insertions(+), 16 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > > index df51c025adfe..719923b99ba1 100644
> > > > --- a/fs/xfs/xfs_file.c
> > > > +++ b/fs/xfs/xfs_file.c
> > > > @@ -1069,10 +1069,6 @@ xfs_find_get_desired_pgoff(
> > > >  				break;
> > > >  
> > > >  			ASSERT(type == HOLE_OFF);
> > > > -			if (lastoff == startoff || lastoff < endoff) {
> > > > -				found = true;
> > > > -				*offset = lastoff;
> > > > -			}
> > > >  			break;
> > > >  		}
> > > >  
> > > > @@ -1080,11 +1076,8 @@ xfs_find_get_desired_pgoff(
> > > >  		 * At least we found one page. If the current offset is smaller
> > > >  		 * than the first page offset, a hole was found.
> > > >  		 */
> > > > -		if (type == HOLE_OFF && lastoff < page_offset(pvec.pages[0])) {
> > > > -			found = true;
> > > > -			*offset = lastoff;
> > > > +		if (type == HOLE_OFF && lastoff < page_offset(pvec.pages[0]))
> > > >  			break;
> > > > -		}
> > > >  
> > > >  		for (i = 0; i < nr_pages; i++) {
> > > >  			struct page	*page = pvec.pages[i];
> > > 
> > > FWIW, it looks like there's still a bug here that the first patch
> > > doesn't address:
> > > 
> > > # xfs_io -fc "truncate 0" -c "falloc 0 32k" -c "pwrite 0 4k" -c "pwrite 32k 4k" -c "seek -h 0" /mnt/file
> > > wrote 4096/4096 bytes at offset 0
> > > 4 KiB, 1 ops; 0.0000 sec (126.008 MiB/sec and 32258.0645 ops/sec)
> > > wrote 4096/4096 bytes at offset 32768
> > > 4 KiB, 1 ops; 0.0000 sec (102.796 MiB/sec and 26315.7895 ops/sec)
> > > Whence  Result
> > > HOLE    36864
> > > # xfs_io -c fsync -c "seek -h 0" /mnt/file 
> > > Whence  Result
> > > HOLE    4096
> > > 
> > > I initially thought this patch might fix it, but on further digging it
> > > doesn't appear to. What looks like is going on here is that the
> > > 'page->index > end' check doesn't actually catch this case of the page
> > > being just beyond the current unwritten extent (perhaps the check should
> > > be 'page->index >= end'), so lastoff is set beyond end and we skip the
> > > hole.
> > 
> > Right, that looks like another bug in the implementation. Will you send a
> > fix or should I?
> > 
> 
> It'd be great if you could tack it onto this series..? Otherwise I'll
> send one a bit later..

OK, I'll take care of this. Looking at it now, the function seems to have
even more problems. Like completely fails to verify found indices are
contiguous...

								Honza

> > > > @@ -1150,21 +1143,20 @@ xfs_find_get_desired_pgoff(
> > > >  
> > > >  		/*
> > > >  		 * The number of returned pages less than our desired, search
> > > > -		 * done.  In this case, nothing was found for searching data,
> > > > -		 * but we found a hole behind the last offset.
> > > > +		 * done.
> > > >  		 */
> > > > -		if (nr_pages < want) {
> > > > -			if (type == HOLE_OFF) {
> > > > -				*offset = lastoff;
> > > > -				found = true;
> > > > -			}
> > > > +		if (nr_pages < want)
> > > >  			break;
> > > > -		}
> > > >  
> > > >  		index = pvec.pages[i - 1]->index + 1;
> > > >  		pagevec_release(&pvec);
> > > >  	} while (index <= end);
> > > >  
> > > > +	/* No page at lastoff and we are not done - we found a hole. */
> > > > +	if (type == HOLE_OFF && lastoff < endoff) {
> > > > +		*offset = lastoff;
> > > > +		found = true;
> > > > +	}
> > > >  out:
> > > >  	pagevec_release(&pvec);
> > > >  	return found;
> > > > -- 
> > > > 2.12.0
> > > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > -- 
> > Jan Kara <jack@suse.com>
> > SUSE Labs, CR
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
