Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58134 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751805AbeAIXQx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jan 2018 18:16:53 -0500
Date: Tue, 9 Jan 2018 15:16:46 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] xfs: use %px for data pointers when debugging
Message-ID: <20180109231646.GQ5602@magnolia>
References: <151553075309.16288.5030700495895866371.stgit@magnolia>
 <151553077155.16288.9554063846414673501.stgit@magnolia>
 <20180109230409.GP16421@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180109230409.GP16421@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jan 10, 2018 at 10:04:09AM +1100, Dave Chinner wrote:
> On Tue, Jan 09, 2018 at 12:46:11PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Starting with commit 57e734423ad ("vsprintf: refactor %pK code out of
> > pointer"), the behavior of the raw '%p' printk format specifier was
> > changed to print a 32-bit hash of the pointer value to avoid leaking
> > kernel pointers into dmesg.  For most situations that's good.
> > 
> > This is /undesirable/ behavior when we're trying to debug XFS, however,
> > so define a PTR_FMT that prints the actual pointer when we're in debug
> > mode.
> > 
> > Note that %p for tracepoints still prints the raw pointer, so in the
> > long run we could consider rewriting some of these messages as
> > tracepoints.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> It sucks to have to play games like this, but we have to be able to
> debug the code somehow....
> 
> > diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> > index fd03780..0949bab 100644
> > --- a/fs/xfs/xfs_linux.h
> > +++ b/fs/xfs/xfs_linux.h
> > @@ -291,4 +291,10 @@ static inline uint64_t howmany_64(uint64_t x, uint32_t y)
> >  #define XFS_IS_REALTIME_MOUNT(mp) (0)
> >  #endif
> >  
> > +#ifdef DEBUG
> > +# define PTR_FMT "%px"
> > +#else
> > +# define PTR_FMT "%p"
> > +#endif
> 
> Can you add a comment here explaining why this is different?

/*
 * Starting in Linux 4.15, the %p (raw pointer value) printk modifier
 * prints a hashed version of the pointer to avoid leaking kernel
 * pointers into dmesg.  If we're trying to debug the kernel we want the
 * raw values, so override this behavior as best we can.
 */

--D

> 
> Otherwise it looks OK.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
