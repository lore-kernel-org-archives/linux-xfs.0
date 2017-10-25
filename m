Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18955 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750822AbdJYFJt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2017 01:09:49 -0400
Date: Tue, 24 Oct 2017 22:09:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/4] xfs: sanity check log record range parameters
Message-ID: <20171025050943.GP5483@magnolia>
References: <20171023144646.50107-1-bfoster@redhat.com>
 <20171023144646.50107-2-bfoster@redhat.com>
 <20171023234903.GI5483@magnolia>
 <20171024113045.GA56184@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171024113045.GA56184@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 24, 2017 at 07:30:46AM -0400, Brian Foster wrote:
> On Mon, Oct 23, 2017 at 04:49:03PM -0700, Darrick J. Wong wrote:
> > On Mon, Oct 23, 2017 at 10:46:43AM -0400, Brian Foster wrote:
> > > If a malformatted filesystem is mounted and attempts log recovery,
> > > we can end up passing garbage parameter values to
> > > xlog_find_verify_log_record(). In turn, the latter can pass a NULL
> > > head pointer to xlog_header_check_mount() and cause a kernel panic.
> > 
> > Malformed how?  Is *last_blk some huge value such that i < -1?
> > 
> > I'm trying to figure out how we get passed a NULL head, and (afaict)
> > that's one way it can happen...
> > 
> 
> Malformatted simply means the log is too small. What happens is that
> start_blk underflows in xlog_find_head() due to:
> 
> 	start_blk = log_bbnum - (num_scan_bblks - head_blk);
> 
> ... and the code ends up with a negative head_blk value by the time we
> get to the "validate_head" label. last_blk ends up negative in
> xlog_find_verify_log_record() and passes the NULL head pointer to
> xlog_header_check_mount().
> 
> I suppose this might be a bit more obvious if we similarly fixed up
> xlog_find_verify_cycle() to ensure that start_blk is sane, rather than
> let it fall through to the record validation before failing.

Agreed.

> > > Add some parameter sanity checks to both functions. Checks in both
> > > places are technically not necessary, but do so to help future proof
> > > the code. This prevents a kernel panic and replaces it with a more
> > > graceful mount failure.
> > > 
> > > Reported-by: Zorro Lang <zlang@redhat.com>
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/xfs_log_recover.c | 11 +++++++++--
> > >  1 file changed, 9 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > > index ee34899..80b37a2 100644
> > > --- a/fs/xfs/xfs_log_recover.c
> > > +++ b/fs/xfs/xfs_log_recover.c
> > > @@ -347,9 +347,12 @@ xlog_header_check_recover(
> > >   */
> > >  STATIC int
> > >  xlog_header_check_mount(
> > > -	xfs_mount_t		*mp,
> > > -	xlog_rec_header_t	*head)
> > > +	struct xfs_mount	*mp,
> > > +	struct xlog_rec_header	*head)
> > >  {
> > > +	if (!head)
> > > +		return -EINVAL;
> > > +
> > >  	ASSERT(head->h_magicno == cpu_to_be32(XLOG_HEADER_MAGIC_NUM));
> > >  
> > >  	if (uuid_is_null(&head->h_fs_uuid)) {
> > > @@ -533,6 +536,10 @@ xlog_find_verify_log_record(
> > >  
> > >  	ASSERT(start_blk != 0 || *last_blk != start_blk);
> > >  
> > > +	if (start_blk < 0 || start_blk > log->l_logBBsize ||
> > > +	    *last_blk < 0 || *last_blk > log->l_logBBsize)
> > > +		return -EINVAL;
> > 
> > /me stumbled over the fact that start_blk and last_blk are offsets (in
> > units of basic blocks) within the log, not absolute disk offsets like
> > their xfs_daddr_t type implies. :(
> > 
> > Could you add a comment somewhere in this function explaining that these
> > two "block" numbers are actually relative logBBstart?  The comment
> > implies this, but apparently not strongly enough.
> > 
> 
> Sure. I'll add a similar check to the cycle verifier as noted above and
> add a comment in both places to note that we're looking for sane "log
> relative block numbers."
> 
> Actually... now that I take a closer look at the code, I'm wondering if
> a more robust solution than these explicit checks would be to push this
> validation down to the log buffer helpers. We already have
> xlog_buf_bbcount_valid() for checking the buffer length. Perhaps we
> should enhance that to a 'xlog_buf_valid()' for sanity checking both the
> log block address and count (and just passing 0 from xlog_get_bp())
> before the blkno converted to a real daddr and actually read. That may
> better protect us from going off the rails anywhere else in the future
> since the read would simply fail. Thoughts?

Sounds like a good idea.

xfs_verify_logbno?  In keeping with the xfs_verify_{agbno,fsbno,agino,ino,
dir_ino} that are getting added in 4.15?

--D

> 
> Brian
> 
> > --D
> > 
> > > +
> > >  	if (!(bp = xlog_get_bp(log, num_blks))) {
> > >  		if (!(bp = xlog_get_bp(log, 1)))
> > >  			return -ENOMEM;
> > > -- 
> > > 2.9.5
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
