Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2CF8C678D5
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Mar 2023 15:28:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbjCGP2P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Mar 2023 10:28:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbjCGP1u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Mar 2023 10:27:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADED154C9B
        for <linux-xfs@vger.kernel.org>; Tue,  7 Mar 2023 07:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678202686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=49sjefw2FKulo5Vz5tQGPSxZQZKzbcJ05HQTQwuGmNA=;
        b=AKM3GQrpCakE5r03nsdFcj+uvMJx3pRA379pgUaTJio+2DNvP9iKQ+/giEKqU0Ve9pJPXQ
        Rd+PXnr1+BEbc3yhrDRMohtkrtt+4yvz2e5zflQY9S9JH1dU9KsqpkSsWkl0/Q0Mt/RRGr
        6k3yWInBHCk9CK3OTxO1glaBLsIzOZo=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-573-YdU9YBQfPXGHQ5mWyNn6jQ-1; Tue, 07 Mar 2023 10:24:29 -0500
X-MC-Unique: YdU9YBQfPXGHQ5mWyNn6jQ-1
Received: by mail-pf1-f198.google.com with SMTP id h14-20020aa786ce000000b005a89856900eso7368712pfo.14
        for <linux-xfs@vger.kernel.org>; Tue, 07 Mar 2023 07:24:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678202643;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=49sjefw2FKulo5Vz5tQGPSxZQZKzbcJ05HQTQwuGmNA=;
        b=bAT9Yt8sDYHaFloFUCwfn6O0rQpFBv7zLnOjwoDZ7cICMmoz1RczpHN1Ay1Le1Bld1
         k8cpH/cFSFcwQXOMSFZAnTVIBfWEnXAxdXRlDoFznZzVOetrxZh0dsrs9VlBQDAPvq+Y
         Gx6UddnxmeUtzYPIEvQu124uA8PyeeojYBMA/uFSi97dQsB44FAm9lZtIruSMZv30oOr
         l7ge38vXlVLvy+IR3lMaBlYQ8/tU75K5KLsbVW+xWoyjsgmnylLaD5vl8avHguFUbD2L
         FLX3FqLYk6bKR5AjX535CXUrjvN4uWxPmQlfyhyrN/YYTeZ8AtI7U/u0T8B4iuzunppT
         pXiw==
X-Gm-Message-State: AO0yUKWXOyhw+ds3vNbvUZeJs6nFRKvmthylmDZQPez6jf4astqFPJ2J
        aL8BA2R5YgCPkTnYU4ujbX931b8cZpuH+UMo3NaveHCkmcpMRQGYw1GVdh55sb8ny8cXfDLASqo
        GKHvHe2BgIlxHI/jj7BE9qn7CF7WEK7ZESgtUFS3GPRA5
X-Received: by 2002:a17:902:f812:b0:19a:f153:b73e with SMTP id ix18-20020a170902f81200b0019af153b73emr5668637plb.4.1678202642960;
        Tue, 07 Mar 2023 07:24:02 -0800 (PST)
X-Google-Smtp-Source: AK7set9SWy5O05m3x1Ey9TSLMznr1jfUxFnvxAX39KEBXqqmaUx44UhyFFrhNGEtwClSqvzd8jjgUVc0X6h/fPAWheE=
X-Received: by 2002:a17:902:f812:b0:19a:f153:b73e with SMTP id
 ix18-20020a170902f81200b0019af153b73emr5668618plb.4.1678202642668; Tue, 07
 Mar 2023 07:24:02 -0800 (PST)
MIME-Version: 1.0
References: <20230307143410.28031-1-hch@lst.de>
In-Reply-To: <20230307143410.28031-1-hch@lst.de>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Tue, 7 Mar 2023 16:23:50 +0100
Message-ID: <CAHc6FU4G5S+5S+1OdatY3apQvmDcvzOQSPPPQdQZTwMNjSq5tw@mail.gmail.com>
Subject: Re: [Cluster-devel] return an ERR_PTR from __filemap_get_folio v3
To:     Christoph Hellwig <hch@lst.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Hugh Dickins <hughd@google.com>, linux-xfs@vger.kernel.org,
        linux-nilfs@vger.kernel.org, cluster-devel@redhat.com,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 7, 2023 at 4:07=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrote=
:
> __filemap_get_folio and its wrappers can return NULL for three different
> conditions, which in some cases requires the caller to reverse engineer
> the decision making.  This is fixed by returning an ERR_PTR instead of
> NULL and thus transporting the reason for the failure.  But to make
> that work we first need to ensure that no xa_value special case is
> returned and thus return the FGP_ENTRY flag.  It turns out that flag
> is barely used and can usually be deal with in a better way.

Thanks for working on this cleanup; looking good at a first glance.

Andreas

