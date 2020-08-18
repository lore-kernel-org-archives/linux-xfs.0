Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E17C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 11:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1853A207D3
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 11:26:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gzG2wGep"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgHRL0I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 07:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbgHRLZ5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 07:25:57 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BDAC061389
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 04:25:05 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id g19so20761632ioh.8
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 04:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1yCF66dPCE3X0RgsAaG/3fewW+UzY9MdS4Pt/N7caao=;
        b=gzG2wGepp+KtHmeIjx+mQsOkzE6jtOCaeqdC7gL+mDShkNCQ2ROSVBR/uDINHAb2CH
         rdOHD+FNZlB2uSsR2vHPAAI7HJtso3ShohfBZ9zdzac1hCCYNHTKSaHYIN60lMj1l8xR
         o2HLLsua0xBqIdkCIneImMjJgn8qklCz7/O2xv/jtCePvW8DaRPt7H5tA3lerguxF9NL
         JhVcFtx5ZN2IvsCJIOPawcmtwuQRENxseVjQ1Le552WYI25ArnxdSFoXTRn5xhQ6N+UZ
         QNuqYyhcAwjZBN4MmQowpFcq32mpYc8S56ZjN5wsstXJIH3hXRp6kcOi8uAH1qHB76Pc
         WsVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1yCF66dPCE3X0RgsAaG/3fewW+UzY9MdS4Pt/N7caao=;
        b=so4rRiieoDxBgceLebYw5NFwKcJsVp8wa5YjPuZiTqVLeqsMUP037flWaSZIe+No0w
         dSSFVgMHCNNR4/5j5eAXTZ9nT9gNFs6VgmgBbjCaMzw6Et2AL2zys9ugNuVLy6bq7ZD5
         92nNGKUkKNnW7Zl8UJdy7PJ8kuj2OhObawYxIk7jlFEo1aYEvk6a9zet+X5tD4Av+qf2
         s0b5EME86X7XnyIIL6vRsTaKDXfoLHFjliCPte/5BnLZCIJh5Zlv24ZqjwYLGWkoAKkp
         o+sC8OzrF/mMdS8oNBpwRkv+NhhRFRjRZMzJSLjiJMEU8hcPUA2bmaboL8A1spda+q3r
         tEzw==
X-Gm-Message-State: AOAM5336aIOACV6WRCdhthHu/azS5Sf3lskZqgOvj83FCpM4bgthLLlf
        z/7Pds6Ne+CK7w5k6ptSyE5G1IGNO4kmgWVxXfw=
X-Google-Smtp-Source: ABdhPJxgo4xFHiudyJ6WgyybBHkNKpanEQk7ZoCdDDyzRgKL+bmq/JwnsV5afEoapfdvds6kaaBQKkh/VSzdGK17ccc=
X-Received: by 2002:a05:6602:1d6:: with SMTP id w22mr15826577iot.64.1597749895783;
 Tue, 18 Aug 2020 04:24:55 -0700 (PDT)
MIME-Version: 1.0
References: <159770500809.3956827.8869892960975362931.stgit@magnolia> <159770505260.3956827.6046629630710794322.stgit@magnolia>
In-Reply-To: <159770505260.3956827.6046629630710794322.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 14:24:44 +0300
Message-ID: <CAOQ4uxh5FpEZDqFBuKDGwKqk7-QK6mvB7Uw-Dp6Y-uev6DtzeA@mail.gmail.com>
Subject: Re: [PATCH 07/11] xfs: convert struct xfs_timestamp to union
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 1:57 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Convert the xfs_timestamp struct to a union so that we can overload it
> in the next patch.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I guess we could have kept xfs_timestamp_t and friend a bit longer to
avoid this churn.
Oh well. I guess the agenda to remove those typedefs is strong.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
