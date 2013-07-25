Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 911FA7F37
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 11:33:25 -0500 (CDT)
Date: Thu, 25 Jul 2013 11:33:21 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 12/48] xfs: add CRC checking to dir2 leaf blocks
Message-ID: <20130725163321.GY3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-13-git-send-email-david@fromorbit.com>
	<20130724230014.GU3111@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130724230014.GU3111@sgi.com>
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

On Wed, Jul 24, 2013 at 06:00:14PM -0500, Ben Myers wrote:
> On Fri, Jun 07, 2013 at 10:25:35AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > This addition follows the same pattern as the dir2 block CRCs.
> > Seeing as both LEAF1 and LEAFN types need to changed at the same
> > time, this is a pretty large amount of change. leaf block headers
> > need to be abstracted away from the on-disk structures (struct
> > xfs_dir3_icleaf_hdr), as do the base leaf entry locations.
> > 
> > This header abstract allows the in-core header and leaf entry
> > location to be passed around instead of the leaf block itself. This
> > saves a lot of converting individual variables from on-disk format
> > to host format where they are used, so there's a good chance that
> > the compiler will be able to produce much more optimal code as it's
> > not having to byteswap variables all over the place.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Looks good.  Note that xfs_dir3_leafn_read_verify and
> xfs_dir3_leafn_write_verify are static in the kernel but not in userspace.  
> 
> Reviewed-by: Ben Myers <bpm@sgi.com>

corresponds to commit 24df33b45ecf5.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
