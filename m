Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26187 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751470AbdKHSqz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2017 13:46:55 -0500
Date: Wed, 8 Nov 2017 10:46:15 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: WTF? Re: [PATCH] License cleanup: add SPDX GPL-2.0 license
 identifier to files with no license
Message-ID: <20171108184615.GE26910@magnolia>
References: <20171107020607.GA26910@magnolia>
 <20171107072040.GB4586@infradead.org>
 <20171107073940.GB4654@kroah.com>
 <20171107172042.GB26910@magnolia>
 <20171107182903.GA4588@kroah.com>
 <20171107184658.56b87d41@alans-desktop>
 <20171107191526.x3rzfcnnlmaz264d@thunk.org>
 <20171107192846.GA24617@infradead.org>
 <20171107202648.GB10679@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171107202648.GB10679@kroah.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, linux-kernel@vger.kernel.org

On Tue, Nov 07, 2017 at 09:26:48PM +0100, Greg Kroah-Hartman wrote:
> On Tue, Nov 07, 2017 at 11:28:46AM -0800, Christoph Hellwig wrote:
> > On Tue, Nov 07, 2017 at 02:15:26PM -0500, Theodore Ts'o wrote:
> > > On Tue, Nov 07, 2017 at 06:46:58PM +0000, Alan Cox wrote:
> > > > > Given that it had no license text on it at all, it "defaults" to GPLv2,
> > > > > so the GPLv2 SPDX identifier was added to it.
> > > > > 
> > > > > No copyright was changed, nothing at all happened except we explicitly
> > > > > list the license of the file, instead of it being "implicit" before.
> > > > 
> > > > Well if Christoph owns the copyright (if there is one) and he has stated
> > > > he believes it is too trivial to copyright then it needs an SPDX tag that
> > > > indicates the rightsholder has stated it's too trivial to copyright and
> > > > (by estoppel) revoked any right they might have to pursue a claim.
> > > 
> > > If Cristoph has revoked any right to pursue a claim, then he's also
> > > legally given up the right to complain if, say, Bradley Kuhn starting
> > > distributing a version with a GPLv3 permission statement --- or if Greg
> > > K-H adds a GPLv2 SPDX identifier.  :-)
> > 
> > 
> > First Christoph really appreciateѕ spelling his name right.
> > 
> > Second Christoph really appreciates talking to him when trying to slap
> > on licensing bits on his code.  I'm not evil, but I'd really like to
> > understand what you are doing and why, and I might be fairly agreeable
> > if that makes sense.
> 
> I already described it in the pull request, and in this patch itself,
> and in this thread already, what is happening, why it was done, and how
> it was done.  I don't know how everyone who was on the original email
> thread got dropped and the xfs mailing list added, that's just odd...

This thread is a result of regular efforts to keep the xfsprogs libxfs
code roughly in-sync with the kernel libxfs code.  That's how the xfs
mailing is on cc on this thread.

That said, it's pretty obvious from Christoph's reaction that nobody
emailed Christoph (the original author of xfs_cksum.h) about the
original change to the kernel source.  Nobody emailed the XFS
maintainers for an ack to the kernel change, and nobody cc'd the
linux-xfs mailing list as a heads-up.  Neither XFS maintainer were
invited to the summit where this change was discussed.

I always thought the rules in SubmittingPatches[1] existed to facilitate
cooperation with Linux subprojects and I strongly protest your decision
to ignore us.

Had anyone involved us, I would have suggested fixing the whole XFS tree
to use the shortened tag instead of each file containing its own
mutations of the GPL, and our broader XFS community could have worked
with you on this.

--D

[1] submitting-patches.rst, section 5:

5) Select the recipients for your patch
---------------------------------------

You should always copy the appropriate subsystem maintainer(s) on any
patch to code that they maintain; look through the MAINTAINERS file and
the source code revision history to see who those maintainers are.  The
script scripts/get_maintainer.pl can be very useful at this step.  If
you cannot find a maintainer for the subsystem you are working on,
Andrew Morton (akpm@linux-foundation.org) serves as a maintainer of last
resort.


> > Doing batch annotations of code where you do not the know any of
> > the history of is a receipt for a desaster if we want to use that
> > information anywhere.
> 
> But we did research the history as well as we could when touching 11k
> files at a single time.  It's been months of research and work, as
> described in the patch.
> 
> If we got something wrong, very sorry, not a problem, please, let's put
> the proper license on the file and all will be good.  What file are you
> concerned about, and what license belongs on it?  This patch only
> touched files without any license header, so again, by default that
> implied it was GPLv2.  Again, no copyright was changed at all.
> 
> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
