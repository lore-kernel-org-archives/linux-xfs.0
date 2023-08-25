Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27E33EE49A5
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Aug 2023 00:16:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjHYAP2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 20:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235657AbjHYAPT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2023 20:15:19 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1691BCC
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 17:15:16 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1bf7a6509deso3492545ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 17:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1692922516; x=1693527316;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/qBpBlOCSsGetkX/G2jP+uE9tjgwVzsKe/QE8J1CHNA=;
        b=B0ezTB46IiSxoBsV7GmW/eWBRGyxeYiUaFQK+L3ZW0HqzhDFZ5XIIOUmuYLWZ6pYua
         uvWYHkF2yDtfoRRJdCLQdUx6Ou2EmNosMRitzWiN3DieVL0bUIjLcmt1N7Ij9dVReEYl
         nWABivzBIWmqXveRKCL/9hQ9lJW0roinRY/AFaVwMEso0pQ7KIh7QTBl8h/wjID1j5fb
         qCOkWV1YfAtzxXBcPvksfLqBBYWfOC4cgcL5MA7ThWmQJQ2ApcBjj0IpDfNR6oqf1QUI
         YykLvaCPQmW8HnpqmgnzANC/lIOoa3FdcB73oeve2exZUB/fc2YndEkE7B9arlM4c0l7
         EXAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692922516; x=1693527316;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/qBpBlOCSsGetkX/G2jP+uE9tjgwVzsKe/QE8J1CHNA=;
        b=NBmK1+fbiLnzfHvIvxRNW702Js08W4fgzaDekXqQtcSMAtQAWLM3L11zy/cpRSPRZV
         fw8I0AtPYVRp7wf0BgQw54EeFsleUfWXGUYuVaYdxDuPjHg1Q0nOFVDn8Kvbv1Ahw8Si
         efWnqs+dkWf7zZi3zBJQSMfTvCXHLl808vmyr5jHrfFJ/XzDOkVbPMXXj89Syi6UKYHq
         /K9Ak+0nOuyRXj0fPYkqxU2trlv+heoHfK8MqAS9/LoM2y//CznDv/70mU6jaTbT4p09
         P26+i0zEfLgu/1MPr9X76p29UvcsryZgT7MxCt0XhuBJZej6LN2LWDSRQqoRSaIqoR/i
         rzSA==
X-Gm-Message-State: AOJu0Yw7mnZIn+0/5nadcvGH/tIYAdfVS6AbRnNRKmp1nOmPoCuNtWcf
        vTcRV8zqOpSZbh+2LY8U8Ccm4g==
X-Google-Smtp-Source: AGHT+IHRHZVGYRLxaPEh0csGvXELzW8gJTP87TBMhlWtlPMOmix5r4wSdUGSqYBMGlmRGMWkCNzqHw==
X-Received: by 2002:a17:902:c40a:b0:1b0:3637:384e with SMTP id k10-20020a170902c40a00b001b03637384emr19582683plk.25.1692922516037;
        Thu, 24 Aug 2023 17:15:16 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id i9-20020a170902c94900b001aaecc0b6ffsm259365pla.160.2023.08.24.17.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 17:15:15 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qZKTp-0066eQ-0K;
        Fri, 25 Aug 2023 10:15:13 +1000
Date:   Fri, 25 Aug 2023 10:15:13 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@gmail.com, linux-xfs@vger.kernel.org,
        ritesh.list@gmail.com, sandeen@sandeen.net
Subject: Re: [PATCH 3/3] xfs: remove cpu hotplug hooks
Message-ID: <ZOfykRAQagl3cIvX@dread.disaster.area>
References: <169291927442.219974.9654062191833512358.stgit@frogsfrogsfrogs>
 <169291929160.219974.11113805270455831702.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169291929160.219974.11113805270455831702.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 24, 2023 at 04:21:31PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> There are no users of the cpu hotplug hooks in xfs now, so remove the
> infrastructure.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_super.c         |   50 +-------------------------------------------
>  include/linux/cpuhotplug.h |    1 -
>  2 files changed, 1 insertion(+), 50 deletions(-)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> 
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 6a4f8b2f6159..1403aace4fe3 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -2301,47 +2301,6 @@ xfs_destroy_workqueues(void)
>  	destroy_workqueue(xfs_alloc_wq);
>  }
>  
> -#ifdef CONFIG_HOTPLUG_CPU
> -static int
> -xfs_cpu_dead(
> -	unsigned int		cpu)
> -{
> -	struct xfs_mount	*mp, *n;
> -
> -	spin_lock(&xfs_mount_list_lock);
> -	list_for_each_entry_safe(mp, n, &xfs_mount_list, m_mount_list) {
> -		spin_unlock(&xfs_mount_list_lock);
> -		spin_lock(&xfs_mount_list_lock);
> -	}
> -	spin_unlock(&xfs_mount_list_lock);
> -	return 0;
> -}

You also can kill the xfs_mount_list and xfs_mount_list_lock now,
right? That can be done in a separate patch, though.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
