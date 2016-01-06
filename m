Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 44E2D7F47
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 16:24:14 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0C6138F8052
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 14:24:13 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	PgchBayvQY30g3vF for <xfs@oss.sgi.com>;
	Wed, 06 Jan 2016 14:24:11 -0800 (PST)
Date: Thu, 7 Jan 2016 09:24:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: handle dquot buffer readahead in log recovery
	correctly
Message-ID: <20160106222410.GK21461@dastard>
References: <1452052834-20605-1-git-send-email-david@fromorbit.com>
	<20160106143409.GA14682@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160106143409.GA14682@bfoster.bfoster>
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

On Wed, Jan 06, 2016 at 09:34:09AM -0500, Brian Foster wrote:
> On Wed, Jan 06, 2016 at 03:00:34PM +1100, Dave Chinner wrote:
> > @@ -264,6 +264,21 @@ xfs_dquot_buf_read_verify(
> >  }
> >  
> >  /*
> > + * readahead errors are silent and simply leave the buffer as !done so
> > + * a real read will then be run with the xfs_dquot_buf_ops verifier.
> > + */
> > +static void
> > +xfs_dquot_buf_readahead_verify(
> > +	struct xfs_buf	*bp)
> > +{
> > +	struct xfs_mount	*mp = bp->b_target->bt_mount;
> > +
> > +	if (!xfs_dquot_buf_verify_crc(mp, bp) &&
> > +	    !xfs_dquot_buf_verify(mp, bp, 0))
> > +		bp->b_flags &= ~XBF_DONE;
> 
> Shouldn't this condition trigger if either the crc or buffer
> verification fails (not if both fail)?

Yup, got my logic tangled there.

> Also, xfs_buf_ioend() sets XBF_DONE when bp->b_error == 0 after the read
> verifier is invoked. I don't see bp->b_error being set here, so it looks
> like clearing this flag wouldn't have any effect.

Hmmm - I just copied that from the inode readahead verifier. So
that's not working properly, either. I'll fix that, too.

Thanks, Brian.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
