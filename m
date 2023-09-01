Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36209CA0FE1
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Sep 2023 03:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237089AbjIADrU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Aug 2023 23:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjIADrT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2023 23:47:19 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F032B18C
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2023 20:47:16 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-68a42d06d02so1282492b3a.0
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2023 20:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1693540036; x=1694144836; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hpOIrXuRQYZxXMqWsb/iUpa9YdxidIVeVU0Ee0w2W+k=;
        b=PgMxHOvqJb/qwOSkCEihpQGhDBzlhpBs8xYA52AVgp4edYwoL41stu0rsUWx1DQUBk
         /1xPSOT7fxioSEJRORRe6sl7ly1DkywhEG9mvy1FbbxNjwgm78qRq7GhFj0qCrON/UuP
         ERz00kS7WSHpkIg+3ReSJtrbFV4ThSGtnQ7jVNLnASoF+4YSknQL6wD1IKJ/JgthlUwS
         MJc8Fu3+HZarDoYxZdy8FuoShv0CAi7rbNkUT8ZAIfl5xcib8OcOZ7zV2VFV+bozIDkk
         eYSYmxbp8Rr5oZrLEP6Ssr9gAmb269oeORhgCnrmg21zc4hd3o92LxCp9beIfB0Pq5TL
         MyXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693540036; x=1694144836;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hpOIrXuRQYZxXMqWsb/iUpa9YdxidIVeVU0Ee0w2W+k=;
        b=b4NmRDtlnITX9txRAsANy989XnpxU98VhHTGQ/KAHYGesmuYRCb5hpMQyu9a+R9H0T
         jzKaII5OYc3JiKQkkf5QiO7+rRFgXNs60fAQGEQrfKNd9O+HARDZ+5G+mOfEBUD/M+IU
         o9h/KK7z9VgjaPrODA/KnRJN3CKRIvCQYkz4ZaPj0GKUeuwRFzNDpK+F9K3wOMiKLfFC
         RyfUqwgUCjZ1vuStOi8c8vB7ePIO0iSWOtQ2VYBDs6EMkRA41vx97bUhKSUleNdJkGUK
         ZJVtKjlnpiqkBIZerM1o6bcz8PC3QC1RUKqrjREu/g4XLcaFamyaKGtntfxcHNAEAKGd
         YkQg==
X-Gm-Message-State: AOJu0YyYWPIDQ1tKoDYzB58FRe+uRd9CX60PzPmpXfd8vU894Wi0mtmr
        1OG72eUUcsTeMkx4iP5MCTmVklmFq8AGH/+KSzc=
X-Google-Smtp-Source: AGHT+IGVuEUS2psVpEs++pUy7C+rz9yGudH5H2zh99cHIE+R9bC1iISy6TNkqpwLq9OdphhGU/44dQ==
X-Received: by 2002:a05:6a00:1952:b0:68a:4261:ab7f with SMTP id s18-20020a056a00195200b0068a4261ab7fmr1745289pfk.31.1693540036477;
        Thu, 31 Aug 2023 20:47:16 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id c17-20020aa78811000000b006884549adc8sm1979862pfo.29.2023.08.31.20.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Aug 2023 20:47:15 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qbv7o-009Egh-3C;
        Fri, 01 Sep 2023 13:47:13 +1000
Date:   Fri, 1 Sep 2023 13:47:12 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Shawn <neutronsharc@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Do I have to fsync after aio_write finishes (with fallocate
 preallocation) ?
Message-ID: <ZPFewPuuv78ZUaxo@dread.disaster.area>
References: <CAB-bdyQVJdTcaaDLWmm+rsW_U6FLF3qCTqLEKLkM6hOgk09uZQ@mail.gmail.com>
 <20221129213436.GG3600936@dread.disaster.area>
 <CAB-bdyQw7hRpRPn9JTnpyJt1sA9vPDTVsUTmrhke-EMmGfaHBA@mail.gmail.com>
 <ZOl2IHacyqSUFgfi@dread.disaster.area>
 <CAB-bdyRTKNQeukwjuB=fCT91BDO5uTJzA_Y7msOdEPBDAURbzg@mail.gmail.com>
 <ZOvx2Xg31EbJXPgr@dread.disaster.area>
 <CAB-bdyQG0gDBJDt5cHHsi7avUazDtL5RO8G6UwQZj5Rw7k-CXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB-bdyQG0gDBJDt5cHHsi7avUazDtL5RO8G6UwQZj5Rw7k-CXQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 31, 2023 at 06:06:23PM -0700, Shawn wrote:
> Hi Dave,
> If ext size hint is not set at all,  what's the default extent size
> alignment if the FS doesn't do striping (which is my case)?

No alignment. XFS will allocate exact sized extents for the
writes being issued...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
