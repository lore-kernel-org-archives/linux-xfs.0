Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A7E0C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Nov 2023 18:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345358AbjKJSdq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Nov 2023 13:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345971AbjKJScu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Nov 2023 13:32:50 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E213F7DBD
        for <linux-xfs@vger.kernel.org>; Thu,  9 Nov 2023 22:51:29 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id 3f1490d57ef6-da0344eb3fdso1743913276.3
        for <linux-xfs@vger.kernel.org>; Thu, 09 Nov 2023 22:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1699599089; x=1700203889; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PZuNPkp5pvSL22XckYA+IGnaTuq+xQ2jH7SR/6KORzk=;
        b=0kCJE6tQcPLPouQ6ukegZw+WcVrKBm5iOf/gaM+HsT2pkl8dJ5gZzmbXdvJ3c5qHjc
         hcNIeewiXRwzCg7+bL5uyOEdF1oh47enrS6HzaBpSAEoyoXnVL2sVO7nw7Fyw81LM7BW
         MVmuoOWtcR8DzcGaqYCjVZ3MamoiXczUvo3Ay4f8mpe5zCaYM2KzpMyNyOdbtXA2S4Ts
         br/xBMyapHFpOddG2gGfpqeHGf1/v/cAkk7fh7A+enXgGdLo6wKcMgdLJjko1AXfzc7o
         zAWEO+la8yXCy3n7qMdsKi7RRqCHectUWZbbJhDjjKar79lq32q4RCiroI96yoJW9+RO
         8xEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699599089; x=1700203889;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PZuNPkp5pvSL22XckYA+IGnaTuq+xQ2jH7SR/6KORzk=;
        b=fJ5LoKY5pjABOn5rlWkF9ANp93mpZ+q2UNMZS9qMcQAbsjZlr4KY6Qj00TUWHDF+QC
         1yqPPcRnEj/Eug1YE3KgJwHavUkEktAg8zRItH2P/5Tg4Kewyu+dwwwjm2wFQaKDwYEP
         mF57D4VhCo8Vy08FbY7HKuRujbmyFYDLJzYvPx8HyE421uqh7rZzOgpowSpfCAqX/bVk
         eNc+Yk8OFpjkPPZHTmayVK5bC0Xs6H+g1LotnDHqWnNVG3KeXq+xrXKy6LBlAbOt/jGq
         bs8bQ0cQ2vb4q4jy5m9ofkt1sthegpBdBdw7sTnPZuvokxn/TPMidTa9QvK/1mG8Qq/6
         Q1Bg==
X-Gm-Message-State: AOJu0YyZKSXDuHbNse9vt4gFewbx9m90E1HNz5oqUBND5+IK3/DTYLfL
        9R6mZoQuiBxr0/hDOk65k110AZoSqJoUKoWmt3M=
X-Google-Smtp-Source: AGHT+IF1+MliPSNih26mB4oPEvVpRAZMUkkFeascIDvorwCuIuogjGqHCLCGunyqRJsw0hQGe1IfzQ==
X-Received: by 2002:a05:6871:458a:b0:1e9:b495:bd0 with SMTP id nl10-20020a056871458a00b001e9b4950bd0mr8099309oab.8.1699591506241;
        Thu, 09 Nov 2023 20:45:06 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id fi20-20020a056a00399400b006c4d0b53365sm630450pfb.88.2023.11.09.20.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Nov 2023 20:45:05 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1r1JOB-00AbtF-1A;
        Fri, 10 Nov 2023 15:45:03 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97-RC0)
        (envelope-from <dave@devoid.disaster.area>)
        id 1r1JOA-000000039JY-3mFb;
        Fri, 10 Nov 2023 15:45:02 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     zlang@redhat.com
Subject: [PATCH 0/2] xfs: fix recovery corruption on s390 w/ nrext64
Date:   Fri, 10 Nov 2023 15:33:12 +1100
Message-ID: <20231110044500.718022-1-david@fromorbit.com>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The following are two patches to fix the corruption bug that
Zorro recently recently reported on big endian platforms when
nrext64 is enabled.

It is caused by recovery zeroing a v2 inode field even on v3 inodes.
Before nrext64, this wasn't an issue because the field in v3 inodes
was just padding (i.e. zeroes) and so writing zero to part of it was
never noticed. However, nrext64 uses this field for the 64 bit data
fork extent count, so zeroing part of it becomes a problem.

The zeroing is done to the xfs_log_dinode, which is held in host
format. Because of the layout of this field, on little endian
machines the di_flush_iter field overlaps the high 16 bits of
di_big_nextents, and so we didn't notice that recovery was
overwriting the the high bits of the extent count because it's
always going to be zero bytes (needs to go over 2^48 extents before
we'd notice) in testing contexts.

However, on big endian machines, the di_flushiter field overlays the
lower 16 bits of the di_big_extents field, and so zeroing
di_flushiter essentially rounds it down to the nearest 64k. For
typical testing contexts, that's effectively zeroing the extent
count.

The fix is two parts. The first patch adds detection of this
specific corruption to the xfs_dinode verifier, and adds a call to
the verifier after recovery has recovered the inode. This catches
corruptions at recovery time, rather than silently writing them back
and not noticing them until the inode is re-read from disk at
runtime.

The second patch fixes the recovery bug. It simply moves the
resetting of the di_flushiter field into the v2 inode specific
flushiter handling branch. That's always been wrong (i.e. since v3
inodes were introduced) but it hasn't mattered until now, so it
marked as fixing the introduction of the nrext64 feature....

-Dave.

