Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24816 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdJDDPB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 23:15:01 -0400
Date: Tue, 3 Oct 2017 20:14:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/25] xfs: probe the scrub ioctl
Message-ID: <20171004031456.GJ6503@magnolia>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706326848.19351.10670988265979551239.stgit@magnolia>
 <20171003233247.GQ3666@dastard>
 <20171004000209.GG6503@magnolia>
 <20171004015606.GY3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171004015606.GY3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 04, 2017 at 12:56:06PM +1100, Dave Chinner wrote:
> On Tue, Oct 03, 2017 at 05:02:09PM -0700, Darrick J. Wong wrote:
> > On Wed, Oct 04, 2017 at 10:32:47AM +1100, Dave Chinner wrote:
> > > On Tue, Oct 03, 2017 at 01:41:08PM -0700, Darrick J. Wong wrote:
> > > > +/*
> > > > + * Scrub probe -- userspace uses this to probe if we're willing to
> > > > + * scrub or repair a given mountpoint.
> > > > + */
> > > > +int
> > > > +xfs_scrub_probe(
> > > > +	struct xfs_scrub_context	*sc)
> > > > +{
> > > > +	if (sc->sm->sm_ino || sc->sm->sm_agno)
> > > > +		return -EINVAL;
> > > > +	if (sc->sm->sm_gen & ~XFS_SCRUB_FLAGS_OUT)
> > > 
> > > sm_flags?
> > 
> > sm_gen is correct because in xfs_scrub_probe we reflect back to
> > userspace any valid scrub outflags that were passed in via sm_gen.
> > Therefore we have to check sm_gen for unknown output flags so that we
> > can error out on any invalid inputs from userland.
> 
> Hmmm - seeing sm_ino and sm_gen in the same structure immediately
> makes me think {inode number, generation} tuple for uniquely
> identifying inodes from userspace. What on earth would scrub output
> flags be doing in a generation number? Indeed, from the first patch:

For actual inode-related scrubbing, yes sm_ino/sm_gen represent a tuple
for uniquely identifying inodes.

> +struct xfs_scrub_metadata {
> +       __u32 sm_type;          /* What to check? */
> +       __u32 sm_flags;         /* flags; see below. */
> +       __u64 sm_ino;           /* inode number. */
> +       __u32 sm_gen;           /* inode generation. */
> +       __u32 sm_agno;          /* ag number. */
> +       __u64 sm_reserved[5];   /* pad to 64 bytes */
> ....
> 
> It is an inode generation number?
> 
> So I'm somewhat confused by flags appearing in the generation
> number...
> 
> > xfs_scrub_metadata() unconditionally clears all the out flags from
> > sm_flags on its way in, prior to any of the scrub handlers being called.
> > 
> > (It's possible I'm misunderstanding your question.)
> 
> What has tripped me up is that the probe function sm_gen abuse isn't
> documented in this patch, so I had no idea why oflags were in
> sm_gen.  Maybe you explained it previously, but I don't remember
> that detail and there's nothing in the patch to remind me....

Yeah... we /are/ abusing the sm_gen field for the dorky probe function.
xfs_io doesn't touch it at all and xfs_scrub doesn't do much with it.
Easier just to drop it.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
