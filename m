Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:28207 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750930AbdLHEyk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Dec 2017 23:54:40 -0500
Date: Fri, 8 Dec 2017 15:54:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] mkfs: Don't emit default config message yet
Message-ID: <20171208045422.GL5858@dastard>
References: <ba4823ed-fabd-d02c-42f3-40c8d5aa44a6@redhat.com>
 <62f67117-150d-e456-d9dd-3a19938cb03a@sandeen.net>
 <20171208042153.GI19219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171208042153.GI19219@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Dec 07, 2017 at 08:21:53PM -0800, Darrick J. Wong wrote:
> On Thu, Dec 07, 2017 at 10:13:15PM -0600, Eric Sandeen wrote:
> > Until we have more than one possible source of configuration,
> > there is no need to emit the only possibility and clutter
> > the output.  We can decide how it should all look when we
> > get more than one source.
> > 
> > Apply some i18n to the config description, though.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Looks ok, I guess,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> (I wonder why Dave put the printf in there, but I'll let him answer that.)

Because I wanted to demonstrate to everyone where the config file
based defaults should be introduced. i.e. before the printf that
says where the defaults were sourced from!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
