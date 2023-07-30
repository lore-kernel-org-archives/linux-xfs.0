Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCE91EB64DD
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Jul 2023 21:20:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjG3VU5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Jul 2023 17:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjG3VUz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Jul 2023 17:20:55 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF011702
        for <linux-xfs@vger.kernel.org>; Sun, 30 Jul 2023 14:20:54 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id e9e14a558f8ab-348ddac3a09so11917785ab.1
        for <linux-xfs@vger.kernel.org>; Sun, 30 Jul 2023 14:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690752053; x=1691356853;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KhTolnCocAxyFCFw7rnwURcA52cfHVUJDAm5DfAGrMk=;
        b=EiIr1zcoHCePS7rbucfQpr7KQhCXNi2/DL5iDM2MB8HWpuOhBYiL3L1AxszltGOMHW
         m5DizIBHeQehIDoyXp58ojF0PwkF53LEam5CyG4DgvbUU7oyafjKk+/OC2cmUz+1W2A0
         raXjUtJQrcOwVrHQJSHFiXfQjRHCRUWPPSRUHJ2Tf8Rq7NkOtBJdcx98QqeWEhHm2lAe
         1FoJhA3uCbdRoqy3/ERhmS/ZKuph/OFu0PY4KNwMobo+uiiqhoJrekIef47F3jPd847L
         bhLebIedlzh76I11FjXOOjUevQP7icLgvFEdWh1c9RBhSxgSpfuqZDngx7IS9MhFSpyQ
         LZ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690752053; x=1691356853;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KhTolnCocAxyFCFw7rnwURcA52cfHVUJDAm5DfAGrMk=;
        b=HboS2m3ihS/85WV8XBEnU9JJS/7bBCOGC7ksFPAzCzfS5pii+vLkowfOv7uIRztBJQ
         wn9BNQaR6n/nsdqQklxiYmL2Y0tc8t2xrMFMKI8FHDGv98+NpHKo3gXHlXxm29AnBUDk
         kyR5iY15LTagYJuw5wHLHxrc2Zubi5u24RgW5WcRMjwbpdLF7Tk9MPE5xJty35dP7Rnp
         AdZJRGNF6yZlD1wwjVtQpsykCLJWZ3MYnIJKNGgbGpekYjAQF4mOkD4t0nfw5rrXXHyX
         JPMccnaKgZDYdtkS2mS//PXe6IXWnbskz/7ofVZkVGDvKtWCoxppvtfLksW2NnKMTUxo
         AwsA==
X-Gm-Message-State: ABy/qLb+rOL+B7kTbj2tODduhZ7v/LdfQtSivTNRsqNdEUXNaAfgSQj5
        wG2H8DteeYkCyjuPPQhKolwACPAkKNdpMmreaGBnzA4yywo=
X-Google-Smtp-Source: APBJJlFTlW75NSco1naaW6XwCFUJK58TOdJoNDwEbDtnUp/x6s3aIYI5P0xjD1KxqfA/VSt6/wN3iQkqDwLGCEbgLo4=
X-Received: by 2002:a05:6e02:1a47:b0:345:fe2d:56f with SMTP id
 u7-20020a056e021a4700b00345fe2d056fmr7370976ilv.14.1690752053535; Sun, 30 Jul
 2023 14:20:53 -0700 (PDT)
MIME-Version: 1.0
From:   Shawn <neutronsharc@gmail.com>
Date:   Sun, 30 Jul 2023 14:20:17 -0700
Message-ID: <CAB-bdyTUFfLw2O80h67WGkok1hM0PKrsjCR_wdMzALQWqi6rrA@mail.gmail.com>
Subject: how does XFS support gpu direct storage
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello all,
Nvidia document explains that,  in order for a filesystem to support
GDS (gpu direct storage) the FS needs to make a callback to
"nvidis-fs.ko"  to translate a virtual address to GPU physical address
for DMA.   However I'm unable to find the callback in XFS code.  I'm
curious how can XFS support GDS without calling nvidia callbacks?


regards,
Shawn
