Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_20,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6041CC433B4
	for <linux-xfs@archiver.kernel.org>; Sat,  1 May 2021 00:33:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DE5561409
	for <linux-xfs@archiver.kernel.org>; Sat,  1 May 2021 00:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhEAAd4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Apr 2021 20:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbhEAAdz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Apr 2021 20:33:55 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DD1C06174A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Apr 2021 17:33:05 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id g65so5445wmg.2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Apr 2021 17:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=euro-domenii-eu.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=82PDRBs0XKckXF74x70d0wTn64MSRalxHDR0T/1iSBU=;
        b=bgtWr0yULimoUohWZBT3+VV2JH16XNZ7sX7bv70HVcd6pptJniTpbdRky9WWJZSFkZ
         NHzWQB4QiBUBntcqv8MtbknLYfMOziYAI2kEKWgxUiIQSvXaoK8z0bb4QwR3Xv8xg6iB
         qFBJNz/s9cAheGd3QGX9WB4lFIWMNN/bbCI0QNJAUV5kxzYkY33NK/I4le4OcKYkEix2
         4gywMlehoCSk37LWM0CnW81Chf3R1upI4I1OIGtWXFo5XVhG4cMpFPAAq0W95nWTvrsv
         fvbtDJuoDLJ/3R1KNGHkvel6FyVDgdFe10ZAQH7SjCqRGqIVB84jqAn4utch8x3seMXM
         mKGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=82PDRBs0XKckXF74x70d0wTn64MSRalxHDR0T/1iSBU=;
        b=irxjT14CNy3wW6B1mCJDghU/LIWClBoWhv3S/0Tg2t9oddLlxRymqiZsEYAF55HrbS
         MPcRIJS7YFJjNXpBcxhCEDFaiJeVZfL4jvQm/PTWkwfDgTuZtVgBCGiix7J0mYnLW85b
         VuY2EtuXFYE7E/8LalZvaXtvdyu85F6YXDBPZ2PalUcClr4nWwzUWMM0fPtDVG5oYcKp
         PDkkEVQAOLkOzin/rLbVIkfltxajMHYk9ZaMoSMYcGrM4QROrNYe1xlLoImgpNvtJ5Sd
         J+rw9659UAuF7NxwzXZFPuK1ZOkwyV02weZJ1s+Z8O5v1s4Oq53WbXs65KyxZxzsgo5X
         6b5Q==
X-Gm-Message-State: AOAM532SGgpz4eQwRzqBAjJqX67PwmB6JzZ/RFrqQDVeFu3NQdVqBSBv
        TlrXzT2O7iSDC3Ryb/qO3ODmUFTgJBeGJdsKQqpQogecCb0=
X-Google-Smtp-Source: ABdhPJzF6HHOM3CimIguMU46u9pF4Nlw0AdyNEJL2ZyOlUbqu3OmNSMwhjfz0hT+RdiC7GdyQhN6WKLdp6fu1QaVq7Y=
X-Received: by 2002:a7b:c5c8:: with SMTP id n8mr9060536wmk.2.1619829184324;
 Fri, 30 Apr 2021 17:33:04 -0700 (PDT)
MIME-Version: 1.0
References: <CADw2znDxTQX4+GzrYqc6RefL5tcDwdKb0Ppyen8sFMn2fDr1zg@mail.gmail.com>
In-Reply-To: <CADw2znDxTQX4+GzrYqc6RefL5tcDwdKb0Ppyen8sFMn2fDr1zg@mail.gmail.com>
From:   "EuroDomenii .Eu .Ro Accredited Registrar" <info@euro-domenii.eu>
Date:   Sat, 1 May 2021 03:32:52 +0300
Message-ID: <CADw2znDLs6_yky6EHoxmE2P7fRcjoKmYamWnNWj=V+9C_OyD6w@mail.gmail.com>
Subject: Roadmap for XFS Send/Receive
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

What is the roadmap for implementing  Send/Receive in XFS?  I'm
talking about the send/receive feature between snapshots via ssh, from
ZFS/BTRFS.

Searching the lists returns no results:
https://marc.info/?l=linux-xfs&w=2&r=1&s=send-receive&q=b
https://marc.info/?l=linux-xfs&w=2&r=1&s=send%2Freceive&q=b

Thank you!
Iulian- EuroDomenii
