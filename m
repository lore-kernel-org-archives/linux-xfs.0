Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:60212 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751480AbeBYCra (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Feb 2018 21:47:30 -0500
Date: Sun, 25 Feb 2018 13:47:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Reflink (cow) copy of busy files
Message-ID: <20180225024727.GD30854@dastard>
References: <9e69fcd01e1c02ea53e0e1ac66d60d24@assyoma.it>
 <20180224220757.GC30854@dastard>
 <711dd96e3c4b3e92d3fb38a01e77dc64@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <711dd96e3c4b3e92d3fb38a01e77dc64@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-xfs@vger.kernel.org

On Sat, Feb 24, 2018 at 11:57:32PM +0100, Gionatan Danti wrote:
> Il 24-02-2018 23:07 Dave Chinner ha scritto:
> >Define "busy file", please.
> 
> Think about a running virtual machine. Maybe an XFS-based virtual
> image (ie: a CentOS 7 guest).
> 
> >If the file is being actively written, then the clone will not be
> >consistent.
> >
> >Yes, it's just like any other snapshot process - you have to quiesce
> >everything that is writing to the file before cloning it. i.e. the
> >data in the file needs to be in a stable, consistent, unchanging
> >state if you want the clone to contain consistent data...
> 
> About *what* level of consistency are we speaking? I understand that
> application-level consistency requires a quiesced filesystem and,
> possibly, an application-level agent. But is it a quiesced
> filesystem a requisite for a *crash-consistent* ie: pull the plug)
> snapshot?

Yes, you have to freeze the filesystem to get a crash-consistent
snapshot of the filesystem.

> In other words: would a cp --reflink=always <vmdisk> <snapshot> of a
> runnig virtual machine produce an usable, crash-consistent snapshot,
> or it risks ending with binary garbage?

You will end up with garbage.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
