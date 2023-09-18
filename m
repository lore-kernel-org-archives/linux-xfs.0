Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55DC8CD37B0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Sep 2023 16:59:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbjIRQ7h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbjIRQ7Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2023 12:59:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD971B8
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2023 09:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695056308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9Zvuaicg3VqTWEHqCTIitqQo+eqgqqYDFCHKgelP6cQ=;
        b=OxGB43psneooUqfluiDNkH5RUx3jfpvFo7nVsPPirqoBBReyr2Oq8P7X+14PnZicY3yD/Y
        yS8EmMQsPj5dlcOBMOT99itbvVoypzK1PqIOpGPF/82JgexE2njfQx+Lu0gHxXpMH9ecXI
        4pG/8JxmwyiXc6aqlSo4myejCCuFxdE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-180-e5NRLsWqPD-XKjaIMP68fA-1; Mon, 18 Sep 2023 12:58:24 -0400
X-MC-Unique: e5NRLsWqPD-XKjaIMP68fA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3BB8938210A5;
        Mon, 18 Sep 2023 16:58:24 +0000 (UTC)
Received: from redhat.com (unknown [10.22.18.43])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EE5F340C2064;
        Mon, 18 Sep 2023 16:58:23 +0000 (UTC)
Date:   Mon, 18 Sep 2023 11:58:17 -0500
From:   Bill O'Donnell <bodonnel@redhat.com>
To:     cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs: Update agsize description in the man page
Message-ID: <ZQiBqQbJ01JmHT56@redhat.com>
References: <20230918142604.390357-1-cem@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230918142604.390357-1-cem@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 18, 2023 at 04:26:04PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> agsize value accept different suffixes, including filesystem blocks, so,
> replace "expressed in bytes" by "expressed as a multiple of filesystem
> blocks".
> 
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>

> ---
>  man/man8/mkfs.xfs.8.in | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
> index 08bb92f65..96c07fc71 100644
> --- a/man/man8/mkfs.xfs.8.in
> +++ b/man/man8/mkfs.xfs.8.in
> @@ -352,12 +352,11 @@ This is an alternative to using the
>  .B agcount
>  suboption. The
>  .I value
> -is the desired size of the allocation group expressed in bytes
> -(usually using the
> +is the desired size of the allocation group expressed as a multiple of the
> +filesystem block size (usually using the
>  .BR m " or " g
>  suffixes).
> -This value must be a multiple of the filesystem block size, and
> -must be at least 16MiB, and no more than 1TiB, and may
> +It must be at least 16MiB, and no more than 1TiB, and may
>  be automatically adjusted to properly align with the stripe geometry.
>  The
>  .B agcount
> -- 
> 2.39.2
> 

