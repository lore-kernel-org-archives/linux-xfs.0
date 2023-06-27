Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C55EB64DC
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jun 2023 22:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjF0WoY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jun 2023 18:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbjF0WoX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jun 2023 18:44:23 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C7A270C
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 15:44:19 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1b80bce2592so16111455ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 15:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687905858; x=1690497858;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=g90+Y120xVJH/76WmII9v5m9YQetqErv0aZddrO2Bg0=;
        b=Srrokoy6TV9fna0cedAhl3eE8SteCrgGDGXToW81aUCdRv3My2WPgrfDd/a+NwQ+qQ
         HprPj+gT1fGg5MmmkhpMT5Z8XoceucnyGTStAHykCa8oGpKZu7O7Oi3gL5zMtzaAh1O8
         CtzLj3ATtffKqGLh6poZx+ptMg8AgZDzBrTry6F19AHNk5KpB4kRUvyRzFlwZHv21urp
         f5X3wd0cOONOJmlwcLZl2zFBczgt+Cq9lyGHWa1zUWpaElWgiblpZikHLHZ6dQMRlovV
         Z8BhJazuBifmHMP3xBXsZsY+ip5mmaSnM/jPaJ/xFysM3jGhRiiny2KIIzGq7Pw8wRIc
         Y7Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687905858; x=1690497858;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g90+Y120xVJH/76WmII9v5m9YQetqErv0aZddrO2Bg0=;
        b=iWHWt0VDnSLEoOLLixURGCrE+G+AyDf6uBKp4173rFEhC9hoArT2ZqSlkuVzTFoeJH
         gSyucSiVMLlHKyuB/xNWrn0PKgJ2K96HghuK0aqI+Y4aBKsrTt6HuE9cxfmo0vYyPLB+
         DTKA2Ixy4EalpapcuHHShEWZsmngmpxC+g0kVvu/obJQ/FQmy63ZfGCssq4Gr+JyKpL+
         /sFrFk8jrRi2ehSU+HMOJPzds+2LWajEMGIe2lFjTQLllzvhCY/E1BRNf9rdFaDuFVBF
         zexE24EsG8Cm+bI5dz7ibjwTQQBA51ZwR+33aNowilzsQw4de1X1KOthRDa2teZJliZQ
         IHoA==
X-Gm-Message-State: AC+VfDzJ1ydg/ZUa4PLrimPNV69MZZS2ealdapIgCl6Fq4bNFNwwUTnT
        +7fGhpJ7POYiOCK4tvf3p2wTyySCHCosEX2eTiI=
X-Google-Smtp-Source: ACHHUZ7YyAq75ZsebxKitniZHC9BrbOu0Xknc+xTzY3v/ucjvMrf5jidE9JvqXuEqGZJm8QYy6uLcQ==
X-Received: by 2002:a17:903:1210:b0:1b0:2658:daf7 with SMTP id l16-20020a170903121000b001b02658daf7mr9133296plh.36.1687905858407;
        Tue, 27 Jun 2023 15:44:18 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-94-37.pa.vic.optusnet.com.au. [49.186.94.37])
        by smtp.gmail.com with ESMTPSA id u15-20020a17090341cf00b001b539640aa3sm6449831ple.283.2023.06.27.15.44.17
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 15:44:17 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qEHPz-00GzwP-0q
        for linux-xfs@vger.kernel.org;
        Wed, 28 Jun 2023 08:44:15 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qEHPy-009Zm4-2q
        for linux-xfs@vger.kernel.org;
        Wed, 28 Jun 2023 08:44:14 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/8 v3] xfs: various fixes for 6.5
Date:   Wed, 28 Jun 2023 08:44:04 +1000
Message-Id: <20230627224412.2242198-1-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

This is an update of the fixes patchset I sent here:

https://lore.kernel.org/linux-xfs/20230620002021.1038067-1-david@fromorbit.com/

There are new patches in the series - patch two is a new patch to
fix a potential issue in the non-blocking busy extent flush code
that Chandan noticed where btree block freeing could potentially
trip over busy extents and return -EAGAIN that isn't handled.
Patches 7 and 8 are new patches to this series; they are outstanding
standalone bug fixes that need review, so I've included them here,
too.

Original cover letter (with patch numbers updated) follows.

-Dave.

--

This is a wrap up of version 3 of all the fixes I have recently
pushed out for review.

The first patch fixes a AIL ordering problem identified when testing
patches 3-5 in this series. This patch only addresses the AIL ordering
problem that was found, it does not address any other corner cases
in intent recovery that may be exposed by patches 3-5.

Patches 3-5 allow partial handling of multi-extent EFIs during
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

Finally, patch 6 addresses journal geometry validation issues. It
makes all geometry mismatches hard failures for V4 and V5
filesystems, except for the log size being too small on V4
filesystems. This addresses the problem on V4 filesystems where we'd
fail to perform ithe remaining validation on the geometry once we'd
detected that the log was too small or too large.

This all passed fstests on v4 and v5 filesystems without
regressions.

---
Version 3:
- patch 2
  - new patch to defer block freeing for inobt and refcountbt
    blocks. This is to close a problem Chandan found during review
    of "xfs: don't block in busy flushing when freeing extents" in
    the V2 series.
- patch 7
  - pulled in AGF length bounds chekcing fixes patch.
  - rearranged slightly for better error discrimination
  - comments added
  - minor syntax and comment fixes
- patch 8
  - new bug fix for a memory leak regression discovered by Coverity
    during xfsprogs scan.

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

