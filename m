Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:34962 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753431AbeBAADM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jan 2018 19:03:12 -0500
Date: Wed, 31 Jan 2018 16:03:06 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/4] xfs: add scrub to XFS_BUILD_OPTIONS
Message-ID: <20180201000306.GI4849@magnolia>
References: <2f4bb05f-fd41-7fa3-22f0-9ec9d2224a47@redhat.com>
 <f5769e20-970a-53f5-4fc7-2afd11304ce2@sandeen.net>
 <20171201222922.GZ21412@magnolia>
 <ad19d44f-87bc-0db7-f890-38de214d8acc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad19d44f-87bc-0db7-f890-38de214d8acc@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Dec 01, 2017 at 04:31:04PM -0600, Eric Sandeen wrote:
> On 12/1/17 4:29 PM, Darrick J. Wong wrote:
> > On Fri, Dec 01, 2017 at 04:12:34PM -0600, Eric Sandeen wrote:
> >> Advertise this config option along with the others.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>
> >> diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
> >> index fcc5dfc..8cee8e8 100644
> >> --- a/fs/xfs/xfs_super.h
> >> +++ b/fs/xfs/xfs_super.h
> >> @@ -44,6 +44,12 @@
> >>  # define XFS_REALTIME_STRING
> >>  #endif
> >>  
> >> +#ifdef CONFIG_XFS_ONLINE_SCRUB
> >> +# define XFS_SCRUB_STRING	"scrub, "
> >> +#else
> >> +# define XFS_SCRUB_STRING
> >> +#endif
> > 
> > I don't mind this addition to the build options, though I had pictured
> > scrub becoming an integral part of xfs some day and not remaining a
> > configurable option.
> 
> It could be removed at that time, unless it's considered an API?
> 
> I'm not hung up on this, if there's no reason for it that's OK.
> 
> > That said I haven't evaluated how much scrub bloats up xfs nor do I know
> > if the kernel tinyfication people would actually want to turn it off??
> > 
> > (For my part I prefer it some day not be Kconfig option so that it won't
> > bitrot ala CONFIG_XFS_RT=y.)
> 
> I'd imagine that it'd be turned on more often than RT but that's just a guess.

Ok, now that we've merged all this stuff, it looks like disabling the
scrub code alone can reduce the module size by ~8%.  I can imagine the
occasional system builder who wants xfs but doesn't care about online
fsck, so I think I'll keep the kconfig option.  Therefore, it ought to
go in the build string.

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> -Eric
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
