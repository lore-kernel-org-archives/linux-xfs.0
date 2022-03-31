Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95D4DC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Mar 2022 16:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239827AbiCaQWn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Mar 2022 12:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239823AbiCaQWm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Mar 2022 12:22:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5702F13E416
        for <linux-xfs@vger.kernel.org>; Thu, 31 Mar 2022 09:20:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2B7C61284
        for <linux-xfs@vger.kernel.org>; Thu, 31 Mar 2022 16:20:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CB9C340ED;
        Thu, 31 Mar 2022 16:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648743654;
        bh=7fh39jG3oM1dNcHvrKlB6VYWSa6RafadTDzteS3vKtY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UwHhi5L2izUCTtwpkAN29pqmdI8pCTylVVU8ZyTRIL22nE/+y8xRbc7hbeRRbE3dI
         M9BBY4d31fxMVpqW7PyueVcv4XXKNf8YZhGwfJTLFNnI/Uh/PS0lYTmhgviP6y212V
         5eBL2kvE1OOVuqL5Ac2RSjcXgcF7b+FhT39xYKR8s6rG3scw4ToJUKHnqrtyH5SD6u
         z62oxZ1YZRioVRnylDm7G5OEk/Q7YDknOrH8p5iK0nu3cyPsLZf7YUPeHMvQJ6uGZE
         rdFTLx3WAQt9KifsbY2IzNviOcEDuVjvCi0O8mpAdKD8151+sbHbbT6W1JK3XdYZD3
         fthwPeLLhEjhQ==
Date:   Thu, 31 Mar 2022 09:20:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Eric Sandeen <esandeen@redhat.com>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH 2/5] mkfs: don't let internal logs consume more than 95%
 of an AG
Message-ID: <20220331162053.GN27690@magnolia>
References: <164738660248.3191861.2400129607830047696.stgit@magnolia>
 <164738661360.3191861.16773208450465120679.stgit@magnolia>
 <822cdfdc-358f-669e-d2db-31745643d614@redhat.com>
 <2023e153-06bc-81fb-e190-edd7a3f5f88e@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023e153-06bc-81fb-e190-edd7a3f5f88e@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 30, 2022 at 07:21:36PM -1000, Eric Sandeen wrote:
> On 3/16/22 8:50 AM, Eric Sandeen wrote:
> > On 3/15/22 6:23 PM, Darrick J. Wong wrote:
> >> From: Darrick J. Wong <djwong@kernel.org>
> >>
> >> Currently, we don't let an internal log consume every last block in an
> >> AG.  According to the comment, we're doing this to avoid tripping AGF
> >> verifiers if freeblks==0, but on a modern filesystem this isn't
> >> sufficient to avoid problems.  First, the per-AG reservations for
> >> reflink and rmap claim up to about 1.7% of each AG for btree expansion,
> > 
> > Hm, will that be a factor if the log consumes every last block in that
> > AG? Or is the problem that if we consume "most" blocks, that leaves the
> > possibility of reflink/rmap btree expansion subsequently failing because
> > we do have a little room for new allocations in that AG?
> > 
> > Or is it a problem right out of the gate because the per-ag reservations
> > collide with a maximal log before the filesystem is even in use?
> 
> Darrick, any comment on this? What did you actually run into that prompted
> this change?

Oops, sorry, forgot to reply to this.

The per-AG reservations shouldn't be a problem on a modern kernel
because we assume an internal log never moves or grows, so we only need
to account for rmap/refcount btree expansions to cover space used
elsewhere in the AG.  That said, *one* block is cutting it really close.

Also, earlier kernels (4.9 era) weren't smart about that, though 4.9 is
dead according to gregkh and any kernel that says rmap/reflink are
experimental should not be used.

The problem that I saw is that you could trick the default calculations
into making the log to consume so much space that either (a) the root
directory gets allocated in the next AG, or if you were <cough>
formatting a single AG then mkfs just exits with a cryptic message about
ENOSPC.

It's fairly difficult to trigger this for a plain old block device, but
if mkfs thinks the disk has a gigantic stripe unit, it'll go around
putting the root directory at a much higher block number than is usual.
For the most part the "max_ag_blocks - 1" was actually fine, but not so
much for the case where the AG size is close to 64MB.

So in the end the 5% figure is still rather handwavy wormcanning.

> Still bugs me a little that a manually-sized log escapes this limit, and if
> it's needed for proper functioning, we should probably enforce it everywhere.

<nod> I guess the same limits ought to be applied to explicit logsize to
improve the "Well if it hurts don't do that!" experience. ;)

> I do understand that the existing code only validates auto-sized logs. But
> I don't want to sweep this under the rug, even if we choose to not fix it all
> right now.
> 
> Mostly looking for clarification on the what fails and how, with the current
> code.

<nod> I'll try to add a sample mkfs failure to the commit message.

--D

> 
> Thanks,
> -Eric
