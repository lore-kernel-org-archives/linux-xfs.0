Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD836C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 17:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234989AbiLMRTD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 12:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236182AbiLMRTA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 12:19:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6361E222B5
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 09:18:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0438BB810DF
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 17:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBB8C433EF;
        Tue, 13 Dec 2022 17:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670951936;
        bh=sS+SRy6JJU+YgL5XR9rPRje7XqbFue3P1JGr+0JA0D8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B+AY2XtFhk3HGvYqlH/rx09+Xo2Fcb5zalGlBLE2c65GIrC9i2AX/zXaU07oZZXt5
         8L/DWl824vRQ52+QsHCsBSD9GlbJ/2LVfsjFKCW3Rz8B3lgXir41mNCjtt32Ea8J5v
         gxK93oGTcVqgXuIX3OEbypicOE4TL65SIZlFHv8sRl9QtbUL7/GnacAabMgSFlaXCL
         FgKbBlNK/QFtouEb0EJQwiExr9uEEP8ooTroduk8AR4TX6MvQzkCgnVSu6ga5HEsNh
         PJ2dBJZz2P9CpyeufJCVqYNKz0jTfVWaYsKf3DUda90RDcZd7VlhzUDCu7tFGWmPte
         oebHVijzlbwhw==
Date:   Tue, 13 Dec 2022 09:18:56 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Suyash Mahar <smahar@ucsd.edu>
Cc:     linux-xfs@vger.kernel.org, tpkelly@eecs.umich.edu,
        Suyash Mahar <suyash12mahar@outlook.com>
Subject: Re: XFS reflink overhead, ioctl(FICLONE)
Message-ID: <Y5i0ALbAdEf4yNuZ@magnolia>
References: <CACQnzjuhRzNruTm369wVQU3y091da2c+h+AfRED+AtA-dYqXNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACQnzjuhRzNruTm369wVQU3y091da2c+h+AfRED+AtA-dYqXNQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[ugh, your email never made it to the list.  I bet the email security
standards have been tightened again.  <insert rant about dkim and dmarc
silent failures here>] :(

On Sat, Dec 10, 2022 at 09:28:36PM -0800, Suyash Mahar wrote:
> Hi all!
> 
> While using XFS's ioctl(FICLONE), we found that XFS seems to have
> poor performance (ioctl takes milliseconds for sparse files) and the
> overhead
> increases with every call.
> 
> For the demo, we are using an Optane DC-PMM configured as a
> block device (fsdax) and running XFS (Linux v5.18.13).

How are you using fsdax and reflink on a 5.18 kernel?  That combination
of features wasn't supported until 6.0, and the data corruption problems
won't get fixed until a pull request that's about to happen for 6.2.

> We create a 1 GiB dense file, then repeatedly modify a tiny random
> fraction of it and make a clone via ioctl(FICLONE).

Yay, random cow writes, that will slowly increase the number of space
mapping records in the file metadata.

> The time required for the ioctl() calls increases from large to insane
> over the course of ~250 iterations: From roughly a millisecond for the
> first iteration or two (which seems high, given that this is on
> Optane and the code doesn't fsync or msync anywhere at all, ever) to 20
> milliseconds (which seems crazy).

Does the system call runtime increase with O(number_extents)?  You might
record the number of extents in the file you're cloning by running this
periodically:

xfs_io -c stat $path | grep fsxattr.nextents

FICLONE (at least on XFS) persists dirty pagecache data to disk, and
then duplicates all written-space mapping records from the source file to
the destination file.  It skips preallocated mappings created with
fallocate.

So yes, the plot is exactly what I was expecting.

--D

> The plot is attached to this email.
> 
> A cursory look at the extent map suggests that it gets increasingly
> complicated resulting in the complexity.
> 
> The enclosed tarball contains our code, our results, and some other info
> like a flame graph that might shed light on where the ioctl is spending
> its time.
> 
> - Suyash & Terence



