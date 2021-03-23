Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C82C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 20:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F41F601FE
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 20:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbhCWU56 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 16:57:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233340AbhCWU5b (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Mar 2021 16:57:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DA25619C2;
        Tue, 23 Mar 2021 20:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616533051;
        bh=DwFqB5ZeRcy79Fu2DlrLkcLO++PTFau1DQjBnKJ0wVU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=axK5mE6SACEBzYlJP1kIJFZVRIhKN5jPQ+GYIOe0yLrUi8r+i2kQ0M5Qq2l1CnDLD
         QrGa3BUmFlBC0vwKhVUu4bgVuOaOmx8ijvv1mECGLWcHovskKR/TLkD0Ip+DOYb8WN
         AReKMqBATtREEhHISOSDAvxmDZYwt2Cc0d/PSPG3u/ebxivAN3jEVB973DMl6ykdQx
         2bNcV859yR5npnVdKDIHO0s0Gf1c59A+F5VNryauFu6M7yDBUA6qCNtKII52o+gRfO
         9VuJi7AWF258/E3+XVkYdh8B3TiZHjRr9Pb6bdbYYi53F7GSPeXI7HFOf/5pFK2qGl
         nkc3/Mnb+YDGA==
Date:   Tue, 23 Mar 2021 13:57:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V6 05/13] xfs: Check for extent overflow when growing
 realtime bitmap/summary inodes
Message-ID: <20210323205730.GN22100@magnolia>
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
 <20210309050124.23797-6-chandanrlinux@gmail.com>
 <20210322175652.GG1670408@magnolia>
 <87r1k56f7k.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r1k56f7k.fsf@garuda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 23, 2021 at 09:21:27PM +0530, Chandan Babu R wrote:
> On 22 Mar 2021 at 23:26, Darrick J. Wong wrote:
> > On Tue, Mar 09, 2021 at 10:31:16AM +0530, Chandan Babu R wrote:
> >> Verify that XFS does not cause realtime bitmap/summary inode fork's
> >> extent count to overflow when growing the realtime volume associated
> >> with a filesystem.
> >>
> >> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> >> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> >
> > Soo... I discovered that this test doesn't pass with multiblock
> > directories:
> 
> Thanks for the bug report and the description of the corresponding solution. I
> am fixing the tests and will soon post corresponding patches to the mailing
> list.

Also, I found a problem with xfs/534 when it does the direct write tests
to a pmem volume with DAX enabled:

--- /tmp/fstests/tests/xfs/534.out      2021-03-21 11:44:09.384407426 -0700
+++ /var/tmp/fstests/xfs/534.out.bad    2021-03-23 13:32:15.898301839 -0700
@@ -5,7 +5,4 @@
 Fallocate 15 blocks
 Buffered write to every other block of fallocated space
 Verify $testfile's extent count
-* Direct write to unwritten extent
-Fallocate 15 blocks
-Direct write to every other block of fallocated space
-Verify $testfile's extent count
+Extent count overflow check failed: nextents = 11

looking at the xfs_bmap output for $testfile shows:

/opt/testfile:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..7]:          208..215          0 (208..215)           8 010000
   1: [8..15]:         216..223          0 (216..223)           8 000000
   2: [16..23]:        224..231          0 (224..231)           8 010000
   3: [24..31]:        232..239          0 (232..239)           8 000000
   4: [32..39]:        240..247          0 (240..247)           8 010000
   5: [40..47]:        248..255          0 (248..255)           8 000000
   6: [48..55]:        256..263          0 (256..263)           8 010000
   7: [56..63]:        264..271          0 (264..271)           8 000000
   8: [64..71]:        272..279          0 (272..279)           8 010000
   9: [72..79]:        280..287          0 (280..287)           8 000000
  10: [80..119]:       288..327          0 (288..327)          40 010000

Which is ... odd since the same direct write gets cut off after writing
to block 7 (like you'd expect since it's the same function) when DAX
isn't enabled...

...OH, I see the problem.  For a non-DAX direct write,
xfs_iomap_write_direct will allocate an unwritten block into a hole, but
if the block was already mapped (written or unwritten) it won't do
anything at all.  For that case, XFS_IEXT_ADD_NOSPLIT_CNT is sufficient,
because in the worst case we add one extent to the data fork.

For DAX writes, however, the behavior is different:

	if (IS_DAX(VFS_I(ip))) {
		bmapi_flags = XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO;
		if (imap->br_state == XFS_EXT_UNWRITTEN) {
			force = true;
			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
		}
	}

This tells xfs_bmapi_write that we want to /convert/ an unwritten extent
to written, and we want to zero the blocks.  If we're dax-writing into
the middle of an unwritten range, this will cause a split.  The correct
parameter there would be XFS_IEXT_WRITE_UNWRITTEN_CNT.  Would you mind
sending a kernel patch to fix that?

--D

> --
> chandan
