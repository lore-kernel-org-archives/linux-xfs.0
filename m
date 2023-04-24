Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8B36C77B76
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Apr 2023 02:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbjDXCge (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Apr 2023 22:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbjDXCgd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Apr 2023 22:36:33 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C092211F
        for <linux-xfs@vger.kernel.org>; Sun, 23 Apr 2023 19:36:31 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-63b52ad6311so4963190b3a.2
        for <linux-xfs@vger.kernel.org>; Sun, 23 Apr 2023 19:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1682303790; x=1684895790;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Er9IodKAhu5Xy/24MmuM3ISnj8SFsqKhcDcV85YYtd4=;
        b=Myis4J2Z9lmx+G/UGHQV666UFM6OJ8EKtdAre2rvRUUjU2E+rQLKwJ+D0eYgmT72Z9
         5SaX6H/C77vylvdgFXO4tn7m7ArVvZvZSOxiW6NiLDX5h8w4cEfp1YoxEuHlyRXPz09e
         5JgUmEmUJwM1H8XEmuezqPmJ+lzP8zXU2UJcc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682303790; x=1684895790;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Er9IodKAhu5Xy/24MmuM3ISnj8SFsqKhcDcV85YYtd4=;
        b=DP4p/uyXJ1CAYvItq3beUoRE22FJubjacmfpxRzaS9WIGc6i2z1n5wGPH2rkHONEfx
         lZHvfjTMS37b5OWRCD49aEaLng54TSOYH6uufQzMinLv0dR9v7VBtd3HA/dxLN1XhyQb
         pE9Ls73rgvSmO3BKNe+J3le5qSP1+hlchs3TxUlXzExhLFN8U29hYygYET4pCY6/R8P1
         7p1w5W4Nrw0yRaOXrQ++bHgz6RjCZptKxyU3jPKR1bDHuQr9oacP79LS5m/AOTzzmrEb
         n+HcsmI9YNfBrBfuXKY9TRKzi3w0k7PIg2Mk9LUnc7Ks5twMn3+XR6Hvzx6+zBUK0y2j
         6iew==
X-Gm-Message-State: AAQBX9eZ9Y4/cU3dFU9CslQRrBV90pplhkoXABOiSQJbj7fUIP580dNd
        qxsZe3e04JmwjWKlMg1Xfe0cnw==
X-Google-Smtp-Source: AKy350a438RODTsIQbvbOZb4mhoGqhZ1pvzPivBPJ5Ra5hjJQnsR6/IRQqkIVQmM+kaUu2d3rd1IMA==
X-Received: by 2002:a05:6a00:2406:b0:63d:38aa:5617 with SMTP id z6-20020a056a00240600b0063d38aa5617mr12656579pfh.6.1682303790512;
        Sun, 23 Apr 2023 19:36:30 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id h8-20020aa786c8000000b0063b8279d3aasm6183422pfo.159.2023.04.23.19.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 19:36:29 -0700 (PDT)
Date:   Mon, 24 Apr 2023 11:36:23 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
        christoph.boehmwalder@linbit.com, hch@infradead.org,
        djwong@kernel.org, minchan@kernel.org, senozhatsky@chromium.org,
        patches@lists.linux.dev, linux-block@vger.kernel.org,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
        drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, hare@suse.de, p.raghav@samsung.com,
        da.gomez@samsung.com, kbusch@kernel.org
Subject: Re: [PATCH 5/5] zram: use generic PAGE_SECTORS and PAGE_SECTORS_SHIFT
Message-ID: <20230424023623.GC1496740@google.com>
References: <20230421195807.2804512-1-mcgrof@kernel.org>
 <20230421195807.2804512-6-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421195807.2804512-6-mcgrof@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On (23/04/21 12:58), Luis Chamberlain wrote:
> 
> Instead of re-defining the already existing constants use the provided ones:
> 
> So replace:
> 
>  o SECTORS_PER_PAGE_SHIFT with PAGE_SECTORS_SHIFT
>  o SECTORS_PER_PAGE       with PAGE_SECTORS
> 
> This produces no functional changes.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
