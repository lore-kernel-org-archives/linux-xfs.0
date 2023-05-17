Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B706C77B75
	for <linux-xfs@archiver.kernel.org>; Wed, 17 May 2023 11:35:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbjEQLfH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 May 2023 07:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbjEQLex (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 May 2023 07:34:53 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375B0658C
        for <linux-xfs@vger.kernel.org>; Wed, 17 May 2023 04:34:45 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1ae557aaf1dso3965455ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 17 May 2023 04:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1684323284; x=1686915284;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xc+ZYx/aYz9w75WiXwvmkjAupz2fa3DJ4hKNAqPIIlg=;
        b=4B7s7GoYF7Xb9B3nWv7SpaD602YflJ5V4ReR5hOZ3waZskw/xXvQa5vmYM9qa1BdHR
         oZgPnHdhYqFQfHWVrqRgfcw2BUjrJsTJFAf0VlMLGkP8YWW17e+w8l2z3Z6tN07fw+lV
         7yyDEawBFW/TM5RZoajdtif182QQK3iTuPngMwUVIgWHqmFwfMd/wOukKMHvhlsU7oad
         I3yb+rlDl10YNFPh+Tj4byK7xO9O1zEPhg3jimrv5e+RiORCX+eN9AyQm0rUX9CK2ra0
         FanStQkm8CcmytPOtcnSDwISlXu0Sjntu+rLgx/+ANjT86kI2MKDfVWfmCGjkHZ8TJKl
         +3nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684323284; x=1686915284;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xc+ZYx/aYz9w75WiXwvmkjAupz2fa3DJ4hKNAqPIIlg=;
        b=RoXst3+AxWbdLaLpEnQ33zOWcqG3AiQQAIvWjYxC+3A1LknUT7WJjOaS3P7s0XsLkA
         IRupfmnyxlV2tAshO3xpAOob6U1rE/dZs1fjxM8SenzFpX+IYYuVMg+ebemokqt7gKKv
         Z5at3TriXayfzFjm//3Do/p7++3FGLnDIsAXdgzpIl8JeD0j6f1Lca95OjID7ejQUIJT
         bnJ1KQS3dp5JB4VKlq39MdBulS9o7uUfopTKrBdP1U0m10UgSsww7JRKduDFSbdVvGK7
         VTmqe+r709wcbkzjCIO8gSxDvwQXQ5vjL+F8BjIbsoqgnSo8PWtBX/p6hdn7hIPlZi+4
         mD3g==
X-Gm-Message-State: AC+VfDwTXQYP+oJ0uPEn/qOBHPriEjYxTMs/Ir3cksNFsUtSX438V8B7
        8QLbvYI4nKs0YpvRKw0E9T45Ig==
X-Google-Smtp-Source: ACHHUZ51OkRC9MYUIlGWMx3d6s8FPqsS2kDu7q0f9tvATUHN+ascbT1XfbUflSu2QyGBOOlUZGTT6g==
X-Received: by 2002:a17:902:c20c:b0:1ab:16d5:998 with SMTP id 12-20020a170902c20c00b001ab16d50998mr41301072pll.26.1684323284484;
        Wed, 17 May 2023 04:34:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id p12-20020a17090b010c00b0024e0df2f97esm1332172pjz.35.2023.05.17.04.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:34:43 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1pzFQP-000XJv-0k;
        Wed, 17 May 2023 21:34:33 +1000
Date:   Wed, 17 May 2023 21:34:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs@vger.kernel.org,
        Chandan Babu R <chandan.babu@oracle.com>,
        Leah Rumancik <lrumancik@google.com>
Subject: Re: xfs: bug fixes for 6.4-rcX
Message-ID: <ZGS7yaaI7knS0QdM@dread.disaster.area>
References: <20230517000449.3997582-1-david@fromorbit.com>
 <CAOQ4uxiJ-sYPpGcPpVzz0hScUNdZ4bs8=GUsncNOXdeEAOCaCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxiJ-sYPpGcPpVzz0hScUNdZ4bs8=GUsncNOXdeEAOCaCQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 17, 2023 at 10:07:55AM +0300, Amir Goldstein wrote:
> On Wed, May 17, 2023 at 3:08 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > Hi folks,
> >
> 
> Hi Dave,
> 
> > The following patches are fixes for recently discovered problems.
> > I'd like to consider them all for a 6.4-rc merge, though really only
> > patch 2 is a necessary recent regression fix.
> >
> > The first patch addresses a long standing buffer UAF during shutdown
> > situations, where shutdown log item completions can race with CIL
> > abort and iclog log item completions.
> >
> 
> Can you tell roughly how far back this UAF bug goes
> or is it long standing enough to be treated as "forever"?

Longer than I cared to trace the history back.

> > The second patch addresses a small performance regression from the
> > 6.3 allocator rewrite which is also a potential AGF-AGF deadlock
> > vector as it allows out-of-order locking.
> >
> > The third patch is a change needed by patch 4, which I split out for
> > clarity. By itself it does nothing.
> >
> > The fourth patch is a fix for a AGI->AGF->inode cluster buffer lock
> > ordering deadlock. This was introduced when we started pinning inode
> > cluster buffers in xfs_trans_log_inode() in 5.8 to fix long-standing
> > inode reclaim blocking issues, but I've only seen it in the wild
> > once on a system making heavy use of OVL and hence O_TMPFILE based
> > operations.
> 
> Thank you for providing Fixes and this summary with backporing hints :)

I don't think you're going to be able to backport the inode cluster
buffer lock fix. Nothing prior to 5.19 has the necessary
infrastructure or the iunlink log item code this latest fix builds
on top of. That was done to fix a whole class of relatively easy to
hit O_TMPFILE related AGI-AGF-inode cluster buffer deadlocks.  This
fix avoids an entirely different class of inode cluster buffer
deadlocks using the infrastructure introduced in the 5.19 deadlock
fixes.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
