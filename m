Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEC04C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 16:39:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C0C96100C
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 16:39:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbhCaQjS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Mar 2021 12:39:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47051 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233757AbhCaQjM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Mar 2021 12:39:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617208752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ss5sR2EvcnSs6zYficUAi6TqGWsonIo9HNyywiu7BAM=;
        b=WYOkZvC4ce/6+o93bDxCQ+pX+1/QxgnXIpqDmG4e1AeQJetlCXYWD5vYuC89KYLgcXwNft
        Wuzb6vcrox3DHGDbqImjpp6qo3vZ1NI9HpByfb2CTXr/tQbCfo1dWNwUFa/odrDdNNt2+K
        EGxlL0jkShMXD5GxwJQn0XVxGKg5B0Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-529-JWBub9w0PyimNnfMLkJhtA-1; Wed, 31 Mar 2021 12:39:09 -0400
X-MC-Unique: JWBub9w0PyimNnfMLkJhtA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8AF3C1966322;
        Wed, 31 Mar 2021 16:39:07 +0000 (UTC)
Received: from bfoster (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DEF191001281;
        Wed, 31 Mar 2021 16:39:06 +0000 (UTC)
Date:   Wed, 31 Mar 2021 12:39:03 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/3] common/xfs: support realtime devices with
 _scratch_xfs_admin
Message-ID: <YGSlp2TXfj7RxuU6@bfoster>
References: <161715288469.2703773.13448230101596914371.stgit@magnolia>
 <161715289029.2703773.9509352442264553944.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161715289029.2703773.9509352442264553944.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 06:08:10PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Teach _scratch_xfs_admin to support passing the realtime device to
> xfs_admin so that we can actually test xfs_admin functionality with
> those setups.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  common/xfs |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/common/xfs b/common/xfs
> index 69f76d6e..189da54b 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -269,9 +269,15 @@ _test_xfs_db()
>  _scratch_xfs_admin()
>  {
>  	local options=("$SCRATCH_DEV")
> +	local rt_opts=()
>  	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
>  		options+=("$SCRATCH_LOGDEV")
> -	$XFS_ADMIN_PROG "$@" "${options[@]}"
> +	if [ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_RTDEV" ]; then
> +		$XFS_ADMIN_PROG --help 2>&1 | grep -q 'rtdev' || \
> +			_notrun 'xfs_admin does not support rt devices'
> +		rt_opts+=(-r "$SCRATCH_RTDEV")
> +	fi
> +	$XFS_ADMIN_PROG "${rt_opts[@]}" "$@" "${options[@]}"
>  }
>  
>  _scratch_xfs_logprint()
> 

