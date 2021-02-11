Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE63C4332B
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 14:05:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10EE664E8A
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 14:05:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbhBKOE4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 09:04:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53051 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231980AbhBKOCS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Feb 2021 09:02:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613052050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l+fVqtrlA0QuHyvZOlb7k14PBzplFpzc7TRXmPz2zr0=;
        b=Cb8X88NIY6rQK7DXBEpcmPuHOvJvTPghxm4OQIuzacbW+sizxgcu+y4vloNNUVkWJe4uDs
        NE/3CwW9ryUUu8BtN6bNIBRne8ueQtgpFptegi1Yhq+PtmHfeMm82PkEolqrGSLVMGDqu5
        HVr9dTRvTirA7InZIWhF3mFBxTYyr8Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-FAm41m6SMUaRJ4iqGzdW_g-1; Thu, 11 Feb 2021 09:00:49 -0500
X-MC-Unique: FAm41m6SMUaRJ4iqGzdW_g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C990C73AA;
        Thu, 11 Feb 2021 14:00:47 +0000 (UTC)
Received: from bfoster (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F18AF10023AB;
        Thu, 11 Feb 2021 14:00:46 +0000 (UTC)
Date:   Thu, 11 Feb 2021 09:00:45 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 5/6] check: run tests in exactly the order specified
Message-ID: <20210211140045.GE222065@bfoster>
References: <161292577956.3504537.3260962158197387248.stgit@magnolia>
 <161292580772.3504537.14460569826738892955.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161292580772.3504537.14460569826738892955.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 09, 2021 at 06:56:47PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Introduce a new --exact-order switch to disable all sorting, filtering
> of repeated lines, and shuffling of test order.  The goal of this is to
> be able to run tests in a specific order, namely to try to reproduce
> test failures that could be the result of a -r(andomize) run getting
> lucky.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  check |   36 ++++++++++++++++++++++++++++--------
>  1 file changed, 28 insertions(+), 8 deletions(-)
> 
> 
> diff --git a/check b/check
> index 6f8db858..106ec8e1 100755
> --- a/check
> +++ b/check
...
> @@ -249,17 +251,22 @@ _prepare_test_list()
>  		trim_test_list $list
>  	done
>  
> -	# sort the list of tests into numeric order
> -	if $randomize; then
> -		if type shuf >& /dev/null; then
> -			sorter="shuf"
> +	# sort the list of tests into numeric order unless we're running tests
> +	# in the exact order specified
> +	if ! $exact_order; then
> +		if $randomize; then
> +			if type shuf >& /dev/null; then
> +				sorter="shuf"
> +			else
> +				sorter="awk -v seed=$RANDOM -f randomize.awk"
> +			fi
>  		else
> -			sorter="awk -v seed=$RANDOM -f randomize.awk"
> +			sorter="cat"
>  		fi
> +		list=`sort -n $tmp.list | uniq | $sorter`
>  	else
> -		sorter="cat"
> +		list=`cat $tmp.list`

Do we want to still filter out duplicates (i.e. uniq) in exact order
mode? LGTM either way:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	fi
> -	list=`sort -n $tmp.list | uniq | $sorter`
>  	rm -f $tmp.list
>  }
>  
> @@ -304,7 +311,20 @@ while [ $# -gt 0 ]; do
>  	-udiff)	diff="$diff -u" ;;
>  
>  	-n)	showme=true ;;
> -        -r)	randomize=true ;;
> +	-r)
> +		if $exact_order; then
> +			echo "Cannot specify -r and --exact-order."
> +			exit 1
> +		fi
> +		randomize=true
> +		;;
> +	--exact-order)
> +		if $randomize; then
> +			echo "Cannnot specify --exact-order and -r."
> +			exit 1
> +		fi
> +		exact_order=true
> +		;;
>  	-i)	iterations=$2; shift ;;
>  	-T)	timestamp=true ;;
>  	-d)	DUMP_OUTPUT=true ;;
> 

