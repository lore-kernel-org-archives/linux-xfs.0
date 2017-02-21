Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41153 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751361AbdBUIOJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Feb 2017 03:14:09 -0500
Date: Tue, 21 Feb 2017 09:13:46 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [BUG 4.10-rc7] sb_fdblocks inconsistency in xfs/297 test
Message-ID: <20170221081345.GA15595@dhcp22.suse.cz>
References: <20170210035348.GA7075@eguan.usersys.redhat.com>
 <20170210071418.GC9346@dhcp22.suse.cz>
 <20170210080210.GC10893@dhcp22.suse.cz>
 <20170210093131.GH10893@dhcp22.suse.cz>
 <20170220142521.GJ2431@dhcp22.suse.cz>
 <20170220145819.GC32455@bfoster.bfoster>
 <20170221041430.GN24562@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170221041430.GN24562@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Tue 21-02-17 12:14:30, Eryu Guan wrote:
> On Mon, Feb 20, 2017 at 09:58:19AM -0500, Brian Foster wrote:
> > On Mon, Feb 20, 2017 at 03:25:21PM +0100, Michal Hocko wrote:
> > > I have discussed that shortly with Jack and he suspects that xfs
> > > specific part of the iomap callbacks doesn't cancel reservations.
> > > Let's CC more xfs people. The thread starts
> > > http://lkml.kernel.org/r/20170210035348.GA7075@eguan.usersys.redhat.com
> > > 
> > 
> > Have you tried commit fa7f138 ("xfs: clear delalloc and cache on buffered
> > write failure"), currently in for-next?
> 
> I cherry-picked this commit to 4.10-rc8 tree and xfs/297 xfs/305 all
> passed for me without fs corruption. They used to fail for me reliably
> with stock 4.10-rc8 kernel. Thanks all for looking at this!

Brian, could you make sure that your commit gets to stable (at least) 4.8+
because that is where d1908f52557b ("fs: break out of
iomap_file_buffered_write on fatal signals") will be backported to.

-- 
Michal Hocko
SUSE Labs
