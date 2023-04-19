Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E977C77B75
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Apr 2023 01:28:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbjDSB2b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Apr 2023 21:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbjDSB2a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Apr 2023 21:28:30 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5877ED7
        for <linux-xfs@vger.kernel.org>; Tue, 18 Apr 2023 18:28:29 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 41be03b00d2f7-51b914ffe71so245425a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 18 Apr 2023 18:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681867708; x=1684459708;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fORvDtycGEYAP00Go8Gr75NbmrQRJi6legeNyHFvVc4=;
        b=LrmAEIyGSJiRmmpboUhhQgqPcY35ao1RN/OmUVmJ2+dtZKoCNZbb8NLxueipM+G5cL
         7Z8Nwal6Jz63ieQNUvv003Q/cAVuE98OeSDB3Ay0Doy0h7oKAWn5SO9oU40wJCf0tbCQ
         BQ42zZnn0Cg/VQDTeWslhL7Wd8s61avskpFcinz3IKJk+gNlExkijnMyMDYHJlhUHd5M
         8IVAzrRyL0O2Bazz7z+f5qoE6nxJXJFFSe3jLE/4Y/nctAfi6fljhWgSEFtC2xGzhK5C
         mIW0MC0YJkbwEU94y4kb1t2bC6NCGfVeKEG9Yso2dAk27EpJOXvZk/aks8gm/9xAtK5z
         hsig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681867708; x=1684459708;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fORvDtycGEYAP00Go8Gr75NbmrQRJi6legeNyHFvVc4=;
        b=hDskf8G2KhCx6UIyZe5OOH9cgcjvmBzaWdiptmeeA4woIg5NCjPJAzt6KiEYEHMLgj
         2BKGLr1Go3qFAnf5eezucoaaOGrMUXJauu8a9pCaO7hW1Ly9DByfnhCk9srZKShRV95R
         4lGv0EnHSV38gsKG9nxiP15NzBwHSDNk5IEJgiNpUCxrq/WVswGZFaqgNXHFBPxXwdNd
         Pls5QU4loTvEj1gXeK+kRuFVW/8TFRa7c5eE/d0qIQtZ6hHcteSOeiReWImisBXJF+HX
         DtCZ1MFwg0zD4JiiHqsF909uBeT+STqbF2Z0iiWcQgnBEjgIYFLvBJjd764T3b44c0eq
         s6NA==
X-Gm-Message-State: AAQBX9dRe0Sq+egU5r2t2ajr1l5taOJB9cikPKHG1dfA8j+PmFr9iVOJ
        3frNc0FBJDI3piDhkf1MxoCa3w==
X-Google-Smtp-Source: AKy350ZW2i/ZFxByFt235VEJD3loFwfTTKFlgazg6SB7eTiGwpib5QWAwouBg+e5G+DCGghYaT9aug==
X-Received: by 2002:a17:902:dad1:b0:1a1:956d:2281 with SMTP id q17-20020a170902dad100b001a1956d2281mr19890233plx.3.1681867708384;
        Tue, 18 Apr 2023 18:28:28 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x24-20020a1709027c1800b001a50ede5086sm10206660pll.51.2023.04.18.18.28.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 18:28:28 -0700 (PDT)
Message-ID: <b09e799e-9d9f-ae22-1f09-babd6521b11d@kernel.dk>
Date:   Tue, 18 Apr 2023 19:28:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 1/2] fs: add FMODE_DIO_PARALLEL_WRITE flag
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>,
        Bernd Schubert <bschubert@ddn.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Dharmendra Singh <dsingh@ddn.com>
References: <20230307172015.54911-2-axboe@kernel.dk>
 <20230412134057.381941-1-bschubert@ddn.com>
 <CAJfpegt_ZCVodOhQCzF9OqKnCr65mKax0Gu4OTN8M51zP+8TcA@mail.gmail.com>
 <ZDjggMCGautPUDpW@infradead.org> <20230414153612.GB360881@frogsfrogsfrogs>
 <cfeade24-81fc-ab73-1fd9-89f12a402486@kernel.dk>
 <CAJfpegvv-SPJRjWrR_+JY-H=xmYq0pnTfAtj-N8kG7AnQvWd=w@mail.gmail.com>
 <e4855cfa-3683-f12c-e865-6e5c4d0e5602@ddn.com>
 <20230418221300.GT3223426@dread.disaster.area>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230418221300.GT3223426@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 4/18/23 4:13?PM, Dave Chinner wrote:
>>> Without first attempting to answer those questions, I'd be reluctant
>>> to add  FMODE_DIO_PARALLEL_WRITE to fuse.
> 
> I'd tag it with this anyway - for the majority of apps that are
> doing concurrent DIO within EOF, shared locking is big win. If
> there's a corner case that apps trigger that is slow, deal with them
> when they are reported....

Agree, the common/fast case will be fine, which is really the most
important part.

-- 
Jens Axboe

