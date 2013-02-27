Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BD4797F63
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 17:31:58 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6F92AAC002
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 15:31:58 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	53sMPPhv1pDRVqjF for <xfs@oss.sgi.com>;
	Wed, 27 Feb 2013 15:31:56 -0800 (PST)
Date: Thu, 28 Feb 2013 10:31:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/9] xfs: add CRC checks to the AGFL
Message-ID: <20130227233155.GF5551@dastard>
References: <1358774760-21841-1-git-send-email-david@fromorbit.com>
	<1358774760-21841-5-git-send-email-david@fromorbit.com>
	<20130227223750.GZ22182@sgi.com> <20130227232045.GE5551@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130227232045.GE5551@dastard>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Feb 28, 2013 at 10:20:45AM +1100, Dave Chinner wrote:
> On Wed, Feb 27, 2013 at 04:37:50PM -0600, Ben Myers wrote:
> > Hi Dave,
....
> > > +	case XFS_BLF_AGFL_BUF:
> > > +		if (*(__be32 *)bp->b_addr != cpu_to_be32(XFS_AGFL_MAGIC)) {
> > > +			xfs_warn(mp, "Bad AGFL block magic!");
> > > +			ASSERT(0);
> > > +		}
> > > +		bp->b_ops = &xfs_agfl_buf_ops;
> > > +		break;
> > 
> > Your changes for v2 in this section look good.
> 
> Actually, the above hunk is broken. The magic number should only be
> checked for CRC enabled filesystems. My current code has this check,
> though I thought I fixed that long before I reposted this series...

I just realised you're commenting on the original version of the
patch series, no the new version I posted a couple of days ago. It
is fixed in that version of the patch, so I'm not going totally
crazy (yet!)....

Can you switch over to the newer version of the patch set?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
