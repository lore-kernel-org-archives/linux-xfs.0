Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 048DBC761AF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Apr 2023 16:05:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238961AbjDEQF0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 12:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239054AbjDEQFV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 12:05:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F28E65A7
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 09:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680710661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ezrY1MpbuGn54W85nscQkQabj0tChDh4QyAKrhiN160=;
        b=WZQDHh+of/UYNZ2stDGY9PzROsTjfchHFxGKS5F1+FlDvGBU9IXS5pBpRk9ozdWxSlwwmX
        TteqVqcNE+f5rCMnquCTtvjXuolTGWtyMInBbiCBByk28kx9bAYWk9WMffQrfKlrz5FJyn
        RKiBK6G2l+U0Sen6jfOFJRi15JdcUs8=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-345-uGJL38ypNxClvE_AlRiWyQ-1; Wed, 05 Apr 2023 12:04:20 -0400
X-MC-Unique: uGJL38ypNxClvE_AlRiWyQ-1
Received: by mail-qt1-f198.google.com with SMTP id y10-20020a05622a164a00b003e38e0a3cc3so24544555qtj.14
        for <linux-xfs@vger.kernel.org>; Wed, 05 Apr 2023 09:04:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680710659;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ezrY1MpbuGn54W85nscQkQabj0tChDh4QyAKrhiN160=;
        b=aUVGSog1vajkwaRp4Fb1imrEXLPeuUuKiJUWp38UfJYzZbXl2PPvoTdlgPc1uGBrd2
         Z6AdWkiQE4gFoGavMGxHtN4wUj1zbkrCpI2NtgHCVhM+BzVdxbZMeTcsSpZXcdUsaoQA
         7dtnwN9Z5wfynYr7sLJ/5OCdmIKeojUmr1pUmUWpGwVfvkMu+WFTNeH9sOJ8m+IZrUdE
         ClGOxDrI/FGeniJRCjsvK5LU+0kjdocHvo+9lf45q048poTmyAF+UOuEBzNCfb6tigab
         +tTzXxkBoULycSi6Tk3rcEV4TybK9nwYgX8EnURabI4ibOLt0EUXeSs0gogcvmzlZL6h
         r6VQ==
X-Gm-Message-State: AAQBX9fNK/Knjfg0dreSdnFTAuPSOP347+EMDJV+6hJhUjdZBriopZ3N
        KUDqMv6IhUonvs5/J8OE1fFdPnAzRKoOsYqCICcsQ5OxSUi2EsalwdgU9OpEjo3zjeNRN5MY8CH
        7Lhl4+ScW48sXPALr0pw=
X-Received: by 2002:a05:622a:4b:b0:3d8:8d4b:c7cc with SMTP id y11-20020a05622a004b00b003d88d4bc7ccmr7038052qtw.46.1680710659556;
        Wed, 05 Apr 2023 09:04:19 -0700 (PDT)
X-Google-Smtp-Source: AKy350a5lKksulKGDz1s6x8IlpR6R6JUlCw8aCDbcTRwKrjAxeI/G0vqKKfr43MPgy1YnBz9zPAfFA==
X-Received: by 2002:a05:622a:4b:b0:3d8:8d4b:c7cc with SMTP id y11-20020a05622a004b00b003d88d4bc7ccmr7037982qtw.46.1680710659193;
        Wed, 05 Apr 2023 09:04:19 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id b9-20020ac84f09000000b003e398d00fabsm4083588qte.85.2023.04.05.09.04.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 09:04:18 -0700 (PDT)
Date:   Wed, 5 Apr 2023 18:04:13 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     djwong@kernel.org, dchinner@redhat.com, hch@infradead.org,
        linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
        rpeterso@redhat.com, agruenba@redhat.com, xiang@kernel.org,
        chao@kernel.org, damien.lemoal@opensource.wdc.com, jth@kernel.org,
        linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com
Subject: Re: [PATCH v2 00/23] fs-verity support for XFS
Message-ID: <20230405160413.7o7tljszm56e73a6@aalbersh.remote.csb>
References: <20230404145319.2057051-1-aalbersh@redhat.com>
 <20230404233713.GF1893@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404233713.GF1893@sol.localdomain>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 04, 2023 at 04:37:13PM -0700, Eric Biggers wrote:
> On Tue, Apr 04, 2023 at 04:52:56PM +0200, Andrey Albershteyn wrote:
> > The patchset is tested with xfstests -g auto on xfs_1k, xfs_4k,
> > xfs_1k_quota, and xfs_4k_quota. Haven't found any major failures.
> 
> Just to double check, did you verify that the tests in the "verity" group are
> running, and were not skipped?

Yes, the linked xfstests in cover-letter has patch enabling xfs
(xfsprogs also needed).
> 
> - Eric
> 

-- 
- Andrey

