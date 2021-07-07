Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90E56C07E96
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 01:36:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78BA561CB3
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 01:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhGGBjV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jul 2021 21:39:21 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:39403 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229949AbhGGBjU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jul 2021 21:39:20 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UezCbn7_1625621798;
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0UezCbn7_1625621798)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 07 Jul 2021 09:36:40 +0800
Date:   Wed, 7 Jul 2021 09:36:38 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: reset child dir '..' entry when unlinking child
Message-ID: <YOUFJntAorMO8SBL@B-P7TQMD6M-0146.local>
Mail-Followup-To: Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>
References: <20210703030233.GD24788@locust>
 <20210705220925.GN664593@dread.disaster.area>
 <YOOTtQoRfAay1Hhs@B-P7TQMD6M-0146.local>
 <20210706214929.GF11588@locust>
 <20210706230736.GP664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210706230736.GP664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 07, 2021 at 09:07:36AM +1000, Dave Chinner wrote:
> On Tue, Jul 06, 2021 at 02:49:29PM -0700, Darrick J. Wong wrote:
> > On Tue, Jul 06, 2021 at 07:20:21AM +0800, Gao Xiang wrote:
> > > Hi Dave and Christoph,
> > > 
> > > On Tue, Jul 06, 2021 at 08:09:25AM +1000, Dave Chinner wrote:
> > > > On Fri, Jul 02, 2021 at 08:02:33PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > While running xfs/168, I noticed a second source of post-shrink
> > > > > corruption errors causing shutdowns.
> > > > > 
> > > > > Let's say that directory B has a low inode number and is a child of
> > > > > directory A, which has a high number.  If B is empty but open, and
> > > > > unlinked from A, B's dotdot link continues to point to A.  If A is then
> > > > > unlinked and the filesystem shrunk so that A is no longer a valid inode,
> > > > > a subsequent AIL push of B will trip the inode verifiers because the
> > > > > dotdot entry points outside of the filesystem.
> > > > 
> > > > So we have a directory inode that is empty and unlinked but held
> > > > open, with a back pointer to an invalid inode number? Which can
> > > > never be followed, because the directory has been unlinked.
> > > > 
> > > > Can't this be handled in the inode verifier? This seems to me to
> > > > be a pretty clear cut case where the ".." back pointer should
> > > > always be considered invalid (because the parent dir has no
> > > > existence guarantee once the child has been removed from it), not
> > > > just in the situation where the filesystem has been shrunk...
> > > 
> > > Yes, I agree all of this, this field can be handled by the inode
> > > verifier. The only concern I can think out might be fs freeze
> > > with a directory inode that is empty and unlinked but held open,
> > > and then recovery on a unpatched old kernels, not sure if such
> > > case can be handled properly by old kernel verifier.
> > 
> > I decided against changing the shortform directory verifier to ignore
> > the dotdot pointer on nlink==0 directories because older kernels will
> > still have the current behavior and that will cause recovery failure for
> > the following sequence:
> > 
> > 1. create A and B and delete A as per above, leave B open
> > 2. shrink fs so that A is no longer a valid inode number
> > 3. flush the shrink transaction to disk
> > 4. futimens(B) (or anything to dirty the inode)
> > 5. crash
> > 6. boot old kernel
> > 7. try to recover fs with old kernel, which will crash since B hadn't
> >    been inactivated
> 
> Yup, I can see how that would happen, but patching the directory
> code still smells like band-aid to me on multiple levels.
> 
> At first glance, this seems like the first step in a on-going game
> of whack-a-mole. If shrink is changing how the on disk format needs
> to be evaluated in ways that older kernels can't safely deal with,
> then shrink needs to be setting an incompat feature bit to prevent
> older kernels from crashing trying to parse the on-disk format.

Not a quite excuse for myself, but it's not easy for me to realize
there could be some problem with the outdated dotdot pointer pointing
to already free blocks in advance since that's too detail without
looking through the specific code considering my XFS knowledge, so
I was always expecting for more reviews, and that's why this was
marked as an experimental risky feature.

> 
> On deeper consideration after looking at the code, why is it even
> considered safe to be recovering pre- and post- shrink operations in
> a single log recovery operation? i.e. I see nothing in the shrink
> code that quiesces the log and flushes all the dirty metadata to
> stable storage prior to logging the superblock geometry changes and
> returning to userspace.
> 
> I can think of another situation where this might be problematic -
> recovering buffers containing unlinked inode lists updates. If the
> inode cluster buffers we recover from transactions before the shrink
> point to inodes that are beyond EOFS after the shrink, we recover
> them and write them to disk, only for them to be read again and
> written to disk when recovering subsequent transactions prior
> to shrink.
> 
> IOWs, we can have transient on-disk state during log recovery where
> stuff before the shrink transaction points to objects beyond the
> EOFS after the shrink, but are still considered to be valid by log
> recovery. If the device has already been shrunk, then log recovery
> has just created a transient corrupt on-disk state, so if log
> recovery fails at this point (for whatever reason), we've got a mess
> on our hands.

Yes, for such cases AIL needs to be pushed out before returning to the
userspace to avoid device shrinking. Since before shrinking transaction
the tail space was considered as valid. The shrinking transaction is
already a sync transaction so it will trigger log force, and it needs
a AIL push all as well before returning to the user space.

> 
> I suspect that this means we could also have problems in the AIL,
> too, but I haven't thought that far through this right now. The
> transient corrupt log recovery state can be fixed by forcing the AIL
> to be written back before we execute the shrink transaction so the
> shrink transaction ends up being written to the tail of the log.
> Doing this would also fix any sort of transient AIL ordering issue
> that might exist around a shrink operation....
> 
> So, yeah, I think this problem hints at bigger issues with shrink,
> on disk format interpretation and transient log recovery states. I
> think we need to finish off all the infrastructure shrink needs
> before we go any further with it....

Hmm.. That will avoid this indeed if more on-disk fields point to
free blocks like this, honestly I didn't realize outdated dotdot
pointer could point to already free blocks then a validator checks
this in the beginning.

Thanks,
Gao Xiang

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
