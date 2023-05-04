Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A6F0C77B7C
	for <linux-xfs@archiver.kernel.org>; Thu,  4 May 2023 23:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjEDXcQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 May 2023 19:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjEDXcP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 May 2023 19:32:15 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F94312497
        for <linux-xfs@vger.kernel.org>; Thu,  4 May 2023 16:32:14 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1aae5c2423dso10662045ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 04 May 2023 16:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1683243133; x=1685835133;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E0ry31fx43wJCDWBVTDNSpnYwvvmIy+2sOkGExGQieU=;
        b=PWL4x/3i2HabexEqIPm0i1wNc2rgjVZoMPAkAx9LgMzI2fUMTNaADqmnGKaOMwBnmF
         +Ga63KvNxIOQI1RmH74PVTx8gjOiTClVK4UX7C8Loo1vB1MJfBMTicYov5dJJ+f42M2j
         ej5FrIwQmkAUKmQyMBPkz6g+632QSqopNSkf/4/6MERuhXvl64cdu4MGaMNRGgdQUXrx
         527Qcy3hgvhqZmoZVvXHL85F0CTkHPN6DGpJWNGLPBcNVq8YIaKmZD4z37LKCGgy/V95
         0RLJVoxTj2D9Zf7/yNrLEE2MMMJxj1IKgB7qPR5TjTVcFEQDArW0dAd9TYgSTrcIDoEo
         CPFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683243133; x=1685835133;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E0ry31fx43wJCDWBVTDNSpnYwvvmIy+2sOkGExGQieU=;
        b=IJyclCidmLGbZ/LjSKRpK6OrvTV4MZrzj5lKbNk/doeZ2DBMJaOsHpongjP+OWImuK
         1aK1g95oxcmNbZ+OO4uzRIZwvQHTlIp2ygButQJYQmOuUutqdMJ+KoeKY9RKULK/rMiY
         Cq4qFg1Ih2SS5LOHzbMXBiVaxTLzvTCJ2VezqBar7UfhXOGsJNK5iu5fon2WlzZC8SlC
         JKHsaxeRC/8C5Jd33tSn9+st99wcsSAaXF6EYpy7ANkVNP5CXvuBT0tEFDKtv/O/mzRU
         YBoqAjnV3Zs/bwcHcSiuJHnJx9nNbIFG05Zn2oUve8YnwGvfi0efls9vphnlW/u1TvJs
         eN8Q==
X-Gm-Message-State: AC+VfDxzveK4zcs5YqTi8PyKeb3iMrit3MnePp5sgtVucNPw9g5S/yZi
        /6Mg/1mCU3lD2/WGaRjpMeCLyYxLrGpenHC4PYc=
X-Google-Smtp-Source: ACHHUZ5vSjAg+GEHW0/yqaihUFeFbzoNVFe4OPZvLIN0CBDnhPHGlhesvj5Mqtc/L4b9yT81/gUkPg==
X-Received: by 2002:a17:902:e5c9:b0:1aa:fe23:a7f8 with SMTP id u9-20020a170902e5c900b001aafe23a7f8mr5775642plf.59.1683243133585;
        Thu, 04 May 2023 16:32:13 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id w1-20020a170902d70100b001a072aedec7sm110298ply.75.2023.05.04.16.32.12
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 16:32:12 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1puiQj-00BQox-M3
        for linux-xfs@vger.kernel.org; Fri, 05 May 2023 09:32:09 +1000
Date:   Fri, 5 May 2023 09:32:09 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUCE] xfs: for-next updated to 2254a7396a0c
Message-ID: <20230504233209.GK3223426@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

I just pushed out a new for-next branch to the xfs kernel tree
with Darrick's set of fixes for issues found since the merge window
opened. These address the inodegc UAF problems and some of the
issues found by testing stripe aligned filesystems. There is nothing
big here, and if nothign goes wrong after a few days in linux-next
I'll ask Linus to pull them next week.

Cheers,

Dave.

----------------------------------------------------------------

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next

  Head Commit: 2254a7396a0ca6309854948ee1c0a33fa4268cec

  xfs: fix xfs_inodegc_stop racing with mod_delayed_work (2023-05-02 09:16:14 +1000)

----------------------------------------------------------------
Darrick J. Wong (9):
      xfs: don't unconditionally null args->pag in xfs_bmap_btalloc_at_eof
      xfs: set bnobt/cntbt numrecs correctly when formatting new AGs
      xfs: flush dirty data and drain directios before scrubbing cow fork
      xfs: don't allocate into the data fork for an unshare request
      xfs: fix negative array access in xfs_getbmap
      xfs: explicitly specify cpu when forcing inodegc delayed work to run immediately
      xfs: check that per-cpu inodegc workers actually run on that cpu
      xfs: disable reaping in fscounters scrub
      xfs: fix xfs_inodegc_stop racing with mod_delayed_work

 fs/xfs/libxfs/xfs_ag.c    | 19 +++++++++----------
 fs/xfs/libxfs/xfs_bmap.c  |  5 +++--
 fs/xfs/scrub/bmap.c       |  4 ++--
 fs/xfs/scrub/common.c     | 26 --------------------------
 fs/xfs/scrub/common.h     |  2 --
 fs/xfs/scrub/fscounters.c | 13 ++++++-------
 fs/xfs/scrub/scrub.c      |  2 --
 fs/xfs/scrub/scrub.h      |  1 -
 fs/xfs/scrub/trace.h      |  1 -
 fs/xfs/xfs_bmap_util.c    |  4 +++-
 fs/xfs/xfs_icache.c       | 40 +++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_iomap.c        |  5 +++--
 fs/xfs/xfs_mount.h        |  3 +++
 fs/xfs/xfs_super.c        |  3 +++
 14 files changed, 65 insertions(+), 63 deletions(-)

-- 
Dave Chinner
david@fromorbit.com
