Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58186 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754017AbdKHGhW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2017 01:37:22 -0500
Date: Wed, 8 Nov 2017 07:37:33 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: WTF? Re: [PATCH] License cleanup: add SPDX GPL-2.0 license
 identifier to files with no license
Message-ID: <20171108063733.GA3098@kroah.com>
References: <20171107020607.GA26910@magnolia>
 <20171107072040.GB4586@infradead.org>
 <20171107073940.GB4654@kroah.com>
 <20171107172042.GB26910@magnolia>
 <20171107182903.GA4588@kroah.com>
 <20171107184658.56b87d41@alans-desktop>
 <20171107191526.x3rzfcnnlmaz264d@thunk.org>
 <20171107192846.GA24617@infradead.org>
 <20171107202648.GB10679@kroah.com>
 <20171107214259.GC16026@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171107214259.GC16026@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, Richard Fontana <fontana@sharpeleven.org>, linux-kernel@vger.kernel.org

On Tue, Nov 07, 2017 at 10:42:59PM +0100, Luis R. Rodriguez wrote:
> On Tue, Nov 07, 2017 at 09:26:48PM +0100, Greg Kroah-Hartman wrote:
> > On Tue, Nov 07, 2017 at 11:28:46AM -0800, Christoph Hellwig wrote:
> > > On Tue, Nov 07, 2017 at 02:15:26PM -0500, Theodore Ts'o wrote:
> > > > On Tue, Nov 07, 2017 at 06:46:58PM +0000, Alan Cox wrote:
> > > > > > Given that it had no license text on it at all, it "defaults" to GPLv2,
> > > > > > so the GPLv2 SPDX identifier was added to it.
> > > > > > 
> > > > > > No copyright was changed, nothing at all happened except we explicitly
> > > > > > list the license of the file, instead of it being "implicit" before.
> > > > > 
> > > > > Well if Christoph owns the copyright (if there is one) and he has stated
> > > > > he believes it is too trivial to copyright then it needs an SPDX tag that
> > > > > indicates the rightsholder has stated it's too trivial to copyright and
> > > > > (by estoppel) revoked any right they might have to pursue a claim.
> > > > 
> > > > If Cristoph has revoked any right to pursue a claim, then he's also
> > > > legally given up the right to complain if, say, Bradley Kuhn starting
> > > > distributing a version with a GPLv3 permission statement --- or if Greg
> > > > K-H adds a GPLv2 SPDX identifier.  :-)
> > > 
> > > 
> > > First Christoph really appreciateѕ spelling his name right.
> > > 
> > > Second Christoph really appreciates talking to him when trying to slap
> > > on licensing bits on his code.  I'm not evil, but I'd really like to
> > > understand what you are doing and why, and I might be fairly agreeable
> > > if that makes sense.
> > 
> > I already described it in the pull request, and in this patch itself,
> 
> The upstream commit b24413180f5600 ("License cleanup: add SPDX GPL-2.0 license
> identifier to files with no license") mentions:
> 
>     Many source files in the tree are missing licensing information, which
>     makes it harder for compliance tools to determine the correct license.
> 
> We typically have not cared bout this, what has changed for us to want
> to actually go ahead and do all this work?

Many of us have cared about it for years, and nothing "changed" except
the fact that Kate and Thomas and Philippe spent about 10 months doing
the real work.  This patch was the result of that work.

> It further states:
> 
>     By default all files without license information are under the default
>     license of the kernel, which is GPL version 2.
>     
>     Update the files which contain no license information with the 'GPL-2.0'
>     SPDX license identifier.  The SPDX identifier is a legally binding
>     shorthand, which can be used instead of the full boiler plate text.
> 
> It says a bit about legally binding stuff, that's strong language, however its
> unclear to me about what it could mean for dual licensed stuff where the goal
> is for the GPL to apply say on Linux but another license outside of Linux.

That is not the case with these files, so I don't understand your issue.

> So what type of legally binding definition was being concocted here, how did such
> consensus get reached and why did we turn around and decide to embrace it all
> of a sudden whereas we had not done so before?

The implicit license of files in the kernel that did not have an
explicit license in them is GPLv2, all this patch does is explicitly
mark them with that license.  It has nothing to do with dual licenses at
all.

However, follow on patches for some subsystems are adding the correct
dual license SPDX identifiers for files that are dual licensed.  See the
patches in the USB git tree for examples of that in places, if you are
curious about how that works with SPDX.

thanks,

greg k-h
