Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78071C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Feb 2021 14:15:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C7ED64E5C
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Feb 2021 14:15:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbhBVOPM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 09:15:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37534 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232445AbhBVONR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Feb 2021 09:13:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614003111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rVOPZ7sTZwulZ4WNjkxhbITP1zNZSXWtBdDfE/Jsebg=;
        b=IiogZ3sG/M5XETu94voYyXcGHqBMIQhcp7skcEVjD8dmjgF5Sil1ys/PVtTqScgdSNSGBP
        Zb5be0nW4eOu0KjzwopMVh4qlnhEz9ac1k7jCQ3G3jxwQ+OlSEajdQzBhpHZbD0gAvWNa1
        lupsp+c2cvqjzS66uVLDxdilyevTHaw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-KluMWPwzMiKVYYsaa99vcA-1; Mon, 22 Feb 2021 09:11:49 -0500
X-MC-Unique: KluMWPwzMiKVYYsaa99vcA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FBCA1005501;
        Mon, 22 Feb 2021 14:11:48 +0000 (UTC)
Received: from bfoster (ovpn-119-92.rdu2.redhat.com [10.10.119.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F31719C45;
        Mon, 22 Feb 2021 14:11:48 +0000 (UTC)
Date:   Mon, 22 Feb 2021 09:11:46 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs_repair: add post-phase error injection points
Message-ID: <20210222141146.GD886774@bfoster>
References: <161370467351.2389661.12577563230109429304.stgit@magnolia>
 <161370469573.2389661.2370498929966302970.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161370469573.2389661.2370498929966302970.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 07:18:15PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create an error injection point so that we can simulate repair failing
> after a certain phase.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  repair/globals.c    |    3 +++
>  repair/globals.h    |    3 +++
>  repair/xfs_repair.c |    8 ++++++++
>  3 files changed, 14 insertions(+)
> 
> 
> diff --git a/repair/globals.c b/repair/globals.c
> index 110d98b6..537d068b 100644
> --- a/repair/globals.c
> +++ b/repair/globals.c
> @@ -117,3 +117,6 @@ uint64_t	*prog_rpt_done;
>  
>  int		ag_stride;
>  int		thread_count;
> +
> +/* If nonzero, simulate failure after this phase. */
> +int		fail_after_phase;
> diff --git a/repair/globals.h b/repair/globals.h
> index 1d397b35..a9287320 100644
> --- a/repair/globals.h
> +++ b/repair/globals.h
> @@ -162,4 +162,7 @@ extern uint64_t		*prog_rpt_done;
>  extern int		ag_stride;
>  extern int		thread_count;
>  
> +/* If nonzero, simulate failure after this phase. */
> +extern int		fail_after_phase;
> +
>  #endif /* _XFS_REPAIR_GLOBAL_H */
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 891b3b23..33062170 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -362,6 +362,10 @@ process_args(int argc, char **argv)
>  
>  	if (report_corrected && no_modify)
>  		usage();
> +
> +	p = getenv("XFS_REPAIR_FAIL_AFTER_PHASE");
> +	if (p)
> +		fail_after_phase = (int)strtol(p, NULL, 0);
>  }
>  
>  void __attribute__((noreturn))
> @@ -851,6 +855,10 @@ static inline void
>  phase_end(int phase)
>  {
>  	timestamp(PHASE_END, phase, NULL);
> +
> +	/* Fail if someone injected an post-phase error. */
> +	if (fail_after_phase && phase == fail_after_phase)
> +		platform_crash();
>  }
>  
>  int
> 

