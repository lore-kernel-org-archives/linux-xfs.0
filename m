Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43026 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932378AbdJYKmC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Oct 2017 06:42:02 -0400
Date: Wed, 25 Oct 2017 06:42:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC] xfs: add a writepage delay error injection tag
Message-ID: <20171025104201.GA62028@bfoster.bfoster>
References: <20171024174527.58767-1-bfoster@redhat.com>
 <20171025052316.GQ5483@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171025052316.GQ5483@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 24, 2017 at 10:23:17PM -0700, Darrick J. Wong wrote:
> On Tue, Oct 24, 2017 at 01:45:27PM -0400, Brian Foster wrote:
> > The XFS ->writepage() cached mapping is racy in that the mapping can
> > change as a result of external factors after it has been looked up
> > and cached. If the current write_cache_pages() instance has to
> > handle subsequent pages over the affected mapping, writeback can
> > submit I/O to the wrong place, causing data loss and possibly
> > corruption in the process.
> > 
> > To support the ability to manufacture this problem and effectively
> > regression test it from userspace, introduce an error injection tag
> > that triggers a fixed delay during ->writepage(). The delay occurs
> > immediately after a mapping is cached. Once userspace triggers
> > writeback, the delay provides userspace with a five second window to
> > perform other operations on the file to attempt to invalidate the
> > mapping.
> > 
> > Note that this tag is intended to be used by xfstests rather than
> > for generic error handling testing. The lifetime of this tag should
> > be tethered to the existence of targeted regression tests for the
> > writepage mapping validity problem.
> 
> Won't that effectively be 'forever' since we'll want to make sure the
> problem doesn't come back, even if Dave's RFC rework eventually makes it
> upstream?
> 

Heh, indeed. That's just me being wishy washy since I was hoping to
avoid the need for error injection here. IOW, I was hoping to replace
this test with a better one, but then decided to send it as an RFC. I'd
like to try using a really large allocsize or some such to see if that
creates a long enough extent/writeback runway to race without needing
the delay. If I can't get anywhere with that, I'll drop the text above
on the next post.

> I was also wondering if maybe some day we might want an error log whose
> numeric setting is something other than "frequency of occurrence"...
> like this one, which could become a writepage_delay_ms to inject
> arbitrary amounts of delay into writeback(?)  But I might just be
> babbling here. :)
> 

I had the same thought when writing this.. that it would be nice if
userspace could just specify the delay rather than the frequency because
the latter is not really useful in this particular case. At the very
least, I'm not sure 5s is really necessary now that we have a test
script, so I'll revisit that. I had set that when I was running commands
manually to find something that worked.

Brian

> --D
> 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > Hi all,
> > 
> > I'm posting this as an RFC for now because I'd like to try and see if
> > there's a reproducer for this that doesn't rely on error injection. I
> > need to think about that a bit more. In the meantime, I wanted to post
> > this as a POC for the associated problem. This does indeed confirm that
> > it's still possible to send I/O off to the wrong place outside the
> > eofblocks variant of the problem that was previously fixed (and more
> > easily reproduced).
> > 
> > I'll post the assocated xfstests test that demonstrates this problem in
> > reply to this patch. The test reproduces about 50% of the time on my
> > test vm.
> > 
> > Thoughts, reviews, flames appreciated.
> > 
> > Brian
> > 
> >  fs/xfs/xfs_aops.c  | 9 +++++++++
> >  fs/xfs/xfs_error.c | 3 +++
> >  fs/xfs/xfs_error.h | 4 +++-
> >  3 files changed, 15 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index a3eeaba..802e030 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -967,6 +967,15 @@ xfs_writepage_map(
> >  				goto out;
> >  			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
> >  							 offset);
> > +			/*
> > +			 * The writepage delay injection tag is for userspace
> > +			 * imap validiation testing purposes. The delay allows
> > +			 * userspace some time to try and invalidate wpc->imap
> > +			 * immediately after it is cached.
> > +			 */
> > +			if (XFS_TEST_ERROR(false, XFS_I(inode)->i_mount,
> > +					   XFS_ERRTAG_WRITEPAGE_DELAY))
> > +				ssleep(5);
> >  		}
> >  		if (wpc->imap_valid) {
> >  			lock_buffer(bh);
> > diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> > index eaf86f5..36072e6 100644
> > --- a/fs/xfs/xfs_error.c
> > +++ b/fs/xfs/xfs_error.c
> > @@ -58,6 +58,7 @@ static unsigned int xfs_errortag_random_default[] = {
> >  	XFS_RANDOM_DROP_WRITES,
> >  	XFS_RANDOM_LOG_BAD_CRC,
> >  	XFS_RANDOM_LOG_ITEM_PIN,
> > +	XFS_RANDOM_WRITEPAGE_DELAY,
> >  };
> >  
> >  struct xfs_errortag_attr {
> > @@ -163,6 +164,7 @@ XFS_ERRORTAG_ATTR_RW(ag_resv_critical,	XFS_ERRTAG_AG_RESV_CRITICAL);
> >  XFS_ERRORTAG_ATTR_RW(drop_writes,	XFS_ERRTAG_DROP_WRITES);
> >  XFS_ERRORTAG_ATTR_RW(log_bad_crc,	XFS_ERRTAG_LOG_BAD_CRC);
> >  XFS_ERRORTAG_ATTR_RW(log_item_pin,	XFS_ERRTAG_LOG_ITEM_PIN);
> > +XFS_ERRORTAG_ATTR_RW(writepage_delay,	XFS_ERRTAG_WRITEPAGE_DELAY);
> >  
> >  static struct attribute *xfs_errortag_attrs[] = {
> >  	XFS_ERRORTAG_ATTR_LIST(noerror),
> > @@ -196,6 +198,7 @@ static struct attribute *xfs_errortag_attrs[] = {
> >  	XFS_ERRORTAG_ATTR_LIST(drop_writes),
> >  	XFS_ERRORTAG_ATTR_LIST(log_bad_crc),
> >  	XFS_ERRORTAG_ATTR_LIST(log_item_pin),
> > +	XFS_ERRORTAG_ATTR_LIST(writepage_delay),
> >  	NULL,
> >  };
> >  
> > diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> > index 7c4bef3..17556b3 100644
> > --- a/fs/xfs/xfs_error.h
> > +++ b/fs/xfs/xfs_error.h
> > @@ -107,7 +107,8 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
> >  #define XFS_ERRTAG_DROP_WRITES				28
> >  #define XFS_ERRTAG_LOG_BAD_CRC				29
> >  #define XFS_ERRTAG_LOG_ITEM_PIN				30
> > -#define XFS_ERRTAG_MAX					31
> > +#define XFS_ERRTAG_WRITEPAGE_DELAY			31
> > +#define XFS_ERRTAG_MAX					32
> >  
> >  /*
> >   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> > @@ -143,6 +144,7 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
> >  #define XFS_RANDOM_DROP_WRITES				1
> >  #define XFS_RANDOM_LOG_BAD_CRC				1
> >  #define XFS_RANDOM_LOG_ITEM_PIN				1
> > +#define XFS_RANDOM_WRITEPAGE_DELAY			1
> >  
> >  #ifdef DEBUG
> >  extern int xfs_errortag_init(struct xfs_mount *mp);
> > -- 
> > 2.9.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
