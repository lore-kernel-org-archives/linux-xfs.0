Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5BBA829DF8
	for <xfs@oss.sgi.com>; Sun,  2 Jun 2013 23:12:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D2CBBAC003
	for <xfs@oss.sgi.com>; Sun,  2 Jun 2013 21:12:09 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	o0sOR55uCNVESft8 for <xfs@oss.sgi.com>;
	Sun, 02 Jun 2013 21:12:07 -0700 (PDT)
Date: Mon, 3 Jun 2013 14:12:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/9] xfs: rework dquot CRCs
Message-ID: <20130603041206.GY29466@dastard>
References: <1369636707-15150-1-git-send-email-david@fromorbit.com>
	<1369636707-15150-5-git-send-email-david@fromorbit.com>
	<51A64FD3.8000606@redhat.com> <20130530010025.GF29466@dastard>
	<51A73FC4.5080700@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51A73FC4.5080700@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, May 30, 2013 at 08:02:12AM -0400, Brian Foster wrote:
> On 05/29/2013 09:00 PM, Dave Chinner wrote:
> > On Wed, May 29, 2013 at 02:58:27PM -0400, Brian Foster wrote:
> >> On 05/27/2013 02:38 AM, Dave Chinner wrote:
> >>> From: Dave Chinner <dchinner@redhat.com>
> >>>
> >>> Calculating dquot CRCs when the backing buffer is written back just
> >>> doesn't work reliably. There are several places which manipulate
> >>> dquots directly in the buffers, and they don't calculate CRCs
> >>> appropriately, nor do they always set the buffer up to calculate
> >>> CRCs appropriately.
> >>>
> >>> Firstly, if we log a dquot buffer (e.g. during allocation) it gets
> >>> logged without valid CRC, and so on recovery we end up with a dquot
> >>> that is not valid.
> >>>
> >>> Secondly, if we recover/repair a dquot, we don't have a verifier
> >>> attached to the buffer and hence CRCs arenot calculate don the way
> >>> down to disk.
> >>>
> >>> Thirdly, calculating the CRC after we've changed the contents means
> >>> that if we re-read the dquot from the buffer, we cannot verify the
> >>> contents of the dquot are valid, as the CRC is invalid.
> >>>
> >>> So, to avoid all the dquot CRC errors that are being detected by the
> >>> read verifier, change to using the same model as for inodes. that
> >>> is, dquot CRCs are calculated and written to the backing buffer at
> >>> the time the dquot is flushed to the backing buffer. If we modify
> >>> the dquuot directly in the backing buffer, calculate the CRC
> >>> immediately after the modification is complete. Hence the dquot in
> >>> the on-disk buffer should always have a valid CRC.
> >>>
> >>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
....
> >>> @@ -853,8 +854,12 @@ xfs_qm_reset_dqcounts(
> >>>  	do_div(j, sizeof(xfs_dqblk_t));
> >>>  	ASSERT(mp->m_quotainfo->qi_dqperchunk == j);
> >>>  #endif
> >>> -	ddq = bp->b_addr;
> >>> +	dqb = bp->b_addr;
> >>>  	for (j = 0; j < mp->m_quotainfo->qi_dqperchunk; j++) {
> >>> +		struct xfs_disk_dquot	*ddq;
> >>> +
> >>> +		ddq =  (struct xfs_disk_dquot *)&dqb[j];
> >>> +
> >>>  		/*
> >>>  		 * Do a sanity check, and if needed, repair the dqblk. Don't
> >>>  		 * output any warnings because it's perfectly possible to
> >>> @@ -871,7 +876,8 @@ xfs_qm_reset_dqcounts(
> >>>  		ddq->d_bwarns = 0;
> >>>  		ddq->d_iwarns = 0;
> >>>  		ddq->d_rtbwarns = 0;
> >>> -		ddq = (xfs_disk_dquot_t *) ((xfs_dqblk_t *)ddq + 1);
> >>> +		xfs_update_cksum((char *)&dqb[j], sizeof(struct xfs_dqblk),
> >>> +					 XFS_DQUOT_CRC_OFF);
> >>
> >> Nice cleanup on the cast ugliness even without the crc change. Is there
> >> a technical reason for the unconditional crc update here beyond that
> >> we're doing a reset? I'm wondering if there's any value in leaving those
> >> bits untouched for a filesystem that might have never enabled crc
> >> (quotacheck or not).
> > 
> > The dquot might be zeroed and unused, but the buffer it sits in is
> > still allocated and valid. That means if we ever start using that
> > dquot again (either by quotacheck or a new uid/gid/prid), it will be
> > read straight out of the buffer rather than allocated, and hence the
> > constraint that allocated but unused dquots still need to have valid
> > CRCs.
> > 
> 
> The constraint makes sense when CRCs are enabled...
> 
> > FWIW, the dquot buffer read validates the CRC on all dquots in the
> > buffer when it comes off disk as it has no way of knowing what
> > dquots contain valid data or not. Same with the xfs_qm_dqcheck()
> > call - an unused dquot still needs to be a valid dquot to pass those
> > checks...
> > 
> 
> Yeah, that part makes sense. I've followed through and grokked most of
> the dquot buffer read and dquot CRC validation code, I think.
> 
> My question is more why is the code above (in xfs_qm_reset_dqcounts())
> not the following?
> 
> 	if (xfs_sb_version_hascrc(&mp->m_sb))
> 		xfs_update_cksum(...);

Because I forgot as it really doesn't matter at all. It wasn't
clear to me that this is what you were asking about the first time
around....

Fixed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
