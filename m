Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D442C54FCB
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 16:17:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A15020776
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 16:17:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E045Eugt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgDVQRo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 12:17:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59011 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726112AbgDVQRn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Apr 2020 12:17:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587572262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7oFgUZnP9MxkKw9NlQe6FSTeqgQXsmFSmDQIjGvyQHw=;
        b=E045EugtgY9g7xv7U6I5fRCoDMtG/aKDvIbfgrgtnb+/WGMa/JAWN6fklcmEb5l24+IJvg
        4u7R9iXEKzqdB2+RgX/yK+i9CN1XkJdKHCg4J7lIsVCjuVTQ7vSp8FhMjf9Wn3n680gabp
        MFs4ocHDzVkWEJbodirItVZuq+3dk2o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-UIAfewR_O06JZrMmosPAeA-1; Wed, 22 Apr 2020 12:17:40 -0400
X-MC-Unique: UIAfewR_O06JZrMmosPAeA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D46E801E57;
        Wed, 22 Apr 2020 16:17:39 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C9609600DE;
        Wed, 22 Apr 2020 16:17:38 +0000 (UTC)
Date:   Wed, 22 Apr 2020 12:17:37 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/19] xfs: complain when we don't recognize the log item
 type
Message-ID: <20200422161737.GA37352@bfoster>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <158752116938.2140829.6588657626837150802.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158752116938.2140829.6588657626837150802.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 21, 2020 at 07:06:09PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're sorting recovered log items ahead of recovering them and
> encounter a log item of unknown type, actually print the type code when
> we're rejecting the whole transaction to aid in debugging.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log_recover.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 11c3502b07b1..5f803083ddc3 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1887,8 +1887,8 @@ xlog_recover_reorder_trans(
>  			break;
>  		default:
>  			xfs_warn(log->l_mp,
> -				"%s: unrecognized type of log operation",
> -				__func__);
> +				"%s: unrecognized type of log operation (%d)",
> +				__func__, ITEM_TYPE(item));
>  			ASSERT(0);
>  			/*
>  			 * return the remaining items back to the transaction
> 

