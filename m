Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B9EC4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Nov 2022 21:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234769AbiKQVg4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Nov 2022 16:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiKQVgy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2022 16:36:54 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4E5C13
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 13:36:53 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 136so3276902pga.1
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 13:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aey2YA9Wxv099mJZe3QO4Iedu/+ayidOgLWrrXYQ8U4=;
        b=GWvtXFyYd6Geow5HM40xhPAE40y7wK6YzEI0W8+EVaakcb5oXXApUSFwPNcuEBN3RZ
         dqf4q65FF8QnRtdqBkirWyBQGns61jNLTaiuXnbwcmhlG0xwXYa5XrPCm/WICSgawd1D
         kTi/AvSwYgk6Hw1lNm2gsM4XvGmIafUgCYi1wQj5Zavvg2PPA0m5Y92xLp94K4Ih+sHi
         lRR0Ldc7kNaFyCIEq7GPj+zawjEQ06wMa+pQ/6Y7XTpRMMPdqwtdA30wQZdIweQYVrAj
         2b8O6omsooDpPxbnxzAv0X1nXhZsMciDkioFJ+PtkdhPYtvWo4E2vUCkhWJ20qKgClAG
         6nwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aey2YA9Wxv099mJZe3QO4Iedu/+ayidOgLWrrXYQ8U4=;
        b=FB9dDHvBblCXz+QyzCNjsVc+YmQIlLWLpX6aFf6y59XXX98lhCh40wqpOilF6/DO8q
         AzdGXce28Mfj16dDhQOGajLKbXZecJ5AR4gxm12eyI2SrSSOILro9jGVVQGFWvifd/Wy
         n0at7Z/W6NV2FO2bBaErBINBbc39oEF8pgIx1XMnu1kIXyrXGon2UQAvcNDKeF5hW0h1
         HMkOaYUtCkvjS+NRaqKxqGWBH3iMToe6iK8XbBdO3/FTrepfHWuG6zVbMWYoCa8jvpWd
         +x+gFmMBk59gHDj460h7yFnqoEedBGg4WnNjj2Zh1fEgNhlz/sa1WrGFVWplxmAlMK28
         xIFw==
X-Gm-Message-State: ANoB5pmjoU0qPN8SzwvjPFTdgbhsP5upPT96rSYqCcl5HGBJ7f8+jjjg
        v+w+T5MGJ92631tOuBKcodFLWw==
X-Google-Smtp-Source: AA0mqf7yraDxC5Qf8PFbY3YC621ZNEgNz1JksSHfWMbhUjsSF1kuPJhKq2TB+lnliQzYGRimUBCmnw==
X-Received: by 2002:a63:d407:0:b0:476:e0fc:8d8a with SMTP id a7-20020a63d407000000b00476e0fc8d8amr3830648pgh.145.1668721013453;
        Thu, 17 Nov 2022 13:36:53 -0800 (PST)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id y129-20020a62ce87000000b0056bd737fdf3sm1624797pfg.123.2022.11.17.13.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 13:36:53 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ovmYy-00FRlu-L0; Fri, 18 Nov 2022 08:36:48 +1100
Date:   Fri, 18 Nov 2022 08:36:48 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: use iomap_valid method to detect stale cached
 iomaps
Message-ID: <20221117213648.GG3600936@dread.disaster.area>
References: <20221117055810.498014-1-david@fromorbit.com>
 <20221117055810.498014-9-david@fromorbit.com>
 <Y3aEfxus3Eem0ppe@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3aEfxus3Eem0ppe@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 17, 2022 at 10:59:11AM -0800, Darrick J. Wong wrote:
> On Thu, Nov 17, 2022 at 04:58:09PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>

[snip code, I'm on PTO for the next coupleof days so, just a quick
process answer here...]

> So the next question is -- how should we regression-test the
> revalidation schemes in the write and writeback paths?  Do you have
> something ready to go that supersedes what I built in patches 13-16 of
> https://lore.kernel.org/linux-xfs/166801781760.3992140.10078383339454429922.stgit@magnolia/T/#u

Short answer is no.

Longer answer is that I haven't needed to write new tests to
exercise the code added to fix the bug.

I've found that g/346 stresses the IOMAP_F_STALE path quite well
because it mixes racing unaligned sub-folio write() calls with mmap
write faults, often to the same folio. It's similar in nature to the
original reproducer in that it does racing concurrent ascending
offset unaligned sub-block writes to a single file. 

g/346 repeatedly found data corruptions (it's a data integrity test)
as a result of the dellalloc punch code doing the wrong thing with
1kB block size, as well as with 4kB block size when the mmap page
faults instatiated multi-page folios....

g269 and g/270 also seem to trigger IOMAP_F_STALE conditions quite
frequently - streaming writes at ENOSPC trigger with fsstress
running in the background executing sync() operations means
writeback is racing with the streaming writes all the time. These
tests exposed bugs that caused stale delalloc blocks to be left
behind by the delalloc punch code.

fsx also tripped over a couple of corruptions, too, when being
run with buffered writes. Because fsx is single threaded, this
implies that it was writeback that was triggering the IOMAP_F_STALE
write() invalidations....

So from a "exercise the IOMAP_F_STALE write() case causing iomap
invalidation, delalloc punching and continuing to complete the rest
of the write", I think we've got a fair bunch of existing tests that
cover both the "racing mmap dirties data in the punch range" and the
"writeback/racing mmap triggers extent changes so triggers
IOMAP_F_STALE" cases.

As for the specific data corruption reproducer, I haven't done
anything other than run the original regression test. I've been
using it as, well, a regression test. I haven't had a chance to look
at any of the other variants that have been written, because all the
actual development was done running "-g rw -g enospc" on 1kB block
size filesystems and repeatedly running g/346 and g/270 until they
passed tens of iterations in a row. I only ran the original
regression test to confirm that I hadn't broken the fix whilsts
getting all the fstests to pass....

> Please let me know what you're thinking.

I'll look at the other tests next week. Until then, I can't really
comment on them.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
