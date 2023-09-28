Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D28CE7AFB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Sep 2023 05:55:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjI1FzC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Sep 2023 01:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjI1FzB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Sep 2023 01:55:01 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96F111F
        for <linux-xfs@vger.kernel.org>; Wed, 27 Sep 2023 22:54:59 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 41be03b00d2f7-51b4ef5378bso9520514a12.1
        for <linux-xfs@vger.kernel.org>; Wed, 27 Sep 2023 22:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1695880499; x=1696485299; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=peEjof8I54c7Dpvx6SkdzH4T8u9Nokq1m4sEsps0BMM=;
        b=IwEEubnU4zZbVMp3MxArPqppMkPrePkjXRL7ivliQ3rUA6Jk1UasBM/2M8BrUTjZgi
         e2TgCfZtcoMiQuZqh7rMVcXf5F1AgSmJgKNX865ZaAmaubg7Kd1lCZp7u7DOiSLhBbGK
         XYgJB5jfIqI8TWMekQqCFaU9TjOdK9sivf5TO04sodlONe6AwX7NBHe4ZJrZA2r1+Li2
         ixSFpYxTXjCxxcjPslbbZRd95FOQtzVdwz9fGsJR6BV0dTB3jTaAaYcGSeHJVkHr7LFy
         VDLvR7yqYW3R0tdnuqQN8qPH3zY24zYg+wVNdsCenr3JKNDhs4oF9Kh6ZOn65wshsFpt
         BnOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695880499; x=1696485299;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=peEjof8I54c7Dpvx6SkdzH4T8u9Nokq1m4sEsps0BMM=;
        b=IUsxCm4T7NzYuas5jbT4mYHgPjT+DHeth2awdRQQgndFiSe6V9hidvCBKYcxgJE9Kl
         K259d5vymQk1vljzLp9oLC/VCna7RN3TwokjfxFpkzR0TgJ0yEGeRZ46608W+ZItGE9h
         VNmJJRMUY3fpWsJG9IXuIxhjDxKwqLRDrX5KYUUVtBLuZnjmmhqJieNwxlYFMTf20ocx
         Y+RhnOQkiHTYaKirrQo7CR84yXvucfGQHJ3D9W+xZ3nshCXcbQywFqjBFr7f7EeFMTC2
         xRjBXCqvpcAUsEHh1BxpfKOJ4CEzlSlW0E2oXUaTyT8Gv8ZFblKKCogZ/B9eWNsGjJ7/
         lDxQ==
X-Gm-Message-State: AOJu0YyCkz4u8OdIRlwx5JbOB3aI9gROIZujnk5kqdZS2s6SaTaqcLWy
        +5ed3YwaLVNCeX11j7qDd1rXFA==
X-Google-Smtp-Source: AGHT+IH1bXgyIeX5IhVpxrLJBFjOc74lgMFmfQOSuSdlQ5Gu0q8UkgTqH3NLCaaLqAa3vH3kvnzZoA==
X-Received: by 2002:a17:90b:383:b0:26d:416a:b027 with SMTP id ga3-20020a17090b038300b0026d416ab027mr273196pjb.31.1695880499192;
        Wed, 27 Sep 2023 22:54:59 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id az14-20020a17090b028e00b002777001ee76sm5229426pjb.18.2023.09.27.22.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 22:54:58 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qljzD-006afR-1q;
        Thu, 28 Sep 2023 15:54:55 +1000
Date:   Thu, 28 Sep 2023 15:54:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: make xchk_iget safer in the presence of corrupt
 inode btrees
Message-ID: <ZRUVL2okuLfNC6U1@dread.disaster.area>
References: <169577058799.3312834.4066903607681044261.stgit@frogsfrogsfrogs>
 <169577058815.3312834.1762190757505617356.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169577058815.3312834.1762190757505617356.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 26, 2023 at 04:31:07PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When scrub is trying to iget na inode, ensure that it won't end up
> deadlocked on a cycle in the inode btree by using an empty transaction
> to store all the buffers.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/common.c |    6 ++++--
>  fs/xfs/scrub/common.h |   19 +++++++++++++++++++
>  fs/xfs/scrub/inode.c  |    4 ++--
>  3 files changed, 25 insertions(+), 4 deletions(-)

Looks reasonable.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Further question on loops in btrees because I can't remember if this
case is handled: if the loop goes round and round the same level,
how is that detected? i.e. how do we avoid recursion count overflows
if we keep walking over the same sibling block pattern?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
