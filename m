Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0DB7C6FD1D
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Mar 2023 00:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbjCRAr0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 20:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCRArZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 20:47:25 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282FC591E0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 17:47:25 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id p3-20020a17090a74c300b0023f69bc7a68so2529373pjl.4
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 17:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1679100444;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZCdRonvarZ4/izkZ6g3tPA0G9wzPNuz5GM0cFWXAnPE=;
        b=t8YA6gl82Qb3M0qpsa9W5cmO2lGLfRwiiY/BQhjG3XzEm/UX1iNyuclYksTST6SC3I
         Sbb7PbBbSMMkGyaVX/rylvVvUi+IwYo4TmULFXqKPUw/m7vawGrVQL7Ivjpyf7ADZXKM
         y1C9dI49Z+E/Wxl8+tkg7j02LF2300u0MaVYonpBJ4yIvhbOTqz+RltPo2n8N2HWVofm
         WgsjZdbLGU78snOceg5/WoYGPaHBomQMR5/giNRj/E6Texyb/5erCgZonhMNb4wT+dL5
         GkY9C09XHKJWT5p1DQ19Dre9FNY+MguoSLbd1hHzEj8L767chv9mFTFrSRhGNI3DgnRI
         r2jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679100444;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZCdRonvarZ4/izkZ6g3tPA0G9wzPNuz5GM0cFWXAnPE=;
        b=G1Sk3WebBkW8gRP3dyqutLGC9+OKSJczpg46achSO1ac4TH1H397pM0WWFw3hiceKQ
         Ujsa9hrJPoyFg+cJSOp95L5V35F1h5ftp6UVa2Pz+8ZxI98gnArbqZbz6q3qQIz+DqLQ
         AJJOwMf+5IEnF2esmJb+s5VKi7ClHQGSVuJ58q/lCa7L4xm3abCNWEDzXABxzv5Z2mP9
         aVqYFxmDb/bvPW+RuxYoKFcJzKyEzE+KJnNsDDKFag+QYJNlAFEAdRQb2mt3T4SxV3D3
         2YY+Bsy1JPYMs0Gium2vBt1rsHd9WN3vcNqDRjZbjwNr3o5Azpor4KqdfADG7U8sILU0
         6yTA==
X-Gm-Message-State: AO0yUKVLX695RbMy3m310evKYhdwAgq+Qinh60RvZFTXAjW7PvafHEEM
        NtoLKaH0c9wSeUEtipkVuRY8cg==
X-Google-Smtp-Source: AK7set+gg5hC3bVuzKy87tRmY1VsaKtkG5A+aCgUsGUtD04zYFCvtkP0OLdRGVsitdCfKfOHXOOQDQ==
X-Received: by 2002:a17:90b:1b4e:b0:23f:7770:9e75 with SMTP id nv14-20020a17090b1b4e00b0023f77709e75mr893268pjb.47.1679100444652;
        Fri, 17 Mar 2023 17:47:24 -0700 (PDT)
Received: from destitution (pa49-196-94-140.pa.vic.optusnet.com.au. [49.196.94.140])
        by smtp.gmail.com with ESMTPSA id gt17-20020a17090af2d100b0023f355a0bb5sm2005373pjb.14.2023.03.17.17.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 17:47:24 -0700 (PDT)
Received: from dave by destitution with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1pdKiv-000JL6-30;
        Sat, 18 Mar 2023 11:47:05 +1100
Date:   Sat, 18 Mar 2023 11:47:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] libfrog: move crc32c selftest buffer into a separate
 file
Message-ID: <ZBUKCRR7xvIqPrpX@destitution>
References: <20230316165101.GN11376@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316165101.GN11376@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 16, 2023 at 09:51:01AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Move the random buffer used for selftests into a separate file so that
> we can link to it from multiple places.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  libfrog/Makefile         |    6 -
>  libfrog/crc32cselftest.h |  526 +---------------------------------------------
>  libfrog/randbytes.c      |  527 ++++++++++++++++++++++++++++++++++++++++++++++
>  libfrog/randbytes.h      |   11 +
>  4 files changed, 548 insertions(+), 522 deletions(-)
>  create mode 100644 libfrog/randbytes.c
>  create mode 100644 libfrog/randbytes.h

looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
