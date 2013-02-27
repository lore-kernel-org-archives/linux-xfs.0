Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5C32D7F63
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 17:35:38 -0600 (CST)
Date: Wed, 27 Feb 2013 17:35:37 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 4/9] xfs: add CRC checks to the AGFL
Message-ID: <20130227233537.GB22182@sgi.com>
References: <1358774760-21841-1-git-send-email-david@fromorbit.com>
	<1358774760-21841-5-git-send-email-david@fromorbit.com>
	<20130227223750.GZ22182@sgi.com> <20130227232045.GE5551@dastard>
	<20130227233155.GF5551@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130227233155.GF5551@dastard>
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

Dave,

On Thu, Feb 28, 2013 at 10:31:55AM +1100, Dave Chinner wrote:
> On Thu, Feb 28, 2013 at 10:20:45AM +1100, Dave Chinner wrote:
> > On Wed, Feb 27, 2013 at 04:37:50PM -0600, Ben Myers wrote:
> > > Hi Dave,
> ....
> > > > +	case XFS_BLF_AGFL_BUF:
> > > > +		if (*(__be32 *)bp->b_addr != cpu_to_be32(XFS_AGFL_MAGIC)) {
> > > > +			xfs_warn(mp, "Bad AGFL block magic!");
> > > > +			ASSERT(0);
> > > > +		}
> > > > +		bp->b_ops = &xfs_agfl_buf_ops;
> > > > +		break;
> > > 
> > > Your changes for v2 in this section look good.
> > 
> > Actually, the above hunk is broken. The magic number should only be
> > checked for CRC enabled filesystems. My current code has this check,
> > though I thought I fixed that long before I reposted this series...
> 
> I just realised you're commenting on the original version of the
> patch series, no the new version I posted a couple of days ago. It
> is fixed in that version of the patch, so I'm not going totally
> crazy (yet!)....

Yep.  The new rev looks good.

> Can you switch over to the newer version of the patch set?

Will do.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
