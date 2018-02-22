Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58562 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751959AbeBVXHf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 18:07:35 -0500
Date: Thu, 22 Feb 2018 15:02:30 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] libxfs: don't return cnt as failure from XFS_BUF_SET_PTR
Message-ID: <20180222230230.GI9827@magnolia>
References: <7514683c-3a04-5fd6-a455-c09a5b370bc5@redhat.com>
 <20180222214647.GH9827@magnolia>
 <9dee9e11-3480-8406-1d8e-8fc14220371b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9dee9e11-3480-8406-1d8e-8fc14220371b@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Feb 22, 2018 at 04:41:17PM -0600, Eric Sandeen wrote:
> On 2/22/18 3:46 PM, Darrick J. Wong wrote:
> > On Thu, Feb 22, 2018 at 03:33:04PM -0600, Eric Sandeen wrote:
> >> We must not get here very often, because any test of an error
> >> from XFS_BUF_SET_PTR will fail because it  returns whatever
> >> is sent in as cnt.  Fix the macro to return 0 so that
> >> "error = XFS_BUF_SET_PTR()" works as expected.
> >>
> >> Should probably make this xfs_buf_associate_memory() to be
> >> more like kernelspace, but for now just fix up the bug.
> >>
> >> Found this via xfs_logprint failing for no good reason.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>
> >> diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> >> index 81d2804..0ae7a28 100644
> >> --- a/libxfs/libxfs_io.h
> >> +++ b/libxfs/libxfs_io.h
> >> @@ -105,6 +105,7 @@ enum xfs_buf_flags_t {	/* b_flags bits */
> >>  #define XFS_BUF_SET_PTR(bp,p,cnt)	({	\
> >>  	(bp)->b_addr = (char *)(p);		\
> >>  	XFS_BUF_SET_COUNT(bp,cnt);		\
> >> +	0;					\
> > 
> > There are only two callers of this macro and it's not exported to
> > xfslibs headers, so why not just fix them not to care about the return
> > value?
> 
> because it marginally matches kernel code ... *shrug* I'd rather
> have libxlog diverge less from kernel, not more, overall.

Uhh... well in that case, I think you should rename XFS_BUF_SET_PTR
with xfs_buf_associate_memory (the helper function that
xlog_bread_offset uses in the kernel).

--D

> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
