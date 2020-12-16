Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61364C2BBD4
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Dec 2020 22:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B5B923A3A
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Dec 2020 22:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730049AbgLPWEn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Dec 2020 17:04:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41070 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730043AbgLPWEn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Dec 2020 17:04:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608156197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CJ5PknlnzHLj39cQ3U4Xztoj+8TF6qILn41yE5DSRdw=;
        b=EXbWJUIP7mEemEBhNp/Fr+eZcYroq80n2VXRON6Oz0DVdTbV8VTH6LMNWoDjyfM65HKDnV
        QtVxPe6AjBZ81ljT6IwPwW9lBlwngcRKE9iMXwESMUt0MIuLhkz3tBNg+FibAVjYeOcxC9
        8ygkaRnOIE/8YI2CfKtoBvTG0S9/ox4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-nzemDwBOO0atq9QVH-ol9w-1; Wed, 16 Dec 2020 17:03:12 -0500
X-MC-Unique: nzemDwBOO0atq9QVH-ol9w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8814801AC0;
        Wed, 16 Dec 2020 22:03:11 +0000 (UTC)
Received: from redhat.com (ovpn-115-132.rdu2.redhat.com [10.10.115.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 431F71971D;
        Wed, 16 Dec 2020 22:03:08 +0000 (UTC)
Date:   Wed, 16 Dec 2020 16:03:06 -0600
From:   Bill O'Donnell <billodo@redhat.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Thomas Deutschmann <whissi@gentoo.org>
Subject: Re: [PATCH] xfsdump: don't try to generate .ltdep in inventory/
Message-ID: <20201216220306.GA2313990@redhat.com>
References: <15af018c-caf7-71e7-c353-96775d7173ba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15af018c-caf7-71e7-c353-96775d7173ba@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 02, 2020 at 02:35:44PM -0500, Eric Sandeen wrote:
> .ltdep gets generated from CFILES, and there are none in inventory/
> so trying to generate it in that dir leads to a non-fatal error:
> 
> Building inventory
>     [LTDEP]
> gcc: fatal error: no input files
> compilation terminated.
> 
> inventory/ - like common/ - has files that get linked into other dirs,
> and .ltdep is generated there.  So, simply remove the .ltdep generation
> from the inventory/ dir.
> 
> Reported-by: Thomas Deutschmann <whissi@gentoo.org>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

looks fine.
Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
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

