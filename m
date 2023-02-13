Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68922C636CC
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 23:02:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjBMXCC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Feb 2023 18:02:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjBMXCC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Feb 2023 18:02:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61CA6BDCD
        for <linux-xfs@vger.kernel.org>; Mon, 13 Feb 2023 15:02:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2F5F6131C
        for <linux-xfs@vger.kernel.org>; Mon, 13 Feb 2023 23:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6244DC433A1
        for <linux-xfs@vger.kernel.org>; Mon, 13 Feb 2023 23:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676329319;
        bh=z++6rm+oHKjwdlqtM6zgSPmLoEWy/kCKygDAXFvvsFA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=hcYqJ9YQMPLzgw6ErqwNwbKZKSQBJwe2sKRdi9ku6z7Pik5DWh3dc9BmMUcgN+Z88
         d4AwbtY4x3DEmaBbSQ6jOwf6UQu49oNQ5G2f2X4j7lWLo1jMUqCO08eVniJJLMaRRX
         FIOtqGCjs55OeZhNlU4uHvQpEKFa7npQ4vOZIIc2RSVEtla/OZwe/h/j3VClxaiQSl
         rlQPo7cZcWeMKQcUX4zCpHqZ1QI9O7G1s5lKUP5428UILGIBSfmlTMS8Z+frNSQQzm
         zqE7kUsqH9gRNx7YdRMrOZ8+mhmmpak/I9htC+y9Pkv04zOcyCI5/kbYGuwPZQfIAf
         890ZPJ8vep4Mw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 4F085C072A6; Mon, 13 Feb 2023 23:01:59 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217030] [Syzkaller & bisect] There is
 "xfs_bmapi_convert_delalloc" WARNING in v6.2-rc7 kernel
Date:   Mon, 13 Feb 2023 23:01:58 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217030-201763-Ag2vUBEXrD@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217030-201763@https.bugzilla.kernel.org/>
References: <bug-217030-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217030

--- Comment #1 from Dave Chinner (david@fromorbit.com) ---
On Mon, Feb 13, 2023 at 10:57:31AM +0000, bugzilla-daemon@kernel.org wrote:
> Bisected and found the first bad commit is:
> 7348b322332d8602a4133f0b861334ea021b134a
> xfs: xfs_bmap_punch_delalloc_range() should take a byte range

I don't see how that commit makes any material difference to the
code; the ranges being punched are the same, just being passed in
different units.

The test filesystem image has a 1kB block size, and it has a bad CRC
in the root bnobt block, hence any attempt to allocate fails
immediately with a corrupt root btree block. The first write done
by the reproducer is an O_SYNC write, so it writes 0x1400 bytes into
the page cache (5 1kB blocks) and then internally the write() runs
fsync() which then fails to allocate the blocks in the writeback
path.

This writeback failure then calls ->discard_page() on the write range,
which punches out the delalloc block underneath the failed write.

At the same time, the other thread is doing a direct IO write, and
it sees there are dirty page cache pages over the page cache and it
attempts to writeback the page. It calls into ->map_blocks which
then sees a delalloc extent and tries to convert it. By the time
writeback has locked the folio, locked the ILOCK and runs the
delalloc extent conversion, the delalloc extent has been punched,
and it fails to find the delalloc extent to convert. It then issues
the WARN_ON() reported in this bug report.

I don't think this a failure that is a result of the commit that the
bisect identified - I think the race condition has been there for a
lot longer, and for some reason we've perturbed the code enough
to now expose the race condition occasionally. i.e. the
->discard_folio path is not invalidating the folio or marking it
with an error when we punch the backing store from under it, so it's
remaining dirty in the page cache but without any backing store for
writeback.

Hence I suspect the problem here is that we aren't calling
folio_set_error() on folios that we fail the first delalloc block
conversion on (i.e. count is zero) so this isn't operating like an
IO error. i.e. page_endio() calls folio_set_error() when a
writeback IO fails, and we are not doing that when we call
->discard_folio so the folio remains dirty and uptodate.  Hence
after a failed writeback due to allocation failure, we have the
situation where a dirty page has no backing store, and it seems a
future writeback can trip over that state.

Hence I suspect this commit first exposed the issue being reported
here:

commit e9c3a8e820ed0eeb2be05072f29f80d1b79f053b
Author: Darrick J. Wong <djwong@kernel.org>
Date:   Mon May 16 15:27:38 2022 -0700

    iomap: don't invalidate folios after writeback errors

    XFS has the unique behavior (as compared to the other Linux filesystems)
    that on writeback errors it will completely invalidate the affected
    folio and force the page cache to reread the contents from disk.  All
    other filesystems leave the page mapped and up to date.

    This is a rude awakening for user programs, since (in the case where
    write fails but reread doesn't) file contents will appear to revert to
    old disk contents with no notification other than an EIO on fsync.  This
    might have been annoying back in the days when iomap dealt with one page
    at a time, but with multipage folios, we can now throw away *megabytes*
    worth of data for a single write error.

    On *most* Linux filesystems, a program can respond to an EIO on write by
    redirtying the entire file and scheduling it for writeback.  This isn't
    foolproof, since the page that failed writeback is no longer dirty and
    could be evicted, but programs that want to recover properly *also*
    have to detect XFS and regenerate every write they've made to the file.

    When running xfs/314 on arm64, I noticed a UAF when xfs_discard_folio
    invalidates multipage folios that could be undergoing writeback.  If,
    say, we have a 256K folio caching a mix of written and unwritten
    extents, it's possible that we could start writeback of the first (say)
    64K of the folio and then hit a writeback error on the next 64K.  We
    then free the iop attached to the folio, which is really bad because
    writeback completion on the first 64k will trip over the "blocks per
    folio > 1 && !iop" assertion.

    This can't be fixed by only invalidating the folio if writeback fails at
    the start of the folio, since the folio is marked !uptodate, which trips
    other assertions elsewhere.  Get rid of the whole behavior entirely.

    Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
    Reviewed-by: Jeff Layton <jlayton@kernel.org>
    Reviewed-by: Christoph Hellwig <hch@lst.de>

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 8fb9b2797fc5..94b53cbdefad 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1387,7 +1387,6 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
                if (wpc->ops->discard_folio)
                        wpc->ops->discard_folio(folio, pos);
                if (!count) {
-                       folio_clear_uptodate(folio);
                        folio_unlock(folio);
                        goto done;
                }

This commit removed the invalidation of the folio after discarding
it's backing store via ->discard_folio, hence allowing writeback of
dirty folios that have no storage reservation or delalloc extent
backing the dirty folio.

This, to me, looks like the underlying problem here. If we are not
invalidating the cached data on writeback allocation failure, we must
not punch out the storage reservation backing the dirty cached data
as we are going to retry the write at some point in the future and
hence still need the storage reservation for the dirty folio....

..... and removing ->discard_folio() then results in delalloc
extents that cannot be converted by writeback and so when we go to
reclaim the inode during cache eviction we now have delalloc extents
on the inode and that trips assert failures because writeback is
it assumes that writeback will always resolve delalloc extents
either by conversion or discarding them.

Ok, the simple solution trips over other assumptions.  More
investigation required....

-Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
