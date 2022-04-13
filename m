Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05E93C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Apr 2022 17:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236567AbiDMRqb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Apr 2022 13:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233980AbiDMRqb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Apr 2022 13:46:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A698F6D190
        for <linux-xfs@vger.kernel.org>; Wed, 13 Apr 2022 10:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649871848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lH0hV3gD6qRTBtPoQBC/7Vat2RdlXA7bzWbab/FAosI=;
        b=dvuoz1o9bk9f/h9ScEiv/nbIAzASI0KGfZK8509GLOg3JaVnCg2/8wqfr7cWEPYFUDTWjm
        /EeRFOSnJ9LkcDHprLgdnQDMKoBJg8+zgd/FtsqGFnC9rVSrNzqApXfkvvJmnkpnH8YATx
        +oWy6xi5dm6pAuHB2G/mtcq1f9OkAts=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-kszXUId6PSapSQ0KvhlRKw-1; Wed, 13 Apr 2022 13:44:07 -0400
X-MC-Unique: kszXUId6PSapSQ0KvhlRKw-1
Received: by mail-qv1-f69.google.com with SMTP id 7-20020a0562140dc700b004442d23d2d8so2364368qvt.2
        for <linux-xfs@vger.kernel.org>; Wed, 13 Apr 2022 10:44:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=lH0hV3gD6qRTBtPoQBC/7Vat2RdlXA7bzWbab/FAosI=;
        b=7gmlVL7v9vNkbPDjqNJbWSgGD4rYUw2vBpJ3x9Z2xlCe4OZ/6RDqNW8K684rhC7h/U
         DgWxuIl6cYTXcpDIcD0VPO+BcbBZ8Cq22a9H7i+Jn4euU60pcm5160XbnjwzH/F8euYJ
         /3zsrEnYivCs8GPxY4gNSraMoMQKRHbbHdNHiaj6W3t5ycXD2F4avMu/lKKOwGIjQoHf
         4swm5rX3plFurWo+rIBaCY0AJLfdgmNRGhh7wQVn+GlYyQ29twNhlmI2WWqMAf9y3tHy
         2qPxPzDtjrnuDRSfbtSpprC9htBjfo1Gpd8/8C5IcCOyN57k11nsyI13er8OMC6K0xOM
         apkg==
X-Gm-Message-State: AOAM530ssn6Aym4YmNRI/eQAWG3EwzXtRBgrfLN5snyGLjcRnWNfZx09
        MtS+o4GFxq8AZYgImORMAXaJtIMl9O0Eg7QVZhiP3O01FehiFNEd/yKtFNn5Lmnw4Zee6DkSe4u
        sV7V2QTv5qEYkpbZZr6CM
X-Received: by 2002:ad4:5c6e:0:b0:443:be74:bf4f with SMTP id i14-20020ad45c6e000000b00443be74bf4fmr36345655qvh.56.1649871847018;
        Wed, 13 Apr 2022 10:44:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6qDkCVZF2xBimrYlxE7+tvGQ49qgUg5k9fHbPKLYjtqXPeYhnwnPcatrObsjfX1jufen+RQ==
X-Received: by 2002:ad4:5c6e:0:b0:443:be74:bf4f with SMTP id i14-20020ad45c6e000000b00443be74bf4fmr36345643qvh.56.1649871846835;
        Wed, 13 Apr 2022 10:44:06 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d2-20020ac85ac2000000b002e1cc2d363asm30212741qtd.24.2022.04.13.10.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 10:44:05 -0700 (PDT)
Date:   Thu, 14 Apr 2022 01:44:00 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs/216: handle larger log sizes
Message-ID: <20220413174400.kvbihaz6bcsgz4hy@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <164971769710.170109.8985299417765876269.stgit@magnolia>
 <164971771391.170109.16368399851366024102.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164971771391.170109.16368399851366024102.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 11, 2022 at 03:55:13PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> mkfs will soon refuse to format a log smaller than 64MB, so update this
> test to reflect the new log sizing calculations.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/216.out |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/tests/xfs/216.out b/tests/xfs/216.out
> index cbd7b652..3c12085f 100644
> --- a/tests/xfs/216.out
> +++ b/tests/xfs/216.out
> @@ -1,10 +1,10 @@
>  QA output created by 216
> -fssize=1g log      =internal log           bsize=4096   blocks=2560, version=2
> -fssize=2g log      =internal log           bsize=4096   blocks=2560, version=2
> -fssize=4g log      =internal log           bsize=4096   blocks=2560, version=2
> -fssize=8g log      =internal log           bsize=4096   blocks=2560, version=2
> -fssize=16g log      =internal log           bsize=4096   blocks=2560, version=2
> -fssize=32g log      =internal log           bsize=4096   blocks=4096, version=2
> -fssize=64g log      =internal log           bsize=4096   blocks=8192, version=2
> +fssize=1g log      =internal log           bsize=4096   blocks=16384, version=2
> +fssize=2g log      =internal log           bsize=4096   blocks=16384, version=2
> +fssize=4g log      =internal log           bsize=4096   blocks=16384, version=2
> +fssize=8g log      =internal log           bsize=4096   blocks=16384, version=2
> +fssize=16g log      =internal log           bsize=4096   blocks=16384, version=2
> +fssize=32g log      =internal log           bsize=4096   blocks=16384, version=2
> +fssize=64g log      =internal log           bsize=4096   blocks=16384, version=2

So this will break downstream kernel testing too, except it follows this new
xfs behavior change. Is it possible to get the minimal log size, then help to
avoid the failure (if it won't mess up the code:)?

>  fssize=128g log      =internal log           bsize=4096   blocks=16384, version=2
>  fssize=256g log      =internal log           bsize=4096   blocks=32768, version=2
> 

