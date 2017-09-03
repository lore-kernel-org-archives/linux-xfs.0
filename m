Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35852 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751224AbdICEBK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 3 Sep 2017 00:01:10 -0400
Date: Sun, 3 Sep 2017 12:01:07 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [BUG] sb_fdblocks counting error caused by too large indlen
 returned from xfs_bmap_worst_indlen()
Message-ID: <20170903040107.GU27835@eguan.usersys.redhat.com>
References: <20170707120040.GG29475@eguan.usersys.redhat.com>
 <20170708064937.GH4103@magnolia>
 <20170709140818.GI29475@eguan.usersys.redhat.com>
 <20170710161824.GI4103@magnolia>
 <20170902074945.GT27835@eguan.usersys.redhat.com>
 <20170902152059.GA4073@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170902152059.GA4073@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Sep 02, 2017 at 08:20:59AM -0700, Darrick J. Wong wrote:
> On Sat, Sep 02, 2017 at 03:49:45PM +0800, Eryu Guan wrote:
> > On Mon, Jul 10, 2017 at 09:18:24AM -0700, Darrick J. Wong wrote:
> > > On Sun, Jul 09, 2017 at 10:08:18PM +0800, Eryu Guan wrote:
> > > > On Fri, Jul 07, 2017 at 11:49:37PM -0700, Darrick J. Wong wrote:
> > > > > On Fri, Jul 07, 2017 at 08:01:43PM +0800, Eryu Guan wrote:
> > > > > > Hi all,
> > > > > > 
> > > > > > I recently hit a repeatable sb_fdblocks corruption as below:
> > > > > > 
> > > > > > Phase 1 - find and verify superblock...
> > > > > > Phase 2 - using internal log
> > > > > >         - zero log...
> > > > > >         - scan filesystem freespace and inode maps...
> > > > > > sb_fdblocks 14538692, counted 14669764
> > > > > >         - found root inode chunk
> > > > > > Phase 3 - for each AG...
> > > > > > ...
> > > > > > 
> > > > > > And the count diff is always 14669764 - 14538692 = 131072 (128k). The
> > > > > > XFS in question was formated with "-m rmapbt=1 -b 1k" option.
> > 
> > I hit this corruption again today in my fstests release testing, and it
> > reminded me this old thread :)
> > 
> > ...
> > 
> > > > > 
> > > > > So maybe the solution is to revert this patch and see if generic/224
> > > > > still blows up when suint/swidth are set?  I tried the steps given in
> > > > > your email from 18 Nov 2016 ("[BUG] dd doesn't return on ENOSPC and hang
> > > > > when fulfilling rmapbt XFS") with sunit=32,swidth=224 (numbers I
> > > > > entirely made up) and it ran just fine.  I then ran it with the
> > > > > reproducer steps you outlined above, and that ran just fine too.
> > > > > I did not run the rest of xfstests.
> > > > 
> > > > Reverting commit fd26a88093ba works for me, I can't reproduce the
> > > > sb_fdblocks accounting error nor the dd hang bug.
> > > 
> > > <nod> I'll consider posting a revert patch for the post -rc1 fixes.
> > > 
> > > But... merge window stuff comes first. :)
> > 
> > Is reverting commit fd26a88093ba still the plan? Maybe we can do it for
> > 4.14.
> 
> Sure.  Can you make the reproducer script an xfstest, please?

Sure, will work on that.

> 
> Will post revert patch for review soon.

Thanks!

Eryu

> 
> --D
> 
> > 
> > Thanks,
> > Eryu
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
