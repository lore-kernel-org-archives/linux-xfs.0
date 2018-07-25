Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37334 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731442AbeGZAJZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jul 2018 20:09:25 -0400
Date: Wed, 25 Jul 2018 15:55:26 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3] libxfs: add more bounds checking to sb sanity checks
Message-ID: <20180725225526.GC4218@magnolia>
References: <20180713131003.31121-1-billodo@redhat.com>
 <20180725213336.16263-1-billodo@redhat.com>
 <bee8d307-e372-2b67-e46e-f54b6dd81379@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bee8d307-e372-2b67-e46e-f54b6dd81379@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Bill O'Donnell <billodo@redhat.com>, linux-xfs@vger.kernel.org

On Wed, Jul 25, 2018 at 03:48:51PM -0700, Eric Sandeen wrote:
> 
> 
> On 7/25/18 2:33 PM, Bill O'Donnell wrote:
> > +	/* Additional sb sanity checks for writes */
> > +	if (!error) {
> > +		if (sb.sb_fdblocks > sb.sb_dblocks ||
> > +		    sb.sb_ifree > sb.sb_icount) {
> > +			    xfs_notice(mp, "SB sanity check failed");
> > +			    error = -EFSCORRUPTED;
> > +		}
> > +	}
> 
> I had kind of had it in my head that Dave suggested testing not
> only sb_fdblocks & sb_ifree but also validating sb_icount against
> sb_dblocks ... would that make sense?  something like:
> 
> +		if (sb.sb_fdblocks > sb.sb_dblocks ||
> +		    sb.sb_icount / sb.sb_inopblock > sb.sb_dblocks) ||

That would make sense, but perhaps we should have a xfs_verify_icount
instead of open-coding a 64-bit division? :)

Granted, I /was/ planning to add all that as part of fs summary counter
scrubbing next cycle.

--D

> +		    sb.sb_ifree > sb.sb_icount) {
> +			    xfs_notice(mp, "SB sanity check failed");
> 
> because all 3 go into the statfs calculations which went wonky
> in the original report?  (xfs_sb_verify has done some sanity
> checks on sb_inopblock by the time we get here.)
> 
> Also, a comment about why these checks are only for write, and are not
> simply in xfs_mount_validate_sb() would be good, since that obviously
> wasn't obvious to me at first.  o_O :)
> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
