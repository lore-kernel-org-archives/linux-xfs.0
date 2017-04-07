Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:40772 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752615AbdDGBW5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2017 21:22:57 -0400
Date: Fri, 7 Apr 2017 11:22:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs: rtinherit minval should be 0
Message-ID: <20170407012215.GS17542@dastard>
References: <20170406143426.19727-1-jtulak@redhat.com>
 <6c83318d-ef75-4dc2-e366-d50d74fb71e6@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c83318d-ef75-4dc2-e366-d50d74fb71e6@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On Thu, Apr 06, 2017 at 11:58:45AM -0500, Eric Sandeen wrote:
> On 4/6/17 9:34 AM, Jan Tulak wrote:
> > As with any other option, rtinherit=[0|1], but minval was incorrectly
> > set to 1, so it was not possible to disable this option.
> 
> Long ago, when this option was added, it was simply a flag with
> no option parsing, i.e. "-d rtinherit"
> 
> so I just want to double check ...
> 
> 1) was it intentional that this turned into a "=0/=1" type option,
>    i.e. an option which can be specified as disabled, essentially restating
>    the default?  Is it the intent that every flag option must now take a
>    value, and that it must take both "off" and "on" values?  Just checking
>    that I haven't lost the thread, here.
> 
> IOWS: we used to have only "-d rtinherit"  But I think now we accept
> -d rtinherit, -d rtinherit=0, and -d rtinherit=1.  Maybe it's water
> under the bridge, I don't see the use in adding value parsing to
> something that was just a simple flag before.  Can you enlighten
> me?

That's pretty much my original thinking in setting this option up
this way. i.e. it'a an option that can only be turned on as nothing
will turn it on automatically and so there is no reason to have a
mechanism to turn it off. Hence minval = maxval to give only a
single valid value for the option....

> 2) really, this and projinherit and, um, extszinherit should
>    probably all go away.  They were written for testing, nothing
>    tests them, and they aren't documented.  Any volunteers for
>    that?  It actually finds its way outside of pure mkfs code,
>    so it's a little tricky to completely eradicate it, but it
>    could be done in 2 steps I think.

Actually, I've been wanting them to be enabled and documented as
first class mkfs options, along with all the other inheritable inode
options, such as DAX. This is so mkfs can be told that a filesystem
will, say, always use DAX to access files with an extent size hint
sized to trigger the huge page fault paths as the default
behaviour for the filesystem and so it sets the appropriate
attributes on the root inode when it is created...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
