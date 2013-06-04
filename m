Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3534929DF8
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 16:46:16 -0500 (CDT)
Date: Tue, 4 Jun 2013 16:46:12 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/6] xfs: rework dquot CRCs
Message-ID: <20130604214612.GL20932@sgi.com>
References: <1370237332-24757-1-git-send-email-david@fromorbit.com>
	<1370237332-24757-2-git-send-email-david@fromorbit.com>
	<51ACDDF9.1040202@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51ACDDF9.1040202@redhat.com>
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
To: Dave Chinner <dchinner@redhat.com>, Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Jun 03, 2013 at 02:18:33PM -0400, Brian Foster wrote:
> On 06/03/2013 01:28 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Calculating dquot CRCs when the backing buffer is written back just
> > doesn't work reliably. There are several places which manipulate
> > dquots directly in the buffers, and they don't calculate CRCs
> > appropriately, nor do they always set the buffer up to calculate
> > CRCs appropriately.
> > 
> > Firstly, if we log a dquot buffer (e.g. during allocation) it gets
> > logged without valid CRC, and so on recovery we end up with a dquot
> > that is not valid.
> > 
> > Secondly, if we recover/repair a dquot, we don't have a verifier
> > attached to the buffer and hence CRCs arenot calculate don the way
> > down to disk.
> > 
> > Thirdly, calculating the CRC after we've changed the contents means
> > that if we re-read the dquot from the buffer, we cannot verify the
> > contents of the dquot are valid, as the CRC is invalid.
> > 
> > So, to avoid all the dquot CRC errors that are being detected by the
> > read verifier, change to using the same model as for inodes. that
> > is, dquot CRCs are calculated and written to the backing buffer at
> > the time the dquot is flushed to the backing buffer. If we modify
> > the dquuot directly in the backing buffer, calculate the CRC
> > immediately after the modification is complete. Hence the dquot in
> > the on-disk buffer should always have a valid CRC.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > ---
> >  fs/xfs/xfs_dquot.c       |   37 ++++++++++++++++---------------------
> >  fs/xfs/xfs_log_recover.c |   10 ++++++++++
> >  fs/xfs/xfs_qm.c          |   40 ++++++++++++++++++++++++++++++----------
> >  fs/xfs/xfs_quota.h       |    2 ++
> >  4 files changed, 58 insertions(+), 31 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index a41f8bf..044e97a 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> > @@ -249,8 +249,11 @@ xfs_qm_init_dquot_blk(
> >  		d->dd_diskdq.d_version = XFS_DQUOT_VERSION;
> >  		d->dd_diskdq.d_id = cpu_to_be32(curid);
> >  		d->dd_diskdq.d_flags = type;
> > -		if (xfs_sb_version_hascrc(&mp->m_sb))
> > +		if (xfs_sb_version_hascrc(&mp->m_sb)) {
> >  			uuid_copy(&d->dd_uuid, &mp->m_sb.sb_uuid);
> > +			xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
> > +					 XFS_DQUOT_CRC_OFF);
> > +		}
> >  	}
> >  
> >  	xfs_trans_dquot_buf(tp, bp,

Huh.  Looks like this buffer will not be recovered.  See
xlog_recover_do_reg_buffer... I think he'll be skipped in recovery.  Goto next.

That's not an issue with this patch though.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
