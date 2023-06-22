Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DA2EEB64D8
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jun 2023 03:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjFVDSQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Jun 2023 23:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjFVDSP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Jun 2023 23:18:15 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CDF1BCD
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 20:18:14 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-666eb03457cso3146276b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 20:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687403894; x=1689995894;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dn+blztEepJO0eLN5Did+wCXT/pMVqAP3bdHjU/KxaI=;
        b=30gpRfEsgP0D7uf5IusonlLeQj1Ieaqw3DqYN2nYlVhxTGm3H8RhuY2NsKmn+sVPZ/
         dR4MBICUcVAzuwUDO3E6RRhBOJ3uDWW6jO2/uFjiBZjUS5o+cAmets5mgaBk7Wu6MGxe
         bx6CqrQgThpQRWwhuMuA4C39KOT+uy9hVdmNRXrhgjwMlVZXl3ldYPTHl/z0gNiEFLBM
         KXGUevLujqRUlJCSmB+GqX+0UMHhX5uQQCLNbxWlGTFkj1MzzEX3k2FxkuWZ2SJj321Q
         qH8+uAIDjBs9rDq5zN9mfiiIki2F1ACifbywQ2dqiLR+xBqDWNNVT4Mw4GIORVQttEzW
         rG+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687403894; x=1689995894;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dn+blztEepJO0eLN5Did+wCXT/pMVqAP3bdHjU/KxaI=;
        b=k23QMTjdiaEaOBwJxW0NmoI72vpsQ1PsTSK8trVGFixbVMyeWjG7cteELrSMaGEkVV
         MWpZ/8Q7TxNRorFLlDq/FFJjAo8/97hB1H/QFhqs9tQ/hLmkHm43gX/1LXPlppZktgUw
         iFY4CmtD+KIXSse2urVIhaIMXtHxi27skcC8TkUQQ78v34g94ltem/WSyuTWKUokVU1W
         rJveDKEbvOrWeZYaIkUbdRhySn3Zp7roxUpgj0OBvH4JdaGplzP4y9eYxo/vNDBJcad5
         3Ajzu66dAlwnKs2FLVe/QpwPh0icsY1ecUw82EVOJFGrUiGhyRZtG54s1vmUEdJ3U/fL
         62fg==
X-Gm-Message-State: AC+VfDycwOoFbdfzU5FpCqjq62Ni744P/uSuwxqd4Ts9qXfIPqh1uOtg
        e9zZKS/1p9oT6YxE2QbT23m8MQ56sQZEPowOLso=
X-Google-Smtp-Source: ACHHUZ5jndVRLcjGqIMItHyVYKfQDaRutDgQ+cRfsKZ35gtlEnmk18LYvwkAHVfh9/ut5xdul4iUGw==
X-Received: by 2002:a05:6a00:2341:b0:66a:2967:c2fe with SMTP id j1-20020a056a00234100b0066a2967c2femr5902469pfj.6.1687403894100;
        Wed, 21 Jun 2023 20:18:14 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id bm17-20020a056a00321100b0063b675f01a5sm3673399pfb.11.2023.06.21.20.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jun 2023 20:18:13 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qCApm-00Egzx-2D;
        Thu, 22 Jun 2023 13:18:10 +1000
Date:   Thu, 22 Jun 2023 13:18:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v25.0 0/2] xfs: force rebuilding of metadata
Message-ID: <ZJO9chlV6ToCnGK1@dread.disaster.area>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
 <168506057570.3730125.9735079571472245559.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168506057570.3730125.9735079571472245559.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 25, 2023 at 05:29:42PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This patchset adds a new IFLAG to the scrub ioctl so that userspace can
> force a rebuild of an otherwise consistent piece of metadata.  This will
> eventually enable the use of online repair to relocate metadata during a
> filesystem reorganization (e.g. shrink).  For now, it facilitates stress
> testing of online repair without needing the debugging knobs to be
> enabled.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-force-rebuild
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-force-rebuild
> 
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-force-rebuild
> ---
>  fs/xfs/libxfs/xfs_fs.h |    6 +++++-
>  fs/xfs/scrub/common.h  |   12 ++++++++++++
>  fs/xfs/scrub/scrub.c   |   18 ++++++++++++------
>  fs/xfs/scrub/trace.h   |    3 ++-
>  4 files changed, 31 insertions(+), 8 deletions(-)

With the high flag bit changed to unsigned,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
