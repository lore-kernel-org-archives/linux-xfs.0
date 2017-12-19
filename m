Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:17897 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750737AbdLSUsp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Dec 2017 15:48:45 -0500
Date: Wed, 20 Dec 2017 07:48:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/13] xfs: move inode fork verifiers to xfs_dinode_verify
Message-ID: <20171219204843.GZ4094@dastard>
References: <151320949282.30654.14805160700975182459.stgit@magnolia>
 <151320952955.30654.5858027812526222455.stgit@magnolia>
 <20171219051619.GP4094@dastard>
 <20171219203459.GB12613@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171219203459.GB12613@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Dec 19, 2017 at 12:34:59PM -0800, Darrick J. Wong wrote:
> On Tue, Dec 19, 2017 at 04:16:19PM +1100, Dave Chinner wrote:
> > On Wed, Dec 13, 2017 at 03:58:49PM -0800, Darrick J. Wong wrote:
> > > +	if (mode && dip->di_forkoff > mp->m_sb.sb_inodesize)
> > > +		return __this_address;
> > 
> > Hold on, this check is completely bogus. di_forkoff is in units of 8 bytes,
> > which inode size is in bytes. Also, di_forkoff is a u8, so it can't
> > /ever/ be larger than the inode size which are >= 256 bytes. Yeah,
> > though so:
> > 
> > #define XFS_DFORK_BOFF(dip)             ((int)((dip)->di_forkoff << 3))
> > 
> > This check needs to be:
> > 
> > 	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
> > 		return __this_address;
> > 
> > Otherwise looks good.
> 
> Oops, thank you for catching that!

Wasn't your bug - the existing code has had this check for a long
time and nobody has noticed it was bogus until now :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
