Return-Path: <SRS0=bXuc=2B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79D20C43603
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Dec 2019 12:47:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42F16214D8
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Dec 2019 12:47:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NmYYI0l+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbfLKMrQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Dec 2019 07:47:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41716 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727402AbfLKMrQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Dec 2019 07:47:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576068435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XpDlSpaIiYX1hh5xwg4wzCVzv8vvdNKlJnu5VR4TI6Q=;
        b=NmYYI0l+ynwqyucBJhsXhnPdEfyjde9cblBXhG5jPaw5l+TxSd9xi4xR4pbcQIVqfkAEpY
        S15XCJWE1mwSay/J0GKFl85AJ/dezvOLcIdtmFKJVvO9i9PfN1QxYgjHvuaB0eUjSIAEM7
        tKYgXVrALWMoDS9WV6lcZEP4oLwndm4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-ad8-fnF9P0S-RE5NbCSYEw-1; Wed, 11 Dec 2019 07:47:14 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76C9B1005502;
        Wed, 11 Dec 2019 12:47:13 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 204246363C;
        Wed, 11 Dec 2019 12:47:13 +0000 (UTC)
Date:   Wed, 11 Dec 2019 07:47:12 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: stabilize insert range start boundary to avoid COW
 writeback race
Message-ID: <20191211124712.GB16095@bfoster>
References: <20191210132340.11330-1-bfoster@redhat.com>
 <20191210214100.GB19256@dread.disaster.area>
MIME-Version: 1.0
In-Reply-To: <20191210214100.GB19256@dread.disaster.area>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: ad8-fnF9P0S-RE5NbCSYEw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 11, 2019 at 08:41:00AM +1100, Dave Chinner wrote:
> On Tue, Dec 10, 2019 at 08:23:40AM -0500, Brian Foster wrote:
> > generic/522 (fsx) occasionally fails with a file corruption due to
> > an insert range operation. The primary characteristic of the
> > corruption is a misplaced insert range operation that differs from
> > the requested target offset. The reason for this behavior is a race
> > between the extent shift sequence of an insert range and a COW
> > writeback completion that causes a front merge with the first extent
> > in the shift.
>=20
> How is the COW writeback completion modifying the extent list while
> an extent shift is modifying the extent list?  Both should be
> running under XFS_ILOCK_EXCL contexts so there shouldn't be a race
> condition here unless we've screwed up the extent list modification
> atomicity...
>=20
> >=20
> > The shift preparation function flushes and unmaps from the target
> > offset of the operation to the end of the file to ensure no
> > modifications can be made and page cache is invalidated before file
> > data is shifted. An insert range operation then splits the extent at
> > the target offset, if necessary, and begins to shift the start
> > offset of each extent starting from the end of the file to the start
> > offset. The shift sequence operates at extent level and so depends
> > on the preparation sequence to guarantee no changes can be made to
> > the target range during the shift.
>=20
> Oh... shifting extents is not an atomic operation w.r.t. other
> inode modifications - both insert and collapse run individual
> modification transactions and lock/unlock the inode around each
> transaction. So, essentially, they aren't atomic when faced with
> other *metadata* modifications to the inode.
>=20

Right..

> > If the block immediately prior to
> > the target offset was dirty and shared, however, it can undergo
> > writeback and move from the COW fork to the data fork at any point
> > during the shift. If the block is contiguous with the block at the
> > start offset of the insert range, it can front merge and alter the
> > start offset of the extent. Once the shift sequence reaches the
> > target offset, it shifts based on the latest start offset and
> > silently changes the target offset of the operation and corrupts the
> > file.
>=20
> Yup, that's exactly the landmine that non-atomic, multi-transaction
> extent range operations have. It might be a COW operation, it might
> be something else that ends up manipulating the extent list. But
> because the ILOCK is not held across the entire extent shift,
> insert/collapse are susceptible to corruption when any other XFs
> code concurrently modifies the extent list.
>=20
> I think insert/collapse need to be converted to work like a
> truncate operation instead of a series on individual write
> operations. That is, they are a permanent transaction that locks the
> inode once and is rolled repeatedly until the entire extent listi
> modification is done and then the inode is unlocked.
>=20

Note that I don't think it's sufficient to hold the inode locked only
across the shift. For the insert case, I think we'd need to grab it
before the extent split at the target offset and roll from there.
Otherwise the same problem could be reintroduced if we eventually
replaced the xfs_prepare_shift() tweak made by this patch. Of course,
that doesn't look like a big problem. The locking is already elevated
and split and shift even use the same transaction type, so it's mostly a
refactor from a complexity standpoint.=20

For the collapse case, we do have a per-shift quota reservation for some
reason. If that is required, we'd have to somehow replace it with a
worst case calculation. That said, it's not clear to me why that
reservation even exists. The pre-shift hole punch is already a separate
transaction with its own such reservation. The shift can merge extents
after that point (though most likely only on the first shift), but that
would only ever remove extent records. Any thoughts or objections if I
just killed that off?

> > To address this problem, update the shift preparation code to
> > stabilize the start boundary along with the full range of the
> > insert. Also update the existing corruption check to fail if any
> > extent is shifted with a start offset behind the target offset of
> > the insert range. This prevents insert from racing with COW
> > writeback completion and fails loudly in the event of an unexpected
> > extent shift.
>=20
> It looks ok to avoid this particular symptom (backportable point
> fix), but I really think we should convert insert/collapse to be
> atomic w.r.t other extent list modifications....
>=20

Ok, I think that approach is reasonable so long as we do it in two
phases as such to minimize backport churn and separate bug fix from
behavior change.

Unless there is other feedback on this patch, is there any objection to
getting this one reviewed/merged independently? I can start looking into
the shift rework today, but that is ultimately going to require more
involved testing than I'd prefer to block the bug fix on (whereas this
patch has now seen multiple days of fsx testing..).

Brian

> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com
>=20

