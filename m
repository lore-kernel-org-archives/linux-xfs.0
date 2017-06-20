Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49088 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750823AbdFTSiL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Jun 2017 14:38:11 -0400
Date: Tue, 20 Jun 2017 20:38:09 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 2/2] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170620183809.GV21846@wotan.suse.de>
References: <20170616105445.3314-1-cmaiolino@redhat.com>
 <20170616105445.3314-3-cmaiolino@redhat.com>
 <20170616183510.GC21846@wotan.suse.de>
 <20170616192445.GG5421@birch.djwong.org>
 <20170616193755.GD21846@wotan.suse.de>
 <3ff0e0c8-ef9c-b7f8-d37e-ed02e5766c40@sandeen.net>
 <20170619105904.GA25255@bfoster.bfoster>
 <20170620165204.GP21846@wotan.suse.de>
 <20170620172041.GD3348@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170620172041.GD3348@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Eric Sandeen <sandeen@sandeen.net>, "Darrick J. Wong" <darrick.wong@oracle.com>, Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Jun 20, 2017 at 01:20:41PM -0400, Brian Foster wrote:
> On Tue, Jun 20, 2017 at 06:52:04PM +0200, Luis R. Rodriguez wrote:
> > On Mon, Jun 19, 2017 at 06:59:05AM -0400, Brian Foster wrote:
> > > If we truly needed a stable worthy fix in short order, that would
> > > probably be to revert ac8809f9a ("xfs: abort metadata writeback on
> > > permanent errors"), which caused this regression by making the AIL
> > > responsible for failed retries. 
> > 
> > Should the following tag be added then to this commit proposed by Carlos:
> > 
> > Fixes: ac8809f9a ("xfs: abort metadata writeback on permanent errors")
> > 
> 
> That seems reasonable to me.

Then in this case I'd like the commit log to also explain *why* the described
fix did not work. It actually describes the issue as being considered, "thin
provisioned devices that have run out of backing space", and this recovering.
So did recovery never really work? Does recovery actually work for some cases
but not some? If so why not for some?

  Luis
