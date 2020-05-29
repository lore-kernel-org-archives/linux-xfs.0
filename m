Return-Path: <SRS0=/boU=7L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C99C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 29 May 2020 14:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5494320814
	for <linux-xfs@archiver.kernel.org>; Fri, 29 May 2020 14:13:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="eE5upXYz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgE2ONn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 May 2020 10:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbgE2ONj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 May 2020 10:13:39 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DF7C08C5CB
        for <linux-xfs@vger.kernel.org>; Fri, 29 May 2020 07:13:38 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id q24so1383662pjd.1
        for <linux-xfs@vger.kernel.org>; Fri, 29 May 2020 07:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sstDEw2eR7/x5s00uzGBoVK1nqE9b65b7cAMAqhOjao=;
        b=eE5upXYzk0pow1GTjkztlADM6NfVbrh/uHt+G1jl9EulITHptpOGivfgZ9UM2DZPeT
         QzDSBImSr62zvHA4fpZjPKoOgIad9kZyPX2Pg/8nuAQTJ3/2yu1dOc5WcOu99Kko/uk+
         JHHjcQeYVXofPi/9w67mwpp7taL/v8rnEtFjiUQt2+5HJT1HNIqLVfzk8C15zK0dRQDM
         HprQkgIl0QIfcdgkulZv6c2+BpjhhJc39zy3lRejrUhTw58N+xFCRBzYs65EUgEZZaQb
         C23jReqIIypb479CHVfyFfIhwVVplo1+96n+FWZRlsJS/ZWLbHO247w+VeMKyAtOGXp+
         Nwmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sstDEw2eR7/x5s00uzGBoVK1nqE9b65b7cAMAqhOjao=;
        b=QSNkA9oOP7blmVVOG/g5oeLOJeW5KOqCWMV1ze85jfuS4uv8jGMH/QsjsRmhOHMFwC
         nttYJx5VSQcncYgFbCYN5j3TPWY5gu82ez/4Y8lqsEWY+gu9MFQDlhZ7LZmE658rW4WX
         nWVQ8IDeX/7f/qTr6pFPPzQZoMH1NOs0s/07ewbqqlALn6l82c7UDDGLKGuTJvTQPP6k
         fszBRGy5UPJ/n5k8oylZn/PB/3YoJwFr6Uw90nDtappBgk8QPBeJE0l9LpD22DWBR7Ej
         BW2nsXWvkNCA0eMCV/xG6qGECWGhoW2Z7WTwS7Vm0kJVL1j08UcJrOfBfHuldpRjwI/c
         M2MA==
X-Gm-Message-State: AOAM5307qVM+RNQ19NUzggorhRl7UwIxmN4d+pIfYPhnP+FrOn4xYngL
        WTTWDNuz80HdfVnJIq//YbJlYA==
X-Google-Smtp-Source: ABdhPJx/vZKTQwjkEYDfjCmjXR8SsS9x7O54I1G0OhUxjA27obWAm6HjQIWQQc+C6Ua+WQEtGiJQ1Q==
X-Received: by 2002:a17:90a:bf18:: with SMTP id c24mr9827989pjs.171.1590761617982;
        Fri, 29 May 2020 07:13:37 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d2sm6688603pgp.56.2020.05.29.07.13.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 07:13:37 -0700 (PDT)
Subject: Re: [PATCH v2] blkdev: Replace blksize_bits() with ilog2()
To:     Kaitao Cheng <pilgrimtao@gmail.com>, hch@lst.de, sth@linux.ibm.com,
        viro@zeniv.linux.org.uk, clm@fb.com, jaegeuk@kernel.org,
        hch@infradead.org, mark@fasheh.com, dhowells@redhat.com,
        balbi@kernel.org
Cc:     damien.lemoal@wdc.com, bvanassche@acm.org, ming.lei@redhat.com,
        martin.petersen@oracle.com, satyat@google.com,
        chaitanya.kulkarni@wdc.com, houtao1@huawei.com,
        asml.silence@gmail.com, ajay.joshi@wdc.com,
        linux-kernel@vger.kernel.org, songmuchun@bytedance.com,
        hoeppner@linux.ibm.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, sagi@grimberg.me,
        linux-nvme@lists.infradead.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, chao@kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        ocfs2-devel@oss.oracle.com, deepa.kernel@gmail.com
References: <20200529141100.37519-1-pilgrimtao@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c8412d98-0328-0976-e5f9-5beddc148a35@kernel.dk>
Date:   Fri, 29 May 2020 08:13:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200529141100.37519-1-pilgrimtao@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/29/20 8:11 AM, Kaitao Cheng wrote:
> There is a function named ilog2() exist which can replace blksize.
> The generated code will be shorter and more efficient on some
> architecture, such as arm64. And ilog2() can be optimized according
> to different architecture.

When you posted this last time, I said:

"I like the simplification, but do you have any results to back up
 that claim? Is the generated code shorter? Runs faster?"

which you handily ignored, yet sending out a new version. I'm not
going to apply this without justification, your commit message is
handwavy at best.

-- 
Jens Axboe

