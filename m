Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CC0787CA4
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 15:35:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9CD16304039
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 13:35:45 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id bRAzjgRELD6wu3nO (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2016 13:35:43 -0700 (PDT)
Date: Tue, 2 Aug 2016 13:35:11 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 18/47] xfs: refactor redo intent item processing
Message-ID: <20160802203511.GL8590@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907708421.25461.405239727630066080.stgit@birch.djwong.org>
	<20160801081023.GC30547@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160801081023.GC30547@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

On Mon, Aug 01, 2016 at 01:10:23AM -0700, Christoph Hellwig wrote:
> > +int
> > +xfs_efi_recover(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_efi_log_item	*efip)
> > +{
> > +	struct xfs_efd_log_item	*efdp;
> > +	struct xfs_trans	*tp;
> > +	int			i;
> > +	int			error = 0;
> > +	xfs_extent_t		*extp;
> > +	xfs_fsblock_t		startblock_fsb;
> > +
> > +	ASSERT(!test_bit(XFS_EFI_RECOVERED, &efip->efi_flags));
> > +
> > +	/*
> > +	 * First check the validity of the extents described by the
> > +	 * EFI.  If any are bad, then assume that all are bad and
> > +	 * just toss the EFI.
> > +	 */
> > +	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
> > +		extp = &(efip->efi_format.efi_extents[i]);
> > +		startblock_fsb = XFS_BB_TO_FSB(mp,
> > +				   XFS_FSB_TO_DADDR(mp, extp->ext_start));
> > +		if ((startblock_fsb == 0) ||
> > +		    (extp->ext_len == 0) ||
> > +		    (startblock_fsb >= mp->m_sb.sb_dblocks) ||
> > +		    (extp->ext_len >= mp->m_sb.sb_agblocks)) {
> > +			/*
> > +			 * This will pull the EFI from the AIL and
> > +			 * free the memory associated with it.
> > +			 */
> > +			set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
> > +			xfs_efi_release(efip);
> > +			return -EIO;
> > +		}
> > +	}
> 
> I know it's just a code move, but there are lots of superflous braces
> here, please remove them.

Ok.  It took me a while to figure out that you were referring to the
parentheses on the if tests and not the curly braces around the code
blocks.

> > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
> > +	if (error)
> > +		return error;
> > +	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
> > +
> > +	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
> > +		extp = &(efip->efi_format.efi_extents[i]);
> 
> and here..
> 
> > +		ASSERT(XFS_LSN_CMP(last_lsn, lip->li_lsn) >= 0);
> 
> This new check seems useful, but nothing in the changelog mentions
> why it has been added.
> 
> Otherwise this looks fine to me.

I'm adding the following to the commit message:

"Furthermore, ensure that log recovery only replays the redo items
that were in the AIL prior to recovery by checking the item LSN
against the largest LSN seen during log scanning.  As written this
should never happen, but we can be defensive anyway."

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
