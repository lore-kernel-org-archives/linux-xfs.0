Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFD2AEB64DB
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jun 2023 01:42:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237503AbjFOBmu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jun 2023 21:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbjFOBms (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jun 2023 21:42:48 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48EA02688
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jun 2023 18:42:15 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-6664a9f0b10so979977b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jun 2023 18:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686793334; x=1689385334;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lYNS5OtVWVvdz1yZzys2gygGXxja+zGQ3N2vKtgidpM=;
        b=5m6HLSOfcYdxns44sfFmFudaSUMQ9a2zxxEs9OgvUr1EknJE0WclW6149EJmW/PWxe
         Vyg1J0C0LwHFye2eMz3+woJJA1VYDt47Km0+Z7SnH8WRsTNxoZ33E7m3z979HScv9xTs
         6nmJ1+nfDPvXs8WTXXBLZb6DhYUHjsyueIP8H6NPGjRd7CWZ5WuEhNCnce46+bhswKZ4
         8SuHcSj6LOqrjcdg5V8XFA6CfqwV1alfcCXLHatinMAxtZmXdHQs0xKvqxJQKWsySVF1
         UMdc7vbPy/2NlrSMF/QhSapAdcR+rLJ7TrrDS8ZGlSkhNaChiDvRmWTTWlnG54odskPL
         inFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686793334; x=1689385334;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lYNS5OtVWVvdz1yZzys2gygGXxja+zGQ3N2vKtgidpM=;
        b=fecB0vcpTpotiUTK6k4T7a6bcyqkwS3V6nnDnvGop7biNasrdza9AzK9tCEVzFeJIp
         hZP3Z4375KQ9eaOZMit5z+eOkIOVt2fDH1DVLtedEAEZ9FHYjsHJQp5IMIQl1zceQGFe
         XBAkG1MpD9G0qSZV4QZXiUlA3uEw02660esjvl+Pwy6t3ERf5X307zQWIafexOuIM+N2
         g3w1rhC49p+Haqri18M/OWz7bfKAThuZ3fSKlrXqeHguuSwJ7WooRfLQiz87EaJ78cWN
         AASLup3kOVMEFS1PF1hU4LU3p3jrpdoEuUVa73f29uXFpKCQDTBMwiuiP6jhisusIyT/
         lO8w==
X-Gm-Message-State: AC+VfDw/4yyJpdNhPv52IOoNemfm4n4GQQIEbXutwm64V2Z1YpqXKMY2
        dbAFERKu/zrIeFVEuuEtOEY9L74HvKC0QmJtKV8=
X-Google-Smtp-Source: ACHHUZ5/U7LBoHHRTMxTSj31S7VobXhmHMjoz/4r9TXT9p9YoDZ/2Bvy0mb0mdoCt9YhLk+r4soKYw==
X-Received: by 2002:a05:6a00:ccb:b0:641:d9b:a444 with SMTP id b11-20020a056a000ccb00b006410d9ba444mr4119301pfv.31.1686793334001;
        Wed, 14 Jun 2023 18:42:14 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id u66-20020a637945000000b0051b36aee4f6sm11544285pgc.83.2023.06.14.18.42.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 18:42:12 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1q9c01-00BtRb-2s;
        Thu, 15 Jun 2023 11:42:09 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1q9c01-00Dkls-1h;
        Thu, 15 Jun 2023 11:42:09 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     chandanrlinux@gmail.com, wen.gang.wang@oracle.com
Subject: [PATCH 0/3] xfs: fix xfs_extent_busy_flush() deadlock in EFI processing
Date:   Thu, 15 Jun 2023 11:41:58 +1000
Message-Id: <20230615014201.3171380-1-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

This patchset is largely a rework of the patch that Wengang posted
here:

https://lore.kernel.org/linux-xfs/20230519171829.4108-1-wen.gang.wang@oracle.com/

Review has run aground because I simply don't have the time to
explain every deep, subtle corner case on every issue that is raised
before progress can be made fixing this issue. Indeed, this is the
second attempt to get this bug fixed that has run aground like this.

Hence I've decided that it's less time and effort to just take what
we have, split it, clean it up, fixed it up, remove all the
unnecessary bits and run it through testing and push it back out for
further review.

I split the alloc flags out as a separate variable that is passed
down the stack; I renamed them all "alloc_flags" so that it's clear
that the flags being used and passed between the functions are the
XFS_ALLOC_FLAG* flag values. If we want to, it will now be trivial
to pull these back into the struct xfs_alloc_arg if we so desire -
there is no mix-and-match of args->flags and function paramter flags
to confuse the issue as was in the original patch.

The changes to xfs_extent_busy_flush() mean that it can now return
-EFSCORRUPTED or -EIO from xfs_log_force(), not just -EAGAIN to
indicate the transaction must be committed before the allocation is
retried. This has been exercised by recoveryloop testing and it
appears that the new corruption/error detection conditions do not
introduce any new failures.

Cheers,

Dave.

