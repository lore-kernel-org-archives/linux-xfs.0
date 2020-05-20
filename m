Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44754C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 19:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AAB8207E8
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 19:49:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nInHpwQQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgETTtH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 15:49:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54670 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbgETTtH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 15:49:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KJRHP7096858;
        Wed, 20 May 2020 19:48:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=bjPVn0h7frpnDqzE61MHIOfWSfCqSRsm3/seHUUcdmw=;
 b=nInHpwQQVop4K3eFAzf7R/kwxwjONddL+TD3B3ciHb6XpLI0DHSnr6rzcH8ajZFxCvZu
 pKs0Um8SzxKMaFNdXMlZALThYJgEGTu8CLLCtAIX8H4Qty+VnA2+3qocFNyZ66E55aF7
 NbnwiCkOQalMLLa11KL9oaBfHWpgkg7PPilTqnz1DyeYjzV9FJ6i1iE65I5iVUrsVA9o
 xOepUyGksAqv9ci6sPCHC4uwnjSo57lrj4GXahPyLaKNkJXLxozxdrBtzrJK1W1Jnk4Q
 0SC12wMGHt7UhGayOamt0/wo+rlqS3sYrKlUGHXZ3HRL6XlZI5mYCdmIbKnFKwzqOBaI Zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3127krd4ge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 19:48:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KJmqkk167157;
        Wed, 20 May 2020 19:48:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 313gj444au-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 19:48:55 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04KJmsws024716;
        Wed, 20 May 2020 19:48:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 May 2020 12:48:54 -0700
Date:   Wed, 20 May 2020 12:48:53 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 3/3] xfs: measure all contiguous previous extents for
 prealloc size
