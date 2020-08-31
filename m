Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF51C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 19:06:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 164C220BED
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 19:06:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C4wDlpro"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgHaTGU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 15:06:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43496 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727993AbgHaTGU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 15:06:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598900779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VGQrVOGSwo94di5IiClX4JhiNp/hXaRb9H3abiRJEB8=;
        b=C4wDlprorNM/TbDScFIGfwYoTqpgu9R8D89qRP7ZMslfoodPQ27vpzYIJuTV17mL9CAcWO
        KFhZB+bcEq0C1aOIesE+QqxYsMCRaw0TTq6cEjEkdaG7CZUzyad6+RVc2VgcUeaSQDMNYM
        EHlP85jXcu5/nOzG6eWmx2cvnRjyMVg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-iHll25sWMICHnMgQfESOiA-1; Mon, 31 Aug 2020 15:06:16 -0400
X-MC-Unique: iHll25sWMICHnMgQfESOiA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 014C61019624;
        Mon, 31 Aug 2020 19:06:15 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D19A5C1BB;
        Mon, 31 Aug 2020 19:06:14 +0000 (UTC)
Date:   Mon, 31 Aug 2020 15:06:12 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs.xfs: remove comment about needed future work
Message-ID: <20200831190612.GB12035@bfoster>
References: <3a5c9483-954d-e045-7ebe-645250d61efe@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a5c9483-954d-e045-7ebe-645250d61efe@sandeen.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 27, 2020 at 02:37:17PM -0500, Eric Sandeen wrote:
> Remove comment about the need to sync this function with the
> kernel; that was mostly taken care of with:
> 
> 7b7548052 ("mkfs: use libxfs to write out new AGs")
> 
> There's maybe a little more samey-samey that we could do here,
> but it's not egregiously cut & pasted as it was before.
> 
> Signed-off-by: Eric Sandeen <sandeen2redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index a687f385..874e40da 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3418,11 +3418,6 @@ prepare_devices(
>  
>  }
>  
> -/*
> - * XXX: this code is mostly common with the kernel growfs code.
> - * These initialisations should be pulled into libxfs to keep the
> - * kernel/userspace header initialisation code the same.
> - */
>  static void
>  initialise_ag_headers(
>  	struct mkfs_params	*cfg,
> 

