Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09330C0015E
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Jul 2023 21:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjGZVut (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Jul 2023 17:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjGZVut (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jul 2023 17:50:49 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F5D127
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jul 2023 14:50:47 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1b89cfb4571so2136305ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jul 2023 14:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1690408247; x=1691013047;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oEVsgMhfJCo3+WMo9jBocLy7Yo6Kj93DjounOZpsoZ8=;
        b=JImPWHdVbo7ZJgolrQI/m8aHyPEXt0Of30eNRqZAa8bdH+gsYimY42WGx7XcoqTiz/
         wW9Ik+WwYLvLnD5860DeZxolVzNv1e8r5hy2PB9G8Or8v39vUOHg1xG0x5ibSBxqwSQm
         MiPuxdFBcYromSZ0J+88yBmN6GQLzO1vBRM/PirC6Mu8N0CtTbAWlmODJ2ZayZ3mbWU+
         W36vZpVaHKxdb3Qi0jq6FJZClLAUPYMkyQp6u3q/GgBhucYRY01GL6ai7O9VP/RSax8Q
         kvBabVIWwmi62NhNBFWp4mKro1HRN/z1hYz2Kgj5+p504uztWFPMUlFllQke6DUBeF2J
         Cn8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690408247; x=1691013047;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oEVsgMhfJCo3+WMo9jBocLy7Yo6Kj93DjounOZpsoZ8=;
        b=dhVoq0ylrKhmOeyW7f9pJ9gMM8fE1N+6lFT5xCEYuUPVJ7MudnpyeioN5YvXvRpupf
         ycZgfcMqOekwCRxpM5nAIj/vwlCdHF+0yEOPUmsuVURoDdC5eFXOfJCOZXwTX3F1fZhS
         +2Ye24ofse5WKK0ZXk9aS+H84g66YtSAA7FHPKupY5s30oHbPtndg5sdOxxxATNYi7CA
         KGoqiZTdUWnzd5PFzA9efY3tYEncyJboaTcMqYURihdQJPqHj/BQDGe0SzqE0NPPp0cI
         PlXFqUi0/nw+1Z8l5+OCbol2YM7RyODeu+hagbCYGxa0XDx8uXTczcBcv5iW79tNHq4p
         f9Vg==
X-Gm-Message-State: ABy/qLYXUPFZPh8zxduDG0iSZXWFQSeoWB1HYPqIjbZe1UTpZdDQyJKc
        Vtl+fGpPbyazQHi8AVMGKaeNrA==
X-Google-Smtp-Source: APBJJlEYMi5IrHUY78a1kRiay85JTqoZqaM8MkfAimsJL8TH5HyPPxcjiUtXy1E0Yotpel0Ii7ehpA==
X-Received: by 2002:a17:902:f80a:b0:1bb:d048:3173 with SMTP id ix10-20020a170902f80a00b001bbd0483173mr1929140plb.61.1690408246973;
        Wed, 26 Jul 2023 14:50:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au. [49.186.119.116])
        by smtp.gmail.com with ESMTPSA id jj6-20020a170903048600b001ab39cd875csm25252plb.133.2023.07.26.14.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 14:50:46 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qOmP5-00AuAE-0V;
        Thu, 27 Jul 2023 07:50:43 +1000
Date:   Thu, 27 Jul 2023 07:50:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 1/7] iomap: merge iomap_seek_hole() and iomap_seek_data()
Message-ID: <ZMGVM/BdgsjMSsIF@dread.disaster.area>
References: <20230726102603.155522-1-hao.xu@linux.dev>
 <20230726102603.155522-2-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230726102603.155522-2-hao.xu@linux.dev>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 26, 2023 at 06:25:57PM +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> The two functions share almost same code, merge them together.
> No functional change in this patch.

No, please don't. seek data and seek hole have subtly different
semantics and return values, and we've explicitly kept them separate
because it's much easier to maintain them as separate functions with
separate semantics than combine them into a single function with
lots of non-obvious conditional behaviour.

The fact that the new iomap_seek() API requires a boolean "SEEK_DATA
or SEEK_HOLE" field to indicate that the caller wants makes it clear
that this isn't actually an improvement over explicit
iomap_seek_data() and iomap_seek_hole() API calls.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
