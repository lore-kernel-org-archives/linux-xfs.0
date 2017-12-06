Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:33854 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752768AbdLFWrJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Dec 2017 17:47:09 -0500
Date: Wed, 6 Dec 2017 14:46:27 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v7] generic: initial fiemap range query test
Message-ID: <20171206224627.GO19219@magnolia>
References: <1512057927-15022-1-git-send-email-nborisov@suse.com>
 <20171206174506.GI19219@magnolia>
 <0d1b5c25-9187-1405-17a2-1e44b65c53a8@suse.com>
 <20171206210659.GE6896@magnolia>
 <20171206215711.GG5858@dastard>
 <61675ab2-0943-e5d7-8c94-247d3ef68a05@sandeen.net>
 <20171206221603.GH5858@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171206221603.GH5858@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Nikolay Borisov <nborisov@suse.com>, eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Dec 07, 2017 at 09:16:03AM +1100, Dave Chinner wrote:
> On Wed, Dec 06, 2017 at 04:01:58PM -0600, Eric Sandeen wrote:
> > On 12/6/17 3:57 PM, Dave Chinner wrote:
> > 
> > > There's a *simple answer* to this problem: fix the new command's
> > > output.
> > > 
> > > That is: the user asked for a specific range, so the command itself
> > > should trim the map returned by the kernel to only display the exact
> > > range the user asked for.  Then it doesn't matter if the underlying
> > > filesystem trims the extents or not, because the we're going to do
> > > that anyway in userspace.
> > 
> > I have a different opinion:
> > 
> > xfs_io is a debugging tool; the fiemap command sends an ioctl to the kernel.
> > 
> > Ranged fiemap queries are a real thing; you put numbers into the kernel,
> > and you get numbers out of the kernel.
> > 
> > IMNSO, xfs_io should present to the user /what the kernel returned/,
> > and not re-interpret it to fit some other notion of correctness if we
> > don't like what the kernel told us.
> 
> I hardly think "trimming to the range the user asked for" is
> "re-interpreting what the kernel told us". It's limiting output
> range to exactly what the user asked for - the output is still
> correct regardless of how it's filtered to match what the user asked
> for....

...except that xfs_io is a tool we use to debug the garbage that FIEMAP
sprays back at userspace, so it absolutely should not be hiding things
like this from the test suite:

$ xfs_io -c "fiemap -va 0k 65k" moofile
moo:
 EXT: FILE-OFFSET               BLOCK-RANGE            TOTAL FLAGS
   0: [0..18446744073709551615]: 1585456720..1585456719     0 0x301
   1: [0..129]:                 hole                     130

(Yay ext4.  WTF does the extent have length 0?)

So.... historically XFS trimmed the FIEMAP results.  Fix the test to
reflect the XFS behavior, get ext4 (and btrfs) to fix their weird
implementations, and leave xfs_io alone.

(Don't mind me shifting positions. :P)

--D

> > If you want to have some user-friendlier behavior where xfs_io layers
> > behaviors on top of what the kernel provides, then add a "-t" argument for trim,
> > but hiding ioctl inconsistencies by filtering them through xfs_io sounds
> > like the wrong approach to me.
> 
> Just filter the last output in the test, then, so it looks like
> 
> 2: [128..XXX] data
> 
> There is absolutely no excuse for creating multiple tests to support
> a small difference in trailing extent range output from different
> filesystem.
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
