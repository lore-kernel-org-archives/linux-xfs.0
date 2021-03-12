Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AC48C433E6
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 15:07:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1016564FFD
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 15:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbhCLPHQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Mar 2021 10:07:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46159 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231597AbhCLPGv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Mar 2021 10:06:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615561610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dPTy07otyXha3cuMdlmtRZgqJTnUCSsYYaMspQ89sNo=;
        b=I9c/loEtvyWAX5llrfsSUxBGKeQAupqbcd9peQdu1H4+DU6nKFL+b+LfkGDywCJl9AULXn
        /MyUhtrxAeJHtPr5XQ0Vn9o47wFG99aiCUT8w3itZwMGcl2N2I7gaTM+73RDpeoYYe1WWQ
        PiQpPSQFtOAg0muGW4g77/0UJuQB3Sc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-UAlqRHffNBS5YFAQGosoDg-1; Fri, 12 Mar 2021 10:06:48 -0500
X-MC-Unique: UAlqRHffNBS5YFAQGosoDg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4953919057A4;
        Fri, 12 Mar 2021 15:06:46 +0000 (UTC)
Received: from localhost (unknown [10.66.61.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A29A95D6D7;
        Fri, 12 Mar 2021 15:06:42 +0000 (UTC)
Date:   Fri, 12 Mar 2021 23:25:06 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/3] common/xfs: add a _require_xfs_shrink helper
Message-ID: <20210312152506.GJ3499219@localhost.localdomain>
Mail-Followup-To: Gao Xiang <hsiangkao@redhat.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <20210312132300.259226-1-hsiangkao@redhat.com>
 <20210312132300.259226-2-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312132300.259226-2-hsiangkao@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 12, 2021 at 09:22:58PM +0800, Gao Xiang wrote:
> In order to detect whether the current kernel supports XFS shrinking.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> use -D1 rather than -D0 since xfs_growfs would report unchanged size
> instead.
> 
>  common/xfs | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 2156749d..326edacc 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -432,6 +432,16 @@ _supports_xfs_scrub()
>  	return 0
>  }
>  
> +_require_xfs_shrink()
> +{
> +	_scratch_mkfs_xfs >/dev/null 2>&1
> +
> +	_scratch_mount
> +	$XFS_GROWFS_PROG -D1 "$SCRATCH_MNT" 2>&1 | grep -q 'Invalid argument' || { \
> +		_scratch_unmount; _notrun "kernel does not support shrinking"; }
	        ^^^^
		I think this unmount isn't necessary, due to after "_notrun" the
		$SCRATCH_DEV will be umounted "automatically".

> +	_scratch_unmount
> +}
> +
>  # run xfs_check and friends on a FS.
>  _check_xfs_filesystem()
>  {
> -- 
> 2.27.0
> 

