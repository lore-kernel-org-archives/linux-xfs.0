Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA341ECAAA1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 21:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236317AbiJ0V0e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 17:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236807AbiJ0V0d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 17:26:33 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917B65E54A
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 14:26:31 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id m6so3033228pfb.0
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 14:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j6K520hsmbBX0/Yy2ZJydJRhad3Iab9wdhbqFSbxqLo=;
        b=PBEfPyZuMX+6ZSZRXh2C0uuw5dhs4j9UiohLtFk6fHvjB2LjGut377jOaaZdbliJsv
         JLW8Pmf6EcQwQ9dVa35/xXq6n0KtUKpxQ/pYnGmwAzYbstRggIxqniJioaK8ukH0WeZD
         TLfii75gK7/4ewbVViEgAQ0IH4OW+VHc46KNNOFtzfAWZckbTuk82jpRSmlJu75yHbqC
         7/Rqz7sUJHndYwzniWkdWsqU4eXB9qaEazXd1S60bTsdpzQYUAQMomm1SM+oYbS4pFqs
         pG3YnGPuYUpnbTwA3MOy1KVuyibFNPKZ5AM3BDfr5HnKBu7B3xRKW4nVfB4nC+Bzo7Sz
         LA1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j6K520hsmbBX0/Yy2ZJydJRhad3Iab9wdhbqFSbxqLo=;
        b=qPTV3GmTt9hSij9iTlgnOguhDLwrB+1CzhiLthPSFBjzbogTO+mNtbfxGNhLV7C3kx
         tqxGcnHDmkPFMBGiSNRruI5t4yIEyAUflqws23QW8q0J3/eqkjxtC3tItsTK7GgxdZJT
         S0JsqO6edI6MU5vasaMH2sOrPqhWRnj3TOMfJPY02gLdfunt3MWCwt7EcQjkkZLS0h8a
         2iNjXZ622X/7ZFif+2FJmAaqUtMfByLvOlQLKId7etxtMLBultpmnLup48zEBl3QE+Ga
         XlYPxwc7k/wgwA1/zjqc68fLgdjSM5IcMiCDbONbyd1KmXMCC9WAwZWkjYXhkHQvwgIj
         EO9g==
X-Gm-Message-State: ACrzQf0ZaIsAxwoQuXyG1P4z7WL5yuIft8iYMsGdy4fqmvFgUmObC8Oj
        Van330u5fKYYNF6MzFRDvTwkwQ==
X-Google-Smtp-Source: AMsMyM7zG/L8K01gEQJFd5IWjFECKsHRCyN5VlWy/vs85YrPr2q6NHoBmfZUyxyv2RhcdXSKuWHzpA==
X-Received: by 2002:a63:85c6:0:b0:46e:ffdb:2e77 with SMTP id u189-20020a6385c6000000b0046effdb2e77mr20884218pgd.439.1666905991094;
        Thu, 27 Oct 2022 14:26:31 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id z7-20020a626507000000b00560bb4a57f7sm1639810pfb.179.2022.10.27.14.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 14:26:30 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ooAOS-0079zy-37; Fri, 28 Oct 2022 08:26:28 +1100
Date:   Fri, 28 Oct 2022 08:26:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2] xfs: fix incorrect return type for fsdax fault
 handlers
Message-ID: <20221027212628.GA3600936@dread.disaster.area>
References: <Y1rz+qkknFIIQM04@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1rz+qkknFIIQM04@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 27, 2022 at 02:11:22PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The kernel robot complained about this:
> 
> >> fs/xfs/xfs_file.c:1266:31: sparse: sparse: incorrect type in return expression (different base types) @@     expected int @@     got restricted vm_fault_t @@
>    fs/xfs/xfs_file.c:1266:31: sparse:     expected int
>    fs/xfs/xfs_file.c:1266:31: sparse:     got restricted vm_fault_t
>    fs/xfs/xfs_file.c:1314:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted vm_fault_t [usertype] ret @@     got int @@
>    fs/xfs/xfs_file.c:1314:21: sparse:     expected restricted vm_fault_t [usertype] ret
>    fs/xfs/xfs_file.c:1314:21: sparse:     got int
> 
> Fix the incorrect return type for these two functions.
> 
> While we're at it, make the !fsdax version return VM_FAULT_SIGBUS
> because a zero return value will cause some callers to try to lock
> vmf->page, which we never set here.
> 
> Fixes: ea6c49b784f0 ("xfs: support CoW in fsdax mode")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: less confusing commit message, add a debug assert to the !fsdax case
> ---

Looks fine to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
