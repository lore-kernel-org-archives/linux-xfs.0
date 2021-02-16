Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08F63C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Feb 2021 12:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADDEA64DF0
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Feb 2021 12:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbhBPMCQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Feb 2021 07:02:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30553 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230283AbhBPMAK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Feb 2021 07:00:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613476724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uWa2SviXIIoGU4SOtx8ib+BpGR2/mZHfu0bS5pzVZBo=;
        b=TSO1cb4BCsKDIo6IhQgsMGhaN8Krwku47wbnxFxy7kgug9sdy8i+XyX0naGl/RP9mCQiqy
        qnLJbKB3IHxLvcizYBMZUkBvUlp0ZZSj4cItVy/nOGR8+LSYkv4+Ph5ZwoBi5r5/J/mllD
        8PRUNPaSEzT22K5TR6rNjaBzJWadx0M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-zCxAqHo_Mn2i8xQzxvir5w-1; Tue, 16 Feb 2021 06:58:42 -0500
X-MC-Unique: zCxAqHo_Mn2i8xQzxvir5w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CEAD2192CC41;
        Tue, 16 Feb 2021 11:58:41 +0000 (UTC)
Received: from bfoster (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5487619D6C;
        Tue, 16 Feb 2021 11:58:41 +0000 (UTC)
Date:   Tue, 16 Feb 2021 06:58:39 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs_repair: add post-phase error injection points
Message-ID: <20210216115839.GD534175@bfoster>
References: <161319520460.422860.10568013013578673175.stgit@magnolia>
 <161319522176.422860.4620061453225202229.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161319522176.422860.4620061453225202229.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 12, 2021 at 09:47:01PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create an error injection point so that we can simulate repair failing
> after a certain phase.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  repair/globals.c    |    3 +++
>  repair/globals.h    |    3 +++
>  repair/progress.c   |    3 +++
>  repair/xfs_repair.c |    4 ++++
>  4 files changed, 13 insertions(+)
> 
> 
...
> diff --git a/repair/progress.c b/repair/progress.c
> index e5a9c1ef..5bbe58ec 100644
> --- a/repair/progress.c
> +++ b/repair/progress.c
> @@ -410,6 +410,9 @@ timestamp(int end, int phase, char *buf)
>  		current_phase = phase;
>  	}
>  
> +	if (fail_after_phase && phase == fail_after_phase)
> +		kill(getpid(), SIGKILL);
> +

It seems a little hacky to bury this in timestamp(). Perhaps we should
at least check for end == PHASE_END (even though PHASE_START is
currently only used in one place). Otherwise seems reasonable..

Brian

>  	if (buf) {
>  		tmp = localtime((const time_t *)&now);
>  		sprintf(buf, _("%02d:%02d:%02d"), tmp->tm_hour, tmp->tm_min, tmp->tm_sec);
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 12e319ae..6b60b8f4 100644
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
> 

