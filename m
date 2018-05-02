Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:46170 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751240AbeEBV5E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 17:57:04 -0400
Date: Thu, 3 May 2018 07:57:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5 V2] xfs: implement online get/set fs label
Message-ID: <20180502215701.GC23861@dastard>
References: <eb592fc3-3165-5ec7-3896-b798fc7f6502@redhat.com>
 <698bd41a-9281-83a2-ff51-64547025442a@sandeen.net>
 <2a638f02-ea72-0d5e-30a4-1d95cfe6ff69@sandeen.net>
 <20180502142420.GL4127@magnolia>
 <d364f3c8-110a-fb69-f2a5-c3b5716f556e@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d364f3c8-110a-fb69-f2a5-c3b5716f556e@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, May 02, 2018 at 09:28:35AM -0500, Eric Sandeen wrote:
> On 5/2/18 9:24 AM, Darrick J. Wong wrote:
> > On Tue, May 01, 2018 at 06:04:09PM -0500, Eric Sandeen wrote:
> >> The GET ioctl is trivial, just return the current label.
> >> +static int
> >> +xfs_ioc_getlabel(
> >> +	struct xfs_mount	*mp,
> >> +	char			__user *label)
> >> +{
> >> +	struct xfs_sb		*sbp = &mp->m_sb;
> >> +
> >> +	/* Paranoia */
> >> +	BUILD_BUG_ON(sizeof(sbp->sb_fname) > FSLABEL_MAX);
> >> +
> >> +	if (copy_to_user(label, sbp->sb_fname, sizeof(sbp->sb_fname)))
> > 
> > Needs to ensure that a null is set at the end of the (userspace) buffer
> > just in case the label is "123456789012".
> 
> Oh, yup!
> 
> > There's nothing in the documentation for this ioctl <cough> that says
> > the passed in buffer must already be zeroed.
> 
> where /do/ we document ioctls like this, anyway?

man pages. You should really cc linux-api@vger.kernel.org on any
patch that introduces/hoists a new VFS ioctl, as well as the man
page patch to document it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
