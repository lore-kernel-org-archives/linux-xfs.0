Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8962C47089
	for <linux-xfs@archiver.kernel.org>; Fri, 28 May 2021 00:01:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9813361183
	for <linux-xfs@archiver.kernel.org>; Fri, 28 May 2021 00:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235780AbhE1AD3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 20:03:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235933AbhE1AD2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 20:03:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61FF6611C9;
        Fri, 28 May 2021 00:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622160114;
        bh=gt0dTk5jntF+5SM9DIU0VYalDMSvyj75mHyzPYJzBlE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T8XPTSaNeat3eNwjXdor5GBBbD5VWg1cximNPYzkJLWi5idiTuVwPSyzpqk+i+B1c
         z4TxWhKZAmGMMMinHM8XLRlEsvnlHef+/zIJplGZXmUU9iGadTQLFecBY0Q5NiS3vu
         glrSqgmbxIWvMfJuPDAzIHRbK+xTxy828pkn187iNdr0gILpwhcBMMwnoVY8eNc1hB
         XMSxLt7YND2uUcL6r+L0a/5fL9zq2R5fiT9hEwRC4ei7tzYEZZDGUuQUmDp5seB6Ne
         V9mToFqDvHNH0/bqmZ5hKNwuZEvEwmtS7TOr7OgJiRTcLQspQRG0dedbK7H8B7i+4u
         dR+8hitUIbYjw==
Date:   Thu, 27 May 2021 17:01:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: reduce transaction reservation for freeing
 extents
Message-ID: <20210528000153.GM2402049@locust>
References: <20210527045202.1155628-1-david@fromorbit.com>
 <20210527045202.1155628-7-david@fromorbit.com>
 <20210527061947.GE202121@locust>
 <20210527085215.GP664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527085215.GP664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 27, 2021 at 06:52:15PM +1000, Dave Chinner wrote:
> On Wed, May 26, 2021 at 11:19:47PM -0700, Darrick J. Wong wrote:
> > On Thu, May 27, 2021 at 02:52:02PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Ever since we moved to deferred freeing of extents, we only every
> > > free one extent per transaction. We separated the bulk unmapping of
> > > extents from the submission of EFI/free/EFD transactions, and hence
> > > while we unmap extents in bulk, we only every free one per
> > > transaction.
> > > 
> > > Our transaction reservations still live in the era from before
> > > deferred freeing of extents, so still refer to "xfs_bmap_finish"
> > > and it needing to free multiple extents per transaction. These
> > > freeing reservations can now all be reduced to a single extent to
> > > reflect how we currently free extents.
> > > 
> > > This significantly reduces the reservation sizes for operations like
> > > truncate and directory operations where they currently reserve space
> > > for freeing up to 4 extents per transaction.
> > > 
> > > For a 4kB block size filesytsem with reflink=1,rmapbt=1, the
> > > reservation sizes change like this:
> > > 
> > > Reservation		Before			After
> > > (index)			logres	logcount	logres	logcount
> > >  0	write		314104	    8		314104	    8
> > >  1	itruncate	579456	    8           148608	    8
> > >  2	rename		435840	    2           307936	    2
> > >  3	link		191600	    2           191600	    2
> > >  4	remove		312960	    2           174328	    2
> > >  5	symlink		470656	    3           470656	    3
> > >  6	create		469504	    2           469504	    2
> > >  7	create_tmpfile	490240	    2           490240	    2
> > >  8	mkdir		469504	    3           469504	    3
> > >  9	ifree		508664	    2           508664	    2
> > >  10	ichange		  5752	    0             5752	    0
> > >  11	growdata	147840	    2           147840	    2
> > >  12	addafork	178936	    2           178936	    2
> > >  13	writeid		   760	    0              760	    0
> > >  14	attrinval	578688	    1           147840	    1
> > >  15	attrsetm	 26872	    3            26872	    3
> > >  16	attrsetrt	 16896	    0            16896	    0
> > >  17	attrrm		292224	    3           148608	    3
> > >  18	clearagi	  4224	    0             4224	    0
> > >  19	growrtalloc	173944	    2           173944	    2
> > >  20	growrtzero	  4224	    0             4224	    0
> > >  21	growrtfree	 10096	    0            10096	    0
> > >  22	qm_setqlim	   232	    1              232	    1
> > >  23	qm_dqalloc	318327	    8           318327	    8
> > >  24	qm_quotaoff	  4544	    1             4544	    1
> > >  25	qm_equotaoff	   320	    1              320	    1
> > >  26	sb		  4224	    1             4224	    1
> > >  27	fsyncts		   760	    0              760	    0
> > > MAX			579456	    8           318327	    8
> > > 
> > > So we can see that many of the reservations have gone substantially
> > > down in size. itruncate, rename, remove, attrinval and attrrm are
> > > much smaller now. The maximum reservation size has gone from being
> > > attrinval at 579456*8 bytes to dqalloc at 318327*8 bytes. This is a
> > > substantial improvement for common operations.
> > 
> > If you're going to play around with log reservations, can you have a
> > quick look at the branch I made to fix all the oversized reservations
> > that we make for rmap and reflink?
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=reflink-speedups
> > 
> > That's what's next after deferred inode inactivation lands.
> 
> They all look reasonable at a first pass. I'd need to do more than
> read the patches to say they are definitely correct, but they
> certainly don't seem unreasonable to me. I'd also have to run
> numbers like the table above so I can quantify the reductions,
> but nothing shouted "don't do this!" to me....

