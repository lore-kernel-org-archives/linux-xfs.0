Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:10169 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750950AbeCNVK5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Mar 2018 17:10:57 -0400
Date: Thu, 15 Mar 2018 08:10:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fsck.xfs: allow forced repairs using xfs_repair
Message-ID: <20180314211054.GI18129@dastard>
References: <2d50aa97-a03b-128f-f4f6-4a6416fac69b@sandeen.net>
 <20180305223148.GG18129@dastard>
 <421d1afd-5af1-aef9-e6bb-3addcdeeff3f@sandeen.net>
 <CACj3i73y_ZWvgdv3aKTKaKGuo+6uhcfy1465T3CD2uQDLE3=xQ@mail.gmail.com>
 <20180306213915.GJ18129@dastard>
 <CACj3i71SHP90DOAhpS3kWyY_6gnx9OzTqgHy7=uxAZH0cfUKMw@mail.gmail.com>
 <20180308162838.GY18989@magnolia>
 <20180308223652.GT18129@dastard>
 <CACj3i720ppnLEyF0k7Sv7Nf27SubnpC+N2A=7Y60st+ncGCG7w@mail.gmail.com>
 <20180314152504.GP4865@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180314152504.GP4865@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jan Tulak <jtulak@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Mar 14, 2018 at 08:25:04AM -0700, Darrick J. Wong wrote:
> On Wed, Mar 14, 2018 at 02:51:51PM +0100, Jan Tulak wrote:
> > On Thu, Mar 8, 2018 at 11:36 PM, Dave Chinner <david@fromorbit.com> wrote:
> > >> > - if the volume/device has a dirty log, exit with 4 - errors left
> > >> > uncorrected (drop to the shell)
> > >
> > > Yup.
> > >
> > >> > - if we find no errors, exit with 0 - no errors
> > >
> > > Yup, but only if the filesystem is not mounted, otherwise it's
> > > "requires reboot" because repair with no errors still rewrites all
> > > the per-ag metadata and so changes the on disk metadata layout.
> > > Continuing at this point with a mounted filesystem is guaranteed to
> > > corrupt the filesystem.
> > 
> > We refuse to start with a mounted fs, so this is no issue.
> > 
> > >
> > >> > - if we find anything and xfs_repair ends successfully, exit with 1 -
> > >> > errors corrected
> > >
> > > Same as the above case - needs reboot.
> > 
> > Do we? The fs wasn't mounted at this point yet. Maybe there is a
> > reason for a reboot, I just don't know about it. :-)
> 
> I agree that it's fine to move on to mounting the rootfs provided we
> don't do -d.

Right, my was "same as the above case" where I said:

| Yup, but only if the filesystem is not mounted, otherwise it's
| "requires reboot"

-Dave.

-- 
Dave Chinner
david@fromorbit.com
