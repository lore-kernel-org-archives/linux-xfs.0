Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E179FC433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 13:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BBEF6103E
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 13:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236591AbhD0NX1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Apr 2021 09:23:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50423 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235875AbhD0NX1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Apr 2021 09:23:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619529764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rHJbEZ/DyYv3vK/bW2o4so2u3V4sQX6iAsquDqNK7dw=;
        b=OB/GcOtU8svGFjv4kkdBbp/Xa2gb8Diq19IA5Zq45qe9ZLlDCeOGPQ3lRzUYl5ftuIfviy
        BwKN82X0I2FveBMd0iJYlga6fCLPkdUTpW14J6ar+HmWfIGPD3kcxrHsAkMIC2f7mFQQwD
        BRHBkZ/bXRNPSztjSdPP0mzbJU/pBBY=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-sZrB7AzLMQCg7zozAUZi-A-1; Tue, 27 Apr 2021 09:22:42 -0400
X-MC-Unique: sZrB7AzLMQCg7zozAUZi-A-1
Received: by mail-pg1-f198.google.com with SMTP id i8-20020a6548480000b02901fb8ebd5714so19623589pgs.12
        for <linux-xfs@vger.kernel.org>; Tue, 27 Apr 2021 06:22:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rHJbEZ/DyYv3vK/bW2o4so2u3V4sQX6iAsquDqNK7dw=;
        b=TWQ0BPeShEzAhJR6/nxJb91KhDhHN2SKZZTDLXGCTAbCQz+EFG6eZvyRjCCRJYOXqR
         A8Bsa2xyXZMYTcMKkAbrh8aKNZeIJLijVtzDLan2j+udx365w82JgpialPdsf41j2Sti
         NFkl2gorU76aqoWxCTKLcaXinyt08xfsqF3VU7dcOhZoUbzK2HvkwwE34QBUVXNXzev8
         l0mQ/5TtiDrA7WjF2rTamLep2/qrF7VI7SmFhpKpj7ZIZRmT91YnzyhF+5n3LnhT/tsN
         lA7DecqtZnf3zED2Q70pWoJ3PJMirCETcx8k8BHMaDR6WZK+nydMJQs/C0ElLBQCFHEz
         pv5A==
X-Gm-Message-State: AOAM532LGB4Uj81omvs82GgF0zlA+i0DnagaToHbiiYoOm0UihSGxZG/
        9p9R3k04/pZ/nVoTyWXLNeQqBswM5PahDDvJNa5gJNz2G+HKD4DIjCIus3Nf6a3uD26K5rQ0CUU
        E87Ijhu90EAPGOdui0ntx
X-Received: by 2002:a17:902:b683:b029:ed:f0d:5cff with SMTP id c3-20020a170902b683b02900ed0f0d5cffmr14638089pls.10.1619529761076;
        Tue, 27 Apr 2021 06:22:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxhYzaPNya3yMuJER/APMOvVpp2Kyj5lkJClTLmFl57+IAnExwgtHnHEHwJLFchkeNtt6Tqlw==
X-Received: by 2002:a17:902:b683:b029:ed:f0d:5cff with SMTP id c3-20020a170902b683b02900ed0f0d5cffmr14638067pls.10.1619529760844;
        Tue, 27 Apr 2021 06:22:40 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y3sm2321373pjr.40.2021.04.27.06.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 06:22:40 -0700 (PDT)
Date:   Tue, 27 Apr 2021 21:22:30 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs: count free space btree blocks when scrubbing
 pre-lazysbcount fses
Message-ID: <20210427132230.GB103178@xiangao.remote.csb>
References: <20210427030232.GE3122264@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210427030232.GE3122264@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 26, 2021 at 08:02:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Since agf_btreeblks didn't exist before the lazysbcount feature, the fs
> summary count scrubber needs to walk the free space btrees to determine
> the amount of space being used by those btrees.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Don't look into scrubbing code too much, but the code
here looks fine to me:

Reviewed-by: Gao Xiang <hsiangkao@redhat.com>

Thanks,
Gao Xiang

