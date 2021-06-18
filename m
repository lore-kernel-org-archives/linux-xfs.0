Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B08CC48BDF
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 14:59:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB26361369
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 14:59:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234639AbhFRPBx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 11:01:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234183AbhFRPBx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 Jun 2021 11:01:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E45FD61260;
        Fri, 18 Jun 2021 14:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624028384;
        bh=Ftex21ZmydYm/8CIEk6HaP/TuifY5w8NPCo8OXjM+BU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rUY5ty15MwFzKqvMfHN3OvIRAGZl+OcMc5g2/B5VgTLrcOMGk7OfSem3TgOmMxIah
         0u3uFW9eWS8XBlfX1Sv6gOtFtUOCQqLjajCDa3KnWBeKWb3Av5V56mIf8wsLhVQ837
         0Xej7tXI+wcw6FaZt43bocLoaCasTPdPdvFuZkhWdLpjueET0GgtcZ+CJnFm3KV5oc
         ZXnW9CkzMmX4X/BHU7nFokmSeq9f1oIyPlJ/9TooQZXlkVGQffpPGaR1qtR2QKaTpH
         PdT7Y6+PO9sbXFelODcRk4eIN4Sxht4x9owmvF6SydoZjZbsEbYd4qpDKscXMXTSlT
         jbOtbeiWTGYkw==
Date:   Fri, 18 Jun 2021 07:59:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: fix type mismatches in the inode reclaim
 functions
Message-ID: <20210618145943.GD158209@locust>
References: <162388772484.3427063.6225456710511333443.stgit@locust>
 <162388773053.3427063.16153257434224756166.stgit@locust>
 <YMyu1tN6kphOlN46@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMyu1tN6kphOlN46@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 18, 2021 at 10:33:58AM -0400, Brian Foster wrote:
> On Wed, Jun 16, 2021 at 04:55:30PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > It's currently unlikely that we will ever end up with more than 4
> > billion inodes waiting for reclamation, but the fs object code uses long
> > int for object counts and we're certainly capable of generating that
> > many.  Instead of truncating the internal counters, widen them and
> > report the object counts correctly.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_icache.c |    8 ++++----
> >  fs/xfs/xfs_icache.h |    6 +++---
> >  fs/xfs/xfs_trace.h  |    4 ++--
> >  3 files changed, 9 insertions(+), 9 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 6b44fc734cb5..18dae6d3d69a 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -1084,11 +1084,11 @@ xfs_reclaim_inodes(
> >  long
> >  xfs_reclaim_inodes_nr(
> >  	struct xfs_mount	*mp,
> > -	int			nr_to_scan)
> > +	unsigned long		nr_to_scan)
> >  {
> >  	struct xfs_icwalk	icw = {
> >  		.icw_flags	= XFS_ICWALK_FLAG_SCAN_LIMIT,
> > -		.icw_scan_limit	= nr_to_scan,
> > +		.icw_scan_limit	= max_t(unsigned long, LONG_MAX, nr_to_scan),
> 
> Does this intend to assign LONG_MAX if nr_to_scan might be smaller?

DOH.  Yes, this should be min_t().  Why do I always screw that up?

--D

> Brian
> 
> >  	};
> >  
> >  	if (xfs_want_reclaim_sick(mp))
> > @@ -1106,13 +1106,13 @@ xfs_reclaim_inodes_nr(
> >   * Return the number of reclaimable inodes in the filesystem for
> >   * the shrinker to determine how much to reclaim.
> >   */
> > -int
> > +long
> >  xfs_reclaim_inodes_count(
> >  	struct xfs_mount	*mp)
> >  {
> >  	struct xfs_perag	*pag;
> >  	xfs_agnumber_t		ag = 0;
> > -	int			reclaimable = 0;
> > +	long			reclaimable = 0;
> >  
> >  	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
> >  		ag = pag->pag_agno + 1;
> > diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> > index 00dc98a92835..c751cc32dc46 100644
> > --- a/fs/xfs/xfs_icache.h
> > +++ b/fs/xfs/xfs_icache.h
> > @@ -15,7 +15,7 @@ struct xfs_icwalk {
> >  	kgid_t		icw_gid;
> >  	prid_t		icw_prid;
> >  	__u64		icw_min_file_size;
> > -	int		icw_scan_limit;
> > +	long		icw_scan_limit;
> >  };
> >  
> >  /* Flags that reflect xfs_fs_eofblocks functionality. */
> > @@ -49,8 +49,8 @@ void xfs_inode_free(struct xfs_inode *ip);
> >  void xfs_reclaim_worker(struct work_struct *work);
> >  
> >  void xfs_reclaim_inodes(struct xfs_mount *mp);
> > -int xfs_reclaim_inodes_count(struct xfs_mount *mp);
> > -long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
> > +long xfs_reclaim_inodes_count(struct xfs_mount *mp);
> > +long xfs_reclaim_inodes_nr(struct xfs_mount *mp, unsigned long nr_to_scan);
> >  
> >  void xfs_inode_mark_reclaimable(struct xfs_inode *ip);
> >  
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index 428dc71f7f8b..85fa864f8e2f 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -3894,7 +3894,7 @@ DECLARE_EVENT_CLASS(xfs_icwalk_class,
> >  		__field(uint32_t, gid)
> >  		__field(prid_t, prid)
> >  		__field(__u64, min_file_size)
> > -		__field(int, scan_limit)
> > +		__field(long, scan_limit)
> >  		__field(unsigned long, caller_ip)
> >  	),
> >  	TP_fast_assign(
> > @@ -3909,7 +3909,7 @@ DECLARE_EVENT_CLASS(xfs_icwalk_class,
> >  		__entry->scan_limit = icw ? icw->icw_scan_limit : 0;
> >  		__entry->caller_ip = caller_ip;
> >  	),
> > -	TP_printk("dev %d:%d flags 0x%x uid %u gid %u prid %u minsize %llu scan_limit %d caller %pS",
> > +	TP_printk("dev %d:%d flags 0x%x uid %u gid %u prid %u minsize %llu scan_limit %ld caller %pS",
> >  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> >  		  __entry->flags,
> >  		  __entry->uid,
> > 
> 
