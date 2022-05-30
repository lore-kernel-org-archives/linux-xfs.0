Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4DBAC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 30 May 2022 08:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiE3IGp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 May 2022 04:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232713AbiE3IGm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 May 2022 04:06:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8F34CDBD
        for <linux-xfs@vger.kernel.org>; Mon, 30 May 2022 01:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653897992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=FANm1doqZnuvQp8dqoXUwCaygSCiGRLAv8O5pwgkd1I=;
        b=Ry8EkZgojbXzbgmiK8FcRFSy9WkYMxDqBf1+1ncGx0DX3PmXB0jwQANG98DER0yEMmstFp
        4fR3ShFV7aVzLUAjuaz5nPbm89LmJ6sOq742rnLUUD1GJBE8NeA4/D7YR4HOCkbciObD8V
        OG7KeAvi1nUtW+V8T2Q8L0di6tfdcO0=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-QkAcy7D2N1W_gGw1g4fvDw-1; Mon, 30 May 2022 04:06:31 -0400
X-MC-Unique: QkAcy7D2N1W_gGw1g4fvDw-1
Received: by mail-qk1-f200.google.com with SMTP id o18-20020a05620a2a1200b006a0cc3d8463so8240169qkp.4
        for <linux-xfs@vger.kernel.org>; Mon, 30 May 2022 01:06:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=FANm1doqZnuvQp8dqoXUwCaygSCiGRLAv8O5pwgkd1I=;
        b=LiQG4hQSgQBBvmbKkrhYRfAguuXKPfBSC2013/Uyv/ash7WQeBo01Jk30RYbvq9El4
         F3GEnuVKBb/ObVxYYyqzHm2toP+YuMiRpNAMf+fzBVv0H8bZ9oAp0h4gPjImLtnk88gA
         GU2xut+CWsJiMEx5a54RPQALk7kbTX/x318NGZz5VUP7hAsSzldq5yNxTlK9CCRPxcPk
         Re9vBSEA3Zgx4QJdAOxBFRSozfNCO/GhjNM4zW3QS7yNhJpWdCVQkRewL5nWqrXyiZMV
         AbF5F2tJCksKJ8CWVBV4OU4FnzzV9BZZfxLoN/UUPedKJ9fpCp46JxGJlWSZDvSy4KnK
         C0Xg==
X-Gm-Message-State: AOAM533hUUCKhNHMkw2CFIw2sB2imabUMV7FPlEpdXPeO97lRqZqWckg
        S/Cbw9O6fzjgU1Sgrt2UAZTsM4tK8k2hvgQhWKO5Qqo47+4meb7KCRkecACjPV8Gsl0wSi3Sp2/
        rGpC4Jvzd4oROftyv3FDR
X-Received: by 2002:a05:620a:1999:b0:6a3:9689:a673 with SMTP id bm25-20020a05620a199900b006a39689a673mr25290033qkb.209.1653897983113;
        Mon, 30 May 2022 01:06:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwtUPQf7QR5FM8wxuF5OVRrZVbK4JcSC+4x2oKkmbJnqwcopcmaJy1biTf/RjE44gViBJnag==
X-Received: by 2002:a05:620a:1999:b0:6a3:9689:a673 with SMTP id bm25-20020a05620a199900b006a39689a673mr25290026qkb.209.1653897982871;
        Mon, 30 May 2022 01:06:22 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 2-20020a370802000000b0069fc13ce204sm7173565qki.53.2022.05.30.01.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 01:06:22 -0700 (PDT)
Date:   Mon, 30 May 2022 16:06:16 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     linux-mm@kvack.org
Cc:     linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Potential regression on kernel 5.19-rc0: kernel BUG at
 mm/page_table_check.c:51!
Message-ID: <20220530080616.6h77ppymilyvjqus@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi mm folks:

I reported a regression bug on latest upstream linux:
https://bugzilla.kernel.org/show_bug.cgi?id=216047

It's about xfs/ext4 + DAX, panic at mm/page_table_check.c:51!

  static struct page_table_check *get_page_table_check(struct page_ext *page_ext)
  {
==>     BUG_ON(!page_ext);
        return (void *)(page_ext) + page_table_check_ops.offset;
  }

It's 100% reproducible for me, by running fstests generic/623:
  https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/tree/tests/generic/623
on xfs or ext4 with DAX enabled.

It doesn't look like a xfs or ext4 issue, so send to linux-mm to get more
reviewing. More details please refer to above bug link. I changed its Pruduct
to mm, but the Assignee isn't changed by default.

Thanks,
Zorro

