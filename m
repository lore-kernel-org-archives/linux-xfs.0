Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EACDC74A5B
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Mar 2023 00:51:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjCRAvA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 20:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCRAu7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 20:50:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709A93B211
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 17:50:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1B3B60EDD
        for <linux-xfs@vger.kernel.org>; Sat, 18 Mar 2023 00:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44580C4339B;
        Sat, 18 Mar 2023 00:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679100657;
        bh=2FV0XyhIXTgLzSD7bX8I85lCcYjj3G1mQp3ezwfN9Ho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z5YTy/tVpxjzGrQQDUONFfuqCTY6ZpmhJMDxKOlHRsF88htW+aGkqstAIYhiBlNnL
         Eg5fiuVP2Zj3PNibPfDej4yj3dePDUy2UBtQAtI1vIe9kgf42ffl9zGM+pd3CJvFy9
         7w/Hg7LScUO88y0EwAIyFStbSQEIxu8swMBt37bUHL/94/395MnK21FhXZ17tfXaPA
         YPqSS7IgDl209F03glpDXdeJLJvR8pKbn2NLjTQBg39Ry/uJtdSuLy/kv3RMzkKZzx
         7MyP1IEvR7vVk1D/25iZXDS/OU/QsNSte6G3y2itUo22ZYbL/qIg/5vVU29ZSCWg/J
         Qwb9EeaRxoFlA==
Date:   Fri, 17 Mar 2023 17:50:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: test dir/attr hash when loading module
Message-ID: <20230318005056.GV11376@frogsfrogsfrogs>
References: <20230316164826.GM11376@frogsfrogsfrogs>
 <ZBUJEJ27tNWDmdxU@destitution>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBUJEJ27tNWDmdxU@destitution>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Mar 18, 2023 at 11:42:56AM +1100, Dave Chinner wrote:
> On Thu, Mar 16, 2023 at 09:48:26AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Back in the 6.2-rc1 days, Eric Whitney reported a fstests regression in
> > ext4 against generic/454.  The cause of this test failure was the
> > unfortunate combination of setting an xattr name containing UTF8 encoded
> > emoji, an xattr hash function that accepted a char pointer with no
> > explicit signedness, signed type extension of those chars to an int, and
> > the 6.2 build tools maintainers deciding to mandate -funsigned-char
> > across the board.  As a result, the ondisk extended attribute structure
> > written out by 6.1 and 6.2 were not the same.
> > 
> > This discrepancy, in fact, had been noticeable if a filesystem with such
> > an xattr were moved between any two architectures that don't employ the
> > same signedness of a raw "char" declaration.  The only reason anyone
> > noticed is that x86 gcc defaults to signed, and no such -funsigned-char
> > update was made to e2fsprogs, so e2fsck immediately started reporting
> > data corruption.
> > 
> > After a day and a half of discussing how to handle this use case (xattrs
> > with bit 7 set anywhere in the name) without breaking existing users,
> > Linus merged his own patch and didn't tell the mailing list.  None of
> > the developers noticed until AUTOSEL made an announcement.
> > 
> > In the end, this problem could have been detected much earlier if there
> > had been any useful tests of hash function(s) in use inside ext4 to make
> > sure that they always produce the same outputs given the same inputs.
> > 
> > The XFS dirent/xattr name hash takes a uint8_t*, so I don't think it's
> > vulnerable to this problem.  However, let's avoid all this drama by
> > adding our own self test to check that the da hash produces the same
> > outputs for a static pile of inputs on various platforms.  This will be
> > followed up in xfsprogs with a similar patch.
> > 
> > Link: https://lore.kernel.org/linux-ext4/Y8bpkm3jA3bDm3eL@debian-BULLSEYE-live-builder-AMD64/
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> I'm going to trust that your binary tables exercise the hash in the
> manner needed because I don't have time right now to manually
> decode it. With that caveat, everything else looks fine.

Yep.  The kernel and userspace use the same 4k buffer of arbitrary
bytes, and the test tables are identical.  I don't know if the dahash
function is *correct* mathematically speaking, but at least this will
demonstrate consistency in behavior between the kernel and userspace.

--D

> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> -- 
> Dave Chinner
> david@fromorbit.com
