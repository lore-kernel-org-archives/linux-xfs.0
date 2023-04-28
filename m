Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94038C77B73
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Apr 2023 02:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344783AbjD1COx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 22:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344621AbjD1COv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 22:14:51 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41EC269D
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 19:14:49 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-63b5c48ea09so7479014b3a.1
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 19:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682648089; x=1685240089;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4qa2Yd2/fCCU/+dMYEJ2c9CmgZScoYozh5MJNUiUIuE=;
        b=ej7E4BWbOL74ZiNpXLtDA40imfnzcDiDw6Q8GohAq6FdTNRJAjjjQqWxJmtymfL0Fr
         BlveMNhXF5WgTbi1FrVIVQUNsggcs91P4Xq5cZJSyWjubJ10FeM98ko6TCUFnQOw1Qk2
         fO05iet70/E2yzC8KMD+y0dPiP+EpqpvhVUzSeJ5G5EvEJYyeS2dnWOEVma4hd6JZWMn
         M5YPPmCjG2u7coX0xp55WEJGU5yYuXGYpb0jYZbMPHJFWBs7fntusIX+km49j17skhak
         YDZUFZyDepIiz35P57+HapXdrRgEizbwLbl1v/Ir9mLTfB9lHkllTPjfGqCZX4WXsPiU
         dNlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682648089; x=1685240089;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4qa2Yd2/fCCU/+dMYEJ2c9CmgZScoYozh5MJNUiUIuE=;
        b=NZYV+opuskDL6c4lK+pkhDca1Wn9bnjF8YUIuJPH65LtUGdgN/DF17m7zkmFIqlDOq
         Hw43QkskMZPNRvSye/6FhZ5N691GovUSBZHMe3O80N0FxYsZwWZOXiyXZyk/J0sQhA0p
         uyg3APnSFqF1mZw5anVOs95eIGQpzAZc9odB1dF4au/mStScOVP900RVli0jQUyiiGxr
         gCSxVMFOxXrBBsy34bSskx7oUMQUO/wBjVstvRVV0pSOlbCHuLnz5a9D9704I8ZAFM8b
         fpuRuyWPsVVnaQHIsweZyrn6X98jyX9PZlOtl022o9hK7LrPP3dssutxsvPecbt6xLK6
         +yJg==
X-Gm-Message-State: AC+VfDzMey/e/vwBKrA/a5lzGgfMyvtst58lIcpJjql+ioPeUBt5/3hh
        dgdWk0VuS9sT+P0fK/2Cjsl8gbxb6oOKydWjOro=
X-Google-Smtp-Source: ACHHUZ4D5WKAZUHcJB5GYgKEvXVKiGkcCD6+qdI5vsqWEeK6YXR0Qh+atR7YKl0Kniacnnr4lrmnkg==
X-Received: by 2002:a05:6a20:2d09:b0:f1:628:dcf3 with SMTP id g9-20020a056a202d0900b000f10628dcf3mr3755049pzl.27.1682648089377;
        Thu, 27 Apr 2023 19:14:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id y185-20020a62cec2000000b00640f588b36dsm4614429pfg.8.2023.04.27.19.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 19:14:48 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1psDdG-008hxn-LJ; Fri, 28 Apr 2023 12:14:46 +1000
Date:   Fri, 28 Apr 2023 12:14:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: explicitly specify cpu when forcing inodegc
 delayed work to run immediately
Message-ID: <20230428021446.GR3223426@dread.disaster.area>
References: <168263576040.1719564.2454266085026973056.stgit@frogsfrogsfrogs>
 <168263576602.1719564.2746529641753015911.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168263576602.1719564.2746529641753015911.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 27, 2023 at 03:49:26PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I've been noticing odd racing behavior in the inodegc code that could
> only be explained by one cpu adding an inode to its inactivation llist
> at the same time that another cpu is processing that cpu's llist.
> Preemption is disabled between get/put_cpu_ptr, so the only explanation
> is scheduler mayhem.  I inserted the following debug code into
> xfs_inodegc_worker (see the next patch):
> 
> 	ASSERT(gc->cpu == smp_processor_id());
> 
> This assertion tripped during overnight tests on the arm64 machines, but
> curiously not on x86_64.  I think we haven't observed any resource leaks
> here because the lockfree list code can handle simultaneous llist_add
> and llist_del_all functions operating on the same list.  However, the
> whole point of having percpu inodegc lists is to take advantage of warm
> memory caches by inactivating inodes on the last processor to touch the
> inode.
> 
> The incorrect scheduling seems to occur after an inodegc worker is
> subjected to mod_delayed_work().  This wraps mod_delayed_work_on with
> WORK_CPU_UNBOUND specified as the cpu number.  Unbound allows for
> scheduling on any cpu, not necessarily the same one that scheduled the
> work.

Ugh, that's a bit of a landmine.

> Because preemption is disabled for as long as we have the gc pointer, I
> think it's safe to use current_cpu() (aka smp_processor_id) to queue the
> delayed work item on the correct cpu.
> 
> Fixes: 7cf2b0f9611b ("xfs: bound maximum wait time for inodegc work")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_icache.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
