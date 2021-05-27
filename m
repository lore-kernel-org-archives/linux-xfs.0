Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61D50C47089
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 08:52:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 375746135F
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 08:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235427AbhE0Ixv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 04:53:51 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:48922 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235324AbhE0Ixu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 May 2021 04:53:50 -0400
Received: from dread.disaster.area (pa49-180-230-185.pa.nsw.optusnet.com.au [49.180.230.185])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id B12AB103A52;
        Thu, 27 May 2021 18:52:16 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lmBkV-005kxd-IE; Thu, 27 May 2021 18:52:15 +1000
Date:   Thu, 27 May 2021 18:52:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: reduce transaction reservation for freeing
 extents
Message-ID: <20210527085215.GP664593@dread.disaster.area>
References: <20210527045202.1155628-1-david@fromorbit.com>
 <20210527045202.1155628-7-david@fromorbit.com>
 <20210527061947.GE202121@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527061947.GE202121@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=dUIOjvib2kB+GiIc1vUx8g==:117 a=dUIOjvib2kB+GiIc1vUx8g==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=GHgr-8bCedm7FY1kGK4A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 26, 2021 at 11:19:47PM -0700, Darrick J. Wong wrote:
> On Thu, May 27, 2021 at 02:52:02PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Ever since we moved to deferred freeing of extents, we only every
> > free one extent per transaction. We separated the bulk unmapping of
> > extents from the submission of EFI/free/EFD transactions, and hence
> > while we unmap extents in bulk, we only every free one per
> > transaction.
> > 
> > Our transaction reservations still live in the era from before
> > deferred freeing of extents, so still refer to "xfs_bmap_finish"
> > and it needing to free multiple extents per transaction. These
> > freeing reservations can now all be reduced to a single extent to
> > reflect how we currently free extents.
> > 
> > This significantly reduces the reservation sizes for operations like
> > truncate and directory operations where they currently reserve space
> > for freeing up to 4 extents per transaction.
> > 
> > For a 4kB block size filesytsem with reflink=1,rmapbt=1, the
> > reservation sizes change like this:
> > 
> > Reservation		Before			After
> > (index)			logres	logcount	logres	logcount
> >  0	write		314104	    8		314104	    8
> >  1	itruncate	579456	    8           148608	    8
> >  2	rename		435840	    2           307936	    2
> >  3	link		191600	    2           191600	    2
> >  4	remove		312960	    2           174328	    2
> >  5	symlink		470656	    3           470656	    3
> >  6	create		469504	    2           469504	    2
> >  7	create_tmpfile	490240	    2           490240	    2
> >  8	mkdir		469504	    3           469504	    3
> >  9	ifree		508664	    2           508664	    2
> >  10	ichange		  5752	    0             5752	    0
> >  11	growdata	147840	    2           147840	    2
> >  12	addafork	178936	    2           178936	    2
> >  13	writeid		   760	    0              760	    0
> >  14	attrinval	578688	    1           147840	    1
> >  15	attrsetm	 26872	    3            26872	    3
> >  16	attrsetrt	 16896	    0            16896	    0
> >  17	attrrm		292224	    3           148608	    3
> >  18	clearagi	  4224	    0             4224	    0
> >  19	growrtalloc	173944	    2           173944	    2
> >  20	growrtzero	  4224	    0             4224	    0
> >  21	growrtfree	 10096	    0            10096	    0
> >  22	qm_setqlim	   232	    1              232	    1
> >  23	qm_dqalloc	318327	    8           318327	    8
> >  24	qm_quotaoff	  4544	    1             4544	    1
> >  25	qm_equotaoff	   320	    1              320	    1
> >  26	sb		  4224	    1             4224	    1
> >  27	fsyncts		   760	    0              760	    0
> > MAX			579456	    8           318327	    8
> > 
> > So we can see that many of the reservations have gone substantially
> > down in size. itruncate, rename, remove, attrinval and attrrm are
> > much smaller now. The maximum reservation size has gone from being
> > attrinval at 579456*8 bytes to dqalloc at 318327*8 bytes. This is a
> > substantial improvement for common operations.
> 
> If you're going to play around with log reservations, can you have a
> quick look at the branch I made to fix all the oversized reservations
> that we make for rmap and reflink?
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=reflink-speedups
> 
> That's what's next after deferred inode inactivation lands.

They all look reasonable at a first pass. I'd need to do more than
read the patches to say they are definitely correct, but they
certainly don't seem unreasonable to me. I'd also have to run
numbers like the table above so I can quantify the reductions,
but nothing shouted "don't do this!" to me....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
