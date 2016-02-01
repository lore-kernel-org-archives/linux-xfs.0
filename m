Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B8A9D7CA2
	for <xfs@oss.sgi.com>; Sun, 31 Jan 2016 23:06:43 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8B308304059
	for <xfs@oss.sgi.com>; Sun, 31 Jan 2016 21:06:43 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	pbDdkGRZ7IOzNuQs for <xfs@oss.sgi.com>;
	Sun, 31 Jan 2016 21:06:41 -0800 (PST)
Date: Mon, 1 Feb 2016 16:06:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: check sizes of XFS on-disk structures at compile time
Message-ID: <20160201050626.GS6033@dastard>
References: <20160111232657.GA7831@birch.djwong.org>
	<20160115205801.GB5757@birch.djwong.org>
	<20160115225219.GP6033@dastard>
	<20160120154035.GH1366@meili.valhalla.31bits.net>
	<20160122220145.GA26408@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160122220145.GA26408@birch.djwong.org>
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
Cc: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>, xfs@oss.sgi.com

On Fri, Jan 22, 2016 at 02:01:45PM -0800, Darrick J. Wong wrote:
> On Wed, Jan 20, 2016 at 10:40:36AM -0500, Josef 'Jeff' Sipek wrote:
> > On Sat, Jan 16, 2016 at 09:52:19AM +1100, Dave Chinner wrote:
> > > On Fri, Jan 15, 2016 at 12:58:01PM -0800, Darrick J. Wong wrote:
> > > > On Mon, Jan 11, 2016 at 03:26:57PM -0800, Darrick J. Wong wrote:
> > > > > Check the sizes of XFS on-disk structures when compiling the kernel.
> > > > > Use this to catch inadvertent changes in structure size due to padding
> > > > > and alignment issues, etc.
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ....
> > > > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_64,	32);
> > > > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_32,	28);
> > > > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_64,	32);
> > > > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_dq_logformat,		24);
> > > > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
> > > > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_icreate_log,		28);
> > > > > +}
> > > > 
> > > > Perhaps this huge function ought to hide away in its own file?
> > > 
> > > Yes, I think that's a good idea, and I think it should only be built
> > > on debug builds, too.
> > 
> > Doesn't this turn into nothingness as far as the generated binary is
> > concerned?  Because if it does, I don't see a reason to keep it debug-only.
> > Afterall, non-debug builds need to be correct and these are pretty important
> > checks.  We certainly don't want another ARM structure padding & alignment
> > fiasco.
> 
> I moved the function to a separate header file and changed the declaration to:
> 
> static inline void __init xfs_check_ondisk_structs(void)
> 
> With any luck that should compile down to an empty inline function which should
> be optimized out of the resulting code.  Worst case it's a separate function
> that gets discarded after the module loads.  If Dave doesn't object, I'll leave
> it enabled for all builds.

Really, it doesn't matter either way....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
