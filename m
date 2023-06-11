Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3556FC77B7A
	for <linux-xfs@archiver.kernel.org>; Sun, 11 Jun 2023 13:41:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjFKNlY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 11 Jun 2023 09:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjFKNlX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Jun 2023 09:41:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12CD8B8
        for <linux-xfs@vger.kernel.org>; Sun, 11 Jun 2023 06:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686490836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=azMrAV1dNo2SPgDEwbp+86J8I+U94aJA/10rWO5njXY=;
        b=P55id6Khd4bjfMPVfFPPGoyXXbkDk7zOmkp2Pvqx/c6j8BsuwwP5iQed7x+GeKVxTKDRgr
        B/nVIOZBju/yewtPswn0MtNgcaNfSl/L3Y2O3R+tdFzIJteQNuMuQQ6AewgK2n+tx2cnp2
        ujuHEsiQiFMjk1UmJXMFEDBAzWokBtY=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222-jIFzf6trOVmG7NYqE3dDPQ-1; Sun, 11 Jun 2023 09:40:26 -0400
X-MC-Unique: jIFzf6trOVmG7NYqE3dDPQ-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-65fd8267042so2053154b3a.0
        for <linux-xfs@vger.kernel.org>; Sun, 11 Jun 2023 06:40:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686490825; x=1689082825;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=azMrAV1dNo2SPgDEwbp+86J8I+U94aJA/10rWO5njXY=;
        b=aPzmJ53mOhhsXDwhI51ZnLJX2hnoNr8NTIWHoht2MJ+Psh4w+rMK2Ko/AUEtYbmzJa
         Z4w8hH+YHkx22T0WYzHYwPba9QnyMMcapt9wq7SmdnilbDrmuqRbmwDx+1CxJhiR9sKc
         qNqXnKfCnc7ZlYxmXhNWtNndKv6D6TB8OXK68QeVKBOP8lHmxgSDO+oefqvep0q+85nw
         snCfTIN4P2HwNjLG0b3Rr3irv0/83vpxpp6yyJE3B4W9MQT15hkxRtjF6BoBWaCYSQ/r
         /Eba/L8FJeCklnno+hRFfmD4rlEVoDlKktyEyOYZR+an6iOfk+/hCIw78jXqcp45ZSU9
         WqLA==
X-Gm-Message-State: AC+VfDyUn2ZVPBH7OzA/KTdFiwVSz3X+TXSXDq6b+6He9LqUu0KgkJEr
        e63AxpL5TId8EoTP+y6y9XJzy/apnasSSuB41/JF4oLt/PbSJC4aUlg0EdMAtFrx/zIc4fvHQmZ
        gzdA6mIMhC/6mbnYZlCZ6cGGcaKsTdbZKe2fjZlWqePDCw4nNwligVdlydDB0lPDea1HlIvKXlV
        dwpAw=
X-Received: by 2002:a05:6a00:148a:b0:63d:3981:313d with SMTP id v10-20020a056a00148a00b0063d3981313dmr8536275pfu.10.1686490825561;
        Sun, 11 Jun 2023 06:40:25 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5dMdGBO4Wsl80KHJIw4ZmDGa3Jk0n1+ZGiNoLCbMvMpbZ9usMosPf1DpINN7xV2zcRsBXtNQ==
X-Received: by 2002:a05:6a00:148a:b0:63d:3981:313d with SMTP id v10-20020a056a00148a00b0063d3981313dmr8536259pfu.10.1686490825204;
        Sun, 11 Jun 2023 06:40:25 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t14-20020a63444e000000b00528da88275bsm5793901pgk.47.2023.06.11.06.40.24
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jun 2023 06:40:24 -0700 (PDT)
Date:   Sun, 11 Jun 2023 21:40:21 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [Bug report] fstests generic/051 (on xfs) hang on latest linux
 v6.5-rc5+
Message-ID: <20230611134021.45suncq3sjrlmlfb@zlang-mailbox>
References: <20230611124836.whfktwaumnefm5z5@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230611124836.whfktwaumnefm5z5@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 11, 2023 at 08:48:36PM +0800, Zorro Lang wrote:
> Hi,
> 
> When I tried to do fstests regression test this weekend on latest linux
> v6.5-rc5+ (HEAD=64569520920a3ca5d456ddd9f4f95fc6ea9b8b45), nearly all
> testing jobs on xfs hang on generic/051 (more than 24 hours, still blocked).
> No matter 1k or 4k blocksize, general disk or pmem dev, or any architectures,
> or any mkfs/mount options testing, all hang there.
> 
> Someone console log as below (a bit long), the call trace doesn't contains any
> xfs functions, it might be not a xfs bug, but it can't be reproduced on ext4.

Overlayfs can reproduce this bug too, when it's based on xfs.

