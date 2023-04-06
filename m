Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6175DC7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjDFTHK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjDFTHJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:07:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E3930E4;
        Thu,  6 Apr 2023 12:07:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2A3A64B41;
        Thu,  6 Apr 2023 19:07:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25709C433EF;
        Thu,  6 Apr 2023 19:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680808027;
        bh=7ozIwwBNug2non7XygOiUzDCqZmhf2FF30AU2MyEYnE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bd7yjVqMJ3Eh8UQAAa9Z9GehnL+DLGK+LMh42dCiAX+VwT+fX3gU13qWvEWDrp9/c
         XurN7beh5jhmKJRFr5cqasjqWLTKkoblKwoAG16JpPLpYZfPlNPoVSmyMLwwTR21Am
         /RGfQ2EFGTgLKGixtyc5URz28xMMcm92YU1fb8MmMvS0vtu5/YQHmSC9TFJf8cP26m
         5e2zA4IKI67icrsgiynhSbpg7c9RrqwRhjxIK0FKCMUQa0HNb4hl1xZbHieAxjzP0q
         SR65TKY3AANfjzKOZFzFreX5h2l0oJ7vlWq7qPRCFXg/GDMXJd/ALP2BF1uQ5kjGsY
         u4L3Bb/B4s6RA==
Date:   Thu, 6 Apr 2023 12:07:06 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Subject: Re: [PATCHSET DELUGE v11] xfs: Parent Pointers
Message-ID: <20230406190706.GB360889@frogsfrogsfrogs>
References: <20230406181038.GA360889@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406181038.GA360889@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 06, 2023 at 11:10:38AM -0700, Darrick J. Wong wrote:
> Hi everyone,
> 
> This submission contains all of the changes to the parent pointers
> patchset that I've been working since last month's deluge.  The kernel
> and xfsprogs patchsets are based on Allison's v10 tag from some time
> ago.  To recap Allison's cover letter:
> 
> "The goal of this patch set is to add a parent pointer attribute to each
> inode.  The attribute name containing the parent inode, generation, and
> directory offset, while the  attribute value contains the file name.
> This feature will enable future optimizations for online scrub, shrink,
> nfs handles, verity, or any other feature that could make use of quickly
> deriving an inodes path from the mount point."
> 
> v11 rebases everything against 6.3-rc5, and weaves all the changes that
> I had made against v10 into Allison's original series.  The new xattr
> NVLOOKUP mode that I introduced for v10 is critical for handling parent
> pointer attr name collisions with grace, so that has been retained from
> v10.  With that in place, I've replaced the diroffset in the ondisk
> parent pointer with the dirent hash of the name.
> 
> Parent pointers now look like this:
> 
> 	(parent_ino, parent_gen, namehash) -> (name[])
> 
> I experimented with replacing the dahash with crc32c for this patchset
> but left it out, having concluded that checksum operation has higher
> overhead (thanks, crypto api!), would require someone to figure out crc
> spoofing sufficiently well to keep metadump name obfuscation working,
> and doesn't seem to improve collision resistance sufficiently to be
> worth the added engineering cost.
> 
> As of this submission, I think this feature is ready to go once we've
> merged the online repair code and rebased the online repair code to
> actually commit the repaired directories.
> 
> If you want to pull the whole thing, use these links:
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-drop-unnecessary

<sigh> Apparently vim undid my edit here; the correct URL is:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs

--D

> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=pptrs
> 
> --D
