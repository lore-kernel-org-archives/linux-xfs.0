Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12F4CC10F1B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 21:14:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235569AbiL3VOs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 16:14:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiL3VOr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 16:14:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87211C912;
        Fri, 30 Dec 2022 13:14:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 779B0B81C26;
        Fri, 30 Dec 2022 21:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D41AC433D2;
        Fri, 30 Dec 2022 21:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672434884;
        bh=rsU6F54u9LqXgAXfzEBqRrCQOjFfTMYagsDaoP6e3j8=;
        h=Date:From:To:Cc:Subject:From;
        b=IeuYRSomh14X6VQTrbdlMPKCRY9/5FI1jUeIhQjUz7W7O6fGfmuhkWSbhrd/p3edv
         JYEd8hUj8wD2wWnF0F0dVLgCsP1Cr5XPWwjKAgJRSI/nyFJHhBLG1MHu94kzNil6U3
         KPjWzUGDFQyO5YhvG4q/AzZQHIh5+aJa/luEfFRv82t23l/df9+h/glH68p+L0x0yF
         2rS6dINgFELu2xnh/vTMFMOXtq629qLZGCA0bpMMulsVmTJIQlHpyRGrmNcpas6DA8
         65cZd+VLFbbnx073IMyEiBXo0TOfhqyZDQAaclVPYrYGF3jUVqQI7KHyEcavnab8i0
         bESqWu9yrK0vw==
Date:   Fri, 30 Dec 2022 13:14:43 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Subject: [NYE DELUGE 4/4] xfs: freespace defrag for online shrink
Message-ID: <Y69Uw6W5aclS115x@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This fourth patch deluge has two faces -- one way of looking at it is
that it is random odds and ends at the tail of my development tree.  A
second interpretation is that it is necessary pieces for defragmenting
free space, which is a precursor for online shrink of XFS filesystems.

The kernel side isn't that exciting -- we export refcounting information
for space extents, and add a new fallocate mode for mapping exact
portions of free filesystem space into a file.

Userspace is where things get interesting!  The free space defragmenter
is an iterative algorithm that assigns free space to a dummy file, and
then uses the GETFSMAP and GETFSREFCOUNTS information to target file
space extents in order of decreasing share counts.  Once an extent has
been targeted, it uses reflinking to freeze the space, copies it
elsewhere, and uses FIDEDUPERANGE to remap existing file data until the
dummy file is the sole owner of the targetted space.  If metadata are
involved, the defrag utility invokes online repair to rebuild the
metadata somewhere else.

When the defragmenter finishes, all the free space has been isolated to
the dummy file, which can be unlinked and closed if defragmentation was
the goal; or it could be passed to a shrinkfs operation.

NOTE: There's also an experimental vectorization interface for scrub.
Given how long it's likely to take to get to this fourth deluge, it
might make more sense to integrate with io_uring when that day comes.

As a warning, the patches will likely take several days to trickle in.

--D
