Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5073DCCA47B
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jul 2022 07:14:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiGKHOP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 03:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiGKHN6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 03:13:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C2F421E3C7
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jul 2022 00:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657523450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3H5coyJVO7u8mGDgPyiKEDOGJFdMHmm1SWJHQJ6yVso=;
        b=K45nTFmkfHYQF0+4hnb+rOzpO/EHGwQMTOlOo2FHSO3KLETbDcPGKP+jZ/bSJ0pReAW0m3
        JQXMLjA7K49mrJ06lps6g1lesQyeHX8Q4RgdJOPo8XdFnZjRM2BhA/fELogpnVHgxKtcsw
        txgrid599Y+A8TK/ytJ59DLd4qKkskg=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-BN3K_TfCOyCVHhzqgViF0w-1; Mon, 11 Jul 2022 03:10:48 -0400
X-MC-Unique: BN3K_TfCOyCVHhzqgViF0w-1
Received: by mail-qt1-f197.google.com with SMTP id c17-20020ac85191000000b0031eb643cf51so1110477qtn.0
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jul 2022 00:10:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3H5coyJVO7u8mGDgPyiKEDOGJFdMHmm1SWJHQJ6yVso=;
        b=jYJIW8MWfpt9g4W9E+zLBf4CaPPRq1b4VceN99E1bfyP/81JGLAYBYEKyPFk1S0F7/
         NcZc+S+EdYAH9odP1cJTQtACnk0s2Rb4QXHx4LlkkQRl/tdp78gw50fV2MzJ0Ovp344+
         MSJI52mewnHK1ZJaCMsvBk9DyaGdpWAv2Jq4K3/IXpED1y7RbLEYWhdHL7pBOGmhVmbY
         CYS6b2p7PH41c1eCqmtafzOKrYV7BUQ8RKdixbDqBkw8uKeAnJNsHr/0eYhkMf2yCtx9
         7iVOxnI47pciUrurRF3ul+Y8Qbm4Lz6WmC5HK6RtprwwnIc3bu9JjI2hcLkLuohOpN1+
         aF5A==
X-Gm-Message-State: AJIora/TOFI9PLOSktj8Mx1HniFyhYf70YMRtySwV1z02+bXTia6dyZD
        uBZKg3c/iE75ROCPj3fESbARxMtNFICe7TiPKoPt2rio6NhdpZWDpSO8a6XuFkw3Hy/s95MZLRQ
        9OsuE63qavKytVirUqG5f
X-Received: by 2002:a05:622a:115:b0:31e:b892:1ec8 with SMTP id u21-20020a05622a011500b0031eb8921ec8mr518754qtw.648.1657523447803;
        Mon, 11 Jul 2022 00:10:47 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sJzrPf1JBI870Kfopi2KwUHPosaND13cQA4scvkFCaayOHvt3kUtOdhfhH4Lt9OR3SH7T+pQ==
X-Received: by 2002:a05:622a:115:b0:31e:b892:1ec8 with SMTP id u21-20020a05622a011500b0031eb8921ec8mr518744qtw.648.1657523447560;
        Mon, 11 Jul 2022 00:10:47 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k4-20020ac81404000000b0031ea15440a6sm4600548qtj.91.2022.07.11.00.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 00:10:46 -0700 (PDT)
Date:   Mon, 11 Jul 2022 15:10:41 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCHSET v2 0/3] fstests: random fixes
Message-ID: <20220711071041.xgeqljfnq6zfi62z@zlang-mailbox>
References: <165705852280.2820493.17559217951744359102.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165705852280.2820493.17559217951744359102.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 05, 2022 at 03:02:02PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Here's the usual batch of odd fixes for fstests.
> 
> v2: rebase against v2022.07.03, add another correction
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D

Hi Darrick,

JFYI, Patch [1/3] and [3/3] have been reviewed and merged. Patch [2/3] is still
under reviewing, and had review points, so feel free to update it with your
other patches together.

Thanks,
Zorro

> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes
> 
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
> ---
>  tests/xfs/018     |   52 +++++++++++++++++++++++++++++++++++++++++++++++-----
>  tests/xfs/018.out |   16 ++++------------
>  tests/xfs/144     |   14 +++++++++-----
>  tests/xfs/547     |   14 ++++++++++----
>  4 files changed, 70 insertions(+), 26 deletions(-)
> 

