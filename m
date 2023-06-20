Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C653EB64D9
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jun 2023 00:20:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbjFTAU2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jun 2023 20:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjFTAU2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Jun 2023 20:20:28 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA48B4
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2023 17:20:26 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-54fdf8c79a3so1935256a12.3
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2023 17:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687220426; x=1689812426;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZtXvsDvnCqWOL6L895j1Fw5hBCHPlfk/C2F3bzGKDMc=;
        b=eCCmIuJVocfwtyxLgv2J2CAfgCZhCBbsCcMLYKWoHWUpKVTygZ6qZIT9XwrGP8Il9p
         87wg7d6BsOu4bofGJcwYhX0lMfMtODG7AdD1yc2JUgiOFY8a8uTFae5TefY5QRWwzn3K
         S1StwD2onoyE31wWT/ujZ37SkAcZg731qs1eK30J70ZoMxxvtWiR+7e5iQRl6GqansPM
         /7QBW9nIwJU6++NBnDK/9OyRsA7lRF5fjwh4tApl5xtUSz5gYO5rtXuo0VDpOLjLE4ee
         8J78vwzpNGbbfCo5FHt5WOLRpjn1TcDN8ksLuQYuTLQhSD3ggAUS048RIBo07fI0A538
         Goew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687220426; x=1689812426;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZtXvsDvnCqWOL6L895j1Fw5hBCHPlfk/C2F3bzGKDMc=;
        b=YDws0lMbljVUGRVvA9g402uFfYMtNB3D5lTHqMfJkqMiPEbfZOeGtMxn4GRpbS4sfA
         LO5b6jJzYbUxqNVehqTltyyXib4UpOJoLMPoc7c573tonGS3MZ2M3mTStgfvsGWKqc39
         2xBI2PvqbR0rrOVsxSqKQhv9ico7XeeY1BzrawLqEVwpPoQOukWJoiaJR4HUHmDG/tLG
         pOc+7dCJ870Gw3vhvEHe9bB5YyNDhpXLGbEFeB5sJySS0C0PTAAkFmvtu4IQcZ+nqW6t
         VUX6DOFR2jwDkSdMXtC8twe5nIgZrXzyeHox+fK4UOVvUF3a7D2MHvnuKytAyFOPKZLP
         pi5w==
X-Gm-Message-State: AC+VfDz+L8ihfpz3dsK+qYu/y3mErNg3obdageuazxAm58YjPq0MOxO2
        /RL6t+zB0zdpocU2SZ0IW9HVzTj7xeJvkO75GAk=
X-Google-Smtp-Source: ACHHUZ4rF0UmQxOHGS4eJOLMvd/92S5nixgCR9y5lYKg2+hxKtHQgiwjP98Qv8bIu3g16W1DgVdogg==
X-Received: by 2002:a17:90a:1ce:b0:25e:542d:acc with SMTP id 14-20020a17090a01ce00b0025e542d0accmr2028917pjd.8.1687220426255;
        Mon, 19 Jun 2023 17:20:26 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id 24-20020a17090a191800b002555689006esm6520936pjg.47.2023.06.19.17.20.25
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 17:20:25 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qBP6d-00Dqg4-0u
        for linux-xfs@vger.kernel.org;
        Tue, 20 Jun 2023 10:20:23 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qBP6c-004dlv-34
        for linux-xfs@vger.kernel.org;
        Tue, 20 Jun 2023 10:20:22 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/5 V2] xfs: various fixes
Date:   Tue, 20 Jun 2023 10:20:16 +1000
Message-Id: <20230620002021.1038067-1-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

This is a wrap up of version 2 of all the fixes I have recently
pushed out for review.

The first patch fixes a AIL ordering problem identified when testing
patches 2-4 in this series. This patch only addresses the AIL ordering
problem that was found, it does not address any other corner cases
in intent recovery that may be exposed by patches 2-4.

Patches 2-4 allow partial handling of multi-extent EFIs during
runtime operation and during journal recovery. This is needed as
we attempt to process all the extents in the EFI in a single
transaction and we can deadlock during AGFL fixup if the transaction
context holds the only free space in the AG in a busy extent.

This patchset uncovered a problem where log recovery would run off
the end of the list of intents to recover and into intents that
require deferred processing. This was caused by the ordering issue
fixed in patch 1.

This patchset does not attempt to address the end of intent recovery
detection issues - this raises other issues with the intent recovery
beyond loop termination. Solving those issues requires more thought,
and the problem can largely be avoided by the first patch in the
series. As it is, CUI recovery has been vulnerable to these intent
recovery loop termination issues for several years but we don't have
any evidence that systems have tripped over this so the urgency to
fix the loop termination fully isn't as high as fixing the AIL bulk
insertion ordering problem that exposed it.

Finally, patch 5 addresses journal geometry validation issues. It
makes all geometry mismatches hard failures for V4 and V5
filesystems, except for the log size being too small on V4
filesystems. This addresses the problem on V4 filesystems where we'd
fail to perform ithe remaining validation on the geometry once we'd
detected that the log was too small or too large.

This all passed fstests on v4 and v5 filesystems without
regressions.

-Dave.

---

Version 2:
- patch 1
  - rewritten commit message
- patch 2
  - uint32_t alloc_flag conversion pushed all the way down into
    xfs_extent_busy_flush
- patch 3
  - Updated comment for xfs_efd_from_efi()
  - fixed whitespace damage
  - check error return from xfs_free_extent_later()
- patch 5
  - update error message for max LSU size check
  - fix whitespace damage
  - clean up error handling in xfs_log_mount() changes


