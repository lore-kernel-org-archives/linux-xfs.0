Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60084 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751159AbdCOAOa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Mar 2017 20:14:30 -0400
Date: Wed, 15 Mar 2017 01:14:27 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v2] xfs: remove kmem_zalloc_greedy
Message-ID: <20170315001427.GI28800@wotan.suse.de>
References: <20170308003528.GK5280@birch.djwong.org>
 <20170314165745.GB28800@wotan.suse.de>
 <20170314180738.GV5280@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170314180738.GV5280@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Brian Foster <bfoster@redhat.com>, Michal Hocko <mhocko@kernel.org>, Christoph Hellwig <hch@lst.de>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Xiong Zhou <xzhou@redhat.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Dave Chinner <david@fromorbit.com>, sebastian.parschauer@suse.com, AlNovak@suse.com, jack@suse.cz, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Tue, Mar 14, 2017 at 11:07:38AM -0700, Darrick J. Wong wrote:
> On Tue, Mar 14, 2017 at 05:57:45PM +0100, Luis R. Rodriguez wrote:
> > On Tue, Mar 07, 2017 at 04:35:28PM -0800, Darrick J. Wong wrote:
> > > The sole remaining caller of kmem_zalloc_greedy is bulkstat, which uses
> > > it to grab 1-4 pages for staging of inobt records.  The infinite loop in
> > > the greedy allocation function is causing hangs[1] in generic/269, so
> > > just get rid of the greedy allocator in favor of kmem_zalloc_large.
> > > This makes bulkstat somewhat more likely to ENOMEM if there's really no
> > > pages to spare, but eliminates a source of hangs.
> > > 
> > > [1] http://lkml.kernel.org/r/20170301044634.rgidgdqqiiwsmfpj%40XZHOUW.usersys.redhat.com
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > > v2: remove single-page fallback
> > > ---
> > 
> > Since this fixes a hang how about *at the very least* a respective Fixes tag ?
> > This fixes an existing hang so what are the stable considerations here ? I
> > realize the answer is not easy but figured its worth asking.
> 
> I didn't think it was appropriate to "Fixes: 77e4635ae1917" since we're
> not fixing _greedy so much as we are killing it.  The patch fixes an
> infinite retry hang when bulkstat tries a memory allocation that cannot
> be satisfied; and having done that, realizes there are no remaining
> callers of _greedy and garbage collects it.  The code that was there
> before also seems capable of sleeping forever, I think.
> 
> So the minimally invasive fix is to apply the allocation conversion in
> bulkstat, and if there aren't any other callers of _greedy then you can
> get rid of it too.

For the stake of stable XFS users then why not do the less invasive change
first, Cc stable, and then move on to the less backward portable solution ?

  Luis
