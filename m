Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1EB4C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 14:05:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94DC164D9C
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 14:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbhBKOED (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 09:04:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21566 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232065AbhBKOB7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Feb 2021 09:01:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613052027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r8c8PrpdWCWAqDzIaZaxhktKImL0Pt+Guo/mialbRTE=;
        b=dsfUKwXyEX2tU2vmpRm4apeOhOrInybWsBQTGxoK6pTGc3puTr32BRHc1P+O7ay7SJdoiW
        wxF6QABcehnmPalREcFdi3q4+6+xAw/F4zIm1DU45uThhktOKFsOJ0M+sSh1oBMDrHlhk4
        kBoAhJJLMLXb+Yp/hMAvghvxj4djTcE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-BarcnAmFPZaQ9I-PDvY0-w-1; Thu, 11 Feb 2021 09:00:23 -0500
X-MC-Unique: BarcnAmFPZaQ9I-PDvY0-w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34627189DF4E;
        Thu, 11 Feb 2021 14:00:22 +0000 (UTC)
Received: from bfoster (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E4B160BF1;
        Thu, 11 Feb 2021 14:00:21 +0000 (UTC)
Date:   Thu, 11 Feb 2021 09:00:19 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 4/6] check: don't abort on non-existent excluded groups
Message-ID: <20210211140019.GD222065@bfoster>
References: <161292577956.3504537.3260962158197387248.stgit@magnolia>
 <161292580215.3504537.12419725496679954055.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161292580215.3504537.12419725496679954055.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 09, 2021 at 06:56:42PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Don't abort the whole test run if we asked to exclude groups that aren't
> included in the candidate group list, since we actually /are/ satisfying
> the user's request.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  check |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/check b/check
> index e51cbede..6f8db858 100755
> --- a/check
> +++ b/check
> @@ -243,7 +243,7 @@ _prepare_test_list()
>  		list=$(get_group_list $xgroup)
>  		if [ -z "$list" ]; then
>  			echo "Group \"$xgroup\" is empty or not defined?"
> -			exit 1
> +			continue
>  		fi

Is this only for a nonexistent group? I.e., 'check -x nosuchgroup ...' ?
If so, what's the advantage?

Brian

>  
>  		trim_test_list $list
> 

