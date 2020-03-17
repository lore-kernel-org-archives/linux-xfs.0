Return-Path: <SRS0=h+lF=5C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 017B6C18E5B
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 14:53:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C834D206EC
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 14:53:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZBZpD+XY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgCQOxh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 10:53:37 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:27996 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726112AbgCQOxh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Mar 2020 10:53:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584456816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BmFKYby683DHB6frP7I3NliZBoCA1l4P6bINat0wINI=;
        b=ZBZpD+XYksRbiavBCF4NgVZaZN5sv/ayzvAEyWMXnzyr6IkmHm/Smr4Q9cRPYugS7YEgPE
        2vK9wZu5cFfEF+w6ljdnWWeCaRuUPpGd5pwFco6BlVEH0VPd/CoH1ECRHwWv8wuafts6bp
        fJamrCxotqCgl0vDboOocQalQ7b+tSM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-VcLA9zdLPmu_NdfnUd0_vw-1; Tue, 17 Mar 2020 10:53:32 -0400
X-MC-Unique: VcLA9zdLPmu_NdfnUd0_vw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DD7CA0CDE;
        Tue, 17 Mar 2020 14:53:21 +0000 (UTC)
Received: from redhat.com (ovpn-115-191.rdu2.redhat.com [10.10.115.191])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C28C819C4F;
        Tue, 17 Mar 2020 14:53:20 +0000 (UTC)
Date:   Tue, 17 Mar 2020 09:53:18 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: use more suitable method to get the quota limit
 value
Message-ID: <20200317145318.GA413282@redhat.com>
References: <1584439170-20993-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584439170-20993-1-git-send-email-kaixuxia@tencent.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 17, 2020 at 05:59:30PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> It is more suitable to use min_not_zero() to get the quota limit
> value, means to choose the minimum value not the softlimit firstly.
> And the meaning is more clear even though the hardlimit value must
> be larger than softlimit value.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Hi -
I think the original code is more clear and readable. Just my take.
Thanks-
Bill


> ---
>  fs/xfs/xfs_qm_bhv.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
> index fc2fa41..f1711f5 100644
> --- a/fs/xfs/xfs_qm_bhv.c
> +++ b/fs/xfs/xfs_qm_bhv.c
> @@ -23,9 +23,8 @@
>  {
>  	uint64_t		limit;
>  
> -	limit = dqp->q_core.d_blk_softlimit ?
> -		be64_to_cpu(dqp->q_core.d_blk_softlimit) :
> -		be64_to_cpu(dqp->q_core.d_blk_hardlimit);
> +	limit = min_not_zero(be64_to_cpu(dqp->q_core.d_blk_softlimit),
> +				be64_to_cpu(dqp->q_core.d_blk_hardlimit));
>  	if (limit && statp->f_blocks > limit) {
>  		statp->f_blocks = limit;
>  		statp->f_bfree = statp->f_bavail =
> @@ -33,9 +32,8 @@
>  			 (statp->f_blocks - dqp->q_res_bcount) : 0;
>  	}
>  
> -	limit = dqp->q_core.d_ino_softlimit ?
> -		be64_to_cpu(dqp->q_core.d_ino_softlimit) :
> -		be64_to_cpu(dqp->q_core.d_ino_hardlimit);
> +	limit = min_not_zero(be64_to_cpu(dqp->q_core.d_ino_softlimit),
> +				be64_to_cpu(dqp->q_core.d_ino_hardlimit));
>  	if (limit && statp->f_files > limit) {
>  		statp->f_files = limit;
>  		statp->f_ffree =
> -- 
> 1.8.3.1
> 

