Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56438 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753132AbdKGU0h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2017 15:26:37 -0500
Date: Tue, 7 Nov 2017 21:26:48 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: WTF? Re: [PATCH] License cleanup: add SPDX GPL-2.0 license
 identifier to files with no license
Message-ID: <20171107202648.GB10679@kroah.com>
References: <20171107020607.GA26910@magnolia>
 <20171107072040.GB4586@infradead.org>
 <20171107073940.GB4654@kroah.com>
 <20171107172042.GB26910@magnolia>
 <20171107182903.GA4588@kroah.com>
 <20171107184658.56b87d41@alans-desktop>
 <20171107191526.x3rzfcnnlmaz264d@thunk.org>
 <20171107192846.GA24617@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171107192846.GA24617@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, linux-kernel@vger.kernel.org

On Tue, Nov 07, 2017 at 11:28:46AM -0800, Christoph Hellwig wrote:
> On Tue, Nov 07, 2017 at 02:15:26PM -0500, Theodore Ts'o wrote:
> > On Tue, Nov 07, 2017 at 06:46:58PM +0000, Alan Cox wrote:
> > > > Given that it had no license text on it at all, it "defaults" to GPLv2,
> > > > so the GPLv2 SPDX identifier was added to it.
> > > > 
> > > > No copyright was changed, nothing at all happened except we explicitly
> > > > list the license of the file, instead of it being "implicit" before.
> > > 
> > > Well if Christoph owns the copyright (if there is one) and he has stated
> > > he believes it is too trivial to copyright then it needs an SPDX tag that
> > > indicates the rightsholder has stated it's too trivial to copyright and
> > > (by estoppel) revoked any right they might have to pursue a claim.
> > 
> > If Cristoph has revoked any right to pursue a claim, then he's also
> > legally given up the right to complain if, say, Bradley Kuhn starting
> > distributing a version with a GPLv3 permission statement --- or if Greg
> > K-H adds a GPLv2 SPDX identifier.  :-)
> 
> 
> First Christoph really appreciateѕ spelling his name right.
> 
> Second Christoph really appreciates talking to him when trying to slap
> on licensing bits on his code.  I'm not evil, but I'd really like to
> understand what you are doing and why, and I might be fairly agreeable
> if that makes sense.

I already described it in the pull request, and in this patch itself,
and in this thread already, what is happening, why it was done, and how
it was done.  I don't know how everyone who was on the original email
thread got dropped and the xfs mailing list added, that's just odd...

> Doing batch annotations of code where you do not the know any of
> the history of is a receipt for a desaster if we want to use that
> information anywhere.

But we did research the history as well as we could when touching 11k
files at a single time.  It's been months of research and work, as
described in the patch.

If we got something wrong, very sorry, not a problem, please, let's put
the proper license on the file and all will be good.  What file are you
concerned about, and what license belongs on it?  This patch only
touched files without any license header, so again, by default that
implied it was GPLv2.  Again, no copyright was changed at all.

thanks,

greg k-h
