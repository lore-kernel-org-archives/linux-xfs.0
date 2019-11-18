Return-Path: <SRS0=mMHn=ZK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BEA2C432C0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 10:59:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4F7C2073A
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 10:59:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QZ8+hRo+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfKRK7p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Nov 2019 05:59:45 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43141 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726490AbfKRK7p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Nov 2019 05:59:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574074783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XZLLjNZz7PGc6ccOCNMERiPvfDcvusW6kIdO0GUv4AY=;
        b=QZ8+hRo+lWyW4JAJCIrIUP28nwFq47iVZqZ9JN28R8mpkCJcwuPGIyrmPBV/WvvSDxEfyI
        dDF4SZptsc86XZlqmMT/l0OHxfc75eo37uukmhBvVJJ2toBW2xKOusUC0S6lBH8pSwB/xy
        XhiShEoRIu42PjYxrUIUHa/32xGidy8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-ELopIZA1MUWGU3HG1QnciA-1; Mon, 18 Nov 2019 05:59:42 -0500
Received: by mail-wr1-f72.google.com with SMTP id n11so2795850wrq.5
        for <linux-xfs@vger.kernel.org>; Mon, 18 Nov 2019 02:59:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=wTaFxpVMQmckpiNciv/a2kW+3/dAiqXImRU+NIg7Ob4=;
        b=WbYwPt5ZbCTtDeDSNtwRXvyU8pVb1pdgkiDOrcpCd+vQxJHshiEjAYuq6uBhk/VYHA
         o52Gg8+aQAkb6VJve9stJg23pyzPNqa2nF48Qm/qu/dlVWWX8T0//h1hWNQAMfEv43L6
         esfR7QjWI1r66mB2TbsC0NhmT0ciGG093zMSwcqvvltZBX646iqeL80uRaAK9gaV4zk5
         JrbTcu/Q39TvYnoM4ry54LpbcHWxOmDUZAiccB2nsTW3MMCkeo3Za3FKoJDFrM5uu+Gz
         Pzymd58F6jefy9J4ugvYanEFt7BnpJQe0F/K57Ld5ocSTuB14ms9SbrLZcEMpGDjoHnZ
         4i7Q==
X-Gm-Message-State: APjAAAVcgFYxC30SnKg7ndSG8PZpEGxiOT5qeM/IZlHToWxdJNC6j2xt
        4v7KybPZaAKn6DKHrk2p49ZrDbeKO4BiaKBrcwb95PoRSNUNPuAqorSiiZVTTNKez6iNjbuQGMa
        5x8tkfeberNazunQ4mHF0
X-Received: by 2002:adf:f489:: with SMTP id l9mr27582493wro.337.1574074781329;
        Mon, 18 Nov 2019 02:59:41 -0800 (PST)
X-Google-Smtp-Source: APXvYqx1nShLA1c9N+buNGwVDaZzD4BI+AffzBLIyYahWab8v2IUICuF6uMxNxl9asRhNvR1K5gDDg==
X-Received: by 2002:adf:f489:: with SMTP id l9mr27582477wro.337.1574074781128;
        Mon, 18 Nov 2019 02:59:41 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id a15sm22360392wrw.10.2019.11.18.02.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 02:59:40 -0800 (PST)
Date:   Mon, 18 Nov 2019 11:59:38 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfs: actually check xfs_btree_check_block return in
 xfs_btree_islastblock
Message-ID: <20191118105938.qjltq52nibcmqvp7@orion>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
References: <157319668531.834585.6920821852974178.stgit@magnolia>
 <157319670439.834585.6578359830660435523.stgit@magnolia>
 <20191108074724.GR6219@magnolia>
MIME-Version: 1.0
In-Reply-To: <20191108074724.GR6219@magnolia>
X-MC-Unique: ELopIZA1MUWGU3HG1QnciA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +/* Does this cursor point to the last block in the given level? */

I think this comment is unnecessary tbh, the function's definition looks pr=
etty
clear to me already.

> +static inline bool
> +xfs_btree_islastblock(
> +=09xfs_btree_cur_t=09=09*cur,
> +=09int=09=09=09level)
> +{
> +=09struct xfs_btree_block=09*block;
> +=09struct xfs_buf=09=09*bp;
> +
> +=09block =3D xfs_btree_get_block(cur, level, &bp);

And here it might be useful for the future, to remind us why do we check it
inside an assertion, something like:

=09/* Caller is already supposed to have done a lookup/seek op */
> +=09ASSERT(block && xfs_btree_check_block(cur, block, level, bp) =3D=3D 0=
);
> +

But, these are just nitpicks, and since I didn't see any review on this pat=
ch
yet, you can add with or without the suggestions above:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Cheers.

--=20
Carlos

