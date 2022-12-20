Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B069CC4167B
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 18:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiLTSSl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Dec 2022 13:18:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiLTSSk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2022 13:18:40 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D916ACE07;
        Tue, 20 Dec 2022 10:18:39 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id n3so9046540pfq.10;
        Tue, 20 Dec 2022 10:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UddUljXkgTazwaNyMbwrgf9pQXRLrrX5SishkuS0MYc=;
        b=eHGbf1JQEcG7vfkGFQcXc1rnMC2zpSwho5gHVnxIA/xnR5sNfaYwMNF2/zktZ8Lc81
         sl/13el3xrLNvSfPWd/9E218SrazdSJK9wmRQs7uB9ulOqEfgMQVdwtVs+a5jalBjza/
         ZBR54+jXwzgDefRlVbePnZhBGyXqeR98eUsnF6TEpEQHOGxyAY50lidhQQ5nUHsoVlUy
         GFXOfg9YNWhY8Vdv0t7HXtxXCAiSAY2TtaZu6vythwjHv7Fws+S3SnYv3oJ2QR1nkO6/
         1EycVePq2UWzzSSVHXtl0nNvOLHu1zUiMlvqlBbzIjPSwVpDyxcuWretUB6NBAdMiaJJ
         SgAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UddUljXkgTazwaNyMbwrgf9pQXRLrrX5SishkuS0MYc=;
        b=q1iIR83C6+esiFC6IIbl0VWWGxJetwMdEQLUEcB1AiOa/M8SZSq82FOD8HPPfSznS5
         0Tgoo1ws1Izryva6REz9Wpt3nQQ3Rl+g86BA7V9TNiBTiDrMxKJGrob+VQ3IgmCvOVWh
         UIrht8bzT2+0YwImYec5mSSXOZ+kgxdjHw5ROZE+ta1rmdYWT8s8cL7P6nhgRTiYpnbd
         ZzSDOyzxRjNsaUDnPEzDMjsru/lRCIYCRu29c7cM8YvvN2FN12ygsf8kk3g5efbyo42U
         Z7hOvlTUJ7Y2vEE4IVx8SR5V1dKvYbGLvhA/TrDsyKsnfBSLhcePFmAhlq/24N5w7y8s
         BIrw==
X-Gm-Message-State: ANoB5plkKCbC2w4TolNwU7Ja8ISUQhtFNWswaImJUmzkjkKF3Uk5bcXp
        HNZ7AzAk9hRPxTnat/YjqpV/egV0EJldOw==
X-Google-Smtp-Source: AA0mqf75xI0rqlINVZ8vjrOMJTzMpJ/NcMM1U76f/KFiPfFFuYqp5DCJwbR+TxJ9ZSzdJJwmzSLBxQ==
X-Received: by 2002:aa7:920e:0:b0:566:900d:a1de with SMTP id 14-20020aa7920e000000b00566900da1demr45890448pfo.26.1671560319088;
        Tue, 20 Dec 2022 10:18:39 -0800 (PST)
Received: from google.com ([2620:15c:2c1:200:fac5:a5ac:32b5:38ad])
        by smtp.gmail.com with ESMTPSA id k5-20020aa79985000000b005623f96c24bsm8948155pfh.89.2022.12.20.10.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 10:18:38 -0800 (PST)
Date:   Tue, 20 Dec 2022 10:18:36 -0800
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, zlang@redhat.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        quwenruo.btrfs@gmx.com
Subject: Re: [PATCH 1/8] check: generate section reports between tests
Message-ID: <Y6H8fA5GD6tz0Lzi@google.com>
References: <167149446381.332657.9402608531757557463.stgit@magnolia>
 <167149446946.332657.17186597494532662986.stgit@magnolia>
 <Y6EpG8cpQDH0XuGz@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6EpG8cpQDH0XuGz@mit.edu>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This was actually an alternative proposed instead of moving /tmp to
/var/tmp [1]. I applied this patch last week in place of the /var/tmp
changes and it is working well with my setup! It is actually nicer than
the /var/tmp approach as I don't have to do as much xml formatting in
gce-xfstests.

- Leah

[1] https://lore.kernel.org/fstests/20221212230646.4022294-1-leah.rumancik@gmail.com/
