Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C546E8FDC1
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Oct 2023 00:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbjJDATz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Oct 2023 20:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbjJDATy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2023 20:19:54 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9B8A9
        for <linux-xfs@vger.kernel.org>; Tue,  3 Oct 2023 17:19:51 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id 46e09a7af769-6c4bf619b57so994917a34.1
        for <linux-xfs@vger.kernel.org>; Tue, 03 Oct 2023 17:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1696378790; x=1696983590; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oGonYtXNPVpEvKDrbEZN+W1IuiCzmh9Shoh0FnKPPso=;
        b=Wv/dzTC6YT0sEYVsLbISMjjxzz0XXTutyuoC/6iUISJy9NI9jNVywBnV8uhBdg/QkR
         gg6h5ebVkY5+4RNAtQ6BcSx4PfsyaxDaNs12u5mkXoH5CJ59PODd/h5U1PQWC2uOJI7V
         AX55+OtRQRlWroBIBg4horpFIyO+p5aV0FAiKU2zkQEatTR1z0LwFPy2xBgohRsE/Ksk
         +6bmIYt9FgM56P+adqrytZ5k90LIbzMH6EWVWynDNQFNyoQcB2FY3RgC2s03arIcrIUy
         qmMrlOSxSNvEoLGAeF143mHHofShhKs88qAZE4f94MY0V1g8fNyoU4vnxiSc9j+AMA/H
         srwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696378790; x=1696983590;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oGonYtXNPVpEvKDrbEZN+W1IuiCzmh9Shoh0FnKPPso=;
        b=czNQ35j+9vt4LcIB7m9W8uXGXdt7jQmHzwgBqfwZes274sgm0BtAv2phBK1nvcwF/6
         P6OKAWgIZs22HnzOb6ef8hBVbhcgKQxOBBqPqHqHdMmNhuuxGjuKW8QbVj5sJM0uJUc3
         DRNXrV4s2VJ6/aKmc0tbpyhgiEf0rsgMbijclwECLcJkYCi2FrEFrakvniQdMUkm5wVL
         luE6vB+g/FJ7h4hkeJVxVmHGrX3F9smG+vW7dEvAuedFflgVObYjEAfuUvi8PL+1XNFd
         YJ4QqwCFjbBmaNiBa6jcuaJJcr3mA1wHQObne1dAwJdegiDCGLcDl00uhU/Du2JQ3PiK
         PcPw==
X-Gm-Message-State: AOJu0YyZjj/io2IWG13aHegIpqV8AIxWvP0HK04huUcOZ7N5FmnvcoSk
        tNCX4lsPqY5ilEJz735D3tJ01Z8rofvxRwXuF40=
X-Google-Smtp-Source: AGHT+IE3OTR0mXlefIhj1rzUVvkfsAePlhvxrdnV3Y5AiD2eDEaxKbimLXcAU5X5ztOJ2qmdx/ANAg==
X-Received: by 2002:a05:6830:1252:b0:6c4:d06f:89bd with SMTP id s18-20020a056830125200b006c4d06f89bdmr831694otp.21.1696378790618;
        Tue, 03 Oct 2023 17:19:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id x29-20020a63b21d000000b00563ea47c948sm1964911pge.53.2023.10.03.17.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 17:19:49 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qnpc9-0097My-2o;
        Wed, 04 Oct 2023 11:19:45 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97-RC0)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qnpc9-00000001Tqy-2O8i;
        Wed, 04 Oct 2023 11:19:45 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     john.g.garry@oracle.com
Subject: [RFC PATCH 0/9] xfs: push perags further into allocation routines
Date:   Wed,  4 Oct 2023 11:19:34 +1100
Message-Id: <20231004001943.349265-1-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This series continues the work towards making shrinking a filesystem
possible.  We need to be able to stop operations from taking place
on AGs that need to be removed by a shrink, so before shrink can be
implemented we need to have the infrastructure in place to prevent
incursion into AGs that are going to be, or are in the process, of
being removed from active duty.

The focus of this is making operations that depend on access to AGs
use the perag to access and pin the AG in active use, thereby
creating a barrier we can use to delay shrink until all active uses
of an AG have been drained and new uses are prevented.

The previous round of allocator changes pushed per-ags mostly into
the core of the allocator, but it left some rough edges where
allocation routine may or may not be called with perags already
held. This series continues the work on driving the perag further
outwards into the bmap and individual allocation layers to clean up
these warts.

The bmap allocators have some interesting complexities. For example,
they might attempt exact block allocation before attempting aligned
allocation, and then in some cases want to attempt aligned
allocation anywhere in the filesytsem instead of in the same AG as
tehy do in other cases. Hence the code is somewhat complex as it
tries to handle all these different cases.

The first step in untangling it all is splitting the exact block EOF
case away from aligned allocation. If that fails, then we can
attempt a near block aligned allocation. The filestreams allocator
already does this with an attempt to allocate only in the same AG as
the EOF block, but the normal allocator does an "all AG near block"
scan. This latter cases starts with a "near block in the same AG"
pass, then tries any other AG, but it requires dropping the perag
before we start, hence doesn't provide any guarantee that we can
actually get the same start AG again....

This separation then exposes the cases where we should be doing
aligned allocation but we don't or we attempt aligned allocation
when we know it can't succeed. There are several small changes to
take this sort of thing into account when selecting the initial AG
to allocate from.

With that, we then push the perag management out into the intial AG
selection code, thereby guaranteeing that we hold the selected AG
until we've failed all the AG sepcific allocation attempts the
policy defines.

Given that we now largely guarantee we select an AG with enough
space for the initial aligned allocation, there is no longer a need
to do an "all AGs" aligne allocation attempt. We know it can be done
in the selected AG, so failure should be very rare and this allows
us to use the same initial single AG EOF/aligned allocation logic
for both allocation policies.

This then allows us to move to {agno,agbno} based allocation
targets, rather than fsblock based targets. It also means that we
always call xfs_alloc_vextent_exact_bno() with a perag held, so we
can get rid of the conditional perag code in that function. This
makes _near_bno() and _exact_bno() essentially identical except for
the allocation function they call, so they can be collapsed into a
common helper.

And with all this, we now have the APIs simplified to the point
where we can change how allocation failure is signalled. Rather than
having the intenral AG allocators returning success with
arags->agbno == NULLAGBLOCK to indication ENOSPC, and then having to
convert that to returning success with args->fsblock == NULLFSBLOCK
to indicate allocation failure to the higher layers, we can convert
all the code to return -ENOSPC when allocation failure occurs.

This is intended to avoid the problems inherent in detecting
"successful allocation that failed" situation that lead to the data
corruption problem in the 6.3 cycle - if we fail to catch ENOSPC
explicitly now, the allocation will still return an error and fail.
Such a failure will likely result in a filesystem shutdown, which is
a *much* better failure behaviour than writing data to a random
location on the block device....

The end result is a slightly more efficient allocation path that
selects AGs at the highest level possible for initial allocation
attempts, uses ENOSPC errors to detect allocation failures, and only
uses AG iteration based allocation algorithms in the cases where the
initial targetted allocations fail. It also makes it much clearer
where we are doing stripe aligned allocations versus non-aligned
allocations.

This passes fstests and various data tests (e.g fio), but hasn't
been strenuously tested yet. I'm posting it because of the
forced-align functionality that has been talked about, and this
series makes it quite clear what "aligned allocation" currently
means and how that is quite different to what "force-align" is
intended to mean.


