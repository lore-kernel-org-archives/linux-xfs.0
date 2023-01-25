Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C445EC38142
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Jan 2023 01:53:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjAYBxy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Jan 2023 20:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjAYBxw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jan 2023 20:53:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC123B0DE
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 17:53:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CC5F7CE19A0
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2023 01:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F5BC433D2;
        Wed, 25 Jan 2023 01:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674611627;
        bh=hIzk0pxP7Fy40FaaueVZt3p79M5h49F9WXwmzTLrdoE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AhaNGKfa2PjZAjUUDPhViRHFp7Vx1YG63bXwiQIWRnIDWH2d3fWbnmrSZhRKZjuvr
         y1aCSDQdFoL3SDkIxEZlOO4azsuEFIhK9TvpdkDOMH87RjnuuVWB4ZVkO7rREOrojv
         R/CXSuk+m7y7m3m3NqZPBrYRYysTBWt0WIi20R/ojx7MhydmY/RyTG7FE9RK15r/fv
         2D70pCd/gngLRNo21gQBZ0jqyAJ0r1DBaZkwnUkwRjJtylITkCsxH39rGrwFNbaTb3
         qxYOkH2qDPMROQSNt0mfGZt90gM7fGMLlIgCjUa1xXOa13qkCcxH+/Ac1d1X7/k2Oj
         XDs6JXqzdrtuQ==
Date:   Tue, 24 Jan 2023 17:53:47 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Daan De Meyer <daan.j.demeyer@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: mkfs.xfs protofile and paths with spaces
Message-ID: <Y9CLq0vtmwIDUl92@magnolia>
References: <CAO8sHc=t1nnLrQDL26zxFA5MwjYHNWTg16tN0Hi+5=s49m5Xxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO8sHc=t1nnLrQDL26zxFA5MwjYHNWTg16tN0Hi+5=s49m5Xxg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 23, 2023 at 10:13:12PM +0100, Daan De Meyer wrote:
> Hi,
> 
> We're trying to use mkfs.xfs's "-p" protofile option for unprivileged
> population of XFS filesystems. However, the man page does not specify
> how to encode filenames with spaces in them. Spaces are used as the
> token delimiter so I was wondering if there's some way to escape
> filenames with spaces in them?

Spaces in filenames apparently weren't common when protofiles were
introduced in the Fourth Edition Unix in November 1973[1], so that
wasn't part of the specification for them:

    "The prototype file contains tokens separated by spaces or new
     lines."

The file format seems to have spread to other filesystems (minix, xenix,
afs, jfs, aix, etc.) without anybody adding support for spaces in
filenames.

One could make the argument that the protofile parsing code should
implicitly 's/\// /g' in the filename token since no Unix supports
slashes in directory entries, but that's not what people have been
doing for the past several decades.

At this point, 50 years later, it probably would make more sense to
clone the mke2fs -d functionality ("slurp up this directory tree") if
there's interest?  Admittedly, at this point it's so old that we ought
to rev the entire format.

[1] https://dspinellis.github.io/unix-v4man/v4man.pdf (page 274)
or https://man.cat-v.org/unix-6th/8/mkfs 

--D

> Cheers,
> 
> Daan De Meyer