Message-ID: <20200520194853.GZ17627@magnolia>
References: <158984934500.619853.3585969653869086436.stgit@magnolia>
 <158984936387.619853.12262802837092587871.stgit@magnolia>
 <20200519124827.GC23387@bfoster>
 <20200520132334.GA36554@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520132334.GA36554@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=1 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=1 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200155
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 20, 2020 at 09:23:34AM -0400, Brian Foster wrote:
> On Tue, May 19, 2020 at 08:48:27AM -0400, Brian Foster wrote:
> > On Mon, May 18, 2020 at 05:49:23PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > When we're estimating a new speculative preallocation length for an
> > > extending write, we should walk backwards through the extent list to
> > > determine the number of number of blocks that are physically and
> > > logically contiguous with the write offset, and use that as an input to
> > > the preallocation size computation.
> > > 
> > > This way, preallocation length is truly measured by the effectiveness of
> > > the allocator in giving us contiguous allocations without being
> > > influenced by the state of a given extent.  This fixes both the problem
> > > where ZERO_RANGE within an EOF can reduce preallocation, and prevents
> > > the unnecessary shrinkage of preallocation when delalloc extents are
> > > turned into unwritten extents.
> > > 
> > > This was found as a regression in xfs/014 after changing delalloc writes
> > > to create unwritten extents during writeback.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/xfs_iomap.c |   63 +++++++++++++++++++++++++++++++++++++++++++---------
> > >  1 file changed, 52 insertions(+), 11 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > > index ac970b13b1f8..2dffd56a433c 100644
> > > --- a/fs/xfs/xfs_iomap.c
> > > +++ b/fs/xfs/xfs_iomap.c
> ...
> > > @@ -413,15 +453,16 @@ xfs_iomap_prealloc_size(
> > >  	 * preallocation size.
> > >  	 *
> > >  	 * If the extent is a hole, then preallocation is essentially disabled.
> > > -	 * Otherwise we take the size of the preceding data extent as the basis
> > > -	 * for the preallocation size. If the size of the extent is greater than
> > > -	 * half the maximum extent length, then use the current offset as the
> > > -	 * basis. This ensures that for large files the preallocation size
> > > -	 * always extends to MAXEXTLEN rather than falling short due to things
> > > -	 * like stripe unit/width alignment of real extents.
> > > +	 * Otherwise we take the size of the contiguous preceding data extents
> > > +	 * as the basis for the preallocation size. If the size of the extent
> > 
> > I'd refer to it as the "size of the contiguous range" or some such since
> > we're now talking about aggregating many extents to form the prealloc
> > basis.
> > 
> > I am a little curious if there's any noticeable impact from having to
> > perform the worst case extent walk in this path. For example, suppose we
> > had a speculatively preallocated file where we started writing (i.e.
> > converting) every other unwritten block such that this path had to walk
> > an extent per block until hitting the 8g max (8g == 2097152 4k blocks).
> > I guess the hope is that either most of those blocks wouldn't have been
> > written back and converted by the time we'd trigger the next post-eof
> > prealloc or that it would just be a wash in the stream of staggered
> > writes falling into our max sized preallocations. Either way, I think
> > it's more important to maintain the existing heuristic so this seems
> > reasonable from that perspective.
> > 
> 
> I had a system spinning yesterday to create this worst case condition
> across a couple max sized extents. Testing out the preallocation path, I
> see a hit from ~5ms to ~35ms between the baseline variant and the
> updated calculation algorithm. Note that the baseline here is only doing
> a 16 block prealloc vs. 8gb with the fix, but regardless a 30ms
> difference for an 8gb allocation doesn't really seem noticeable enough
> to matter. IOW, I think we can disgregard this particular concern...

<nod> I'd figured that walking backwards through the incore extent tree
shouldn't be all that costly, particularly since it tends to result in
more aggressive speculative preallocation.

> > This scenario also makes me wonder if we should consider continuing to
> > do write time file size extension zeroing in certain cases vs. leaving
> > around unwritten extents. For example, the current post-eof prealloc
> > behavior is that writes that jump over current EOF will zero (via
> > buffered writes) any allocated blocks (delalloc or physical) between
> > current EOF and the start of the write.

Right...

> > That behavior doesn't change with delalloc -> unwritten if the
> > prealloc is still delalloc at the time of the extending write, but
> > we'd presumably skip those zeroing writes if the prealloc had been
> > converted to real+unwritten first.

...though I wonder how often we'll encounter the situation where we've
created a posteof preallocation, and we end up with written extents
beyond EOF, and then the next write jumps past EOF?

> > Hmm.. that does
> > seem a little random to me, particularly if somebody starts to see
> > unwritten extents sprinkled throughout a file that never explicitly saw
> > preallocation. Perhaps we should avoid converting post-eof blocks? OTOH,
> > unwritten probably makes sense for large jumps in EOF vs zeroing GBs of
> > blocks, so one could argue that we should convert such ranges (if still
> > delalloc) rather than zero them at all. Thoughts? We should probably
> > work this out one way or another before landing the delalloc ->
> > unwritten behavior..

/me wonders if that will be a problem in practice?  If writeback starts,
it'll (try to) convert the delalloc reservation into an unwritten extent
(even if the extent crosses EOF).  Writeback completion will convert the
written parts to regular extents, leaving the rest unwritten.

iomap_zero_range is a NOP on unwritten extents, so starting a new write
far beyond EOF will do very little work to make sure [oldsize, write
start] range is zero.

(Or am I misunderstanding this...?)

> Thinking about this one a little more.. it seems it's probably not worth
> conditionally changing post-eof conversion behavior. Since there are
> cases where we probably want post-eof prealloc to remain as unwritten if
> it's carried within i_size, that would either be extra code for post-eof
> blocks or would split up any kind of heuristic for manually zeroing such
> blocks. ISTM that the right approach might be to convert all delalloc ->

I might just leave it all unwritten and not try to be clever about
pre-zeroing when we extend EOF because that just adds more complexity.

> unwritten (as this series already does), then perhaps consider a write
> time heuristic that would perform manual zeroing of extents if certain
> conditions are met (e.g., for unwritten extents under a certain size).

ISTR that ext4 has some sort of heuristic to do that.  I'm not sure
which is better as writes get relatively more expensive, but so long as
the amount of zeroing is less than an erase block size it probably
doesn't matter...

> The remaining question to me is whether we should include something like
> that before changing delalloc behavior or consider it separately as an
> optimization...

Separately.  It's getting late in the cycle. ;)

> Brian
> 
> P.S., BTW I forgot to mention on my last pass of this series that it
> probably makes sense to reorder these behavioral fixup patches to
> precede the patch that actually changes delalloc to allocate unwritten
> extents.

Yeah, I'll do that.  I think I mostly like Christoph's rewrite of the
third patch of the series.

--D

> > Brian
> > 
> > > +	 * is greater than half the maximum extent length, then use the current
> > > +	 * offset as the basis. This ensures that for large files the
> > > +	 * preallocation size always extends to MAXEXTLEN rather than falling
> > > +	 * short due to things like stripe unit/width alignment of real
> > > +	 * extents.
> > >  	 */
> > > -	if (prev.br_blockcount <= (MAXEXTLEN >> 1))
> > > -		alloc_blocks = prev.br_blockcount << 1;
> > > +	if (plen <= (MAXEXTLEN >> 1))
> > > +		alloc_blocks = plen << 1;
> > >  	else
> > >  		alloc_blocks = XFS_B_TO_FSB(mp, offset);
> > >  	if (!alloc_blocks)
> > > 
> > 
> 
