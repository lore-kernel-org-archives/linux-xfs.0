Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15738C77B7C
	for <linux-xfs@archiver.kernel.org>; Mon, 29 May 2023 00:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjE2AIe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 May 2023 20:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjE2AId (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 May 2023 20:08:33 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6814ABB
        for <linux-xfs@vger.kernel.org>; Sun, 28 May 2023 17:08:32 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-517bdc9e81dso1228480a12.1
        for <linux-xfs@vger.kernel.org>; Sun, 28 May 2023 17:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1685318912; x=1687910912;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=WcL9SwWbtJyhwYRHeP3A0GXCde/irn0th2cy2sQKnWk=;
        b=0JtSTTMystmf4Deea2phXnp+LFUBDnk4Lm9XLR2UYxz6U67BRpJEH4o0UaaFe4aWr9
         lBNiDghuuZf3gk6Q7V16gKdxUoO+Bk2UKNeQl882tUA8b3pu6QSWnhAEMKMxbqys9/Jg
         O35HgZoWuSJr0jk6Jj6ZdwnKeouQ7ly1kBr7KUdO93cImVRVlrLIjOwiGAB0MFn0ySko
         pzw7uQwnbDUGVmyPlb1XZSTsdBRrsd75igkJ/Qc9lffw5vRzMvCbiDHQcq1cCtiaK2j0
         N0TOPmQjfTsD7GBr4hH/3I33VC+smjLGHSCrXgayxvRkJVqO4oXhTnQvUGMMnkeqzzZY
         epRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685318912; x=1687910912;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WcL9SwWbtJyhwYRHeP3A0GXCde/irn0th2cy2sQKnWk=;
        b=hjEfqQhISPR7uxttu2Rrv5y8YH2ClOLNDd4fQmshsWq+SSrbjQ5iOQPTEhT3pFshkd
         Onq66JG0yo03pJYKdZ6kgVnCG8hjkeu8uVtLUfY1E/vLMyMMJaCoe2Qa4vkHKaNTsN1q
         n2zJMiftDVIfOSarlTczLVeenrUxQw/YWyeA4vfdE/rDFGRnn6oawcJ6v3S58Jm1s8Mg
         SsJi+QOANG2hSz9/k2gzeNii88JvcGCyfuc/W82OuStEiuqExo/CHXGWkAW8yh2nZ22V
         HdTtqqs85lN0/ho4mNA8uNCzyfqnV0tXiW8TJpAsQ8NpNUHvQmnyoUr1YKfAu2IcC5Yx
         Kc1w==
X-Gm-Message-State: AC+VfDz0vWFgeVfjduCr1V0yFFYEGaqym6hTeo1jFnfxo11V79LDudUU
        SIEQgxiBr2lXRxLOCehQxoVSozn6CchXwGlDO8E=
X-Google-Smtp-Source: ACHHUZ6xBcXtQ1J4VPWKza9VzZBkU9IrQ0iHIx6cEm1OdRVeoE6Q2X8yay10X+WY09jwkFVHVrAXVw==
X-Received: by 2002:a17:903:1209:b0:1af:e2e2:2bd9 with SMTP id l9-20020a170903120900b001afe2e22bd9mr10576433plh.17.1685318911816;
        Sun, 28 May 2023 17:08:31 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id s16-20020a170902989000b001a96a6877fdsm6795907plp.3.2023.05.28.17.08.30
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 17:08:31 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1q3QR2-00575v-2R
        for linux-xfs@vger.kernel.org;
        Mon, 29 May 2023 10:08:28 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1q3QR2-00A6VP-1A
        for linux-xfs@vger.kernel.org;
        Mon, 29 May 2023 10:08:28 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/3] xfs: improve AGF/AGFL verification
Date:   Mon, 29 May 2023 10:08:22 +1000
Message-Id: <20230529000825.2325477-1-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Folks,

This set of patches is a result of a recent syzkaller bug report on
v4 filesystems. It tripped over a corrupt AGFL count field in the
AGF, but the failure didn't manifest until a crash processing extent
free operations.

It turns out the crash was due to deferred AGFL freeing being passed
a NULLAGBNO as the block to free - this resulted in an invalid
filesystem block value which translated to an invalid AGNO which
then failed a perag lookup in the defered extent freeing code.

While the oops was a result of a change in the 6.4-rc1 merge window,
this is not the cause of the problem - the problem has always been
there for V4 filesystems. However, V5 filesystems would have
detected this specific corruption and would not have failed at all.
There are other failures to detect bad extent ranges being
freed so the v5 code needs improvement, too.

The V5 verification is not done in the AGF/AGFL verifiers.
It is deferred to initialising the perag from the AGF after it has
been read from disk and the verifiers have been run. It is not
documented in the code that the verifiers intentionally don't check
free list indexes, even though they could in most situations.

The verification for v5 filesystems was introduced back when we
discovered that there was an issue with the on-disk sizing of the v5
AGFL header. Code was added to detect the mismatch at runtime
instead of in the verifier so that it could be corrected without
shutting down the filesystem. It does so by resetting the AGFL
indexes and the AGFL in the first transaction that needs to fix the
free list. The old contents of the AGFL are leaked, but the system
continues to function without any further issues.

For some reason, this verification was not extented to v4
filesystems, even though it is still necessary to catch the same
corruptions on V4 filesystems. The first patch in the series simply
runs the existing v5 AGFL index verification on v4 filesystems and
triggers the AGFL reset code in the same way. This is all that is
necessary to "fix" the syzkaller reproducer.

However, one of the things the verification does not do is determine
if the agbno we pull from the AGFL in xfs_alloc_get_freelist() is
valid. The AGFL read verifier for V5 filesystems checks that each
entry is either in range or NULLAGBNO, but that isn't sufficient. V4
filesystems can't even do this, because for a long time mkfs didn't
initialise AGFLs to NULLAGBNO so can contain anything at all.

Hence we have to check the AGBNO we pull from the AGFL as being in a
valid range. NULLAGBNO is not valid - that's what triggered the oops
later on.  If we caught invalid AGBNOs in xfs_alloc_get_freelist()
and returned -EFSCORRUPTED, the system would not have crashed. The
second patch addresses this.

Finally, nothing checked that the fsbno we are adding to xefi for
deferred freeing is actually valid. This fsbno can come from any
other structure in the filesystem, and we magically trust that it is
valid despite many paths into this code not directly verifying the
extent we are asking to be freed is valid. Freeing a bogus extent
will, at best, result in a free space btree with a corrupt record in
it that we trip over later and shut down the filesystem. Worst
case, it will crash the system (as per the syzkaller report).

The third patch in the series hardens the extent freeing code to
reject bogus extent ranges at the time the code attempts to queue
them for freeing. It also adds error handling to all the code that
defers extent free operations so that the filesystem can be shut
down immediately from the context that holds the bad extent, rather
than having it get passes silently to later operations that end up
tripping over it.

IOWs, all three patches are needed to close the holes that lead to
the system crashing rather than detecting AGF/AGFL corruption and
handling it cleanly.

Cheers,

Dave.

