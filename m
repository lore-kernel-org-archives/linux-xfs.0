Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 594E0C77B73
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Apr 2023 22:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbjDSWxi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Apr 2023 18:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232152AbjDSWxh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2023 18:53:37 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D8983E2
        for <linux-xfs@vger.kernel.org>; Wed, 19 Apr 2023 15:53:05 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-63b4e5fdb1eso499057b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 19 Apr 2023 15:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1681944784; x=1684536784;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/KfgOhHQ4pmwO7hbfLpTnsh9JQsCH5LCFaO4vHTE8uU=;
        b=WApN/DC0u3UpdH5SUef1bkdvRajfI7MPv3J4pqAMe+jP7Y2XgWHgaUL7ZjaLD1NGL/
         9fvwYvM1lS/15vwkzZfyFPrDcvZJzUFjcyT5gLEFjt2/Oj8Qo/nX4AUlaGffq1eWpEy4
         Jm6jo7SrfIyR8JUCN69qxFdzoU9bW1lMi1Fis++5+NK1QYOaXZBMrsCNmHofcAHcKhIp
         kmsDp9eSLadu7aeAU7x33f78NVdahICHiVXCjrTfI860DMZVksx74ApeyaOWS0UhhNBe
         js9gRZh7LgrerTVngL830pwh9A58CXHVKP0RVzIoli+s7EJdhSml+X4ytxJyqVJFVyDS
         Zohw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681944784; x=1684536784;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/KfgOhHQ4pmwO7hbfLpTnsh9JQsCH5LCFaO4vHTE8uU=;
        b=hCjxYQWqhutKxZGiIrRhYoO3dtZSJbQmOkkNTwgVPhclovXIPihr4vNHBd/wUB7Iw1
         qfjH7eC9pbi2ijWta3s8D6D6ciOWjx25os1fr/p7uGvpq53GUGe3Z3rN29BxJFn50bJM
         B6jrI7UWXzdqipsOb6n6Z8Yq/5p+RFacJUfbFlHMmu69sSKSvMFCEFm/3MBgTnohYYkQ
         otxHvYCdgAGKrxKNwJ2luNJjBWSE1N2faabVkCjWBhEZUNiGKv6VVHOQMuQlpXGpQySM
         pafMZ8BSJfZsafBPhClkI2hG3SLF/LUyYfT35mPtYUHvjyllMAQApDXKbHurqzpfyVV7
         mn4g==
X-Gm-Message-State: AAQBX9cIGYNe6uw5hydEORcgaBj1MRMXeJW0IZKBEE89XHSlx36kw8gj
        QQTWykCGn40PB004e5g6pbKf4XW8CddqcdY3n/w=
X-Google-Smtp-Source: AKy350bguc0d3X4D5mpwR4U2uLCVSp2MA6qPtVoKAgQbRTj1GHrRBQ8vJm+d54y8aipewbl1vYXfEQ==
X-Received: by 2002:a05:6a20:8410:b0:f1:996f:845c with SMTP id c16-20020a056a20841000b000f1996f845cmr103284pzd.47.1681944783834;
        Wed, 19 Apr 2023 15:53:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id u24-20020aa78498000000b0063d47bfcdd5sm1839742pfn.111.2023.04.19.15.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:53:03 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ppGfc-005QpB-0E; Thu, 20 Apr 2023 08:53:00 +1000
Date:   Thu, 20 Apr 2023 08:52:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org
Subject: [ANNOUNCE] xfs: for-next branch updated to 71deb8a5658c
Message-ID: <20230419225259.GV3223426@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

I've just updated the for-next branch of the linux-xfs kernel tree.
This contains a couple of minor fixes, one for duplicate header
include warnings and another to fix a documentation format warning.

Assuming the tha merge window for 6.4 opens next week, this will
probably be the last update for the 6.4 merge window. Of course, if
there's a rash of sudden bug fixes, that may vhange, but for now I
think the tree is largely settled.

-Dave.

----------------------------------------------------------------

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next

  Head commit: 71deb8a5658c592ccad5ededb2ceffef6fcbba5f

  xfs: Extend table marker on deprecated mount options table (2023-04-20 08:18:36 +1000)

----------------------------------------------------------------
Bagas Sanjaya (1):
      xfs: Extend table marker on deprecated mount options table

Dave Chinner (1):
      xfs: fix duplicate includes

 Documentation/admin-guide/xfs.rst | 6 +++---
 fs/xfs/scrub/refcount.c           | 4 +---
 2 files changed, 4 insertions(+), 6 deletions(-)

-- 
Dave Chinner
david@fromorbit.com
