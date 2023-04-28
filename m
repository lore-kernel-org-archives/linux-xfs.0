Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8119C77B61
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Apr 2023 02:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344642AbjD1CSN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 22:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344621AbjD1CSM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 22:18:12 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2EC2684
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 19:18:07 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id 98e67ed59e1d1-246fd87a124so7981440a91.0
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 19:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682648287; x=1685240287;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EqGZa4YSysHwYslyuKVQ0Huqk2vIcjs5agLP+jWZmvM=;
        b=yHefcwK99o1CnC2JLw5p7MggHqsugCpH6M/KWmMvr60ZD0ODY8KX9Y0Ui4BQRyhIyp
         3us0qIRRkkTIl4Os0/UV8c/y3XuUXhIukbRbDcUa9w3F68YXM/uwL8ZQKP1VuTO1jLpb
         vuUPwmZqGk8akxpqOWmhEsyZsz4DrrsjgAf8nFEXBKufkOtczllRsNwY5ap8/qw4+wCP
         K4M7F8XpQYKRqg+Ux7HDWkkYDIRxjIIs6AHE65NBaGOkyR6i6tJTj6gVdXU3dtS1HQoB
         8wafse+2bAWzbNvEC/j1xhwehyBXqMqpU13sXxNAR8iI7X+wQ/T/xP+Ip5dptF9pctsS
         XCWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682648287; x=1685240287;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EqGZa4YSysHwYslyuKVQ0Huqk2vIcjs5agLP+jWZmvM=;
        b=W1B9esQIEaYHBYi5fCyVbFi3lqoQGxpQJ8gVCsQPK42AwsA4odQoFPJD2jQrOd0U7N
         oPBvVWltEF/Us2b9dOpLsCc+caHU3RwDPw0zuP8SoRejS+TSRiMd2aM17Tjqw6lCoC2p
         RbOe2988sbOuWnCmVCWnAt+m/j5cR+D2Qaol3BPmyNzjAF/AkZfgWk+JohG0T/PuddQo
         PcwSJIYHcba2s5P3N1orQj9or1NrMhAvPs9ff7yr/r8kmlMo1+SIZBO2FhP5tcxW4NOh
         j5KRiyWrlPA7kSY8BFojqNwUaXMCkWVgdc5EN7rRLmoBhCKzUEO6NwQSxa8QkY3otMP7
         7YBA==
X-Gm-Message-State: AC+VfDxCFz7SStI/vLrRrwFI/kvr7TolHJOQ/ElYbljcxh87B1EUQhcw
        8hVuYPgLro1t7GsR4GJRVKgVEUSquv8HfG0rSRM=
X-Google-Smtp-Source: ACHHUZ7Ds1ps4ra9qPqk7/8TO0EhK5UyHJ7vy0qpyGoSVT3wzpTeMkMgnGXz9CD3yiY8ALOE7Uf9hw==
X-Received: by 2002:a17:90b:4b09:b0:246:f8d7:3083 with SMTP id lx9-20020a17090b4b0900b00246f8d73083mr4098075pjb.16.1682648287122;
        Thu, 27 Apr 2023 19:18:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id iz19-20020a170902ef9300b001a98ac97d0asm5376331plb.114.2023.04.27.19.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 19:18:06 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1psDgR-008i0O-MP; Fri, 28 Apr 2023 12:18:03 +1000
Date:   Fri, 28 Apr 2023 12:18:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: check that per-cpu inodegc workers actually run
 on that cpu
Message-ID: <20230428021803.GS3223426@dread.disaster.area>
References: <168263576040.1719564.2454266085026973056.stgit@frogsfrogsfrogs>
 <168263577171.1719564.17269081541985295999.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168263577171.1719564.17269081541985295999.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 27, 2023 at 03:49:31PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we've allegedly worked out the problem of the per-cpu inodegc
> workers being scheduled on the wrong cpu, let's put in a debugging knob
> to let us know if a worker ever gets mis-scheduled again.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_icache.c |    2 ++
>  fs/xfs/xfs_mount.h  |    3 +++
>  fs/xfs/xfs_super.c  |    3 +++
>  3 files changed, 8 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 58712113d5d6..4b63c065ef19 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1856,6 +1856,8 @@ xfs_inodegc_worker(
>  	struct xfs_inode	*ip, *n;
>  	unsigned int		nofs_flag;
>  
> +	ASSERT(gc->cpu == smp_processor_id());

I kinda wish there was a reverse "per cpu item to cpu" reverse
resolution function, but this is only debugging code so it'll do.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
