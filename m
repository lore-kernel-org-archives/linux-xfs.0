Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA28C77B6F
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 15:35:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjDKPfu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 11:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDKPft (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 11:35:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED6B19A8
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 08:35:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 424E5611F8
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 15:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F48CC433EF;
        Tue, 11 Apr 2023 15:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681227346;
        bh=V0zqP/af8TyhYKCo4q2UYbiQPuOwvMWzo0Di/sIw3/0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VjhE6Y6Plnw8GgGcBtm3sIisM0opSraHtxHivwebiJI4dvjaODBoCXd/xTBV52pKo
         P3FrLjhfnAiB94WAItasoriG5vNH5m3iKv+AESUZZIkFaWOghGIt6v0XDKbIC0sEEp
         bqfG+GzfwBEdoRzl0hsYkVMqvxMUUKz9AckE+Nu0JTNGW38lnNWAnw8Yjx964UGeWF
         2wJ1zwRylsBsJC5c6woWXVJYG/w6g2amxemCY9pLdpxMuOsx49DJ/1uYdrm8b1AIcD
         /3NQILNi631EmC4p5aYKbXgKSC6Y4l1AkygB8FcV8x2Y9IBMM0MYpvNL+mZx5QvQKW
         8XkV3FOHAGKzw==
Date:   Tue, 11 Apr 2023 08:35:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 4/6] xfs_db: fix metadump name obfuscation for ascii-ci
 filesystems
Message-ID: <20230411153546.GH360889@frogsfrogsfrogs>
References: <168073977341.1656666.5994535770114245232.stgit@frogsfrogsfrogs>
 <168073979582.1656666.4211101901014947969.stgit@frogsfrogsfrogs>
 <ZDTpBtMlSsxRJjRh@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDTpBtMlSsxRJjRh@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 10, 2023 at 09:58:46PM -0700, Christoph Hellwig wrote:
> On Wed, Apr 05, 2023 at 05:09:55PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Now that we've stabilized the dirent hash function for ascii-ci
> > filesystems, adapt the metadump name obfuscation code to detect when
> > it's obfuscating a directory entry name on an ascii-ci filesystem and
> > spit out names that actually have the same hash.
> 
> Between the alloc use, the goto jumping back and the failure to
> obsfucate some names this really seems horribly ugly.  I could
> come up with ideas to fix some of that, but they'd be fairly invasive.

Given that it's rol7 and xoring, I'd love it if someone came up with a
gentler obfuscate_name() that at least tried to generate obfuscated
names that weren't full of control characters and other junk that make
ls output horrible.

Buuuut doing that requires a deep understanding of how the math works.
I think I've almost grokked it, but applied math has never been my
specialty.  Mark Adler's crc spoof looked promising if we ever follow
through on Dave's suggestion to change the dahash to crc32c, but that's
a whole different discussion.

> Is there any reason we need to support obsfucatation for ascii-ci,
> or could we just say we require "-o" to metadump ascii-ci file systems
> and not deal with this at all given that it never actually worked?

That would be simpler for metadump, yes.

I'm going to introduce a followup series that adds a new xfs_db command
to generate obfuscated filenames/attrs to exercise the dabtree hash
collision resolution code.  I should probably do that now, since I
already sent xfs/861 that uses it.

It wouldn't be the end of the world if hashcoll didn't work on asciici
filesystems, but that /would/ be a testing gap.

--D
