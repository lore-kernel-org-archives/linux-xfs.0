Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 950B3C1B0D8
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Dec 2020 23:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68E8223750
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Dec 2020 23:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgLPXMM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Dec 2020 18:12:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51577 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729009AbgLPXMM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Dec 2020 18:12:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608160246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nECb6PjtAyextz3WMiCi5A67WXcAt4IHXKWL0tOrEuM=;
        b=hQyeNnpjKXg9tBRdG973be+/H57S+z3m3bnPnA6NB7XRjJdXvx9OKQU1pUvzN7O9W9s9Ea
        yYIJAQGuUtPUfLNw7MIY85ZDzulO7eMyY495Oj5Mqgjf0cdu+N6d2TRoMcgy9ImKHl5hFS
        4s5EMDm8aathaYQP7dWHDhoXOwQz0IM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-OT6l7InDPA2o_HHxWbjq4A-1; Wed, 16 Dec 2020 18:10:44 -0500
X-MC-Unique: OT6l7InDPA2o_HHxWbjq4A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 607ED801817;
        Wed, 16 Dec 2020 23:10:43 +0000 (UTC)
Received: from redhat.com (ovpn-115-132.rdu2.redhat.com [10.10.115.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E00C962953;
        Wed, 16 Dec 2020 23:10:39 +0000 (UTC)
Date:   Wed, 16 Dec 2020 17:10:37 -0600
From:   Bill O'Donnell <billodo@redhat.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Thomas Deutschmann <whissi@gentoo.org>
Subject: Re: [PATCH V2] xfsdump: don't try to generate .ltdep in inventory/
Message-ID: <20201216231037.GA2386499@redhat.com>
References: <15af018c-caf7-71e7-c353-96775d7173ba@redhat.com>
 <ad5ad420-1c4d-7f53-a2a6-51480836ea09@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad5ad420-1c4d-7f53-a2a6-51480836ea09@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 16, 2020 at 04:32:07PM -0600, Eric Sandeen wrote:
> .ltdep gets generated from CFILES, and there are none in inventory/
> so trying to generate it in that dir leads to a non-fatal error when
> the include invokes the rule to build the .ltdep file:
> 
> Building inventory
>     [LTDEP]
> gcc: fatal error: no input files
> compilation terminated.
> 
> inventory/ - like common/ - has files that get linked into other dirs,
> and .ltdep is generated in those other dirs, not in inventory/.
> 
> So, simply remove the .ltdep include/generation from the inventory/
> dir, because there is no reason or ability to generate the file here.
> 
> Reported-by: Thomas Deutschmann <whissi@gentoo.org>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
> 
> V2: more comprehensive problem description
> 
> diff --git a/inventory/Makefile b/inventory/Makefile
> index cda145e..6624fba 100644
> --- a/inventory/Makefile
> +++ b/inventory/Makefile
> @@ -12,5 +12,3 @@ LSRCFILES = inv_api.c inv_core.c inv_fstab.c inv_idx.c inv_mgr.c \
>  default install install-dev:
>  
>  include $(BUILDRULES)
> -
> --include .ltdep
> 

