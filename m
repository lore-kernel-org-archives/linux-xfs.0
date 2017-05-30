Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46163 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750912AbdE3So6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 May 2017 14:44:58 -0400
Date: Tue, 30 May 2017 11:44:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0.9/9] xfs: introduce the XFS_IOC_GETFSMAP ioctl
Message-ID: <20170530184452.GB4519@birch.djwong.org>
References: <149417257252.24656.2629280196308754994.stgit@birch.djwong.org>
 <20170508194755.GK5973@birch.djwong.org>
 <9d94c89f-f730-955c-bde3-eb9264737303@sandeen.net>
 <20170526214142.GO4521@birch.djwong.org>
 <0e27be7e-17b0-391f-bc80-512ad5523436@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e27be7e-17b0-391f-bc80-512ad5523436@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Fri, May 26, 2017 at 05:12:25PM -0500, Eric Sandeen wrote:
> On 5/26/17 4:41 PM, Darrick J. Wong wrote:
> > On Fri, May 26, 2017 at 04:20:49PM -0500, Eric Sandeen wrote:
> >>
> >>
> >> On 5/8/17 2:47 PM, Darrick J. Wong wrote:
> >>> From: Darrick J. Wong <darrick.wong@oracle.com>
> >>>
> >>> Introduce a new ioctl that uses the reverse mapping btree to return
> >>> information about the physical layout of the filesystem.
> >>>
> >>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> >>
> >> Ok, howzabout this:
> >>
> >> Changes from your version:
> >>
> >> - remove libxfs stuff, I synced that separately already
> >> - rename sys_fsmap just fsmap (it's not a syscall)
> >> - change meaning of "have_fsmap" - it now means we have it on the
> >>   system, not that this platform (linux) might support it.*
> > 
> > I'll have a look... though afaict this removes anything that would
> > prevent us from building the fsmap stuff on a non-linux platform.
> > Seeing as fsmap is linux-only, we might as well restrict it on the
> > platforms we still support.
> 
> Right, so in this patch, either we define HAVE_GETFSMAP if we find
> it on the system, or we implement it in include/linux.h and define
> it then.  So HAVE_GETFSMAP won't get set on non-linux.
> 
> But in the next patch that actually makes use of the fsmap ioctl,
> we'll need to conditionally include fsmap.c, and then all should
> be good, I think, right?  Something like:
> 
> +# On linux we get fsmap from the system or define it ourselves
> +# so include this based on platform type.  If this reverts to only
> +# the autoconf check w/o local definition, change to testing HAVE_GETFSMAP
> +ifeq ($(PKG_PLATFORM),linux)
> +CFILES += fsmap.c
> +endif

Yes, I think that will be fine.  Do you want me to respin the patches
as they are now (having been fixed), or should I wait for a for-next
rebase with whatever's in your tree?

--D

> 
> > Darwin?  (I think Jan Tulak added this, though OSX doen't do XFS...)
> > BSD?  (Wasn't XFS removed from their kernel a few years ago?)
> 
> Jan, do you still use it? 
> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
