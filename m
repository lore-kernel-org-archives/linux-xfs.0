Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34876 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752185AbdIATck (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Sep 2017 15:32:40 -0400
Date: Fri, 1 Sep 2017 15:32:38 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/3] xfs: Add rtdefault mount option
Message-ID: <20170901193237.GF29225@bfoster.bfoster>
References: <25856B28-A65C-4C5B-890D-159F8822393D@fb.com>
 <20170901043151.GZ10621@dastard>
 <C6F6823D-65D7-4B73-9AC7-CBA4125F2429@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C6F6823D-65D7-4B73-9AC7-CBA4125F2429@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Wareing <rwareing@fb.com>
Cc: Dave Chinner <david@fromorbit.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Fri, Sep 01, 2017 at 06:39:09PM +0000, Richard Wareing wrote:
> Thanks for the quick feedback Dave!  My comments are in-line below.
> 
> 
> > On Aug 31, 2017, at 9:31 PM, Dave Chinner <david@fromorbit.com> wrote:
> > 
> > Hi Richard,
> > 
> > On Thu, Aug 31, 2017 at 06:00:21PM -0700, Richard Wareing wrote:
...
> >> add
> >> support for the more sophisticated AG based block allocator to RT
> >> (bitmapped version works well for us, but multi-threaded use-cases
> >> might not do as well).
> > 
> > That's a great big can of worms - not sure we want to open it. The
> > simplicity of the rt allocator is one of it's major benefits to
> > workloads that require deterministic allocation behaviour...
> 
> Agreed, I took a quick look at what it might take and came to a similar conclusion, but I can dream :).
> 

Just a side point based on the discussion so far... I kind of get the
impression that the primary reason for using realtime support here is
for the simple fact that it's a separate physical device. That provides
a basic mechanism to split files across fast and slow physical storage
based on some up-front heuristic. The fact that the realtime feature
uses a separate allocation algorithm is actually irrelevant (and
possibly a problem in the future).

Is that an accurate assessment? If so, it makes me wonder whether it's
worth thinking about if there are ways to get the same behavior using
traditional functionality. This ignores Dave's question about how much
of the performance actually comes from simply separating out the log,
but for example suppose we had a JBOD block device made up of a
combination of spinning and solid state disks via device-mapper with the
requirement that a boundary from fast -> slow and vice versa was always
at something like a 100GB alignment. Then if you formatted that device
with XFS using 100GB AGs (or whatever to make them line up), and could
somehow tag each AG as "fast" or "slow" based on the known underlying
device mapping, could you potentially get the same results by using the
same heuristics to direct files to particular sets of AGs rather than
between two physical devices? Obviously there are some differences like
metadata being spread across the fast/slow devices (though I think we
had such a thing as metadata only AGs), etc. I'm just handwaving here to
try and better understand the goal.

Brian

> > 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
