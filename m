Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55444 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751937AbdLESz0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Dec 2017 13:55:26 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3208D3AAF0
        for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2017 18:55:26 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0667E7A1E1
        for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2017 18:55:26 +0000 (UTC)
Date: Tue, 5 Dec 2017 13:55:24 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: extfree log recovery and owner (rmapbt) updates
Message-ID: <20171205185524.GB42206@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

I've been playing around with deferring AGFL block frees and noticed
something funky going on with xfs_bmap_add_free() and owner info. We
pass the extent owner info to xfs_bmap_add_free() in various places to
transfer this info to the deferred free processing context.
Subsequently, xfs_trans_free_extent() -> ... -> xfs_free_ag_extent()
uses the owner info to remove the rmapbt entry associated with the
extent. The rmapbt update occurs at the time the extent is freed.

If the system crashes immediately after the initial transaction commits,
however, EFI recovery calls xfs_trans_free_extent() with an "unknown"
owner. I see a reference to using a "wildcard" in this context in some
of the old rmapbt commits, but it looks like this codepath skips the
rmapbt update altogether if oi_owner == XFS_RMAP_OWN_UNKNOWN. A quick
test that shuts down the fs immediately after a transaction commits that
logs an EFI for a freed inode chunk leaves the fs inconsistent after log
recovery, with a bit of a cryptic message from repair:

  unknown block state, ag 0, block 24

It does look like the associated rmapbt entry still exists in the tree
even though the extent has been freed (from xfs_db -c fsmap):

5: 0/24 len 8 owner -7 offset 0 bmbt 0 attrfork 0 extflag 0                                                            

So what is supposed to be going on here? Should the rmapbt entry be
removed unconditionally during recovery, or should a separate rmapbt
update item be deferred (as in the bunmapi case, for example) rather
than passing oinfo along with the TYPE_FREE deferred item? Or something
else entirely..?

Brian
