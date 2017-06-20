Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37829 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751036AbdFTQwH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Jun 2017 12:52:07 -0400
Date: Tue, 20 Jun 2017 18:52:04 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 2/2] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170620165204.GP21846@wotan.suse.de>
References: <20170616105445.3314-1-cmaiolino@redhat.com>
 <20170616105445.3314-3-cmaiolino@redhat.com>
 <20170616183510.GC21846@wotan.suse.de>
 <20170616192445.GG5421@birch.djwong.org>
 <20170616193755.GD21846@wotan.suse.de>
 <3ff0e0c8-ef9c-b7f8-d37e-ed02e5766c40@sandeen.net>
 <20170619105904.GA25255@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170619105904.GA25255@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Jun 19, 2017 at 06:59:05AM -0400, Brian Foster wrote:
> On Fri, Jun 16, 2017 at 02:45:13PM -0500, Eric Sandeen wrote:
> > On 6/16/17 2:37 PM, Luis R. Rodriguez wrote:
> > > On Fri, Jun 16, 2017 at 12:24:45PM -0700, Darrick J. Wong wrote:
> > >> On Fri, Jun 16, 2017 at 08:35:10PM +0200, Luis R. Rodriguez wrote:
> > > It seems like a rather large set of changes, if the issue was sevee I was hoping
> > > for a stable candidate fix first. If its not fixing a severe issue then sure.
> > 
> > Fixes go uptream first, then to stable kernels if appropriate, right?
> > 
> > But not every fix is a trivial one-liner.  I don't think there is any simpler
> > fix to be had, here.
> > 
> 
> Yeah, this is kind of intended to be the simplest fix available as far
> as I'm aware. TBH, I don't think the fix here is fundamentally that
> complex (define a state for already flushed/failed log items), but
> rather the code that needs to be modified to implement it has various
> states and corner cases to manage that make it tricky to get right.

OK this helps, thanks.

> If we truly needed a stable worthy fix in short order, that would
> probably be to revert ac8809f9a ("xfs: abort metadata writeback on
> permanent errors"), which caused this regression by making the AIL
> responsible for failed retries. 

Should the following tag be added then to this commit proposed by Carlos:

Fixes: ac8809f9a ("xfs: abort metadata writeback on permanent errors")

FWIW this was merged as of v3.13. Even though that seems to have taken the
failed buffer and kept it the commit log of that change seems to indicate we
already ran into similar situations before, after this commit we seem to just
retry IO once, but keep the buffer around on the AIL, to allow further
modifications of the buffer.


> A couple caveats I can think of with
> that are that 1.) this would likely short circuit the recently added
> error configuration api (which is kind of irrelevant if the underlying
> error management code doesn't work correctly, but suggests that should
> be reverted as well) and 2.) in doing so, this reverts back to the
> hardcoded infinite retry behavior in XFS. That means that transient
> errors may eventually recover, but the thinp enospc use case and whatnot
> are still going to hang on umount. 

Right, and also one of the gains of the patch seems to have been to allow
thinp devices to keep on chugging with modifications on the buffer, so that
would be lost as well. That seems to be like an optimization though so its
worth loosing IMHO if would have resolved the hang. Since that's not the case
though...

> It hasn't seemed necessary to me to take that approach given the lower
> prevalence of the issue 

Of this issue? I suppose its why I asked about examples of issues, I seem
to have found it likely much more possible out in the wild than expected.
It would seem folks might be working around it somehow.

> and the fact that a solution had been worked out
> for a while now. Though I suppose the longer we go without a fix in
> place, the stronger the argument for something like that becomes.

  Luis
