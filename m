Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45306 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750990AbdFSRmJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Jun 2017 13:42:09 -0400
Date: Mon, 19 Jun 2017 10:42:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/2 V4] Resubmit items failed during writeback
Message-ID: <20170619174203.GA4733@birch.djwong.org>
References: <20170616105445.3314-1-cmaiolino@redhat.com>
 <20170619135120.GD25516@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170619135120.GD25516@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Jun 19, 2017 at 09:51:22AM -0400, Brian Foster wrote:
> On Fri, Jun 16, 2017 at 12:54:43PM +0200, Carlos Maiolino wrote:
> > Hi,
> > 
> > there goes a new version of this patchset based on previous reviews on V3.
> > 
> > Changelogs added separated to each patch.
> > 
> 
> Hi Carlos,
> 
> I pointed out the last things that I'm aware of that I think need to be
> fixed in this series (along with a few nits here and there). That said,
> it's already been pointed out that we probably want an xfstests test
> case to go along with this before it would be merged. Is that something
> you are still planning on?
> 
> I'd actually like to take this a bit farther than a regression test and
> see if we can improve our ability to test the error handling code in
> general. What do you (or anybody else..) think about including a patch
> in this series that introduces the ability to inject metadata writeback
> errors on DEBUG kernels? For example, consider something that just sets
> b_error at the top of xfs_buf_iodone_callbacks() based on a random value
> and configurable error frequency. This could use XFS_TEST_ERROR() or
> something like a new DEBUG sysfs attribute in the error configuration
> (see log_badcrc_factor for a similar example).

Sounds reasonable.

I wonder if it would be more useful to have individual knobs for each
metadata object type so that you could have multiple xfstests, each of
which runs the same software scenario but with different failures
configured?  Then we could test what happens when, say, only inode
writes fail, or bmbt writes fail, etc. rather than one big hammer that's
harder to control?

For a moment I also wondered why not use the error injection mechanism
that we already have, rather than inventing more sysfs knobs?  But we
have limited space in xfs_error_injection (29/32 bits used) so we
probably should just switch everything to sysfs knobs.

--D

> This would facilitate longer running tests where iodone callback errors
> occur randomly and transiently and we can thus actually exercise the
> error handling and recovery code. I'd love to run some fsstress testing,
> for example, as I'm hoping that would help wring out any further issues
> that could be lurking (particularly with the tricky xfs_iflush_done()
> logic and whatnot). If implemented generally enough, that could also be
> reused for a more simple xfstests regression test for the original
> problem (e.g., mount fs, set error frequency = 100%, modify an inode,
> set error frequency = 0, umount), albeit it would require debug mode.
> Thoughts?
> 
> Brian
> 
> > 
> > -- 
> > 2.9.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
