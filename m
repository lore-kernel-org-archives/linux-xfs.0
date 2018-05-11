Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:64064 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750794AbeEKXyJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 May 2018 19:54:09 -0400
Date: Sat, 12 May 2018 09:54:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: test mount vs superblock shrinker races
Message-ID: <20180511235406.GA23861@dastard>
References: <20180511021152.10803-1-david@fromorbit.com>
 <CAOQ4uxh+D_1jEJquR5uyv2-AQpnNyZ9iiXFSqW6eSMmcPDi7Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh+D_1jEJquR5uyv2-AQpnNyZ9iiXFSqW6eSMmcPDi7Jw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, May 11, 2018 at 08:41:58AM +0300, Amir Goldstein wrote:
> On Fri, May 11, 2018 at 5:11 AM, Dave Chinner
> <david@fromorbit.com> wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > Test case for superblock shrinkers running while the filesystem
> > is being set up and/or torn down and tripping over inconsistent
> > state.
> >
> > Signed-Off-By: Dave Chinner <dchinner@redhat.com> ---
...
> 
> Isn't it dangerous for the time being? Your fix commit message
> says you got reports of OOPS.

If you have a kernel with the mount_delay sysfs option, you will
have a kernel with the fix. If you don't have mount_delay, the test
won't run.

> Not sure what should be the authoritative condition to remove dangerous
> point kernel release with a fix??

I'm not going to add "dangerous" to new regression tests that have a
fix pending anymore because nobody is doing maintenance tasks like
sweeping out tests that aren't dangerous to upstream. Tagging new
regression tests as dangerous just creates unnecessary technical
debt.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