Reservations before and after for a sample 100G filesystem:

# mkfs.xfs /tmp/a.img
meta-data=/tmp/a.img             isize=512    agcount=4, agsize=6553600 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1
data     =                       bsize=4096   blocks=26214400, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=12800, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Look like:

<before>				<after>
type 0 res 294904 count 8             | type 0 res 185080 count 5
type 1 res 547200 count 8             | type 1 res 327552 count 5
type 2 res 410752 count 2             | type 2 res 307936 count 2
type 3 res 187760 count 2               type 3 res 187760 count 2
type 4 res 290688 count 2             | type 4 res 180864 count 2
type 5 res 434560 count 3             | type 5 res 269824 count 3
type 6 res 433408 count 2             | type 6 res 268672 count 2
type 7 res 450432 count 2             | type 7 res 285696 count 2
type 8 res 433408 count 3             | type 8 res 268672 count 3
type 9 res 468728 count 2             | type 9 res 303992 count 2
type 10 res 2168 count 0                type 10 res 2168 count 0
type 11 res 137088 count 2            | type 11 res 82176 count 2
type 12 res 163320 count 2            | type 12 res 108408 count 2
type 13 res 760 count 0                 type 13 res 760 count 0
type 14 res 546432 count 1            | type 14 res 326784 count 1
type 15 res 23288 count 3               type 15 res 23288 count 3
type 16 res 13312 count 0               type 16 res 13312 count 0
type 17 res 274304 count 3            | type 17 res 164480 count 3
type 18 res 640 count 0                 type 18 res 640 count 0
type 19 res 158328 count 2            | type 19 res 103416 count 2
type 20 res 4224 count 0                type 20 res 4224 count 0
type 21 res 6512 count 0                type 21 res 6512 count 0
type 22 res 232 count 1                 type 22 res 232 count 1
type 23 res 299127 count 8            | type 23 res 189303 count 5
type 24 res 848 count 1                 type 24 res 848 count 1
type 25 res 208 count 1                 type 25 res 208 count 1
type 26 res 640 count 1                 type 26 res 640 count 1
type 27 res 760 count 0                 type 27 res 760 count 0
type -1 res 547200 count 8              type -1 res 327552 count 5

IOWs, a 63% reduction in the size of an itruncate reservations.

Note that the patchset also includes the necessary pieces to continue
formatting filesystems with the same minimum log size rules as before so
that you can format with a new xfsprogs and still be able to mount on an
older kernel.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
