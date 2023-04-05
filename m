Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B997C7619A
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Apr 2023 17:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbjDERKf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 13:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233704AbjDERKa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 13:10:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8A16191
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 10:10:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A0DC63FE6
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 17:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE574C433EF;
        Wed,  5 Apr 2023 17:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680714626;
        bh=2P/u4IHR2BRHLPfUYFwtL1Cq2xIOdlWD448o93jExs8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zg5sHEM1ArUjkhwFNFOxPCnW7t4W56AGiOHFlGZjQACBpgdGvf6vcWEBg6ihcU9b+
         KxkO9Xq0YoLyHwwTkByz9uxLY4r9ctFwbX5OIUV7LV6gpVs4osHSGhnYy3LIKXnyRI
         dTghax/OxeeaprEebJhd5tY1sBRmZf+4mNxnKQAS8wSRujlLc+dBzj99KWf/7fYtey
         10jQvnwIovrelCyNisgL0gB+7jtwxYhI6PX+f9TPwSIBgtA4Jw75OYE+KP+BPfHJ/N
         CFgSd/PB0PxS+U9ErajCyYmOVSWVPjLyRHzVJKt5N8FjZg7l4t8QtICug/YFGHx+gq
         LJNt+K273VHXw==
Date:   Wed, 5 Apr 2023 10:10:26 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/3] xfs: stabilize the tolower function used for
 ascii-ci dir hash computation
Message-ID: <20230405171026.GH303486@frogsfrogsfrogs>
References: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs>
 <168062802637.174368.12108206682992075671.stgit@frogsfrogsfrogs>
 <CAHk-=whe9kmyMojhse3cZ-zpHPfvGf_bA=PzNfuV0t+F5S1JxA@mail.gmail.com>
 <20230404183214.GG109974@frogsfrogsfrogs>
 <ZC0RaOeTFtCxFfhx@infradead.org>
 <20230405154022.GF303486@frogsfrogsfrogs>
 <ZC2W6jZ1LI12swSY@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZC2W6jZ1LI12swSY@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 05, 2023 at 08:42:34AM -0700, Christoph Hellwig wrote:
> On Wed, Apr 05, 2023 at 08:40:22AM -0700, Darrick J. Wong wrote:
> > <shrug> Welllll... if someone presents a strong case for adopting the
> > utf8 casefolding feature that f2fs and ext4 added some ways back, I
> > could be persuaded to import that, bugs and all, into XFS.  However,
> > given all the weird problems I've uncovered with "ascii"-ci, I'm going
> > to be very hardnosed about adding test cases and making sure /all/ the
> > tooling works properly.
> 
> You'll love this paper:
> 
> https://www.usenix.org/conference/fast23/presentation/basu

I know.

I stick to my earlier statements about "I wouldn't ever enable this
feature on any computer I use..." and "...not a tarpit that I ever want
to visit in XFS."

At one point I had wired up xfs_scrub to complain about filenames that
map to the same casefolded utf8 names to warn syadmins that this could
be used in some sort of unicode casefolding attack.  I pushed it back on
my patch stack and ran it against /home today and got a bunch of stuff
like this from the kernel source tree:

Warning: inode 4187068442 (31/26318874): Case-folded Unicode name "ip6t_hl.h" in directory could be confused with "ip6t_HL.h". (unicrash.c line 614)
Warning: inode 4032422946 (30/5891106): Case-folded Unicode name "ipt_ecn.h" in directory could be confused with "ipt_ECN.h". (unicrash.c line 614)
Warning: inode 4032422946 (30/5891106): Case-folded Unicode name "ipt_ttl.h" in directory could be confused with "ipt_TTL.h". (unicrash.c line 614)
Warning: inode 2285477942 (17/3776566): Case-folded Unicode name "xt_hl.c" in directory could be confused with "xt_HL.c". (unicrash.c line 614)
Warning: inode 2285477942 (17/3776566): Case-folded Unicode name "xt_tcpmss.c" in directory could be confused with "xt_TCPMSS.c". (unicrash.c line 614)
Warning: inode 3627924489 (27/4045833): Case-folded Unicode name "xt_tcpmss.h" in directory could be confused with "xt_TCPMSS.h". (unicrash.c line 614)
Warning: inode 3763353714 (28/5257330): Case-folded Unicode name "ip6t_hl.h" in directory could be confused with "ip6t_HL.h". (unicrash.c line 614)
Warning: inode 3763353714 (28/5257330): Case-folded Unicode name ".ip6t_hl.h.cmd" in directory could be confused with ".ip6t_HL.h.cmd". (unicrash.c line 614)
Warning: inode 7042717 (0/7042717): Case-folded Unicode name ".ipt_ecn.h.cmd" in directory could be confused with ".ipt_ECN.h.cmd". (unicrash.c line 614)
Warning: inode 7042717 (0/7042717): Case-folded Unicode name ".ipt_ttl.h.cmd" in directory could be confused with ".ipt_TTL.h.cmd". (unicrash.c line 614)
Warning: inode 7042718 (0/7042718): Case-folded Unicode name "ip6t_hl.h" in directory could be confused with "ip6t_HL.h". (unicrash.c line 614)
Warning: inode 7042718 (0/7042718): Case-folded Unicode name ".ip6t_hl.h.cmd" in directory could be confused with ".ip6t_HL.h.cmd". (unicrash.c line 614)
Warning: inode 406880264 (3/4227080): Case-folded Unicode name "Z6.0+pooncelock+pooncelock+pombonce.litmus" in directory could be confused with "Z6.0+pooncelock+poonceLock+pombonce.litmus". (unicrash.c line 614)

Yuck.

I never sent this patch to linux-xfs because XFS doesn't do casefolding
so who cares.  The xtables stuff is easy to spot, but that last one took
some staring before I even figured out what was different between the
two names -- lock vs Lock.

--D
