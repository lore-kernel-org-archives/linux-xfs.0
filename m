Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D319C04E69
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Aug 2023 17:42:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbjHHRm3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Aug 2023 13:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234805AbjHHRlt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Aug 2023 13:41:49 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E206E4218
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 09:18:29 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id 46e09a7af769-6bcf2fd5d69so2278941a34.1
        for <linux-xfs@vger.kernel.org>; Tue, 08 Aug 2023 09:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1691511471; x=1692116271;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XB95/o7Xsi6beLBEdd1FYpxtew7nXv00BRUOPTdOsfA=;
        b=avIULkkg9L0w5z4eT/R+wPYR6EccRalnwy7hodCxpVaAWpW1wrQhwFXh22Dh0KIAL1
         cPvRsDJCBkZaz+kFwTWFOgBxNkomp5DWfhxhbH4ugFzx4EElH+T/PsuoJBbN7g3dD5ei
         S2BErMJs81ZOWOZrn12QWfpq0PwX6+u1t9vuwpHLxuRsL8eIhabmbE4//1LvilpFHxZK
         cmD1qXXv7GABq+BA657h6wIggA7RFVflO1ybV4Q9p/REhQxvqnU8vTOkAXSuQOleePbb
         Pw5FsnaR5Qls1QPBah0bSSJW5uaMeWD0SDeqqJ700TNkhLwU+ntCeKAzQDd/TWRCf0K0
         CNsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691511471; x=1692116271;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XB95/o7Xsi6beLBEdd1FYpxtew7nXv00BRUOPTdOsfA=;
        b=QuVg4d3FuBwOOzbdCLLy7bNj889GAitXbXlNrGhtmEIItJP4DYd6TUTfNeZV86LGCV
         uxVjPnBeZR+ntCfaJRxnKs0dY4TKNxjrIKG++WqQ8DK32ZgfpfXKt2O7M19IPoqbgmFD
         g7HeDESrbVo83fdnMuG01HgJ5BhMd7CIffdtbsmA2rHWux5w4Cw0OEeYrEDp4Ti4nE93
         zrL2xsI2+oUDCuR32gGQ3q40cZw+1+5Q4ZvcrI4R3TbT4Jex1iJlYWBG27sNPH6fS1MY
         Lg/3QBvAtbQfTEi6SEp3FUDbW7HmBLIjD1Ig8HNEsj2xN65P5CzeOm71Tlw76EptW3CJ
         4y9Q==
X-Gm-Message-State: AOJu0Yzp99UQ0xq3x/Hq1X2PlfjeC0/YfL/+X00BS3x94Mwgoy+YSn7D
        S4hXCTI0ftHdpnF6LQl4fWJuxFDdNByyaXvuWRY=
X-Google-Smtp-Source: AGHT+IFH5R6U7DvFc5YzcNP/hLFOs+phMIfM2svbpkdK4SHqG0PzoG7RLHyt2lIxhDBKVQAceq3eKw==
X-Received: by 2002:a17:903:32c5:b0:1bc:4374:1e3c with SMTP id i5-20020a17090332c500b001bc43741e3cmr14453854plr.40.1691478801003;
        Tue, 08 Aug 2023 00:13:21 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-166-213.pa.nsw.optusnet.com.au. [49.180.166.213])
        by smtp.gmail.com with ESMTPSA id m1-20020a170902db0100b001b9d95945afsm8167234plx.155.2023.08.08.00.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 00:13:20 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qTGu6-002cAy-1H;
        Tue, 08 Aug 2023 17:13:18 +1000
Date:   Tue, 8 Aug 2023 17:13:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: hide xfs_inode_is_allocated in scrub common code
Message-ID: <ZNHrDly4D/KV8LPU@dread.disaster.area>
References: <169049625702.922264.5146998399930069330.stgit@frogsfrogsfrogs>
 <169049625739.922264.2263489616800569557.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169049625739.922264.2263489616800569557.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 27, 2023 at 03:30:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This function is only used by online fsck, so let's move it there.
> In the next patch, we'll fix it to work properly and to require that the
> caller hold the AGI buffer locked.  No major changes aside from
> adjusting the signature a bit.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

LGTM

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
