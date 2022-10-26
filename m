Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C44C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Oct 2022 18:50:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbiJZSuf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Oct 2022 14:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233990AbiJZSue (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2022 14:50:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12AA66BD4C
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 11:50:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5023E61FFC
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 18:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B0CC43141;
        Wed, 26 Oct 2022 18:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666810231;
        bh=YoMYVmVdTBzQ5ePIEi0miTJPNQAbN+3wlQldFqgR7Ak=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tM6NPRFs88oTvItUiJMBF5pE3QhlY4MfxeKqRYpxIw0zkFcuvBmd8/E2KB7EcWvML
         IgVULgHEBsTFHgxtXdwK95tUh9jimFoF5TjTxdctEEzRswp8yLlqEq48QrzRIjo+8P
         6liaiLYwbJC9p0E+CB1corUTMOYblf/BxN7XsmJYioa7HQb1pxUiGCgaVdQTf5wHJt
         eROAKsdQQiU3qyjMKhjVHgprpilAs09B8Gax0G/VASsT/czVNLz1vtqL2XEq7/TVeJ
         sh/iokO/dep/UvvOA5cRLc8sUJoobP5e4itm+DqnN5rzcl6kH55JUd7obkPmCxzL+r
         q7WhHSD7JJcVQ==
Date:   Wed, 26 Oct 2022 11:50:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Matthias Bodenbinder <matthias@bodenbinder.de>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: xfs_scrub: inode record: Attempting optimization
Message-ID: <Y1mBd3cA/nYI/3wR@magnolia>
References: <793f95a4b1f1efa959540aed9c48e751dd648c91.camel@bodenbinder.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <793f95a4b1f1efa959540aed9c48e751dd648c91.camel@bodenbinder.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 26, 2022 at 09:53:30AM +0200, Matthias Bodenbinder wrote:
> Hello,
> 
> I am not sure if this is the right place to ask my question. If not
> please forgive me and point me to the correct place.
> 
> I have a question about xfs_scrub. When I run this on my root directory
> I get plenty of info messages like:
> 
> ####
> # xfs_scrub -v / 
> EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
> Phase 1: Find filesystem geometry.
> /: using 24 threads to scrub.
> Phase 2: Check internal metadata.
> Phase 3: Scan all inodes.
> Phase 4: Repair filesystem.
> Info: inode 100663763 (3/467) inode record: Attempting optimization.
> Info: inode 67169419 (2/60555) inode record: Attempting optimization.
> Info: inode 33566167 (1/11735) inode record: Attempting optimization.
> ...
> 
> Phase 5: Check directory tree.
> Phase 7: Check summary counters.
> 44,0GiB data used;  1,2M inodes used.
> 43,6GiB data found; 1,2M inodes found.
> 1,2M inodes counted; 1,2M inodes checked.
> ####
> 
> 
> I see more than 3200 Info lines like this. And they occur also with any
> subsequent scrub. They are not going away.
> 
> Can I fix this somehow or shall I just ignore it?

Unfortunately, the *repair* part of online fsck isn't upstream yet, so
the kernel doesn't actually know how to fix or optimize anything.

For now, you might as well run scrub in dry-run mode (-n) which should
cut down on the warnings.

(Though TBH there's not really much point in running xfs_scrub until I
can get all ~480 patches through the review process -- there are 100
pending fixes and strengthening patches for the checking part alone.)

That said -- thanks for trying it out! :)

--D

> Kind Regards
> Matthias
> 
> PS
> This is on EndeavourOS with kernel 5.15.74-lts
> 
