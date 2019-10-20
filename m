Return-Path: <SRS0=FSF3=YN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,STOX_REPLY_TYPE,STOX_REPLY_TYPE_WITHOUT_QUOTES autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2A86CA9EA0
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Oct 2019 14:55:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6939621928
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Oct 2019 14:55:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zadara-com.20150623.gappssmtp.com header.i=@zadara-com.20150623.gappssmtp.com header.b="Uz2Uzeoq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbfJTOzC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 20 Oct 2019 10:55:02 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:52938 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfJTOzC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 Oct 2019 10:55:02 -0400
Received: by mail-wm1-f41.google.com with SMTP id r19so10572431wmh.2
        for <linux-xfs@vger.kernel.org>; Sun, 20 Oct 2019 07:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadara-com.20150623.gappssmtp.com; s=20150623;
        h=message-id:from:to:cc:subject:date:mime-version
         :content-transfer-encoding:importance;
        bh=r1rQHnnNUYq5ZY7ChFC24yc06aLwb2+HTTmYX7vCqy0=;
        b=Uz2UzeoqtGDLbDnm3GPxAzm9cBlQan0/ftny2azoAVfkac6wpNGpLgn30gxz9MNKj4
         J49YIEbISmxWQtfFzZKKQquvtWsLnyPwothcmbPzbGjgY9mNw0cSXNFyeaaQtN+ZLwEj
         ReLiQYC2mQJXPCdfxAbN3JZuEY7OXU/4O8lRNu5Mp+TR1wYtpobm6+Eek1czyrjiJrXD
         53hrf2P0/4I103l3RyGvLs7sMiR25CShBwCbivsECnmoLUbMecgHrqkGRVFEoqPJ0iPZ
         QSPEDihHQDygnwpOf9qe5/9A9PpMRl6ATZmY1Co5VolkAClHh4gC/5k1RTwkFqSEWuYv
         EqrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:from:to:cc:subject:date:mime-version
         :content-transfer-encoding:importance;
        bh=r1rQHnnNUYq5ZY7ChFC24yc06aLwb2+HTTmYX7vCqy0=;
        b=Fb680nNhH5govPTCFramt0fDAFCzC+UJKRqCiD8JZv1eCbaBzBGBAUC1b6tyiWt8Vd
         v+bru7VWHdPC/eU6MJS+VVtFAYoEzyH61KyoX5qZD8pH0pbMyg6q8k1Jrilmig+BwIjD
         iP1Fhp0aDHKYA60whCAvwJv/dQu7Deg3YLXUpdLyWbqkqMTHfcLMbB8MGCvQavXwhggv
         wozESbearzQozqv8YObheWCcjq2SkryoXecNIEzgbf132yqUbEcd2xueNeDEYbj1xWAQ
         l6ra5kzsOXmpBkZn+zH4rNcJsoZcR50r3g7TmBnS++JEMptimuljHBEY/ndpp87B+AIA
         B0Qg==
X-Gm-Message-State: APjAAAVjseXslJxWEpvzpCllW6ZirpxFv4+7v8lUqu4BkU07wF7HyBZF
        nM5bUnNEkZ9Djf6u1Mox55EiLw==
X-Google-Smtp-Source: APXvYqwRIk7RjK7D8bX7BSFruYhFgnl/tiCVCjg3z6yoQi8OUYlpwi0VMO/cOvHsGM2RC+dZABZPYQ==
X-Received: by 2002:a1c:b4c1:: with SMTP id d184mr14459022wmf.37.1571583300310;
        Sun, 20 Oct 2019 07:55:00 -0700 (PDT)
Received: from alyakaslap ([82.166.81.77])
        by smtp.gmail.com with ESMTPSA id j22sm8620663wrd.41.2019.10.20.07.54.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Oct 2019 07:54:59 -0700 (PDT)
Message-ID: <CC133B1B9D9B46AFAB2D35A366BF7DC4@alyakaslap>
From:   "Alex Lyakas" <alex@zadara.com>
To:     <vbendel@redhat.com>, <bfoster@redhat.com>
Cc:     <linux-xfs@vger.kernel.org>
Subject: xfs_buftarg_isolate(): "Correctly invert xfs_buftarg LRU isolation logic"
Date:   Sun, 20 Oct 2019 17:54:03 +0300
MIME-Version: 1.0
Content-Type: text/plain;
        format=flowed;
        charset="iso-8859-1";
        reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 16.4.3528.331
X-MimeOLE: Produced By Microsoft MimeOLE V16.4.3528.331
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello Vratislav, Brian,

This is with regards to commit "xfs: Correctly invert xfs_buftarg LRU 
isolation logic" [1].

I am hitting this issue in kernel 4.14. However, after some debugging, I do 
not fully agree with the commit message, describing the effect of this 
defect.

In case b_lru_ref > 1, then indeed this xfs_buf will be taken off the LRU 
list, and immediately added back to it, with b_lru_ref being lesser by 1 
now.

In case b_lru_ref==1, then this xfs_buf will be similarly isolated (due to a 
bug), and xfs_buf_rele() will be called on it. But now its b_lru_ref==0. In 
this case, xfs_buf_rele() will free the buffer, rather than re-adding it 
back to the LRU. This is a problem, because we intended for this buffer to 
have another trip on the LRU. Only when b_lru_ref==0 upon entry to 
xfs_buftarg_isolate(), we want to free the buffer. So we are freeing the 
buffer one trip too early in this case.

In case b_lru_ref==0 (somehow), then due to a bug, this xfs_buf will not be 
removed off the LRU. It will remain sitting in the LRU with b_lru_ref==0. On 
next shrinker call, this xfs_buff will also remain on the LRU, due to the 
same bug. So this xfs_buf will be freed only on unmount or if 
xfs_buf_stale() is called on it.

Do you agree with the above?

If so, I think this fix should be backported to stable kernels.

Thanks,
Alex.

[1]
commit 19957a181608d25c8f4136652d0ea00b3738972d
Author: Vratislav Bendel <vbendel@redhat.com>
Date:   Tue Mar 6 17:07:44 2018 -0800

    xfs: Correctly invert xfs_buftarg LRU isolation logic

    Due to an inverted logic mistake in xfs_buftarg_isolate()
    the xfs_buffers with zero b_lru_ref will take another trip
    around LRU, while isolating buffers with non-zero b_lru_ref.

    Additionally those isolated buffers end up right back on the LRU
    once they are released, because b_lru_ref remains elevated.

    Fix that circuitous route by leaving them on the LRU
    as originally intended.

    Signed-off-by: Vratislav Bendel <vbendel@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
    Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com> 

