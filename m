Return-Path: <SRS0=Z/aa=WP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F91FC3A5A0
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 18:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 706D222CEC
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 18:19:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbfHSSTZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Aug 2019 14:19:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35826 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727769AbfHSSTY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Aug 2019 14:19:24 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A2B6B19AED9A;
        Mon, 19 Aug 2019 18:19:24 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C56010016EA;
        Mon, 19 Aug 2019 18:19:24 +0000 (UTC)
Date:   Mon, 19 Aug 2019 14:19:22 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 3/4] xfs: randomly fall back to near mode lookup
 algorithm in debug mode
Message-ID: <20190819181922.GE2875@bfoster>
References: <20190815125538.49570-1-bfoster@redhat.com>
 <20190815125538.49570-4-bfoster@redhat.com>
 <20190817013703.GB752159@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190817013703.GB752159@magnolia>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Mon, 19 Aug 2019 18:19:24 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 16, 2019 at 06:37:03PM -0700, Darrick J. Wong wrote:
> On Thu, Aug 15, 2019 at 08:55:37AM -0400, Brian Foster wrote:
> > The last block scan is the dominant near mode allocation algorithm
> > for a newer filesystem with fewer, large free extents. Add debug
> > mode logic to randomly fall back to lookup mode to improve
> > regression test coverage.
> 
> How about just using an errortag since the new sysfs interface lets
> testcases / admins control the frequency?
> 

We could do that, but my understanding of the equivalent logic in the
current algorithm is that we want broad coverage of both near mode
sub-algorithms across the entire suite of tests. Hence we randomly drop
allocations into either algorithm when DEBUG mode is enabled. IIRC, we
do something similar with sparse inodes (i.e., randomly allocate sparse
inode chunks even when unnecessary) so the functionality isn't only
covered by targeted tests.

Do we have the ability to have always on error tags as such? I thought
we had default frequency values for each tag, but I thought they still
had to be explicitly enabled. If that's the case, I'm sure we could come
up with such an on-by-default mechanism and perhaps switch over these
remaining DEBUG mode hacks, but that's a follow up thing IMO..

Brian

> --D
> 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 7753b61ba532..d550aa5597bf 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -1266,6 +1266,7 @@ xfs_alloc_ag_vextent_near(
> >  	int			i;
> >  	xfs_agblock_t		bno;
> >  	xfs_extlen_t		len;
> > +	bool			lastblock;
> >  
> >  	/* handle unitialized agbno range so caller doesn't have to */
> >  	if (!args->min_agbno && !args->max_agbno)
> > @@ -1291,7 +1292,12 @@ xfs_alloc_ag_vextent_near(
> >  	 * Otherwise run the optimized lookup search algorithm from the current
> >  	 * location to the end of the tree.
> >  	 */
> > -	if (xfs_btree_islastblock(acur.cnt, 0)) {
> > +	lastblock = xfs_btree_islastblock(acur.cnt, 0);
> > +#ifdef DEBUG
> > +	if (lastblock)
> > +		lastblock = prandom_u32() & 1;
> > +#endif
> > +	if (lastblock) {
> >  		int	j;
> >  
> >  		trace_xfs_alloc_cur_lastblock(args);
> > -- 
> > 2.20.1
> > 
