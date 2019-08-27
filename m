Return-Path: <SRS0=DGLX=WX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CD29C3A5A3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 16:08:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02147206BF
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 16:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbfH0QIi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 12:08:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53542 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725804AbfH0QIi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Aug 2019 12:08:38 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D882C18B3D83
        for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2019 16:08:37 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 95E6219D7A
        for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2019 16:08:37 +0000 (UTC)
Date:   Tue, 27 Aug 2019 12:08:35 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] generic 223: Ensure xfs allocator will honor
 alignment requirements
Message-ID: <20190827160835.GJ10636@bfoster>
References: <20190826144712.14614-1-cmaiolino@redhat.com>
 <20190827133816.GH10636@bfoster>
 <20190827153349.wgrskp6rdbjaznaa@pegasus.maiolino.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827153349.wgrskp6rdbjaznaa@pegasus.maiolino.io>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Tue, 27 Aug 2019 16:08:37 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 27, 2019 at 05:33:50PM +0200, Carlos Maiolino wrote:
> On Tue, Aug 27, 2019 at 09:38:16AM -0400, Brian Foster wrote:
> > On Mon, Aug 26, 2019 at 04:47:12PM +0200, Carlos Maiolino wrote:
> > > If the files being allocated during the test do not fit into a single
> > > Allocation Group, XFS allocator may disable alignment requirements
> > > causing the test to fail even though XFS was working as expected.
> > > 
> > > Fix this by fixing a min AG size, so all files created during the test
> > > will fit into a single AG not disabling XFS alignment requirements.
> > > 
> > > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > > ---
> > > 
> > > Hi,
> > > 
> > > I am tagging this patch as a RFC mostly to start a discussion here, regarding
> > > this issue found while running generic/223.
> > > 
> > > The generic/223 fails when running it with finobt disabled. Specifically, the
> > > last file being fallocated are unaligned.
> > > 
> > > When the finobt is enabled, the allocator does not try to squeeze partial file
> > > data into small available extents in AG 0, while it does when finobt is
> > > disabled.
> > > 
> > > Here are the bmap of the same file after generic/223 finishes with and without
> > > finobt:
> > > 
> > > finobt=0
> > > 
> > > /mnt/scratch/file-1073745920-falloc:
> > >  EXT: FILE-OFFSET         BLOCK-RANGE      AG AG-OFFSET           TOTAL FLAGS
> > >    0: [0..191]:           320..511          0 (320..511)            192 001011
> > >    1: [192..375]:         64..247           0 (64..247)             184 001111
> > >    2: [376..1287791]:     678400..1965815   0 (678400..1965815) 1287416 000111
> > >    3: [1287792..2097159]: 1966080..2775447  1 (256..809623)      809368 000101
> > > 
> > > 
> > > finobt=1
> > > 
> > > /mnt/scratch/file-1073745920-falloc:
> > >  EXT: FILE-OFFSET         BLOCK-RANGE      AG AG-OFFSET           TOTAL FLAGS
> > >    0: [0..1285831]:       678400..1964231   0 (678400..1964231) 1285832 000111
> > >    1: [1285832..2097159]: 1966080..2777407  1 (256..811583)      811328 000101
> > > 
> > > 
> > > I still don't know the details about why the allocator takes different decisions
> > > depending on finobt being used or not, although I believe it's because the extra
> > > space being used in each AG, and the default AG size when running the test, but
> > > I'm still reading the code to try to understand this difference.
> > > 
> > 
> > For reference, I think this behavior is related to a couple patches I
> > posted a few months ago[1]. I reproduced similar behavior after some of
> > extent allocation rework changes and ultimately determined that the
> > changes I had at the time weren't really the root cause. The commit log
> > for patch 1 in that series shows a straightforward example that IIRC
> > doesn't have anything to do with finobt either.
> > 
> > > Even though I think there might be room for improvement in the XFS allocator
> > > code to avoid this bypass of alignment requirements here, I still think the test
> > > should be fixed to avoid forcing the filesystem to drop alignment constraints
> > > during file allocation which basically invalidate the test, and that's why I
> > > decided to start the discussion with a RFC patch for the test, but sending it to
> > > xfs list instead of fstests.
> > > 
> > 
> > The question I have is is this test doing anything a user wouldn't
> > expect to honor alignment? I understand that alignment is not
> > guaranteed, but I wouldn't expect to play that card unless the
> > filesystem is low on free space or aligned space in general (IIRC that's
> > something we check by adding the worst case alignment to the size of the
> > allocation request).
> 
> Yeah, that's my question too. I don't know :P that's why I decide to start the
> thread with a patch. I also wouldn't expect the alignment requirement to be
> bypassed unless we are low in space, but I am not sure if that's correct or not.
> > 
> > The example I had was a 1GB fallocate on an empty ~15GB/16AG fs (i.e.
> > allocation larger than a single AG). That is a corner case, but one I'd
> > expect to work.
> 
> Hmm, is this the same case we spoke about?
> 

I think so.

> > With regard to generic/223, what is it doing in this
> > case to "force the filesystem to drop alignment?" I think you could make
> > the argument that the test needs fixing if it's doing something that
> > legitimately risks the ability to align allocations, but I also think
> > you could argue that the test has done its job by finding this problem.
> > :)
> 
> Yeah, I am a bit confused about it. I need to understand the alloc algorithm to
> get a better idea on what's going on. I honestly don't know if the test did its
> job or if we should really expect misaligned files if the allocation request
> spans more than 1 AG, I should have started the thread with this question :P
> 

If the allocation size spans multiple AGs, we know that we'll need
multiple extents by definition. Given that, I'd argue that if free space
were in a state where we could easily align the same file allocation if
it were broken into multiple smaller (sub-AG sized) requests by
userspace, then we should probably be able to align the larger
allocation when the kernel is the one that actually breaks it up. That's
just my .02 though, there's always tradeoffs. :)

Brian

> 
> > 
> > Brian
> > 
> > [1] https://marc.info/?l=linux-xfs&m=155671950608062&w=2
> > 
> > > Comments?
> > > 
> > > Cheers
> > > 
> > > 
> > >  tests/generic/223 | 9 ++++++++-
> > >  1 file changed, 8 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/tests/generic/223 b/tests/generic/223
> > > index dfd8c41b..782651e2 100755
> > > --- a/tests/generic/223
> > > +++ b/tests/generic/223
> > > @@ -34,6 +34,13 @@ _require_xfs_io_command "falloc"
> > >  
> > >  rm -f $seqres.full
> > >  
> > > +# Ensure we won't trick xfs allocator to disable alignment requirements
> > > +if [ "$FSTYP" == "xfs" ]; then
> > > +	mkfs_opts="-d agsize=2g"
> > > +else
> > > +	mkfs_opts=""
> > > +fi
> > > +
> > >  BLOCKSIZE=4096
> > >  
> > >  for SUNIT_K in 8 16 32 64 128; do
> > > @@ -41,7 +48,7 @@ for SUNIT_K in 8 16 32 64 128; do
> > >  	let SUNIT_BLOCKS=$SUNIT_BYTES/$BLOCKSIZE
> > >  
> > >  	echo "=== mkfs with su $SUNIT_BLOCKS blocks x 4 ==="
> > > -	export MKFS_OPTIONS=""
> > > +	export MKFS_OPTIONS=$mkfs_opts
> > >  	_scratch_mkfs_geom $SUNIT_BYTES 4 $BLOCKSIZE >> $seqres.full 2>&1
> > >  	_scratch_mount
> > >  
> > > -- 
> > > 2.20.1
> > > 
> 
> -- 
> Carlos
