Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5DBD27F47
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2016 16:52:23 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 54EA3304053
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2016 14:52:23 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	J1nwNn1slI2c6dFy for <xfs@oss.sgi.com>;
	Fri, 15 Jan 2016 14:52:21 -0800 (PST)
Date: Sat, 16 Jan 2016 09:52:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: check sizes of XFS on-disk structures at compile time
Message-ID: <20160115225219.GP6033@dastard>
References: <20160111232657.GA7831@birch.djwong.org>
	<20160115205801.GB5757@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160115205801.GB5757@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Fri, Jan 15, 2016 at 12:58:01PM -0800, Darrick J. Wong wrote:
> On Mon, Jan 11, 2016 at 03:26:57PM -0800, Darrick J. Wong wrote:
> > Check the sizes of XFS on-disk structures when compiling the kernel.
> > Use this to catch inadvertent changes in structure size due to padding
> > and alignment issues, etc.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
....
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_64,	32);
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_32,	28);
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_64,	32);
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_dq_logformat,		24);
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_icreate_log,		28);
> > +}
> 
> Perhaps this huge function ought to hide away in its own file?

Yes, I think that's a good idea, and I think it should only be built
on debug builds, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
