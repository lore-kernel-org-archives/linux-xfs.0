Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CDEC4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 04:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiKIE7K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 23:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiKIE7I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 23:59:08 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF4315A19
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 20:59:07 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id p21so16055574plr.7
        for <linux-xfs@vger.kernel.org>; Tue, 08 Nov 2022 20:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KYKyOjdNF+CNJTxSK9QBVZgj+1+/qswwvoinSoGBaSE=;
        b=BEJhQi2e/7Q0f8lFmz2rSCjKWX/wjNu/FSORP1RMXpUgBR2lLHeNrByiZd4gkW40CH
         UiLdDUGTMttJ4O7fbarOoEFoReikIcxpisCyR/kEe2Y4msJDIbcrf5raeLYBWA3WWmYS
         50QjoBytKn5DRMO8WJH9GbYefOPtPttWuIAVAcS8H9O3b75TuX95UvYxoXZlzMYO59n3
         wvx/byWBpS6upB/T4NGR/5NID0j6xvtQLg86Xdn10UTx/B6d5Msx5Tgwa9eCkRtoAcPA
         ZtcGJBd577uS/+djHgy3AKhyqAM4ub/7GllKbc5YIlfan9QFZT7ZvMnwfNI7dIS01QPt
         TckQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KYKyOjdNF+CNJTxSK9QBVZgj+1+/qswwvoinSoGBaSE=;
        b=PB+OPhVOhJTBbHu1SxAVkG5x1jdneSFmn1jusmaXKdFthFmNsfXOUsWINBF+T/8xZF
         pXyd++Sqf9YOfYReZB2JOn6ZYDLUb/GrHTzsj2p1OvoVb3KXheQKGPHiEQPQMHpQheH7
         rvccjHqb0R4TkKe8mFqVU5wqhMtEV0Ppaiupk/hk8AiQzfR5f8fJ9s6HAU/6je9l0bm0
         15DRdamuHxtrY5wpJRNqHzjZOJ/+85XsUAdKZYj7vUS0XJpAGmGAYzvAGhEL7qvAMh8G
         IX777al3p24QA0G6ohbiLDUKAymbDXhvTZ/2ftBas4Fla8gAyGNP71Y3e22aEc/z/T0n
         XsnA==
X-Gm-Message-State: ACrzQf2d45A/NnmK3mz+fmSO996iEIMoOFCfvNcXJtcQTS2x6harGTxY
        dExH2403VM3GpEdmZye89XmTUwlprT04wBjPALcFZ+Sy
X-Google-Smtp-Source: AMsMyM58aPnJJox7nvhKDVysjw4ER5BLtw8qPdsY8hto8SXy1KxHanKl3T0kDUBqUL8+bZ36fimThjBdM22VwMgNKTA=
X-Received: by 2002:a17:90b:3594:b0:213:bf67:4d50 with SMTP id
 mm20-20020a17090b359400b00213bf674d50mr57930349pjb.32.1667969946888; Tue, 08
 Nov 2022 20:59:06 -0800 (PST)
MIME-Version: 1.0
References: <CAG5wfU0E+y_gnfQLP4x2Ctan0Ts4d3frjVgZ9dt-xegVrucdXQ@mail.gmail.com>
In-Reply-To: <CAG5wfU0E+y_gnfQLP4x2Ctan0Ts4d3frjVgZ9dt-xegVrucdXQ@mail.gmail.com>
From:   Alexander Hartner <thahartner@gmail.com>
Date:   Wed, 9 Nov 2022 12:58:55 +0800
Message-ID: <CAG5wfU2p08ju-SbaRYMjuPXzzEXGneQzTTP56xYrWatO=NUS0g@mail.gmail.com>
Subject: Detecting disk failures on XFS
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We have dealing with a problem where a NVME drive fails every so
often. More than it really should. While we are trying to make sense
of the hardware issue, we are also looking at the recovery options.

Currently we are using Ubuntu 20.04 LTS on XFS with a single NVME
disk. If the disk fails the following error is reported.

Nov 6, 2022 @ 20:27:12.000    [1095930.104279] nvme nvme0: controller
is down; will reset: CSTS=0x3, PCI_STATUS=0x10
Nov 6, 2022 @ 20:27:12.000    [1095930.451711] nvme nvme0: 64/0/0
default/read/poll queues
Nov 6, 2022 @ 20:27:12.000    [1095930.453846] blk_update_request: I/O
error, dev nvme0n1, sector 34503744 op 0x1:(WRITE) flags 0x800
phys_seg 1 prio class 0

And the system becomes completely unresponsive.

I am looking for a solution to stop the system when this happens, so
the other nodes in our cluster can carry the work. However since the
system is unresponsive and the disk presumably in read-only mode we
stuck in a sort of zombie state, where the processes are still running
but don't have access to the disk. On EXT3/4 there is an option to
take the system down.

errors={continue|remount-ro|panic}
Define the behavior when an error is encountered.  (Either ignore
errors and just mark the filesystem erroneous and continue, or remount
the filesystem read-only, or panic and halt the system.)  The default
is set in the filesystem superblock, and can be changed using
tune2fs(8).

Is there an equivalent for XFS ? I didn't find anything similar on the
XFS man page.

Also any other suggestions to better handle this ?
