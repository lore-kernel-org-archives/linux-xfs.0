Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B3DC43381
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 14:05:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFED964EAC
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 14:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhBKOEl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 09:04:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41440 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231701AbhBKOB7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Feb 2021 09:01:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613052015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zYHzjPbevDFoTvsUsVZajP2priDExCfynXOtTBde3wQ=;
        b=fAKtiNMTZnAsQmdrevd4r+LKK57ruj3autxTczB1ZPUgj2lmZC17AcmlHL0K6EGJ905Kcv
        zOqbuGAJkwfzGkV56fC/rMOgmQw7FfR5mMGLCLIW9PJcS/HTraQFqKRlrIeSsR5cvaCxVE
        sb5EqLUcne1mqkHzC1O8SdvLUnAoIzc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-lAAQVLbWO-KYI6Aid-dhIw-1; Thu, 11 Feb 2021 09:00:11 -0500
X-MC-Unique: lAAQVLbWO-KYI6Aid-dhIw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1F39107ACF5;
        Thu, 11 Feb 2021 14:00:09 +0000 (UTC)
Received: from bfoster (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EC6760657;
        Thu, 11 Feb 2021 14:00:08 +0000 (UTC)
Date:   Thu, 11 Feb 2021 09:00:07 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 3/6] check: allow '-e testid' to exclude a single test
Message-ID: <20210211140007.GC222065@bfoster>
References: <161292577956.3504537.3260962158197387248.stgit@magnolia>
 <161292579650.3504537.2704583548318437413.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161292579650.3504537.2704583548318437413.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 09, 2021 at 06:56:36PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This enables us to mask off specific tests.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Seems reasonable:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  check |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> 
> diff --git a/check b/check
> index c6ad1d6c..e51cbede 100755
> --- a/check
> +++ b/check
> @@ -79,6 +79,7 @@ testlist options
>      -g group[,group...]	include tests from these groups
>      -x group[,group...]	exclude tests from these groups
>      -X exclude_file	exclude individual tests
> +    -e testlist         exclude a specific list of tests
>      -E external_file	exclude individual tests
>      [testlist]		include tests matching names in testlist
>  
> @@ -287,6 +288,11 @@ while [ $# -gt 0 ]; do
>  
>  	-X)	subdir_xfile=$2; shift ;
>  		;;
> +	-e)
> +		xfile=$2; shift ;
> +		echo "$xfile" | tr ', ' '\n\n' >> $tmp.xlist
> +		;;
> +
>  	-E)	xfile=$2; shift ;
>  		if [ -f $xfile ]; then
>  			sed "s/#.*$//" "$xfile" >> $tmp.xlist
> 

