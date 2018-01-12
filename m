Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53166 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753186AbeALA3c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jan 2018 19:29:32 -0500
Date: Thu, 11 Jan 2018 16:29:27 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 21/27] xfs_scrub: scrub file data blocks
Message-ID: <20180112002927.GN5602@magnolia>
References: <151520348769.2027.9860697266310422360.stgit@magnolia>
 <151520361807.2027.808101481520701260.stgit@magnolia>
 <282321ba-d611-3fdc-7fc5-033f53cf0a5c@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <282321ba-d611-3fdc-7fc5-033f53cf0a5c@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Jan 11, 2018 at 05:25:58PM -0600, Eric Sandeen wrote:
> 
> 
> On 1/5/18 7:53 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> ...
> 
> > +		/* Get the stat info for this directory entry. */
> > +		error = fstatat(dir_fd, dirent->d_name, &sb,
> > +				AT_NO_AUTOMOUNT | AT_SYMLINK_NOFOLLOW);
> > +		if (error) {
> > +			str_errno(ctx, newpath);
> > +			continue;
> 
> I needed:
> 
> +#ifndef AT_NO_AUTOMOUNT
> +#define AT_NO_AUTOMOUNT 0x800
> +#endif

Fixed.

--D

> here
> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
