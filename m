Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41913 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbfAaS0O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Jan 2019 13:26:14 -0500
Received: by mail-pg1-f195.google.com with SMTP id m1so1697651pgq.8
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 10:26:13 -0800 (PST)
Date: Thu, 31 Jan 2019 10:26:09 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH 01/10] xfs: Fix xqmstats offsets in /proc/fs/xfs/xqmstat
Message-ID: <20190131182609.GN11489@garbanzo.do-not-panic.com>
References: <20190131180919.2500-1-mcgrof@kernel.org>
 <20190131180919.2500-2-mcgrof@kernel.org>
 <20190131181903.GB4989@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190131181903.GB4989@kroah.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-xfs@vger.kernel.org, Alexander.Levin@microsoft.com, amir73il@gmail.com, hch@infradead.org, Carlos Maiolino <cmaiolino@redhat.com>, Dave Chinner <david@fromorbit.com>

On Thu, Jan 31, 2019 at 07:19:03PM +0100, Greg KH wrote:
> On Thu, Jan 31, 2019 at 10:09:10AM -0800, Luis Chamberlain wrote:
> > From: Carlos Maiolino <cmaiolino@redhat.com>
> > 
> > The addition of FIBT, RMAP and REFCOUNT changed the offsets into
> > __xfssats structure.
> > 
> > This caused xqmstat_proc_show() to display garbage data via
> > /proc/fs/xfs/xqmstat, once it relies on the offsets marked via macros.
> > 
> > Fix it.
> > 
> > Fixes: 00f4e4f9 xfs: add rmap btree stats infrastructure
> > Fixes: aafc3c24 xfs: support the XFS_BTNUM_FINOBT free inode btree type
> > Fixes: 46eeb521 xfs: introduce refcount btree definitions
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> > Signed-off-by: Dave Chinner <david@fromorbit.com>
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > ---
> >  fs/xfs/xfs_stats.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> You do not list what the upstream git commit ids are on any of these
> patches :(
> 
> That's a requirement, sorry, can you respin these and add that to the
> first line of the commit, as is normally done in the stable patches?

Sure thing, sorry forgot about that. Will wait for review on the set
first, and if there are no complaints will send a v2 as required.

  Luis
